Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6870C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 01:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2812068F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 01:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VzEcvnjp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfKVBvT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 20:51:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51558 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKVBvS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 20:51:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM1nApK130823;
        Fri, 22 Nov 2019 01:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Dg+vsQvDWna6f+xETOVidrZD7Dy01y8wCuUApAtOZh8=;
 b=VzEcvnjpbr6KYiSlhJlHVietiq+WD6JEBhj6kvbrqTnfU+jYIUYoQG8iBxpEaFpNAOio
 XqTYjRkE39ifI57bqU3cT/xHU2qJ4dGs8bd6RIQvwKUsw8gbm4ncUvW/Ni3bLhw2wniF
 v/zUTIiBgzXY8Qtr8HonCUxPQxyywLbP/VsKbLI2o61bKh6xFJF/LIZ1QWgWlbd0kyIV
 EEebGlzhTVQwZZ13SwDtDG+89YZokWhp/Xp6fNLmN5lTc+v26IITJzjQoAN5iTVo9XC7
 epSUbY+VITw9O9vUXawbQHdfUy1CLQ66rARyiEZ2haE9ekukPZbSnwQhacrNN6rYq3oL Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8hu7w1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 01:51:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAM1m0Dl071632;
        Fri, 22 Nov 2019 01:51:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wdfrwa1t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 01:51:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAM1pC6J019993;
        Fri, 22 Nov 2019 01:51:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 17:51:12 -0800
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: size cpu map by last cpu id set
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191121175556.18953-1-jsmart2021@gmail.com>
Date:   Thu, 21 Nov 2019 20:51:10 -0500
In-Reply-To: <20191121175556.18953-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 21 Nov 2019 09:55:56 -0800")
Message-ID: <yq17e3sd6gh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Currently the lpfc driver sizes its cpu_map array based on
> num_possible_cpus(). However, that can be a value that is less than
> the highest cpu id bit that is set. As such, if a thread runs on a cpu
> with a larger cpu id, or for_each_possible_cpu() is used, the driver
> could index off the end of the array and return garbage or GPF.

Applied to 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
