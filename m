Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3680C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 00:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764872151B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 00:54:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="TGxR+Iju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgKYAyK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 19:54:10 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:59533 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgKYAyJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 19:54:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606265649; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=HUsEpWpEk8fh+QW/RzVw1weMcorPYrNWedOn0ByEUqA=;
 b=TGxR+IjuAinRS394qZ9l9kEvRj9dWVESTOkWsvI1/mdLlN5J1zDKGONZsvQMRnalv/pa4US1
 WFKEQE9qbWNcfwZGh7k4zcNxwyCP7yfzEr9Sh399GqiUiRWQmtyzu2aKAmHdzDJPpV4OOR/O
 TxuqcfNoojEvnItpmIfibH4AunU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fbdab13a5c560669c48b36d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 00:53:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A30BC4346A; Wed, 25 Nov 2020 00:53:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21CB5C433ED;
        Wed, 25 Nov 2020 00:53:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 08:53:37 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
In-Reply-To: <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-2-git-send-email-cang@codeaurora.org>
 <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
Message-ID: <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-25 05:09, Bean Huo wrote:
> On Mon, 2020-11-23 at 23:28 -0800, Can Guo wrote:
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -229,6 +229,8 @@ struct ufs_dev_cmd {
>>   * @max_freq: maximum frequency supported by the clock
>>   * @min_freq: min frequency that can be used for clock scaling
>>   * @curr_freq: indicates the current frequency that it is set to
>> + * @always_on_while_link_active: indicate that the clk should not be
>> disabled if
>> +                                link is still active
>>   * @enabled: variable to check against multiple enable/disable
>>   */
>>  struct ufs_clk_info {
>> @@ -238,6 +240,7 @@ struct ufs_clk_info {
>>         u32 max_freq;
>>         u32 min_freq;
>>         u32 curr_freq;
>> +       bool always_on_while_link_active;
> 
> Can,
> using a sentence as a parameter name looks a little bit clumsy to me.
> The meaning has been explained in the comments section. How about
> simplify it and in line with other parameters in the structure?
> 

Do you have a better name in mind?

Thanks,

Can Guo.

> Thanks,
> Bean
> 
>>         bool enabled;
>>  };
>> 
