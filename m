Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0F6C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC4C241A5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kt4lAFIl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgKRItw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:49:52 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:23951 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgKRItv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 03:49:51 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605689390; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8ubPeUbv9nGA17bHuaYj4qnBJnm2N8KJxhb4W1TPD4Q=;
 b=kt4lAFIlhIAV/BLCURWuhUdgeTZLDscj/156/6RVmlBycSq4pF/gkr19kG10IhJqqRNUwcY4
 j/lV0RkIqkNesWjK9Xp0bnfK6NUfbAhK3HKaGZxt/XGZF8KblHkNHCUDq98iZmpk0tD37Gqx
 PQlyQgpqddA+FjHYS9c3Ww50ivk=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5fb4e02e309342b9149d05f0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Nov 2020 08:49:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E5590C433ED; Wed, 18 Nov 2020 08:49:49 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05AF5C433C6;
        Wed, 18 Nov 2020 08:49:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 16:49:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC v1 1/1] scsi: pm: Leave runtime resume along if block
 layer PM is enabled
In-Reply-To: <6d774277-b055-6924-cf2d-01e874ac3f7b@acm.org>
References: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
 <1605249009-13752-2-git-send-email-cang@codeaurora.org>
 <97dea590-5f2e-b4e3-ac64-7c346761c523@acm.org>
 <20f447a438aa98afb18be4642c8888b3@codeaurora.org>
 <6d774277-b055-6924-cf2d-01e874ac3f7b@acm.org>
Message-ID: <3d58c7a1971bbb2895a30122255ed2e1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-11-18 12:38, Bart Van Assche wrote:
> On 11/15/20 5:42 PM, Can Guo wrote:
>> Actually, I am thinking about removing all the pm_runtime_set_active()
>> codes in both scsi_bus_resume_common() and scsi_dev_type_resume() - we
>> don't need to forcibly set the runtime PM status to RPM_ACTIVE for 
>> either
>> SCSI host/target or SCSI devices.
>> 
>> Whenever we access one SCSI device, either block layer or somewhere in
>> the path (e.g. throgh sg IOCTL, sg_open() calls 
>> scsi_autopm_get_device())
>> should runtime resume the device first, and the runtime PM framework 
>> makes
>> sure device's parent (and its parent's parent and so on)gets resumed 
>> as
>> well.
>> Thus, the pm_runtime_set_active() seems redundant. What do you think?
> 
> Hi Can,
> 
> It is not clear to me why the pm_runtime_set_active() calls occur in 
> the
> scsi_pm.c source file since the block layer automatically activates
> block devices if necessary. Maybe these calls are a leftover from a 
> time
> when runtime suspended devices were not resumed automatically by the
> block layer? Anyway, I'm fine with removing these calls.
> 
> Thanks,
> 
> Bart.

Yes, I agree with you. Let me test the new patch (which removes all the
pm_runtime_set_active() calls) first, if no issue found, I will upload
it for review.

Thanks,

Can Guo.
