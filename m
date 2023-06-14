Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A701EB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 04:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjFNEyk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 00:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbjFNEyi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 00:54:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6371715
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 21:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686718473; x=1718254473;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3Muu6E+Is3WJHLbxz8Btl2rdbYzvJWSQQjPTwfqNXYs=;
  b=QzV3NrII531qCTPoI3mYBSPhx0HS8mDwBDZjcalJRvXnw/iSYzNmojJN
   QYnObQrbjUf7PIHlo27kv0Eiv70AGQnTYqQbUOTV619XdMNTTuQE40YmZ
   +ND0qdCZpr9E0NNjTHMYDfMEcelceesZHjjsHWmwLgwPmi7oWBPlB7r0n
   XLa3vXyvD2hnHGby1TKLSsDXXTiiHPX9vzwGxCjp3PTHLbd4jHnlplMJq
   jJYlBSqL+oxoLTWhJ+6YxHT7EKcBfaOKYvg8lu4zNBr3iMB2isSD+m4UI
   YJWwVr/CeW3L2vtwfG8hXOIVcWioTDruDoQ4URzOdOUb+kyhmqYG7wfjU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="343214671"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="343214671"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 21:54:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="836138360"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="836138360"
Received: from cjohann-mobl.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.240])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 21:54:31 -0700
Message-ID: <f7e5a3d9-3caa-e75d-5069-3763d3ca8951@intel.com>
Date:   Wed, 14 Jun 2023 07:54:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.12.0
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
References: <20230613170327.61186-1-adrian.hunter@intel.com>
 <c3b42f98-31f8-39f4-4540-cccf0bfe31cd@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <c3b42f98-31f8-39f4-4540-cccf0bfe31cd@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/06/23 21:22, Bart Van Assche wrote:
> On 6/13/23 10:03, Adrian Hunter wrote:
>> Add PCI ID to support Intel Arrow Lake, same as MTL.
> 
> The patch looks good to me but the "same as MTL" text in the patch description looks confusing to me?

The code change is using the same driver data as MTL:

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 38276dac8e52..cf3987773051 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -599,6 +599,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },	<--- here
 	{ }	/* terminate list */
 };
 
MTL is Meteor Lake.  The abbreviation is not unheard of in
commit messages. A web search for Intel MTL brings up the answer.

And there is this earlier patch to the same code:

commit 4049f7acef3eb37c1ea0df45f3ffc29404f4e708
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Mon Apr 4 08:50:38 2022 +0300

    scsi: ufs: ufs-pci: Add support for Intel MTL
    
    Add PCI ID and callbacks to support Intel Meteor Lake (MTL).
    
    Link: https://lore.kernel.org/r/20220404055038.2208051-1-adrian.hunter@intel.com
    Cc: stable@vger.kernel.org # v5.15+
    Reviewed-by: Avri Altman <avri.altman@wdc.com>
    Reviewed-by: Bart Van Assche <bvanassche@acm.org>
    Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

