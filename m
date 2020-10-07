Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CC6C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3963620B1F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="of5DWxln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgJGDs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgJGDs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jV5a167245;
        Wed, 7 Oct 2020 03:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kyKFkLXbdAekvCLOdl/PsfM0CkigS++iap4xFCbLgaU=;
 b=of5DWxlnliKS2+lC1DatNaB4zuckc4bpcwJsaY79Fzp7ScfmK0amvHS4IpA3wJ93nkBz
 kUguXAl5Kj9/ParekfT0nImrDdIbV/G8iO4Yal+7SfqcBmTopkkwtcKZA1lw9k2l5vGu
 YYVbKxCNDnLifzNLQ3/gMZex7lrvV5QsoiKgYMB/xkOZMkbF4t0ATd3lNYFu9zKXos2A
 tnYsaJ1HfICYGBzokS45X4pGto5ciU7MQm3ngO811t52xqtk98WXktl1rnIznOP4GAoG
 3TIn+fd07wuMTFym23MfK1cLz96sDUbOtxZiVG3kH3YUxLRDdQyvQW+KbcrTA4RgV3Xd 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmydc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973k9Pa160218;
        Wed, 7 Oct 2020 03:48:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37xyvfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:13 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mA0w025056;
        Wed, 7 Oct 2020 03:48:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] fnic: to not call 'scsi_done()' for unhandled commands
Date:   Tue,  6 Oct 2020 23:47:49 -0400
Message-Id: <160204240575.16940.9033970836537317918.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200515112647.49260-1-hare@suse.de>
References: <20200515112647.49260-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 May 2020 13:26:47 +0200, Hannes Reinecke wrote:

> The fnic drivers assigns an ioreq structure to each command, and
> severs this assignment once scsi_done() has been called and the
> command has been completed.
> So when traversing commands to terminate outstanding I/O we should
> not call scsi_done() on commands which do not have a corresponding
> ioreq structure; these commands have either never entered the driver
> or have already been completed.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: fnic: Do not call 'scsi_done()' for unhandled commands
      https://git.kernel.org/mkp/scsi/c/712582e60f28

-- 
Martin K. Petersen	Oracle Linux Engineering
