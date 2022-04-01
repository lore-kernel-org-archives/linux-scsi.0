Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80DEC4167E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 15:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349744AbiDAO5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349319AbiDAOpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:45:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B1A29A57E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823746; x=1680359746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JinOvZgQOLDXNfhZgNFKxhl/hzFt5+bNm8bUnrw4DNE=;
  b=W9eVZIv+SbOJCIBr2YCkmgScKYQcHx5ylb2/wSu+wGM6ZXDuEjYvJDee
   FPxfIbvQ+MZutQxehzebnJi+NQzqDGnBLbn3ouKPYLrYspfW6hDtJ6fB8
   wKQobIgJ9t85IYoJzu1xli2ibKqZal6252uJMxeq/YAXB9iFk1zwDyiZC
   IZNynni9v4FCJNa8cT8Hn3TY8xTQtkfEOkSdEvwSGXXXWeQeLZwJaw6BL
   WbOEGPQgaqDReJnBrJma5RgEu247hzv0zXQNCHnTAifYKY9YRSeB0ujhb
   xyyM6mFfZd1Er38fdXqBS4Fk3oFsF3rqkT+zJCVvnBMygrRk/sPH/vHIl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="260328560"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="260328560"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:35:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="567534847"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.63.177])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:35:10 -0700
Message-ID: <17c360e7-ea35-de7a-6f38-f1818826312a@intel.com>
Date:   Fri, 1 Apr 2022 17:35:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 13/29] scsi: ufs: Remove the LUN quiescing code from
 ufshcd_wl_shutdown()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-14-bvanassche@acm.org>
 <8e1a89f6-4195-c0a9-62f3-c1dcbbd4202f@intel.com>
 <66458c8f-157e-f050-f520-e3ec01e75d69@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <66458c8f-157e-f050-f520-e3ec01e75d69@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/04/2022 16.52, Bart Van Assche wrote:
> On 3/31/22 23:20, Adrian Hunter wrote:
>> On 01/04/2022 1.34, Bart Van Assche wrote:
>>> Quiescing LUNs falls outside the scope of a shutdown callback. The shutdown
>>> callback is called from inside the reboot() system call and the reboot()
>>> system call is called after user space has stopped accessing block devices.
>>> Hence this patch that removes the quiescing calls from
>>> ufshcd_wl_shutdown(). This patch makes shutdown faster since multiple
>>> synchronize_rcu() calls are removed.
>>
>> AFAIK there is nothing stopping shutdown being called during intense UFS I/O.
>> What happens then?
> 
> Hmm ... how could this happen? Am I perhaps misunderstanding something about the Linux shutdown sequence?
> 
> The UFS driver is the only driver I know that tries to stop I/O from inside its shutdown callback. I'm not aware of any other Linux kernel driver that tries to pause I/O from inside its shutdown callback.

We are putting the UFS device into powerdown mode.  I am not sure what will happen if the device is processing requests at the same time.

