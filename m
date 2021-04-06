Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85ED2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51289613AF
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhDFGLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:11:34 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10666 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhDFGLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 02:11:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617689486; h=Message-ID: References: In-Reply-To: Subject:
 To: From: Date: Content-Transfer-Encoding: Content-Type: MIME-Version:
 Sender; bh=LFtlMeteySqkbg9VW89fzgUU8QYwhiAabX+uMoEasZE=; b=P8Kr2BupSCed3SNnztu9EljebZszNqi6o6XMsOSQIuSK5ToI8PCDPspb1C3CeIc94FO5GWqL
 NalV0Odfeo0jtVZadeSXZziGuEwb7KIh5u3NAOkxoha6sJ4f2sAm/FRQNRJ0QPb56RrueXul
 WTlv+Rgy1vCcXG6+yKGvSl6lFMw=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 606bfb889a9ff96d953862e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Apr 2021 06:11:20
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 90874C43468; Tue,  6 Apr 2021 06:11:20 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6920CC433C6;
        Tue,  6 Apr 2021 06:11:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 14:11:19 +0800
From:   Can Guo <cang@codeaurora.org>
To:     undisclosed-recipients:;
Subject: Re: [PATCH 1/2] scsi: ufs: Introduce hba performance monitor sysfs
 nodes
In-Reply-To: <1891546521.01617689102000.JavaMail.epsvc@epcpadp3>
References: <e29c3fa0d5ecfd8eb386432008f24e8c@codeaurora.org>
 <1617257704-1154-2-git-send-email-cang@codeaurora.org>
 <1617257704-1154-1-git-send-email-cang@codeaurora.org>
 <1891546521.01617683881598.JavaMail.epsvc@epcpadp4>
 <CGME20210401061611epcas2p279c9303e0e0bf4e2bc5eb1f4ffd84c52@epcms2p6>
 <1891546521.01617689102000.JavaMail.epsvc@epcpadp3>
Message-ID: <9b0a9a7770e6dbbee9bba2a991dd6229@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-06 13:58, Daejun Park wrote:
> Hi Can Guo,
>> 
>> Hi Daejun,
>> 
>> On 2021-04-06 12:11, Daejun Park wrote:
>>> Hi Can Guo,
>>> 
>>>> +static ssize_t monitor_enable_store(struct device *dev,
>>>> +                                    struct device_attribute *attr,
>>>> +                                    const char *buf, size_t count)
>>>> +{
>>>> +        struct ufs_hba *hba = dev_get_drvdata(dev);
>>>> +        unsigned long value, flags;
>>>> +
>>>> +        if (kstrtoul(buf, 0, &value))
>>>> +                return -EINVAL;
>>>> +
>>>> +        value = !!value;
>>>> +        spin_lock_irqsave(hba->host->host_lock, flags);
>>>> +        if (value == hba->monitor.enabled)
>>>> +                goto out_unlock;
>>>> +
>>>> +        if (!value) {
>>>> +                memset(&hba->monitor, 0, sizeof(hba->monitor));
>>>> +        } else {
>>>> +                hba->monitor.enabled = true;
>>>> +                hba->monitor.enabled_ts = ktime_get();
>>> 
>>> How about setting lat_max to and lat_min to KTIME_MAX and 0?
>> 
>> lat_min is already 0. What is the benefit of setting lat_max to
>> KTIME_MAX?
>> 
>>> I think lat_sum should be 0 at this point.
>> 
>> lat_sum is already 0 at this point, what is the problem?
> 
> Sorry. I misunderstood about resetting monitor values.
> 
>> 
>>> 
>>>> +        }
>>>> +
>>>> +out_unlock:
>>>> +        spin_unlock_irqrestore(hba->host->host_lock, flags);
>>>> +        return count;
>>>> +}
>>> 
>>> 
>>>> +static void ufshcd_update_monitor(struct ufs_hba *hba, struct
>>>> ufshcd_lrb *lrbp)
>>>> +{
>>>> +        int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
>>>> +
>>>> +        if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
>>>> +                struct request *req = lrbp->cmd->request;
>>>> +                struct ufs_hba_monitor *m = &hba->monitor;
>>>> +                ktime_t now, inc, lat;
>>>> +
>>>> +                now = ktime_get();
>>> 
>>> How about using lrbp->compl_time_stamp instead of getting new value?
>> 
>> I am expecting "now" keeps increasing and use it to update
>> m->busy_start_s,
>> but if I use lrbp->compl_time_stamp to do that, below line ktime_sub()
>> may
>> give me an unexpected value as lrbp->compl_time_stamp may be smaller
>> than
>> m->busy_start_ts, because the actual requests are not completed by the
>> device
>> in the exact same ordering as the bits set in hba->outstanding_tasks,
>> but driver
>> is completing them from bit 0 to bit 31 in ascending order.
> 
> lrbp->compl_time_stamp is set just before calling 
> ufshcd_update_monitor().
> And I don't think it can be negative value, because 
> ufshcd_send_command()
> and __ufshcd_transfer_req_compl() are protected by host lock.
> 

Yes, I replied u in another mail... I will use the compl_time_stamp in 
next
version. And later I will add alloc_time_stamp and release_time_stamp to 
lrbp
so that we can monitor the overall send/compl path, including hpb_prep() 
and
hpb_rsp().

>> 
>>> 
>>>> +                inc = ktime_sub(now, m->busy_start_ts[dir]);
>>>> +                m->total_busy[dir] = ktime_add(m->total_busy[dir],
>>>> inc);
>>>> +                m->nr_sec_rw[dir] += blk_rq_sectors(req);
>>>> +
>>>> +                /* Update latencies */
>>>> +                m->nr_req[dir]++;
>>>> +                lat = ktime_sub(now, lrbp->issue_time_stamp);
>>>> +                m->lat_sum[dir] += lat;
>>>> +                if (m->lat_max[dir] < lat || !m->lat_max[dir])
>>>> +                        m->lat_max[dir] = lat;
>>>> +                if (m->lat_min[dir] > lat || !m->lat_min[dir])
>>>> +                        m->lat_min[dir] = lat;
>>> 
>>> This if statement can be shorted, by setting lat_max / lat_min as
>>> default value.
>> 
>> I don't quite get it, can you show me the code sample?
> 
> I think " || !m->lat_max[dir]" can be removed.
> 
>                 if (m->lat_max[dir] < lat)
>                         m->lat_max[dir] = lat;
>                 if (m->lat_min[dir] > lat)
>                         m->lat_min[dir] = lat;
> 

 From the beginning, lat_min is 0, without "!m->lat_min[dir]", m->lat_min
will never be updated. Same for lat_max. Meanwhile, !m->lat_min/max will
be hit only once in each round, which does not hurt.

Thanks,
Can Guo.

> Thanks,
> Daejun
> 
>> 
>> Thanks,
>> Can Guo
>> 
>>> 
>>>> +
>>>> +                m->nr_queued[dir]--;
>>>> +                /* Push forward the busy start of monitor */
>>>> +                m->busy_start_ts[dir] = now;
>>>> +        }
>>>> +}
>>> 
>>> Thanks,
>>> Daejun
