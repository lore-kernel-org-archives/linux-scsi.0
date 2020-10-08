Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261E4C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2BE02145D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f2hG0wZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgJHCVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:21:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60400 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgJHCVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:21:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982LAOm182167;
        Thu, 8 Oct 2020 02:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ujrP1A79PfSHt2pHV1dbSLACm8bWFEwOQH7yCiehXO8=;
 b=f2hG0wZHL7JrUR7E4hPFpzcri4lAEKH0zYDmOwjPQp7e+C1ZUy2ICmimfMDY863Sh1Y3
 i3NgJRtMuPVPYjkaRH7vFlBww/YTwNhS0fqAtV7IbB95ej8wkIzHyrXq6EoyypLS+ZHc
 7TWj8jNxhKMSJuvGgg6aBQyr3Yq4vLj/yE3SNY9sPpyT2ax2Z0fvZWB5/H2HoVHhFh0X
 8NY2ihAxrbf+fCsIG0AM9AFZWHnXtBHwmaxQ8/xiMhSavbTo/PvawcYqt/xIln3qkiZA
 eVA8Hd0YK0g9jZ8xYzWHvq6h7nKZq1wUbW5Zm0jiszSaXoZl6LFLRL0pyCNylFNwYnc9 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb5aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:21:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982EtDu145035;
        Thu, 8 Oct 2020 02:19:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0cv8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:19:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0982Ji2B017485;
        Thu, 8 Oct 2020 02:19:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:19:43 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Do not consume srb greedily
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imblzcgi.fsf@ca-mkp.ca.oracle.com>
References: <20200929073802.18770-1-dwagner@suse.de>
Date:   Wed, 07 Oct 2020 22:19:39 -0400
In-Reply-To: <20200929073802.18770-1-dwagner@suse.de> (Daniel Wagner's message
        of "Tue, 29 Sep 2020 09:38:02 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=956 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=985 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> qla2xx_process_get_sp_from_handle() will clear the slot which the
> current srb is stored. So this function has a side effect. Therefore,
> we can't use it in qla24xx_process_mbx_iocb_response() to check
> for consistency and later again in qla24xx_mbx_iocb_entry().
>
> Let's move the consistency check directly into
> qla24xx_mbx_iocb_entry() and avoid the double call or any open coding
> of the qla2xx_process_get_sp_from_handle() functionality.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
