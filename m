From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: RE: NPIV mapping problems (was Re: [PATCH 1/19] add data buffer accessors)
Date: Tue, 3 Jul 2007 12:56:06 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B0124454A@AVEXCH2.qlogic.org>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp> <1178980728.3723.8.camel@mulgrave.il.steeleye.com> <20070629132332.GB2648@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7BDAC.49B51848"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:48560 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbXGCT5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 15:57:32 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070629132332.GB2648@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@infradead.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7BDAC.49B51848
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 29 June 2007, Andrew Vasquez wrote:
> On Sat, 12 May 2007, James Bottomley wrote:
>=20
> > On Sat, 2007-05-12 at 19:05 +0900, FUJITA Tomonori wrote:
> > > Add a set of accessors for the scsi data buffer. This is in=20
> > > preparation for chaining sg lists and bidirectional requests (and=20
> > > possibly, the mid-layer dma mapping).
> > >=20
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  drivers/scsi/scsi_lib.c  |   26 ++++++++++++++++++++++++++
> > >  include/scsi/scsi_cmnd.h |   11 +++++++++++
> > >  2 files changed, 37 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/drivers/scsi/scsi_lib.c=20
> b/drivers/scsi/scsi_lib.c index=20
> > > 1f5a07b..a2ebe61 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -2290,3 +2290,29 @@ void scsi_kunmap_atomic_sg(void *virt)
> > >  	kunmap_atomic(virt, KM_BIO_SRC_IRQ);  } =20
> > > EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
> > > +
> > > +int scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
> >=20
> > Actually, this is redundant.  We make sure the
> > shost->shost_gendev.parent is the device which should have=20
> been passed
> > in to scsi_add_host().
>=20
> Well, there's perhaps an unintended side-effect with this=20
> assumption, NPIV-based 'vports' (and their subsequent 'struct=20
> device' members) are not fully initialized objects.
>=20
> This is what we've run into while working on our NPIV (based)=20
> driver with the 'data buffer' accessors works, while queueing=20
> the first command to an sdev of a freshly created vport:
> ...=20
> One possiblity (the least intrusive) would be to add a
> scsi_dma_map_with_device() function which takes the proper (LLD
> defined) 'struct device' as a parameter, as was originally=20
> proposed, and have NPIV-aware drivers call that function=20
> during the mappings of physical *and* virtual dma-mappings.
As a one possible solution, scsi_dma_map_with_device() has added.
With this change, the QLogic NPIV enabled driver has tested and it works
fine.
With the patch attached, would like to stroke this thread so that it can
move forward.

Thank you,
Seokmann
---
>From cddc43e416deeb875982f371d27c4fb074d5970e Mon Sep 17 00:00:00 2001
From: Seokmann Ju <seokmann.ju@qlogic.com>
Date: Tue, 3 Jul 2007 11:53:34 -0700
Subject: [PATCH] add data buffer accessor with device structure.

- in addition to scsi_dma_map(), scsi_dma_map_with_device() has added.
- this addition is for not fully instantiated host, like virtual hosts
on
  NPIV based implementation.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/scsi_lib.c  |   22 ++++++++++++++++++++++
 include/scsi/scsi_cmnd.h |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70454b4..90601ed 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2315,6 +2315,28 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_dma_map);

 /**
+ * scsi_dma_map_with_device - perform DMA mapping against command's sg
lists
+ * @dev:       device structure
+ * @cmd:       scsi command
+ *
+ * Returns the number of sg lists actually used, zero if the sg lists
+ * is NULL, or -ENOMEM if the mapping failed.
+ */
+int scsi_dma_map_with_device(struct device *dev, struct scsi_cmnd *cmd)
+{
+       int nseg =3D 0;
+
+       if (scsi_sg_count(cmd)) {
+               nseg =3D dma_map_sg(dev, scsi_sglist(cmd),
scsi_sg_count(cmd),
+                                 cmd->sc_data_direction);
+               if (unlikely(!nseg))
+                       return -ENOMEM;
+       }
+       return nseg;
+}
+EXPORT_SYMBOL(scsi_dma_map_with_device);
+
+/**
  * scsi_dma_unmap - unmap command's sg lists mapped by scsi_dma_map
  * @cmd:       scsi command
  */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..a223331 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -136,6 +136,7 @@ extern struct scatterlist *scsi_alloc_sgtable(struct
scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);

 extern int scsi_dma_map(struct scsi_cmnd *cmd);
+extern int scsi_dma_map_with_device(struct device *dev, struct
scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);

 #define scsi_sg_count(cmd) ((cmd)->use_sg)
--
1.5.2.2.603.g7c851
---

------_=_NextPart_001_01C7BDAC.49B51848
Content-Type: application/octet-stream;
	name="0001-add-data-buffer-accessor-with-device-structure.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-add-data-buffer-accessor-with-device-structure.patch
Content-Disposition: attachment;
	filename="0001-add-data-buffer-accessor-with-device-structure.patch"

RnJvbSBjZGRjNDNlNDE2ZGVlYjg3NTk4MmYzNzFkMjdjNGZiMDc0ZDU5NzBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZW9rbWFubiBKdSA8c2Vva21hbm4uanVAcWxvZ2ljLmNvbT4K
RGF0ZTogVHVlLCAzIEp1bCAyMDA3IDExOjUzOjM0IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gYWRk
IGRhdGEgYnVmZmVyIGFjY2Vzc29yIHdpdGggZGV2aWNlIHN0cnVjdHVyZS4KCi0gaW4gYWRkaXRp
b24gdG8gc2NzaV9kbWFfbWFwKCksIHNjc2lfZG1hX21hcF93aXRoX2RldmljZSgpIGhhcyBhZGRl
ZC4KLSB0aGlzIGFkZGl0aW9uIGlzIGZvciBub3QgZnVsbHkgaW5zdGFudGlhdGVkIGhvc3QsIGxp
a2UgdmlydHVhbCBob3N0cyBvbgogIE5QSVYgYmFzZWQgaW1wbGVtZW50YXRpb24uCgpTaWduZWQt
b2ZmLWJ5OiBTZW9rbWFubiBKdSA8c2Vva21hbm4uanVAcWxvZ2ljLmNvbT4KLS0tCiBkcml2ZXJz
L3Njc2kvc2NzaV9saWIuYyAgfCAgIDIyICsrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUv
c2NzaS9zY3NpX2NtbmQuaCB8ICAgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25z
KCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5j
IGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKaW5kZXggNzA0NTRiNC4uOTA2MDFlZCAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfbGli
LmMKQEAgLTIzMTUsNiArMjMxNSwyOCBAQCBpbnQgc2NzaV9kbWFfbWFwKHN0cnVjdCBzY3NpX2Nt
bmQgKmNtZCkKIEVYUE9SVF9TWU1CT0woc2NzaV9kbWFfbWFwKTsKIAogLyoqCisgKiBzY3NpX2Rt
YV9tYXBfd2l0aF9kZXZpY2UgLSBwZXJmb3JtIERNQSBtYXBwaW5nIGFnYWluc3QgY29tbWFuZCdz
IHNnIGxpc3RzCisgKiBAZGV2OglkZXZpY2Ugc3RydWN0dXJlCisgKiBAY21kOglzY3NpIGNvbW1h
bmQKKyAqCisgKiBSZXR1cm5zIHRoZSBudW1iZXIgb2Ygc2cgbGlzdHMgYWN0dWFsbHkgdXNlZCwg
emVybyBpZiB0aGUgc2cgbGlzdHMKKyAqIGlzIE5VTEwsIG9yIC1FTk9NRU0gaWYgdGhlIG1hcHBp
bmcgZmFpbGVkLgorICovCitpbnQgc2NzaV9kbWFfbWFwX3dpdGhfZGV2aWNlKHN0cnVjdCBkZXZp
Y2UgKmRldiwgc3RydWN0IHNjc2lfY21uZCAqY21kKQoreworCWludCBuc2VnID0gMDsKKworCWlm
IChzY3NpX3NnX2NvdW50KGNtZCkpIHsKKwkJbnNlZyA9IGRtYV9tYXBfc2coZGV2LCBzY3NpX3Nn
bGlzdChjbWQpLCBzY3NpX3NnX2NvdW50KGNtZCksCisJCQkJICBjbWQtPnNjX2RhdGFfZGlyZWN0
aW9uKTsKKwkJaWYgKHVubGlrZWx5KCFuc2VnKSkKKwkJCXJldHVybiAtRU5PTUVNOworCX0KKwly
ZXR1cm4gbnNlZzsKK30KK0VYUE9SVF9TWU1CT0woc2NzaV9kbWFfbWFwX3dpdGhfZGV2aWNlKTsK
KworLyoqCiAgKiBzY3NpX2RtYV91bm1hcCAtIHVubWFwIGNvbW1hbmQncyBzZyBsaXN0cyBtYXBw
ZWQgYnkgc2NzaV9kbWFfbWFwCiAgKiBAY21kOglzY3NpIGNvbW1hbmQKICAqLwpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9zY3NpL3Njc2lfY21uZC5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfY21uZC5oCmlu
ZGV4IDUzZTE3MDUuLmEyMjMzMzEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvc2NzaS9zY3NpX2NtbmQu
aAorKysgYi9pbmNsdWRlL3Njc2kvc2NzaV9jbW5kLmgKQEAgLTEzNiw2ICsxMzYsNyBAQCBleHRl
cm4gc3RydWN0IHNjYXR0ZXJsaXN0ICpzY3NpX2FsbG9jX3NndGFibGUoc3RydWN0IHNjc2lfY21u
ZCAqLCBnZnBfdCk7CiBleHRlcm4gdm9pZCBzY3NpX2ZyZWVfc2d0YWJsZShzdHJ1Y3Qgc2NhdHRl
cmxpc3QgKiwgaW50KTsKIAogZXh0ZXJuIGludCBzY3NpX2RtYV9tYXAoc3RydWN0IHNjc2lfY21u
ZCAqY21kKTsKK2V4dGVybiBpbnQgc2NzaV9kbWFfbWFwX3dpdGhfZGV2aWNlKHN0cnVjdCBkZXZp
Y2UgKmRldiwgc3RydWN0IHNjc2lfY21uZCAqY21kKTsKIGV4dGVybiB2b2lkIHNjc2lfZG1hX3Vu
bWFwKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCk7CiAKICNkZWZpbmUgc2NzaV9zZ19jb3VudChjbWQp
ICgoY21kKS0+dXNlX3NnKQotLSAKMS41LjIuMi42MDMuZzdjODUxCgo=

------_=_NextPart_001_01C7BDAC.49B51848--
