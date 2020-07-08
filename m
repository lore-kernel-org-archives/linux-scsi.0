Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42657C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A91620786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QaWsiM6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGHGJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:09:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgGHGJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:09:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866bqV045565;
        Wed, 8 Jul 2020 06:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7K3egptjeqfTLbKh288yd9y2uEkz0qSg2EeZKtTdmiY=;
 b=QaWsiM6u+FfQjbVInOOHJdc0Q+ky9o+VPzm+86JicyfGRrOkmilxX0M2CVEFB0Mpysdv
 BxAibOMS8+mUpl8+rn8OT09Jvh4Wv/gu1N69df8PxYTAjxlVBOOAmCbMBfJLlnP9xK6t
 SvfYZMPY61OcMbQ38gt0TVC59d7arJ31G2KddMJierKCkKmTe4nWUKHz2RgP0Zq6nMnA
 fV+uR9nnAKBjHnhArZuIn0XrIQvIV41as1i63Rsuy1mbYxzn+lMx79Y4LkWrFi8wNA9a
 rbVUBPHDAqsmByah4H2mt1MTRqcjL+Y9u9smSz8YhlyFHuak7Xh584UNs3uIYufjqgZr Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 322kv6g9wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:09:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685x91o145284;
        Wed, 8 Jul 2020 06:07:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 324n4se4kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0686730i016580;
        Wed, 8 Jul 2020 06:07:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:03 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix interrupt assignments when multiple vectors are supported on same cpu
Date:   Wed,  8 Jul 2020 02:06:49 -0400
Message-Id: <159418828150.5152.6880397435934077871.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706204230.130363-1-jsmart2021@gmail.com>
References: <20200706204230.130363-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 13:42:30 -0700, James Smart wrote:

> With certain platforms its possible pci_alloc_irq_vectors() may
> affinitize irq vectors to multiple (all?) cpus. The driver is currently
> assuming exclusivity and vectors being doled out to different cpus and
> is assigning primary ownership of each vector to the first cpu in the
> mask.  The code doesn't bother to check if the cpu already owns a vector
> and will unconditionally overwrite the cpu to vector mapping. This causes
> the relationships between eq's and cq's to get confused and gets worse
> when cpus start to offline. The net results are interrupts are skipped
> resulting in mailbox timeouts and there are oops's in cpu offling flows.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix interrupt assignments when multiple vectors are supported on same CPU
      https://git.kernel.org/mkp/scsi/c/17105d959b26

-- 
Martin K. Petersen	Oracle Linux Engineering
