Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F54EC64E7B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 12:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14EF220715
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 12:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="BDXTt0I1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgKYM2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 07:28:19 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:62757 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgKYM2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 07:28:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606307297; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=iNAPFkL8b7EnXxHK07zTOw6eeK1eE3u8WLYvqlWH7hw=;
 b=BDXTt0I1RM5bwS70cszkBNSWPJfmxWRtmblDYZul+CNaa2RWgbRuPvnH9Abxp6hyNoRatXPf
 SWyJ33+pN0yB1GSXFnA8Y3pC2h59ZSrPfu8wGn9/NuCq4Bi1TlWzCEobkXqTKzZfNh33kI2a
 MtnYLYfQnW9YLe76qg8yMPjX+wI=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fbe4de17f0cfa6a1632a13a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 12:28:17
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A8845C43468; Wed, 25 Nov 2020 12:28:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE92CC433ED;
        Wed, 25 Nov 2020 12:28:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 20:28:15 +0800
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
In-Reply-To: <0b0c545d80f9a0e8106a634063c23a8f0ba895fc.camel@gmail.com>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-2-git-send-email-cang@codeaurora.org>
 <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
 <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
 <0b0c545d80f9a0e8106a634063c23a8f0ba895fc.camel@gmail.com>
Message-ID: <9484cba7b95c6c6fcbafd96bc35c1dee@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-25 19:54, Bean Huo wrote:
> On Wed, 2020-11-25 at 08:53 +0800, Can Guo wrote:
>> > > +       bool always_on_while_link_active;
>> >
>> > Can,
>> > using a sentence as a parameter name looks a little bit clumsy to
>> > me.
>> > The meaning has been explained in the comments section. How about
>> > simplify it and in line with other parameters in the structure?
>> >
>> 
>> Do you have a better name in mind?
>> 
> no specail input in mind, maybe just "bool eternal_on"

It is like plain "always_on", but it cannot tell the whole story.
If it is not something crutial, let's just let it go first so long
as it does not break the original functionality. What do you say?

Thanks,

Can Guo.

> 
>> Thanks,
>> 
>> Can Guo.
