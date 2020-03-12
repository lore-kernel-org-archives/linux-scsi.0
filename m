Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B164C2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65FBD20755
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I0Qxefjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgCLDJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:09:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 23:09:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C2xLbA175706;
        Thu, 12 Mar 2020 03:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4/jFFmq3O/qVJV0fZ9n85WMs1u0qzrBLdxiFRQDhmLo=;
 b=I0QxefjhjLDDXSBnHWhPt9MwQkSvK+5rtKbC+f7lfy/F3Sl1ZODkXnmC/NOjR7LwAMOm
 u6KjxW9RCEgAK+jDuodE6OUUDYIYaWK3cL6GD9ZC8p952lgb9S10YvU+UjdoifNoFjoj
 L+9Cj+5t2+FqPHumydqjJ40iDbt2ozRKMqP7qRLjXAjyzETG17axpC9DGWwuqSN2ibxE
 RqXGyu+luwW/RMktPptnI32gPMjoJd6748SpZlHstxF0lCf5mlTjn5iAx4bWAO6dLKKm
 Z4fNy+vFml2O6CrJcYsiDHZu5JmnJ0/ba2XFqqH9qwLImZfJQHWqmoLIRaR9ANSv3wry jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yp7hmbf8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:08:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C38hQn097206;
        Thu, 12 Mar 2020 03:08:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ypv9wugmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:08:42 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C38bOC022054;
        Thu, 12 Mar 2020 03:08:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:08:37 -0700
To:     huobean@gmail.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200311112921.29031-1-beanhuo@micron.com>
        <20200311112921.29031-2-beanhuo@micron.com>
Date:   Wed, 11 Mar 2020 23:08:34 -0400
In-Reply-To: <20200311112921.29031-2-beanhuo@micron.com> (huobean@gmail.com's
        message of "Wed, 11 Mar 2020 12:29:21 +0100")
Message-ID: <yq11rpyb77x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> This patch is to revert commit 2bb1156f9f1b36b1f594b89fa5412fd4178b28c6.

I dropped Bart's patch. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
