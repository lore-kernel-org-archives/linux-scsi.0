Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CACC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535342075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zN9jqOKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgE0CN1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgE0CNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2BafA091983;
        Wed, 27 May 2020 02:13:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ywNpRq8p/a0eAFuvS8RIzBSBN/m0XmNwMEZWHkMHwe8=;
 b=zN9jqOKaOBSIkqeqDklaSKJn44QBymLyF8wE0ZwHpaC6mLILN4drrlKUwqONQeuioIbe
 rzMML23INOe4KPzu4tUoM5IrLXYfcqv2fJTrt4Tz754oC0O917UE+xZrRD72OhMzCjuc
 Z/+DsLbujcBoxEvdfELUKrfIXhnfcZ7XoY4SRgguI+dHOTSWTCBo0bSd2uoz53B0SqQh
 W1oi26pb6pF8w9VpuU1YlPyArddrbpbe2SSp8s6iJIKvKrjMV01pbNc9QoyKUlHeDSJW
 80iCfaEXBOZU8EBXVOevTXDhhxQt0KindtI9dFSFLiI95fROsHkVehHycgEgLOIwCMxU hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 316u8qvxh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2Cocf060324;
        Wed, 27 May 2020 02:13:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 317dryjtv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2D62Z020377;
        Wed, 27 May 2020 02:13:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:05 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] qla2xxx: Remove an unused function
Date:   Tue, 26 May 2020 22:12:52 -0400
Message-Id: <159054550933.12032.15841456018822328014.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520040738.1017-1-bvanassche@acm.org>
References: <20200520040738.1017-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=903 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=938 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 May 2020 21:07:38 -0700, Bart Van Assche wrote:

> This was detected by building the qla2xxx driver with clang. See also
> commit a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support").

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove an unused function
      https://git.kernel.org/mkp/scsi/c/ce9a9321c118

-- 
Martin K. Petersen	Oracle Linux Engineering
