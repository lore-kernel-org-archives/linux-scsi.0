Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3913FC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 06:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D6E20774
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 06:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Sh+PuwBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgHNGcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 02:32:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29774 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgHNGcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Aug 2020 02:32:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597386738; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GtZh4Kd4Xj61251vTNQM2ZvbKpTI8dSHon6ULLbS4pw=;
 b=Sh+PuwBgDVuf8E4+ZtFN1tEsGd9EyPi2LvCafa2TsNPDbGmbw07GWwgM3BZMBfc4emkqyOll
 D3cY8LLv8kRqUZBekUXlB79rsFuOcsZhTPB6VYgwXUukr++PK+ctrLhV0ABZuSs61HnPtjSK
 fUQNx8AnY1Jdlt10sMaZabT30xQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f362feb1e4d3989d4aeb596 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 06:32:11
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B0902C433CB; Fri, 14 Aug 2020 06:32:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 57847C433C9;
        Fri, 14 Aug 2020 06:32:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Aug 2020 14:32:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v11 0/9] Fix up and simplify error recovery mechanism
In-Reply-To: <yq14kp7jnag.fsf@ca-mkp.ca.oracle.com>
References: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
 <yq14kp7jnag.fsf@ca-mkp.ca.oracle.com>
Message-ID: <bd724c191ac5b7c655783a068edfe675@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 2020-08-13 10:26, Martin K. Petersen wrote:
> Can,
> 
>> The changes have been tested with error injections of multiple error
>> types (and all kinds of mixture of them) during runtime, e.g. hibern8
>> enter/ exit error, power mode change error and fatal/non-fatal error
>> from IRQ context. During the test, error injections happen randomly
>> across all contexts, e.g. clk scaling, clk gate/ungate, runtime
>> suspend/resume and IRQ.
> 
> Applied to my staging tree. You'll get a formal merge message once 5.10
> opens.
> 
> Thanks!

Thank you! I will push error recovery ehancement changes after 5.10 
opens.

Regards,

Can Guo
