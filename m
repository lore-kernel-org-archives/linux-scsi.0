Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B1EC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 17:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjDLRZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 13:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjDLRZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 13:25:05 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916A25BAA
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 10:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681320299; x=1712856299;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=icCRA17pDsF60qriIWOmf5B1dJjMsri1f/VJtXEAmCw=;
  b=NvCIBh9chpc9QEK54CmDdN0CxyNzfBciGUH43J+YHRWDSa8jCBUTFNgH
   mKo0DDqKD1b53cJKovh4YtRjZBtC/56nFndpGJAx1gdfoYruJcwF4Mbf1
   TfIEHB/g3lwfGear5y5Azbvs0EljtCJu4gAjnF3Bt8y34YiuIZbL8hPue
   /zRISnSoo3zRToNjhiJ5VyPcmSEEq2asBMIqame+cpmZi8R4Zmp5CGjGC
   NEe2jpL9Ag0CaC22/mxWZHAoCp0VfTgvT//LDTOT2b6kQ56EKinFkJDpT
   fX41ttxZk5jUHObqZ0PFW7DSNmJebx1N3M327CLL46LTxSwVfA3dGpFxa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="341459811"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="341459811"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 10:24:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1018818640"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1018818640"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.212.63])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 10:24:55 -0700
Message-ID: <3e669a6d-9fe9-81f2-2991-d7a02be5d7b1@intel.com>
Date:   Wed, 12 Apr 2023 20:24:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
 <17217146-9c07-3963-fd32-02704632330d@intel.com>
 <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
 <a71dc651-a306-eebe-968e-0d9e56f44a76@intel.com>
 <ce0794e1-45d5-c76a-9835-7285353e786c@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <ce0794e1-45d5-c76a-9835-7285353e786c@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/04/23 19:34, Bart Van Assche wrote:
> On 4/11/23 11:31, Adrian Hunter wrote:
>> It would be better not to assume current stable trees are the only
>> consumers of fixes.  Presumably adding the extra Fixes tag does no
>> harm.
> 
> Hi Adrian,
> 
> The convention is to add a reference to the most recent patch that got fixed in the patch description. Anyone who backports fixes is assumed to follow the chain of patches transitively that is created by Fixes: tags.

Wouldn't that only work if commit dcd5b7637c6d had a Fixes tag too.

