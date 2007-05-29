From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: [PATCH 4/5] SCSI: add cpu cache flushes after kmapping and modifying a page
Date: Tue, 29 May 2007 12:53:39 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E21E8@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A211.E871BB00"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:57982 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbXE2Qxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 12:53:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A211.E871BB00
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

What ever became of the following patch? I have enclosed the incremental
aacraid version of this patch to permit closure if the following was
rejected because of another portion.

This attached aacraid specific portion of the patch is against current
scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch content.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Tejun Heo
Sent: Saturday, June 03, 2006 11:41 PM
To: Jens Axboe; James Bottomley; Dave Miller; bzolnier@gmail.com;
james.steward@dynamicratings.com; jgarzik@pobox.com;
mattjreimer@gmail.com; Guennadi Liakhovetski; rmk@arm.linux.org.uk;
lkml; linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org;
htejun@gmail.com
Cc: Tejun Heo
Subject: [PATCH 4/5] SCSI: add cpu cache flushes after kmapping and
modifying a page


Add calls to flush_kernel_dcache_page() after CPU has kmapped and
modified a page.  This fixes PIO cache coherency bugs on architectures
with aliased caches.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

 drivers/scsi/3w-9xxx.c        |    1 +
 drivers/scsi/3w-xxxx.c        |    1 +
 drivers/scsi/aacraid/aachba.c |    4 +++-
 drivers/scsi/ide-scsi.c       |    1 +
 drivers/scsi/ips.c            |    2 ++
 drivers/scsi/iscsi_tcp.c      |    1 +
 drivers/scsi/megaraid.c       |    2 ++
 drivers/scsi/qlogicpti.c      |    1 +
 drivers/scsi/scsi_debug.c     |    1 +
 drivers/scsi/scsi_lib.c       |    1 +
 10 files changed, 14 insertions(+), 1 deletions(-)

9b4bdd1409efb726d4a6561a4f7e2aff878ab4f4
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index caeb6d2..172f16b 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1948,6 +1948,7 @@ static void twa_scsiop_execute_scsi_comp
 			local_irq_save(flags);
 			buf =3D kmap_atomic(sg->page, KM_IRQ0) +
sg->offset;
 			memcpy(buf,
tw_dev->generic_buffer_virt[request_id], sg->length);
+			flush_kernel_dcache_page(kmap_atomic_to_page(buf
- sg->offset));
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		}
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index e8e41e6..8449551 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1527,6 +1527,7 @@ static void tw_transfer_internal(TW_Devi
 		struct scatterlist *sg;
=20
 		sg =3D (struct scatterlist *)cmd->request_buffer;
+		flush_kernel_dcache_page(kmap_atomic_to_page(buf -
sg->offset));
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
 		local_irq_restore(flags);
 	}
diff --git a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
index 642a3b4..b7c00b8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -376,8 +376,10 @@ static void aac_internal_transfer(struct
=20
 	memcpy(buf + offset, data, transfer_len - offset);
=20
-	if (scsicmd->use_sg)=20
+	if (scsicmd->use_sg) {
+		flush_kernel_dcache_page(kmap_atomic_to_page(buf -
sg->offset));
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	}
=20
 }
=20
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 39b760a..9c28b95 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -189,6 +189,7 @@ static void idescsi_input_buffers (ide_d
 					pc->sg->offset;
 			drive->hwif->atapi_input_bytes(drive,
 						buf + pc->b_count,
count);
+			flush_kernel_dcache_page(kmap_atomic_to_page(buf
- pc->sg->offset));
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index a4c0b04..29eb3f0 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3682,6 +3682,8 @@ ips_scmd_buf_write(Scsi_Cmnd * scmd, voi
 			local_irq_save(flags);
 			buffer =3D kmap_atomic(sg[i].page, KM_IRQ0) +
sg[i].offset;
 			memcpy(buffer, &cdata[xfer_cnt], min_cnt);
+                        flush_kernel_dcache_page(
+                                kmap_atomic_to_page(buffer -
sg[i].offset));
 			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
 			local_irq_restore(flags);
=20
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2068b66..ae9784c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -945,6 +945,7 @@ static int iscsi_scsi_data_in(struct isc
 		dest =3D kmap_atomic(sg[i].page, KM_SOFTIRQ0);
 		rc =3D iscsi_ctask_copy(conn, ctask, dest + sg[i].offset,
 				      sg[i].length, offset);
+		flush_kernel_dcache_page(kmap_atomic_to_page(dest));
 		kunmap_atomic(dest, KM_SOFTIRQ0);
 		if (rc =3D=3D -EAGAIN)
 			/* continue with the next SKB/PDU */
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index de35ffe..7cb7590 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -671,6 +671,8 @@ #endif
 				struct scatterlist *sg;
=20
 				sg =3D (struct scatterlist
*)cmd->request_buffer;
+				flush_kernel_dcache_page(
+					kmap_atomic_to_page(buf -
sg->offset));
 				kunmap_atomic(buf - sg->offset,
KM_IRQ0);
 			}
 			cmd->result =3D (DID_OK << 16);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index c7e78dc..f8201f2 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1146,6 +1146,7 @@ static void scsi_rbuf_put(struct scsi_cm
 		struct scatterlist *sg;
=20
 		sg =3D (struct scatterlist *) cmd->request_buffer;
+		flush_kernel_dcache_page(kmap_atomic_to_page(buf -
sg->offset));
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
 	}
 }
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5a5d2af..88543db 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -511,6 +511,7 @@ static int fill_from_dev_buffer(struct s
 				len =3D arr_len - req_len;
 			}
 			memcpy(kaddr_off, arr + req_len, len);
+
flush_kernel_dcache_page(kmap_atomic_to_page(kaddr));
 			kunmap_atomic(kaddr, KM_USER0);
 			act_len +=3D len;
 		}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 764a8b3..8bb2f6c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -945,6 +945,7 @@ void scsi_io_completion(struct scsi_cmnd
 			unsigned long flags;
 			char *to =3D bio_kmap_irq(req->bio, &flags);
 			memcpy(to, cmd->buffer, cmd->bufflen);
+
flush_kernel_dcache_page(kmap_atomic_to_page(to));
 			bio_kunmap_irq(to, &flags);
 		}
 		kfree(cmd->buffer);
--=20
1.3.2

------_=_NextPart_001_01C7A211.E871BB00
Content-Type: application/octet-stream;
	name="aacraid_flush_dcache.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_flush_dcache.patch
Content-Disposition: attachment;
	filename="aacraid_flush_dcache.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDUtMjkgMTE6NTc6NDcuMzMyNDM3NTE5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDUtMjkgMTI6Mzc6MDQuNTgxMzg2NjM5IC0wNDAwCkBAIC0zMSw5ICsz
MSw5IEBACiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRp
b24uaD4KICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KLSNpbmNsdWRlIDxsaW51eC9kbWEtbWFw
cGluZy5oPgogI2luY2x1ZGUgPGFzbS9zZW1hcGhvcmUuaD4KICNpbmNsdWRlIDxhc20vdWFjY2Vz
cy5oPgorI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4gLyogRm9yIGZsdXNoX2tlcm5lbF9kY2Fj
aGVfcGFnZSAqLwogCiAjaW5jbHVkZSA8c2NzaS9zY3NpLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3Np
X2NtbmQuaD4KQEAgLTM1NSw3ICszNTUsOSBAQAogCQltZW1jcHkoYnVmICsgb2Zmc2V0LCBkYXRh
LCB0cmFuc2Zlcl9sZW4pOwogCi0JaWYgKHNjc2ljbWQtPnVzZV9zZykgCisJaWYgKHNjc2ljbWQt
PnVzZV9zZykgeworCQlmbHVzaF9rZXJuZWxfZGNhY2hlX3BhZ2Uoa21hcF9hdG9taWNfdG9fcGFn
ZShidWYgLSBzZy0+b2Zmc2V0KSk7CiAJCWt1bm1hcF9hdG9taWMoYnVmIC0gc2ctPm9mZnNldCwg
S01fSVJRMCk7CisJfQogCiB9CiAK

------_=_NextPart_001_01C7A211.E871BB00--
