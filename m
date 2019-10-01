Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF0CC352A9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C210E2133F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dRnFXvLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbfJAD2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:28:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfJAD2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:28:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913P4xu099322;
        Tue, 1 Oct 2019 03:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6y/OCOEAXI6Iy6zbVDQ9FeH4AdUNae/fKFFy/jp2zqs=;
 b=dRnFXvLHn4L1YxWt+2yqU8JucE2qAZCDUxPfYtpeh3WIFhlWOpBjKbwugQ2hBQQ0eHKw
 krEp/4kuoYL7k84N6L7e0IwvGZyrX+AIoJ8xWH9GouLpMuwz7LG6JyqXJRebITaaSdfl
 tA+ZXFVKBEbb5HrIJ7NZ6Xsi6iFeXXPoeIoK+2qYe9JKWZRcPu5zGLlRNDXLx4dGvksn
 b5vMt99S1bwRAl2+OqzeUP22O1e+zmR+BCsPp1rVcj3G3SHb58cRYCQvd2Rw8rkTxMU3
 k6hBgFfohGI3awret+MZT6S9l23wcW3NuivBoP6Iqe51g2oUKZO+Hn23lmEZtssas4cK Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v9yfq2xhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:28:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913SUxr118612;
        Tue, 1 Oct 2019 03:28:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vbnqbwsuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:28:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x913RwJ3012620;
        Tue, 1 Oct 2019 03:28:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:27:58 -0700
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        varun@chelsio.com, axboe@kernel.dk, davem@davemloft.net
Subject: Re: [PATCH] scsi: libcxgbi: remove unused function to stop warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190924093716.GA78230@LGEARND20B15>
Date:   Mon, 30 Sep 2019 23:27:55 -0400
In-Reply-To: <20190924093716.GA78230@LGEARND20B15> (Austin Kim's message of
        "Tue, 24 Sep 2019 18:37:16 +0900")
Message-ID: <yq1pnjhw3es.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=953
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Austin,

> Since 'commit fc8d0590d914 ("libcxgbi: Add ipv6 api to driver")' was 
> introduced, there is no call to csk_print_port() 
> and csk_print_ip() is made.

Applied to 5.5/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
