Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68275C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 04:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 386DC20674
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 04:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="HuDiOAgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLPEgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 23:36:20 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:37891 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbfLPEgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Dec 2019 23:36:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576470979; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1IOCtn9qRak1dMm874uHU1b5mpiz11s+B6M7qcU1U20=;
 b=HuDiOAgv2cXnqngWojwwCw+N43wFzhVablWGufZ83OwAkFsllZu6jUinCBk3zIagrhMD5nrU
 qK+79LCMobT19t2v3/IwpC+l9fqoY8ogqyeyaI0hKD1rdxgQxieGV9GZofRELMxtXt0UVVFg
 Si9Idn5S+Cghyb+72GEi9jUiGwA=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df709bd.7f17c1ea4b90-smtp-out-n01;
 Mon, 16 Dec 2019 04:36:13 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C25CC447A2; Mon, 16 Dec 2019 04:36:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69947C433CB;
        Mon, 16 Dec 2019 04:36:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Dec 2019 12:36:10 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
In-Reply-To: <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
Message-ID: <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-16 05:49, Bart Van Assche wrote:
> On 2019-12-11 22:37, Bjorn Andersson wrote:
>> It's the asymmetry that I don't like.
>> 
>> Perhaps if you instead make ufshcd platform_device_register_data() the
>> bsg device you would solve the probe ordering, the remove will be
>> symmetric and module autoloading will work as well (although then you
>> need a MODULE_ALIAS of platform:device-name).
> 
> Hi Bjorn,
> 
> From Documentation/driver-api/driver-model/platform.rst:
> "Platform devices are devices that typically appear as autonomous
> entities in the system. This includes legacy port-based devices and
> host bridges to peripheral buses, and most controllers integrated
> into system-on-chip platforms.  What they usually have in common
> is direct addressing from a CPU bus.  Rarely, a platform_device will
> be connected through a segment of some other kind of bus; but its
> registers will still be directly addressable."
> 
> Do you agree that the above description is not a good match for the
> ufs-bsg kernel module?
> 
> Thanks,
> 
> Bart.

Hi Bart,

I missed this one.
How about making it a plain device and add it from ufs driver?

Thanks,

Can Guo.
