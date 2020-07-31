Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943F0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 02:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9AF20829
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 02:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y6GrT3yG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgGaCPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 22:15:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbgGaCPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 22:15:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06V2C2JX032158;
        Fri, 31 Jul 2020 02:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=oEkkmZnNd5qB6ufvppE1H4HyGJ4f5J9QoWET7eVTCiY=;
 b=Y6GrT3yGYZe/2iP/AlZwA6cRx8Av0lq/FgcHNI1evfDYiy40AbjH6uX5/SRHMu5Qbbc3
 o7Nqjwff36OEavOA2bm3Gi5p4BxrgTiulFt1Z29jBJrWiW8CDo4N6NB8WTNqVmd4kUxA
 OCqim8QDcvY7E8Xjl8rpbqiaTqh5hJhzqW58z0y/48g5FtZ669DaP9gVejBC35G16i2l
 9SqAdW0yrVFVANrtxn5Fx0CWZpZ5W+NWp1THYZSOl6XUBTRL6+bIuOLGAOovlA65XwkC
 8zasxNovcZpIljEjlU9u97O0HyErI/L5ppzPhsBBniL8wGCErNnyGRA3A76/Yd3nPtAx 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32hu1jxrc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 02:15:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06V2DTXq094042;
        Fri, 31 Jul 2020 02:15:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32hu5xrr41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 02:15:00 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06V2ErPP020118;
        Fri, 31 Jul 2020 02:14:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 19:14:52 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_transport_srp: sanitize scsi_target_block/unblock sequences
Date:   Thu, 30 Jul 2020 22:14:51 -0400
Message-Id: <159616168007.12111.12215825242546147499.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728134833.42547-1-hare@suse.de>
References: <20200728134833.42547-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Jul 2020 15:48:33 +0200, Hannes Reinecke wrote:

> The SCSI midlayer does not allow state transitions from SDEV_BLOCK
> to SDEV_BLOCK, so calling scsi_target_block() from __rport_fast_io_fail()
> is wrong as the port is already blocked.
> Similarly we don't need to call scsi_target_unblock() afterwards as the
> function has already done this.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_transport_srp: Sanitize scsi_target_block/unblock sequences
      https://git.kernel.org/mkp/scsi/c/bf1a28f92a8b

-- 
Martin K. Petersen	Oracle Linux Engineering
