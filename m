Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DB3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 06:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352499AbiFNGvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 02:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352435AbiFNGvG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 02:51:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1994393E8
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 23:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655189465; x=1686725465;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FOoaOvPi5+rG2N5vn2NsCr5QRa/BEiXDizQKWM1udqw=;
  b=oBLiRWfitvjg4V3ZT/kGYmsbEkfP3/+WLCJh3xu0kX9CNCeCVqV6yk+s
   TpQqXlYQpHmHfWTmH52LaGtndRRVFvHY7SdMeJ2ZQRByv7vj7ccrWRcas
   L05j7AZqzH6Hs7N0F5R+Ta+0v2mrTM5Zla8SKI53x2wjWXH/DygZRajjH
   eR/H56Y83HGv4zSPweOeBIncxgQvk1Je1kaifOOWy6YdqEdnhz4D5xf+B
   suDPNNBsuxd6Ji86962LkxZq0cP4xLXAFGsOgNWM4jD2nQP9QEZtjtu04
   gUwJLJ4ffbNaPxAL3p/lDIr+k1ZqEtd5bOMhtyAyjxQt14Ecc/EPtdT6t
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="258977115"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="258977115"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 23:51:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="640178754"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.32.89])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 23:51:03 -0700
Message-ID: <3ca1d28b-2998-3cc5-7bf9-eb78a80e9430@intel.com>
Date:   Tue, 14 Jun 2022 09:51:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] ufs: Fix a race between the interrupt handler and
 the reset handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
References: <20220613214442.212466-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/06/22 00:44, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series is version two of a fix between the UFS interrupt handler and
> reset handlers. Please consider this patch series for kernel v5.20.
> 
> Changes compared to v1:
> - Converted a single patch into three patches.
> - Modified patch 3/3 such that only cleared requests are completed.
> 
> Bart Van Assche (3):
>   scsi: ufs: Simplify ufshcd_clear_cmd()
>   scsi: ufs: Support clearing multiple commands at once
>   scsi: ufs: Fix a race between the interrupt handler and the reset
>     handler
> 
>  drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++++---------------
>  1 file changed, 48 insertions(+), 28 deletions(-)
> 

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
