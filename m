From: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 16:17:20 +0100
Message-ID: <200902221617.21621.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <m1iqn2ein5.fsf@fess.ebiederm.org>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sonntag 22 Februar 2009 13:54:54 Eric W. Biederman wrote:
> Prakesh could you try this patch instead?
>
> I think the problem is simply that the MCP55 ht mapping capability
> requires an address to be programed into it and it wasn't in your
> case.
>
> It should not hurt to enable one msi ht mapping capability too many.

I tried it, but unfortunately doesn't help. I run into the same issue.

>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index baad093..f7a0370 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2017,10 +2017,19 @@ static void __devinit ht_enable_msi_mapping(struct
> pci_dev *dev) while (pos && ttl--) {
>  		u8 flags;
>
> -		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
> -					 &flags) == 0) {
> +		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags))
> +			return;
> +
> +		if (!(flags & HT_MSI_FLAGS_ENABLE)) {
>  			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
>
> +			if (!(flags & HT_MSI_FLAGS_FIXED)) {
> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_LO,
> +					(HT_MSI_FIXED_ADDR & HT_MSI_FIXED_ADDR));
> +				pci_write_config_dword(dev, pos + HT_MSI_ADDR_HI,
> +					(HT_MSI_FIXED_ADDR >> 32));
> +			}
> +
>  			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
>  					      flags | HT_MSI_FLAGS_ENABLE);
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
