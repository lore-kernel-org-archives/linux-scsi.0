Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C91C35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 22:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EA620796
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 22:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l9B5brpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgJBWlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:41:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60278 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgJBWlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 18:41:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092MdvKu070266;
        Fri, 2 Oct 2020 22:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Q4bKodpaOILL4ATFX/AB2Mj1wx/yrk+xtT2l9Dw6hFU=;
 b=l9B5brpjEuEkeNVBoe0TMRsszW4YT2qe2zOeKXTMdUkykJ+x6b3mfT/rK2Csvb0ExGXC
 jdLY7icNlEHXyXo9jq4BYbmZSmS82d8XyqvN8A470MnLnHwqvR2aQpp95T0RAen0VyKC
 67DR8lqOGNuns/OBw5GV1QevRlvB94UiJJg+kd9rAtwxoYxYPpwKnHWZhPY6GyIsCdWq
 tkyVhciVH6buzDCofVlt1F0sgEuCxMl3B36o6kqWgzlwd4QZFl7SQ0DOqqyKc5qgV1/B
 o0k/GaUyO9ySM3IR0LUHuv0YffJeYajLsZMAGiZEdb+8fCnv/Rz+XXGm+STyhyQXsyrb 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33wupg45c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 22:41:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092MebcQ141892;
        Fri, 2 Oct 2020 22:41:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfj3nqb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 22:41:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092Mf9wt013589;
        Fri, 2 Oct 2020 22:41:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 15:41:09 -0700
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Add CONTROL field for trace events
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rigfdza.fsf@ca-mkp.ca.oracle.com>
References: <20200929125957.83069-1-r.bolshakov@yadro.com>
Date:   Fri, 02 Oct 2020 18:41:06 -0400
In-Reply-To: <20200929125957.83069-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Tue, 29 Sep 2020 15:59:57 +0300")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020172
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Roman,

> trace-cmd report doesn't show events from target subsystem because
> scsi_command_size() leaks through event format string:

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
