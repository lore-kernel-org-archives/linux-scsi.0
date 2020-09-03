Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F19C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD6B207D3
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 02:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aU9IX0kS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgICCOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 22:14:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41444 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgICCOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 22:14:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832Dsvs104107;
        Thu, 3 Sep 2020 02:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=iRSItWPs+wa/lzIDrc+aTG06APBAan4JpcguU6mCPKo=;
 b=aU9IX0kSJQJY4LANRxzP2bJwoGHcIbjaEh22bpyeCLwwXl8fSfhaO5d6a9Ge55t/Tj4h
 NH7AEdNtKliydlMsz9G3FR8z/FlI0pAjqBCyeVBlB+r4mlPVoVBIcMS+AzBga8XPzdCm
 Sqypm6X4v1Ctx+YeHhoUg0HTV7M2FWVz+0tyTZXkp2ByuPdY2OsInz6orAG06BMmJClq
 vzPfyN9AWM0zmXY0of2r1xcAAucVy2RRk1DMkyRoOgupc7LWXNI7pIub0t7a5Rf7GZho
 Y0A4dpRWvTSg6OIGmpFoRli6T+HG34ALvFryWE/Y4qtKd7IZdY6gP6RFahmzVQIg6uH6 YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 339dmn4grf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 02:13:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832B4AZ160620;
        Thu, 3 Sep 2020 02:11:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380sv3uwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 02:11:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0832BtG5020139;
        Thu, 3 Sep 2020 02:11:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 19:11:54 -0700
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v2] scsi: ibmvfc: interface updates for future FPIN and
 MQ support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2lrd2ys.fsf@ca-mkp.ca.oracle.com>
References: <20200901002420.648532-1-tyreld@linux.ibm.com>
Date:   Wed, 02 Sep 2020 22:11:52 -0400
In-Reply-To: <20200901002420.648532-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Mon, 31 Aug 2020 19:24:20 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> 	Fixup complier errors from neglected commit --amend

Bunch of formatting-related checkpatch warnings. Please fix.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
