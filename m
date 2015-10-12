From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 05/25] scsi: hisi_sas: allocate memories and create pools
Date: Mon, 12 Oct 2015 17:15:28 +0200
Message-ID: <13409618.ra2GB8eyNb@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-6-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 12 October 2015 23:20:17 John Garry wrote:
> +       interrupt_count = of_property_count_u32_elems(np, "interrupts");
> +       if (interrupt_count < 0)
> +               goto err_out;
> +
> +       if (of_property_read_u32(np, "#interrupt-cells", &interrupt_cells))
> +               goto err_out;
> +
> +       hisi_hba->int_names = devm_kcalloc(&pdev->dev,
> +                                          interrupt_count / interrupt_cells,
> +                                          HISI_SAS_NAME_LEN,
> +                                          GFP_KERNEL);
> 

This computation looks wrong: the "interrupts" property refers to interrupts
that are referenced by this node and provided by an interrupt-controller,
while the "#interrupt-cells" property refers to interrupts provided by
this node. They don't need to have any relation.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
