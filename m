Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E26C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 06:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE936528C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 06:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhCIGVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 01:21:53 -0500
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:43548 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCIGVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 01:21:34 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id E85CB400410;
        Tue,  9 Mar 2021 14:21:12 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     daejun7.park@samsung.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kaixian.yang@vivo.com, wangqing@vivo.com
Subject: [Resend]Re: [PATCH] [v26,1/4] scsi: ufs: Introduce HPB feature
Date:   Tue,  9 Mar 2021 14:21:02 +0800
Message-Id: <1615270866-32000-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20210303062800epcms2p1c14c69e74782f25aaaef808ae625d701@epcms2p1>
References: <20210303062800epcms2p1c14c69e74782f25aaaef808ae625d701@epcms2p1>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHh5DTx5ISElLQ0xNVkpNSk5JTEtDQ0pLT0tVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nhg6LBw*LT8RMQ5DIhUwNTYu
        PlEaCx1VSlVKTUpOSUxLQ0NKQ0NJVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFIS05CNwY+
X-HM-Tid: 0a7815a5a3ced991kuwse85cb400410
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>The Following is experiment environment:
> - kernel version: 4.4.0
> - RAM: 8GB
> - UFS 2.1 (64GB)
>
>Result:
>+-------+----------+----------+-------+
>| cycle | baseline | with HPB | diff  |
>+-------+----------+----------+-------+
>| 1     | 272.4    | 264.9    | -7.5  |
>| 2     | 250.4    | 248.2    | -2.2  |
>| 3     | 226.2    | 215.6    | -10.6 |
>| 4     | 230.6    | 214.8    | -15.8 |
>| 5     | 232.0    | 218.1    | -13.9 |
>| 6     | 231.9    | 212.6    | -19.3 |
>+-------+----------+----------+-------+
>
>We also measured HPB performance using iozone.
>Here is my iozone script:
>iozone -r 4k -+n -i2 -ecI -t 16 -l 16 -u 16
>-s $IO_RANGE/16 -F mnt/tmp_1 mnt/tmp_2 mnt/tmp_3 mnt/tmp_4 mnt/tmp_5
>mnt/tmp_6 mnt/tmp_7 mnt/tmp_8 mnt/tmp_9 mnt/tmp_10 mnt/tmp_11 mnt/tmp_12
>mnt/tmp_13 mnt/tmp_14 mnt/tmp_15 mnt/tmp_16
>
>Result:
>+----------+--------+---------+
>| IO range | HPB on | HPB off |
>+----------+--------+---------+
>|   1 GB   | 294.8  | 300.87  |
>|   4 GB   | 293.51 | 179.35  |
>|   8 GB   | 294.85 | 162.52  |
>|  16 GB   | 293.45 | 156.26  |
>|  32 GB   | 277.4  | 153.25  |
>+----------+--------+---------+

According to Samsung's iozone test result, HPB is going to boost random 
performance of rom on mobile, we believe it will help our customers on 
several occasions.

WangQing
