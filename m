Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CE2C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 01:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA25622309
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 01:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kbJgt9SI";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WghnqhEy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKSBhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:37:15 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:51718
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfKSBhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 20:37:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574127434;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=iVE+tT1tSlaGnnxJjbuS6r6YzZPxUIcklKk0cW+No+U=;
        b=kbJgt9SIYdALUEj8jjnYiluBFyoQfGuoQVVDjOnis/d7KxNVauXzMo+t5RWCfvhw
        6zGdTN1EyW3sUml7YTT/8Eb65AuuIrIr9Ydr87ST2FINQqvSZ/nJT59IgAh24PZMVDA
        Dqz2jZnwoV7MPlR1s3p9pGhoh0xqBqHBE27bLs5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574127434;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=iVE+tT1tSlaGnnxJjbuS6r6YzZPxUIcklKk0cW+No+U=;
        b=WghnqhEypdglzMuJH+P4nAGJQKLXwVGqfVpaCaAXckRGDNs3C0yXeXekfb1cBwCY
        WtqgRa2FXs0Kh/UWqpvqt4JSl0acbLXSuQzs/yNX2AMp01zLz36xlN8UmCUHXcMElZF
        kWK0pm3ZjrF68UmrpPtNa1QIpZgbOalRLL94AcO4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 19 Nov 2019 01:37:14 +0000
From:   cang@codeaurora.org
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     Can Guo <cang@qti.qualcomm.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, Mark Salyzyn <salyzyn@google.com>
Subject: Re: [PATCH v2 0/4] UFS driver general fixes bundle 5
In-Reply-To: <CAGOxZ50cmTgcCXfzykQtJpO8ahXjhrXioq22s2DK_-W9KMGD0Q@mail.gmail.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <CAGOxZ50cmTgcCXfzykQtJpO8ahXjhrXioq22s2DK_-W9KMGD0Q@mail.gmail.com>
Message-ID: <0101016e814e7ad5-9cc8a39a-662c-4b57-ad25-416bf665ff98-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.19-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-18 21:26, Alim Akhtar wrote:
> Hi Can
> 
> On Mon, Nov 18, 2019 at 9:21 AM Can Guo <cang@qti.qualcomm.com> wrote:
>> 
>> This bundle includes 4 general fixes for UFS driver.
>> 
>> Changes since v1:
>> - Incorporated review comments from Avri Altman.
>> - Removed change "scsi: ufs: Add new bit field PA_INIT to UECDL 
>> register".
>> - Updated change "scsi: ufs: Complete pending requests in host reset 
>> and restore path".
>> 
>> Asutosh Das (1):
>>   scsi: ufs: Recheck bkops level if bkops is disabled
>> 
>> Can Guo (3):
>>   scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
>>   scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
>>   scsi: ufs: Complete pending requests in host reset and restore path
>> 
>>  drivers/scsi/ufs/ufs.h    |  4 ++--
>>  drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
>>  drivers/scsi/ufs/ufshcd.h |  2 ++
>>  3 files changed, 19 insertions(+), 18 deletions(-)
>> 
>> --
> 
> For this bundle, most of the review is done, so if you can send V3 of
> these with the addressed 2/4 patch, this can merged.
> Thanks
> 

Yes, sure, shall do. Thank you.

>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
