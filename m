Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D60FC3524D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 07:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34D482073C
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 07:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ZZhzTFop"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgBCHR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 02:17:28 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29821 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727305AbgBCHR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 02:17:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580714248; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LSUOB0htOB7h0HnG8rrlaTFbDlSnIcVLwSog0W6Hsls=;
 b=ZZhzTFoptSpJCZoM6+JmPEgOYf03mXjCTjD46W2i9uk0nEAD2eDzZ+nBs4bp6ppU7S0Ii1ci
 wUESUPqKy3MI3AjWFH5gIuN6OJ+lW6JQtQj/tCERN8v9Er1/4kOaDKdd3WtEsmV/dzn5k/J9
 LuxTfZULxDkXnzbu9rsvEzjxxJ4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e37c902.7f2180f166c0-smtp-out-n02;
 Mon, 03 Feb 2020 07:17:22 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2CE2C447A1; Mon,  3 Feb 2020 07:17:21 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 181D7C433CB;
        Mon,  3 Feb 2020 07:17:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Feb 2020 15:17:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v4 6/8] scsi: ufs: Add dev ref clock gating wait
 time support
In-Reply-To: <BN7PR08MB568451D6C66F4C6FB11E6EEBDB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-7-git-send-email-cang@codeaurora.org>
 <BN7PR08MB568451D6C66F4C6FB11E6EEBDB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <b263ce1549ef4a6e1a0659f2fa0165e1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-24 07:11, Bean Huo (beanhuo) wrote:
> Hi,  Can
> 
>> 
>> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime 
>> defines the
>> minimum time for which the reference clock is required by device 
>> during
>> transition to LS-MODE or HIBERN8 state. Make this change to reflect 
>> the new
>> requirement by adding delays before turning off the clock.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs.h    |  3 +++
>>  drivers/scsi/ufs/ufshcd.c | 41
>> +++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 44 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
>> 3327981..385bac8 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -168,6 +168,7 @@ enum attr_idn {
>>  	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
>>  	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
>>  	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
>> +	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
>>  };
>> 
>>  /* Descriptor idn for Query requests */ @@ -530,6 +531,8 @@ struct
>> ufs_dev_info {
>>  	bool f_power_on_wp_en;
>>  	/* Keeps information if any of the LU is power on write protected */
>>  	bool is_lu_power_on_wp;
>> +	u16 spec_version;
>> +	u32 clk_gating_wait_us;
>>  };
>> 
> This one also need rebase
> 
> Thanks,
> 
> //Bean

Shall rebase this series.

Thanks,

Can Guo
