Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7E2C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0FF21D40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hdmqI59S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgJMWpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729488AbgJMWpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYPqC023467;
        Tue, 13 Oct 2020 22:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CaTy4YTvs5CGaygcmD6qF9eix3A6M9uA0HF105Q7cck=;
 b=hdmqI59SVDfAqZbgTXF2Cb4VzMtMlX/84zAv/IWYYjIx65dEWjiHEJqfvVZ5OYJkZo0X
 Ojs/+O/LtLxqSU5Afya86nfR8Fz+KA5TZqE4gSiw9Ka4GfXg5D98nqQVsysXlUwzy5u8
 BNV1Rvyjd0KnVyf3uB2B/njGcubZBu3FssK2NCTNRVgroXIQ5Z+IHrEZZPljU7wITPbB
 OTRNzuE9Ow88fNgAqrLIaFJOSTCz8Cq+xxBrMNGI3W7Jwfq1r3x8s1/u+5zy8b1rBhjy
 oHtrreGMnWXiWoRq5SVrB3Hp5sXiBzBXlFOUl/xmUV3+Z2CEhJVh7lQfY8TWKkSZD1rV 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wkmr8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMaWax049136;
        Tue, 13 Oct 2020 22:43:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 343pvx1su1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhQcE002707;
        Tue, 13 Oct 2020 22:43:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:26 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, achim_leubner@adaptec.com,
        linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH v2] scsi: gdth: make option_setup() static
Date:   Tue, 13 Oct 2020 18:43:02 -0400
Message-Id: <160262862431.3018.6128470260008817148.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918034920.3199926-1-yanaijie@huawei.com>
References: <20200918034920.3199926-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Sep 2020 11:49:20 +0800, Jason Yan wrote:

> And move the two functions around the '__setup' macro which uses them to
> avoid a 'unused-function' warning.
> 
> This addresses the following sparse warning:
> 
> drivers/scsi/gdth.c:3229:12: warning: symbol 'option_setup' was not
> declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: gdth: Make option_setup() static
      https://git.kernel.org/mkp/scsi/c/938b9e9ffbf8

-- 
Martin K. Petersen	Oracle Linux Engineering
