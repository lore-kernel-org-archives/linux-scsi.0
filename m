Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F7FC388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 02:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 481F42225E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 02:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x2FjnJ6W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKCCCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 21:02:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKCCCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 21:02:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A31wuLI025233;
        Tue, 3 Nov 2020 02:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cIMX/ky3aUv9Mygip6c32WMsIlDYK7dd5HjFrY+i14s=;
 b=x2FjnJ6W1u89xVZmNW23VMRBIqMZQuxoBS2FK/uxtMPfp3KRl9Dnh6wQaBZuh2MKvqvq
 bB8lF08JSAMP3VApNbkMDpui5FgB7WyOvU0iHrox28AjNnCuCgIRsK4zT+EBtiQtqGK8
 tyns+acpQLuWIfu8gQknevdPxbMkPQaktxyHDBzKTlvHI278N30a9Z8n+m2qxJBEq7Fr
 BFMUbTMc8/bfzyH+IHXlnmbQbztgrgJve9sD5SNzzpZwKJh8vb5x8ar6af9/25G7Ioqf
 7cr750NHtI4kZDAhh4LgWblTgKhgkOjp57dEZRb1S3vQGFKpxsZOOn9qULhQk6Vh2myh UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2ex2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 02:02:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A320k2o100274;
        Tue, 3 Nov 2020 02:02:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34jf47kjhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 02:02:01 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A321wZ7004357;
        Tue, 3 Nov 2020 02:01:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 18:01:58 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Brian Bunker <brian@purestorage.com>
Subject: Re: [PATCH] scsi_dh_alua: avoid crash during alua_bus_detach()
Date:   Mon,  2 Nov 2020 21:01:56 -0500
Message-Id: <160436888615.27492.12981270573337953625.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924104559.26753-1-hare@suse.de>
References: <20200924104559.26753-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=640 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=653 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Sep 2020 12:45:59 +0200, Hannes Reinecke wrote:

> alua_bus_detach() might be running concurrently with alua_rtpg_work(),
> so we might trip over h->sdev == NULL and call BUG_ON().
> The correct way of handling it would be to not set h->sdev to NULL
> in alua_bus_detach(), and call rcu_synchronize() before the final
> delete to ensure that all concurrent threads have left the critical
> section.
> Then we can get rid of the BUG_ON(), and replace it with a simple
> if condition.

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: scsi_dh_alua: Avoid crash during alua_bus_detach()
      https://git.kernel.org/mkp/scsi/c/5faf50e9e9fd

-- 
Martin K. Petersen	Oracle Linux Engineering
