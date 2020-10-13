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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19E7C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8201921D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D0qJvNJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgJMWpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgJMWpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZn1f072076;
        Tue, 13 Oct 2020 22:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hUz6mf1LVCjXk4ceK1MhMoAC9vXZnVF54stdDMc+h0o=;
 b=D0qJvNJuU3vRbrEMXvrKQdvDDKvTQ1jHaiI20UGCAoEF+9D+yloR4c6zVvwVYmP/lYm3
 ZNvCzerxrRvZ0UmcKusFvvvCKgz0Wbaa/hyauQiGthLo3csUmWGlGNTxsqKqAN3DIifp
 X4svM6GunRoWyMgudA6FIDi8vBJWkUNAbiAcw46zCzFVvr8xaBwZNgWGyg7un8jJr/gf
 cTtAMPf+lBAhZ4aoXSa67ZI5sLeEq+dUBujKHz4R4sA7Z8S3hAJnKyFmbTi/vNwRr1nU
 ABnulq2MbKBntqLXq06XREIhi1X76lFN2ujQrMlTBQh2umfPsyilLegxSkKE8Jrt/7HV bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeb2hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:45:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZDhg155570;
        Tue, 13 Oct 2020 22:43:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 343puyjx2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhJon009975;
        Tue, 13 Oct 2020 22:43:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Liu Shixin <liushixin2@huawei.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] [SCSI] fnic: simplify the return expression of vnic_wq_copy_alloc
Date:   Tue, 13 Oct 2020 18:42:54 -0400
Message-Id: <160262862433.3018.6227146591502862587.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921082452.2592085-1-liushixin2@huawei.com>
References: <20200921082452.2592085-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Sep 2020 16:24:52 +0800, Liu Shixin wrote:

> Simplify the return expression.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: fnic: Simplify the return expression of vnic_wq_copy_alloc()
      https://git.kernel.org/mkp/scsi/c/39d0c6e770c2

-- 
Martin K. Petersen	Oracle Linux Engineering
