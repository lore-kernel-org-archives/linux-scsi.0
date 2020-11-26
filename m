Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78289C6379D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1248B21534
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="pPkEQDCu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgKZBZb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:25:31 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:30803 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKZBZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 20:25:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606353929; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=V16thVLdBJdUt6KU8AVud/cH+EtHnsC94YUQORQwInc=;
 b=pPkEQDCu0/IionCXxC9sDpcereCAzcdoE/7T2TCFo3IRcd31LnpHN9ZVvlD1aAWbJ9+ljBnC
 xlEIYutbwjadys+AkgIK0lFs3RQgSaZlwbEBatIMRk7syi5nbGpaXcysD4UftrfFhKtocsL+
 8QdF8PSzqr5gFqNGUFxf4o0Xeds=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fbf040022377520eec09504 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 26 Nov 2020 01:25:20
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 65DD8C43465; Thu, 26 Nov 2020 01:25:20 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32D74C433ED;
        Thu, 26 Nov 2020 01:25:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 09:25:19 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
In-Reply-To: <1606352316.23925.1.camel@mtkswgap22>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-2-git-send-email-cang@codeaurora.org>
 <1606352316.23925.1.camel@mtkswgap22>
Message-ID: <07687efa0e49a5c2266deadad94c92dd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 08:58, Stanley Chu wrote:
> Hi Can,
> 
> "Refector" in title shall be "Refactor"?
> 
> On Mon, 2020-11-23 at 23:28 -0800, Can Guo wrote:
>> Remove the param skip_ref_clk from __ufshcd_setup_clocks(), but keep a 
>> flag
>> in struct ufs_clk_info to tell whether a clock can be disabled or not 
>> while
>> the link is active.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> Otherwise looks good to me.
> 

Sorry, will fix it in next version.

Thanks,

Can Guo.

> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
