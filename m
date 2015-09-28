From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 07/32] cxlflash: Fix context encode mask width
Date: Tue, 29 Sep 2015 08:39:07 +1000
Message-ID: <87k2rauq2c.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222847-9190-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34397 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbI1WjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2015 18:39:22 -0400
Received: by padhy16 with SMTP id hy16so185930420pad.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 15:39:22 -0700 (PDT)
In-Reply-To: <1443222847-9190-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


Looks good to me.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

"Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:

> The context encode mask covers more than 32-bits, making it
> a long integer. This should be noted by appending the ULL
> width suffix to the mask.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/superpipe.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> index 72d53cf..7947091 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -87,7 +87,7 @@ enum ctx_ctrl {
>  	CTX_CTRL_FILE		= (1 << 5)
>  };
>  
> -#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0) << 28) | _id)
> +#define ENCODE_CTXID(_ctx, _id)	(((((u64)_ctx) & 0xFFFFFFFF0ULL) << 28) | _id)
>  #define DECODE_CTXID(_val)	(_val & 0xFFFFFFFF)
>  
>  struct ctx_info {
> -- 
> 2.1.0
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWCcGLAAoJEPC3R3P2I92FJ1kP/juiS2a5hBDOGjVliW6KlWK6
pb9yRZ1qmvgiL1xtMO/rfSEEb/kwO6QSbDcKqLtKwI24DBkVF2eDAOo9mOKKNhBI
EF/AwZsvG1DE3o0+AAx3mY7+AO1rP+uZSvCJf5GvDDdSfYXfq5f49+aM6HJ0n130
ewlQmOnwwGDpO2gehccrDSmSbUB1CwKY1uQ5KtczGqdtfkgSu7YVRHKiNiid9Nop
uJWDE452NBm2dM5Jf2hXFXwMSzx9bbmM5Ue27gf1HES8CGw3Z2BQtYIx6tjHLYH/
Rj4dPSLBjuBeEI4YZHqxkYs3ipBV38wRwuG0O5o+YKUD6TczeYtwwCVAmma8pTm2
tYT8xrY19Ng3oQ1P68zxP4D5uYbdFhIOyqLhss9Lnas0VxzZUbdfiuF4V8ABSGTz
L8WFw2ff/73LtVaSr/KGyt1RvfLpoEFxkYd3+sGwsfqM/HyC2K3g4RZucLct1oeX
PPPKz5ZQF9K/R/mKJEIAG+Fh0usryj97Wgf+r3Ie0QQDorOoG+8itGg0OJ0o1ojV
wjduJiwsoD+2HwnTw85TwSp6PPY+8o7Gml1PvfGUFWJjPgSUkcQ6L3lrispE4twt
hgrWSsRE/GO5+JD9KNSYnKr8dRxD6iDFefppZv64nWJKi11PZoz7z09Q+dE1KAng
jpNUi5wyGph2AwD7E9I2
=M1UV
-----END PGP SIGNATURE-----
