From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/4] [SCSI] ufs: Add Platform glue driver for ufshcd
Date: Mon, 2 Jul 2012 15:27:19 +0000
Message-ID: <201207021527.19888.arnd@arndb.de>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com> <1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1341239572-7408-3-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Monday 02 July 2012, Vinayak Holikatti wrote:
> +static struct platform_driver ufshcd_pltfrm_driver = {
> +       .probe  = ufshcd_pltfrm_probe,
> +       .remove = __devexit_p(ufshcd_pltfrm_remove),
> +#ifdef CONFIG_PM
> +       .suspend = ufshcd_pltfrm_suspend,
> +       .resume = ufshcd_pltfrm_resume,
> +#endif
> +       .driver = {
> +               .name   = "ufshcd",
> +               .owner  = THIS_MODULE,
> +       },
> +};

Hi Vinayak,

Please add a device tree match table here to allow the driver to be
used by modern platforms that only do device tree based hardware
detection. Just look in other drivers for existing uses of
"of_match_table" to be used.

I'm not sure what the "compatible" string should be in this case,
because the it matches a JEDEC specification, not a particular
vendor's implementation of it. The match table can have multiple
entries, which is useful if you have multiple implementations
that are slightly different or don't fully conform to the spec.

Maybe a list like

static const struct of_device_id ufs_of_match[] = {
	{ .compatible = "jedec,ufs-1.1" },
}

would be enough for now.

	Arnd
