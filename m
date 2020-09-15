Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DE4C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE8B120809
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lombxXOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgIOVku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:40:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgIOVet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 17:34:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLUh5b146173;
        Tue, 15 Sep 2020 21:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bKefqrS9x6G26Q8J7sRki6R1Qm0M7hqQGhPAOWazeo4=;
 b=lombxXODv8NFYNEoRa8P6KmSdGNOeGbQ682XD5jwetrB2nIxSqxDeKAxB9+11gE8Dhzz
 36vgXES0uHVOTMG6q/o8mkLIN1yIeNcMchpunG0O6LIUUSd4FhlJrIL1DsSAxRgtYhkj
 GVYbxUtJUljhGfm9hJNGgo0brf5/1tdtfNttwdQl/LvSSMgNLvMl+j1xXO+iFsUEpHm8
 5cv8lpyIzKGClFmg/zPma4HMU7CYigSNj5IpaHSOuL3ZeKvjsCzz6XffRS4vzsDNzxJx
 MAympkIpATmmbyahlzjR5OS+ox6B0m8bs45lCr4IcarW3xi5Wvw7e6OvWhV8mAMgYngA QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dhb8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 21:34:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FLTpaV144963;
        Tue, 15 Sep 2020 21:32:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm31ah54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 21:32:41 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FLWcrO010604;
        Tue, 15 Sep 2020 21:32:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 21:32:38 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qla2xxx: remove unneeded variable 'rval'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn6m680m.fsf@ca-mkp.ca.oracle.com>
References: <20200911091021.2937708-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 17:32:35 -0400
In-Reply-To: <20200911091021.2937708-1-yanaijie@huawei.com> (Jason Yan's
        message of "Fri, 11 Sep 2020 17:10:21 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This addresses the following coccinelle warning:
>
> drivers/scsi/qla2xxx/qla_init.c:7112:5-9: Unneeded variable: "rval".
> Return "QLA_SUCCESS" on line 7115

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
