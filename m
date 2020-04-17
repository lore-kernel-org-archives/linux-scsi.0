Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35235C38A29
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13058214AF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j79sndWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDQVet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:34:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgDQVes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 17:34:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLXpxF001332;
        Fri, 17 Apr 2020 21:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ET1mH8yHofW+JbKW0TyY3wnOHfNGjT/e0T/krpHIWFk=;
 b=j79sndWqF/8GxUaIRrKGsbTAkEs2o9PPFQElgHLSenY9VckG95hDjxlMOJOfAINVslud
 2PCB0QosBdpoU8Bd8tAifWiVHUpqloYO53S2Fg5M5gE3WUMC1sRaMAC+TFgyTa3/h342
 Txs7KBzgQzGMVdJDYUab079JvUBGnF3mZ2HVARRx787Ohs3s+tTs+n/XILav7g1H6thP
 PGUjqf8j0A5Miongi818nQMSC7X1os6LszPSLbZ+9bCJ7egkLk0AeEY7Kdd/4FgC5j2u
 Jx9uPjcJi6Z243NWCyBidxYz5+QLU+VNOlAyeXHCcIOYzz93rNU4zSLlLNo8tV0fIDL6 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30e0aaevf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:34:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLVx38084129;
        Fri, 17 Apr 2020 21:32:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dyp3jee9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:32:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HLWFvl001681;
        Fri, 17 Apr 2020 21:32:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:32:15 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <rfontana@redhat.com>, <kstewart@linuxfoundation.org>,
        <allison@lohutok.net>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <arnd@arndb.de>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: mvsas: make mvst_host_attrs static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200415085044.7460-1-yanaijie@huawei.com>
Date:   Fri, 17 Apr 2020 17:32:12 -0400
In-Reply-To: <20200415085044.7460-1-yanaijie@huawei.com> (Jason Yan's message
        of "Wed, 15 Apr 2020 16:50:44 +0800")
Message-ID: <yq1zhb9n6hv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170156
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following sparse warning:
>
> drivers/scsi/mvsas/mv_init.c:28:25: warning: symbol 'mvst_host_attrs'
> was not declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
