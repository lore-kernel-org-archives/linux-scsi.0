Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA6AC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 06:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245357AbiDAGWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiDAGWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 02:22:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41AE12F157
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 23:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648794014; x=1680330014;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xHReKmgcNXELgqNaX+3p776415/3O8mQIFO1WKYsuis=;
  b=hcJlg1cqc21vySfFP0eU0MtW9U3r5cNtXW26yr6cZ7uDlwuguJ8TURb9
   U/H2MZWXTLOIuCd5o5DMrl3IHEq0ekLfGjzJNgYAd6zVu1Zq/oaONA38i
   j7gS4Yh2TST03uqi9O/rulSgmsuAHoEWsg5zjaAy6LBIH/FApfBUz/M+d
   29PFrSKHagWxBji+d6FGa/QoWfnjJqUt5ijy3hF636ADO3aqYxd5dEpeh
   yUMpyduKzjWBE/0YrvhgOD0eJfruBdf0qqn4VnEMBJvuqdm6fma+ceQxw
   TP5fXjPNuJ47BwptNmHT73VYwDmlaJ9y5O5gonQWBHQbYRDQtLv2jjDgq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="240642860"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="240642860"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:20:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="567192445"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.63.177])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:20:11 -0700
Message-ID: <8e1a89f6-4195-c0a9-62f3-c1dcbbd4202f@intel.com>
Date:   Fri, 1 Apr 2022 09:20:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 13/29] scsi: ufs: Remove the LUN quiescing code from
 ufshcd_wl_shutdown()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220331223424.1054715-14-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/04/2022 1.34, Bart Van Assche wrote:
> Quiescing LUNs falls outside the scope of a shutdown callback. The shutdown
> callback is called from inside the reboot() system call and the reboot()
> system call is called after user space has stopped accessing block devices.
> Hence this patch that removes the quiescing calls from
> ufshcd_wl_shutdown(). This patch makes shutdown faster since multiple
> synchronize_rcu() calls are removed.

AFAIK there is nothing stopping shutdown being called during intense UFS I/O.
What happens then?

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a48362165672..ae08c7964f2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9212,9 +9212,7 @@ static int ufshcd_wl_resume(struct device *dev)
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
> @@ -9222,12 +9220,6 @@ static void ufshcd_wl_shutdown(struct device *dev)
>  
>  	/* Turn on everything while shutting down */
>  	ufshcd_rpm_get_sync(hba);
> -	scsi_device_quiesce(sdev);
> -	shost_for_each_device(sdev, hba->host) {
> -		if (sdev == hba->sdev_ufs_device)
> -			continue;
> -		scsi_device_quiesce(sdev);
> -	}
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>  }
>  

