Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5F9C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F67B215A4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CsM9qmuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgCKCxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 22:53:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgCKCxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 22:53:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2qiLH173906;
        Wed, 11 Mar 2020 02:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=C6z4djNS02N9iMx5kLTriwW3pwQLUP5G3FucGBR4Htg=;
 b=CsM9qmuwsmbWsESu+3rqD8wil4bTWxRMgEDdc/t1UIhb7GcGHejqwtnbSZCuVG0tyuOX
 bEgl1q12c13szWWGgZNxg20WkWHblcTu69SV+cx3p3BGzQ1qKkkEtNpZODVAxBXiQLDS
 Ffbpdi73Scpf/zufQ5fMeVJGbD4bV9Q8Jckc8D3+pFzuPabSXoDDq9gVWDEXIgytoodc
 SZz+bFgZAgWAKZylcNaTfH9xOl7Qu6oc5i9OPrRGCKmMkS5H2YP9T1cpEx3C4AUSLJ6F
 WAf3AbQVd3cxVMqLK7XXMhvhsQXNQSSYzw8RklRQnZ+jOTvwap4f8RAqooUffbJ5947G GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31uh0en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:53:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2mijk017925;
        Wed, 11 Mar 2020 02:53:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yp8pvntw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:53:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B2rb9j023910;
        Wed, 11 Mar 2020 02:53:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 19:53:37 -0700
To:     Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        hmadhani@marvell.com, rjones@marvell.com
Subject: Re: [PATCH] qla2xxx: add ring buffer for tracing debug logs.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1581557368-32080-1-git-send-email-rajan.shanmugavelu@oracle.com>
Date:   Tue, 10 Mar 2020 22:53:35 -0400
In-Reply-To: <1581557368-32080-1-git-send-email-rajan.shanmugavelu@oracle.com>
        (Rajan Shanmugavelu's message of "Wed, 12 Feb 2020 17:29:28 -0800")
Message-ID: <yq1blp3r49c.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Rajan,

> Having this log in a ringbuffer helps to diagnose qla2xxx driver and
> firmware issues instead of having it run again with extended_logging
> enabled saving cycles and hard to reproduce problem.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
