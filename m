Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C8AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5A21613A3
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 05:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbhDFFhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 01:37:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:47688 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhDFFhj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 01:37:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617687449; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=D4WmUB4gaCM3Asypeaei1ZMJSInX9OL35mr8oRjNLpA=;
 b=VpStZ3Pa1YAJuIEyJaf9HZctvON+VixWUGYIxZzbG+Z8HHy5tRSf+/XPIa4czpxqNtbsy7/I
 K73mwJvd4Y44uhbcmwU8UOjbkO004k+xlTS2swH4bv42XxA4CddKkODoZIRsMVw4oB7Ck6nP
 w24A8Rbsx7cHoqulaXeFYDhCAAI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 606bf3992cc44d3aeadacb36 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Apr 2021 05:37:29
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2FB77C43465; Tue,  6 Apr 2021 05:37:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 352ECC433C6;
        Tue,  6 Apr 2021 05:37:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 13:37:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
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
Subject: Re: [PATCH 1/2] scsi: ufs: Introduce hba performance monitor sysfs
 nodes
In-Reply-To: <1891546521.01617683881598.JavaMail.epsvc@epcpadp4>
References: <1617257704-1154-2-git-send-email-cang@codeaurora.org>
 <1617257704-1154-1-git-send-email-cang@codeaurora.org>
 <CGME20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52@epcms2p5>
 <1891546521.01617683881598.JavaMail.epsvc@epcpadp4>
Message-ID: <e29c3fa0d5ecfd8eb386432008f24e8c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun,

On 2021-04-06 12:11, Daejun Park wrote:
> Hi Can Guo,
> 
>> +static ssize_t monitor_enable_store(struct device *dev,
>> +                                    struct device_attribute *attr,
>> +                                    const char *buf, size_t count)
>> +{
>> +        struct ufs_hba *hba = dev_get_drvdata(dev);
>> +        unsigned long value, flags;
>> +
>> +        if (kstrtoul(buf, 0, &value))
>> +                return -EINVAL;
>> +
>> +        value = !!value;
>> +        spin_lock_irqsave(hba->host->host_lock, flags);
>> +        if (value == hba->monitor.enabled)
>> +                goto out_unlock;
>> +
>> +        if (!value) {
>> +                memset(&hba->monitor, 0, sizeof(hba->monitor));
>> +        } else {
>> +                hba->monitor.enabled = true;
>> +                hba->monitor.enabled_ts = ktime_get();
> 
> How about setting lat_max to and lat_min to KTIME_MAX and 0?

lat_min is already 0. What is the benefit of setting lat_max to 
KTIME_MAX?

> I think lat_sum should be 0 at this point.

lat_sum is already 0 at this point, what is the problem?

> 
>> +        }
>> +
>> +out_unlock:
>> +        spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +        return count;
>> +}
> 
> 
>> +static void ufshcd_update_monitor(struct ufs_hba *hba, struct 
>> ufshcd_lrb *lrbp)
>> +{
>> +        int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
>> +
>> +        if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
>> +                struct request *req = lrbp->cmd->request;
>> +                struct ufs_hba_monitor *m = &hba->monitor;
>> +                ktime_t now, inc, lat;
>> +
>> +                now = ktime_get();
> 
> How about using lrbp->compl_time_stamp instead of getting new value?

I am expecting "now" keeps increasing and use it to update 
m->busy_start_s,
but if I use lrbp->compl_time_stamp to do that, below line ktime_sub() 
may
give me an unexpected value as lrbp->compl_time_stamp may be smaller 
than
m->busy_start_ts, because the actual requests are not completed by the 
device
in the exact same ordering as the bits set in hba->outstanding_tasks, 
but driver
is completing them from bit 0 to bit 31 in ascending order.

> 
>> +                inc = ktime_sub(now, m->busy_start_ts[dir]);
>> +                m->total_busy[dir] = ktime_add(m->total_busy[dir], 
>> inc);
>> +                m->nr_sec_rw[dir] += blk_rq_sectors(req);
>> +
>> +                /* Update latencies */
>> +                m->nr_req[dir]++;
>> +                lat = ktime_sub(now, lrbp->issue_time_stamp);
>> +                m->lat_sum[dir] += lat;
>> +                if (m->lat_max[dir] < lat || !m->lat_max[dir])
>> +                        m->lat_max[dir] = lat;
>> +                if (m->lat_min[dir] > lat || !m->lat_min[dir])
>> +                        m->lat_min[dir] = lat;
> 
> This if statement can be shorted, by setting lat_max / lat_min as 
> default value.

I don't quite get it, can you show me the code sample?

Thanks,
Can Guo

> 
>> +
>> +                m->nr_queued[dir]--;
>> +                /* Push forward the busy start of monitor */
>> +                m->busy_start_ts[dir] = now;
>> +        }
>> +}
> 
> Thanks,
> Daejun
