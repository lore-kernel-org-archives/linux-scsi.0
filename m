Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CF5C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 03:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8B020792
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 03:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S8UMwwyg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgFLDxG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 23:53:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54333 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgFLDxG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 23:53:06 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200612035302epoutp02a671a82b7462d6f14a2adb8f77cb2750~Xr4W7SET-1753117531epoutp02X
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 03:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200612035302epoutp02a671a82b7462d6f14a2adb8f77cb2750~Xr4W7SET-1753117531epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591933982;
        bh=5tLF6fdYvXuQ+oWURL9o4gFqdlrIDs0SFbyH+UiH4HA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=S8UMwwygyudO/7/ritdt9TDR0Kr+VbZnbnCfqkq2Np/qOxpTBM8FhGyRJMazFHxpI
         DFb85jluzgun5VSsRKPyZf1I4l3Ec7fSFhcUIENQDL5x2H/goj4d7xjkJQWzetx58L
         LD7jICDgoS9MA3cjDd0t9eIrrIyDHJVTFEWuEU6Q=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200612035301epcas1p1670632461b5acc152457d38ae6aeca32~Xr4WivTyW0502605026epcas1p1i;
        Fri, 12 Jun 2020 03:53:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH 5/5] scsi: ufs: Prepare HPB read for cached
 sub-region
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
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
In-Reply-To: <bdc420e4-3f2e-cf52-eb42-f85e747b2fb1@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21591933981778.JavaMail.epsvc@epcpadp2>
Date:   Fri, 12 Jun 2020 12:39:11 +0900
X-CMS-MailID: 20200612033911epcms2p8dee9ef9f42a622ab1f5921ded4ca589d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <bdc420e4-3f2e-cf52-eb42-f85e747b2fb1@acm.org>
        <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <336371513.41591323603173.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 18:38, Daejun Park wrote:
> > +  if (total_srgn_cnt != 0) {
> > +    dev_err(hba->dev, "ufshpb(%d) error total_subregion_count %d",
> > +      hpb->lun, total_srgn_cnt);
> > +    goto release_srgn_table;
> > +  }
> > +
> > +  return 0;
> > +release_srgn_table:
> > +  for (i = 0; i < rgn_idx; i++) {
> > +    rgn = rgn_table + i;
> > +    if (rgn->srgn_tbl)
> > +      kvfree(rgn->srgn_tbl);
> > +  }

> Please insert a blank line above goto labels as is done in most of the
> kernel code.
OK, I will fix it.

> > +static struct device_attribute ufshpb_sysfs_entries[] = {
> > +  __ATTR(hit_count, 0444, ufshpb_sysfs_show_hit_cnt, NULL),
> > +  __ATTR(miss_count, 0444, ufshpb_sysfs_show_miss_cnt, NULL),
> > +  __ATTR(rb_noti_count, 0444, ufshpb_sysfs_show_rb_noti_cnt, NULL),
> > +  __ATTR(rb_active_count, 0444, ufshpb_sysfs_show_rb_active_cnt, NULL),
> > +  __ATTR(rb_inactive_count, 0444, ufshpb_sysfs_show_rb_inactive_cnt,
> > +         NULL),
> > +  __ATTR(map_req_count, 0444, ufshpb_sysfs_show_map_req_cnt, NULL),
> > +  __ATTR_NULL
> > +};

> Please use __ATTR_RO() where appropriate.
They are only readable attributes. So I changed the code to use __ATTR_RO.

> > +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
> > +{
> > +  struct device_attribute *attr;
> > +  int ret;
> > +
> > +  device_initialize(&hpb->hpb_lu_dev);
> > +
> > +  ufshpb_stat_init(hpb);
> > +
> > +  hpb->hpb_lu_dev.parent = get_device(&hba->ufsf.hpb_dev);
> > +  hpb->hpb_lu_dev.release = ufshpb_dev_release;
> > +  dev_set_name(&hpb->hpb_lu_dev, "ufshpb_lu%d", hpb->lun);
> > +
> > +  ret = device_add(&hpb->hpb_lu_dev);
> > +  if (ret) {
> > +    dev_err(hba->dev, "ufshpb(%d) device_add failed",
> > +      hpb->lun);
> > +    return -ENODEV;
> > +  }
> > +
> > +  for (attr = ufshpb_sysfs_entries; attr->attr.name != NULL; attr++) {
> > +    if (device_create_file(&hpb->hpb_lu_dev, attr))
> > +      dev_err(hba->dev, "ufshpb(%d) %s create file error\n",
> > +        hpb->lun, attr->attr.name);
> > +  }
> > +
> > +  return 0;
> > +}

> This is the wrong way to create sysfs attributes. Please set the
> 'groups' member of struct device instead of using a loop to create sysfs
> attributes. The former approach is compatible with udev but the latter
> approach is not.
OK, I changed to create attributes without loop.

> > +static void ufshpb_probe_async(void *data, async_cookie_t cookie)
> > +{
> > +  struct ufshpb_dev_info hpb_dev_info = { 0 };
> > +  struct ufs_hba *hba = data;
> > +  char *desc_buf;
> > +  int ret;
> > +
> > +  desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
> > +  if (!desc_buf)
> > +    goto release_desc_buf;
> > +
> > +  ret = ufshpb_get_dev_info(hba, &hpb_dev_info, desc_buf);
> > +  if (ret)
> > +    goto release_desc_buf;
> > +
> > +  /*
> > +   * Because HPB driver uses scsi_device data structure,
> > +   * we should wait at this point until finishing initialization of all
> > +   * scsi devices. Even if timeout occurs, HPB driver will search
> > +   * the scsi_device list on struct scsi_host (shost->__host list_head)
> > +   * and can find out HPB logical units in all scsi_devices
> > +   */
> > +  wait_event_timeout(hba->ufsf.sdev_wait,
> > +         (atomic_read(&hba->ufsf.slave_conf_cnt)
> > +        == hpb_dev_info.num_lu),
> > +         SDEV_WAIT_TIMEOUT);
> > +
> > +  dev_dbg(hba->dev, "ufshpb: slave count %d, lu count %d\n",
> > +    atomic_read(&hba->ufsf.slave_conf_cnt), hpb_dev_info.num_lu);
> > +
> > +  ufshpb_scan_hpb_lu(hba, &hpb_dev_info, desc_buf);
> > +release_desc_buf:
> > +  kfree(desc_buf);
> > +}

> What happens if two LUNs are added before the above code is woken up?
> Will that perhaps cause the wait_event_timeout() call to wait forever?
I don't think it is problem. I think that the wait_event_timeout() will
check the condition before waiting.

> > +static int ufshpb_probe(struct device *dev)
> > +{
> > +  struct ufs_hba *hba;
> > +  struct ufsf_feature_info *ufsf;
> > +
> > +  if (dev->type != &ufshpb_dev_type)
> > +    return -ENODEV;
> > +
> > +  ufsf = container_of(dev, struct ufsf_feature_info, hpb_dev);
> > +  hba = container_of(ufsf, struct ufs_hba, ufsf);
> > +
> > +  async_schedule(ufshpb_probe_async, hba);
> > +  return 0;
> > +}

> So this is an asynchronous probe that is not visible to the device
> driver core? Could the PROBE_PREFER_ASYNCHRONOUS flag have been used
> instead to make device probing asynchronous?
I added the PROBE_PREFER_ASYNCHRONOUS flag to code and changed it to probe
synchronously.
 
> > +static int ufshpb_remove(struct device *dev)
> > +{
> > +  struct ufshpb_lu *hpb, *n_hpb;
> > +  struct ufsf_feature_info *ufsf;
> > +  struct scsi_device *sdev;
> > +
> > +  ufsf = container_of(dev, struct ufsf_feature_info, hpb_dev);
> > +
> > +  dev_set_drvdata(&ufsf->hpb_dev, NULL);
> > +
> > +  list_for_each_entry_safe(hpb, n_hpb, &ufshpb_drv.lh_hpb_lu,
> > +         list_hpb_lu) {
> > +    ufshpb_set_state(hpb, HPB_FAILED);
> > +
> > +    sdev = hpb->sdev_ufs_lu;
> > +    sdev->hostdata = NULL;
> > +
> > +    device_del(&hpb->hpb_lu_dev);
> > +
> > +    dev_info(&hpb->hpb_lu_dev, "hpb_lu_dev refcnt %d\n",
> > +       kref_read(&hpb->hpb_lu_dev.kobj.kref));
> > +    put_device(&hpb->hpb_lu_dev);
> > +  }
> > +  dev_info(dev, "ufshpb: remove success\n");
> > +
> > +  return 0;
> > +}

> Where is the code that waits for the asynchronously scheduled probe
> calls to finish?
I changed it to probe without async_schedule.

> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > new file mode 100644
> > index 000000000000..c6dd88e00849
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -0,0 +1,185 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Universal Flash Storage Host Performance Booster
> > + *
> > + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
> > + *
> > + * Authors:
> > + *  Yongmyung Lee <ymhungry.lee@samsung.com>
> > + *  Jinyoung Choi <j-young.choi@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + * See the COPYING file in the top-level directory or visit
> > + * <http://www.gnu.org/licenses/gpl-2.0.html>
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > + * without warranty of any kind. You are solely responsible for
> > + * determining the appropriateness of using and distributing
> > + * the program and assume all risks associated with your exercise
> > + * of rights with respect to the program, including but not limited
> > + * to infringement of third party rights, the risks and costs of
> > + * program errors, damage to or loss of data, programs or equipment,
> > + * and unavailability or interruption of operations. Under no
> > + * circumstances will the contributor of this Program be liable for
> > + * any damages of any kind arising from your use or distribution of
> > + * this program.
> > + *
> > + * The Linux Foundation chooses to take subject only to the GPLv2
> > + * license terms, and distributes only under these terms.
> > + */

> Please use an SPDX declaration instead of the full GPLv2 text.
OK, I will.

Thanks,

Daejun.


