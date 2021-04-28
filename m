Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04375C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE1F26144A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhD1XXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 19:23:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56774 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhD1XXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 19:23:50 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210428232302epoutp01c10ce9a765abdb7db1cfdec702feb7fb~6KRQ957zh3096930969epoutp01r
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 23:23:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210428232302epoutp01c10ce9a765abdb7db1cfdec702feb7fb~6KRQ957zh3096930969epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619652182;
        bh=veV6D9x1M3bFbS0JiBxgWeQmEtL7MjpWoFNiNEBnsLk=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=tEjlHgRCTtBJjkOJe/tmv9v+Tl6ozkbAgVNN91WyS7tVpX36MblMVQB1eJJw5DUMR
         bHB21R+kVFIhwQXwxXmuHw7YJNs2Fr0sE/UMaGIZG4QZT/S4Aa8EAviHjbMI4nybA7
         +CbJ3bb3NvNzJchl7yAV4EE5ZkxRCqxtkXe0nTrc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210428232301epcas2p469bf20b40118727c8d7166e0748a3c14~6KRPtF1360572805728epcas2p4X;
        Wed, 28 Apr 2021 23:23:01 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FVvnF6SyQz4x9QB; Wed, 28 Apr
        2021 23:22:57 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-ed-6089ee517049
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.FC.09717.15EE9806; Thu, 29 Apr 2021 08:22:57 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v34 0/4] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
Date:   Thu, 29 Apr 2021 08:22:57 +0900
X-CMS-MailID: 20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xbVRzHc+4t9941dl4YG0dUKNfoLI7SEgoHA/hi5DpcArLVBGOgae8o
        sbS1l4KPqDUoFCpscyqzQ5gIm2FIAVdWGLLxGLCZxSw83JqxgZMZIuWZKYgQKS1u8b9Pfud7
        fr/v9zwoPOguEUrl6Qs4k16lYwihoL1PoojKmC3LkVlKotFETTuBfiwZItH0yiiBvpxfwdGi
        41QAmu6VoM6eHgI1TryGir91EKj6qgVDFYedBPqhpwVHd24ukajuejuGDq+XClD7UiAavDwL
        0HBnNYFsv7gIdHpwHUMNzhsAlVU1CZ7fxQ6PpLHDlRUY22EfJ9kjdRcBe+HrJpL9+PIFAbsw
        5RawlWcbAbvUFsaWXrRh6cIsXaKWU2k4k5jTqw2aPH1uEpOWmf1StiJOJo+SJ6B4RqxX5XNJ
        TMor6VGpebqNmIy4UKUzb5TSVTzPRCcnmgzmAk6sNfAFSQxn1OiMcrlRyqvyebM+V6o25D8r
        l8liFBvKHJ12tLYFGIvj33Z/d0JgAc5nysE2CtKx8M5YN1kOhFQQ7QJwse42Xg4oSkQHwjXX
        Dq9mB83Cku8/I70cRDPQcc1O+upS6J5sAl4m6D2wauj2Zp9gepqE/9TPYr4BIni8dErg40fh
        udNO4OOn4fKpCtzHO+GNMx5yi+cGav2aYPjJrat+TSCcWDnvrz8CB87P+/t/CJ03/wbewZD+
        FMC+DneAbyEajllbNweL6P3Qc8Wz2UhAPwnHG2x+QymwtuIvwss4HQ7Peao3w+O0BDo6o70I
        6Sdgv1uwFcXSukr+n3F6O7T2rf1Xd9X85rf2FGxecWC+No9Bdw3wIQt7HHlHQIT9/jnbH3Bg
        v+/gJMAbwS7OyOfncnyMMfbBq20Dmw8+knWBE555aS/AKNALIIUzwaLV5rKcIJFG9c67nMmQ
        bTLrOL4XKDayH8VDd6oNGz9GX5AtV8TExckSFEgRF4OYENEK90FOEJ2rKuDe5DgjZ9rah1Hb
        Qi2Ycmi4eEH6s/asJCRgfJ/jcXdH1HMnGfmf4qLEwiHJQoNZHjLy4qsZioM/pXXEifdNWpKn
        FMetYUmEdSzHVqiNmGvpUn5FLDqlMknWQNuZ+FTXN2sTqfUL6szIQ8rFlz/v/6hP2z3VPLP+
        x6X4YJn6ocGSftB8afn9KqfggHB3VeIBZVoaWh2pMYyl3BN+Ebm7aCzw3rWDL/CHHr7ST/Zv
        70tWD3Fk7dwbyrzyNXYZZIWFkN30nsy9e4/1LFVNTttWNZPhv88UxXqUoxFLpXYNRVqpX2ey
        7w4n2z1lLeX7YwjLwFutq9ZwTObsKqw4pq2fLbK9br7edStDGJ3wXiUj4LUqeSRu4lX/AjGP
        E+x5BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb
References: <CGME20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changelog:

v33 -> v34
Fix warning about NULL check before some freeing functions is not needed.

v32 -> v33
1. Fix wrong usage of scsi_command_normalize_sense.
2. Addressed Bart's comments (func. name, type casting, parentheses)

v31 -> v32
Delete unused parameter of unmap API.

v30 -> v31
Delete unnecessary debug message.

v29 -> v30
1. Add support to reuse bio of pre-request.
2. Delete unreached code in the ufshpb_issue_map_req.

v28 -> v29
1. Remove unused variable that reported by kernel test robot.

v27 -> v28
1. Fix wrong return value of ufshpb_prep.

v26 -> v27
1. Fix wrong refernce of sense buffer in pre_req complete function.
2. Fix read_id error.
3. Fix chunk size checking for HPB 1.0.
4. Mute unnecessary messages before HPB initialization.

v25 -> v26
1. Fix wrong chunk size checking for HPB 1.0.
2. Fix wrong max data size for HPB single command.
3. Fix typo error.

v24 -> v25
1. Change write buffer API for unmap region.
2. Add checking hpb_enable for avoiding unnecessary memory allocation.
3. Change pr_info to dev_info.
4. Change default requeue timeout value for HPB read.
5. Fix wrong offset manipulation on ufshpb_prep_entry.

v23 -> v24
1. Fix build error reported by kernel test robot.

v22 -> v23
1. Add support compatibility of HPB 1.0.
2. Fix read id for single HPB read command.
3. Fix number of pre-allocated requests for write buffer.
4. Add fast path for response UPIU that has same LUN in sense data.
5. Remove WARN_ON for preventing kernel crash.
7. Fix wrong argument for read buffer command.

v21 -> v22
1. Add support processing response UPIU in suspend state.
2. Add support HPB hint from other LU.
3. Add sending write buffer with 0x03 after HPB init.

v20 -> v21
1. Add bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD attr. and fHPBen flag support.

v19 -> v20
1. Add documentation for sysfs entries of hpb->stat.
2. Fix read buffer command for under-sized sub-region.
3. Fix wrong condition checking for kick map work.
4. Delete redundant response UPIU checking.
5. Add LUN checking in response UPIU.
6. Fix possible deadlock problem due to runtime PM.
7. Add instant changing of sub-region state from response UPIU.
8. Fix endian problem in prefetched PPN.
9. Add JESD220-3A (HPB v2.0) support.

v18 -> 19
1. Fix null pointer error when printing sysfs from non-HPB LU.
2. Apply HPB read opcode in lrbp->cmd->cmnd (from Can Guo's review).
3. Rebase the patch on 5.12/scsi-queue.

v17 -> v18
Fix build error which reported by kernel test robot.

v16 -> v17
1. Rename hpb_state_lock to rgn_state_lock and move it to corresponding
patch.
2. Remove redundant information messages.

v15 -> v16
1. Add missed sysfs ABI documentation.

v14 -> v15
1. Remove duplicated sysfs ABI entries in documentation.
2. Add experiment result of HPB performance testing with iozone.

v13 -> v14
1. Cleanup codes by commentted in Greg's review.
2. Add documentation for sysfs entries (from Greg's review).
3. Add experiment result of HPB performance testing.

v12 -> v13
1. Cleanup codes by comments from Can Guo.
2. Add HPB related descriptor/flag/attributes in sysfs.
3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.

v11 -> v12
1. Fixed to return error value when HPB fails to initialize pinned active 
region.
2. Fixed to disable HPB feature if HPB fails to allocate essential memory
and workqueue.
3. Fixed to change proper sub-region state when region is already evicted.

v10 -> v11
Add a newline at end the last line on Kconfig file.

v9 -> v10
1. Fixed 64-bit division error
2. Fixed problems commentted in Bart's review.

v8 -> v9
1. Change sysfs initialization.
2. Change reading descriptor during HPB initialization
3. Fixed problems commentted in Bart's review.
4. Change base commit from 5.9/scsi-queue to 5.10/scsi-queue.

v7 -> v8
Remove wrongly added tags.

v6 -> v7
1. Remove UFS feature layer.
2. Cleanup for sparse error.

v5 -> v6
Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405

v4 -> v5
Delete unused macro define.

v3 -> v4
1. Cleanup.

v2 -> v3
1. Add checking input module parameter value.
2. Change base commit from 5.8/scsi-queue to 5.9/scsi-queue.
3. Cleanup for unused variables and label.

v1 -> v2
1. Change the full boilerplate text to SPDX style.
2. Adopt dynamic allocation for sub-region data structure.
3. Cleanup.

NAND flash memory-based storage devices use Flash Translation Layer (FTL)
to translate logical addresses of I/O requests to corresponding flash
memory addresses. Mobile storage devices typically have RAM with
constrained size, thus lack in memory to keep the whole mapping table.
Therefore, mapping tables are partially retrieved from NAND flash on
demand, causing random-read performance degradation.

To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
(Host Performance Booster) which uses host system memory as a cache for the
FTL mapping table. By using HPB, FTL data can be read from host memory
faster than from NAND flash memory. 

The current version only supports the DCM (device control mode).
This patch consists of 3 parts to support HPB feature.

1) HPB probe and initialization process
2) READ -> HPB READ using cached map information
3) L2P (logical to physical) map management

In the HPB probe and init process, the device information of the UFS is
queried. After checking supported features, the data structure for the HPB
is initialized according to the device information.

A read I/O in the active sub-region where the map is cached is changed to
HPB READ by the HPB.

The HPB manages the L2P map using information received from the
device. For active sub-region, the HPB caches through ufshpb_map
request. For the in-active region, the HPB discards the L2P map.
When a write I/O occurs in an active sub-region area, associated dirty
bitmap checked as dirty for preventing stale read.

HPB is shown to have a performance improvement of 58 - 67% for random read
workload. [1]

[1]:
https://www.usenix.org/conference/hotstorage17/program/presentation/jeong

Daejun Park (4):
  scsi: ufs: Introduce HPB feature
  scsi: ufs: L2P map management for HPB read
  scsi: ufs: Prepare HPB read for cached sub-region
  scsi: ufs: Add HPB 2.0 support

 Documentation/ABI/testing/sysfs-driver-ufs |  162 ++
 drivers/scsi/ufs/Kconfig                   |    9 +
 drivers/scsi/ufs/Makefile                  |    1 +
 drivers/scsi/ufs/ufs-sysfs.c               |   22 +
 drivers/scsi/ufs/ufs.h                     |   54 +-
 drivers/scsi/ufs/ufshcd.c                  |   74 +-
 drivers/scsi/ufs/ufshcd.h                  |   29 +
 drivers/scsi/ufs/ufshpb.c                  | 2384 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                  |  277 +++
 9 files changed, 3010 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.25.1

