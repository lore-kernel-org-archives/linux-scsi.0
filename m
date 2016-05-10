From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Tue, 10 May 2016 16:48:06 +0200
Message-ID: <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com>
 <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com> <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113d6bfc757eca05327e0404
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33465 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcEJOs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 10:48:26 -0400
Received: by mail-oi0-f51.google.com with SMTP id v145so19120644oie.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2016 07:48:26 -0700 (PDT)
In-Reply-To: <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

--001a113d6bfc757eca05327e0404
Content-Type: text/plain; charset=UTF-8

On Mon, May 9, 2016 at 6:41 PM, Jinpu Wang <jinpu.wang@profitbricks.com> wrote:
> On Wed, May 4, 2016 at 7:02 PM, Jinpu Wang <jinpu.wang@profitbricks.com> wrote:
>> On Mon, May 2, 2016 at 3:44 PM, James Bottomley <jejb@linux.vnet.ibm.com> wrote:
>>> On Mon, 2016-05-02 at 12:05 +0200, Hannes Reinecke wrote:
>>>> On 04/29/2016 02:49 PM, Jinpu Wang wrote:
>>>> > Hi, all
>>>> >
>>>> > We hit IO error on fsync, it turns out was because sd treat
>>>> > succeeded
>>>> > SYNC as error. From what I checked in SBC spec there is no
>>>> > indication
>>>> > we should fail IO in this case, so we create this patch.
>>>> >
>>>> >
>>>> > Best Regards,
>>>> >
>>>> > Jack Wang
>>>> >
>>>> > v2:
>>>> > No change on patch itself, only resend in body as suggested by
>>>> > Bart,
>>>> > still keep the attachment in case mail client break the format.
>>>> >
>>>> > From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17 00:00:00
>>>> > 2001
>>>> > From: Jack Wang <jinpu.wang@profitbricks.com>
>>>> > Date: Mon, 25 Apr 2016 12:05:22 +0200
>>>> > Subject: [PATCH] sd: Don't treat succeeded SYNC as error
>>>> >
>>>> > We hit IO error in our production on multipath devices during
>>>> > resize
>>>> > device on target side, the problem turns out sd driver passes up as
>>>> > IO
>>>> > error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
>>>> > Capacity data has changed, even storage side sync the data
>>>> > properly.
>>>> >
>>>> > In order to fix this check in sd_done, report success if condition
>>>> > matches.
>>>> >
>>>> > Sebastian Parschauer report/analyze the bug here:
>>>> > https://sourceforge.net/p/scst/mailman/message/34953416/
>>>> >
>>>> > Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
>>>> > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
>>>> > ---
>>>> >  drivers/scsi/sd.c | 13 +++++++++++++
>>>> >  1 file changed, 13 insertions(+)
>>>> >
>>>> Well.
>>>> Is there anything which guarantees us that 'capacity data has
>>>> changed' will be the only sense code which we'll be seeing as a
>>>> response to SYNCHRONIZE CACHE?
>>>> I sincerely doubt so.
>>>> So why don't you fall back to the default action (ie retry the
>>>> command) whenever you hit an UNIT ATTENTION?
>>>> This way we would cove any resulting sense code, _and_ would get rid
>>>> of the rather ugly special case here.
>>>
>>> Actually, why are we getting here at all?  should we be eating this
>>> unit attention once we've reported it in scsi_check_sense()?
>>>
>>> I also don't quite understand why the normal retry mechanism in
>>> scsi_io_completion() (called after drv->done()) isn't handling this.
>>>  We set retries on a flush command and we give sd_sync_cache three
>>> goes.  Any one of those should also cause the CC/UA to be ignored.
>>>
>>> James
>>>
>>>
>>
>> Sorry for delay, I agree safer to retry this command.
>> I checked the code path, in scsi_io_completion, we call
>> __scsi_error_from_host_byte for FLUSH request,
>> and we set error to EIO by default, somehow the code report error
>> directly to user space without retry.
>> [  647.206270] sd 1:0:0:0: [sdb] tag#0 Send: scmd 0xffff8800b6558480
>> [  647.206422] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10) 35
>> 00 00 00 00 00 00 00 00 00
>> [  647.209748] sd 1:0:0:0: Capacity data has changed
>> [  647.209896] sd 1:0:0:0: [sdb] tag#0 Done: SUCCESS Result:
>> hostbyte=DID_OK driverbyte=DRIVER_OK
>> [  647.210157] sd 1:0:0:0: [sdb] tag#0 CDB: Synchronize Cache(10) 35
>> 00 00 00 00 00 00 00 00 00
>> [  647.210419] sd 1:0:0:0: [sdb] tag#0 Sense Key : Unit Attention [current]
>> [  647.210567] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Capacity data has changed
>> [  647.210741] sd 1:0:0:0: [sdb] tag#0 scsi host busy 1 failed 0
>> [  647.210888] sd 1:0:0:0: Notifying upper driver of completion (result 8000002)
>> [  647.211035] sd 1:0:0:0: [sdb] tag#0 sd_done: completed 0 of 0 bytes
>> [  647.211182] sd 1:0:0:0: [sdb] tag#0 0 sectors total, 0 bytes done, error -5
>> [  647.211330] blk_update_request: I/O error, dev sdb, sector 0
>>
>> Will figure out why retry doesn't work.
>>
>> Thanks James and Hannes for all your input.
>>
>> Regards,
>> Jack
>
> Hi James, Hannes and all,
>
> I find out it's code below which report error directly back to user
> space without any retry.
>  913         /*
>  914          * If we finished all bytes in the request we are done now.
>  915          */
>  916         if (!scsi_end_request(req, error, good_bytes, 0))
>  917                 return;
>
> But not sure, what's the best way to fix the behavior to let it retry,
>  maybe add condition with sense key && asc && ascq direct go to
> requeue before line 913?
>
> Thanks
> Jack


Hi James , Hannes and all,

I created a patch below, I did basic test on my test machines. Please
share your comments!

Thanks,
Jack
>From 72ab860811e14e37db81fb409abf0fa7e7fe32cb Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@profitbricks.com>
Date: Tue, 10 May 2016 10:10:59 +0200
Subject: [PATCH] scsi: requeue command on capacity data has changed

We hit IO error in our production on multipath devices during resize
device on target side, the problem turns out scsi driver passes up as IO
error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
Capacity data has changed, even storage side sync the data properly.

To fix this, when condition met, we simply requeue the command.

Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/scsi_lib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..b00310f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -910,6 +910,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
  error = 0;
  }

+ if (sense_valid && (sshdr.sense_key == UNIT_ATTENTION)) {
+ if ((sshdr.asc == 0x2a && sshdr.ascq == 0x09))
+ goto requeue;
+ }
+
  /*
  * If we finished all bytes in the request we are done now.
  */
-- 
1.9.1

--001a113d6bfc757eca05327e0404
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-scsi-requeue-command-on-capacity-data-has-changed.patch"
Content-Disposition: attachment;
	filename="0001-scsi-requeue-command-on-capacity-data-has-changed.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_io1jtzxm0

RnJvbSA3MmFiODYwODExZTE0ZTM3ZGI4MWZiNDA5YWJmMGZhN2U3ZmUzMmNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogVHVlLCAxMCBNYXkgMjAxNiAxMDoxMDo1OSArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHNjc2k6IHJlcXVldWUgY29tbWFuZCBvbiBjYXBhY2l0eSBkYXRhIGhhcyBjaGFuZ2VkCgpXZSBo
aXQgSU8gZXJyb3IgaW4gb3VyIHByb2R1Y3Rpb24gb24gbXVsdGlwYXRoIGRldmljZXMgZHVyaW5n
IHJlc2l6ZQpkZXZpY2Ugb24gdGFyZ2V0IHNpZGUsIHRoZSBwcm9ibGVtIHR1cm5zIG91dCBzY3Np
IGRyaXZlciBwYXNzZXMgdXAgYXMgSU8KZXJyb3Igd2hlbiBzZW5zZSBkYXRhIGlzIFVOSVRfQVRU
RU5USU9OIGFuZCBBU0MgJiYgQVNDUSBpbmRpY2F0ZQpDYXBhY2l0eSBkYXRhIGhhcyBjaGFuZ2Vk
LCBldmVuIHN0b3JhZ2Ugc2lkZSBzeW5jIHRoZSBkYXRhIHByb3Blcmx5LgoKVG8gZml4IHRoaXMs
IHdoZW4gY29uZGl0aW9uIG1ldCwgd2Ugc2ltcGx5IHJlcXVldWUgdGhlIGNvbW1hbmQuCgpSZXBv
cnRlZC1ieTogU2ViYXN0aWFuIFBhcnNjaGF1ZXIgPHMucGFyc2NoYXVlckBnbXguZGU+ClNpZ25l
ZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgotLS0KIGRy
aXZlcnMvc2NzaS9zY3NpX2xpYi5jIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGIvZHJpdmVycy9z
Y3NpL3Njc2lfbGliLmMKaW5kZXggODEwNjUxNS4uYjAwMzEwZiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zY3NpL3Njc2lfbGliLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKQEAgLTkxMCw2
ICs5MTAsMTEgQEAgdm9pZCBzY3NpX2lvX2NvbXBsZXRpb24oc3RydWN0IHNjc2lfY21uZCAqY21k
LCB1bnNpZ25lZCBpbnQgZ29vZF9ieXRlcykKIAkJZXJyb3IgPSAwOwogCX0KIAorCWlmIChzZW5z
ZV92YWxpZCAmJiAoc3NoZHIuc2Vuc2Vfa2V5ID09IFVOSVRfQVRURU5USU9OKSkgeworCQlpZiAo
KHNzaGRyLmFzYyA9PSAweDJhICYmIHNzaGRyLmFzY3EgPT0gMHgwOSkpCisJCQlnb3RvIHJlcXVl
dWU7CisJfQorCiAJLyoKIAkgKiBJZiB3ZSBmaW5pc2hlZCBhbGwgYnl0ZXMgaW4gdGhlIHJlcXVl
c3Qgd2UgYXJlIGRvbmUgbm93LgogCSAqLwotLSAKMS45LjEKCg==
--001a113d6bfc757eca05327e0404--
