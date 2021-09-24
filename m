Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144D6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 19:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E89736127A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 19:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348225AbhIXTzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348243AbhIXTzQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 15:55:16 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1DDC06161E;
        Fri, 24 Sep 2021 12:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=W0xZkng9ihhv3poTcIXdZvI+VTliOg+ztpCX/sntisQ=; b=u4DRvvniz55rMoSSFiQW49S6iT
        HFIca4gNDWzJGqZ/FS3kkG7TNubZvoYet9aeBp+FvcrZeTUqn/P5cqEStS0BwQycIXBHQXIIDG9Dr
        rcQb8cxRter7yOAuRgJOhoqHF+m/YeVEYWPbiYMdFB92llb5sdzvddBY4/IW64fP5JByXmvNBxo1i
        3SQFzbC9v3wr4YtVZpLw8AEMeFf2loiTW59lj4g9vEtDZneVL9H/1Lj/igf1TWZSY0Ipi56fgf+gx
        2WNFhzRbjyKX5B/Sx3NFUkaVjEtv6lMomuIetSsRIuj96STJab65Hba917TStj6eQCqKy86DjTczE
        3m6dx/bA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTrGM-00FQRN-Pt; Fri, 24 Sep 2021 19:53:38 +0000
Subject: Re: [PATCH] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
To:     Avri Altman <Avri.Altman@wdc.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jdelvare@suse.com" <jdelvare@suse.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
References: <20210924164530.1754128-1-anders.roxell@linaro.org>
 <c3bdc145-70e7-b504-0437-f451a3e1c5a8@infradead.org>
 <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5dab9890-6142-3ac3-424a-1fc169734464@infradead.org>
Date:   Fri, 24 Sep 2021 12:53:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/21 11:59 AM, Avri Altman wrote:
>>> Since fragment 'SCSI_UFS_HWMON' can't be build as a module,
>>> 'SCSI_UFS_HWMON' has to depend on 'HWMON=y'.
>>>
>>> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature
>>> notification support")
>>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>>> ---
>>>    drivers/scsi/ufs/Kconfig | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
>>> 565e8aa6319d..30c6edb53be9 100644
>>> --- a/drivers/scsi/ufs/Kconfig
>>> +++ b/drivers/scsi/ufs/Kconfig
>>> @@ -202,7 +202,7 @@ config SCSI_UFS_FAULT_INJECTION
>>>
>>>    config SCSI_UFS_HWMON
>>>        bool "UFS  Temperature Notification"
>>> -     depends on SCSI_UFSHCD && HWMON
>>> +     depends on SCSI_UFSHCD && HWMON=y
>>>        help
>>>          This provides support for UFS hardware monitoring. If enabled,
>>>          a hardware monitoring device will be created for the UFS device.

Thinking about this, it should be possible to do it like this
so that both SCSI_UFSHCD=m ad SCSI_HFS_HWMON=m would also work.
I.e., this would allow more combinations of Kconfig settings to
work. It only excludes SCSI_UFSH_HWMON=y and HWMON=m

+       depends on SCSI_UFSHCD=HWMON || HWMON=y

OK, I have verified that this works (builds) in all allowed
combinations.  Anders, would you please resubmit the patch?


-- 
~Randy
