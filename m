Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96972C00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 344242078E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B4ln0aRW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgKED6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 22:58:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgKED6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 22:58:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A53twhK196469;
        Thu, 5 Nov 2020 03:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=sqU6t1oHaTzIOZLFsXPXg06HqdSMMXxcDvzKuWvTVKg=;
 b=B4ln0aRWLFQD0q55K7QK7CYB9Jov0O/JADw6pEgBLVWQFcDSEQAbujTD+/SzcPskKKPY
 QMf0/g8IASWII3MlXqRmaI/4zQy0LzLhLdxu8UkkEDlg4pg4hvOtChCI660mPMyA+vGk
 p27KSDH6Y9HcfD//x/Et9rj6zVtIpKqxdgJcHKAQucZMA9zLw/4ljhK8MN2z5i4BvaE9
 fZtgvHTOE//WH7RE9ZPQnYTZXqIonqSnyc1gp2Ta6wvfaaWid6ajY/V4d8SmlUqxzgBf
 oJeaO6gBbtHEPmEsbPb+sKmKfEQJzkU2rkk29IcX0P4XTU27uE3KWg4Sf0iP4XVAzckI yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34hhw2swja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 03:58:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A53tmsx158690;
        Thu, 5 Nov 2020 03:56:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34hvryvstb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 03:56:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A53uBOB023502;
        Thu, 5 Nov 2020 03:56:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 19:56:11 -0800
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH V3 0/4] pm80xx updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8kcsbhs.fsf@ca-mkp.ca.oracle.com>
References: <20201102165528.26510-1-Viswas.G@microchip.com.com>
Date:   Wed, 04 Nov 2020 22:56:08 -0500
In-Reply-To: <20201102165528.26510-1-Viswas.G@microchip.com.com> (Viswas G.'s
        message of "Mon, 2 Nov 2020 22:25:24 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=704 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=1 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=734 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> This patch set include some bug fixes for pm80xx driver.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
