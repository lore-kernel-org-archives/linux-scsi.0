Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B32AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 01:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C636622242
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 01:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLWBcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:32:43 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:29842 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLWBcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 20:32:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608687139; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=h1bDyEJ9nAY42G2PbS2dTq2qdvlUkAJJiDtknBWsySM=;
 b=Vj61pXvR3Ui+xxj5nF5LNA/iiNwJuASEkQVmOvJE3/Ve9A5+YsaUDZC99CJRCDo8DAWL8irZ
 5uCgHnJQlQasZ4XG0dPI0rxjp1EiyAYbZhm7qvN0LfEI4Xqm5KZ894z/jYpgmnnnvEA+c/jk
 Rb7RywVXkj74y2b28nTzfomQrdA=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fe29e061d5c1fa4273c5e6e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Dec 2020 01:31:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5470DC43467; Wed, 23 Dec 2020 01:31:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 771C5C433C6;
        Wed, 23 Dec 2020 01:31:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Dec 2020 09:31:49 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
In-Reply-To: <28211d08700d1e4876a9aea342e8fcb79534cd2c.camel@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
 <20201215230519.15158-2-huobean@gmail.com>
 <1608617307.14045.3.camel@mtkswgap22>
 <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
 <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
 <28211d08700d1e4876a9aea342e8fcb79534cd2c.camel@gmail.com>
Message-ID: <862483add1462510b809aee6d3678435@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-23 06:11, Bean Huo wrote:
> On Tue, 2020-12-22 at 21:57 +0100, Bean Huo wrote:
>> > > May this operation race with UFS shutdown flow?
>> > >
>> > > To be more clear, ufshcd_wb_ctrl() here may be executed after
>> > > host
>> > > clock
>> > > is disabled by shutdown flow?
>> > >
>> > > If yes, we need to avoid it.
>> >
>> > I have the same doubt - can user still access sysfs nodes after
>> > system
>> > starts to run shutdown routines? If yes, then we need to remove all
>> > UFS
>> > sysfs nodes in ufshcd_shutdown().
>> >
>> 
>> No, we shouldn't do in this way, user space complains this. I think
>> the nodes in the sysfs can be shileded write, but the nodes shouldn't
>> be flash of its presence frequently.
>> 
>> Thanks,
>> Bean
>> 
>> 
>> > Thanks,
>> >
>> > Can Guo.
> 
> 
> Hi Can
> Got your point, you don't want user space to interrupt UFS by sysyfs if
> UFS is in power down mode. if this is true, insteading of removing all
> sysfs node in ufshcd_shutdown, maybe just add this checkup before
> accessing UFS device descriptors/flag/attributes/LU:
> 
> for example, for the device descriptor:
> 
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-
> sysfs.c
> index b3bf7fca00e5..881fe1c24a9f 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -262,6 +262,9 @@ static ssize_t ufs_sysfs_read_desc_param(struct
> ufs_hba *hba,
>         u8 desc_buf[8] = {0};
>         int ret;
> 
> +       if (!ufshcd_is_ufs_dev_active(hba) ||
> !ufshcd_is_link_active(hba))
> +               return -EACCES;
> +
> 
> Bean

First of all, this check is not helping at all, during 
ufshcd_shutdown(),
both the link and dev can be active for a moment, so this check is not
helping the race condition. And assume you come up with a better check,
you want to add the check everywhere? You must have noticed the fix to
the func ufshcd_clk_gate_enable_store() from Jaegeuk Kim. So, don't
expect any luck from user space, so long the sysfs nodes are available,
users can grasp them and even stress them just for testing purposes.
I don't see why removing the sysfs nodes during ufshcd_shutdown() is a
concern to customer - we should do whatever is needed to protect LLD
contexts from user space intervene. What do you think?

Can Guo.

Thanks,

Can Guo.
