Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5495C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 23:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354098AbiBKXZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 18:25:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiBKXZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 18:25:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39B0C5F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 15:25:45 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BJdn8L011211;
        Fri, 11 Feb 2022 23:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=jbXTMi9DBkCEN0T2U/8yLPaNWbXYb+DkQQLbjPbMk9k=;
 b=keQObEuwjpTNJKQNRiGU9GZno4tKLhTDyM6Lc6arnfifva6ER+Mjq7KWUGRlEqjrTysj
 Q5KMEtgIQNELAfd8cd5GhKvxh63rBS0SYELrHDVfyjU3/e1sKsRZJa+64SWKVrOdePKC
 K6QEVA3kV50T0hlP5fABrOMoJtezKItOC+vlqYBpWNDfUa9Hh/sdtXpxTdP29PMSCCce
 m8m6UAMcXS/pZ0iasOa5UZnmzyDKQDyDAvhh5sAFZNvU3tzQXmt7FM8gWV3WM/1+37l8
 oZE8iD7mDTNn3g/51G1eb9UhfnkAJEDwYL/Auz6IDx/weXZcd9RWedlqX1pvf1n2VW1q zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5njr1rgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BNG6sX020730;
        Fri, 11 Feb 2022 23:25:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3e1jpykk1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 23:25:30 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21BNPTt9094578;
        Fri, 11 Feb 2022 23:25:30 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3e1jpykk0v-1;
        Fri, 11 Feb 2022 23:25:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     scott.teel@microchip.com, scott.benesh@microchip.com,
        jejb@linux.vnet.ibm.com, POSWALD@suse.com, joseph.szczypek@hpe.com,
        murthy.bhat@microchip.com, gerry.morong@microchip.com,
        Don Brace <don.brace@microchip.com>,
        mahesh.rajashekhara@microchip.com, Justin.Lindley@microchip.com,
        hch@infradead.org, mike.mcgowen@microchip.com,
        Kevin.Barnett@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/18] smartpqi updates
Date:   Fri, 11 Feb 2022 18:25:24 -0500
Message-Id: <164462189850.7606.16409799152267021175.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: qnZQsk90CANAewCPgCo31grjw_V1y_Ba
X-Proofpoint-ORIG-GUID: qnZQsk90CANAewCPgCo31grjw_V1y_Ba
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Feb 2022 15:47:47 -0600, Don Brace wrote:

> These patches are based on Martin Petersen's 5.18/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   5.18/scsi-queue
> 
> This set of changes consist of:
>  * Correcting a stack trace when the driver is unloaded. The driver was
>    holding a spin lock when calling scsi_remove_device.
>  * Adding in new PCI device IDs and aligning the device order with our
>    out-of-box driver. No functional changes.
>  * Allow NCQ to be enabled for SATA disks. The controller firmware has
>    to have support for this feature.
>  * Enhance reboot performance by now issuing disk spin-downs during
>    reboots. This eliminates spin-up time required doing the boot up.
>  * Speed up multipath failover detection by returning DID_NO_CONNECT
>    when the controller returns a path failure. Previously, the driver was
>    waiting on an internal re-scan to detect the path failure.
>  * Change function name pqi_is_io_high_priority() to
>    pqi_is_io_high_priority() for better readability. Remove some white
>    spaces from the same function.
>  * Correct the structure used for AIO command submission. The structure
>    used was pqi_raid_path_request, but needs to be pqi_aio_path_request.
>    Both structure are the same size and have the same member offsets,
>    so no issues were reported.
>  * A PQI_HZ MACRO was introduced some time ago to resolve some timing
>    issues. This definition is not needed. Switch back to using HZ.
>  * For certain controllers, there was a request to avoid a drive
>    spin-down for suspend (S3) state transitions.
>  * For small drive expansions, the driver was not detecting the new
>    size changes. We added a rescan whenever the driver receives an
>    event from the controller.
>  * In some rare cases, the controller can be locked up when a kdump
>    is requested. When this occurs, the kdump is failed. This helps
>    in debugging the cause of the lockup.
>  * For RAID 10 disks, only one set of disks were used for read
>    operations. Now we spread out I/O to all volumes. This resolves
>    some inconsistent performance issues.
>  * Export SAS addresses for all disks instead of only SAS disks.
>  * Correct NUMA node association during pci_probe. A small typo
>    was causing a different NUMA node to be set.
>  * Not all structures were checked with BUILD_BUG_ON.
>  * Correct some rare Hibernate/Suspend issues. Newer controllers
>    may boot up with different timings.
>  * Correct WWID output for lsscsi -t. The wrong part of the 16-byte WWID
>    was used for the SAS address field.
>  * Bump the driver version to 2.1.14-035
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/18] smartpqi: fix rmmod stack trace
        https://git.kernel.org/mkp/scsi/c/c4ff687d25c0
[02/18] smartpqi: add PCI IDs
        https://git.kernel.org/mkp/scsi/c/c57ee4ccb358
[03/18] smartpqi: enable SATA NCQ priority in sysfs
        https://git.kernel.org/mkp/scsi/c/2a47834d9452
[04/18] smartpqi: eliminate drive spin down on warm boot
        https://git.kernel.org/mkp/scsi/c/70ba20be4bb1
[05/18] smartpqi: propagate path failures to SML quickly
        https://git.kernel.org/mkp/scsi/c/94a68c814328
[06/18] smartpqi: fix a name typo and cleanup code
        https://git.kernel.org/mkp/scsi/c/b4dc06a9070e
[07/18] smartpqi: fix a typo in func pqi_aio_submit_io
        https://git.kernel.org/mkp/scsi/c/9e98e60bfca3
[08/18] smartpqi: resolve delay issue with PQI_HZ value
        https://git.kernel.org/mkp/scsi/c/42dc0426fbbb
[09/18] smartpqi: avoid drive spin-down during suspend
        https://git.kernel.org/mkp/scsi/c/b73357a1fd39
[10/18] smartpqi: update volume size after expansion
        https://git.kernel.org/mkp/scsi/c/27655e9db479
[11/18] smartpqi: fix kdump issue when ctrl is locked up
        https://git.kernel.org/mkp/scsi/c/3ada501d602a
[12/18] smartpqi: speed up RAID 10 sequential reads
        https://git.kernel.org/mkp/scsi/c/5d8fbce04d36
[13/18] smartpqi: expose SAS address for SATA drives
        https://git.kernel.org/mkp/scsi/c/00598b056aa6
[14/18] smartpqi: fix NUMA node not updated during init
        https://git.kernel.org/mkp/scsi/c/c52efc923856
[15/18] smartpqi: fix BUILD_BUG_ON() statements
        https://git.kernel.org/mkp/scsi/c/5e6935864d81
[16/18] smartpqi: fix hibernate and suspend
        https://git.kernel.org/mkp/scsi/c/c66e078ad89e
[17/18] smartpqi: fix lsscsi-t SAS addresses
        https://git.kernel.org/mkp/scsi/c/291c2e0071ef
[18/18] smartpqi: update version to 2.1.14-035
        https://git.kernel.org/mkp/scsi/c/62ed6622aaf0

-- 
Martin K. Petersen	Oracle Linux Engineering
