Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50527C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 04:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1043320724
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 04:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U8NJlqoa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgGMEda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 00:33:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48049 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgGMEda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 00:33:30 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200713043326epoutp042b86dede9fbd89f6d00ae9b3973149e1~hNbfbVjf70874008740epoutp04W
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 04:33:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200713043326epoutp042b86dede9fbd89f6d00ae9b3973149e1~hNbfbVjf70874008740epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594614806;
        bh=TUu2y7yJdL0EbYQoUb8UWYUJ7q9FObrrUVnqafvzGNs=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=U8NJlqoarwrygfLxYqUdFZODyJC2etGgVmc6tm2akVqBtp3nkAfuMZG/KVViZAehp
         C5LylYtseGDmUPvYuc/cEotGQcCjGU2o9iDeVEGfk9VtRHQJBNNdbnINV//kkj2/7b
         e5DNk6mPv975trRsmVRRD8lAlaPV2WLIS5rz/QLE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200713043325epcas2p204ff14b18d0a5c9439414b79bec118b8~hNbeHrMHy0866008660epcas2p2v;
        Mon, 13 Jul 2020 04:33:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B4rPH3Rm7zMqYkY; Mon, 13 Jul
        2020 04:33:23 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.A7.19322.314EB0F5; Mon, 13 Jul 2020 13:33:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200713043322epcas2p3cf3a7f54656a9750e7b3269bcad6fefa~hNbbyCxod3016830168epcas2p30;
        Mon, 13 Jul 2020 04:33:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200713043322epsmtrp2763b4dc79c15244db1c439ebcc464764~hNbbxNNME0083400834epsmtrp2P;
        Mon, 13 Jul 2020 04:33:22 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-a2-5f0be413bbb7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.0B.08303.214EB0F5; Mon, 13 Jul 2020 13:33:22 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200713043322epsmtip149e30bfedf46ffbebcb2de63beb40c95~hNbbh4pAR3268432684epsmtip1O;
        Mon, 13 Jul 2020 04:33:22 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <000001d657ef$8c084200$a418c600$@samsung.com>
Subject: RE: [RFC PATCH v5 2/3] ufs: exynos: introduce command history
Date:   Mon, 13 Jul 2020 13:33:22 +0900
Message-ID: <000401d658ce$bdf18e40$39d4aac0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIueMtDWjJeafEhyFhDluPRduUJOgLIn2wwAYGYW/MB36EHOagjXMfA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmma7wE+54gznfJS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfj5d+F
        LAVnZCvO3DvP2MB4T7yLkZNDQsBEYueGQywgtpDADkaJyzOZuhi5gOxPjBKXXs5ghXA+M0o8
        ffKSCaajf+1HqKpdjBKHrr1jhHBeMEqs7DoHNotNQFti2sPdYO0iAneZJJYuXMzexcjBwSlg
        JfG8JQekRljATeJU2y6wehYBVYnnj1qYQUp4BSwlpnd5g4R5BQQlTs58AlbCLCAvsf3tHGaI
        IxQkfj5dxgpiiwCNOf5/EjNEjYjE7M42ZpC1EgJnOCR2vj7KDtHgIrF10W4WCFtY4tXxLVBx
        KYnP7/ayQdj1EvumNrBCNPcAvbzvHyNEwlhi1rN2RpDjmAU0Jdbv0gcxJQSUJY7cgrqNT6Lj
        8F92iDCvREebEESjssSvSZOhhkhKzLx5B2qrh8Tcf4uYJzAqzkLy5SwkX85C8s0shL0LGFlW
        MYqlFhTnpqcWGxUYIsf1JkZwatZy3cE4+e0HvUOMTByMhxglOJiVRHijRTnjhXhTEiurUovy
        44tKc1KLDzGaAoN9IrOUaHI+MDvklcQbmhqZmRlYmlqYmhlZKInz5ipeiBMSSE8sSc1OTS1I
        LYLpY+LglGpg2nz/ZZe+UF7G212rfiVZFca8zT9hlsfySyM992B26qYi7u/voly/vn7872BS
        7MeFIYe2/N0/KU7zVG+uGceahEUWpn0podsCG/7NvtMuebS47VoWy7yXGnvkeBLVJxanh+Q0
        T15SNCPtvea6Bk3Tr8+i6riX2575L3Blsps+S/rNpDBGi9ogm/W//TaLVZfY+01fOcfDhM9N
        65VayU71hhXCYRGNpbWNt9wrXoscLFPwuvX8V+jZL/OOVZq3c/k3JitHPUz3u3uu9c6S1Ut3
        yxzas54p/bmBw+OXBp3XM/R091mzX/EXm2rqsf7nv48mbz4Kf9y3Z/qiPfWCZ9/l36qND3Ty
        /LD8ejH7TV1lJZbijERDLeai4kQAMhq8aFYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWy7bCSnK7QE+54g0NLDC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CV8fLvQpaCM7IVZ+6dZ2xgvCfexcjJISFgItG/9iMTiC0ksINRYtphdoi4pMSJ
        nc8ZIWxhifstR1i7GDmAap4xSlwRBgmzCWhLTHu4GyjMxSEi8JZJ4sCvXjBHSKCDSeLMoy9s
        IA2cAlYSz1tyQBqEBdwkTrXtYgGxWQRUJZ4/amEGKeEVsJSY3uUNEuYVEJQ4OfMJWAkz0Pze
        h62MELa8xPa3c5ghzlGQ+Pl0GSuILQI08vj/ScwQNSISszvbmCcwCs1CMmoWklGzkIyahaRl
        ASPLKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4EjU0trBuGfVB71DjEwcjIcYJTiY
        lUR4o0U544V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2xJDU7NbUgtQgmy8TBKdXA
        xCT9M2t/qNpU4Ym1l+XPBR968F/lef6Lip/KXJI3hV7OU1H4F+xrdDmwcrai0Ow+g6mZZwJj
        Vj9hX/Df0DXsRnzlpBlPM61nLH4tt5nltkicnc+xVsb022Jis4/z74rMD7leyOclMsfh5Gb+
        7XeFU9O8Q3ZFfOjv5Jn0zPzUPbuVbJVf4jguLNmkWFSZV28SevxGcEWm5/fEmzOufYll2Cm+
        8vR1n5vZHwK2CV3V0+pfrq20wFfD55xVWiH34guVZ75pprG/F3sg9Ep5+toZHBPCVP8urg+z
        +tOlcdLoXJ7astZlV8xXLot5G1kvrz/h7eWd3FY7lqemu+28wCs7855C2LbctzEtB+NmT4yx
        UGIpzkg01GIuKk4EAC4lZdkzAwAA
X-CMS-MailID: 20200713043322epcas2p3cf3a7f54656a9750e7b3269bcad6fefa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200711070544epcas2p4d3a75d2f56b8162c09efa0eeaf012fa2
References: <cover.1594450408.git.kwmad.kim@samsung.com>
        <CGME20200711070544epcas2p4d3a75d2f56b8162c09efa0eeaf012fa2@epcas2p4.samsung.com>
        <71f2a8e3fdfcf9f60cc8b5e14acf3a57cf22d4f8.1594450408.git.kwmad.kim@samsung.com>
        <000001d657ef$8c084200$a418c600$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
> 
> > -----Original Message-----
> > From: Kiwoong Kim <kwmad.kim@samsung.com>
> > Sent: 11 July 2020 12:28
> > To: linux-scsi@vger.kernel.org; alim.akhtar@samsung.com;
> > avri.altman@wdc.com; jejb@linux.ibm.com; martin.petersen@oracle.com;
> > beanhuo@micron.com; asutoshd@codeaurora.org; cang@codeaurora.org;
> > bvanassche@acm.org; grant.jung@samsung.com; sc.suh@samsung.com;
> > hy50.seo@samsung.com; sh425.lee@samsung.com
> > Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> > Subject: [RFC PATCH v5 2/3] ufs: exynos: introduce command history
> >
> > This includes functions to record contexts of incoming commands in a
> > circular queue. ufshcd.c has already some function tracer calls to get
> > command history but ftrace would be gone when system dies before you
> > get the information, such as panic cases.
> >
> > This patch also implements callbacks compl_xfer_req to store IO
> > contexts at completion times.
> >
> > When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG, the driver collects
> > the information from incoming commands in the circular queue.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > +void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
> > +			      struct ufs_hba *hba, int tag) {
> > +	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
> > +	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
> > +	int cpu = raw_smp_processor_id();
> > +	struct cmd_data *cmd_log = &mgr->cmd_log;	/* temp buffer to put
> > */
> > +	u64 lba = 0;
> > +	u32 sct = 0;
> > +
> > +	if (mgr->active == 0)
> > +		return;
> > +
> > +	cmd_log->start_time = cpu_clock(cpu);
> > +	cmd_log->op = cmd->cmnd[0];
> > +	cmd_log->tag = tag;
> > +
> > +	/* This function runtime is protected by spinlock from outside */
> > +	cmd_log->outstanding_reqs = hba->outstanding_reqs;
> > +
> > +	/* Now assume using WRITE_10 and READ_10 */
> > +	put_unaligned(cpu_to_le32(*(u32 *)cmd->cmnd[2]), (u32 *)&lba);
> This gives compilation error, you need to include <asm-
> generic/unaligned.h> Also type casting to u32 is not needed, will give
> build warnings.
> 
> > +	put_unaligned(cpu_to_le16(*(u16 *)cmd->cmnd[7]), (u16 *)&sct);
> Type casting to u16 is not needed.
> 
> > +	if (cmd->cmnd[0] != UNMAP)
> > +		cmd_log->lba = lba;
> > +
> > +	cmd_log->sct = sct;
> > +	cmd_log->retries = cmd->allowed;
> > +
> > +	ufs_s_put_cmd_log(mgr, cmd_log);
> > +}
> > +
> > +void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
> > +			    struct ufs_hba *hba, int tag)
> > +{
> > +	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
> > +	struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
> Unused variable "cmd"
> 
> > +	struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
> > +	int cpu = raw_smp_processor_id();
> > +
> > +	if (mgr->active == 0)
> > +		return;
> > +
> > +	cmd_info->pdata[tag]->end_time = cpu_clock(cpu); }
> > +
> > +int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct
> > +device
> > +*dev) {
> > +	struct ufs_s_dbg_mgr *mgr;
> > +
> > +	mgr = devm_kzalloc(dev, sizeof(struct ufs_s_dbg_mgr), GFP_KERNEL);
> > +	if (!mgr)
> > +		return -ENOMEM;
> > +	handle->private = (void *)mgr;
> > +	mgr->handle = handle;
> > +	mgr->active = 1;
> > +
> > +	/* cmd log */
> > +	spin_lock_init(&mgr->cmd_lock);
> > +
> > +	return 0;
> > +}
> > +MODULE_AUTHOR("Kiwoong Kim <kwmad.kim@samsung.com>");
> > +MODULE_DESCRIPTION("Exynos UFS debug information");
> > +MODULE_LICENSE("GPL"); MODULE_VERSION("0.1");
> May be "GPL v2"
> 
> > diff --git a/drivers/scsi/ufs/ufs-exynos-if.h
> > b/drivers/scsi/ufs/ufs-exynos-if.h
> > new file mode 100644
> > 2.7.4
> 

Have Checked what you commented.

Thanks.
Kiwoong Kim

