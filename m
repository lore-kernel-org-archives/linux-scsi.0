Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C65BC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 13:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB98D221E2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 13:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tKLu6W8g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgHGNCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 09:02:14 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12142 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgHGNCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Aug 2020 09:02:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596805333; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mc38/opTEptAuWJc70jptxAnqwYZATU+evTD+ABr2Ms=;
 b=tKLu6W8gpQXegOR2AVqPIBTS94/DrNlYs3x9t8o2GN63UUjKWovSlZddQqw2au59+Un8R79M
 TB40CYlx0M6cwtuqxLkJF7FWavy/1nGMmAuO3WF2k549tavw/MwZfxyi/g3liwIc+ujB4Oze
 xJrE5Xak4uxXuuIb/l3jYZkxigk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f2d50bb8567201751ad7bc0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 Aug 2020 13:01:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 51D89C433AD; Fri,  7 Aug 2020 13:01:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 856CCC433C9;
        Fri,  7 Aug 2020 13:01:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 07 Aug 2020 21:01:45 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D. Nguyen" <nguyenb@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Hongwu Su <hongwus@codeaurora.org>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Mark Salyzyn <salyzyn@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: [PATCH 9/9] scsi: ufs: Properly release resources if a task is
 aborted successfully
In-Reply-To: <a752927b-dd9b-ebf0-8c77-e2ae0b2aa475@web.de>
References: <a752927b-dd9b-ebf0-8c77-e2ae0b2aa475@web.de>
Message-ID: <fc5c328732792aca1dd451d0109f00b5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Markus,

On 2020-08-07 17:33, Markus Elfring wrote:
>> … To fix it, …
> 
> I propose to replace this wording by the tag “Fixes”.
> 
> 
>> … "mannually", …
> 
> Please avoid a typo:
> … "manually", …
> 
> 
> Regards,
> Markus

Thanks, will fix these in next version.

Regards,
Can Guo.
