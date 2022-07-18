Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4F9C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 16:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbiGRQv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 12:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiGRQvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 12:51:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6222B244
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 09:51:52 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGi9sT016197;
        Mon, 18 Jul 2022 16:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=bcZ0eX5Cu/ii/H0jlWGUZRsuqZyFqaUO5IvkG1G8xq4=;
 b=H9f/l9LY5/dNDbYfWkY3eo4g/UFN7sH735BzBJjL08rRS83F8WMZUmUbUZ0IGAfV5N7V
 a9Uj5B36ImiBK9MHObGvHgeji+0uIgQBKYinQIaCfQi+T0kt+W/2nvfmcO+sGyR1lEmR
 71BkO+W8fdYG/pb2hm8SURTGk5Vozr9rZqvKgQRl6okYcz8FzXeM0PrSJSglMJo5jAbE
 4ylaWoz36zrk94nE+mOny57CWrhTsyvD5++HJViQg9HG5Z87PRyVm1nlETLNTJNjVugM
 LnGNpZRLCQHaMhxrKqoNhI8sOkV5V1UAAVbGJzXYmxSR+rBgc4yoPJo7gdQs7iEOeVeT Zw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdba305e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 16:51:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26IGpCYp020811;
        Mon, 18 Jul 2022 16:51:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8tudd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 16:51:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26IGo32h22348084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 16:50:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA4144C046;
        Mon, 18 Jul 2022 16:51:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B2F4C044;
        Mon, 18 Jul 2022 16:51:45 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.17.130])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 18 Jul 2022 16:51:45 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1oDTyD-000Fpn-6I;
        Mon, 18 Jul 2022 18:51:45 +0200
Date:   Mon, 18 Jul 2022 16:51:45 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: regression next-20220714: mkfs.ext4 on multipath device over scsi
 disks causes 'lifelock' in block layer
Message-ID: <YtWPoZISMLxHA/vu@t480-pf1aa2c2.fritz.box>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-11-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-11-martin.petersen@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nvvSn4COse4YsNuHvBWW-zvaQ_cF8qLw
X-Proofpoint-ORIG-GUID: nvvSn4COse4YsNuHvBWW-zvaQ_cF8qLw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_16,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 02, 2022 at 12:35:55AM -0500, Martin K. Petersen wrote:
> In preparation for adding support for the WRITE SAME(16) NDOB flag,
> move configuration of the WRITE_ZEROES operation to a separate
> function. This is done to facilitate fetching all VPD pages before
> choosing the appropriate zeroing method for a given device.
> 
> The deferred configuration also allows us to mirror the discard
> behavior and permit the user to revert a device to the kernel default
> configuration by echoing "default" to the sysfs file.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++--------------
>  drivers/scsi/sd.h |  7 ++++--
>  2 files changed, 44 insertions(+), 19 deletions(-)
> 

Hello Martin,

somehow this patch triggers a regression on s390x with zFCP in
`next-20220714`.

In our daily regression test suite a simple:

  # mkfs.ext4 -F /dev/mapper/mpathc1

causes the block layer to trip with this when trying to discard blocks
(at least that's my assumption about what its trying to do) from a SCSI
disk:

  [   33.042224] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   33.042228] device-mapper: multipath: 251:0: Failing path 8:0.
  [   33.042239] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   33.042267] device-mapper: multipath: 251:0: Failing path 8:64.
  [   33.197329] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   33.198850] device-mapper: multipath: 251:0: Reinstating path 8:64.
  [   33.210742] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   33.210752] device-mapper: multipath: 251:0: Failing path 8:0.
  [   33.210771] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   33.210792] device-mapper: multipath: 251:0: Failing path 8:64.
  [   38.200929] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   38.201489] device-mapper: multipath: 251:0: Reinstating path 8:64.
  [   38.220039] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   38.220045] device-mapper: multipath: 251:0: Failing path 8:0.
  [   38.220056] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   38.220060] device-mapper: multipath: 251:0: Failing path 8:64.
  [   43.202538] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   43.203015] device-mapper: multipath: 251:0: Reinstating path 8:64.
  [   43.219877] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   43.219881] device-mapper: multipath: 251:0: Failing path 8:0.
  [   43.219889] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   43.219892] device-mapper: multipath: 251:0: Failing path 8:64.
  [   48.204035] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   48.204526] device-mapper: multipath: 251:0: Reinstating path 8:64.
  [   48.219951] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   48.219964] device-mapper: multipath: 251:0: Failing path 8:0.
  [   48.219990] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   48.219996] device-mapper: multipath: 251:0: Failing path 8:64.
  [   53.205456] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   53.206950] device-mapper: multipath: 251:0: Reinstating path 8:64.
  [   53.219820] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   53.219824] device-mapper: multipath: 251:0: Failing path 8:0.
  [   53.219834] blk_insert_cloned_request: over max size limit. (4194304 > 65535)
  [   53.219837] device-mapper: multipath: 251:0: Failing path 8:64.
  [   58.209693] device-mapper: multipath: 251:0: Reinstating path 8:0.
  [   58.210143] device-mapper: multipath: 251:0: Reinstating path 8:64.

This continues ad infinitum.

I suspected this patchset as it's new in next-20220714, and next-20220704
didn't have this bug in our regression runs. I didn't see any other 'obvious'
patch in scsi or block that has a diff between those two tags.

I started bisecting between:
  9821106213c8 ("scsi: zfcp: Drop redundant "the" in the comments")
as good, and
  f095c3cd1b69 ("scsi: qla2xxx: Update version to 10.02.07.800-k")
as bad; and ended up at:
  1bd95bb98f83 ("scsi: sd: Move WRITE_ZEROES configuration to a separate function")

I ran this on Fedora 36, with mkfs.ext4 1.46.5 (30-Dec-2021).

The multipath device:

  create: mpathc (36005076307ffc5e3000000000000805c) dm-0 IBM,2107900
  size=20G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
  `-+- policy='service-time 0' prio=50 status=active
    |- 0:0:0:1079787648 sda 8:0   active ready running
    `- 1:0:0:1079787648 sde 8:64  active ready running

Some information on the block devices and topology:

  # lsblk /dev/sda /dev/sde
  NAME        MAJ:MIN RM SIZE RO TYPE  MOUNTPOINTS
  sda           8:0    0  20G  0 disk
  └─mpathc    251:0    0  20G  0 mpath
    └─mpathc1 251:2    0  20G  0 part
  sde           8:64   0  20G  0 disk
  └─mpathc    251:0    0  20G  0 mpath
    └─mpathc1 251:2    0  20G  0 part
  # lsblk -t /dev/sda /dev/sde
  NAME        ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE  RA WSAME
  sda                 0    512      0     512     512    1 bfq             256 512    0B
  └─mpathc            0    512      0     512     512    1 mq-deadline     256 128    0B
    └─mpathc1         0    512      0     512     512    1                 128 128    0B
  sde                 0    512      0     512     512    1 bfq             256 512    0B
  └─mpathc            0    512      0     512     512    1 mq-deadline     256 128    0B
    └─mpathc1         0    512      0     512     512    1                 128 128    0B
  # lsblk -D /dev/sda /dev/sde
  NAME        DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
  sda                0        1G       4G         0
  └─mpathc           0        1G       4G         0
    └─mpathc1        0        1G       4G         0
  sde                0        1G       4G         0
  └─mpathc           0        1G       4G         0
    └─mpathc1        0        1G       4G         0
  # lsblk -S /dev/sda /dev/sde
  NAME HCTL             TYPE VENDOR   MODEL    REV SERIAL      TRAN
  sda  0:0:0:1079787648 disk IBM      2107900 1060 75DL241805C fc
  sde  1:0:0:1079787648 disk IBM      2107900 1060 75DL241805C fc

Any idea why this is happening? In case you need more details, this
reproduces very reliably here.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
