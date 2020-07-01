Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD19BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A00242082F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iV/yw+Gk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGATsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 15:48:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGATsA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 15:48:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JcUce132879;
        Wed, 1 Jul 2020 19:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=PVG5KSKo1V8Qn2rizeew4jQ3Duw0SRlP8b4omgRIUw0=;
 b=iV/yw+GkRMBF/U5TVYf9YM9TkBAKzlO5C/ioyDcmPKvkOr572KqdU83gsPfbF/6bIWax
 NT94v3ybDwjCqcrNQ2hkVBCyA7eMwPiU84Zl8G14IwJq3rQg4qA7KxuCyA/LUukfirfG
 N635o+ZwPaoYY0mxQyn54/NoBmW0uymfu14LelrvXJX1V4JjdPJ2v7uPlwujzP7+qRS3
 pbBzdVrdsYq9PE9L0hnDn4tL1LiCOfd4jAb/3142pi0Ux4eW1d8l45miBIDmn67D5Vtv
 UH417HgdaGpZhmcBj6dYqob+PJ2D2/SDEz0scURJ29afefe66WN6MrW7tOXx2kDG78Yt hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrncjv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 19:47:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061Jckni067799;
        Wed, 1 Jul 2020 19:47:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31y52kqbg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 19:47:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061JloT7010334;
        Wed, 1 Jul 2020 19:47:51 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 19:47:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 0/3] misc iscsi changes for 5.9
Date:   Wed,  1 Jul 2020 14:47:45 -0500
Message-Id: <1593632868-6808-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010137
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.9 queue branch and
Bob's wq patches in this thread:

https://lore.kernel.org/linux-scsi/8e09f77c-ac01-358b-0451-d4107ef5cd34@oracle.com/T/#t

They are just some cleanups and fixups and one fix for an
issue that was found while reviewing the code (there are no
offload and async sesison removal users).

