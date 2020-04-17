Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C257C38A2B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CB6214AF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pyUkzSPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgDQVcu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:32:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgDQVcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 17:32:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLIQsK017001;
        Fri, 17 Apr 2020 21:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=UHhXn4TFb7iP/yLbQUBSjFu5xKU2uaPUb6UZTF11SnI=;
 b=pyUkzSPRbSwThrq20A2lvHv19pKI0vRXo7Rs0aFxXOfeYE46fTHRvtn5lXknlo/uhOJg
 WtdwXyyULSbeCchHvyx8xs1Jdd82b7pb1IsU5Zvtm7jpLxR4w6T+Z3WxiOGAXLTcw2f8
 hJQcbQx4+21+s2emts7FGQi4XohcghyhBWznd9EjpIFgkLA/HGMinYQDIpxuHiLbFRF5
 MY3GVBDR28vJrCrVJ02m93x7ybtJ6i49X6/lnNjtGVF4z3gnCwrRNs0yV8GFzVV4eyCB
 OUKBZxSlfyQUDL0Z7NK6Se6NQLRsmXc5NkH69WrxI+CBPvNUl2ke7N0U2GQavO6NwKyf CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30dn961c72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLWC5d142752;
        Fri, 17 Apr 2020 21:32:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30dn9m51a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HLW2hw002064;
        Fri, 17 Apr 2020 21:32:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:32:02 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <QLogic-Storage-Upstream@cavium.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qedi: make qedi_ll2_buf_size static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200415085029.7170-1-yanaijie@huawei.com>
Date:   Fri, 17 Apr 2020 17:32:00 -0400
In-Reply-To: <20200415085029.7170-1-yanaijie@huawei.com> (Jason Yan's message
        of "Wed, 15 Apr 2020 16:50:29 +0800")
Message-ID: <yq14kthol2n.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=927 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following sparse warning:
>
> drivers/scsi/qedi/qedi_main.c:44:6: warning: symbol 'qedi_ll2_buf_size'
> was not declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
