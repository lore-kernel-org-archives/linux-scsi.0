From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v2] advansys: fix regression with request_firmware
 change
Date: Mon, 29 Mar 2010 19:16:05 -0400
Message-ID: <1269904565.22206.3.camel@mulgrave.site>
References: <201003262005.09121.herton@mandriva.com.br>
	 <201003291736.31066.herton@mandriva.com.br>
	 <201003291749.08246.herton@mandriva.com.br>
	 <201003291822.49062.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2XQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2010 19:16:13 -0400
In-Reply-To: <201003291822.49062.herton@mandriva.com.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Mon, 2010-03-29 at 18:22 -0300, Herton Ronaldo Krzesinski wrote:
> Em Seg 29 Mar 2010, =C3=A0s 17:49:08, Herton Ronaldo Krzesinski escre=
veu:
> > Em Seg 29 Mar 2010, =C3=A0s 17:36:30, Herton Ronaldo Krzesinski esc=
reveu:
> > > Em Dom 28 Mar 2010, =C3=A0s 12:25:20, James Bottomley escreveu:
> > > > On Fri, 2010-03-26 at 20:05 -0300, Herton Ronaldo Krzesinski wr=
ote:
> >=20
> > <snip>
> >=20
> > > > This is both nasty and not really a fix:  the overrun buf is st=
ill
> > > > mapped many times on the reset path and only ever unmapped once=
, which
> > > > is still an unfixed bug in this code.  I think the map needs to=
 be moved
> > > > out of AscInitMicroCodeVar() to somewhere in here.
> > >=20
> > > I didn't want to do this since I think there will be much changes=
 and I can't
> > > test properly as I don't have the hardware (also may be too much =
for what
> > > looks like a legacy driver/hardware). But I aggree this if is ugl=
y and not
> > > unmapping when needed on reset. What I thought can be better is t=
his, to fix
> > > error handling also on AscInitMicroCodeVar then:
> >=20
> > Sorry the diff had some typos (didn't test it), but was only for th=
e idea
>=20
> Damn, and in the diff I also forgot about dma unmap on scsi_add_host =
error...
> please consider version below, also compile tested:
>=20
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 9201afe..43289e8 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -460,6 +460,7 @@ typedef struct asc_risc_sg_list_q {
>  #define ASC_IERR_BIST_PRE_TEST		0x0800	/* BIST pre-test error */
>  #define ASC_IERR_BIST_RAM_TEST		0x1000	/* BIST RAM test error */
>  #define ASC_IERR_BAD_CHIPTYPE		0x2000	/* Invalid chip_type setting *=
/
> +#define ASC_IERR_DMA_MAP_SINGLE 	0x4000  /* Error with dma_map_singl=
e */

You don't actually need another flag for this.  asc_board is in
shost_priv and, as such, is zero initialised, so you can rely on
overrun_dma being NULL unless it's mapped on a narrow board.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
