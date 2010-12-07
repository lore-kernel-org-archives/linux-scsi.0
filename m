From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
Date: Wed, 08 Dec 2010 02:24:53 +0900
Message-ID: <1291742693.1638.22.camel@leonhard>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:60491 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0LGRZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2010 12:25:03 -0500
In-Reply-To: <1291739449.17668.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

2010-12-07 (=ED=99=94), 10:30 -0600, James Bottomley:
> On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE=
) so
> > allyesconfig build always emits the warnings. Possible patch for th=
is
> > would be wraping it up in #ifdefs but when I sent a same patch to G=
reg
> > KH he didn't want to add more #ifdefs in .c files.
>=20
> I didn't mean changing any c files.  I meant fixing the module includ=
e
> to make the table used even in the !MODULE case.  That way we only al=
ter
> one file instead of a significant proportion of the drivers.
>=20

It would not be a _significant_ proportion because normal drivers may
refer the table in their driver struct. :)

Anyway the patch below looks good to me. I'll happily drop my patches i=
f
you apply this in your tree.

Thanks.

>=20
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 7575bbb..d49aa9c 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -90,7 +90,10 @@ extern const struct gtype##_id __mod_##gtype##_tab=
le		\
>  extern struct module __this_module;
>  #define THIS_MODULE (&__this_module)
>  #else  /* !MODULE */
> -#define MODULE_GENERIC_TABLE(gtype,name)
> +/* Flag name as used to avoid warnings about the unused device id ta=
ble */
> +#define MODULE_GENERIC_TABLE(gtype,name)			\
> +static const struct gtype##_id __mod_##gtype##_table		\
> +  __attribute__ ((unused, alias(__stringify(name))))
>  #define THIS_MODULE ((struct module *)0)
>  #endif
> =20


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
