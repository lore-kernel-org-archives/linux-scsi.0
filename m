Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EAFC3A5A0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9EC920644
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FTNGSJ/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfHTCIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 22:08:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57144 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHTCIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 22:08:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K23umP131097;
        Tue, 20 Aug 2019 02:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=kozv8rNqFFlDh2kng2AHwAN932YpA+oJwg1l0wjA7Rs=;
 b=FTNGSJ/LPjg2wnjCqq1IC24MokXtEmQa6Zhok4tomaY7/LRzQQZ5iYCwH4HGZZlmyhf9
 cdhETQzkTSXL4lkwAt34LS0/2o1yo8hw9ddfeU1pwxv1RJtxizs3VIliVwnuZhsoNwnK
 9rC3FSRVw9Gldhe2ts9XeLIa9OWhpjbGVSebgl0gOVm02QQpejjOx6hIw17xKKbGJhnN
 3ZdB7fxo67LKR0zQnECwfyT7bPdfwUL7V4gonEpY2f+hPzknuvFXvKTIEw/I19vQmerG
 9KJwz90L89c9e7LFuHbZRhT/b/EG7KdSeQpUdNcXYv72W4P+jjD6mzwtmjNF3F1KcTBb cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ue90tb2sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:08:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K28DrL000766;
        Tue, 20 Aug 2019 02:08:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ug1g8k495-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:08:52 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K28pOS003666;
        Tue, 20 Aug 2019 02:08:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 19:08:51 -0700
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove redundant code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20190808013525.13681-1-huangfq.daxian@gmail.com> (Fuqian Huang's
        message of "Thu, 8 Aug 2019 09:35:25 +0800")
Organization: Oracle Corporation
References: <20190808013525.13681-1-huangfq.daxian@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
Date:   Mon, 19 Aug 2019 22:08:49 -0400
Message-ID: <yq1d0h0ziz2.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=920
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=991 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fuqian,

> Remove the redundant initialization code.

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
