Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3550C43457
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934E821D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pkup2Mgd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgJMWnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgJMWnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYZ2p023515;
        Tue, 13 Oct 2020 22:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=b8+BtDvdnvqRGyviSgmSRydVjoh1Tbhgum73s6i2O4w=;
 b=Pkup2MgdBgYdCnXqmsz62KHr+rDNs9izL61DuP2BZq1zUMfK9emXI7iGYY5x32MPJQYW
 hG/N4gmMmgvelE4dYKIXzKNBTP0Y1DMXXKk6lFAnDHJ2gPz+jacknAShI6s7+03Z30z6
 O4GBb0KB/EYYqOp72AP6HnS07QgWchLlJ3zFBGqWyE7GBr6UDpWsAuJV2U2Zci7h2fed
 G9a7Az2RzMQ3VGxDih9RQn4YbOQVr2gMJbFsMchExZg9qTaEVcsotK1waqHj9VL0IIO/
 +t0JP7mGodm42XgbqhyBkz/qUm1clsbUchYtBuT6rf6gC+Fe3AUYl1yu9hY8mm+6bh3W Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkmr7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZWWa162453;
        Tue, 13 Oct 2020 22:43:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by2v0b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:11 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhAIN002550;
        Tue, 13 Oct 2020 22:43:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Do not consume srb greedily
Date:   Tue, 13 Oct 2020 18:42:47 -0400
Message-Id: <160262862432.3018.12930536900869421478.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929073802.18770-1-dwagner@suse.de>
References: <20200929073802.18770-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=965 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=982
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Sep 2020 09:38:02 +0200, Daniel Wagner wrote:

> qla2xx_process_get_sp_from_handle() will clear the slot which the
> current srb is stored. So this function has a side effect. Therefore,
> we can't use it in qla24xx_process_mbx_iocb_response() to check
> for consistency and later again in qla24xx_mbx_iocb_entry().
> 
> Let's move the consistency check directly into
> qla24xx_mbx_iocb_entry() and avoid the double call or any open coding
> of the qla2xx_process_get_sp_from_handle() functionality.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Do not consume srb greedily
      https://git.kernel.org/mkp/scsi/c/657ed8a8a61b

-- 
Martin K. Petersen	Oracle Linux Engineering
