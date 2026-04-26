Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6130FF26;
	Sun, 26 Apr 2026 23:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777245285; cv=none; b=EOc5GbgULq/e6eskh3/XjEL4BlJ87UkqMZIXkhbIQz2QtAVFbDwrLkbuZka1tu6vz3uD7feLWVV5r77owqgTIxD9CzuMW2fcIGzKVIHLF35Oz+tL93VlUyr9SVQQNFAWLoWoowoyCCDp3tKDQ+cDDMX6oP7DO5Dod/Fv+H/axsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777245285; c=relaxed/simple;
	bh=fNSO0ZiQYKIxczq5E447tSJrJsB+pPyxyTsjeRVyg24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHlKz2m/EJsZzaZJeRIr3cGnA2hYzSz/IgNMVd0qy9KVm9/uw16VxvHuR4OVwItKZ5a+SETllaDOr6JMeFO1ItUnK3ZcNC7yTET/SmnqMLyS2/vlCrX7PbQRgq7QOCwYMWdZuLhmjaWzFJGbeoy7QlhBtsqscCd52GjYwqQJdzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWq5jeI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWq5jeI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96729C2BCAF;
	Sun, 26 Apr 2026 23:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245284;
	bh=fNSO0ZiQYKIxczq5E447tSJrJsB+pPyxyTsjeRVyg24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SWq5jeI7JhgG4vS+sXVmnpYtn6b+4shQZY0inklzt5G2xq7Y0UH7Y4tmMlOoz8AT6
	 6vjEu6+GGRUL7Z33WgaL+ByDzD3SEfKktwB0zFmC4QpgpePq3pPZZtXb/GuEuvd++y
	 x75ydyvaLFAMpVIuyVKYaU6l5KI21t7RabC2Bo7d/QJf9aO9Fj8VrI9V6FuJ8hwwaO
	 kkpnLa1Ti4o7zfq930L5oykzUGlJBpdIvfVvJ4KZCuGdK27t1ewpZmLVeysIPp0SoU
	 a4YCTRPrZJesbmX3JQDikY2M8EuOIwUedi4CL+4S1ANXLh1WItSAXtIBIedS+sZTbl
	 12raIKaWdT9rg==
Message-ID: <401b8b4a-4787-4f70-b531-0c1ddc04f86b@kernel.org>
Date: Mon, 27 Apr 2026 08:14:36 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] ata: libata-scsi: add atapi_max_lun module
 parameter
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-2-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-2-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
> so the SCSI layer never scans past LUN 0.  This blocks support for
> the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
> COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
> Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).
> 
> Introduce a libata module parameter, atapi_max_lun, that controls the
> upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
> current behaviour exactly: out-of-the-box only LUN 0 is scanned.
> Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).
> 
> Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
> device must both be on the SCSI device list (or carry the appropriate
> quirk) and run on a host whose atapi_max_lun has been raised before
> any extra LUNs are scanned.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>

This looks OK to me, but I would prefer renaming things a little:

atapi_max_lun -> atapi_max_nr_luns

to avoid confusion between the maximum LUN ID and the maximum number of LUNs
(yeah, they are only off by one, but better be clear to not trip on that).

One additional nit below.

With that fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/ata/libata-core.c | 5 +++++
>  drivers/ata/libata-scsi.c | 2 +-
>  drivers/ata/libata.h      | 1 +
>  include/linux/libata.h    | 1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 374993031895..8c279b6eb1fb 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -122,6 +122,11 @@ int atapi_passthru16 = 1;
>  module_param(atapi_passthru16, int, 0444);
>  MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>  
> +int atapi_max_lun = 1;
> +module_param(atapi_max_lun, int, 0444);
> +MODULE_PARM_DESC(atapi_max_lun,
> +	"Maximum LUN to scan on ATAPI devices flagged BLIST_FORCELUN (1 [default] .. 7)");

	"Maximum number of LUNs to scan on ATAPI devices flagged "
	"with BLIST_FORCELUN (1 [default] .. 7)");

> +
>  int libata_fua = 0;
>  module_param_named(fua, libata_fua, int, 0444);
>  MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 3b65df914ebb..d1665305b552 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4620,7 +4620,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const struct scsi_host_template *s
>  		shost->transportt = ata_scsi_transport_template;
>  		shost->unique_id = ap->print_id;
>  		shost->max_id = 16;
> -		shost->max_lun = 1;
> +		shost->max_lun = clamp(atapi_max_lun, 1, ATAPI_MAX_LUN);
>  		shost->max_channel = 1;
>  		shost->max_cmd_len = 32;
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index b5423b6e97de..96d804d02b99 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -33,6 +33,7 @@ enum {
>  #define ATA_PORT_TYPE_NAME	"ata_port"
>  
>  extern int atapi_passthru16;
> +extern int atapi_max_lun;
>  extern int libata_fua;
>  extern int libata_noacpi;
>  extern int libata_allow_tpm;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 00346ce3af5e..27b11577826e 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -131,6 +131,7 @@ enum {
>  	ATA_SHORT_PAUSE		= 16,
>  
>  	ATAPI_MAX_DRAIN		= 16 << 10,
> +	ATAPI_MAX_LUN		= 8,	/* SCSI-2 cap (LUN values 0..7) */
>  
>  	ATA_ALL_DEVICES		= (1 << ATA_MAX_DEVICES) - 1,
>  


-- 
Damien Le Moal
Western Digital Research
