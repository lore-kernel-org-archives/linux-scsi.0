Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC255C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2F12075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XdjfX0GC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgETCa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:30:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgETCa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:30:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2RYmN123062;
        Wed, 20 May 2020 02:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=1jTlin6SCHnD/yu40tKWfjWm1Yq1l5j9i2OZEVjk4xY=;
 b=XdjfX0GCt3dPzc31PdPZz140aoBJDpQDk0A0car2WgwdV7Bxtx5NiXXD0FZyKNZ03+xm
 cNEk+Yk1aZlMr8tMjUZrKPY1MbMBXTLX+4TyXEhoLtvvDycYej1VjZzYkkjuxaa6DMRX
 rxrcl1LoJazBuugDk5FzD8GHikWHqZHzo97HZ5fE1aqrqU3ZPKJeqmLeaZe8zU9xRnVL
 t6edeSuDDqU9nKxvxyjI/0q2AUF26r9pyuicDfqiMTmtJs+eiFlaQRoapDpGgo7S+aCM
 TGMR2axqm/VvUSzw0iDbP6qXqeDCav+eYjCU+2HxPalKnm5lvg591qG/D/SZXzr6h7Th cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tnghwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2T3Hn052167;
        Wed, 20 May 2020 02:30:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t3629tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2UHkR027990;
        Wed, 20 May 2020 02:30:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:17 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        damien.lemoal@wdc.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi_debug: parser tables and code interaction
Date:   Tue, 19 May 2020 22:30:05 -0400
Message-Id: <158994171818.20861.6295933861231587786.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513013943.25285-1-dgilbert@interlog.com>
References: <20200513013943.25285-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 May 2020 21:39:43 -0400, Douglas Gilbert wrote:

> This patch is in response to a static analyser report from Dan Carpenter
> titled: "[bug report] scsi: scsi_debug: Add per_host_store option".
> This code may not clear the static analyzer reports, but may shed light
> on why they occur. Amongst other things this driver has a table driven
> SCSI command parser which also involves some C code. There are some
> invariants between the table entries and the corresponding C code (i.e.
> the resp_*() functions) that, if broken, may lead to a NULL dereference.
> And the report is valid, at least in the case of the PRE-FETCH command.
> Alas, that is not one of the cases that the static analyzer reported.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Parser tables and code interaction
      https://git.kernel.org/mkp/scsi/c/b6ff8ca73350

-- 
Martin K. Petersen	Oracle Linux Engineering
