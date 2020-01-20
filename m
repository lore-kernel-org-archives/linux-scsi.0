Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57778C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 23:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2874322522
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 23:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bgid2RQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgATXip (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 18:38:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgATXip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 18:38:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KNceHq064551;
        Mon, 20 Jan 2020 23:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SVJN3fEqmwpyRkm+dKBJ0PyEYMdf2lHqnmEdtL8pKeY=;
 b=bgid2RQT2al7Ad7Ns5NOvbQ4uM3N7QZEDBynyn2rchqqfClaxfRd5qVrhEBpCHjYzzZi
 4+dxZxZKx6NJwiE0JM8wMSqzeH8ASlNenpmx0bq/T+q9WCyipQOvSLUp+ukpAPMC+pDK
 8mE5zsYdOjRfqV3VcXI7bV2EUNuIo5upRZl0SXeo4sAgiyu14y/HzHJMrt327RkCqQF8
 7AIT92K8PizSj6tdDatenSLzR4+VesOPqXfy/pjh/TVpZ3tJM31mhd/P6H6/ncUwPpMc
 MFIN+IqizwkkHLK5/4pz9VfYTApTX94/6f/ZdYRQw9kVgxx7heA02aDGaMBATw/H71HE 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksyq1rb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 23:38:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KNXZh4105362;
        Mon, 20 Jan 2020 23:36:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xmc5mdek4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 23:36:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00KNabQv017101;
        Mon, 20 Jan 2020 23:36:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 15:36:37 -0800
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280: Make checking for 64bit support consistent
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200117115628.13219-1-tbogendoerfer@suse.de>
Date:   Mon, 20 Jan 2020 18:36:35 -0500
In-Reply-To: <20200117115628.13219-1-tbogendoerfer@suse.de> (Thomas
        Bogendoerfer's message of "Fri, 17 Jan 2020 12:56:27 +0100")
Message-ID: <yq1o8uxk8e4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200200
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> Use #ifdef QLA_64BIT_PTR to check if 64bit support is enabled.  This
> fixes ("scsi: qla1280: Fix dma firmware download, if dma address is
> 64bit").

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
