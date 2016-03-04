From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v10 5/6] add TC G210 platform driver
Date: Fri, 04 Mar 2016 22:12:45 +0100
Message-ID: <2253265.cRVI7LPIKe@wuerfel>
References: <cover.1457111366.git.jpinto@synopsys.com> <cc5666f44c532b31dee1a1c8d12157173e69f9e2.1457111366.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cc5666f44c532b31dee1a1c8d12157173e69f9e2.1457111366.git.jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Friday 04 March 2016 17:22:18 Joao Pinto wrote:
> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
> 
> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>

Looks basically ok, but I think it can be simplified a little:

> +/**
> + * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
> + */
> +static struct ufs_hba_variant_ops tc_dwc_g210_pltfm_hba_vops = {
> +	.name                   = "tc-dwc-g210-pltfm",
> +	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
> +};
> +
> +/**
> + * tc_dwc_g210_pltfm_probe()
> + * @pdev: pointer to platform device structure
> + *
> + */
> +static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +
> +	/* Check Test Chip type and set the specific setup routine */
> +	if (of_device_is_compatible(np, "snps, g210-tc-6.00-20bit")) {
> +		tc_dwc_g210_pltfm_hba_vops.custom_phy_initialization =
> +						tc_dwc_g210_config_20_bit;
> +	} else if (of_device_is_compatible(np, "snps, g210-tc-6.00-40bit")) {
> +		tc_dwc_g210_pltfm_hba_vops.custom_phy_initialization =
> +						tc_dwc_g210_config_40_bit;
> +	}

Instead of manually checking the compatible string, define two copies
of the ufs_hba_variant_ops, and put a pointer to them into the
.data field of tc_dwc_g210_pltfm_match.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
