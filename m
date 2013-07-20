From: Mike Christie <mchristie@fusionio.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Sat, 20 Jul 2013 09:48:28 -0500
Message-ID: <51EAA33C.9010405@fusionio.com>
References: <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>  <1373583637.7397.370.camel@haakon3.risingtidesystems.com>  <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>  <1373692812.7397.625.camel@haakon3.risingtidesystems.com>  <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>  <1374010683.7397.880.camel@haakon3.risingtidesystems.com>  <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>  <1374173515.7397.948.camel@haakon3.risingtidesystems.com>  <51E83E32.9050306@cs.wisc.edu>  <1374193399.7397.973.camel@haakon3.risingtidesystems.com>  <20130719003034.GG28005@kernel.dk>  <1374195825.7397.997.camel@haakon3.risingtidesystems.com>  <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>  <1374248000.2266.20.camel@dabdike>  <1374267684.7397.1058.camel@haakon3.risingtidesystems.com> <
 1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------000603010606030309060206"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--------------000603010606030309060206
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 07/19/2013 11:56 PM, Nicholas A. Bellinger wrote:
> On Fri, 2013-07-19 at 14:01 -0700, Nicholas A. Bellinger wrote:
>> On Fri, 2013-07-19 at 08:33 -0700, James Bottomley wrote:
>>> On Thu, 2013-07-18 at 23:34 -0700, Nicholas A. Bellinger wrote:
>>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>>> index 0101af5..191bc15 100644
>>>> --- a/drivers/ata/libata-scsi.c
>>>> +++ b/drivers/ata/libata-scsi.c
>>>> @@ -1144,7 +1144,11 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>>>>                         "sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
>>>>                         sdev->sector_size);
>>>>  
>>>> -       blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
>>>> +       if (!q->mq_ops) {
>>>> +               blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
>>>> +       } else {
>>>> +               printk("Skipping dma_alignment for libata w/ scsi-mq\n");
>>>> +       }
>>>
>>> Amazingly enough there is a reason for the dma alignment, and it wasn't
>>> just to annoy you, so you can't blindly do this.
>>>
>>> The email thread is probably lost in the mists of time, but if I
>>> remember correctly the problem is that some ahci DMA controllers barf if
>>> the sector they're doing DMA on crosses a page boundary.  Some are
>>> annoying enough to actually cause silent data corruption.  You won't
>>> find every ahci DMA controller doing this, so the change will work for
>>> some, but it will be hard to identify those it won't work for until
>>> people start losing data.
>>
>> Thanks for the extra background.
>>
>> So at least from what I gather thus far this shouldn't be an issue for
>> initial testing with scsi-mq <-> libata w/ ata_piix.
>>
>>>
>>> The correct fix, obviously, is to do the bio copy on the kernel path for
>>> unaligned data.  It is OK to assume that REQ_TYPE_FS data is correctly
>>> aligned (because of the block to page alignment).
>>>
>>
>> Indeed.  Looking into the bio_copy_kern() breakage next..
>>
> 
> OK, after further investigation the root cause is a actually a missing
> bio->bio_end_io() -> bio_copy_kern_endio() -> bio_put() from the
> blk_end_sync_rq() callback path that scsi-mq REQ_TYPE_BLOCK_PC is
> currently using.
> 
> Including the following patch into the scsi-mq working branch now, and
> reverting the libata dma_alignment=0x03 hack.
> 
> Alexander, care to give this a try..?
> 
> --nab
> 
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index 0761c89..70303d2 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -25,7 +25,10 @@ static void blk_end_sync_rq(struct request *rq, int error)
>         struct completion *waiting = rq->end_io_data;
>  
>         rq->end_io_data = NULL;
> -       if (!rq->q->mq_ops) {
> +       if (rq->q->mq_ops) {
> +               if (rq->bio)
> +                       bio_endio(rq->bio, error);
> +       } else {
>                 __blk_put_request(rq->q, rq);
>         }
> 


This does not handle requests with multiple bios, and for the mq stye
passthrough insertion completions you actually want to call
blk_mq_finish_request in scsi_execute. Same for all the other
passthrough code in your scsi mq tree. That is your root bug. Instead of
doing that though I think we want to have the block layer free the bios
like before.

For the non mq calls, blk_end_request type of calls will complete the
bios when blk_finish_request is called from that path. It will then call
the rq end_io callback.

I think the blk mq code assumes if the end_io callack is set that the
end_io function will do the bio cleanup. See __blk_mq_end_io. Also see
how blk_mq_execute_rq calls blk_mq_finish_request for an example of how
rq passthrough execution and cleanup is being done in the mq paths.

Now with the scsi mq changes, when blk_execute_rq_nowait calls
blk_mq_insert_request it calls it with a old non mq style of end io
function that does not complete the bios.

What about the attached only compile tested patch. The patch has the mq
block code work like the non mq code for bio cleanups.



--------------000603010606030309060206
Content-Type: text/plain; charset="UTF-8"; name="blk-mq-free-bio.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="blk-mq-free-bio.patch"

YmxrLW1xOiBibGstbXEgc2hvdWxkIGZyZWUgYmlvcyBpbiBwYXNzIHRocm91Z2ggY2FzZQoK
Rm9yIG5vbiBtcSBjYWxscywgdGhlIGJsb2NrIGxheWVyIHdpbGwgZnJlZSB0aGUgYmlvcyB3
aGVuCmJsa19maW5pc2hfcmVxdWVzdCBpcyBjYWxsZWQuCgpGb3IgbXEgY2FsbHMsIHRoZSBi
bGsgbXEgY29kZSB3YW50cyB0aGUgY2FsbGVyIHRvIGRvIHRoaXMuCgpUaGlzIHBhdGNoIGhh
cyB0aGUgYmxrIG1xIGNvZGUgd29yayBsaWtlIHRoZSBub24gbXEgY29kZQphbmQgaGFzIHRo
ZSBibG9jayBsYXllciBmcmVlIHRoZSBiaW9zLgoKU2lnbmVkLW9mZi1ieTogTWlrZSBDaHJp
c3RpZSA8bWljaGFlbGNAY3Mud2lzYy5lZHU+CgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWZs
dXNoLmMgYi9ibG9jay9ibGstZmx1c2guYwppbmRleCBjNTZjMzdkLi4zZTRjYzljIDEwMDY0
NAotLS0gYS9ibG9jay9ibGstZmx1c2guYworKysgYi9ibG9jay9ibGstZmx1c2guYwpAQCAt
MjMxLDcgKzIzMSw3IEBAIHN0YXRpYyB2b2lkIGZsdXNoX2VuZF9pbyhzdHJ1Y3QgcmVxdWVz
dCAqZmx1c2hfcnEsIGludCBlcnJvcikKIAl1bnNpZ25lZCBsb25nIGZsYWdzID0gMDsKIAog
CWlmIChxLT5tcV9vcHMpIHsKLQkJYmxrX21xX2ZpbmlzaF9yZXF1ZXN0KGZsdXNoX3JxLCBl
cnJvcik7CisJCWJsa19tcV9mcmVlX3JlcXVlc3QoZmx1c2hfcnEpOwogCQlzcGluX2xvY2tf
aXJxc2F2ZSgmcS0+bXFfZmx1c2hfbG9jaywgZmxhZ3MpOwogCX0KIAlydW5uaW5nID0gJnEt
PmZsdXNoX3F1ZXVlW3EtPmZsdXNoX3J1bm5pbmdfaWR4XTsKZGlmZiAtLWdpdCBhL2Jsb2Nr
L2Jsay1tcS5jIGIvYmxvY2svYmxrLW1xLmMKaW5kZXggNzk5ZDMwNS4uNTQ4OWI1YSAxMDA2
NDQKLS0tIGEvYmxvY2svYmxrLW1xLmMKKysrIGIvYmxvY2svYmxrLW1xLmMKQEAgLTI3MCw3
ICsyNzAsNyBAQCB2b2lkIGJsa19tcV9mcmVlX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJx
KQogfQogRVhQT1JUX1NZTUJPTChibGtfbXFfZnJlZV9yZXF1ZXN0KTsKIAotdm9pZCBibGtf
bXFfZmluaXNoX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgZXJyb3IpCitzdGF0
aWMgdm9pZCBibGtfbXFfZmluaXNoX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQg
ZXJyb3IpCiB7CiAJc3RydWN0IGJpbyAqYmlvID0gcnEtPmJpbzsKIAl1bnNpZ25lZCBpbnQg
Ynl0ZXMgPSAwOwpAQCAtMjg2LDIyICsyODYsMTcgQEAgdm9pZCBibGtfbXFfZmluaXNoX3Jl
cXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgZXJyb3IpCiAKIAlibGtfYWNjb3VudF9p
b19jb21wbGV0aW9uKHJxLCBieXRlcyk7CiAJYmxrX2FjY291bnRfaW9fZG9uZShycSk7Ci0J
YmxrX21xX2ZyZWVfcmVxdWVzdChycSk7CiB9CiAKIHZvaWQgYmxrX21xX2NvbXBsZXRlX3Jl
cXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgZXJyb3IpCiB7CiAJdHJhY2VfYmxvY2tf
cnFfY29tcGxldGUocnEtPnEsIHJxKTsKKwlibGtfbXFfZmluaXNoX3JlcXVlc3QocnEsIGVy
cm9yKTsKIAotCS8qCi0JICogSWYgLT5lbmRfaW8gaXMgc2V0LCBpdCdzIHJlc3BvbnNpYmxl
IGZvciBkb2luZyB0aGUgcmVzdCBvZiB0aGUKLQkgKiBjb21wbGV0aW9uLgotCSAqLwogCWlm
IChycS0+ZW5kX2lvKQogCQlycS0+ZW5kX2lvKHJxLCBlcnJvcik7CiAJZWxzZQotCQlibGtf
bXFfZmluaXNoX3JlcXVlc3QocnEsIGVycm9yKTsKLQorCQlibGtfbXFfZnJlZV9yZXF1ZXN0
KHJxKTsKIH0KIAogdm9pZCBfX2Jsa19tcV9lbmRfaW8oc3RydWN0IHJlcXVlc3QgKnJxLCBp
bnQgZXJyb3IpCkBAIC05NzMsOCArOTY4LDcgQEAgaW50IGJsa19tcV9leGVjdXRlX3JxKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCiAJaWYgKHJxLT5l
cnJvcnMpCiAJCWVyciA9IC1FSU87CiAKLQlibGtfbXFfZmluaXNoX3JlcXVlc3QocnEsIHJx
LT5lcnJvcnMpOwotCisJYmxrX21xX2ZyZWVfcmVxdWVzdChycSk7CiAJcmV0dXJuIGVycjsK
IH0KIEVYUE9SVF9TWU1CT0woYmxrX21xX2V4ZWN1dGVfcnEpOwpkaWZmIC0tZ2l0IGEvYmxv
Y2svYmxrLW1xLmggYi9ibG9jay9ibGstbXEuaAppbmRleCA0MmQwMTEwLi41MmJmMWY5IDEw
MDY0NAotLS0gYS9ibG9jay9ibGstbXEuaAorKysgYi9ibG9jay9ibGstbXEuaApAQCAtMjcs
NyArMjcsNiBAQCB2b2lkIGJsa19tcV9jb21wbGV0ZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0
ICpycSwgaW50IGVycm9yKTsKIHZvaWQgYmxrX21xX3J1bl9yZXF1ZXN0KHN0cnVjdCByZXF1
ZXN0ICpycSwgYm9vbCBydW5fcXVldWUsIGJvb2wgYXN5bmMpOwogdm9pZCBibGtfbXFfcnVu
X2h3X3F1ZXVlKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LCBib29sIGFzeW5jKTsKIHZv
aWQgYmxrX21xX2luaXRfZmx1c2goc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpOwotdm9pZCBi
bGtfbXFfZmluaXNoX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgZXJyb3IpOwog
CiAvKgogICogQ1BVIGhvdHBsdWcgaGVscGVycwo=
--------------000603010606030309060206--
