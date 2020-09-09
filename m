Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F41C2BC11
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C533420758
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ym9nIdkv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIICKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:10:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56106 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIICJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08929K34130861;
        Wed, 9 Sep 2020 02:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2MDz0iBE9wUMMSfTGt5gn+J4j4QRpCH7gFOJe15pJVs=;
 b=ym9nIdkvx5U25rc8S7SNmY3BRb381Ju2kBTZz0us60AVlICP8bglB7q8IwWdCEPaJ8IH
 iiZj/V/0GOx1VIvz+c4a3SBYKCH76nQ61FoISn4Ff0Zy8eZ3DPcH8Zksjxk9gs8XahqV
 ly3oZog0KJBzMDBmzIV+3+t+miK8lBiblkzyovqKHPp5vzD7/Amvq4ZK/uMWhsk03/Rb
 ftS2FREh8pQbE7sjBzumjh5nKGn3BKoQKa7ncZr2x1X2pGVzWMzBKO4mwDRuzhq79cXW
 flKWdtHt1X0I1NgwTCLTYgEV5cLVZWgrJwjJAta6ioy7CUcYii1niQ4Peg+NZPPojHY2 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23qy0ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08926Oac185531;
        Wed, 9 Sep 2020 02:09:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33cmkwwga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929ihm008064;
        Wed, 9 Sep 2020 02:09:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jason Yan <yanaijie@huawei.com>, artur.paszkiewicz@intel.com,
        intel-linux-scu@intel.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: isci: remove set but not used 'index'
Date:   Tue,  8 Sep 2020 22:09:22 -0400
Message-Id: <159961731706.5787.5995426868864919327.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827125851.428071-1-yanaijie@huawei.com>
References: <20200827125851.428071-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=959 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=973 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Aug 2020 20:58:51 +0800, Jason Yan wrote:

> This addresses the following gcc warning with "make W=1":
> 
> drivers/scsi/isci/host.c: In function ‘sci_controller_complete_io’:
> drivers/scsi/isci/host.c:2674:6: warning: variable ‘index’ set but not
> used [-Wunused-but-set-variable]
>  2674 |  u16 index;
>       |      ^~~~~

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: isci: Remove set but not used 'index'
      https://git.kernel.org/mkp/scsi/c/7149e0cb31c5

-- 
Martin K. Petersen	Oracle Linux Engineering
