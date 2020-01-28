Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A48C35240
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9406D2467C
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yj5rlSTe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgA1DlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:41:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgA1DlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 22:41:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3ciOx009130;
        Tue, 28 Jan 2020 03:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=uVy/Vh79yBfcH2lIY0+3S2hMDKfa7Ogm1s3EEk+ruL8=;
 b=Yj5rlSTeOwPKxEg/DjUkT63iCNYKBPpyr2pEwnRBZ9kBrZjFr8MkPIWUNlE/6AuMgNfR
 6mKHWuOl17r/DCeKDjMU8ZyLKTmOsgbZHNzWMR/vFx7i5wAVBH57V8BYicSE+QE7nuiG
 2WIBcF90CbO7DXdNaLK1ZmyshSuRP4ro9w5VmyGNOE+ZdjRrSl7ul/jfbavuQikzmJpo
 LnNjzywdgj96eACf9Aqq6uHD5E550pmHn9BNLOoFqNwMqBuvB/98z6iXAI4o1wp9/mkE
 MKqc2vquF+Mmc/DGA7KclW22H+9ByGRz702LssEBOKgfXV49j2LTrr9L99/MsL9ft/6n GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xrd3u3e0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:41:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3d1Fn056624;
        Tue, 28 Jan 2020 03:41:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xry6x8n0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:41:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00S3fG5C014319;
        Tue, 28 Jan 2020 03:41:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 19:41:16 -0800
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5] qla2xxx: Fix unbound NVME response length
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200124045014.23554-1-hmadhani@marvell.com>
Date:   Mon, 27 Jan 2020 22:41:14 -0500
In-Reply-To: <20200124045014.23554-1-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Thu, 23 Jan 2020 20:50:14 -0800")
Message-ID: <yq1d0b4b63p.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=825
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> On certain cases when response length is less than 32, NVME response
> data is supplied inline in IOCB. This is indicated by some combination
> of state flags. There was an instance when a high, and incorrect,
> response length was indicated causing driver to overrun buffers. Fix
> this by checking and limiting the response payload length.

Applied to 5.6/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
