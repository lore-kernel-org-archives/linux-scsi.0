Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348CAC433EB
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4D822D01
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="fH8+1DZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHFEx7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 00:53:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26790 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgHFEx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 00:53:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596689637; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=OsZPoBJQJp6PSyMnKPpLTNg227XLM8APZn+rJSU8syY=;
 b=fH8+1DZYHIZ/5MB7zOXtEaPi1Dr+lwgnsulKQ6Ev/pK8v/+JLpnpRZvIzTLPk3k7x7CpnbDG
 VXPEHuojP15DuEIb72veqNY7bPSorrc7nQGrZFmc4obTL/TLlnjqSxjnNXFv0XIo8cyFDtyz
 7OUtHfs2KJcUJy7iBtNqB+RS77A=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f2b8ce5725833be3066a6b1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 Aug 2020 04:53:57
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4599C433AF; Thu,  6 Aug 2020 04:53:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22634C433C6;
        Thu,  6 Aug 2020 04:53:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 06 Aug 2020 12:53:55 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 8/9] scsi: ufs: Fix a racing problem btw error handler
 and runtime PM ops
In-Reply-To: <yq1r1slzxoh.fsf@ca-mkp.ca.oracle.com>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
 <1596445485-19834-9-git-send-email-cang@codeaurora.org>
 <yq1r1slzxoh.fsf@ca-mkp.ca.oracle.com>
Message-ID: <f6a49b77e381c274e1a4cfd11e088304@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-05 09:31, Martin K. Petersen wrote:
> Can,
> 
>> Current IRQ handler blocks scsi requests before scheduling eh_work,
>> when error handler calls pm_runtime_get_sync, if ufshcd_suspend/resume
>> sends a scsi cmd, most likely the SSU cmd, since scsi requests are
>> blocked, pm_runtime_get_sync() will never return because
>> ufshcd_suspend/reusme is blocked by the scsi cmd. Some changes and
>> code re-arrangement can be made to resolve it.
> 
>   CC [M]  drivers/scsi/ufs/ufshcd.o
> drivers/scsi/ufs/ufshcd.c: In function ‘ufshcd_queuecommand’:
> drivers/scsi/ufs/ufshcd.c:2570:6: error: this statement may fall
> through [-Werror=implicit-fallthrough=]
>  2570 |   if (hba->pm_op_in_progress) {
>       |      ^
> drivers/scsi/ufs/ufshcd.c:2575:2: note: here
>  2575 |  case UFSHCD_STATE_RESET:
>       |  ^~~~
> cc1: all warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:280: drivers/scsi/ufs/ufshcd.o] 
> Error 1
> make[2]: *** [scripts/Makefile.build:497: drivers/scsi/ufs] Error 2
> make[1]: *** [scripts/Makefile.build:497: drivers/scsi] Error 2
> make: *** [Makefile:1764: drivers] Error 2

Thanks Martin, will fix it in next version.

Can Guo.
