Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B22C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 06:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52EC4206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 06:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lHQXXtj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPGeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:34:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49089 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgIPGeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 02:34:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600238049; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=prCtKq1R1zy4yEQC9e7arLt8v2FySSHVYD5hW893oqo=;
 b=lHQXXtj5v5wasjL8vSrXaXKaptfuQxOa/I38/4WHX93qKA3O0cUSAeQQLtaV+GPn+oMaVxBb
 tobpOLNfO1Xh1aX5PM/qgmFKfkBmruOAhNRjU1g1/zaraJ6aqEk9/h2x1fi69MYwKYnMZtqL
 DLPIOpjohMYRagb96WgqL7HP6QY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f61b1e1698ee477d1c4c9e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:34:09
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75A3DC433A0; Wed, 16 Sep 2020 06:34:09 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B3651C433F1;
        Wed, 16 Sep 2020 06:34:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Sep 2020 14:34:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bean Huo <huobean@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
In-Reply-To: <yq1wo0u6bdw.fsf@ca-mkp.ca.oracle.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
 <1599099873-32579-2-git-send-email-cang@codeaurora.org>
 <1599627906.10803.65.camel@linux.ibm.com>
 <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
 <1599706080.10649.30.camel@mtkswgap22>
 <1599718697.3851.3.camel@HansenPartnership.com>
 <1599725880.10649.35.camel@mtkswgap22>
 <1599754148.3575.4.camel@HansenPartnership.com>
 <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
 <d151d6a2b53cfbd7bf3f9c9313b49c4c404c4c5a.camel@gmail.com>
 <4017d039fa323a63f89f01b5bf4cf714@codeaurora.org>
 <yq1wo0u6bdw.fsf@ca-mkp.ca.oracle.com>
Message-ID: <149974f6d7073dae363797874fc088bf@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-16 04:21, Martin K. Petersen wrote:
> Can,
> 
>> Do you know when can this change be picked up in scsi-queue-5.10?
>> If I push my fixes to ufshcd_abort() on scsi-queue-5.10, they will
>> run into conflicts with this one again, right? How should I move
>> forward now?
> 
> You should be able to use 5.10/scsi-queue as baseline now.
> 
> For 5.11 I think I'll do a separate branch for UFS.

Thanks for the information.

Regards,

Can Guo.
