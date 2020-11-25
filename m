Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D29EC2D0E4
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 02:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B642067D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 02:02:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Yur+7ih2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgKYCCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:02:07 -0500
Received: from z5.mailgun.us ([104.130.96.5]:13795 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgKYCCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 21:02:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606269726; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=S6E44d3995g7vEC1l0zAsDxmqGgmEe2drvRJsKeYYSA=;
 b=Yur+7ih2yQb+9zsrNORLYMTjov5XNC30glgEaucTs1UbW9RrdjFHtNMiYAiEOFUOLvnDcdax
 g5eYv/Zv3r5XF7hFjtQKCjPhtbwb7TjDwzYuzRmgbOV/6klidZd04862ObfNhm45gNAp4E8d
 FSioxvpRvCLiHUCgGp4WKxFTt34=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5fbdbae31dba509aaea3fe4a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 02:01:07
 GMT
Sender: hongwus=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6BCDFC43468; Wed, 25 Nov 2020 02:01:06 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A80BC433C6;
        Wed, 25 Nov 2020 02:01:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 10:01:05 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     Bean Huo <huobean@gmail.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        cang=codeaurora.org@codeaurora.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
In-Reply-To: <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-2-git-send-email-cang@codeaurora.org>
 <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
 <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
Message-ID: <2bdcfeaa104a380425faa68a0479534d@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-25 08:53, Can Guo wrote:
> On 2020-11-25 05:09, Bean Huo wrote:
>> On Mon, 2020-11-23 at 23:28 -0800, Can Guo wrote:
>>> +++ b/drivers/scsi/ufs/ufshcd.h
>>> @@ -229,6 +229,8 @@ struct ufs_dev_cmd {
>>>   * @max_freq: maximum frequency supported by the clock
>>>   * @min_freq: min frequency that can be used for clock scaling
>>>   * @curr_freq: indicates the current frequency that it is set to
>>> + * @always_on_while_link_active: indicate that the clk should not be
>>> disabled if
>>> +                                link is still active
>>>   * @enabled: variable to check against multiple enable/disable
>>>   */
>>>  struct ufs_clk_info {
>>> @@ -238,6 +240,7 @@ struct ufs_clk_info {
>>>         u32 max_freq;
>>>         u32 min_freq;
>>>         u32 curr_freq;
>>> +       bool always_on_while_link_active;
>> 
>> Can,
>> using a sentence as a parameter name looks a little bit clumsy to me.
>> The meaning has been explained in the comments section. How about
>> simplify it and in line with other parameters in the structure?
>> 
> 
> Do you have a better name in mind?
> 
> Thanks,
> 
> Can Guo.
> 
>> Thanks,
>> Bean
>> 
>>>         bool enabled;
>>>  };
>>> 

Looks good to me. The variable name is not a problem.

Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
