Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78ECC4332B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9806A22241
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 10:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbhADKsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:48:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10292 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbhADKsd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 05:48:33 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210104104748epoutp0259c2c6bd8b879178288df75dd47bc1ee~XAbUJQxA72488024880epoutp02g
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:47:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210104104748epoutp0259c2c6bd8b879178288df75dd47bc1ee~XAbUJQxA72488024880epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1609757268;
        bh=Go/clYggiEyM6zQDZcFotUEs/WoFOIkWSvwzSQH2jhw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OBs5f/tK7eWNka3cYwngkJAhm+iE2KZ9tlXpjUh66m/81zee6RuYmwiu9Kr/mR+34
         OcqB5zIt13D5MV6yhe1NL4yBc/Rsss7XcBZaCcpthr4q++PHs3o5oWxu0PuG5EeLIZ
         OZL4Z+uJIeerFNgawJeDQ2JI1K4JIfI6Zzxu6SRk=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210104104748epcas5p35140f9de7456e26b75523b7131b32c20~XAbTXt3_F0252202522epcas5p3-;
        Mon,  4 Jan 2021 10:47:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.DB.15682.352F2FF5; Mon,  4 Jan 2021 19:47:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210104104237epcas5p1ed2d167f50060eb0567ade5d9a1df701~XAWydkdLf2312423124epcas5p1z;
        Mon,  4 Jan 2021 10:42:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210104104237epsmtrp287e4dee44b7d8db23bbf16ad41c2100a~XAWycdM_m2765327653epsmtrp2N;
        Mon,  4 Jan 2021 10:42:37 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-da-5ff2f2534d7b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.49.13470.D11F2FF5; Mon,  4 Jan 2021 19:42:37 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210104104233epsmtip1173332a6b503fc6f3517b19376a68251~XAWuBs05c1774617746epsmtip1T;
        Mon,  4 Jan 2021 10:42:32 +0000 (GMT)
From:   SelvaKumar S <selvakuma.s1@samsung.com>
To:     linux-nvme@lists.infradead.org
Cc:     kbusch@kernel.org, axboe@kernel.dk, damien.lemoal@wdc.com,
        Johannes.Thumshirn@wdc.com, hch@lst.de, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, mpatocka@redhat.com, hare@suse.de,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com, SelvaKumar S <selvakuma.s1@samsung.com>
Subject: [RFC PATCH v4 0/3] add simple copy support
Date:   Mon,  4 Jan 2021 16:11:56 +0530
Message-Id: <20210104104159.74236-1-selvakuma.s1@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmum7wp0/xBg++m1qsvtvPZjHtw09m
        i9b2b0wWe9/NZrXYs2gSk8XK1UeZLB7f+cxu8bfrHpPF0f9v2SwmHbrGaLH3lrbF5V1z2Czm
        L3vKbtF9fQebxfLj/5gsJnZcZbLY9ns+s8WVKYuYLda9fs9i8eD9dXaL1z9Oslm0bfzK6CDm
        cfmKt8fOWXfZPc7f28jicflsqcemVZ1sHpuX1HvsvtnA5vHx6S0Wj/f7rrJ59G1Zxeix+XS1
        x+dNch7tB7qZAnijuGxSUnMyy1KL9O0SuDIa9txlK9itVHG8bzJ7A+Nx6S5GTg4JAROJ/hM/
        2LsYuTiEBHYzSvxcv5wFwvnEKPF77ieozDdGifV717LDtDzvXMoMkdjLKDFrwls2COczo8TZ
        /ddZQKrYBHQlri3ZBGaLCChJ/F3fBDaXWeAms8SlX5/ARgkLGEsc6rnKCmKzCKhK3N+0HqyB
        V8BW4snf20wQ6+QlZl76zg4RF5Q4OfMJWA0zULx562xmiJp2TonZy20gbBeJJycXQJ0qLPHq
        +BYoW0ri87u9bBB2ucSzzmlQ8xsYJfrel0PY9hIX9/wFinMAzdeUWL9LHyIsKzH11DomiLV8
        Er2/n0C18krsmPcErFxCQE3i1HYziLCMxIfDu6A2eUh8m/obrFxIIFbi9c6PrBMY5WcheWYW
        kmdmISxewMi8ilEytaA4Nz212LTAMC+1XK84Mbe4NC9dLzk/dxMjOGlqee5gvPvgg94hRiYO
        xkOMEhzMSiK8FRc+xAvxpiRWVqUW5ccXleakFh9ilOZgURLn3WHwIF5IID2xJDU7NbUgtQgm
        y8TBKdUATMSG6nM3bFfnilForbE/KLvz14T7FTmb/q6YeW7BzLP2i67GWeit1jj0xOf1bx8H
        2Xgr/67D83w+xd9v/ZM/u9q4tO6u9+wft/azzwlpMrv7IGTjzFkqc1S/LDr28Ngjy7CWyOpF
        hxlPGgi8UTab/Mgi+L0jx48PU3V/6scZr/+2b6bai/by/uTQmL3nli8sNxI5K1MlJy93u3/9
        /1AH6/75NT1XHNJOHC9aYHso6syn9YGX55uEck016dq7Vu303s+XfpivrWGcm/bx8N70+GKj
        62/sJLtmXvjZwp7P8fKpTcJuMa0DvtpH7kkbpaQ/d9zIfDXwS7ntqeCdcyKSnldcj02eUG3T
        9ubml93LLyqxFGckGmoxFxUnAgB9ywkyCQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnK7sx0/xBse6NSxW3+1ns5j24Sez
        RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
        lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
        uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
        4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBkNe+6yFexWqjjeN5m9gfG4dBcjJ4eEgInE886l
        zF2MXBxCArsZJf61djBCJGQk1t7tZIOwhSVW/nvODlH0kVHi2c79rCAJNgFdiWtLNrGA2CIC
        ShJ/1zexgBQxC3xmlpi/qw0sISxgLHGo5ypYA4uAqsT9TevB4rwCthJP/t5mgtggLzHz0nd2
        iLigxMmZT4BqOIAGqUusnycEEmYGKmneOpt5AiP/LCRVsxCqZiGpWsDIvIpRMrWgODc9t9iw
        wDAvtVyvODG3uDQvXS85P3cTIzhitTR3MG5f9UHvECMTB+MhRgkOZiUR3ooLH+KFeFMSK6tS
        i/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYDp+rChxU5rf+8YrE1Zv
        OPq1auO5+x1/fY85LElo2Fm6STOnsHlhaOkp+7k5bl96hK5f2rlK7373stWfeJ0nXf0uLns+
        u9smanvCHPll/it2x4nf2LKjebKa5YXZJ0raeY8nVGS7dX6oWNay3eEDS7K/Tdj1rLmtmk0v
        /Jv2MfROvBpht01VpertK52jV6O9njR/V656uvNqUUd41Aqlin+MW+duWPyK43u2+Y6J/n/5
        OBiyWK2br+RvVDR+4bl70d+DCi6JJ/5svn+WTyHDlf/6df01gTfXv+pedMmFK5PBzYJ/wZV7
        UzW3LKjI1zZwORO7M9v6yRWfL8v3SMle1AupnLTTdfNpCSHf+oilHUZKLMUZiYZazEXFiQCj
        gKFmRwMAAA==
X-CMS-MailID: 20210104104237epcas5p1ed2d167f50060eb0567ade5d9a1df701
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210104104237epcas5p1ed2d167f50060eb0567ade5d9a1df701
References: <CGME20210104104237epcas5p1ed2d167f50060eb0567ade5d9a1df701@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset tries to add support for TP4065a ("Simple Copy Command"),
v2020.05.04 ("Ratified")

The Specification can be found in following link.
https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip

Simple copy command is a copy offloading operation and is  used to copy
multiple contiguous ranges (source_ranges) of LBA's to a single destination
LBA within the device reducing traffic between host and device.

This implementation doesn't add native copy offload support for stacked
devices rather copy offload is done through emulation. Possible use
cases are F2FS gc and BTRFS relocation/balance.

*blkdev_issue_copy* takes source bdev, no of sources, array of source
ranges(values are in bytes), destination bdev and destination offset(in bytes).
If both source and destination block devices are same and copy_offload = 1,
then copy is done through native copy offloading. Copy emulation is used
in other cases.

As SCSI XCOPY can take two different block devices and no of source range is
equal to 1, this interface can be extended in future to support SCSI XCOPY.

For devices supporting native simple copy, attach the control information
as payload to the bio and submit to the device. For devices without native
copy support, copy emulation is done by reading each source range into memory
and writing it to the destination.

Following limits are added to queue limits and are exposed in sysfs
to userspace
	- *copy_offload* controls copy_offload. set 0 to disable copy
		offload, 1 to enable native copy offloading support.
	- *max_copy_sectors* limits the sum of all source_range length
	- *max_copy_nr_ranges* limits the number of source ranges
	- *max_copy_range_sectors* limit the maximum number of sectors
		that can constitute a single source range.

	max_copy_sectors = 0 indicates the device doesn't support copy
offloading.

	*copy offload* sysfs entry is configurable and can be used toggle
between emulation and native support depending upon the usecase.

Changes from v3

1. gfp_flag fixes.
2. Export bio_map_kern() and use it to allocate and add pages to bio.
3. Move copy offload, reading to buf, writing from buf to separate functions.
4. Send read bio of copy offload by chaining them and submit asynchronously.
5. Add gendisk->part0 and part->bd_start_sect changes to blk_check_copy().
6. Move single source range limit check to blk_check_copy()
7. Rename __blkdev_issue_copy() to blkdev_issue_copy and remove old helper.
8. Change blkdev_issue_copy() interface generic to accepts destination bdev
	to support XCOPY as well.
9. Add invalidate_kernel_vmap_range() after reading data for vmalloc'ed memory.
10. Fix buf allocoation logic to allocate buffer for the total size of copy.
11. Reword patch commit description.

Changes from v2

1. Add emulation support for devices not supporting copy.
2. Add *copy_offload* sysfs entry to enable and disable copy_offload
	in devices supporting simple copy.
3. Remove simple copy support for stacked devices.

Changes from v1:

1. Fix memory leak in __blkdev_issue_copy
2. Unmark blk_check_copy inline
3. Fix line break in blk_check_copy_eod
4. Remove p checks and made code more readable
5. Don't use bio_set_op_attrs and remove op and set
   bi_opf directly
6. Use struct_size to calculate total_size
7. Fix partition remap of copy destination
8. Remove mcl,mssrl,msrc from nvme_ns
9. Initialize copy queue limits to 0 in nvme_config_copy
10. Remove return in QUEUE_FLAG_COPY check
11. Remove unused OCFS

SelvaKumar S (3):
  block: export bio_map_kern()
  block: add simple copy support
  nvme: add simple copy support

 block/blk-core.c          |  94 ++++++++++++++--
 block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
 block/blk-map.c           |   3 +-
 block/blk-merge.c         |   2 +
 block/blk-settings.c      |  10 ++
 block/blk-sysfs.c         |  50 +++++++++
 block/blk-zoned.c         |   1 +
 block/bounce.c            |   1 +
 block/ioctl.c             |  43 ++++++++
 drivers/nvme/host/core.c  |  87 +++++++++++++++
 include/linux/bio.h       |   1 +
 include/linux/blk_types.h |  15 +++
 include/linux/blkdev.h    |  15 +++
 include/linux/nvme.h      |  43 +++++++-
 include/uapi/linux/fs.h   |  13 +++
 15 files changed, 589 insertions(+), 12 deletions(-)

-- 
2.25.1

