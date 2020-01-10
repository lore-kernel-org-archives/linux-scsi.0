Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4352C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5222082E
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HD1giw7n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbgAJGEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:04:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgAJGED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:04:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A63NNZ069230;
        Fri, 10 Jan 2020 06:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=f+r/wQUTbig1GvOyCilDUvV0UR3hqNhVmFBidr+fX+4=;
 b=HD1giw7nE3x5UHThzWVrxL5p6/AX85eFOG57fGN4pW1WwCBDq4vLA4ChyiwuPl04IO8F
 +LqMIkI0h2QSUi3fBXaNTObfMDYaUPGDB9JmyyO7wwlV+5hHK4JjZx2qNTMqVlF+rVOP
 W7VmBIfGbUUwoUG6dI0iESV+NJczf0H6AGPv7wbmSgnPdCcG3nWemCVKG+DN3G3v7bMt
 X6gR2R8ZQ1kYFu3mJsSm38ubG99EWjYBCvzwCdOx1IQZwj4VO6Erpx0TktgltkpzeB/q
 RohoiwkIh+5KWxmlTOv1XNhj0foQ9mqsLAj8V/8kQL1ym1R1wCAoQYZVnsNMdbUnX9tr Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr7sjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:04:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A63wkU055803;
        Fri, 10 Jan 2020 06:04:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xeh9005ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:04:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00A6391B014037;
        Fri, 10 Jan 2020 06:03:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:03:09 -0800
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: .PATCH.04/11.megaraid.sas.Don.t.kill.already.dead.adapter
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
        <1578051155-14716-5-git-send-email-anand.lodnoor@broadcom.com>
Date:   Fri, 10 Jan 2020 01:03:07 -0500
In-Reply-To: <1578051155-14716-5-git-send-email-anand.lodnoor@broadcom.com>
        (Anand Lodnoor's message of "Fri, 3 Jan 2020 17:02:28 +0530")
Message-ID: <yq1blrbx2zo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=729
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=809 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100051
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anand,

This patch got mangled in transit.

-- 
Martin K. Petersen	Oracle Linux Engineering
