From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] blk_abort_queue on failed paths?
Date: Thu, 4 Jun 2009 10:18:17 -0700
Message-ID: <20090604171817.GA6995@linux.vnet.ibm.com>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com> <4A26ED7D.1010203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:48882 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZFDRSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 13:18:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n54HFfsG013544
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 11:15:41 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n54HIOra226402
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 11:18:24 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n54HILx1000627
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 11:18:24 -0600
Content-Disposition: inline
In-Reply-To: <4A26ED7D.1010203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie <michaelc@cs.wisc.edu> wrote:
> adding linux-scsi and Mike Anderson
>
> David Strand wrote:
>> After updating to kernel 2.6.28 I found that when I performed some
>> cable break testing during device i/o, I would get unwanted device or
>> host resets. Ultimately I traced it back to this patch:
>>
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2
>>
>> The call to blk_abort_queue causes the block layer to call
>> scsi_times_out for pending i/o, which can (or will) ultimately lead to
>> device, and/or bus and/or host resets, which of course cause all the
>> other devices significant disruption.
>>
>
> What driver were you using? I just did a work around for qla4xxx for  
> this (have not posted it yet). I added a scsi_times_out handler to the  
> driver so that if the IO was failed to a transport problem then the eh  
> does not run.
>
> FC drivers already use fc_timed_out, but I think that will not work. The  
> FC driver could fail the IO then call fc_remote_port_delete. So the  
> failed IO could hit dm-mpath.c and that could call into the  
> scsi_times_out (which for fc drivers call into fc_timed_out) but the  
> fc_remote_port_delete has not been done yet, so the port_state is still  
> online so that kicks off the scsi eh.
>

For HA link transport failure cases the waking of scsi_eh should not
matter. For tgt link transport failures the waking of scsi_eh is not good.
Previous test runs with added debug I only saw a few case of going into the
abort routines, but maybe my test configs where not complete (timing of
the workqueues running will alter the outcome also). I will look into this
more. The original described failure case of getting host resets is not
good though and would like to understand how we get this far.

> For transport errors I do not think blk_abort_queue is needed anymore -  
> at least for scsi drivers. For FC almost every driver supports the  
> terminate_rport_io call back (just mptfc does not), so you can set the  
> fast io fail tmo to make sure all IO is failed quickly. For iscsi, we  
> have the replacement/recovery_timeout. And for SAS, I think there is a  
> timeout or the device/target/port is deleted, right?
>
>

Yes. (I believe there is an end case that others have discussed in the past
that path checkers or other requests without the fast_fail flag set may
wait until devloss).

>> What was the reason for this change? I searched through my email from
>> this mailing list and could not find a discussion about it.
>
>
> It seems like it would only make sense to call blk_abort_queue for maybe  
> some block drivers (does cciss or dasd need it) or maybe for device  
> errors. But it seems to be broken for the common multipath use cases.

One usage is to handle the case of slow multipath failover where devices
are still responsive on the transport, but are not completing IOs. We can
see a very long delay depending on IO timeout value vs. queue depth of the
target.

If this failure case is perceived to be minor or causing side effects we
could restrict this behavior to a multipath.conf parameter. Another option
would be to refresh your old patch on getting extended result info
allowing deactivate path to only run under certain cases.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
