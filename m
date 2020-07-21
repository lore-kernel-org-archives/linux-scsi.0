Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34742C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046C82073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ReB4syrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgGUDC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:02:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59116 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUDC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:02:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L2w9Fa033555;
        Tue, 21 Jul 2020 03:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=MdqfSyIq/KyafYjd9YUedKT/DNi6zcshO4zGZKhKWcw=;
 b=ReB4syrlwRy/bqo+wWZsoWYPUS+Zlhv2IXqYGNnWMoQMw/3Io2P2W7GewJfG6+vGnxfo
 2ZIAeVzK2yrWVVstFoxxh/QFJs/+fVTUEfDM6+weCi2j/2JIJN3yKZIeVH6VOYSHjX5Y
 T4yfu5Wu80NBSJJBdXSqt7kQ3SR+O/8JLrWnGINaeNyHOYt4PXcoTaabSiO1ncGOMVWW
 xUPA8in5+dYWlKY3Q4+xcTADgLHWY/dztW7s7t5aUhKLMITVXKDA2WeCTK5rtLzX+zoa
 gJ4T8RlVGQ7StxiOt0SdTi6dd52sNP6DmzfprsOzCe2FoUsoVftx514ULSMYys6GA4y0 nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 32bpkb2jcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:02:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L2w1SA089173;
        Tue, 21 Jul 2020 03:02:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32dnafncsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:02:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L32rSb031342;
        Tue, 21 Jul 2020 03:02:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 20:02:53 -0700
To:     sumit.saxena@broadcom.com
Cc:     linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com,
        "shivasharan.srikanteshwara@broadcom.com. Tomas Henzl" 
        <thenzl@redhat.com>
Subject: Re: [PATCH V2] megaraid_sas: clear affinity hint
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eep5inao.fsf@ca-mkp.ca.oracle.com>
References: <20200709133144.8363-1-thenzl@redhat.com>
Date:   Mon, 20 Jul 2020 23:02:51 -0400
In-Reply-To: <20200709133144.8363-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Thu, 9 Jul 2020 15:31:44 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=842 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=851 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> To avoid a warning in free_irq, clear the affinity hint.

Sumit: Please review!

	https://patchwork.kernel.org/patch/11654391/

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
