Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5D8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D49206DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKB6N/qk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGCEDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:03:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgGCEDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:03:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06342KEI075884;
        Fri, 3 Jul 2020 04:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=xWCcry42ndbCYydQezGMJ4PEqJlhKTm9Q0ErqefcU1c=;
 b=MKB6N/qk+d/53RVBrSiCfbLlfGHAUQ3MOLEqb6G/Zy8kG7IzLhpKjWOtC9CnVSnuTyaA
 kq1LZl2ILi4pP3P3dI2UhecnOBl0P6f64Ssx1yxYJg8kRDrkcxNlQcGy9Cu8yePdJSIP
 OpTUH8s6TOCmqsOZAjuRO6wIE/wAhnVU99xFvz7ozyjjJQadv/Zynj2UkOEu2PQaAg35
 kCWK3tk6Hwa2h7OhZu1TC26Pq84txUmWgHiCr6o4qdFvnC8dfyBtK8x0iyPwRwHJ9v/B
 uerDOxVt7VZPkOP8pNzAMAjxRffAr+HOsz3aowkbIiUmPFbqkMsSYjYD2IE5vatL4K2w Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1e8hhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:03:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633wuWh161772;
        Fri, 3 Jul 2020 04:03:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg1b5kug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:03:02 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063431MN005457;
        Fri, 3 Jul 2020 04:03:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:03:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Date:   Fri,  3 Jul 2020 00:02:58 -0400
Message-Id: <159374890395.14616.10785231694620584225.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701085254.51740-1-damien.lemoal@wdc.com>
References: <20200701085254.51740-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Jul 2020 17:52:54 +0900, Damien Le Moal wrote:

> In BRM_status_show(), if the condition "!ioc->is_warpdrive" tested on
> entry to the function is true, a "goto out" is called. This results in
> unlocking ioc->pci_access_mutex without this mutex lock being taken.
> This generates the following splat:
> 
> [ 1148.539883] mpt3sas_cm2: BRM_status_show: BRM attribute is only for warpdrive
> [ 1148.547184]
> [ 1148.548708] =====================================
> [ 1148.553501] WARNING: bad unlock balance detected!
> [ 1148.558277] 5.8.0-rc3+ #827 Not tainted
> [ 1148.562183] -------------------------------------
> [ 1148.566959] cat/5008 is trying to release lock (&ioc->pci_access_mutex) at:
> [ 1148.574035] [<ffffffffc070b7a3>] BRM_status_show+0xd3/0x100 [mpt3sas]
> [ 1148.580574] but there are no more locks to release!
> [ 1148.585524]
> [ 1148.585524] other info that might help us debug this:
> [ 1148.599624] 3 locks held by cat/5008:
> [ 1148.607085]  #0: ffff92aea3e392c0 (&p->lock){+.+.}-{3:3}, at: seq_read+0x34/0x480
> [ 1148.618509]  #1: ffff922ef14c4888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x2a/0xb0
> [ 1148.630729]  #2: ffff92aedb5d7310 (kn->active#224){.+.+}-{0:0}, at: kernfs_seq_start+0x32/0xb0
> [ 1148.643347]
> [ 1148.643347] stack backtrace:
> [ 1148.655259] CPU: 73 PID: 5008 Comm: cat Not tainted 5.8.0-rc3+ #827
> [ 1148.665309] Hardware name: HGST H4060-S/S2600STB, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [ 1148.678394] Call Trace:
> [ 1148.684750]  dump_stack+0x78/0xa0
> [ 1148.691802]  lock_release.cold+0x45/0x4a
> [ 1148.699451]  __mutex_unlock_slowpath+0x35/0x270
> [ 1148.707675]  BRM_status_show+0xd3/0x100 [mpt3sas]
> [ 1148.716092]  dev_attr_show+0x19/0x40
> [ 1148.723664]  sysfs_kf_seq_show+0x87/0x100
> [ 1148.731193]  seq_read+0xbc/0x480
> [ 1148.737882]  vfs_read+0xa0/0x160
> [ 1148.744514]  ksys_read+0x58/0xd0
> [ 1148.751129]  do_syscall_64+0x4c/0xa0
> [ 1148.757941]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1148.766240] RIP: 0033:0x7f1230566542
> [ 1148.772957] Code: Bad RIP value.
> [ 1148.779206] RSP: 002b:00007ffeac1bcac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [ 1148.790063] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f1230566542
> [ 1148.800284] RDX: 0000000000020000 RSI: 00007f1223460000 RDI: 0000000000000003
> [ 1148.810474] RBP: 00007f1223460000 R08: 00007f122345f010 R09: 0000000000000000
> [ 1148.820641] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000000
> [ 1148.830728] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix unlock imbalance
      https://git.kernel.org/mkp/scsi/c/cb551b8dc079

-- 
Martin K. Petersen	Oracle Linux Engineering
