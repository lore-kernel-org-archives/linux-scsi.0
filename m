From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH RESEND 03/11] bnx2fc: Support 'sequence cleanup'
 task
Date: Wed, 27 Jul 2011 11:13:17 -0700
Message-ID: <4E30553D.8080403@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
 <1311717109-14077-4-git-send-email-bprakash@broadcom.com>
 <1311766857.5029.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2155 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1G0SNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 14:13:43 -0400
In-Reply-To: <1311766857.5029.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 7/27/2011 4:40 AM, James Bottomley wrote:
> On Tue, 2011-07-26 at 14:51 -0700, Bhanu Prakash Gollapudi wrote:
>> For the devices that support sequence level error recovery, based on=
 the REC
>> response, the firmware has to be informed about the offset from whic=
h the
>> retransmission should happen. Driver initiates sequence cleanup task=
 to
>> firmware so that the firmware can program the task. Upon the sequenc=
e cleanup
>> completion, SRR is issued to retransmit the sequence.
>>
>> Signed-off-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
>> ---
>>   drivers/scsi/bnx2fc/bnx2fc.h     |   10 ++++
>>   drivers/scsi/bnx2fc/bnx2fc_hwi.c |   97 ++++++++++++++++++++++++++=
++++++++
>>   drivers/scsi/bnx2fc/bnx2fc_io.c  |  106 ++++++++++++++++++++++++++=
++++++++++++
>>   3 files changed, 213 insertions(+), 0 deletions(-)
>
> Well, I got another two patches include, but this one doesn't compile=
:
>
>    CC [M]  drivers/scsi/bnx2fc/bnx2fc_io.o
> drivers/scsi/bnx2fc/bnx2fc_io.c: In function
> =91bnx2fc_initiate_seq_cleanup=92:
> drivers/scsi/bnx2fc/bnx2fc_io.c:987:8: error: =91struct bnx2fc_els_cb=
_arg=92
> has no member named =91r_ctl=92
> drivers/scsi/bnx2fc/bnx2fc_io.c:988:8: error: =91struct bnx2fc_els_cb=
_arg=92
> has no member named =91offset=92
> drivers/scsi/bnx2fc/bnx2fc_io.c: In function
> =91bnx2fc_process_seq_cleanup_compl=92:
> drivers/scsi/bnx2fc/bnx2fc_io.c:1235:21: error: =91struct
> bnx2fc_els_cb_arg=92 has no member named =91offset=92
> drivers/scsi/bnx2fc/bnx2fc_io.c:1236:29: error: =91struct
> bnx2fc_els_cb_arg=92 has no member named =91r_ctl=92
> drivers/scsi/bnx2fc/bnx2fc_io.c:1252:2: error: implicit declaration o=
f
> function =91bnx2fc_send_srr=92
> make[1]: *** [drivers/scsi/bnx2fc/bnx2fc_io.o] Error 1
> make: *** [drivers/scsi/bnx2fc/bnx2fc.ko] Error 2
>
> I assume it has to be combined with one of the other patches to make =
a
> bisectable unit?

Sorry for the inconvenience, James. Intention was to have bisectable=20
units. I'll correct it and resubmit shortly.

>
> James
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
