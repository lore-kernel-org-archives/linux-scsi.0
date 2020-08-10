Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A14EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 00:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45455206D8
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 00:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jgxebZvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJAsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 20:48:13 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:46869 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgHJAsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 20:48:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597020492; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lyx1K9lvsEfHQhbp6wimBqGRqyqH8L3RTY/INOpfUXw=;
 b=jgxebZvBLrJg5h8V070J65EN+dLnwEESfFnW32xxysRtfvsnN++KTapQdyAPfL51Jgs486J7
 lsO8Bw9EyFWwDdoDGRGDqgikEIbL0GzeR1xbx2bTwfzpF4yg/n15lFiOWk8HQWWA4/6XQiYu
 0FYJvt4CtawlTn1tZioNcrG0lws=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f3099484c787f237b732938 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 10 Aug 2020 00:48:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4AAC4C43391; Mon, 10 Aug 2020 00:48:08 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A388C433C6;
        Mon, 10 Aug 2020 00:48:07 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 10 Aug 2020 08:48:07 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
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
Subject: Re: [9/9] scsi: ufs: Properly release resources if a task is aborted
 successfully
In-Reply-To: <cb9dbb7d-5515-0190-d336-be657e1ca31c@web.de>
References: <a752927b-dd9b-ebf0-8c77-e2ae0b2aa475@web.de>
 <fc5c328732792aca1dd451d0109f00b5@codeaurora.org>
 <cb9dbb7d-5515-0190-d336-be657e1ca31c@web.de>
Message-ID: <8082186eed74798a403f3e3cb80a1751@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Markus,

On 2020-08-10 02:00, Markus Elfring wrote:
>> Thanks, will fix these in next version.
> 
> Thanks for your adjustment of the proposed commit message.
> Should the corresponding patch be marked with an other version number?
> https://lore.kernel.org/linux-arm-kernel/1596975355-39813-10-git-send-email-cang@codeaurora.org/
> https://lore.kernel.org/patchwork/patch/1285629/
> https://lkml.org/lkml/2020/8/9/87
> 
> Should a cover letter be provided for such a patch series?
> 
> Regards,
> Markus

I am not sure if you got my mails, this patch is included in
a patch series with other 8 changes and they do have a cover
letter. Let me re-send them to you.

Thanks,

Can Guo.
