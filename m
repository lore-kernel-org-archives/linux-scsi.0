From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Mon, 9 May 2016 18:41:31 +0200
Message-ID: <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com> <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32822 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcEIQlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 12:41:51 -0400
Received: by mail-oi0-f52.google.com with SMTP id v145so216584540oie.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2016 09:41:51 -0700 (PDT)
In-Reply-To: <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Wed, May 4, 2016 at 7:02 PM, Jinpu Wang <jinpu.wang@profitbricks.com> wrote:
> On Mon, May 2, 2016 at 3:44 PM, James Bottomley <jejb@linux.vnet.ibm.com> wrote:
>> On Mon, 2016-05-02 at 12:05 +0200, Hannes Reinecke wrote:
>>> On 04/29/2016 02:49 PM, Jinpu Wang wrote:
>>> > Hi, all
>>> >
>>> > We hit IO error on fsync, it turns out was because sd treat
>>> > succeeded
>>> > SYNC as error. From what I checked in SBC spec there is no
>>> > indication
>>> > we should fail IO in this case, so we create this patch.
>>> >
>>> >
>>> > Best Regards,
>>> >
>>> > Jack Wang
>>> >
>>> > v2:
>>> > No change on patch itself, only resend in body as suggested by
>>> > Bart,
>>> > still keep the attachment in case mail client break the format.
>>> >
>>> > From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17 00:00:00
>>> > 2001
>>> > From: Jack Wang <jinpu.wang@profitbricks.com>
>>> > Date: Mon, 25 Apr 2016 12:05:22 +0200
>>> > Subject: [PATCH] sd: Don't treat succeeded SYNC as error
>>> >
>>> > We hit IO error in our production on multipath devices during
>>> > resize
>>> > device on target side, the problem turns out sd driver passes up as
>>> > IO
>>> > error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
>>> > Capacity data has changed, even storage side sync the data
>>> > properly.
>>> >
>>> > In order to fix this check in sd_done, report success if condition
>>> > matches.
>>> >
>>> > Sebastian Parschauer report/analyze the bug here:
>>> > https://sourceforge.net/p/scst/mailman/message/34953416/
>>> >
>>> > Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
>>> > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
>>> > ---
>>> >  drivers/scsi/sd.c | 13 +++++++++++++
>>> >  1 file changed, 13 insertions(+)
>>> >
>>> Well.
>>> Is there anything which guarantees us that 'capacity data has
>>> changed' will be the only sense code which we'll be seeing as a
>>> response to SYNCHRONIZE CACHE?
>>> I sincerely doubt so.
>>> So why don't you fall back to the default action (ie retry the
>>> command) whenever you hit an UNIT ATTENTION?
>>> This way we would cove any resulting sense code, _and_ would get rid
>>> of the rather ugly special case here.
>>
>> Actually, why are we getting here at all?  should we be eating this
>> unit attention once we've reported it in scsi_check_sense()?
>>
>> I also don't quite understand why the normal retry mechanism in
>> scsi_io_completion() (called after drv->done()) isn't handling this.
>>  We set retries on a flush command and we give sd_sync_cache three
>> goes.  Any one of those should also cause the CC/UA to be ignored.
>>
>> James
>>
>>
>
> Sorry for delay, I agree safer to retry this command.
> I checked the code path, in scsi_io_completion, we call
> __scsi_error_from_host_byte for FLUSH request,
> and we set error to EIO by default, somehow the code report error
> directly to user space without retry.
> [  647.206270] sd 1:0:0:0: [sdb] tag#0 Send: scmd 0xffff8800b6558480
> [  647.206422] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10) 35
> 00 00 00 00 00 00 00 00 00
> [  647.209748] sd 1:0:0:0: Capacity data has changed
> [  647.209896] sd 1:0:0:0: [sdb] tag#0 Done: SUCCESS Result:
> hostbyte=DID_OK driverbyte=DRIVER_OK
> [  647.210157] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10) 35
> 00 00 00 00 00 00 00 00 00
> [  647.210419] sd 1:0:0:0: [sdb] tag#0 Sense Key : Unit Attention [current]
> [  647.210567] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Capacity data has changed
> [  647.210741] sd 1:0:0:0: [sdb] tag#0 scsi host busy 1 failed 0
> [  647.210888] sd 1:0:0:0: Notifying upper driver of completion (result 8000002)
> [  647.211035] sd 1:0:0:0: [sdb] tag#0 sd_done: completed 0 of 0 bytes
> [  647.211182] sd 1:0:0:0: [sdb] tag#0 0 sectors total, 0 bytes done, error -5
> [  647.211330] blk_update_request: I/O error, dev sdb, sector 0
>
> Will figure out why retry doesn't work.
>
> Thanks James and Hannes for all your input.
>
> Regards,
> Jack

Hi James, Hannes and all,

I find out it's code below which report error directly back to user
space without any retry.
 913         /*
 914          * If we finished all bytes in the request we are done now.
 915          */
 916         if (!scsi_end_request(req, error, good_bytes, 0))
 917                 return;

But not sure, what's the best way to fix the behavior to let it retry,
 maybe add condition with sense key && asc && ascq direct go to
requeue before line 913?

Thanks
Jack
