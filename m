From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: virtio_blk - kernel BUG at drivers/virtio/virtio_ring.c:160!
Date: Wed, 22 Oct 2014 08:57:07 +0800
Message-ID: <CACVXFVMkyRb=ZKCzmn28s=MtwJwktWtqgtHh+yQ6WBnYm83OiQ@mail.gmail.com>
References: <20141016151738.GC57207@bfoster.bfoster>
	<20141017132721.GN16538@infradead.org>
	<5446BC7C.9080607@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113d2bf25a80620505f86dc5
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50982 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJVA5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 20:57:08 -0400
Received: by mail-ob0-f175.google.com with SMTP id wn1so2055826obc.20
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2014 17:57:08 -0700 (PDT)
In-Reply-To: <5446BC7C.9080607@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

--001a113d2bf25a80620505f86dc5
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 22, 2014 at 4:05 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/17/2014 07:27 AM, Christoph Hellwig wrote:
>> On Thu, Oct 16, 2014 at 11:17:39AM -0400, Brian Foster wrote:
>>> Hi all,
>>>
>>> Hopefully this is the right list for this report...
>>>
>>> I hit the following kernel bug reliably by running xfstests test
>>> generic/234 against XFS using 10GB LVM test/scratch volumes on top of a
>>> ~100GB virtio_blk block device. The virt block device is file-backed on
>>> the host.
>>
>> Jens, I thought the segment merging bug was fixed a while ago.  Did we
>> manage to not include parts of it for 3.17?
>
> Mings patch went in after 3.17, iirc. Ming?

Sorry, that patch is wrong[1], attachment patch should fix the issue.

[1] http://marc.info/?l=linux-kernel&m=141290430004361&w=2


Thanks,
-- 
Ming Lei

--001a113d2bf25a80620505f86dc5
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-blk-merge-recaculate-segment-if-it-isn-t-less-than-m.patch"
Content-Disposition: attachment;
	filename="0001-blk-merge-recaculate-segment-if-it-isn-t-less-than-m.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1jz09iz0

RnJvbSBkZGUxOTU0OTM1MmRhM2ZlYTUxNmQ4OWJiZmEyNWQwOGI3ODRlMjI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8dG9tLmxlaW1pbmdAZ21haWwuY29tPgpEYXRl
OiBXZWQsIDIyIE9jdCAyMDE0IDA4OjMwOjMwICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmxrLW1l
cmdlOiByZWNhY3VsYXRlIHNlZ21lbnQgaWYgaXQgaXNuJ3QgbGVzcyB0aGFuIG1heAogc2VnbWVu
dHMKClRoZSBwcm9ibGVtIGlzIGludHJvZHVjZWQgYnkgY29tbWl0IDc2NGY2MTJjNmMzYzIzMWIo
YmxrLW1lcmdlOgpkb24ndCBjb21wdXRlIGJpX3BoeXNfc2VnbWVudHMgZnJvbSBiaV92Y250IGZv
ciBjbG9uZWQgYmlvKSwKYW5kIG1lcmdlIGlzIG5lZWRlZCBpZiBudW1iZXIgb2YgY3VycmVudCBz
ZWdtZW50IGlzbid0IGxlc3MgdGhhbgptYXggc2VnbWVudHMuCgpTdHJpY3RseSBzcGVha2luZywg
YmlvLT5iaV92Y250IHNob3VsZG4ndCBiZSB1c2VkIGhlcmUgc2luY2UKaXQgbWF5IG5vdCBiZSBh
Y2N1cmF0ZSBpbiBjYXNlcyBvZiBib3RoIGNsb25lZCBiaW8gb3IgYmlvIGNsb25lZApmcm9tLCBi
dXQgYmlvX3NlZ21lbnRzKCkgaXMgYSBiaXQgZXhwZW5zaXZlLCBhbmQgYmlfdmNudCBpcyBzdGls
bAp0aGUgYmlnZ2VzdCBudW1iZXIsIHNvIHRoZSBhcHByb2FjaCBzaG91bGQgd29yay4KClNpZ25l
ZC1vZmYtYnk6IE1pbmcgTGVpIDx0b20ubGVpbWluZ0BnbWFpbC5jb20+Ci0tLQogYmxvY2svYmxr
LW1lcmdlLmMgfCAgICA1ICsrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tZXJnZS5jIGIvYmxvY2svYmxr
LW1lcmdlLmMKaW5kZXggYmE5OTM1MS4uYjNhYzQwYSAxMDA2NDQKLS0tIGEvYmxvY2svYmxrLW1l
cmdlLmMKKysrIGIvYmxvY2svYmxrLW1lcmdlLmMKQEAgLTk5LDE2ICs5OSwxNyBAQCB2b2lkIGJs
a19yZWNvdW50X3NlZ21lbnRzKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpi
aW8pCiB7CiAJYm9vbCBub19zZ19tZXJnZSA9ICEhdGVzdF9iaXQoUVVFVUVfRkxBR19OT19TR19N
RVJHRSwKIAkJCSZxLT5xdWV1ZV9mbGFncyk7CisJYm9vbCBtZXJnZV9ub3RfbmVlZCA9IGJpby0+
YmlfdmNudCA8IHF1ZXVlX21heF9zZWdtZW50cyhxKTsKIAogCWlmIChub19zZ19tZXJnZSAmJiAh
YmlvX2ZsYWdnZWQoYmlvLCBCSU9fQ0xPTkVEKSAmJgotCQkJYmlvLT5iaV92Y250IDwgcXVldWVf
bWF4X3NlZ21lbnRzKHEpKQorCQkJbWVyZ2Vfbm90X25lZWQpCiAJCWJpby0+YmlfcGh5c19zZWdt
ZW50cyA9IGJpby0+YmlfdmNudDsKIAllbHNlIHsKIAkJc3RydWN0IGJpbyAqbnh0ID0gYmlvLT5i
aV9uZXh0OwogCiAJCWJpby0+YmlfbmV4dCA9IE5VTEw7CiAJCWJpby0+YmlfcGh5c19zZWdtZW50
cyA9IF9fYmxrX3JlY2FsY19ycV9zZWdtZW50cyhxLCBiaW8sCi0JCQkJbm9fc2dfbWVyZ2UpOwor
CQkJCW5vX3NnX21lcmdlICYmIG1lcmdlX25vdF9uZWVkKTsKIAkJYmlvLT5iaV9uZXh0ID0gbnh0
OwogCX0KIAotLSAKMS43LjkuNQoK
--001a113d2bf25a80620505f86dc5--
