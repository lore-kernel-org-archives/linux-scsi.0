Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDAFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbiFPF3O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbiFPF3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:29:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F0B583B9
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:29:11 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25G2BRET014923
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:29:11 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gq83ywqpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:29:10 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25G5TAtK005470
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:29:10 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gq83ywqpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 22:29:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuwmUxxcxz42sJaZcScZHh1F347x2ez5If04V0r44Bfnm2kvYue45ip/Zh2ADScGgUVv+e69pkTaPpCCz/XbeDCBVfLI2tYN8r1Efyg4VFU4ka/siwhf+m67Z2z3yQRHFNnAbNIY9j4QVZtoxGlStYboApC6u5f++8DX91vMu0bhVQ8w6A6A5GozEibDvUBB+XFhnzXmPYWP9nStnxEorbOjrzQaZXRX+ueRAU2yzr5WuFbjRfdyJrABaMnl3ASqjr/uHl8ifgKPfaA/Ws3ygnj2RnxpuUKnfKyuVwp/nTjpwKPkNUt0jbFtbCEAxQH1cB477Pmkc2uUCooAHPvlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wM0SuosAh0XD+Kr7PBZBNvTY3Cq0QH8umxyVvIarGL8=;
 b=HyKXH8U4QuqWBVmLgwhTfMkcq1x90H3hKLHdB+NfM/Vdk+R+W0LolLtlKR25Cz5pSNT5bAgS6wVNelmX2h35JX2QjY+Iha/u6keyLyxvJVVsucoTaJJXl4hs1dyddWh26ao8lOrOJUSZYu28mGtliSJtYM0azEfkZrK6zBRFulDX5oIyH/QDBpVXEnkH5r5MVtTJFfoxAxLyfAyljqc6oF7nv5P1w4KcMCRvokv6nvf33n+pcY7vo7hKP8ZMK+37+IxE6Ta4hed0yQ1CFSVqdov5Kx4bolEiWqQCU+rbefBJZCB2j0DXoGvoLlsoII8b4px/wQibEJIODitYWWhEBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM0SuosAh0XD+Kr7PBZBNvTY3Cq0QH8umxyVvIarGL8=;
 b=pVGLxjdqgGZjdb7JpUKQ6oN3z4pBk3dvqXaXq2L+siQ/XEMf+GxZDhwj3/w0McAjNlGUXsukYeMpULBwOvTGiaYUJwa12LXfp6mq/X5CiZ58PLMAOLu6bXuR6ya96CusAARv6OAHD/kPV1Ai05Gyug2gpbLZ3paHWcC5cFMyB3s=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by DM5PR18MB2197.namprd18.prod.outlook.com (2603:10b6:4:b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Thu, 16 Jun
 2022 05:29:08 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c973:8ef8:8634:9295]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c973:8ef8:8634:9295%9]) with mapi id 15.20.5353.015; Thu, 16 Jun 2022
 05:29:08 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: RE: [PATCH 05/11] qla2xxx: Fix crash due to stale srb access around
 IO timeouts
Thread-Topic: [PATCH 05/11] qla2xxx: Fix crash due to stale srb access around
 IO timeouts
Thread-Index: AQHYf8CPMs1AXIpcYE2HDXpfY4Irr61Rg34g
Date:   Thu, 16 Jun 2022 05:29:08 +0000
Message-ID: <CO6PR18MB45005ACCE1E36E9BC2629D7FAFAC9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20220614072953.16462-1-njavali@marvell.com>
 <20220614072953.16462-6-njavali@marvell.com>
In-Reply-To: <20220614072953.16462-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d119b2e-7887-4924-62f8-08da4f5922e2
x-ms-traffictypediagnostic: DM5PR18MB2197:EE_
x-microsoft-antispam-prvs: <DM5PR18MB21976334273B4AC2E47E3D13AFAC9@DM5PR18MB2197.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UkF7oYB/c+hx6KKzPiOG9cbIbp2JmAFwjcGJ3dP5lT6EuIU77Zh9jhPdNLiaa3rm9QUWzVVO4y7vhk2K90AR9KFVJ42f+fOFhiPdasFGSyQDzqHENhOk/tgHRy03NdjU8EXmHZ7ABssKoJ+sQNDF+5tVnfe0PR1kqt82MIZkWvGz+wHt5INdn27iuHiVsO8kev0lU5VsBQdTG656JJOXEeqxCzDg2rfd2IdOEN0t3U42IbJ9iCK7AAUTmi1Ot6d7vThoSobIIuQss47KyHGVjucxMnOptwttnFbDU0NiN6fG16p3b8OwqLHggCt/ghumV8ePvx0FCU2huGM0+p8lpcqPi7ihJdpm16BDpaC1fWscNQcNrppqOCkXx4nY7OQ8Sd+MnWNKznYRIWz/VF+53guE7t8w7oMNzLmis5duDRZQgNzITUDwG53nXvs5D2rd0Exfrg9Kkszd976DgZSFgEAuN0gD+9y4N+3Z/E3UFIf6WvbYpX4cwPpjE4M/DwRFv0DZ09tewpFiVt1r4RvbKg7Vkf3mnBqEwaUlLfSAybRzYwK2vTnMF1RM6FVqz4YjzI+Qc0f1WGFDHffFdLJgCc8yEVKoxpArb+RFkKR4xOQqAUlKeadTdYrJE3mqjJJQYAoR9aUtM96b66nlBCR3S/ExnfbFUpp9TWGfx254x9awdiEwda2nmurEH3Q72fVvhUvKeLQHh6rTHErm0d7TeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(508600001)(6916009)(53546011)(71200400001)(54906003)(26005)(66946007)(9686003)(66446008)(66556008)(52536014)(316002)(8936002)(55016003)(4326008)(64756008)(5660300002)(33656002)(2906002)(38070700005)(66476007)(107886003)(7696005)(6506007)(122000001)(8676002)(38100700002)(76116006)(86362001)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KPn0iUixi53xjgb08lfCWWgLCKVsgk/2cJdLL3z6qxJU8gI+mfBEC9ZSNqcu?=
 =?us-ascii?Q?Pj/Te6b1UrL6on+qcTFaPCliZMiIRWZ3S1EAw3SUJFQm1TdcVremu8qNYwCr?=
 =?us-ascii?Q?SiqmiQfYZMU8qDC2JrdgOwh2pyUtWzPFlAVMx5PlFvBT5wvESIlQx2xTCEbR?=
 =?us-ascii?Q?WrK/CkwjyTCGHwFV01j//ENuSwl0O4gjWWlEokRHJFk1McBQP7CufpAJg/D9?=
 =?us-ascii?Q?7muwUSuBxPNPRb13os7miOzmt2f1Qm/5JV5vSO9MxZofaXq+4zt/rEi467U6?=
 =?us-ascii?Q?/+TVxgvV0du8Wp8BwJNYB1EJJA/38GMLnuMOcT9Y54ct/4DFI+E5RXB+b8rI?=
 =?us-ascii?Q?GBgrnptTpwpW3+vrnKz8QK9NXEMQEY+yECEa0Xl1l6n88uAzgyg+Rmwk0+Ng?=
 =?us-ascii?Q?RXY1uRofjq6P1caNawHbKBCUZGDiibtS18Hj2am8z3jtKMl8QCwfDap4W5ss?=
 =?us-ascii?Q?uPLo9+ZhWEvdhF4IvrIbRl1oXUW7T+Nlh9I94rVY7QQ0qU6mpGiPKNEQCrcl?=
 =?us-ascii?Q?StbUkAQaxrBtDRIvP8/nYdT6tQ54UhxI25zEWpFZno9o9wmdOeA3DuFJF3Lp?=
 =?us-ascii?Q?PglODYruSlOTi4EVf/FWmNc0zeXK/yiZyz61lfIkVsqX1Vv76hkeBMPtxcXi?=
 =?us-ascii?Q?5sklwjGJGuFH++MQFonkII88EBpAjWwuhRTR1Pjzo0mxSj1IWj5wiIXupKMG?=
 =?us-ascii?Q?a74P6QFjVDWCV/R9Ttu6KOgjG+e0B+cvobKijZEhi2kP0YYJMxCudtMSS2Pk?=
 =?us-ascii?Q?QO0aJMYDIwRUutac09MXnEKn6aoGyNrZBw4Q+9rVhw9uAC8fiGfrO1a6VxYg?=
 =?us-ascii?Q?YpJqB8N1O/xcplOgpqJUD6Li4ymClRvnNVtekiuPPmsczrvXaGumtMRmGEnp?=
 =?us-ascii?Q?lW8OsOk1rrqMOyOT/CQoHszLtWvhyemgkFuW0FBeUOEd/qx35ISbsrNGwdrt?=
 =?us-ascii?Q?ODGcu53BPFTYojAEOsssKO+dJJdp85TXrjlv2fmWSQpT8RI/Y+RZAanUsiun?=
 =?us-ascii?Q?VxW1aPLz3iHfb5YX+tEoJJmmnIAH5RrEUL11DXYXIFpxviJqSovQry6w+qyB?=
 =?us-ascii?Q?SsSAAWs42yyyn9YpILnxj/DPC/i+wmixubJ8JnT56ZJLaMOTOX0EhRvDOyDF?=
 =?us-ascii?Q?tdC6DTi4zxo+tMnv7YFJewZ2bfR5ZopdqC2ZpPEsfeZVvYZJq5K5fW4h3rCa?=
 =?us-ascii?Q?tl+1Jhs0M/SHss8Myd2Pvjwe+2OuGKrJDSi2CjBbm7fzHyZQl4scSU5tbET6?=
 =?us-ascii?Q?7wfA5HIiB8BLaQCTwEsRZYs5CRNO/19MbOIlw2Hryr1OljRPGaxG3ydssASS?=
 =?us-ascii?Q?+8q7/jb1W74XfTzfA7O7x7n5O4cq4UxIvekDGlvHq74Zu0x72TVSsyK0P4wH?=
 =?us-ascii?Q?TMR6nKlAecv8Xk1HxdkdmF2/aCFdZkH11QS/lnL8eupaZRSPRojahcsbQSzH?=
 =?us-ascii?Q?8Sh/7uRH/HL4ZR2iWsIcM/1iGAWHS08ij4nabwsiAm+w3G2+egDpbuyUxK8d?=
 =?us-ascii?Q?xXL4AMi3qYxLb0PSS1eBMJpqq9Wnv8ipnp6RTiH15jWbyFTei2Sw9p5I1gn1?=
 =?us-ascii?Q?1jwXRjK9K3rrOgUziHyzyFY1/q0STzYYaGbtthkxjY3advTB1AlysB2/TCsj?=
 =?us-ascii?Q?5h9PU0oXazHlSE9m0Wxr1fSFUccWDOotJwVKjyDZsf5DXxpC7e6PxWXHxGjp?=
 =?us-ascii?Q?TmI6k9fWD6Kl4oY/c0J+8/CY4cyfaJcq02SFj2hjke213p5O5RFXcshP+G8v?=
 =?us-ascii?Q?t3W8lbkm8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d119b2e-7887-4924-62f8-08da4f5922e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 05:29:08.1823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /zdTPekVqowe7IediXPM2G/7EElosnTc21E2C1TNUEUJT95PxwC/MjWXcAbQzOpmRInIZOzJxjpAgq/NRzQKlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2197
X-Proofpoint-ORIG-GUID: Z5oEkl08w33R07-90dG5tVGEmMt7ZA2b
X-Proofpoint-GUID: 1QYJFKdaq3f7FH2HxPMN6FpX6oeyE160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

I have a v2 of this patch with additional change.
Please ignore this series and I will send the v2.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Tuesday, June 14, 2022 1:00 PM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>
> Subject: [PATCH 05/11] qla2xxx: Fix crash due to stale srb access around =
IO
> timeouts
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Ensure srb is returned during IO timeout error escalation. If that is
> not possible fail the escalation path.
>=20
> Following crash stack was seen:
>=20
> BUG: unable to handle kernel paging request at 0000002f56aa90f8
> IP: qla_chk_edif_rx_sa_delete_pending+0x14/0x30 [qla2xxx]
> Call Trace:
>  ? qla2x00_status_entry+0x19f/0x1c50 [qla2xxx]
>  ? qla2x00_start_sp+0x116/0x1170 [qla2xxx]
>  ? dma_pool_alloc+0x1d6/0x210
>  ? mempool_alloc+0x54/0x130
>  ? qla24xx_process_response_queue+0x548/0x12b0 [qla2xxx]
>  ? qla_do_work+0x2d/0x40 [qla2xxx]
>  ? process_one_work+0x14c/0x390
>=20
> Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionalit=
y.)
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 41 +++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 210fb5c52421..2fd4f4268ba8 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1342,21 +1342,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  /*
>   * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
>   */
> -int
> -qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned
> int t,
> -	uint64_t l, enum nexus_wait_type type)
> +static int
> +__qla2x00_eh_wait_for_pending_commands(struct qla_qpair *qpair,
> unsigned int t,
> +				       uint64_t l, enum nexus_wait_type type)
>  {
>  	int cnt, match, status;
>  	unsigned long flags;
> -	struct qla_hw_data *ha =3D vha->hw;
> -	struct req_que *req;
> +	scsi_qla_host_t *vha =3D qpair->vha;
> +	struct req_que *req =3D qpair->req;
>  	srb_t *sp;
>  	struct scsi_cmnd *cmd;
>=20
>  	status =3D QLA_SUCCESS;
>=20
> -	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	req =3D vha->req;
> +	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
>  	for (cnt =3D 1; status =3D=3D QLA_SUCCESS &&
>  		cnt < req->num_outstanding_cmds; cnt++) {
>  		sp =3D req->outstanding_cmds[cnt];
> @@ -1383,12 +1382,32 @@
> qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned
> int t,
>  		if (!match)
>  			continue;
>=20
> -		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>  		status =3D qla2x00_eh_wait_on_command(cmd);
> -		spin_lock_irqsave(&ha->hardware_lock, flags);
> +		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
>  	}
> -	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> +
> +	return status;
> +}
> +
> +int
> +qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned
> int t,
> +				     uint64_t l, enum nexus_wait_type type)
> +{
> +	struct qla_qpair *qpair;
> +	struct qla_hw_data *ha =3D vha->hw;
> +	int i, status =3D QLA_SUCCESS;
>=20
> +	status =3D __qla2x00_eh_wait_for_pending_commands(ha-
> >base_qpair, t, l,
> +							type);
> +	for (i =3D 0; status =3D=3D QLA_SUCCESS && i < ha->max_qpairs; i++) {
> +		qpair =3D ha->queue_pair_map[i];
> +		if (!qpair)
> +			continue;
> +		status =3D __qla2x00_eh_wait_for_pending_commands(qpair,
> t, l,
> +								type);
> +	}
>  	return status;
>  }
>=20
> @@ -1425,7 +1444,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
>  		return err;
>=20
>  	if (fcport->deleted)
> -		return SUCCESS;
> +		return FAILED;
>=20
>  	ql_log(ql_log_info, vha, 0x8009,
>  	    "DEVICE RESET ISSUED nexus=3D%ld:%d:%llu cmd=3D%p.\n", vha-
> >host_no,
> --
> 2.19.0.rc0

