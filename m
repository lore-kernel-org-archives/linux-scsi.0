Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529B7C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 13:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDRNqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 09:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjDRNqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 09:46:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C27A15626
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 06:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681825548; x=1713361548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b75VZW+YGGQs3M1Jzsf6Hbj+0jqDTN0BBk9+OnQHhcc=;
  b=EAc+DjHPjAwPVpLAs7fbyjAfuSrXGJMIFDLNKyyewFUpSnJgEWk3JCeB
   71HBiNEO//oVrW0aeZHkQVKeWzwZTLB/G5Sz4B1jsOqAfwx5873zWSdZX
   XGt8vJwxnuIi3Z9nnCu29beXZY4daD2ofldyRQc0NxBowvyifXtfddmw3
   6u+exXFH6kSBt0SIzaqyfXKxxUpFaQ98YlmwNPKuuXVMG50rPWhqHmG+h
   V5Ul8jXoS1Zum3ZKh5GUIHhzh/u00Q/ELZaqNXdCIbyn+ULqqHM5K8tKB
   9WVvqgTz9v1Mc+9weHcev8qg8DzhGHmUm25LX7AvrTpfpWx+ljXH1PLcF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="345172270"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="345172270"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 06:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="815210034"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="815210034"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.32.90])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 06:45:33 -0700
Message-ID: <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
Date:   Tue, 18 Apr 2023 16:45:28 +0300
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230417230656.523826-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/04/23 02:06, Bart Van Assche wrote:
> Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
> ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
> Also remove the ufshcd_rpm_get_sync() call because it is not necessary
> to resume a UFS device before submitting a START STOP UNIT command.

What about the host controller hba->dev?

> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9434328ba323..784787cf08c3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9768,22 +9768,12 @@ static int ufshcd_wl_resume(struct device *dev)
>  static void ufshcd_wl_shutdown(struct device *dev)
>  {
>  	struct scsi_device *sdev = to_scsi_device(dev);
> -	struct ufs_hba *hba;
> -
> -	hba = shost_priv(sdev->host);
> +	struct ufs_hba *hba = shost_priv(sdev->host);
>  
>  	down(&hba->host_sem);
>  	hba->shutting_down = true;
>  	up(&hba->host_sem);
>  
> -	/* Turn on everything while shutting down */
> -	ufshcd_rpm_get_sync(hba);
> -	scsi_device_quiesce(sdev);
> -	shost_for_each_device(sdev, hba->host) {
> -		if (sdev == hba->ufs_device_wlun)
> -			continue;
> -		scsi_device_quiesce(sdev);
> -	}
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>  }
>  

