Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C7EC47256
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 04:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946DE20721
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 04:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r3wgAe6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgEEElt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 00:41:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgEEElt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2020 00:41:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0454cl2d057457;
        Tue, 5 May 2020 04:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RF4R1BkyGrvJxfQoRItLYvlaInyyf87oiAxRkXh+GNs=;
 b=r3wgAe6k2Xn8aHC0/XpH4hA0mvEgvXAX0ZmNHm531QMFONXrV+1jVOX69WghFRqnYqpB
 noml56C4ZoQGuDiTvDP3eywTvqFdMZLKRdrVWXhIKeEna/2HZlYLeBHIiDhMK9fZj+HN
 kE7uktkFgbK0pBLAdx4n0BT71SAQngJzT/KGXCkOVs6dJTA97uxpg4RDnsP7GH6uACtw
 I86fOQxL5Bxo3sYJqWBOK5uDRUJidC4QPB2h0OBP2WSSv4wrrGTcGfncDHRyDSMBHUlZ
 opPM0S0j9WIaP9YgzF4vsb93x+eGIhPj8wzdCi5b/jTyCn2K4FkUHgFcCb7s1Mb4fzRU zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r2g61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 04:41:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0454fMXs158994;
        Tue, 5 May 2020 04:41:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjnd3wtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 04:41:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0454fdnn024523;
        Tue, 5 May 2020 04:41:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 21:41:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.de,
        jejb@linux.vnet.ibm.com, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v5 0/8] per_host_store+random parameters, compare
Date:   Tue,  5 May 2020 00:41:34 -0400
Message-Id: <158865259186.19638.17408497382348347352.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200421151424.32668-1-dgilbert@interlog.com>
References: <20200421151424.32668-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Apr 2020 11:14:16 -0400, Douglas Gilbert wrote:

> This patchset contains one large and several small improvements to the
> scsi_debug driver. The large one is the new per_host_store parameter.
> After it is set to 1, a following write to the add_host parameter will
> cause each newly created host to get its own store (e.g. its own
> ramdisk for user data). A host may contain 1 or more targets and each
> target may contain 1 or more Logical Units (LUs). So every LU within
> a host (by default there is only 1) will share the same store.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/8] scsi_debug: randomize command completion time
      https://git.kernel.org/mkp/scsi/c/0c4bc91d6649
[2/8] scsi_debug: add per_host_store option
      https://git.kernel.org/mkp/scsi/c/87c715dcde63
[3/8] scsi: scsi_debug: Implement VERIFY(10), add VERIFY(16)
      https://git.kernel.org/mkp/scsi/c/c3e2fe9222d4
[4/8] scsi: scsi_debug: Weaken rwlock around ramdisk access
      https://git.kernel.org/mkp/scsi/c/67da413f26af
[5/8] scsi: scsi_debug: Improve command duration calculation
      https://git.kernel.org/mkp/scsi/c/a2aede970a8e
[6/8] scsi: scsi_debug: Implement PRE-FETCH commands
      https://git.kernel.org/mkp/scsi/c/ed9f3e2513f9
[7/8] scsi: scsi_debug: Re-arrange parameters alphabetically
      https://git.kernel.org/mkp/scsi/c/5d8070767358
[8/8] scsi: scsi_debug: Bump to version 1.89
      https://git.kernel.org/mkp/scsi/c/48e3bf1631ea

-- 
Martin K. Petersen	Oracle Linux Engineering
