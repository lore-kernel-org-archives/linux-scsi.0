From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 07 Sep 2010 17:20:32 +0400
Message-ID: <4C863C20.2080004@vlnb.net>
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org>	<4C7FFD1A.8090509@vlnb.net>	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>	<20100905201802.GC18411@core.coreip.homeip.net>	<1283723447.556.133.camel@haakon2.linux-iscsi.org>	<20100905234134.GA17212@core.coreip.homeip.net>	<1283731194.556.147.camel@haakon2.linux-iscsi.org>	<1283769578.15944.1293.camel@mulgrave.site>	<4C85617E.2080603@vlnb.net>	<1283810135.556.238.camel@haakon2.linux-iscsi.org>	<20100907004424.GB21430@core.coreip.homeip.net>	<AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>	<4C85DBC9.6030601@suse.de> <AANLkTi=zS=zTFZ-93vdMwPo1wcRsoLL9fnm5rxNT+4WH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab0IGNUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 09:20:42 -0400
In-Reply-To: <AANLkTi=zS=zTFZ-93vdMwPo1wcRsoLL9fnm5rxNT+4WH@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

Bart Van Assche, on 09/07/2010 10:45 AM wrote:
> On Tue, Sep 7, 2010 at 8:29 AM, Hannes Reinecke<hare@suse.de>  wrote:
>>
>> Bart Van Assche wrote:
>> [ ... ]
>>> You seem to have missed the start of this thread. The design of SCST
>>> is significantly more advanced than that of LIO, and it has already
>>> been explained in this thread why
>>> (http://www.spinics.net/lists/linux-scsi/msg45856.html).
>>>
>> Hmm. That link seems to be misrouted. I was hoping for a design
>> overview of SCST there; however it's just a complain to
>> James Bottomley etc.
>>
>> Care to send the correct link?
>
> An SCST design overview diagram together with SCST API documentation
> can be found here: http://scst.sourceforge.net/scst_pg.html (sorry for
> the language imperfections on this page, which should not affect
> readability though).

For iSCSI-like transports, which support immediate/unsolicited data, 
additional description of the processing flow is here.

In short, in this flow target drivers called by the SCST core 
(preprocessing_done() callback) after preprocessing of this command 
finished and the command has allocated buffer, so now the driver can 
continue processing of the command and transfer in its buffer 
immediate/unsolicited data, if there are any.

In details it is as the following:

After iSCSI-SCST received new command in scsi_cmnd_start() it calls 
scst_rx_cmd() to create scst_cmd then after it initialized necessary 
fields in it (CDB, task attribute, expected data direction, etc.) it 
calls scst_cmd_init_stage1_done() to notify SCST that scst_cmd 
initialization finished and its processing can be started. Then SCST 
parses SCSI CDB to determines data transfer length and direction (this 
is necessary to prevent various DoS'es from remote initiators like 
sending a command with wrong data direction; try this in the 
pass-through case and you will see what happens) and allocates necessary 
data buffer. From this point the following 2 scenarios are possible:

1. Regular path, when SCST does all the processing directly as simple 
function calls. SCST in the end of processing calls 
iscsi_preprocessing_done() callback, which sets scst_state and returns. 
Following the call stack the execution flow will return to 
scsi_cmnd_start() and continue there.

2. During processing SCST has to change context (switch to another 
thread). It can be necessary, e.g., to handle some management activity. 
Here everything is the same as in (1) above, but after 
scst_cmd_init_stage1_done() returned scsi_cmnd_start() returns 1 and 
further processing of this connection is suspended. Then 
iscsi_preprocessing_done() will resume it. Then process_read_io() will 
call cmnd_rx_continue().

Then iSCSI-SCST will do necessary checks and if all correct:

   - For READ commands and commands without data transfers, calls in 
iscsi_restart_cmnd() scst_restart_cmd() to tell SCST to start command's 
execution.

   - Fro WRITE commands it receives immediate data, sends the necessary 
R2T PDUs (send_r2t()), receives data for them and then calls 
scst_restart_cmd().

Then, after the command is finished, SCST returns to iSCSI-SCST status 
of the command's execution in iscsi_xmit_response() callback, which 
using send_data_rsp() makes the necessary Data-In PDUs and then either 
directly sends them using iscsi_try_local_processing()->iscsi_send() (to 
minimize latency) or passes to the write thread.

Other internal SCST processing is as shown on the "The commands 
processing flow" in http://scst.sourceforge.net/scst_pg.html.

Thanks,
Vlad
