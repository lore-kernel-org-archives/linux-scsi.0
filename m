From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [PATCH v2] advansys: fix regression with request_firmware change
Date: Tue, 30 Mar 2010 13:35:38 -0300
Message-ID: <201003301335.39002.herton@mandriva.com.br>
References: <201003262005.09121.herton@mandriva.com.br> <201003291822.49062.herton@mandriva.com.br> <1269904565.22206.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:57847 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0C3Qfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 12:35:44 -0400
In-Reply-To: <1269904565.22206.3.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Em Seg 29 Mar 2010, =C3=A0s 20:16:05, James Bottomley escreveu:
> On Mon, 2010-03-29 at 18:22 -0300, Herton Ronaldo Krzesinski wrote:
> > Em Seg 29 Mar 2010, =C3=A0s 17:49:08, Herton Ronaldo Krzesinski esc=
reveu:
> > > Em Seg 29 Mar 2010, =C3=A0s 17:36:30, Herton Ronaldo Krzesinski e=
screveu:
> > > > Em Dom 28 Mar 2010, =C3=A0s 12:25:20, James Bottomley escreveu:
> > > > > On Fri, 2010-03-26 at 20:05 -0300, Herton Ronaldo Krzesinski =
wrote:
> > >=20
> > > <snip>
> > >=20
> > > > > This is both nasty and not really a fix:  the overrun buf is =
still
> > > > > mapped many times on the reset path and only ever unmapped on=
ce, which
> > > > > is still an unfixed bug in this code.  I think the map needs =
to be moved
> > > > > out of AscInitMicroCodeVar() to somewhere in here.
> > > >=20
> > > > I didn't want to do this since I think there will be much chang=
es and I can't
> > > > test properly as I don't have the hardware (also may be too muc=
h for what
> > > > looks like a legacy driver/hardware). But I aggree this if is u=
gly and not
> > > > unmapping when needed on reset. What I thought can be better is=
 this, to fix
> > > > error handling also on AscInitMicroCodeVar then:
> > >=20
> > > Sorry the diff had some typos (didn't test it), but was only for =
the idea
> >=20
> > Damn, and in the diff I also forgot about dma unmap on scsi_add_hos=
t error...
> > please consider version below, also compile tested:
> >=20
> > diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> > index 9201afe..43289e8 100644
> > --- a/drivers/scsi/advansys.c
> > +++ b/drivers/scsi/advansys.c
> > @@ -460,6 +460,7 @@ typedef struct asc_risc_sg_list_q {
> >  #define ASC_IERR_BIST_PRE_TEST		0x0800	/* BIST pre-test error */
> >  #define ASC_IERR_BIST_RAM_TEST		0x1000	/* BIST RAM test error */
> >  #define ASC_IERR_BAD_CHIPTYPE		0x2000	/* Invalid chip_type setting=
 */
> > +#define ASC_IERR_DMA_MAP_SINGLE 	0x4000  /* Error with dma_map_sin=
gle */
>=20
> You don't actually need another flag for this.  asc_board is in
> shost_priv and, as such, is zero initialised, so you can rely on
> overrun_dma being NULL unless it's mapped on a narrow board.

Ok, this is new diff avoiding adding an extra flag:

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9201afe..7f87979 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4724,6 +4724,10 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *a=
sc_dvc)
 	BUG_ON((unsigned long)asc_dvc->overrun_buf & 7);
 	asc_dvc->overrun_dma =3D dma_map_single(board->dev, asc_dvc->overrun_=
buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
+		warn_code =3D -ENOMEM;
+		goto err_dma_map;
+	}
 	phy_addr =3D cpu_to_le32(asc_dvc->overrun_dma);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
 				 (uchar *)&phy_addr, 1);
@@ -4739,14 +4743,23 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *=
asc_dvc)
 	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
 	if (AscGetPCAddr(iop_base) !=3D ASC_MCODE_START_ADDR) {
 		asc_dvc->err_code |=3D ASC_IERR_SET_PC_ADDR;
-		return warn_code;
+		warn_code =3D UW_ERR;
+		goto err_mcode_start;
 	}
 	if (AscStartChip(iop_base) !=3D 1) {
 		asc_dvc->err_code |=3D ASC_IERR_START_STOP_CHIP;
-		return warn_code;
+		warn_code =3D UW_ERR;
+		goto err_mcode_start;
 	}
=20
 	return warn_code;
+
+err_mcode_start:
+	dma_unmap_single(board->dev, asc_dvc->overrun_dma,
+			 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+err_dma_map:
+	asc_dvc->overrun_dma =3D 0;
+	return warn_code;
 }
=20
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -4802,6 +4815,8 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *a=
sc_dvc)
 	}
 	release_firmware(fw);
 	warn_code |=3D AscInitMicroCodeVar(asc_dvc);
+	if (!asc_dvc->overrun_dma)
+		return warn_code;
 	asc_dvc->init_state |=3D ASC_INIT_STATE_END_LOAD_MC;
 	AscEnableInterrupt(iop_base);
 	return warn_code;
@@ -7978,9 +7993,10 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		status =3D AscInitAsc1000Driver(asc_dvc);
=20
 		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
-		if (asc_dvc->err_code) {
+		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset error: "
-				    "0x%x\n", asc_dvc->err_code);
+				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
+				    status);
 			ret =3D FAILED;
 		} else if (status) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset warning: "
@@ -12311,7 +12327,7 @@ static int __devinit advansys_board_found(struc=
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
@@ -12320,30 +12336,36 @@ static int __devinit advansys_board_found(str=
uct Scsi_Host *shost,
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code) {
+			if (!asc_dvc_varp->overrun_dma) {
 				ret =3D -ENODEV;
-				kfree(asc_dvc_varp->overrun_buf);
+				goto err_free_mem;
 			}
 		}
 	} else {
-		if (advansys_wide_init_chip(shost))
+		if (advansys_wide_init_chip(shost)) {
 			ret =3D -ENODEV;
+			goto err_free_mem;
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
+		goto err_free_mem;
=20
 	scsi_scan_host(shost);
 	return 0;
=20
- err_free_wide_mem:
-	advansys_wide_free_mem(boardp);
+ err_free_mem:
+	if (ASC_NARROW_BOARD(boardp)) {
+		if (asc_dvc_varp->overrun_dma)
+			dma_unmap_single(boardp->dev, asc_dvc_varp->overrun_dma,
+					 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
+	} else
+		advansys_wide_free_mem(boardp);
+ err_free_irq:
 	free_irq(boardp->irq, shost);
  err_free_dma:
 #ifdef CONFIG_ISA


>=20
> James
>=20
>=20
>=20

--=20
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
