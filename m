From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic7-triple x build fixed in kbuild.git
Date: Thu, 06 Dec 2007 08:44:45 +0100
Message-ID: <4757A86D.4010507@suse.de>
References: <20071204213301.GA32214@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:40358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbXLFHot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Dec 2007 02:44:49 -0500
In-Reply-To: <20071204213301.GA32214@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vegard Nossum <vegard.nossum@gmail.com>, linux-scsi@vger.kernel.org

Sam Ravnborg wrote:
> akpm reported that:
> make mrproper
> make allmodconfig
> make drivers/scsi/aic7xxx/
>=20
> were broken in recent kbuild.git - and as a logical consequence
> removed kbuild.git from his -mm lineup.
>=20
> I have now fixed it (stupid bug I made) and pushed out
> a fresh kbuild.git tree.
>=20
> As previously announced I am not very active in kbuild land the next
> couple of weeks so I may be slow if there is any comments.
>=20
> The fixed commit is included below.
>=20
> 	Sam
>=20
> commit 63b7c4e77e9204407ee8a5d5243ba9c502550252
> Author: Vegard Nossum <vegard.nossum@gmail.com>
> Date:   Fri Oct 26 13:31:13 2007 +0200
>=20
>     aic7(3*x): fix firmware build
>    =20
>     This patch adds the proper $(obj) and $(src) prefixes to dependen=
cy
>     rules in aic7xxx makefile. Without this patch, there is a remote
>     possibility that parallel make with a different output directory =
can
>     fail.
>    =20
>     Also changed the deprecated EXTRA_CFLAGS construct to ccflags-y s=
yntax.
>    =20
>     Fixed up patch to survive "make drivers/scsi/ -j"
>     with BUILD_FIRMWARE enable. /Sam
>    =20
>     Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>     Cc: linux-scsi@vger.kernel.org
>=20
> diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Mak=
efile
> index 9a6ce19..e4f70c5 100644
> --- a/drivers/scsi/aic7xxx/Makefile
> +++ b/drivers/scsi/aic7xxx/Makefile
> @@ -33,11 +33,10 @@ aic79xx-y					+=3D aic79xx_osm.o	\
>  						   aic79xx_proc.o	\
>  						   aic79xx_osm_pci.o
> =20
> -EXTRA_CFLAGS +=3D -Idrivers/scsi
> +ccflags-y +=3D -Idrivers/scsi
>  ifdef WARNINGS_BECOME_ERRORS
> -EXTRA_CFLAGS +=3D -Werror
> +ccflags-y +=3D -Werror
>  endif
> -#EXTRA_CFLAGS +=3D -g
> =20
>  # Files generated that shall be removed upon make clean
>  clean-files :=3D aic7xxx_seq.h aic7xxx_reg.h aic7xxx_reg_print.c
> @@ -46,53 +45,45 @@ clean-files +=3D aic79xx_seq.h aic79xx_reg.h aic7=
9xx_reg_print.c
>  # Dependencies for generated files need to be listed explicitly
> =20
>  $(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
> +$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_reg.h
>  $(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
> -$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
> -$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
> +$(obj)/aic79xx_core.o: $(obj)/aic79xx_reg.h
> =20
> -$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_reg.h
> -$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_reg.h
> +$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h
> +$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h
> =20
> -aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:=3D $(obj)/aic7xxx_seq=
=2Eh \
> -						   $(obj)/aic7xxx_reg.h
> +aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:=3D $(obj)/aic7xxx_reg=
=2Eh
>  aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+=3D $(obj)/aic7xxx_r=
eg_print.c
> =20
>  aicasm-7xxx-opts-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT) :=3D \
>  	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h
> =20
>  ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
> -# Create a dependency chain in generated files
> -# to avoid concurrent invocations of the single
> -# rule that builds them all.
> -aic7xxx_seq.h: aic7xxx_reg.h
> -ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
> -aic7xxx_reg.h: aic7xxx_reg_print.c
> -endif
> -$(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicas=
m/aicasm
> +$(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/a=
icasm/aicasm
>  	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
>  			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
>  			      $(src)/aic7xxx.seq
> +
> +$(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
> +else
> +$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
>  endif
> =20
> -aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:=3D $(obj)/aic79xx_seq=
=2Eh \
> -						   $(obj)/aic79xx_reg.h
> +aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:=3D $(obj)/aic79xx_reg=
=2Eh
>  aic79xx-gen-$(CONFIG_AIC79XX_REG_PRETTY_PRINT)	+=3D $(obj)/aic79xx_r=
eg_print.c
> =20
>  aicasm-79xx-opts-$(CONFIG_AIC79XX_REG_PRETTY_PRINT) :=3D \
>  	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h
> =20
>  ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
> -# Create a dependency chain in generated files
> -# to avoid concurrent invocations of the single
> -# rule that builds them all.
> -aic79xx_seq.h: aic79xx_reg.h
> -ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
> -aic79xx_reg.h: aic79xx_reg_print.c
> -endif
> -$(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicas=
m/aicasm
> +$(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/a=
icasm/aicasm
>  	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
>  			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
>  			      $(src)/aic79xx.seq
> +
> +$(aic79xx-gen-y): $(obj)/aic79xx_seq.h
> +else
> +$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
>  endif
> =20
>  $(obj)/aicasm/aicasm: $(src)/aicasm/*.[chyl]

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
