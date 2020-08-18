Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71364C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F3C206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B2TBbD40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHRDMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:12:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgHRDMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:12:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38sRA134983;
        Tue, 18 Aug 2020 03:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=IM/CtWMxGTFoI36YKZLgHVy2FtdZ2hRYUUsFrkOGI9c=;
 b=B2TBbD40pFMM6yaKjNRsheHyuiEgKMwKSOzxpPckpCw48qFlVqWdcp7ES4/IJCO1LJza
 7oSMdU3vSaf21I/cbJIYjyNCoQGEFSZmrorkaQ4GD0JgVjB3/ECq6/0ta2lzSSH2g7fd
 nozZqmCfN/dipx5tbOx5STcM/SzydekhE/WJguD3h7Wy7WnQqhViYUe9X5IdPR4t1MpY
 2hLdoIZxYxeY5nfWJTZGYKNNd4X+XhJRyz51GZ7hzql4n+CucdO2KFS5RxSkATVsEZCI
 w7a1nkLzUXL9T2HNtWUCTzJLYcXFH3I0knAOVuyQ3sQ9Pobnysn/kAq4pvt9a3Al1MQs 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r27df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:12:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38BtQ104690;
        Tue, 18 Aug 2020 03:12:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfraxnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:39 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I3CbZP021358;
        Tue, 18 Aug 2020 03:12:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:36 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        john.garry@huawei.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [PATCH] scsi_debug: fix scp is NULL errors
Date:   Mon, 17 Aug 2020 23:12:24 -0400
Message-Id: <159772029326.19587.10576074443140518302.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200813155738.109298-1-dgilbert@interlog.com>
References: <20200813155738.109298-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 Aug 2020 11:57:38 -0400, Douglas Gilbert wrote:

> John Garry reported 'sdebug_q_cmd_complete: scp is NULL' failures
> that were mainly seen on aarch64 machines (e.g. RPi 4 with four
> A72 CPUs). The problem was tracked down to a missing critical
> section on a "short circuit" path. Namely, the time to process
> the current command so far has already exceeded the requested
> command duration (i.e. the number of nanoseconds in the ndelay
> parameter).
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix scp is NULL errors
      https://git.kernel.org/mkp/scsi/c/223f91b48079

-- 
Martin K. Petersen	Oracle Linux Engineering
