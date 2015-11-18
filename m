From: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 20/32] scsi: hisi_sas: add v1 hw interrupt init
Date: Wed, 18 Nov 2015 09:26:56 -0600
Message-ID: <CAL_Jsq+NEm_+cGYC6XG6_fprg1Gd7VG0dj8MKPAPUPqpBzL0pg@mail.gmail.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com> <1447779059-136143-21-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447779059-136143-21-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, John Garry <john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org>, hare-l3A5Bk7waGM@public.gmane.org, Wei Xu <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zhangfei Gao <zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 10:50 AM, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Add code to interrupts, so now we can get a phy up
> interrupt when a disk is connected.

So I started looking at why you are using of_irq_count which drivers
shouldn't need to. In patch 5 you use it to allocate memory to store
the irq names, then use them here...


> +static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
> +       {"Phy Up"},
> +};
> +static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
> +       int_phyup_v1_hw,
> +};
> +
> +static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
> +{
> +       struct device *dev = &hisi_hba->pdev->dev;
> +       struct device_node *np = dev->of_node;
> +       char *int_names = hisi_hba->int_names;
> +       int i, j, irq, rc, idx;
> +
> +       if (!np)
> +               return -ENOENT;
> +
> +       for (i = 0; i < hisi_hba->n_phy; i++) {
> +               struct hisi_sas_phy *phy = &hisi_hba->phy[i];
> +
> +               idx = i * HISI_SAS_PHY_INT_NR;
> +               for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
> +                       irq = irq_of_parse_and_map(np, idx);

It is also preferred that drivers don't use this either. You should
use platform_get_irq() instead.

> +                       if (!irq) {
> +                               dev_err(dev,
> +                                       "irq init: fail map phy interrupt %d\n",
> +                                       idx);
> +                               return -ENOENT;
> +                       }
> +
> +                       (void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
> +                                      HISI_SAS_NAME_LEN,
> +                                      "%s %s:%d", dev_name(dev),
> +                                      phy_int_names[j], i);
> +                       rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
> +                                       &int_names[idx * HISI_SAS_NAME_LEN],
> +                                       phy);

There's no requirement for the name to match the name in the DT or
even that the name needs to be unique.

If you really want the DT names used, then just call
of_property_read_string_index() on interrupt-names here. There is no
point to copy the string.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
