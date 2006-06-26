From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Mon, 26 Jun 2006 08:37:39 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290BDEC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C6991D.4FA8EE9F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:30354 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751108AbWFZMhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 08:37:42 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>, Alan Cox <alan@redhat.com>
Cc: torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6991D.4FA8EE9F
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

MarkH is out on Vacation for a few weeks.

This may seem like a DILLIGAF, but after chatting with the F/W folks,
there is no harm in dropping the page calculation as denoted in the
enclosed patch for these older adapters in this new age of 4GB+ memory
sticks. Any resource optimization within the old-old-old adapters for
systems with less than 4G of memory is of little consequence. The
existing AAC_QUIRK_31BIT flag in linit.c should look after the rest of
the legacy hardware DMA limitations.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
---
Applies to the scsi-misc-2.6 git tree.
<enclosed aacraid-GART.patch>

Andi Kleen sez:
> On Sunday 25 June 2006 21:00, Alan Cox wrote:
>> On Sun, Jun 25, 2006 at 05:22:23PM +0200, Andi Kleen wrote:
>>>> Older aacraid hardware cannot address the 3-4GB range where the
iommu
>>>> remaps pages. As the PCI DMA implementation for the x86-64 is
flawed and
>>>> doesn't support any nice way to deal with this via swiotlb instead
the
>>>> driver handles it internally.
>>> Then you should just force a low bounce pfn < 0xfffffff for the
block device -=20
>>> then the block layer  should use GFP_DMA bouncing.
>> From a tiny 16MB DMA pool that can't sustain the required load ? Or
has that
>> bit changed.
> It should be ok because it blocks. It will be slow, but what=20
> else do you expect from broken hardware like this?=20

------_=_NextPart_001_01C6991D.4FA8EE9F
Content-Type: application/octet-stream;
	name="aacraid-GART.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid-GART.patch
Content-Disposition: attachment;
	filename="aacraid-GART.patch"

LS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbWluaXQuYwkyMDA2LTA2LTE0IDA5OjI2OjE5
LjAwMDAwMDAwMCAtMDQwMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jCTIw
MDYtMDYtMjYgMDg6MTk6MjkuMTg2Nzk1NzEwIC0wNDAwCkBAIC05MiwyOCArOTIsNyBAQAogCWlu
aXQtPkFkYXB0ZXJGaWJzUGh5c2ljYWxBZGRyZXNzID0gY3B1X3RvX2xlMzIoKHUzMilwaHlzKTsK
IAlpbml0LT5BZGFwdGVyRmlic1NpemUgPSBjcHVfdG9fbGUzMihmaWJzaXplKTsKIAlpbml0LT5B
ZGFwdGVyRmliQWxpZ24gPSBjcHVfdG9fbGUzMihzaXplb2Yoc3RydWN0IGh3X2ZpYikpOwotCS8q
IAotCSAqIG51bWJlciBvZiA0ayBwYWdlcyBvZiBob3N0IHBoeXNpY2FsIG1lbW9yeS4gVGhlIGFh
Y3JhaWQgZncgbmVlZHMKLQkgKiB0aGlzIG51bWJlciB0byBiZSBsZXNzIHRoYW4gNGdiIHdvcnRo
IG9mIHBhZ2VzLiBudW1fcGh5c3BhZ2VzIGlzIGluCi0JICogc3lzdGVtIHBhZ2UgdW5pdHMuIE5l
dyBmaXJtd2FyZSBkb2Vzbid0IGhhdmUgYW55IGlzc3VlcyB3aXRoIHRoZQotCSAqIG1hcHBpbmcg
c3lzdGVtLCBidXQgb2xkZXIgRmlybXdhcmUgZGlkLCBhbmQgaGFkICp0cm91YmxlcyogZGVhbGlu
ZwotCSAqIHdpdGggdGhlIG1hdGggb3ZlcmxvYWRpbmcgcGFzdCAzMiBiaXRzLCB0aHVzIHdlIG11
c3QgbGltaXQgdGhpcwotCSAqIGZpZWxkLgotCSAqCi0JICogVGhpcyBhc3N1bWVzIHRoZSBtZW1v
cnkgaXMgbWFwcGVkIHplcm8tPm4sIHdoaWNoIGlzbnQKLQkgKiBhbHdheXMgdHJ1ZSBvbiByZWFs
IGNvbXB1dGVycy4gSXQgYWxzbyBoYXMgc29tZSBzbGlnaHQgcHJvYmxlbXMKLQkgKiB3aXRoIHRo
ZSBHQVJUIG9uIHg4Ni02NC4gSSd2ZSBidHcgbmV2ZXIgdHJpZWQgRE1BIGZyb20gUENJIHNwYWNl
Ci0JICogb24gdGhpcyBwbGF0Zm9ybSBidXQgZG9uJ3QgYmUgc3VycHJpc2VkIGlmIGl0cyBwcm9i
bGVtYXRpYy4KLQkgKi8KLSNpZm5kZWYgQ09ORklHX0dBUlRfSU9NTVUKLQlpZiAoKG51bV9waHlz
cGFnZXMgPDwgKFBBR0VfU0hJRlQgLSAxMikpIDw9IEFBQ19NQVhfSE9TVFBIWVNNRU1QQUdFUykg
ewotCQlpbml0LT5Ib3N0UGh5c01lbVBhZ2VzID0gCi0JCQljcHVfdG9fbGUzMihudW1fcGh5c3Bh
Z2VzIDw8IChQQUdFX1NISUZULTEyKSk7Ci0JfSBlbHNlIAotI2VuZGlmCQotCXsKLQkJaW5pdC0+
SG9zdFBoeXNNZW1QYWdlcyA9IGNwdV90b19sZTMyKEFBQ19NQVhfSE9TVFBIWVNNRU1QQUdFUyk7
Ci0JfQorCWluaXQtPkhvc3RQaHlzTWVtUGFnZXMgPSBjcHVfdG9fbGUzMihBQUNfTUFYX0hPU1RQ
SFlTTUVNUEFHRVMpOwogCiAJaW5pdC0+SW5pdEZsYWdzID0gMDsKIAlpZiAoZGV2LT5uZXdfY29t
bV9pbnRlcmZhY2UpIHsK

------_=_NextPart_001_01C6991D.4FA8EE9F--
