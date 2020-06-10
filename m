Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45722C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 04:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C57F2074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 04:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFJE3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 00:29:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37675 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgFJE3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 00:29:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id y18so465102plr.4;
        Tue, 09 Jun 2020 21:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qKo4IDH4MNqqS+P7y5/W6LXucLKpQrFZ0zzxXg2wH1Q=;
        b=msH5ptsMqhXrDuwb10zDofe/tj62fFd8B5jYJSZPLyC7OuBWfr1vopGOdhL4EjXxIA
         Tdoy+jX9MCAEWtfSqIBPzLvgWDXabuSEzxUnsWjE5l6lJOPY8b364Z29APgogds7qStA
         MTZjSX9AWOcvmwCXpd+tCvzDc0y6S7VR8uvpI1wIL1guyTqsLM8drWZOBCDKnIcDg30K
         zPheJ46pePfqaFuPmRoAceGFeqzHsw8R60QYIYaf638VGJ2RySqpCyLyWmneXuXGjsEt
         mfVj00TCRhfV84LnDq4f3VJqud1NAyEiMjkbQ2c+eBWwZzAVT6bdfo3V+EytXcX5oHf2
         2Hjg==
X-Gm-Message-State: AOAM530DwJGQDYJsr8Q8FJnwdJCoX5u8q7WURBNvyYXxw+dOlaBg2T/j
        c7akJcno0U6KbTst5ypG9v4=
X-Google-Smtp-Source: ABdhPJzcBrKv34bTjRmw9uDmAXvV6XsjtS7P9UjLsvc9HKIpFK/rXOT78foZxxHH3FbnIUc9h7xPDg==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr1497639plt.59.1591763377006;
        Tue, 09 Jun 2020 21:29:37 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u4sm9255020pfl.102.2020.06.09.21.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 21:29:35 -0700 (PDT)
Subject: Re: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
 <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <76831c81-7879-8be7-54a4-ca6bfa68c30e@acm.org>
Date:   Tue, 9 Jun 2020 21:29:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 18:38, Daejun Park wrote:
> +	if (total_srgn_cnt != 0) {
> +		dev_err(hba->dev, "ufshpb(%d) error total_subregion_count %d",
> +			hpb->lun, total_srgn_cnt);
> +		goto release_srgn_table;
> +	}
> +
> +	return 0;
> +release_srgn_table:
> +	for (i = 0; i < rgn_idx; i++) {
> +		rgn = rgn_table + i;
> +		if (rgn->srgn_tbl)
> +			kvfree(rgn->srgn_tbl);
> +	}

Please insert a blank line above goto labels as is done in most of the
kernel code.

> +static struct device_attribute ufshpb_sysfs_entries[] = {
> +	__ATTR(hit_count, 0444, ufshpb_sysfs_show_hit_cnt, NULL),
> +	__ATTR(miss_count, 0444, ufshpb_sysfs_show_miss_cnt, NULL),
> +	__ATTR(rb_noti_count, 0444, ufshpb_sysfs_show_rb_noti_cnt, NULL),
> +	__ATTR(rb_active_count, 0444, ufshpb_sysfs_show_rb_active_cnt, NULL),
> +	__ATTR(rb_inactive_count, 0444, ufshpb_sysfs_show_rb_inactive_cnt,
> +	       NULL),
> +	__ATTR(map_req_count, 0444, ufshpb_sysfs_show_map_req_cnt, NULL),
> +	__ATTR_NULL
> +};

Please use __ATTR_RO() where appropriate.

> +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
> +{
> +	struct device_attribute *attr;
> +	int ret;
> +
> +	device_initialize(&hpb->hpb_lu_dev);
> +
> +	ufshpb_stat_init(hpb);
> +
> +	hpb->hpb_lu_dev.parent = get_device(&hba->ufsf.hpb_dev);
> +	hpb->hpb_lu_dev.release = ufshpb_dev_release;
> +	dev_set_name(&hpb->hpb_lu_dev, "ufshpb_lu%d", hpb->lun);
> +
> +	ret = device_add(&hpb->hpb_lu_dev);
> +	if (ret) {
> +		dev_err(hba->dev, "ufshpb(%d) device_add failed",
> +			hpb->lun);
> +		return -ENODEV;
> +	}
> +
> +	for (attr = ufshpb_sysfs_entries; attr->attr.name != NULL; attr++) {
> +		if (device_create_file(&hpb->hpb_lu_dev, attr))
> +			dev_err(hba->dev, "ufshpb(%d) %s create file error\n",
> +				hpb->lun, attr->attr.name);
> +	}
> +
> +	return 0;
> +}

This is the wrong way to create sysfs attributes. Please set the
'groups' member of struct device instead of using a loop to create sysfs
attributes. The former approach is compatible with udev but the latter
approach is not.

> +static void ufshpb_probe_async(void *data, async_cookie_t cookie)
> +{
> +	struct ufshpb_dev_info hpb_dev_info = { 0 };
> +	struct ufs_hba *hba = data;
> +	char *desc_buf;
> +	int ret;
> +
> +	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
> +	if (!desc_buf)
> +		goto release_desc_buf;
> +
> +	ret = ufshpb_get_dev_info(hba, &hpb_dev_info, desc_buf);
> +	if (ret)
> +		goto release_desc_buf;
> +
> +	/*
> +	 * Because HPB driver uses scsi_device data structure,
> +	 * we should wait at this point until finishing initialization of all
> +	 * scsi devices. Even if timeout occurs, HPB driver will search
> +	 * the scsi_device list on struct scsi_host (shost->__host list_head)
> +	 * and can find out HPB logical units in all scsi_devices
> +	 */
> +	wait_event_timeout(hba->ufsf.sdev_wait,
> +			   (atomic_read(&hba->ufsf.slave_conf_cnt)
> +				== hpb_dev_info.num_lu),
> +			   SDEV_WAIT_TIMEOUT);
> +
> +	dev_dbg(hba->dev, "ufshpb: slave count %d, lu count %d\n",
> +		atomic_read(&hba->ufsf.slave_conf_cnt), hpb_dev_info.num_lu);
> +
> +	ufshpb_scan_hpb_lu(hba, &hpb_dev_info, desc_buf);
> +release_desc_buf:
> +	kfree(desc_buf);
> +}

What happens if two LUNs are added before the above code is woken up?
Will that perhaps cause the wait_event_timeout() call to wait forever?

> +static int ufshpb_probe(struct device *dev)
> +{
> +	struct ufs_hba *hba;
> +	struct ufsf_feature_info *ufsf;
> +
> +	if (dev->type != &ufshpb_dev_type)
> +		return -ENODEV;
> +
> +	ufsf = container_of(dev, struct ufsf_feature_info, hpb_dev);
> +	hba = container_of(ufsf, struct ufs_hba, ufsf);
> +
> +	async_schedule(ufshpb_probe_async, hba);
> +	return 0;
> +}

So this is an asynchronous probe that is not visible to the device
driver core? Could the PROBE_PREFER_ASYNCHRONOUS flag have been used
instead to make device probing asynchronous?

> +static int ufshpb_remove(struct device *dev)
> +{
> +	struct ufshpb_lu *hpb, *n_hpb;
> +	struct ufsf_feature_info *ufsf;
> +	struct scsi_device *sdev;
> +
> +	ufsf = container_of(dev, struct ufsf_feature_info, hpb_dev);
> +
> +	dev_set_drvdata(&ufsf->hpb_dev, NULL);
> +
> +	list_for_each_entry_safe(hpb, n_hpb, &ufshpb_drv.lh_hpb_lu,
> +				 list_hpb_lu) {
> +		ufshpb_set_state(hpb, HPB_FAILED);
> +
> +		sdev = hpb->sdev_ufs_lu;
> +		sdev->hostdata = NULL;
> +
> +		device_del(&hpb->hpb_lu_dev);
> +
> +		dev_info(&hpb->hpb_lu_dev, "hpb_lu_dev refcnt %d\n",
> +			 kref_read(&hpb->hpb_lu_dev.kobj.kref));
> +		put_device(&hpb->hpb_lu_dev);
> +	}
> +	dev_info(dev, "ufshpb: remove success\n");
> +
> +	return 0;
> +}

Where is the code that waits for the asynchronously scheduled probe
calls to finish?

> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> new file mode 100644
> index 000000000000..c6dd88e00849
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -0,0 +1,185 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Universal Flash Storage Host Performance Booster
> + *
> + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
> + *
> + * Authors:
> + *	Yongmyung Lee <ymhungry.lee@samsung.com>
> + *	Jinyoung Choi <j-young.choi@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * See the COPYING file in the top-level directory or visit
> + * <http://www.gnu.org/licenses/gpl-2.0.html>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This program is provided "AS IS" and "WITH ALL FAULTS" and
> + * without warranty of any kind. You are solely responsible for
> + * determining the appropriateness of using and distributing
> + * the program and assume all risks associated with your exercise
> + * of rights with respect to the program, including but not limited
> + * to infringement of third party rights, the risks and costs of
> + * program errors, damage to or loss of data, programs or equipment,
> + * and unavailability or interruption of operations. Under no
> + * circumstances will the contributor of this Program be liable for
> + * any damages of any kind arising from your use or distribution of
> + * this program.
> + *
> + * The Linux Foundation chooses to take subject only to the GPLv2
> + * license terms, and distributes only under these terms.
> + */

Please use an SPDX declaration instead of the full GPLv2 text.

Thanks,

Bart.
