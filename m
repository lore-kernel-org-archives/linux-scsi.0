Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D723C943B;
	Wed, 27 May 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867783; cv=none; b=r9K1305kFwrOoId8T8MMJYjQN0/Yc0rY25EVOtHeTMGuO7d8zgkr6gqcbXaSKvwm0YtzIefsoZssdEnFxFbxfILrB2ExX7sdwOKsXXL0xmgO3seT0oC9cIGu9sKQV5ehdNT8bhNx1NclL2dJW3xkMoTH84mSHAp7BFuO2qyYZT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867783; c=relaxed/simple;
	bh=klF5ZMVluVPlXQqUygeOot5OisfLZO2JpSeb3OMva2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q684ISHc6avS30vOsy5rcogh90EYZ+DpqyQw7TTTCjJ8hGfRmDW5NcTBxyMpu2VsTTGgVvgukLl4jPfID8qGLY3IfgH1RZSkDc+CYH01Ij+b0QXH8eP250kxbbXZL7oiKSnNEzywsf2APVD1FlxzCxwX89O90+Qcd43ciszmy30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bs+lCfYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bs+lCfYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE1B1F000E9;
	Wed, 27 May 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779867781;
	bh=L4l/SWpNgNVYP85CML5uEJDa5fjqq3vqghd2CxOwqzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bs+lCfYyteZpYpfPKKTQJYgH8iKKRRnsWtk3P4WlmOY5BEYIW0oiTZB3V8BDD1+XT
	 Jqm7TGqf505o9qc+MuEBF1K1Fv0vwRCmjFThAjleGzQH1tfTHu81OYp/YnVG/K219F
	 537D4AuSuPyy42ibo7p0Pc3cRLlGbavYFu/7jAiTNtls7mGuKv9jCntOUC7vUR3VcO
	 s3OXpF3UqOrWoQSvNAYXT4qvPXppCNK70zbns+O1NCO7aaNfpyxLtQOrAyOJRf6zAq
	 vLyZXjs13NeC3zTnWfGs42y6i7g0hpRsnPaOmKz/Xve4/Z6C2RcXh5ji3OKfvOLO7r
	 VxI6hMWmDqj9Q==
Date: Wed, 27 May 2026 09:42:56 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1 1/8] ata: pata_budda: Use named initializer for
 zorro_device_id
Message-ID: <ahaggIq9eD8UjONu@ryzen>
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
 <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>

On Tue, May 26, 2026 at 04:17:27PM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> Using named initializers is more explicit and thus easier to parse for a
> human.
> 
> It's also more robust to changes in the struct definition. This robustness
> is relevant for a planned change to struct zorro_device_id that replaces
> .driver_data by an anonymous union.
> 
> This change doesn't introduce changes to the compiled zorro_device_id
> array.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
> ---
>  drivers/ata/pata_buddha.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/pata_buddha.c b/drivers/ata/pata_buddha.c
> index c36ee991d5e5..3b1f0ee2f875 100644
> --- a/drivers/ata/pata_buddha.c
> +++ b/drivers/ata/pata_buddha.c
> @@ -253,9 +253,9 @@ static void pata_buddha_remove(struct zorro_dev *z)
>  }
>  
>  static const struct zorro_device_id pata_buddha_zorro_tbl[] = {
> -	{ ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA, BOARD_BUDDHA},
> -	{ ZORRO_PROD_INDIVIDUAL_COMPUTERS_CATWEASEL, BOARD_CATWEASEL},
> -	{ 0 }
> +	{ .id = ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA, .driver_data = BOARD_BUDDHA },
> +	{ .id = ZORRO_PROD_INDIVIDUAL_COMPUTERS_CATWEASEL, .driver_data = BOARD_CATWEASEL },
> +	{ }
>  };
>  MODULE_DEVICE_TABLE(zorro, pata_buddha_zorro_tbl);
>  
> @@ -282,7 +282,7 @@ static int __init pata_buddha_late_init(void)
>  	/* Manually bind to all X-Surf boards */
>  	while ((z = zorro_find_device(ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF, z))) {
>  		static struct zorro_device_id xsurf_ent = {
> -			ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF, BOARD_XSURF
> +			.id = ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF, .driver_data = BOARD_XSURF
>  		};
>  
>  		pata_buddha_probe(z, &xsurf_ent);
> -- 
> 2.47.3
> 

Okay for this patch to go via SCSI as suggested by Uwe in the cover-letter:

Acked-by: Niklas Cassel <cassel@kernel.org>
