From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/5] fusion-kfree-cleanup
Date: Wed, 11 May 2005 11:37:26 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0247DC9C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C55650.18B73740"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23783 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262007AbVEKRhp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:37:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C55650.18B73740
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 1/5:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.02/


This patch is originally From: Jesper Juhl <juhl-lkml@dif.dk>

This patch gets rid of redundant NULL checks prior to calling kfree() in
drivers/message/* There are also a few small whitespace changes in there.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>







------_=_NextPart_000_01C55650.18B73740
Content-Type: application/octet-stream;
	name="kfree-1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kfree-1.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-04-28 17:04:13.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-05-10 14:27:13.000000000 =
-0600=0A=
@@ -1804,15 +1804,10 @@=0A=
 		ioc->alloc_total -=3D sz;=0A=
 	}=0A=
 =0A=
-	if (ioc->spi_data.nvram !=3D NULL) {=0A=
-		kfree(ioc->spi_data.nvram);=0A=
-		ioc->spi_data.nvram =3D NULL;=0A=
-	}=0A=
-=0A=
-	if (ioc->spi_data.pIocPg3 !=3D NULL) {=0A=
-		kfree(ioc->spi_data.pIocPg3);=0A=
-		ioc->spi_data.pIocPg3 =3D NULL;=0A=
-	}=0A=
+	kfree(ioc->spi_data.nvram);=0A=
+	kfree(ioc->spi_data.pIocPg3);=0A=
+	ioc->spi_data.nvram =3D NULL;=0A=
+	ioc->spi_data.pIocPg3 =3D NULL;=0A=
 =0A=
 	if (ioc->spi_data.pIocPg4 !=3D NULL) {=0A=
 		sz =3D ioc->spi_data.IocPg4Sz;=0A=
@@ -1829,10 +1824,8 @@=0A=
 		ioc->ReqToChain =3D NULL;=0A=
 	}=0A=
 =0A=
-	if (ioc->ChainToChain !=3D NULL) {=0A=
-		kfree(ioc->ChainToChain);=0A=
-		ioc->ChainToChain =3D NULL;=0A=
-	}=0A=
+	kfree(ioc->ChainToChain);=0A=
+	ioc->ChainToChain =3D NULL;=0A=
 }=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -4364,10 +4357,8 @@=0A=
 =0A=
 	/* Free the old page=0A=
 	 */=0A=
-	if (ioc->spi_data.pIocPg3) {=0A=
-		kfree(ioc->spi_data.pIocPg3);=0A=
-		ioc->spi_data.pIocPg3 =3D NULL;=0A=
-	}=0A=
+	kfree(ioc->spi_data.pIocPg3);=0A=
+	ioc->spi_data.pIocPg3 =3D NULL;=0A=
 =0A=
 	/* There is at least one physical disk.=0A=
 	 * Read and save IOC Page 3=0A=
diff -uarN b/drivers/message/fusion/mptctl.c =
a/drivers/message/fusion/mptctl.c=0A=
--- b/drivers/message/fusion/mptctl.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptctl.c	2005-05-10 14:27:13.000000000 =
-0600=0A=
@@ -99,14 +99,14 @@=0A=
  * arg contents specific to function.=0A=
  */=0A=
 static int mptctl_fw_download(unsigned long arg);=0A=
-static int mptctl_getiocinfo (unsigned long arg, unsigned int cmd);=0A=
-static int mptctl_gettargetinfo (unsigned long arg);=0A=
-static int mptctl_readtest (unsigned long arg);=0A=
-static int mptctl_mpt_command (unsigned long arg);=0A=
-static int mptctl_eventquery (unsigned long arg);=0A=
-static int mptctl_eventenable (unsigned long arg);=0A=
-static int mptctl_eventreport (unsigned long arg);=0A=
-static int mptctl_replace_fw (unsigned long arg);=0A=
+static int mptctl_getiocinfo(unsigned long arg, unsigned int cmd);=0A=
+static int mptctl_gettargetinfo(unsigned long arg);=0A=
+static int mptctl_readtest(unsigned long arg);=0A=
+static int mptctl_mpt_command(unsigned long arg);=0A=
+static int mptctl_eventquery(unsigned long arg);=0A=
+static int mptctl_eventenable(unsigned long arg);=0A=
+static int mptctl_eventreport(unsigned long arg);=0A=
+static int mptctl_replace_fw(unsigned long arg);=0A=
 =0A=
 static int mptctl_do_reset(unsigned long arg);=0A=
 static int mptctl_hp_hostinfo(unsigned long arg, unsigned int cmd);=0A=
@@ -121,11 +121,11 @@=0A=
 /*=0A=
  * Private function calls.=0A=
  */=0A=
-static int mptctl_do_mpt_command (struct mpt_ioctl_command karg, void =
__user *mfPtr);=0A=
+static int mptctl_do_mpt_command(struct mpt_ioctl_command karg, void =
__user *mfPtr);=0A=
 static int mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t =
fwlen);=0A=
-static MptSge_t *kbuf_alloc_2_sgl( int bytes, u32 dir, int sge_offset, =
int *frags,=0A=
+static MptSge_t *kbuf_alloc_2_sgl(int bytes, u32 dir, int sge_offset, =
int *frags,=0A=
 		struct buflist **blp, dma_addr_t *sglbuf_dma, MPT_ADAPTER *ioc);=0A=
-static void kfree_sgl( MptSge_t *sgl, dma_addr_t sgl_dma,=0A=
+static void kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma,=0A=
 		struct buflist *buflist, MPT_ADAPTER *ioc);=0A=
 static void mptctl_timeout_expired (MPT_IOCTL *ioctl);=0A=
 static int  mptctl_bus_reset(MPT_IOCTL *ioctl);=0A=
diff -uarN b/drivers/message/fusion/mptlan.c =
a/drivers/message/fusion/mptlan.c=0A=
--- b/drivers/message/fusion/mptlan.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptlan.c	2005-05-10 14:27:13.000000000 =
-0600=0A=
@@ -538,8 +538,8 @@=0A=
 		}=0A=
 	}=0A=
 =0A=
-	kfree (priv->RcvCtl);=0A=
-	kfree (priv->mpt_rxfidx);=0A=
+	kfree(priv->RcvCtl);=0A=
+	kfree(priv->mpt_rxfidx);=0A=
 =0A=
 	for (i =3D 0; i < priv->tx_max_out; i++) {=0A=
 		if (priv->SendCtl[i].skb !=3D NULL) {=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2005-04-25 15:45:54.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptscsih.c	2005-05-10 14:27:13.000000000 =
-0600=0A=
@@ -998,20 +998,17 @@=0A=
 		hd->ScsiLookup =3D NULL;=0A=
 	}=0A=
 =0A=
-	if (hd->Targets !=3D NULL) {=0A=
-		/*=0A=
-		 * Free pointer array.=0A=
-		 */=0A=
-		kfree(hd->Targets);=0A=
-		hd->Targets =3D NULL;=0A=
-	}=0A=
+	/*=0A=
+	 * Free pointer array.=0A=
+	 */=0A=
+	kfree(hd->Targets);=0A=
+	hd->Targets =3D NULL;=0A=
 =0A=
 	dprintk((MYIOC_s_INFO_FMT=0A=
 	    "Free'd ScsiLookup (%d) memory\n",=0A=
 	    hd->ioc->name, sz1));=0A=
 =0A=
-	if (hd->info_kbuf !=3D NULL)=0A=
-		kfree(hd->info_kbuf);=0A=
+	kfree(hd->info_kbuf);=0A=
 =0A=
 	/* NULL the Scsi_Host pointer=0A=
 	 */=0A=

------_=_NextPart_000_01C55650.18B73740--
