Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2641C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA30613F2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243589AbhDFEiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:38:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62396 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbhDFEiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:38:11 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210406043802epoutp02bc77ed3b820daae0962f9e7f5f943876~zKuuOvk9O0142601426epoutp020
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 04:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210406043802epoutp02bc77ed3b820daae0962f9e7f5f943876~zKuuOvk9O0142601426epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617683882;
        bh=cluGM44R5WOQaZ+AAkjY1huKsxNJn1WDAGgg6GaO4zs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LbO1CICzEwMrSnosRIGP6Oj5iFQvFj5xik229J/uYnTPSbniqcZ3J1GqzoVp+1Xyt
         q9+NK/sejpMDO0K5NhwoxoA/BAYI2pjEIkHBlmz4vaweahFOvC1rDzICnLEWtMaD2s
         aPZHxctxs/SsBX5VHVkW4TD2i7YakTXyKMaxyzMk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210406043801epcas3p214f94096eb26a1fe7bf2a7ee7ccd537a~zKutmJl3O0726507265epcas3p2R;
        Tue,  6 Apr 2021 04:38:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4FDvsP4W9vz4x9QF; Tue,  6 Apr 2021 04:38:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 1/2] scsi: ufs: Introduce hba performance monitor sysfs
 nodes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1617257704-1154-2-git-send-email-cang@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01617683881598.JavaMail.epsvc@epcpadp4>
Date:   Tue, 06 Apr 2021 13:11:40 +0900
X-CMS-MailID: 20210406041140epcms2p5a717b30f522bd99c8b3c805397a73692
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52
References: <1617257704-1154-2-git-send-email-cang@codeaurora.org>
        <1617257704-1154-1-git-send-email-cang@codeaurora.org>
        <CGME20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

> +static ssize_t monitor_enable_store(struct device *dev,
> +                                    struct device_attribute *attr,
> +                                    const char *buf, size_t count)
> +{
> +        struct ufs_hba *hba = dev_get_drvdata(dev);
> +        unsigned long value, flags;
> +
> +        if (kstrtoul(buf, 0, &value))
> +                return -EINVAL;
> +
> +        value = !!value;
> +        spin_lock_irqsave(hba->host->host_lock, flags);
> +        if (value == hba->monitor.enabled)
> +                goto out_unlock;
> +
> +        if (!value) {
> +                memset(&hba->monitor, 0, sizeof(hba->monitor));
> +        } else {
> +                hba->monitor.enabled = true;
> +                hba->monitor.enabled_ts = ktime_get();

How about setting lat_max to and lat_min to KTIME_MAX and 0?
I think lat_sum should be 0 at this point.

> +        }
> +
> +out_unlock:
> +        spin_unlock_irqrestore(hba->host->host_lock, flags);
> +        return count;
> +}


> +static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +        int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
> +
> +        if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
> +                struct request *req = lrbp->cmd->request;
> +                struct ufs_hba_monitor *m = &hba->monitor;
> +                ktime_t now, inc, lat;
> +
> +                now = ktime_get();

How about using lrbp->compl_time_stamp instead of getting new value?

> +                inc = ktime_sub(now, m->busy_start_ts[dir]);
> +                m->total_busy[dir] = ktime_add(m->total_busy[dir], inc);
> +                m->nr_sec_rw[dir] += blk_rq_sectors(req);
> +
> +                /* Update latencies */
> +                m->nr_req[dir]++;
> +                lat = ktime_sub(now, lrbp->issue_time_stamp);
> +                m->lat_sum[dir] += lat;
> +                if (m->lat_max[dir] < lat || !m->lat_max[dir])
> +                        m->lat_max[dir] = lat;
> +                if (m->lat_min[dir] > lat || !m->lat_min[dir])
> +                        m->lat_min[dir] = lat;

This if statement can be shorted, by setting lat_max / lat_min as default value.

> +
> +                m->nr_queued[dir]--;
> +                /* Push forward the busy start of monitor */
> +                m->busy_start_ts[dir] = now;
> +        }
> +}

Thanks,
Daejun
