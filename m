Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D04CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8B1619E9
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350732AbhI3Mpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:45:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:58935 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348891AbhI3Mpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 08:45:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="212254977"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="212254977"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 05:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="479880245"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 30 Sep 2021 05:44:06 -0700
Subject: Re: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        avri.altman@wdc.com, bvanassche@acm.org, cang@codeaurora.org,
        huobean@gmail.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        liwei213@huawei.com, manivannan.sadhasivam@linaro.org,
        martin.petersen@oracle.com
References: <20210922093842.18025-2-adrian.hunter@intel.com>
 <CGME20210929051745epcas2p1024eb171d57dca361d2d3d522683770d@epcas2p1.samsung.com>
 <1632891691-17109-1-git-send-email-kwmad.kim@samsung.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <da246d0c-0c9f-4271-3351-fa8c01c26ff7@intel.com>
Date:   Thu, 30 Sep 2021 15:43:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1632891691-17109-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/09/2021 08:01, Kiwoong Kim wrote:
> (I post this again because this isn't attached to the mail thread)
> 
> UFSHCI specifies Data Byte Count (DBC) like this:
> A '0' based value that indicates the length, in bytes, of the data
> block. A maximum of length of 256KB may exist for any entry. Bits 1:0 of this
> field shall be 11b to indicate Dword granularity.
> A value of '3' indicates 4 bytes, '7' indicates 8 bytes, etc.
> 
> That means the size value should be aligned with 4. And as I know it's 18.
> Yes, its buffer is enough but if a host doesn't access memory with four-byte
> alignment, it could cause problems.

Fixed in V6
