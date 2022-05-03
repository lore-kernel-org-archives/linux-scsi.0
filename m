Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE3AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 08:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiEDIWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 04:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346269AbiEDIWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 04:22:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F233237F2
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 01:18:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2430TJqe004092;
        Tue, 3 May 2022 00:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=s8lUmsZe8RextxlB8jcIFPjd3TiNngRfTYFzKzpxct8=;
 b=AU2OQFzGJGyfyZlZRaCd2U2PLt/vvjXdtPNXHzWhWa3O3lsB+TgOyNPS0L7w+U18OtNk
 +MA4bF5nlqcFzRxsjl+A/1tisfNU2zNo/dTQmp72DjlNz8DI4gP7E7DG6351b1UE8d51
 2Y5bMSjmAUGW0Yah9lC5/z32c3Rhcux2+WjSNKyULh42IwjTrJiEdA2zXz3NK2Z2FIdW
 g7e1NCkNq1STzx+qJNVtiMsc76/ahxPe2RbOb3ErjwLc1iJFLyhG9ySLijT0iPTzEEcd
 cgCQO/OGuLKTW2oeGWGXFD0M9lV1yODrHNp/zLQqktcSicB8GhyuKXvciC4GYfq5fnh+ cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430opCW008935;
        Tue, 3 May 2022 00:51:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:53 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljI010389;
        Tue, 3 May 2022 00:51:52 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-11;
        Tue, 03 May 2022 00:51:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Hannes Reinecke <hare@suse.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support zoned devices with gap zones
Date:   Mon,  2 May 2022 20:51:21 -0400
Message-Id: <165153836359.24053.1674323302545812899.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jvHrslQWNpTGO9E8TR4BfgT1FQ-Y73-g
X-Proofpoint-ORIG-GUID: jvHrslQWNpTGO9E8TR4BfgT1FQ-Y73-g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Apr 2022 11:30:14 -0700, Bart Van Assche wrote:

> In ZBC-2 support has been improved for zones with a size that is not a power
> of two by allowing host-managed devices to report gap zones. This patch adds
> support for zoned devices for which data zones and gap zones alternate if the
> distance between zone start LBAs is a power of two.
> 
> Please consider this patch series for kernel v5.19.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/9] scsi: sd_zbc: Improve source code documentation
      https://git.kernel.org/mkp/scsi/c/aa96bfb4caff
[2/9] scsi: sd_zbc: Verify that the zone size is a power of two
      https://git.kernel.org/mkp/scsi/c/9a93b9c9d38a
[3/9] scsi: sd_zbc: Use logical blocks as unit when querying zones
      https://git.kernel.org/mkp/scsi/c/43af5da09efb
[4/9] scsi: sd_zbc: Introduce struct zoned_disk_info
      https://git.kernel.org/mkp/scsi/c/628617be8968
[5/9] scsi: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
      https://git.kernel.org/mkp/scsi/c/60caf3758103
[6/9] scsi: sd_zbc: Hide gap zones
      https://git.kernel.org/mkp/scsi/c/c976e588b34e
[7/9] scsi_debug: Fix a typo
      https://git.kernel.org/mkp/scsi/c/897284e8a048
[8/9] scsi_debug: Rename zone type constants
      https://git.kernel.org/mkp/scsi/c/35dbe2b9a7b0
[9/9] scsi_debug: Add gap zone support
      https://git.kernel.org/mkp/scsi/c/4a5fc1c6d752

-- 
Martin K. Petersen	Oracle Linux Engineering
