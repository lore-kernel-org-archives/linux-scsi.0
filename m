Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA2DC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 05:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC31F22319
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 05:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qS3B0AJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKSFC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 00:02:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKSFC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 00:02:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4xXLV114720;
        Tue, 19 Nov 2019 05:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=jB+O4a3NgE5WXNZD9Yw7crEu3nh5H9RCPaLEcqLm15U=;
 b=qS3B0AJTqCea0pBhcI0GE5N+UTZk6KXwmuJvOYSCAl4YEV3gWwXj47nDR6n/7ufvZJuV
 ag3Y2VCznnoTL19zSSeL8tG9v7cqQfMcYBXqf9bOD9f7ZM49ixiqXLXJu1+s7/2M9ezZ
 /KPY1jESf43Xf00azyXK9UhPoLdNcjSYjNnH7MS9uoYWLZPCCWKBHFa0vQN1kzYbqZwd
 SVZ790MCCzHOy7984RrOHKJEOk2QscA5Bq+aXkbSmtq5Nn6eu71f1GfUxGE51DSDa5KU
 q7Nef6lJsgNLjvOsmQTNYVRTHxprEn+eRxuqkPmFOszWawsqGGj0hUh2jMt1yL9dPy/f rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htmgkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:02:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4xT6U159214;
        Tue, 19 Nov 2019 05:02:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wbxm3mxd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 05:02:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJ52N2g013505;
        Tue, 19 Nov 2019 05:02:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 21:02:23 -0800
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     "\<James.Bottomley\@hansenpartnership.com\>" 
        <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6/8] qla2xxx: Fix memory leak when sending I/O fails
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105150657.8092-1-hmadhani@marvell.com>
        <20191105150657.8092-7-hmadhani@marvell.com>
        <4BDE2B95-835F-43BE-A32C-2629D7E03E0A@marvell.com>
Date:   Tue, 19 Nov 2019 00:02:21 -0500
In-Reply-To: <4BDE2B95-835F-43BE-A32C-2629D7E03E0A@marvell.com> (Himanshu
        Madhani's message of "Mon, 18 Nov 2019 20:25:29 +0000")
Message-ID: <yq1o8x8ihlu.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=593
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=680 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190045
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> We found this patch to have introduced regression of double
> free. Please revert this patch in 5.5/scsi-queue and not needed with
> the patch 5 included in the series.

Reverted in 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
