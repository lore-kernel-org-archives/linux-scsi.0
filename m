Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C7AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70DDE611CC
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhJUDqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231315AbhJUDpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1PdIu020879;
        Thu, 21 Oct 2021 03:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=0Eknst1Uwf8u6hbJVv5AkdXOEExJ4hsrCjeOk81PcgY=;
 b=OFaL+0+nixcQ56W3K64cdc0H0OWin5O6bzqcYPzRYK3lxtSFekInqJETBPX1nWLp2BzT
 xidQGti+1Fw/ROxPhebOb7yrpD5S25IV3x910RhVdGb3n5di28Wl3Tfbj7WONsvJP1uY
 vAzk2ZJCpcZNG9O6+RAlSMiM0ycTbzcD1UDl958IFtFcluddS0EddjyEfhYi+LeOfd6z
 Ahd2VS2Zy58OH1vrSvRlXHV6MoXBmn/DN8VRKE78FEYYk6xsTCa75UniUH4CPVs9Ub5X
 4VTj2sXF8BsUdP1nVls139PPVpAy5XMK9Keatw5IlJgXnRL13ZejVM4IyonK2pM0Af+8 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3eslu078070;
        Thu, 21 Oct 2021 03:43:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:10 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8G082116;
        Thu, 21 Oct 2021 03:43:10 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-16;
        Thu, 21 Oct 2021 03:43:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     MichelleJin <shjy180909@gmail.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.de,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next] scsi: fcoe: use netif_is_bond_master() instead of open code
Date:   Wed, 20 Oct 2021 23:42:47 -0400
Message-Id: <163478764103.7011.9200697521255166481.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211015142006.540773-1-shjy180909@gmail.com>
References: <20211015142006.540773-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Hbex_9Tjbs_EmjLWRv0-AlA4HOTs4a_F
X-Proofpoint-GUID: Hbex_9Tjbs_EmjLWRv0-AlA4HOTs4a_F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Oct 2021 14:20:06 +0000, MichelleJin wrote:

> 'netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER'
> is defined as netif_is_bond_master() in netdevice.h.
> So, replace it with netif_is_bond_master() for cleaning code.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: fcoe: use netif_is_bond_master() instead of open code
      https://git.kernel.org/mkp/scsi/c/b3ef4a0e40df

-- 
Martin K. Petersen	Oracle Linux Engineering
