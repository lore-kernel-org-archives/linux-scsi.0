Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A06BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbiGSDJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbiGSDJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:09:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317BB3C8FC
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 20:09:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKjwhD024475;
        Tue, 19 Jul 2022 03:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=TYg1lOJkgWVHkC6lc8v1O/2pro42QQx2wOoULTZ0KHU=;
 b=FrDUdjakm7TmR50dhtyJRIcE5wnERNgyxRRSsG4ljcxYtkz3vDk9nfUOAE29Dv03UmlC
 ncvo+fFrKUr29aBRLB7ylZB9f6srPGRAQSx49nDk5wumjMPLxdxYSwQ2ayb73seWOqto
 BVfB4XYh00AfSb0egDgQ33zRkGZDsI1m2XFTZlF7rdkeL8XUftp7lI2QQ9S+a9ck/Vi8
 3dznR1cvr0t/Kw5GLKPwYR6QPy8PzQsHT9sSVfniDWhJm1IOF6rFn2u7Mb+anVAoOEC3
 Qo7LODrKwGIWUxycq276aWMV7jWR8Me22apQR7QzMmecdF0WDhdiZWZuvDV1pjwASogS Qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42cymb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J1eiTT001872;
        Tue, 19 Jul 2022 03:09:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2ypta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:03 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J391U3016855;
        Tue, 19 Jul 2022 03:09:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hc1k2ypt1-2;
        Tue, 19 Jul 2022 03:09:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kumar.meiyappan@microchip.com, gerry.morong@microchip.com,
        POSWALD@suse.com, Justin.Lindley@microchip.com,
        mike.mcgowen@microchip.com, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, scott.benesh@microchip.com,
        murthy.bhat@microchip.com, joseph.szczypek@hpe.com,
        mahesh.rajashekhara@microchip.com,
        Don Brace <don.brace@microchip.com>, hch@infradead.org,
        jejb@linux.vnet.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 00/16] smartpqi updates
Date:   Mon, 18 Jul 2022 23:08:55 -0400
Message-Id: <165820009735.29375.5044702058624125689.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190011
X-Proofpoint-ORIG-GUID: 60IilbJv7LLxueif6gRxLk4R7Dx0oM_q
X-Proofpoint-GUID: 60IilbJv7LLxueif6gRxLk4R7Dx0oM_q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Jul 2022 13:46:45 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 5.20/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   5.20/scsi-queue
> 
> This set of changes consists of:
>  * Remove a device from the OS faster by adding -ENODEV return code check
>    in pqi_lun_reset. This status is set in the io_request->status member.
>    Schedule the rescan worker thread within 5 seconds to initiate the
>    removal. The driver used to retry a reset without checking for a
>    device's removal and initiated 3 more retries. Device resets were
>    taking up to 30 seconds. We also added a check to see if the controller
>    firmware is still responsive during a reset operation.
>  * Add the controller firmware version to the console logs. The firmware
>    version is still in sysfs firmware_version.
>  * Add support for more controllers; Ramaxel, Lenovo, and Adaptec.
>  * Close a few rare read/write ordering issues where a register read
>    could pass a register write.
>  * Add support for multi-actuator devices. Our controllers now support up
>    to 256 LUNs per multi-actuator device. We added a feature bit to check
>    if the controller supports multi-actuator devices and updated support
>    in the driver to support resets, I/O submission, and multi-actuator
>    device removals.
>  * Correct some rare system hangs that can occur when a PCI link-down
>    condition occurs (such as a cable pull). We also fail all outstanding
>    requests when a link-down is detected.
>  * Correct an issue with setting the DMA direction flag for RAID path
>    requests. It should be noted that there are two submission paths for
>    requests in the driver, a RAID path and an Accelerated I/O (AIO) path.
>    Beginning with firmware version 5.0 for Gen1 controllers and 3.01.x
>    for Gen2 controllers, a change was made that removed the SCSI command
>    READ BLOCK LIMITS (0x05) from an internal lookup table for RAID path
>    requests. As a result of this change, the firmware switched to using
>    the DMA direction flag in the request IU, which was incorrect. This
>    caused the command to hang the controller. This patch resolves the
>    hang. The AIO path is unaffected by the controller firmware change.
>  * correct a rare device RAID map access race condition related to
>    configuration changes. We do not access the RAID map until after the
>    new RAID map is valid.
>  * added a module parameter 'disable_managed_interrupts' to allow
>    customers to change IRQ affinity. Multi-queue still works properly.
>  * Updated device removal to using .slave_destroy instead of using our
>    own internal method.
>  * Added another module parameter to reduce the amount of time the
>    driver waits for a controller to become ready. The default wait time
>    is 3 minutes but can be extended to 30 minutes. This change results
>    from customers with large installations requesting a longer wait time.
>  * Updated copyright information.
>  * Bump the driver version to 2.1.18-045
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/16] smartpqi: shorten drive visibility after removal
        https://git.kernel.org/mkp/scsi/c/4e7d26029ee7
[02/16] smartpqi: add controller fw version to console log
        https://git.kernel.org/mkp/scsi/c/1d393227fc76
[03/16] smartpqi: add PCI-IDs for ramaxel controllers
        https://git.kernel.org/mkp/scsi/c/dab5378485f6
[04/16] smartpqi: close write read holes
        https://git.kernel.org/mkp/scsi/c/297bdc540f0e
[05/16] smartpqi: add driver support for multi-LUN devices
        https://git.kernel.org/mkp/scsi/c/904f2bfda65e
[06/16] smartpqi: fix PCI control linkdown system hang
        https://git.kernel.org/mkp/scsi/c/331f7e998b20
[07/16] smartpqi: add PCI-ID for Adaptec SmartHBA 2100-8i
        https://git.kernel.org/mkp/scsi/c/44e68c4af5d2
[08/16] smartpqi: add PCI-IDs for Lenovo controllers
        https://git.kernel.org/mkp/scsi/c/2a9c2ba2bc47
[09/16] smartpqi: stop logging spurious PQI reset failures
        https://git.kernel.org/mkp/scsi/c/85b41834b0f4
[10/16] smartpqi: fix dma direction for RAID requests
        https://git.kernel.org/mkp/scsi/c/69695aeaa662
[11/16] smartpqi: fix RAID map race condition
        https://git.kernel.org/mkp/scsi/c/6ce3cfb365eb
[12/16] smartpqi: add module param to disable managed ints
        https://git.kernel.org/mkp/scsi/c/cf15c3e734e8
[13/16] smartpqi: update deleting a LUN via sysfs
        https://git.kernel.org/mkp/scsi/c/2d80f4054f7f
[14/16] smartpqi: add ctrl ready timeout module parameter
        https://git.kernel.org/mkp/scsi/c/6d567dfee0b7
[15/16] smartpqi: update copyright to current year.
        https://git.kernel.org/mkp/scsi/c/e4b73b3fa2b9
[16/16] smartpqi: update version to 2.1.18-045
        https://git.kernel.org/mkp/scsi/c/f54f85dfd757

-- 
Martin K. Petersen	Oracle Linux Engineering
