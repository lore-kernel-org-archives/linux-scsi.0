Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC804C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6D1613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhDVRSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:18:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbhDVRSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:18:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH03uM004795;
        Thu, 22 Apr 2021 17:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pFSR1sYcYSb6DxmZzkcO7EEeVUrqrCDGTNlvWAFAviQ=;
 b=n84dLbgwnHNAhckbkiJ1cxFkPQ8C19du6Dnd5plFjzUpcy2CNMOc7oYMI5ABdiVTogiC
 3kHygyLN9ebhG9jfV1Wn/LAKzOQ7j5q2DsiPAgrtGc5n/puvxknub0GyEQXKz26Ga4mx
 EU/RLlMlOHI6Go0vrBtgEzQfcT3WumCiGsd4QNpy9yNSCR92cfEtJpXtbZEibbJEkVkd
 wyNpstC2eN41UhivUpPjiFAM6QGubVGwrVYIgOqE/F+ASbBuAmy6F4KW1q23/s5CYGQR
 HkD0+Ce9DGnROx5JFac3VB2xOnOrVP3IH4pQxMOcAk6zemPexRbruN49HqzkiZB7RKH5 eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38022y5h25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:17:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHA2X4185015;
        Thu, 22 Apr 2021 17:17:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 383cg9as2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:17:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGj6dlRjCrp/u4norpZPFGc/2MT5pWIymvxr9mSNRxMTiQlKPiAMJkbH7Oy0HXptspHyo52v9RR7Xd0nyBS4L+HJGcT7FUVnx46xwXRt5W5XHcPK0kjQZ/l3rzSx4eaerZ+iawXRgJq5CB/d6p+EEJb/qIaESxbGMT8VUy6oLvJwZ/ZQhqF0M91q6P4Ol25xHHJ81d1T/cFGF3bZSvPMLHxMkH/njdmkXer2OjdGChXWy3VK0Jz2lL/sPgPU9MAxTXmIz4oq3ZHn428BvjrtcqH8ZWQKyL+bqGnwvW3doT1c4bGQY2MqNvP+PrZDF/c1TEzKGg1EzpLX/KdXJl/Gjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFSR1sYcYSb6DxmZzkcO7EEeVUrqrCDGTNlvWAFAviQ=;
 b=AFtwdxvf/98cCm+AgDLfoIYvsokYPCzzwFCaenS60KZxsoVG3unWTfCWtkHZU+N/xDipjZ4b0jiJITBNtlmP3fC+A3y4/x2SqfO4U/4EFrA3liRO1+vPlIsAOga04+0aqaQLX6sX2PTmNAfkDvBUeGA7tmPCHZ6a7Mvgtt8L4tWXMimgum6r7E24du2/hPF/zncXJ0F/VQqyl/1Pvp39N4nB/lMcvXrJECngVhNRFm3gdDOjEYPgMHLnsRuTnlcZkXxd3MwnfmG1FQwX4AL2UU3tU2vrpEdJSC2eDbtA+qk3fPIzY31xKXcwcUHULyvKOYvqCABkmAtOukhwDzJdDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFSR1sYcYSb6DxmZzkcO7EEeVUrqrCDGTNlvWAFAviQ=;
 b=GkaUdUky75qdMevzCbDMg+DXKSr587XZnO5PVV8Y9nIG6zTqB6DXLJK+GM+DQmNbEzs+JkF3sAMDV+LKlLltC2xbdNRZRKNxP6d7i9o/iYv2hPajYNisaAEI8SRipbbxaE2hLht25f/M5nYEx8SgHT89C0feZMFVnPNHAmpDTGQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2829.namprd10.prod.outlook.com (2603:10b6:805:ce::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 22 Apr
 2021 17:17:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:17:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 19/24] mpi3mr: print pending host ios for debug
Thread-Topic: [PATCH v3 19/24] mpi3mr: print pending host ios for debug
Thread-Index: AQHXNQuUqiF0U96600WX7rE5MCxUqarAzJuA
Date:   Thu, 22 Apr 2021 17:17:19 +0000
Message-ID: <24A80BB1-B6D6-46D5-9615-48655ED8560D@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-20-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-20-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1793586c-00bb-495a-5ad9-08d905b27c4a
x-ms-traffictypediagnostic: SN6PR10MB2829:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2829827C3017B32757DE4662E6469@SN6PR10MB2829.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:357;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NLsbv4rn6LmLNx900pvXUyIcpQTm9Kjegl8CErlOh8DbKVQMAsevkUpN1cbKhq4NAqWp04yRhA5dCwjHHQ2MtxuEYUXIcCvS4jkLK0BbZh5Yit208ELegbs3KGojdWsGquSlHeVpNxBclgtLAjPwVqbpm+RMR2QtgegrfVo4m98igOvuVCQnbLkKZTCLmAR1nTJ/zkyRG1RjiAzbtaF2eG17+C+UTUT23yBcn2eZxy+6ZYKHvR0fBNk78KWuUgSkPwPkoAn5PktD2/wM02fBcNBdDZHIlQg4s8TUFEIu9Hnic4/I/lDg1HOBbMyXPTZInIZQm2P6fiC2RTXRG/nLxSLY07uc2yUlGx6f8pG48YByJpR0R5CGO2rTCnz1PR/47dWvhtEVjplPzk+psew9bv4+skF6v10kHbfIPmoo9RHdLhIASrm2lQZ3XGbimUr/UerMmwjA/SmblT+CgI8dfqbLfewuwF55cfYnzERwj+YkFQYFDALfPnLIV6PCDuDgrcwstjcGDBkweRS+DqX7aK9j5roty/iFO3Gpbz0XD0h+1UfeNs9QMSRsZO515PcmNw6dG51Q81zdF1BO2qYSvPkUly2fbnEPAQEQfjUUcQTI4Ck0CoDkEEjS9Nq80cZXX9lq+bL49qfDH07ONtPSZ5nNwFleAstkzotQi50veebzWC/LDMHfrclQNsmMHp2G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(6486002)(186003)(66556008)(6506007)(33656002)(2906002)(6916009)(53546011)(66946007)(54906003)(478600001)(38100700002)(4326008)(71200400001)(26005)(122000001)(36756003)(8676002)(83380400001)(44832011)(76116006)(86362001)(66446008)(2616005)(66476007)(5660300002)(8936002)(64756008)(6512007)(316002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?n2K1AVEvzynlPALj/xC6iiAGm0ZJPdHK7C+qbpO9oQ/I9yEJUup1Xt4tbw8k?=
 =?us-ascii?Q?X4aRm4nEahJCmvZYc62Saco2WGiu40tzp6RzhmZGWazZoZqjjpo2J1oXlUTp?=
 =?us-ascii?Q?kBFvK0kOoaJrr9lOgLmSLiQZtdafIu/fK2WXYRASBES2hp5g8rei9uf8YMGe?=
 =?us-ascii?Q?JTPP4wYfuhcxDY2Em/7KdAIabdIKT4j1HMpSjtwhIWhBIf2m9bCP97naKW2w?=
 =?us-ascii?Q?Vgry0nf7HlhWC7ug4K8yobcApC3DwnrM9NhzS5Bd/Mt1SUFrqLxxDRqz9NJr?=
 =?us-ascii?Q?r20mEvz4OPKI/irWDL9ypKXGfIzqh3QLnSBTxfB6GsbvG1rEKILkd4TYl4RA?=
 =?us-ascii?Q?XaUvuF/OzI/3Mc1hJqTGm1zLHer22VnKN98DvR1OW79wo4iUQeTo+mV+cpm1?=
 =?us-ascii?Q?JJvBIzRMXCT9ZDsX6W5lPK8jmTP8XOfMF15QrAdoGK8wwdQNWk1jKbe0VVxt?=
 =?us-ascii?Q?BvG3JPkTfcBA6q478VBBxPpMtKY0/jRJv6iUQkvH6C//RngvG/cwVqC1SxDQ?=
 =?us-ascii?Q?6gk4068xL7uHgMh6/+XDM0EHOl3GIp/Tzb1d/dPhkQJUFdzEH+Cx9EYCCPg5?=
 =?us-ascii?Q?uvY1E1uhk98Zt4vclcK86A+82F4A7I3KqWYgCEJkDlQe93k0aMduPmwBbenL?=
 =?us-ascii?Q?4VGbcKyxJtlxOezb9ifyQxGDXMBEhwVG0CXkG+TzYN2OBiFoNcVsrb23TScB?=
 =?us-ascii?Q?NBLTpXwqB9dkhHU7Oif0/ZWydi8Gm49WBLkluxE32P5JBBWX3TtQN7a1uM5h?=
 =?us-ascii?Q?bIDqqei4bIMuphV0uQ22iv5FT5/Grr8vrK2gl30SO0WGEjU1C2vGlLS9LWkQ?=
 =?us-ascii?Q?S8WhOQ7N4vpxmTDd7038ZL8dQNT5xtb3yUUTA6iJ0CPmZbGrU2xSZP8teaqj?=
 =?us-ascii?Q?/+PqLvmNeo9WHRxr9foEdtBv5iP4RPIhTPiGQo0oAIC0xl4a+nJ7i8KtnVpx?=
 =?us-ascii?Q?lZM5Sf6gxqw2fJMXRbFTZKFONIzHrCNgsomRk6YQM9gaP5kpeu3up6u4Phpf?=
 =?us-ascii?Q?7Q8x7BKwywctyKw0TOHdv2tcjtNWszAFodoSRS84NbI93BY7xvYeDslcuKAh?=
 =?us-ascii?Q?T2pCq6hNq3gwmLf3Zw8Mspf6RVmkGgiidWqJIA8DNUxFmK+BFHVTGOAedKeU?=
 =?us-ascii?Q?D9GHW0fPcyvqJwIW2hyM/InjKxyPEE/1uW4xCQM7CmrwoI4Sq9TDPqU0qkuW?=
 =?us-ascii?Q?KA2CIgMsKuLDqE1ApAoTzUchNN4MBNJJJr8nBPk7NdEPSKbTyRe0wHQ2/TtO?=
 =?us-ascii?Q?U/FUfYdcCP78FUn531CyFnFU9uKWMxVRX84gxUbhvas/XMiFZ97PqRsOgL7j?=
 =?us-ascii?Q?v3wdglF1TAtnslOazsf9JOxdklhzwmufzpXKXCDDzoTtAQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F3F4CF0FB86804B95BDF90638CBD67E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1793586c-00bb-495a-5ad9-08d905b27c4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:17:19.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4R93MIwd/5TRsOLwroxi3qsZaRy2NMbXvzMD2kwsxt2IC8ODonYkBhgTrK08JBIKUabIfGXDHAT9NM1RwKqdoCljBn12COZOj+J9SoC1G/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2829
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220129
X-Proofpoint-ORIG-GUID: gn1ZXhAbVzgZ3RzgYetXYJsqkRsYd9mg
X-Proofpoint-GUID: gn1ZXhAbVzgZ3RzgYetXYJsqkRsYd9mg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220127
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 69 +++++++++++++++++++++++++++++++++
> 1 file changed, 69 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 01b82bd2e8df..56f1e59e86cc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -334,6 +334,37 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc =
*mrioc)
> 	}
> }
>=20
> +/**
> + * mpi3mr_print_scmd - print individual SCSI command
> + * @rq: Block request
> + * @data: Adapter instance reference
> + * @reserved: N/A. Currently not used
> + *
> + * Print the SCSI command details if it is in LLD scope.
> + *
> + * Return: true always.
> + */
> +static bool mpi3mr_print_scmd(struct request *rq,
> +	void *data, bool reserved)
> +{
> +	struct mpi3mr_ioc *mrioc =3D (struct mpi3mr_ioc *)data;
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);
> +	struct scmd_priv *priv =3D NULL;
> +
> +	if (scmd) {
> +		priv =3D scsi_cmd_priv(scmd);
> +		if (!priv->in_lld_scope)
> +			goto out;
> +
> +		ioc_info(mrioc, "%s :Host Tag =3D %d, qid =3D %d\n",
> +		    __func__, priv->host_tag, priv->req_q_idx + 1);
> +		scsi_print_command(scmd);
> +	}
> +
> +out:
> +	return(true);
> +}
> +
>=20
> /**
>  * mpi3mr_flush_scmd - Flush individual SCSI command
> @@ -2367,6 +2398,43 @@ static int mpi3mr_map_queues(struct Scsi_Host *sho=
st)
> 	    mrioc->pdev, mrioc->op_reply_q_offset);
> }
>=20
> +/**
> + * mpi3mr_get_fw_pending_ios - Calculate pending I/O count
> + * @mrioc: Adapter instance reference
> + *
> + * Calculate the pending I/Os for the controller and return.
> + *
> + * Return: Number of pending I/Os
> + */
> +static inline int mpi3mr_get_fw_pending_ios(struct mpi3mr_ioc *mrioc)
> +{
> +	u16 i;
> +	uint pend_ios =3D 0;
> +
> +	for (i =3D 0; i < mrioc->num_op_reply_q; i++)
> +		pend_ios +=3D atomic_read(&mrioc->op_reply_qinfo[i].pend_ios);
> +	return pend_ios;
> +}
> +
> +/**
> + * mpi3mr_print_pending_host_io - print pending I/Os
> + * @mrioc: Adapter instance reference
> + *
> + * Print number of pending I/Os and each I/O details prior to
> + * reset for debug purpose.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_print_pending_host_io(struct mpi3mr_ioc *mrioc)
> +{
> +	struct Scsi_Host *shost =3D mrioc->shost;
> +
> +	ioc_info(mrioc, "%s :Pending commands prior to reset: %d\n",
> +	    __func__, mpi3mr_get_fw_pending_ios(mrioc));
> +	blk_mq_tagset_busy_iter(&shost->tag_set,
> +	    mpi3mr_print_scmd, (void *)mrioc);
> +}
> +
> /**
>  * mpi3mr_eh_host_reset - Host reset error handling callback
>  * @scmd: SCSI command reference
> @@ -2384,6 +2452,7 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *s=
cmd)
> 	int retval =3D FAILED, ret;
>=20
>=20
> +	mpi3mr_print_pending_host_io(mrioc);
> 	ret =3D mpi3mr_soft_reset_handler(mrioc,
> 	    MPI3MR_RESET_FROM_EH_HOS, 1);
> 	if (ret)
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

