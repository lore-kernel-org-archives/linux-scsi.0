From: Adrian Bunk <bunk@kernel.org>
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Date: Sat, 17 May 2008 17:17:49 +0300
Message-ID: <20080517141749.GD3284@cs181133002.pp.htv.fi>
References: <200805161906.19321.toralf.foerster@gmx.de> <1211018673.3603.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53676 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYEQOTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2008 10:19:43 -0400
Content-Disposition: inline
In-Reply-To: <1211018673.3603.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley wrote:
> On Fri, 2008-05-16 at 19:06 +0200, Toralf F=C3=B6rster wrote:
> > Hello,
> >=20
> > the build (.config attached) failed, make ends with :
> > ...
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      vmlinux
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33bab): undefined reference to `request_firmware'
> > drivers/built-in.o: In function `sas_request_addr':
> > (.text+0x33c3f): undefined reference to `release_firmware'
> > make: *** [vmlinux] Error 1
>=20
> There's a slight fault in the stub logic.  It fails for FW_LOADER=3Dm=
 and
> the user =3Dy.
>=20
> This should fix it.

An interesting question is whether we actually want to have the stub at=
=20
all - the compile errors catched cases where someone forgot to select=20
=46W_LOADER at compile time instead of turning them into possible runti=
me=20
problems as will happen after your patch.

Are there any serious use cases where SCSI_SAS_LIBSAS is used in very=20
space limited environments and without any other drivers that select=20
=46W_LOADER in the kernel?

> James
>=20
> ---
>=20
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 4d10c73..6c7eff2 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -13,7 +13,7 @@ struct firmware {
> =20
>  struct device;
> =20
> -#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
> +#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) &=
& defined(MODULE))
>  int request_firmware(const struct firmware **fw, const char *name,
>  		     struct device *device);
>  int request_firmware_nowait(

cu
Adrian

--=20

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
