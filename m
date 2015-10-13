From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 07/25] scsi: hisi_sas: add ioremap for device HW
Date: Tue, 13 Oct 2015 14:20:59 +0200
Message-ID: <5074860.NRYCq0Qjjh@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <5285087.C8umupFr76@wuerfel> <561CD316.6040406@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561CD316.6040406-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zhangfei <zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 13 October 2015 17:47:02 zhangfei wrote:
> On 10/12/2015 11:21 PM, Arnd Bergmann wrote:
> > On Monday 12 October 2015 23:20:19 John Garry wrote:
> >> +int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
> >> +{
> >> +       struct platform_device *pdev = hisi_hba->pdev;
> >> +       struct device *dev = &pdev->dev;
> >> +       struct resource *res;
> >> +
> >> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +       hisi_hba->regs = devm_ioremap(dev,
> >> +                                     res->start,
> >> +                                     resource_size(res));
> >> +       if (!hisi_hba->regs)
> >> +               return -ENOMEM;
> >> +
> >> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> >> +       hisi_hba->ctrl_regs = devm_ioremap(dev,
> >> +                                          res->start,
> >> +                                          resource_size(res));
> >> +       if (!hisi_hba->ctrl_regs)
> >> +               return -ENOMEM;
> >> +
> >> +       return 0;
> >> +}
> >>
> >>   static const struct of_device_id sas_of_match[] = {
> >>
> >
> > Better use devm_ioremap_resource() here, which registers the resource so they
> > are checked for conflicts and listed in /proc/iomem.
> >
> 
> Yes, hisi_hba->regs can use devm_ioremap_resource.
> 
> However ctrl_regs have to use devm_ioremap, since the address are 
> sharing among different nodes, unfortunately, and devm_ioremap_resource 
> will fail.

This sounds like it should be fixed in the DT binding then, to ensure
that the ranges don't overlap.

Mapping the same register region multiple times is generally considered
a bad idea because the drivers that map them often don't have global
locks that serialize the access, so it's better to have code in place
that ensures that they are distinct.

What is the purpose of the ctrl_regs region, and why is it shared
across multiple devices?

Are all users of these registers in the same driver?

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
