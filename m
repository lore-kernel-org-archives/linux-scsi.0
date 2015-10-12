From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 04/25] scsi: hisi_sas: add scsi host registration
Date: Mon, 12 Oct 2015 17:21:34 +0200
Message-ID: <5053179.dHmgEztyeB@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-5-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-5-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 12 October 2015 23:20:16 John Garry wrote:
> +
> +       shost = scsi_host_alloc(&hisi_sas_sht, sizeof(void *));
> +       if (!shost)
> +               return -ENOMEM;
> +
> +       hisi_hba = hisi_sas_hba_alloc(pdev, shost, np);
> +       if (!hisi_hba) {
> +               rc = -ENOMEM;
> +               goto err_out_ha;
> +       }

You can collapse the allocations into one and just pass sizeof(*hisi_hba)
instead of sizeof(void *) above.


> +       sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
> +       platform_set_drvdata(pdev, sha);
> +
> +       phy_nr = port_nr = HISI_SAS_MAX_PHYS;
> +
> +       arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
> +       arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
> +       if (!arr_phy || !arr_port)
> +               return -ENOMEM;

And since these are fixed-size arrays, they can be moved in there as well.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
