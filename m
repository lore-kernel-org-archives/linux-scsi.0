From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH v2] advansys: fix regression with request_firmware change
Date: Mon, 29 Mar 2010 18:22:48 -0300
Message-ID: <201003291822.49062.herton@mandriva.com.br>
References: <201003262005.09121.herton@mandriva.com.br> <201003291736.31066.herton@mandriva.com.br> <201003291749.08246.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:42517 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0C2VWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2010 17:22:52 -0400
In-Reply-To: <201003291749.08246.herton@mandriva.com.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Em Seg 29 Mar 2010, =C3=A0s 17:49:08, Herton Ronaldo Krzesinski escreve=
u:
> Em Seg 29 Mar 2010, =C3=A0s 17:36:30, Herton Ronaldo Krzesinski escre=
veu:
> > Em Dom 28 Mar 2010, =C3=A0s 12:25:20, James Bottomley escreveu:
> > > On Fri, 2010-03-26 at 20:05 -0300, Herton Ronaldo Krzesinski wrot=
e:
>=20
> <snip>
>=20
> > > This is both nasty and not really a fix:  the overrun buf is stil=
l
> > > mapped many times on the reset path and only ever unmapped once, =
which
> > > is still an unfixed bug in this code.  I think the map needs to b=
e moved
> > > out of AscInitMicroCodeVar() to somewhere in here.
> >=20
> > I didn't want to do this since I think there will be much changes a=
nd I can't
> > test properly as I don't have the hardware (also may be too much fo=
r what
> > looks like a legacy driver/hardware). But I aggree this if is ugly =
and not
> > unmapping when needed on reset. What I thought can be better is thi=
s, to fix
> > error handling also on AscInitMicroCodeVar then:
>=20
> Sorry the diff had some typos (didn't test it), but was only for the =
idea

Damn, and in the diff I also forgot about dma unmap on scsi_add_host er=
ror...
please consider version below, also compile tested:

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9201afe..43289e8 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -460,6 +460,7 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_IERR_BIST_PRE_TEST		0x0800	/* BIST pre-test error */
 #define ASC_IERR_BIST_RAM_TEST		0x1000	/* BIST RAM test error */
 #define ASC_IERR_BAD_CHIPTYPE		0x2000	/* Invalid chip_type setting */
+#define ASC_IERR_DMA_MAP_SINGLE 	0x4000  /* Error with dma_map_single =
*/
=20
 #define ASC_DEF_MAX_TOTAL_QNG   (0xF0)
 #define ASC_MIN_TAG_Q_PER_DVC   (0x04)
@@ -4701,14 +4702,12 @@ static void AscInitQLinkVar(ASC_DVC_VAR *asc_dv=
c)
 static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
-	ushort warn_code;
 	PortAddr iop_base;
 	ASC_PADDR phy_addr;
 	ASC_DCNT phy_size;
 	struct asc_board *board =3D asc_dvc_to_board(asc_dvc);
=20
 	iop_base =3D asc_dvc->iop_base;
-	warn_code =3D 0;
 	for (i =3D 0; i <=3D ASC_MAX_TID; i++) {
 		AscPutMCodeInitSDTRAtID(iop_base, i,
 					asc_dvc->cfg->sdtr_period_offset[i]);
@@ -4724,6 +4723,10 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *a=
sc_dvc)
 	BUG_ON((unsigned long)asc_dvc->overrun_buf & 7);
 	asc_dvc->overrun_dma =3D dma_map_single(board->dev, asc_dvc->overrun_=
buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
+		asc_dvc->err_code |=3D ASC_IERR_DMA_MAP_SINGLE;
+		return -ENOMEM;
+	}
 	phy_addr =3D cpu_to_le32(asc_dvc->overrun_dma);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
 				 (uchar *)&phy_addr, 1);
@@ -4739,14 +4742,19 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *=
asc_dvc)
 	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
 	if (AscGetPCAddr(iop_base) !=3D ASC_MCODE_START_ADDR) {
 		asc_dvc->err_code |=3D ASC_IERR_SET_PC_ADDR;
-		return warn_code;
+		goto err_mcode_start;
 	}
 	if (AscStartChip(iop_base) !=3D 1) {
 		asc_dvc->err_code |=3D ASC_IERR_START_STOP_CHIP;
-		return warn_code;
+		goto err_mcode_start;
 	}
=20
-	return warn_code;
+	return 0;
+
+err_mcode_start:
+	dma_unmap_single(board->dev, asc_dvc->overrun_dma,
+			 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	return UW_ERR;
 }
=20
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -4802,6 +4810,8 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *a=
sc_dvc)
 	}
 	release_firmware(fw);
 	warn_code |=3D AscInitMicroCodeVar(asc_dvc);
+	if (asc_dvc->err_code !=3D 0)
+		return warn_code;
 	asc_dvc->init_state |=3D ASC_INIT_STATE_END_LOAD_MC;
 	AscEnableInterrupt(iop_base);
 	return warn_code;
@@ -12311,7 +12321,7 @@ static int __devinit advansys_board_found(struc=
t Scsi_Host *shost,
 		asc_dvc_varp->overrun_buf =3D kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL)=
;
 		if (!asc_dvc_varp->overrun_buf) {
 			ret =3D -ENOMEM;
-			goto err_free_wide_mem;
+			goto err_free_irq;
 		}
 		warn_code =3D AscInitAsc1000Driver(asc_dvc_varp);
=20
@@ -12323,27 +12333,34 @@ static int __devinit advansys_board_found(str=
uct Scsi_Host *shost,
 			if (asc_dvc_varp->err_code) {
 				ret =3D -ENODEV;
 				kfree(asc_dvc_varp->overrun_buf);
+				goto err_free_irq;
 			}
 		}
 	} else {
-		if (advansys_wide_init_chip(shost))
+		if (advansys_wide_init_chip(shost)) {
 			ret =3D -ENODEV;
+			advansys_wide_free_mem(boardp);
+			goto err_free_irq;
+		}
 	}
=20
-	if (ret)
-		goto err_free_wide_mem;
-
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
=20
 	ret =3D scsi_add_host(shost, boardp->dev);
 	if (ret)
-		goto err_free_wide_mem;
+		goto err_add_host;
=20
 	scsi_scan_host(shost);
 	return 0;
=20
- err_free_wide_mem:
-	advansys_wide_free_mem(boardp);
+ err_add_host:
+	if (ASC_NARROW_BOARD(boardp)) {
+		dma_unmap_single(boardp->dev, asc_dvc_varp->overrun_dma,
+				 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
+	} else
+		advansys_wide_free_mem(boardp);
+ err_free_irq:
 	free_irq(boardp->irq, shost);
  err_free_dma:
 #ifdef CONFIG_ISA


--=20
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
