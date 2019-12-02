Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29929C432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F327020715
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IZJ5FJPz";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="T6F69I6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfLBH3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:29:35 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:44324
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfLBH3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575271774;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=n1UHqyOwMirXt9ynuPF5AWJEn/klRohJE9Berk4y3+E=;
        b=IZJ5FJPzg0BG3l7mnBT6N03zlx2u6el7V1zZtP3hOi66dd36BrYuifbMumGsbQ5L
        ADkcHMiR8uDfY6PQNPTDtbdNT9COeedcc+DnbmchXUckbD5dtm0f8YeVCZ0z3wWITlN
        TJ8/2n7jO/TsteWSvCQ/MK944wh/YoLYjVN1NLao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575271774;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=n1UHqyOwMirXt9ynuPF5AWJEn/klRohJE9Berk4y3+E=;
        b=T6F69I6qo5sSUKmipfp0NkQgBjG/g0bxUmpCugxtTVxn7OQK/of8Da8gGsLiACA5
        qtf/kZm1hXVVcVzyt7RuXHE3fanRrgCFq18OWqa/vZn9zOED9f99CqWnU70/aSSRNPe
        6BK5xMN2gcM2KFwjK5wYV8BALPPKiu5cLf+lexrI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 2 Dec 2019 07:29:34 +0000
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Evan Green <evgreen@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
In-Reply-To: <MN2PR04MB699154831CDD5847C4674632FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ec4a25faa-77e03f78-006b-4b7c-bf8a-d56378f4b1be-000000@us-west-2.amazonses.com>
 <MN2PR04MB699154831CDD5847C4674632FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016ec583b87a-6f10681d-2567-4ae8-bf1b-d78404ad26fb-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.02-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-02 15:23, Avri Altman wrote:
> Hi,
>> 
>> Considering there can be multiple UFS hosts in SoC, give each ufs-bsg 
>> an unique
>> ID by appending the scsi host number to its device name.
> Can you refer me to such a design?
> 
> Thanks,
> Avri
> 

Consider a platform which has an embedded UFS device and supports a UFS 
card meanwhile.
This conbination is very popular nowadays. BTW, 845 started supporting 
two UFS hosts 3 years ago.

Thanks,

Can Guo

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c 
>> index
>> dc2f6d2..3ef5b78 100644
>> --- a/drivers/scsi/ufs/ufs_bsg.c
>> +++ b/drivers/scsi/ufs/ufs_bsg.c
>> @@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>>         bsg_dev->parent = get_device(parent);
>>         bsg_dev->release = ufs_bsg_node_release;
>> 
>> -       dev_set_name(bsg_dev, "ufs-bsg");
>> +       dev_set_name(bsg_dev, "ufs-bsg%d", shost->host_no);
>> 
>>         ret = device_add(bsg_dev);
>>         if (ret)
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
