Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E09C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F052310D
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 15:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbhAFPhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 10:37:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbhAFPhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 10:37:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FXWLp160944;
        Wed, 6 Jan 2021 15:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=B4zV0bAX3g2r+0DbmAeYacwV5zCLGZhVYUfd8o4aT6U=;
 b=mNKCE5gbYNpogjPkc4hICF8jsV72MRemPE9UALklCdXoUutNKGHHrJNJBwTjTbLxQs2y
 ZpSl2OGi4ybXvdtMdGno5e7uNgOVUl0L/H+B0eSbp2+KaO+f8ZZn74ehiI1O0Rddg//9
 gtheC6Ijf4npVUXTYdLj+XqqkAMpjr4ALrAiN+TQeYloZLtYOSKLkuwgofFQ/moWsTqY
 2UAULCBCcGTKyTx9uqg9U+YEhPcSOnS8t86VpeaqWiTE7A+D9Mcd8oXV2LoUxsx5mmbG
 dPa2eLaIvEr1nr/AlFO0k9HShIW7g1P2vMhce0xaJR42cTlMdxT6/KA137UKVW9/Crj5 Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepm8fgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:37:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FUrg6077713;
        Wed, 6 Jan 2021 15:37:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fa15aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:37:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106FbAw5008695;
        Wed, 6 Jan 2021 15:37:10 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 07:37:10 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 5/7] qla2xxx: Fix mailbox Ch erroneous error
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20210105103847.25041-6-njavali@marvell.com>
Date:   Wed, 6 Jan 2021 09:37:09 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <177622F6-F573-4EE0-AF78-4C051F17BA22@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-6-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Mailbox Ch/dump ram extend expects mb register 10 to be
> set. If not set/clear, firmware can pick up garbage from previous
> invocation of this mailbox. Example: mctp dump can set mb10.
> On subsequent flash read which use mailbox cmd Ch, mb10 can
> retain previous value.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c | 1 +
> drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
> 2 files changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c =
b/drivers/scsi/qla2xxx/qla_dbg.c
> index bb7431912d41..144a893e7335 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -202,6 +202,7 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t =
addr, __be32 *ram,
> 		wrt_reg_word(&reg->mailbox0, =
MBC_DUMP_RISC_RAM_EXTENDED);
> 		wrt_reg_word(&reg->mailbox1, LSW(addr));
> 		wrt_reg_word(&reg->mailbox8, MSW(addr));
> +		wrt_reg_word(&reg->mailbox10, 0);
>=20
> 		wrt_reg_word(&reg->mailbox2, MSW(LSD(dump_dma)));
> 		wrt_reg_word(&reg->mailbox3, LSW(LSD(dump_dma)));
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c =
b/drivers/scsi/qla2xxx/qla_mbx.c
> index 629af6fe8c55..06c99963b2c9 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4291,7 +4291,8 @@ qla2x00_dump_ram(scsi_qla_host_t *vha, =
dma_addr_t req_dma, uint32_t addr,
> 	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
> 		mcp->mb[0] =3D MBC_DUMP_RISC_RAM_EXTENDED;
> 		mcp->mb[8] =3D MSW(addr);
> -		mcp->out_mb =3D MBX_8|MBX_0;
> +		mcp->mb[10] =3D 0;
> +		mcp->out_mb =3D MBX_10|MBX_8|MBX_0;
> 	} else {
> 		mcp->mb[0] =3D MBC_DUMP_RISC_RAM;
> 		mcp->out_mb =3D MBX_0;
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

