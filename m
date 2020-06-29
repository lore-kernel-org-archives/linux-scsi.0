Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013CFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D073F20780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:26:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hV3oCuus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgF2X0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:26:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgF2X0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 19:26:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN8EqS138295;
        Mon, 29 Jun 2020 23:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=fqU6wHxINH56k6JKjjs6e6XouLea5SKHBm8doY2++bU=;
 b=hV3oCuus5wr4TLZHcsDxtvwzrGuJrWm7dZOhtfzcWO/Rs+fdoaaEKUe/AIH/Ch6Qy7MI
 4KO0fThnAUmIGhPLVpVi5QPWGtJpG1IsBjVpQBPUoWKyyd8W3EmajQIZXQsCNQWO/Ae4
 oxvsEK/KBDgTooBt1NkEj4rQUsSPGys3j5D4VlX0rIcmq/FXQlE9YEjobd3qpiiq4auc
 ATczIs4YHUHMZxcq2HzpXJqV1xh5I6dpw5HWZUlbx113tq/XilhyOhtd0dnK3nUhMheI
 MjrNGxEcNuFyjHz7Bzm+HaC6UxpR4xOTF7QqXdygfJUKgCr0mdQnw5kmNqHREBP/1mjK Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1dp1vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 23:26:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TN8egF003313;
        Mon, 29 Jun 2020 23:26:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg11nenr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 23:26:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05TNQkvi025664;
        Mon, 29 Jun 2020 23:26:46 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 23:26:45 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2 0/9] qla2xxx patches for kernel v5.9
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
Date:   Mon, 29 Jun 2020 18:26:45 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <02A19F4D-965A-4C3A-B542-6132489D7C94@oracle.com>
References: <20200629225454.22863-1-bvanassche@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,=20

> On Jun 29, 2020, at 5:54 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> Hi Martin,
>=20
> This patch series includes cleanup patches and also patches that =
address
> complaints from several static source code analyzers. Please consider =
these
> patches for kernel v5.9.
>=20
> Thanks,
>=20
> Bart.
>=20
> Changes compared to v1:
> - Rewrote patch "Fix a Coverity complaint in qla2100_fw_dump()"
>=20
> Bart Van Assche (9):
>  qla2xxx: Check the size of struct fcp_hdr at compile time
>  qla2xxx: Remove the __packed annotation from struct fcp_hdr and
>    fcp_hdr_le
>  qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
>  qla2xxx: Initialize 'n' before using it
>  qla2xxx: Remove a superfluous cast
>  qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of
>    request_t.handle
>  qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
>  qla2xxx: Make qla2x00_restart_isp() easier to read
>  qla2xxx: Introduce a function for computing the debug message prefix
>=20
> drivers/scsi/qla2xxx/qla_bsg.c     |  3 +-
> drivers/scsi/qla2xxx/qla_dbg.c     | 98 ++++++++++--------------------
> drivers/scsi/qla2xxx/qla_dbg.h     |  1 +
> drivers/scsi/qla2xxx/qla_init.c    | 39 ++++++------
> drivers/scsi/qla2xxx/qla_iocb.c    |  4 +-
> drivers/scsi/qla2xxx/qla_nx.c      | 20 +++---
> drivers/scsi/qla2xxx/qla_target.h  |  4 +-
> drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
> 8 files changed, 70 insertions(+), 100 deletions(-)
>=20

I had reviewed this series earlier and provided Reviewed-by tag.=20

=
https://lore.kernel.org/linux-scsi/EAC19A51-7256-4D5D-9DBB-D30CEF8551E9@or=
acle.com/

--
Himanshu Madhani	Oracle Linux Engineering





