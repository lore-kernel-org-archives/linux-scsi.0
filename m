Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CFAC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D0522B49
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kAunwwyc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgG3CYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 22:24:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgG3CYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 22:24:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06U2LxiM012523;
        Thu, 30 Jul 2020 02:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=eUTieb3q5B4ekvgmNe55qqLMuveEcKYOBUj6MInH6Vw=;
 b=kAunwwyc65LXH6hlG2O9SMNRLOtdwgBNfePRrU4VFlfElPxGfxbAPzkVXrNAezlAV9zm
 bi2+9Qbct/sbka9VLyoRcIn6j3nBDkCtGEdC6zbdeKJri+Gk7ExIR8/dP/U17JdV1Gtq
 AwdmEJr6Y+9e9UleRlD0U7lw2FM1ISHfUylON3keV5CCCRMtT+kKn7wuUq8Pe+0zrf3p
 2ZoyHj9XRM+plrD8piYQ6k4XQYluD2dC1fX4i1CBmdimZTn7gXA0dXR7OZg50w7FXEdt
 2U73B/4R0eVj3f9d5+vEZZDNfJVco0B+fTeY4E+hOvcPZhIq7y48xSthELu1cO3JXd9N zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1js2wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 02:24:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06U2MVrI108907;
        Thu, 30 Jul 2020 02:24:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32hu5ymfts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 02:24:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06U2O3F8001101;
        Thu, 30 Jul 2020 02:24:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 19:24:03 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "open list:VIRTIO BLOCK AND SCSI DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 0/1] virtio-scsi: fix missing unplug events when all LUNs are unplugged at the same time
Date:   Wed, 29 Jul 2020 22:24:01 -0400
Message-Id: <159607582923.27464.4409897545362766716.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729194806.4933-1-mlevitsk@redhat.com>
References: <20200729194806.4933-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 22:48:05 +0300, Maxim Levitsky wrote:

> virtio-scsi currently has limit of 8 outstanding notifications so when more that
> 8 LUNs are unplugged, some are missed.
> 
> Commit 5ff843721467 ("scsi: virtio_scsi: unplug LUNs when events missed")
> Fixed this by checking the 'event overflow' bit and manually scanned the bus
> to see which LUNs are still there.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: virtio-scsi: Correctly handle the case where all LUNs are unplugged
      https://git.kernel.org/mkp/scsi/c/b12149f2698c

-- 
Martin K. Petersen	Oracle Linux Engineering
