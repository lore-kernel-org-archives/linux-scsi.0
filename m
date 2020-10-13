Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3210BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF3D21D40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sG/ru4WH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgJMWn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41812 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbgJMWnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaIiN072227;
        Tue, 13 Oct 2020 22:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=euMt7ddtAReM6hm3zp6EydmBcw+KEliXP2TYOjleSHs=;
 b=sG/ru4WH8eMFAmscomNUmwIUaNhv/Eu9rxLsh0lrw/oZKTvEU98vfQ7RC4ex5/5CYLrT
 dJEEFEnvG0sW0TZa43bYFDGXGQQ0FAZKu2v+ztsZXsaRpakk7LRSFhwzv8BZOSWJ+fzA
 8Hao9znPMA/K54eAB98lbuuLsgMFd+GHMAY91GHzLCziT+S6BvwxKmlmfGWbEd7WdqSG
 80C2wsLZLsSVJOo3rQN+HTZCrhBr+W0tIGF1BWojV8dXJBdxTTfyO0phx5ByJog1rnvv
 uqg6i9KvS3qPRQmAQ+2/boN3WZrAUOTRLq6xLTGVO4R2Hki1En20tgwYYBoPuE4NJ+Fi WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeb2cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZEY8155734;
        Tue, 13 Oct 2020 22:43:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 343puyjwyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhCil005707;
        Tue, 13 Oct 2020 22:43:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:11 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Qian Cai <cai@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] sr: initialize ->cmd_len
Date:   Tue, 13 Oct 2020 18:42:49 -0400
Message-Id: <160262862435.3018.2306353471771317298.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008200611.1818099-2-hch@lst.de>
References: <20201008200611.1818099-1-hch@lst.de> <20201008200611.1818099-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1011
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 8 Oct 2020 22:06:10 +0200, Christoph Hellwig wrote:

> Ensure the command length is properly set.  Previously the command code
> tried to find this out using the command opcode.

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: sr: Initialize ->cmd_len
      https://git.kernel.org/mkp/scsi/c/9120ac54cce6
[2/2] scsi: core: Set sc_data_direction to DMA_NONE for no-transfer commands
      https://git.kernel.org/mkp/scsi/c/b6ba9b0e201a

-- 
Martin K. Petersen	Oracle Linux Engineering
