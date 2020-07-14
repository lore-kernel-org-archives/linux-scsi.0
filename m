Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE83C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 421BA21D90
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="knJcj1jO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgGNEMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:12:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36321 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbgGNEMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 00:12:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594699954; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XBcjJwlLi5e8UJxwpFLfDWxhorCwwJpmtJ41g/1puLk=;
 b=knJcj1jOwNaWsxjOfn5IsFAxSmSDLdOxH6ldn1klHQoUuaaiN2cErQWGinfWSrotTnL9pXqm
 kxWxLuiy4fmtE7nvW5Ch95h6iEwb/G5/PfvEZUBHpXZ4tVzuJ13H+9VY4Q+tdu/eTr2W6ISm
 qh6f7Orjdq3TzKBiwmQn8UH6Pwc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f0d308b1012768490038565 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Jul 2020 04:11:55
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B7FCEC433CB; Tue, 14 Jul 2020 04:11:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F30ECC433CA;
        Tue, 14 Jul 2020 04:11:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jul 2020 12:11:53 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] scsi: ufs: Add checks before setting clk-gating
 states
In-Reply-To: <31ef233b-2562-2f61-d899-587092b5c033@acm.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
 <1594693693-22466-2-git-send-email-cang@codeaurora.org>
 <31ef233b-2562-2f61-d899-587092b5c033@acm.org>
Message-ID: <f598fd46a548d86b7dd363351920341e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-07-14 11:38, Bart Van Assche wrote:
> On 2020-07-13 19:28, Can Guo wrote:
>> @@ -2538,7 +2540,8 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *cmd)
>>  		err = SCSI_MLQUEUE_HOST_BUSY;
>>  		goto out;
>>  	}
>> -	WARN_ON(hba->clk_gating.state != CLKS_ON);
>> +	if (ufshcd_is_clkgating_allowed(hba))
>> +		WARN_ON(hba->clk_gating.state != CLKS_ON);
> 
> A minor comment: has it been considered to change this into the
> following?
> 
> 	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
> 		hba->clk_gating.state != CLKS_ON);
> 
> Thanks,
> 
> Bart.

Sure, will do that.

Thanks,

Can Guo.
