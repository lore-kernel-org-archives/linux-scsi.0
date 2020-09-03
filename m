Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BE9C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70ED2080C
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zuase8o0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgICDB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:01:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICDBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:01:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832xTwl043665;
        Thu, 3 Sep 2020 03:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XXQ/yioSFk4noMmCCpzRTB9dvpbfi9CZwsXtpL2bwvU=;
 b=Zuase8o0VxwvI78R9ghqkhAlr/stkYDRe2oYOAWD7aBCo9nZB+mabOMcudxcBlLHlReF
 0XXyD4kM511/zxO5hOyq5drUYcRM3fefJuVUPzQ8YWXyyvJb2TfhyoV7UFVgUdwHOX7h
 DFhdqXmTyLfaEuBrmKY+PYqvVF8w+6qvakmInOhH9/c+6ciWl53E63WAfBvgmJyQZHnP
 Ph2fBZysPRz70vHwfxNszb337dBhYp9FSs64tKKYJvEwdI2F/RWBgTmlFDewJZKVwveX
 k8/YvKNZ1GbQkzL2jm4PGC7QAntGilwnEed1Nv1rpYJuHaJJpLwOTSrm5nNCBsSw4PbY PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eer67m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832t6OG060104;
        Thu, 3 Sep 2020 03:01:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380sv5y06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08331DoE002195;
        Thu, 3 Sep 2020 03:01:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
Date:   Wed,  2 Sep 2020 23:01:04 -0400
Message-Id: <159910202093.23499.1919922784942360263.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901145026.12174-1-thenzl@redhat.com>
References: <20200901145026.12174-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=604 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=623 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Sep 2020 16:50:26 +0200, Tomas Henzl wrote:

> disable_irq might sleep, replace it with disable_irq_nosync,
> for synchronisation is the 'irq_poll_scheduled' sufficient
> 
> Fixes: 320e77acb3 scsi: mpt3sas: Irq poll to avoid CPU hard lockups

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
      https://git.kernel.org/mkp/scsi/c/b614d55b970d

-- 
Martin K. Petersen	Oracle Linux Engineering
