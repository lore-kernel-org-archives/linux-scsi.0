Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9152FC33CAA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E2624653
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5SDxcMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAUE4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 23:56:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgAUE4g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 23:56:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4rMVV065996;
        Tue, 21 Jan 2020 04:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=D3T06gwDNjBQHSf+WeTRUnSjC80olQKqYVFDvKvxLVs=;
 b=p5SDxcMW3zP4iXZmJVcBOWw8Gao/u94hBkLgwt7GCNLMXXdvMs0XELG2uDeiEmXqwroP
 wUJja5j5HFKZ8ANivcRVkxgcGkG4B3FoN2DsZY+bjZyGq3dSzh7WKpyGqaCGOva7m/Ki
 AF79OMjl2s/SbLIwHL+mtkKSpCDmOJdaySEpaO4SnHR0IMlmjqOnyb+y945vXMnJoe7Z
 0XwvF1jQe3CzbSrWFVjgSJzQEkMVwDhdcz5mN8MJRXRIhSbNyU7pc42cJR+o56EyOo7Y
 WSfpQD92iCz4dm+9b/tjRcg+JMTg565iMNtLwi0pODmXqO8kx8G9qvcWQPf30OLLAehC Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xksyq2f2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:56:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4rMFT044784;
        Tue, 21 Jan 2020 04:56:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xnpfn97qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:56:28 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00L4uQ2f006166;
        Tue, 21 Jan 2020 04:56:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 20:56:26 -0800
To:     hare@suse.de
Cc:     Igor Druzhinin <igor.druzhinin@citrix.com>,
        <fcoe-devel@open-fcoe.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND 0/2] Fixing libfc memory leaks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1579013000-14570-1-git-send-email-igor.druzhinin@citrix.com>
Date:   Mon, 20 Jan 2020 23:56:24 -0500
In-Reply-To: <1579013000-14570-1-git-send-email-igor.druzhinin@citrix.com>
        (Igor Druzhinin's message of "Tue, 14 Jan 2020 14:43:18 +0000")
Message-ID: <yq1pnfdif0n.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=635
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=697 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Could you take a look at those?
> At least the first one causes noticeable memory decline over time
> for some of our deployments.
>
> Igor Druzhinin (2):
>   scsi: libfc: free response frame from GPN_ID
>   scsi: libfc: drop extra rport reference in fc_rport_create()
>
>  drivers/scsi/libfc/fc_disc.c  | 2 ++
>  drivers/scsi/libfc/fc_rport.c | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)

Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
