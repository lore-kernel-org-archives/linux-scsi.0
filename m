Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DAFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86E620E65
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 00:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Mb0W21sA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgIAA2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 20:28:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14180 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIAA2H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 20:28:07 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200901002803epoutp0328c9344eede88af04ae75aa3b04efffc~wgVhLbEh90428104281epoutp03L
        for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2020 00:28:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200901002803epoutp0328c9344eede88af04ae75aa3b04efffc~wgVhLbEh90428104281epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598920083;
        bh=OF1Pv++QhXZYlFTml4PQgnKmM92CjP4TjcSJp36bjlQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Mb0W21sAzpiW/X8VtyBgpRWEtnd638SG1T0MW1FjtWBt5GHu18kIONSPVeAztoIBj
         FfzDVQZnRqGPsQuDzR7KeG9gfFz+w6+pYAjvgxiha/Zpdei8NApxCZA9miXw9gni4e
         6SCV/NnDjxg7r/m9PPdQ81z3x765h3TqkTM630Aw=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200901002802epcas1p331f2e1e6a83c76992b163b522132e121~wgVf98voU2184021840epcas1p3j;
        Tue,  1 Sep 2020 00:28:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v9 2/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <93f1cf18-30da-4482-9a0d-c46d2f70bd15@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21598920082632.JavaMail.epsvc@epcpadp2>
Date:   Tue, 01 Sep 2020 09:24:29 +0900
X-CMS-MailID: 20200901002429epcms2p392aaaa25de16b387c15ed4387a0321dd
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200828070950epcms2p5470bd43374be18d184dd802da09e73c8
References: <93f1cf18-30da-4482-9a0d-c46d2f70bd15@acm.org>
        <963815509.21598598782155.JavaMail.epsvc@epcpadp2>
        <231786897.01598601302183.JavaMail.epsvc@epcpadp1>
        <CGME20200828070950epcms2p5470bd43374be18d184dd802da09e73c8@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart

> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 618b253e5ec8..df30622a2b67 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -588,6 +588,24 @@ struct ufs_hba_variant_params {
> >  	u16 hba_enable_delay_us;
> >  	u32 wb_flush_threshold;
> >  };
> > +#ifdef CONFIG_SCSI_UFS_HPB
> > +/**
> > + * struct ufshpb_dev_info - UFSHPB device related info
> > + * @num_lu: the number of user logical unit to check whether all lu finished
> > + *          initialization
> > + * @rgn_size: device reported HPB region size
> > + * @srgn_size: device reported HPB sub-region size
> > + * @slave_conf_cnt: counter to check all lu finished initialization
> > + * @hpb_disabled: flag to check if HPB is disabled
> > + */
> > +struct ufshpb_dev_info {
> > +	int num_lu;
> > +	int rgn_size;
> > +	int srgn_size;
> > +	atomic_t slave_conf_cnt;
> > +	bool hpb_disabled;
> > +};
> > +#endif
> 
> Please insert a blank line above "#ifdef CONFIG_SCSI_UFS_HPB"

OK, I will insert a blank line.
 
> > +/* HPB enabled lu list */
> > +static LIST_HEAD(lh_hpb_lu);
> 
> Is it necessary to maintain this list? Or in other words, is it possible to
> change all list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu) calls into
> shost_for_each_device() calls?

OK, I will remove lh_hpb_lu.

> > +/* SYSFS functions */
> > +#define ufshpb_sysfs_attr_show_func(__name)				\
> > +static ssize_t __name##_show(struct device *dev,			\
> > +	struct device_attribute *attr, char *buf)			\
> > +{									\
> > +	struct scsi_device *sdev = to_scsi_device(dev);			\
> > +	struct ufshpb_lu *hpb = sdev->hostdata;				\
> > +	if (!hpb)							\
> > +		return -ENOENT;						\
> > +	return snprintf(buf, PAGE_SIZE, "%d\n",				\
> > +			atomic_read(&hpb->stats.__name));		\
> > +}									\
> > +static DEVICE_ATTR_RO(__name)
> 
> Please leave a blank line after declarations (between the "hpb" declaration
> and "if (!hpb)").

OK, I will add a blank line.

> > +#ifndef CONFIG_SCSI_UFS_HPB
> > +[...]
> > +static struct attribute *hpb_dev_attrs[] = { NULL,};
> > +static struct attribute_group ufs_sysfs_hpb_stat_group = {.attrs = hpb_dev_attrs,};
> > +#else
> > +[...]
> > +extern struct attribute_group ufs_sysfs_hpb_stat_group;
> > +#endif
> 
> Defining static variables or arrays in header files is questionable because
> the definition of these variables will be duplicated in each source file that
> header file is included in. Although the general rule for kernel code is to
> confine #ifdefs to header files, for ufs_sysfs_hpb_stat_group I think that
> it is better to surround its use with #ifndef CONFIG_SCSI_UFS_HPB / #endif
> instead of defining a dummy structure as static variable in a header file if
> HPB support is disabled.

OK, I added #ifdef in ufshcd.c.

static const struct attribute_group *ufshcd_driver_groups[] = {
	&ufs_sysfs_unit_descriptor_group,
	&ufs_sysfs_lun_attributes_group,
#ifdef CONFIG_SCSI_UFS_HPB
	&ufs_sysfs_hpb_stat_group,
#endif
	NULL,
};

Thanks,
Daejun
