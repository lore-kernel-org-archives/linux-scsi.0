From: =?UTF-8?B?6rmA6riw7JuF?= <kwmad.kim@samsung.com>
Subject: RE: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
Date: Thu, 30 Nov 2017 16:46:20 +0900
Message-ID: <017b01d369af$5054bbc0$f0fe3340$@samsung.com>
References: <CGME20171128053631epcas1p389908b55511552b79b4083109dddc515@epcas1p3.samsung.com>
        <002a01d3680a$d8817200$89845600$@samsung.com>
        <20171128142439.GA5765@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56428 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdK3HqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 02:46:24 -0500
In-reply-to: <20171128142439.GA5765@infradead.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, cpgs@samsung.com, 'HeonGwang Chu' <hg.chu@samsung.com>, =?UTF-8?B?J+q5gOu2gOynhCc=?= <boojin.kim@samsung.com>, 'YOUNGEUN PARK' <youngeun.park@samsung.com>

Dear Christoph

Thank you for your comments.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Tuesday, November 28, 2017 11:25 PM
> To: =EA=B9=80=EA=B8=B0=EC=9B=85
> Cc: linux-scsi@vger.kernel.org; Martin K. Petersen; cpgs@samsung.com;
> HeonGwang Chu; =EA=B9=80=EB=B6=80=EC=A7=84; YOUNGEUN PARK
> Subject: Re: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
>=20
> On Tue, Nov 28, 2017 at 02:36:31PM +0900, =EA=B9=80=EA=B8=B0=EC=9B=85 =
wrote:
> > This driver is to use UFS devices on Exynos SoC and has been already
> > used for many years for commercial products.
>=20
> So why do you only submit it only now?

The 1st author of this didn't complete submitting it.
And then following products has been coming and I need time to organize =
this.

>=20
> > +/* Helper for UFS CAL interface */
> > +static inline int ufs_init_cal(struct exynos_ufs *ufs, int idx,
> > +					struct platform_device *pdev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_link(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_link(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_gear_change(struct exynos_ufs *ufs,
> > +				struct uic_pwr_mode *pmd)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_gear_change(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_post_h8_enter(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
> > +
> > +static inline int ufs_pre_h8_exit(struct exynos_ufs *ufs) {
> > +	return 0;
> > +}
>=20
> These are all dummys, please rmeove them.
>=20
> > +#ifndef __EXYNOS_UFS_VS_DEBUG__
>=20
> Please don't have ifdef code that isn't Kconfig selectable.

Okay.

>=20
> > +#ifndef __EXYNOS_UFS_MMIO_FUNC__
> > +#define __EXYNOS_UFS_MMIO_FUNC__
> > +#define EXYNOS_UFS_MMIO_FUNC(name)						\
> > +static inline void name##_writel(struct exynos_ufs *ufs, u32 val, =
u32
> reg)	\
> > +{										\
> > +	writel(val, ufs->reg_##name + reg);					\
> > +}										\
> > +										\
> > +static inline u32 name##_readl(struct exynos_ufs *ufs, u32 reg)
> 	\
> > +{										\
> > +	return readl(ufs->reg_##name + reg);					\
> > +}
> > +
> > +EXYNOS_UFS_MMIO_FUNC(hci);
> > +EXYNOS_UFS_MMIO_FUNC(unipro);
>=20
> Please remove this macro magic.

Could you explain an intention of this comment?
Because this driver needs MMIO-based accesses for multi regions?
For example, is this kind of a rule not to use macro?

>=20
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 1332e544da92..1afd5ac9707c 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -308,6 +308,7 @@ struct ufs_hba_variant_ops {
> >  	int	(*setup_clocks)(struct ufs_hba *, bool,
> >  				enum ufs_notify_change_status);
> >  	int     (*setup_regulators)(struct ufs_hba *, bool);
> > +	void    (*host_reset)(struct ufs_hba *);
> >  	int	(*hce_enable_notify)(struct ufs_hba *,
> >  				     enum ufs_notify_change_status);
> >  	int	(*link_startup_notify)(struct ufs_hba *,
>=20
> New ufs core methods should be added in a separate patch with a good
> description, and also with actual callers using them.

Okay.
