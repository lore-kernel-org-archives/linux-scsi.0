Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20682C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 14:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjDROOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDROOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 10:14:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FFC9C
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681827291; x=1713363291;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LAHRWtyaNxIOTMxnUuGXuyshU3VfVe+xmSzUzSHg7xA=;
  b=aczOjareUbaphmHcMEhGWcdOF6h3GVKoVFRTbR8uRFA6Ta31gedNv3M/
   rQuLfYMuGjHivSjSYePAV+IHasFSSluRRW7Ngf8CEw6dYmZY7W1DO2Tfu
   UFtrkFsNfYza+iPL3iXUF/w/720n6kkJlWu+yQ/jvtZ2ZXPCMick9fV5x
   Nl0MOGIq+dM9L5jAxciTJUO4gnXZMtzcLNg7zE/pKWBkza51JDCRguj3G
   +yNZFvEjWrcCR21pZDoORYBBu090ng3fLvozBxLPWA4zDMzlLRhnD9yPx
   ZevFtD7fUWWI2km8VUVjOvTWd89zLNA7b9BdcvldTkb1iZm/agLTAVwJS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="345181311"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="345181311"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 07:13:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="815224998"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="815224998"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.32.90])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 07:13:39 -0700
Message-ID: <4568ba8b-2dd8-b88c-fbfb-1b0a561e0b15@intel.com>
Date:   Tue, 18 Apr 2023 17:13:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/4] scsi: ufs: Simplify ufshcd_wl_shutdown()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-3-bvanassche@acm.org>
 <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
 <0a2af553-9b37-d7b4-2fc2-6185c64e8663@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0a2af553-9b37-d7b4-2fc2-6185c64e8663@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/04/23 17:06, Bart Van Assche wrote:
> On 4/18/23 06:45, Adrian Hunter wrote:
>> On 18/04/23 02:06, Bart Van Assche wrote:
>>> Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
>>> ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
>>> Also remove the ufshcd_rpm_get_sync() call because it is not necessary
>>> to resume a UFS device before submitting a START STOP UNIT command.
>>
>> What about the host controller hba->dev?
> 
> The above question is not clear to me. Please elaborate.

Does hba->dev need to be runtime resumed?


