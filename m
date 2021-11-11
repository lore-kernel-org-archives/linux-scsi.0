Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C90C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 05:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916E36135E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 05:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhKKF3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 00:29:54 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5940 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhKKF3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 00:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636608425; x=1668144425;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=cVnvtakc4Z6LGB6zWW59TOFUrqBxBX4OwZ7zfkKwooY=;
  b=RtFKwQLftPRs8Re+KME1CoO3i2GGnoKqFfSVF1xaEzNm/dpWjeB+v8Wt
   BxmfE2qaN0Eq9DGJ+PgHFskdtAHLG3dLdxDY88eMo7+diNdVccn2d4KEv
   c2ljGAS8rdzRNpg/JnVf2ure21llN6OkCom0J4jvvYzY4o0m7YXwq5ROk
   k2tbEl8y+o3TufM2zdRPS/GtJrvYM9y+r3IhL2F8nXgXcM8wbUNsLDim9
   aX/gUtlewMCyLLQ92XFP/x4rCtN4iD0etJCyowZ9DJRdVwv/ZCxfKaDr3
   GuGbpasNEYdtdBFpCJ6vMAYATgrAn9dNW5dxEgdCtXIV2klRGLDGkiqFI
   g==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="297121522"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 13:27:04 +0800
IronPort-SDR: x+GDw7Zx3epGf+76/h/Y4aPo8jHuSbcVlLxq1hiFsSjFcY57AcYL3y/6Croz5YdvjpgYTklr55
 80C9k7z0T6BjS5Ugn1TZeADLvbglQlrMp5uYGFfuj0DxMQgt+jiFrP9o2xHuyoNZTAjrjISddI
 n53WW1fPtPxOnwi5d+pikRJYHiFJBdiWGn66cVQkk5WNUsL7lISjJ8/AAdS/7gnH/nXLStNC3n
 ftgaOHCFNPIXm11cwiowZTc4mlBpwMy4b4S12pZkbtQD6aDTxTutmi6tuIu+wdkSF4iILO4Ljr
 LxXers2gCLsYrVtLaa+18T5P
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 21:02:14 -0800
IronPort-SDR: qCrS7nATXGGgbe1IRMMI1bmo9NzuZbAh1WFWIKs92Lj050AfovwDHRcqPQergUrLMit6giJcU3
 TDV+hhz8cdvTK+wkLM0+178AOSdUTeXzDUi5qHr60+QmrUcQXZ1AfKs8VTqu9YtN2B/rTAp3xR
 Xx6ZUY51VzCGG6xGxsTFvPJBFrjzU2inpXE7CG7YqYVeaEMU8YDacezCVyF6TCD9JSHTuCoouW
 zesDXxtL7742rot7sUWyOFRyvWVg4ApY2BG9zwM5e1afHszdK6JqPSxUAJEVcN8xW42mnC0oTv
 FLY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 21:27:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HqVZw4Nmwz1RtVm
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 21:27:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636608424; x=1639200425; bh=cVnvtakc4Z6LGB6zWW59TOFUrqBxBX4OwZ7
        zfkKwooY=; b=uE+4vlYSVEFKI1FXUQu6xnUqGUCWrTCaOU02VUn7X4ukeLG/u3/
        xEHrAwUKeWsNSd/zMu0Mpicpd5cvPwV6qyOWcBvO+KS7ecXMSMZDvKvcW0WWWSeD
        gcqS+jjyzDbY8LAA5QbIl7WOIKHozxFyW6zmzXyry5aQFVvZY6hQsJyMpETKDybA
        OA3y0QCurqKtyVDA5/6OsBwx9iAtbqmLk4V+NlUfD0sEzC+I/ySWDBN7j8VBJDx9
        gzcVWeATCq+6ran/47WiWu7bHP0uk3ih9kMcJCpGEMAqVamAEA8h9hEpI/LVmUrF
        6iuwPR59NpVO2Hsdc+g76qfhIBsTvNvMPrw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KXIxAjV0MIlU for <linux-scsi@vger.kernel.org>;
        Wed, 10 Nov 2021 21:27:04 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HqVZv4GCGz1RtVl;
        Wed, 10 Nov 2021 21:27:03 -0800 (PST)
Message-ID: <93498302-c4c6-de7f-f177-e55de2828db0@opensource.wdc.com>
Date:   Thu, 11 Nov 2021 14:27:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Problem with scsi device sysfs attributes
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <4b3e8a72-0b48-95e3-6617-a685d42c08fb@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4b3e8a72-0b48-95e3-6617-a685d42c08fb@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 12:31, Damien Le Moal wrote:
> Bart,
> 
> Your patch 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
> modified the scsi device sysfs attributes initialization to use the scsi
> template shost_groups and sdev_groups for adding attributes using groups instead
> of arrays of attrs. However, this patch completely removed the
> sysfs_create_groups() call to actually create the attributes listed in the groups.
> 
> As a result, I see many missing sysfs device attributes for at least ahci (e.g.
> ncq_prio_enavle, ncq_prio_supported), but I suspect other device types may have
> similar problems.
> 
> I do not see where the attribute groups in the arrray sdev->gendev_attr_groups
> are registered with sysfs. In fact, it looks like sdev->gendev_attr_groups is
> referenced only in scsi_sysfs.c but only for initializing it. It is never used
> to actually register the attr groups... Am I missing something ?
> 
> This is at least breaking NCQ priority support right now. Did your patch
> 92c4b58b15c5 remove too much code ? Shouldn't we have a call to
> sysfs_create_groups() somewhere ? I think that should be in
> scsi_sysfs_device_initialize() but I am not 100% sure.

Adding this:

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d3d362289ecc..a1a30af96e17 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1339,6 +1339,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
        int error;
        struct scsi_target *starget = sdev->sdev_target;
+       struct Scsi_Host *shost = sdev->host;
+       struct scsi_host_template *hostt = shost->hostt;

        error = scsi_target_add(starget);
        if (error)
@@ -1365,6 +1367,17 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
                return error;
        }

+       if (hostt->sdev_groups) {
+               error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
+                                           hostt->sdev_groups);
+               if (error) {
+                       sdev_printk(KERN_INFO, sdev,
+                                   "failed to create device attributes:
%d\n",
+                                   error);
+                       return error;
+               }
+       }
+
        device_enable_async_suspend(&sdev->sdev_dev);
        error = device_add(&sdev->sdev_dev);
        if (error) {

I can see the AHCI NCQ attributes are visible under
/sysfs/block/sdX/device/.

So it looks like the LLD attribute groups added to
sdev->gendev_attr_groups by scsi_sysfs_device_initialize() using
hostt->sdev_groups are never registered with sysfs, but the default
common scsi attributes defined by scsi_sdev_attr_group are registered...
This is very weird.

I do not understand why. I cannot find where sdev->gendev_attr_groups is
used to create the attributes in sysfs...



-- 
Damien Le Moal
Western Digital Research
