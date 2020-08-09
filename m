Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB33C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62713206C0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgHIAHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 20:07:46 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50836 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgHIAHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 20:07:45 -0400
Received: by mail-pj1-f67.google.com with SMTP id e4so2829931pjd.0;
        Sat, 08 Aug 2020 17:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bt+A3fF2RiSPLUBf0cQVi/6Q2KQ5cYRZSYVMJX46Wn0=;
        b=YATmVaTstoz4MnQ5shRylflSqKRMQg5z/k7pHMjTAgBR+ZLKQL1DQCLwNF2kwoZ2sT
         togThcOw6lgS71lnqcJb0UrEd57RkCImYhu76mP6pIxOO6/hR8kAYGgsKduYgoSwwLn+
         B2JxvqS2vhdkEkIm3Pl2gI+AxF8FnmYul5sXC/9iys8w9ZYGktH29T5cMdk61fOs9X4R
         zkTAQb9HzIJl2/DcoyHMPkSHX402CVUCDrGady0L4GCA+9B5TcI6onqhXIhpxZ8vB6BB
         mG6KkparAWKxQH1FlozklfPU6um1YyLpQ//UzBrfHsTiAucs43jZxLWsEHAc/pX+9zbr
         yfAA==
X-Gm-Message-State: AOAM530PNV5gzMBQFIa9by2cFTOoQ4Sf5w+OyYm+3qjl1HdYLSsh3cc4
        /fd2rXVAfsfg5vW37TKdaqk=
X-Google-Smtp-Source: ABdhPJywqIdTqloPfxs1N0NZMjRkFwjJWbCoP8zqeqFkqxMmTS1duo6WG6fNxqArPGlHzVAtbJD5Mw==
X-Received: by 2002:a17:902:d345:: with SMTP id l5mr17060759plk.276.1596931664234;
        Sat, 08 Aug 2020 17:07:44 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c2sm14859046pgb.52.2020.08.08.17.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 17:07:43 -0700 (PDT)
Subject: Re: [PATCH v8 2/4] scsi: ufs: Introduce HPB feature
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
 <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
 <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
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
Message-ID: <2154d9c6-4b29-7d24-0261-26d2aa05caef@acm.org>
Date:   Sat, 8 Aug 2020 17:07:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:11, Daejun Park wrote:
> This is a patch for the HPB feature.
> This patch adds HPB function calls to UFS core driver.
> 
> The mininum size of the memory pool used in the HPB is implemented as a
      ^^^^^^^
      minimum?
> Kconfig parameter (SCSI_UFS_HPB_HOST_MEM), so that it can be configurable.

> +config SCSI_UFS_HPB
> +	bool "Support UFS Host Performance Booster"
> +	depends on SCSI_UFSHCD
> +	help
> +	  A UFS HPB Feature improves random read performance. It caches
          ^         ^^^^^^^
          The?      feature?
> +	  L2P map of UFS to host DRAM. The driver uses HPB read command
> +	  by piggybacking physical page number for bypassing FTL's L2P address
> +	  translation.

Please explain what L2P and FTL mean. Not everyone is familiar with SSD
internals.

> +config SCSI_UFS_HPB_HOST_MEM
> +	int "Host-side cached memory size (KB) for HPB support"
> +	default 32
> +	depends on SCSI_UFS_HPB
> +	help
> +	  The mininum size of the memory pool used in the HPB module. It can
> +	  be configurable by the user. If this value is larger than required
> +	  memory size, kernel resizes cached memory size.
                              ^^^^^^^ ^^^^^^^^^^^^^^^^^^
                             reduces?    cache size?

Please make this a kernel module parameter instead of a compile-time constant.

> +#ifndef CONFIG_SCSI_UFS_HPB
> +static void ufshpb_resume(struct ufs_hba *hba) {}
> +static void ufshpb_suspend(struct ufs_hba *hba) {}
> +static void ufshpb_reset(struct ufs_hba *hba) {}
> +static void ufshpb_reset_host(struct ufs_hba *hba) {}
> +static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
> +static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
> +static void ufshpb_remove(struct ufs_hba *hba) {}
> +static void ufshpb_scan_feature(struct ufs_hba *hba) {}
> +#endif

Please move these definitions into ufshpb.h since that is the
recommended Linux kernel coding style.

> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b2ef18f1b746..904c19796e09 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -47,6 +47,9 @@
>  #include "ufs.h"
>  #include "ufs_quirks.h"
>  #include "ufshci.h"
> +#ifdef CONFIG_SCSI_UFS_HPB
> +#include "ufshpb.h"
> +#endif

Please move #ifdef CONFIG_SCSI_UFS_HPB / #endif into ufshpb.h. From
Documentation/process/4.Coding.rst: "As a general rule, #ifdef use
should be confined to header files whenever possible."

> +struct ufsf_feature_info {
> +	atomic_t slave_conf_cnt;
> +	wait_queue_head_t sdev_wait;
> +};

Please add a comment above this data structure that explains the role
of this data structure and also what "ufsf" stands for.

> +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb);

I don't think that this forward declaration is necessary so please leave it
out.

> +static inline int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
> +			     struct ufshpb_subregion *srgn)
> +{
> +	return rgn->rgn_state != HPB_RGN_INACTIVE &&
> +		srgn->srgn_state == HPB_SRGN_VALID;
> +}

Please do not declare functions inside .c files inline but instead let
the compiler decide which functions to inline. Modern compilers are really
good at this.

> +static struct kobj_type ufshpb_ktype = {
> +	.sysfs_ops = &ufshpb_sysfs_ops,
> +	.release = NULL,
> +};

If the release method of a kobj_type is NULL that is a strong sign that
there is something wrong ...

> +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
> +{
> +	int ret;
> +
> +	ufshpb_stat_init(hpb);
> +
> +	kobject_init(&hpb->kobj, &ufshpb_ktype);
> +	mutex_init(&hpb->sysfs_lock);
> +
> +	ret = kobject_add(&hpb->kobj, kobject_get(&hba->dev->kobj),
> +			  "ufshpb_lu%d", hpb->lun);
> +
> +	if (ret)
> +		return ret;
> +
> +	ret = sysfs_create_group(&hpb->kobj, &ufshpb_sysfs_group);
> +
> +	if (ret) {
> +		dev_err(hba->dev, "ufshpb_lu%d create file error\n", hpb->lun);
> +		return ret;
> +	}
> +
> +	dev_info(hba->dev, "ufshpb_lu%d sysfs adds uevent", hpb->lun);
> +	kobject_uevent(&hpb->kobj, KOBJ_ADD);
> +
> +	return 0;
> +}

Please attach these sysfs attributes to /sys/class/scsi_device/*/device
instead of creating a new kobject. Consider using the following
scsi_host_template member to define LUN sysfs attributes:

	/*
	 * Pointer to the SCSI device attribute groups for this host,
	 * NULL terminated.
	 */
	const struct attribute_group **sdev_groups;

> +static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
> +			       struct ufshpb_dev_info *hpb_dev_info,
> +			       u8 *desc_buf)
> +{
> +	struct scsi_device *sdev;
> +	struct ufshpb_lu *hpb;
> +	int find_hpb_lu = 0;
> +	int ret;
> +
> +	shost_for_each_device(sdev, hba->host) {
> +		struct ufshpb_lu_info hpb_lu_info = { 0 };
> +		int lun = sdev->lun;
> +
> +		if (lun >= hba->dev_info.max_lu_supported)
> +			continue;
> +
> +		ret = ufshpb_get_lu_info(hba, lun, &hpb_lu_info, desc_buf);
> +		if (ret)
> +			continue;
> +
> +		hpb = ufshpb_alloc_hpb_lu(hba, lun, hpb_dev_info,
> +					  &hpb_lu_info);
> +		if (!hpb)
> +			continue;
> +
> +		hpb->sdev_ufs_lu = sdev;
> +		sdev->hostdata = hpb;
> +
> +		list_add_tail(&hpb->list_hpb_lu, &lh_hpb_lu);
> +		find_hpb_lu++;
> +	}
> +
> +	if (!find_hpb_lu)
> +		return;
> +
> +	ufshpb_check_hpb_reset_query(hba);
> +
> +	list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu) {
> +		dev_info(hba->dev, "set state to present\n");
> +		ufshpb_set_state(hpb, HPB_PRESENT);
> +	}
> +}

Please remove the loop from the above function, make this function accept a
SCSI device pointer as argument and call this function from
ufshcd_slave_configure() or ufshcd_hpb_configure().

> +static void ufshpb_init(void *data, async_cookie_t cookie)
> +{
> +	struct ufsf_feature_info *ufsf = (struct ufsf_feature_info *)data;
> +	struct ufs_hba *hba;
> +	struct ufshpb_dev_info hpb_dev_info = { 0 };
> +	char *desc_buf;
> +	int ret;
> +
> +	hba = container_of(ufsf, struct ufs_hba, ufsf);
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
> +	ufshpb_issue_hpb_reset_query(hba);
> +
> +	dev_dbg(hba->dev, "ufshpb: slave count %d, lu count %d\n",
> +		atomic_read(&hba->ufsf.slave_conf_cnt), hpb_dev_info.num_lu);
> +
> +	ufshpb_scan_hpb_lu(hba, &hpb_dev_info, desc_buf);
> +
> +release_desc_buf:
> +	kfree(desc_buf);
> +}

Since the UFS driver calls scsi_scan_host() from ufshcd_add_lus(), do you
agree that the above wait_event_timeout() call can be eliminated by splitting
ufshpb_init() into two functions and by calling the part below
wait_event_timeout() after scsi_scan_host() has finished?

> +void ufshpb_remove(struct ufs_hba *hba)
> +{
> +	struct ufshpb_lu *hpb, *n_hpb;
> +	struct ufsf_feature_info *ufsf;
> +	struct scsi_device *sdev;
> +
> +	ufsf = &hba->ufsf;
> +
> +	list_for_each_entry_safe(hpb, n_hpb, &lh_hpb_lu, list_hpb_lu) {
> +		ufshpb_set_state(hpb, HPB_FAILED);
> +
> +		sdev = hpb->sdev_ufs_lu;
> +		sdev->hostdata = NULL;
> +
> +		ufshpb_destroy_region_tbl(hpb);
> +
> +		list_del_init(&hpb->list_hpb_lu);
> +		ufshpb_remove_sysfs(hpb);
> +
> +		kfree(hpb);
> +	}
> +
> +	dev_info(hba->dev, "ufshpb: remove success\n");
> +}

Should the code in the body of the above loop perhaps be called from inside
ufshcd_slave_destroy()?

> +void ufshpb_scan_feature(struct ufs_hba *hba)
> +{
> +	init_waitqueue_head(&hba->ufsf.sdev_wait);
> +	atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> +
> +	if (hba->dev_info.wspecversion >= HPB_SUPPORT_VERSION &&
> +	    (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
> +		async_schedule(ufshpb_init, &hba->ufsf);
> +}

Why does this function use async_schedule()?

Thanks,

Bart.
