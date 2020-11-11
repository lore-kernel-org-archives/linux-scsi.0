Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408C5C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B3B20809
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hMBaoRVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgKKC6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgKKC6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2s7CB089150;
        Wed, 11 Nov 2020 02:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Lx9VPHpbsC4D9EQxsTczY/lx3S31VkVJDzB5u2kRgyY=;
 b=hMBaoRVSLgyd7HYb38IclMm2nKiecPU7Q3JrUTIWO8Ea4YB9M6IxEceI69hbBzhz9J3E
 ijJ1TvI3bvOoJRld7qhe9tlawLJyJEb9bIVWetLdViEg1/0i6Z+i8UQ5zyUfUD4e7fwa
 a5YlZwBprwVKVJRS51BJACDNroE/S/hudQ5xW4/jo9lXUfEZ1DBbPIwq2y1+19jZ3O/2
 pWVPs0QzkUdFgIQ9DDYbAe9XwOot5nJh4dFIOwGvrTpKP5o/RjTjn1EZ56EXckhaxwRY
 y0EWaqk4N91QkbfYaO9Q+gXjCHE6V7sC7vRHtR3QZ4nfdEwkLhqO38RBN9ud1Kau2+oL +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3ay5a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2t5eW184422;
        Wed, 11 Nov 2020 02:58:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp7ppvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:35 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2wW8d017724;
        Wed, 11 Nov 2020 02:58:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:32 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, himanshu.madhani@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/8] target: fix lun ref count handling
Date:   Tue, 10 Nov 2020 21:58:23 -0500
Message-Id: <160506295513.14063.6141786437368137956.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com> <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=805
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=822 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 1 Nov 2020 12:59:27 -0600, Mike Christie wrote:

> This fixes 2 bugs in the lun refcounting.
> 
> 1. For the TCM_WRITE_PROTECTED case we were returning an error after
> taking a ref to the lun, but never dropping it (caller just send
> status and drops cmd ref).
> 
> 2. We still need to do a percpu_ref_tryget_live for the virt lun0 like
> we do for other luns, because the tpg code does the refcount/wait
> process like it does with other luns.

Applied to 5.11/scsi-queue, thanks!

[1/8] scsi: target: Fix LUN ref count handling
      https://git.kernel.org/mkp/scsi/c/a2b5d6f975a4
[2/8] scsi: target: Fix cmd_count ref leak
      https://git.kernel.org/mkp/scsi/c/02dd4914b0bc
[3/8] scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
      https://git.kernel.org/mkp/scsi/c/8f394da36a36
[4/8] scsi: target: Remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
      https://git.kernel.org/mkp/scsi/c/27b0efd15d52
[5/8] scsi: qla2xxx: Move sess cmd list/lock to driver
      https://git.kernel.org/mkp/scsi/c/605e74025f95
[6/8] scsi: target: Drop sess_cmd_lock from I/O path
      https://git.kernel.org/mkp/scsi/c/6f55b06f9b07
[7/8] scsi: target: Make state_list per CPU
      https://git.kernel.org/mkp/scsi/c/1526d9f10c61
[8/8] scsi: tcm_loop: Allow queues, can_queue and cmd_per_lun to be settable
      https://git.kernel.org/mkp/scsi/c/94a0dfcf7d33

-- 
Martin K. Petersen	Oracle Linux Engineering
