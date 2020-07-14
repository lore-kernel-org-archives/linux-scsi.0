Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D75C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D4762193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsfWo4XA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgGNE7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNE7C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4wjnN100227;
        Tue, 14 Jul 2020 04:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/IZ1YNfpxlLHPkt4HIZERPrzGr+mYFv0E0nW5zjjxg8=;
 b=HsfWo4XA5gsjakLpL5myGZsSFxsKxHXHNNP1diOyouEyRm/daI5S6bYlz515Uy2vBYSL
 ISDyhNs0DgzJ4JeFahZBG4+KNnu0lXE+HxMtcY+1SvEMOsKxi76pM381Y6DEnDxUbbkR
 7DfRRc3ZOYaAams3IBFI7/jVq2YaFhOlPF0Zypw8qeKXxIhbMwB2oFOoA+eJbQmXTyFc
 achtSxRBC1X4IYrelcHQ/2WtUk0bUzBO0nLZUOfWBKFtrpZ6qZQwbyly+hD4NDJ4H/Qy
 MZhSSWDttxooal7BSVFXUucVzJWFg2OhlIkm9gvsLrc+JnfzsYiiVuSzzK0zY27R69+1 SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur2ypx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:58:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4vXZ0174075;
        Tue, 14 Jul 2020 04:58:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb2nuf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:50 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E4wmk2025040;
        Tue, 14 Jul 2020 04:58:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:48 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org,
        Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: cxgb4i: fix dereference of pointer tdata before it is null checked
Date:   Tue, 14 Jul 2020 00:58:39 -0400
Message-Id: <159470266467.11195.3151931908467404359.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709135217.1408105-1-colin.king@canonical.com>
References: <20200709135217.1408105-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=938 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=953 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jul 2020 14:52:17 +0100, Colin King wrote:

> Currently pointer tdata is being dereferenced on the initialization of
> pointer skb before tdata is null checked. This could lead to a potential
> null pointer dereference.  Fix this by dereferencing tdata after tdata
> has been null pointer sanity checked.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: cxgb4i: Fix dereference of pointer tdata before it is null checked
      https://git.kernel.org/mkp/scsi/c/b92a4a9f7be8

-- 
Martin K. Petersen	Oracle Linux Engineering
