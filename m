Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4311DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 15:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhKXPKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 10:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhKXPKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 10:10:02 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E477C061574
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 07:06:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j3so4826744wrp.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 07:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=9wAFQv4+BFq06vpwRuVg402YAyK43z7S50+vVCRUhLs=;
        b=MJfXzIl7777dN0hLswz1rXpy5j6cnKqhC46IlzR8VOZHS5XSBJG35kvt0KqPW1Fg4V
         YCqxQeur+VUxYoAyuAZq3FtT85C7PTagkOdjVMIhF2Gu5BwZqnj3oMFOv0WxbccQjCom
         RA19SYcbumRKnZBlxfua76GYjL3j242xthMYdf5gxj2AvoMFNpnmBEy0BtG203tIFT0D
         CGz+cnRl7gy5r3mbHXpBEDcdo7AETQunCoxlxG0sI91pXLLd1tREwT3xclJ40r8PtWoj
         tmu4S5Lclti2Ia7NOPxAZtwhFp5GnzV0btNvrlnSthERHXlVb2NVE/oF1SJvXwdBNii6
         EigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9wAFQv4+BFq06vpwRuVg402YAyK43z7S50+vVCRUhLs=;
        b=W86jl6PZI7zdneV9TxicnCXyU+fuqN41LaQWyt9vz6J64MLG7dYnwAb5lMXTmdVOVd
         tUDDmOBqJPaYr8hmr9o9obPwQ0iluNY5URvgLuQ+4xuRpOgFf1o/EI/o6GOJ0fbJNok8
         gb5uejuei6FRkeUWfRR/G51pe9D9S3VASFs85UN8OpZFmEtchm7zmC2r66TNr9gS/isB
         YZ14GATH/Sc2cYnq4XruuKQ3qBZ8Fc56GPLQ1zIqHhGwlfb0JN9KDJ2PsUwkUo5rkBKJ
         LD+eHxvrn6XRshVucnFngXHwxH+yNVwopz/s5mqkK0e80jpKRU4kWA+K609K6rE38w99
         tWAQ==
X-Gm-Message-State: AOAM531akiidmJO7/D0Z0DxYqQ+DSMQuxwSMNpaA8A/s0DRLD+he2jpG
        UfiS7hsP6hw5v+jkxbZ0ZXI=
X-Google-Smtp-Source: ABdhPJzITUttZSlXoJsTPrit7U7fpL0Axbn4Lidlnqd7DodSFf3QKJ2PW8QXF9LU5kR6AtT4C37B5A==
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr18700730wrw.312.1637766409872;
        Wed, 24 Nov 2021 07:06:49 -0800 (PST)
Received: from p200300e94719c92bf4a887f9e51081f6.dip0.t-ipconnect.de (p200300e94719c92bf4a887f9e51081f6.dip0.t-ipconnect.de. [2003:e9:4719:c92b:f4a8:87f9:e510:81f6])
        by smtp.googlemail.com with ESMTPSA id g4sm97773wro.12.2021.11.24.07.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 07:06:49 -0800 (PST)
Message-ID: <73922deedb087beed3b8ff7ed683972bae6054a2.camel@gmail.com>
Subject: Re: [PATCH V8 1/1] scsi: ufs: Let devices remain runtime suspended
 during system suspend
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Date:   Wed, 24 Nov 2021 16:06:48 +0100
In-Reply-To: <20211027130614.406985-2-adrian.hunter@intel.com>
References: <20211027130614.406985-1-adrian.hunter@intel.com>
         <20211027130614.406985-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-27 at 16:06 +0300, Adrian Hunter wrote:
> If the UFS Device WLUN is runtime suspended and is in the same power
> 
> mode, link state and b_rpm_dev_flush_capable (BKOP or WB buffer flush
> etc)
> 
> state, then it can remain runtime suspended instead of being runtime
> 
> resumed and then system suspended.
> 
> 
> 
> The following patch has cleared the way for that to happen:
> 
>   scsi: core: pm: Only runtime resume if necessary
> 
> 
> 
> So amend the logic accordingly.
> 
> 
> 
> Note, the ufs-hisi driver uses different RPM and SPM, but it is made
> 
> explicit by a new parameter to suspend prepare.
> 
> 
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

