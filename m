From: Ismail Donmez <ismail@pardus.org.tr>
Subject: Re: [PATCH] scsi/scsi.h protect scsi_to_u32 function by ifdef __KERNEL__
Date: Sun, 22 Oct 2006 20:32:00 +0300
Message-ID: <200610222032.00597.ismail@pardus.org.tr>
References: <200610211302.08574.ismail@pardus.org.tr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Qs6OFLRkwGXyZBO"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:51108 "EHLO uludag.org.tr")
	by vger.kernel.org with ESMTP id S1751322AbWJVRbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Oct 2006 13:31:52 -0400
In-Reply-To: <200610211302.08574.ismail@pardus.org.tr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ismail Donmez <ismail@pardus.org.tr>
Cc: linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

--Boundary-00=_Qs6OFLRkwGXyZBO
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46orgot to cc linux-scsi list.

21 Eki 2006 Cts 13:02 tarihinde =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=B1n=
=C4=B1z:
> Hi,
>
> include/scsi/scsi.h defines scsi_to_u32 function like this:
>
>  static inline u32 scsi_to_u32(u8 *ptr)
>
> But the definition of u8 is protected by ifdef __KERNEL__ in asm/types.h
> hence this whole function should be procted as well. This fixes compilati=
on
> of cdrtools with latest kernel-headers GIT tree.
>
> Signed-off-by: Ismail Donmez <ismail@pardus.org.tr>

--Boundary-00=_Qs6OFLRkwGXyZBO
Content-Type: text/x-diff;
  charset="utf-8";
  name="1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="1.patch"

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 84a6d5f..0ce924a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -429,10 +429,12 @@ #define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
+#ifdef __KERNEL__
 /* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
 static inline u32 scsi_to_u32(u8 *ptr)
 {
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
+#endif
 
 #endif /* _SCSI_SCSI_H */

--Boundary-00=_Qs6OFLRkwGXyZBO--
