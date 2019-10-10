Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EBFC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 260C1208C3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mgjrhdeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbfJJDhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:37:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732252AbfJJDhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 23:37:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3TT5B121490;
        Thu, 10 Oct 2019 03:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=QPgael3DIpp/EzyPXpnJ5F9DaD/nZMYWVOzsKWlWTIw=;
 b=mgjrhdeP8sEttxgJNHvqt44bAjGo3bewphk/c7vMQ1zcBYOMZ6NpVTAUMpMahJNH50dA
 t4hJ21hVGOj1GKJwa63TV2VTil/s3U42tsGtT1ZIJESdxyvSO+so09asuoTdh4Uj5Elu
 ERFBH76uxBkF3SbP4JaNs+00yWrBQRrfGPLVQbAGbVd7A6OFld2l563ZVUmNlhvZf616
 4C9fLBXjICxDT5Sukx1HBX3KQJYx3CDRksbCKYroyjZidmCkuiyvuUD0wcQnq6EMukAo
 DuQj7FbOQMx0skTWbskyjLxK3LKPbtXRoa1jRhaPkrFNEtrHgq199l1HHAt8D9CBqCvF MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vejkurdkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:37:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3STD5099801;
        Thu, 10 Oct 2019 03:37:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vh5cc5uwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:37:03 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A3b14m010196;
        Thu, 10 Oct 2019 03:37:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 20:37:01 -0700
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sni_53c710 fix compilation error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191009151118.32350-1-tbogendoerfer@suse.de>
Date:   Wed, 09 Oct 2019 23:36:59 -0400
In-Reply-To: <20191009151118.32350-1-tbogendoerfer@suse.de> (Thomas
        Bogendoerfer's message of "Wed, 9 Oct 2019 17:11:18 +0200")
Message-ID: <yq1lftti84k.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=819
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=896 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> Drop out memory dev_printk() with wring device pointer argument.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
