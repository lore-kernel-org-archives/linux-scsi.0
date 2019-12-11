Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EFFC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED322073D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o88nLTeN";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="dfaKObj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfLKLp2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 06:45:28 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:41558
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727365AbfLKLp2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 06:45:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576064727;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=JiPXq/eUqhlCbHe6rPsNhUYA8v5Xs7QVIRqJ0vKWarc=;
        b=o88nLTeNBNMz266JfaBhfh1U4vFIK/tNpuvCWfneAv96iHYlViOkkTaY1pWu5AXW
        D/0UShqZl/L9SX5X1FuoCTi413eui3ul5jBd1G3aO1YNEl9Lv25MpLY9ci55kkdnBYH
        Ykv+rSeUvkf8/YWx6vKxwkIWq51DctTvduQR5hFA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576064727;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=JiPXq/eUqhlCbHe6rPsNhUYA8v5Xs7QVIRqJ0vKWarc=;
        b=dfaKObj6pfCLm2/VKuhOQ6vUwvnzdelWdoUL0vOe4iucihFqvvFQY8WNu+DOb8by
        18YRj4KnaiD95dNoJ3OTCWgAei7vcEkG9IgW8dVtz20I3Xio8OkaRnzazMLZYfbWHbF
        lNs7RekohSwrnBXwgfmQ1ZOL1tDHBAMLVs+YJNTU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Dec 2019 11:45:27 +0000
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Maxime Ripard <mripard@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        =?UTF-8?Q?Cl=C3=A9ment_P=C3=A9ron?= <peron.clem@gmail.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] arm64: defconfig: Compile ufs-bsg as a module
In-Reply-To: <MN2PR04MB6991B27D797044D8FFDFAE8FFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ef43c56d3-c7064a44-6025-4349-afd4-a2c91a9d9ffe-000000@us-west-2.amazonses.com>
 <MN2PR04MB6991B27D797044D8FFDFAE8FFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016ef4c73939-4ac7175d-40e4-4b34-bfbf-3f921a785503-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.11-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-11 19:11, Avri Altman wrote:
>> 
>> Compiling ufs-bsg as a module to improve flexibility of its usage.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> Not sure we want to make it loadable by default.
> The platform vendor should decide if this module is available or not,
> Don't you think?
> 
> 

Agree, I will remove this change from patchset in next versioin of it.

Thanks,

Can Guo.

>> ---
>>  arch/arm64/configs/defconfig | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/arm64/configs/defconfig 
>> b/arch/arm64/configs/defconfig index
>> 8e05c39..169a6e6 100644
>> --- a/arch/arm64/configs/defconfig
>> +++ b/arch/arm64/configs/defconfig
>> @@ -227,6 +227,7 @@ CONFIG_SCSI_UFSHCD=y
>> CONFIG_SCSI_UFSHCD_PLATFORM=y  CONFIG_SCSI_UFS_QCOM=m
>> CONFIG_SCSI_UFS_HISI=y
>> +CONFIG_SCSI_UFS_BSG=m
>>  CONFIG_ATA=y
>>  CONFIG_SATA_AHCI=y
>>  CONFIG_SATA_AHCI_PLATFORM=y
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
