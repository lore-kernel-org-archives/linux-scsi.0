Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391AAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C31D610D0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhJUOmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:42:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11584 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230483AbhJUOl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:41:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYVvw002974;
        Thu, 21 Oct 2021 14:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nyznLRZQcUnJaaV7Vc1/Bzmm6zgCxL6D1DLr2vudAQY=;
 b=Hsuo+5nybSlp9+h7Bdy2f8Aj8x/mxTUnevdTx9ouoESh8m2FpmP9lV7ToZhukbjCODpV
 Hx5zeu5TooOeoncX498dcEMcdA1Y5SwQ5H7JHp9gDzueb0J+H8oWokxAhTNr15CwWCOA
 L+PVq6Wl3KofynvmbPqUJcGfn9zN3paV4ZHbhI3ZAj8f7iLeToS2juDeL+EVBSF7R226
 ZrkrOwhVJTpSwDSX3cnurInnSFpEG8AduypmG2OgUZMvl3J4Z0cJz+T0pd8V5HKB0eSV
 +bQVEH9ql1jVDfXaPjUZ4Fr741tInvtvprDmEDcCaok76RjG07WP3BVQwjC/4BiBTjFb Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9y7cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:39:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZeR7150656;
        Thu, 21 Oct 2021 14:39:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3bqkv20wdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IC0RWCUwsqaILKrGFUyYQky0LAlrKGgjBOtkEgIQ+co1FLXZHO/CzXrfdBJPmpMTDnPoicS6iNEcaGHYKWhlVMSI2fMIAnaTziXBiONPBmYhL5T9cAVBgGOSbq3cGUY6i92TXuJdM6zq+623fkwz477K2OC9SrIFgJNKFcY5FxsjkqYVfrWXrd3u7uOGcCzJgX32t3r5mX0oXqCSpDZ8X9me8WCzqSdUzQcBhV/ggKeBJT7T7bCJmcX/MoNxmMt3jLw6uqcPajXSAFfq2NKAXwZLts5oYgS82Ux/YCr+B68pyV2n/yBHGlBZojAa+q2a0KONJPf8cXjtXIaoSnH8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyznLRZQcUnJaaV7Vc1/Bzmm6zgCxL6D1DLr2vudAQY=;
 b=IVbvvEKzZ4y/JIue6pQhLVZAay8+pyZHXopx2fGj6LravX8H03ujgqLI7s+UEkYgy1nlZjwXgM4zEQHv/1pWCWu7YFC7AdPwElyNtwFHgNMVb1iC7n3dAT2fJF6g5hW7rMS3mkJr+m9ICeJVqr6KEA2N9y9FF7eqkkrXapS3aPjhfcX04Yhzkl5TWDWeMTfapWS1aCxb+oe1pwnE2k5aYNvEPqSH8tE+kUHH2lz0PvFYfRyiB8oOvZMzXx7DbBZklcdszzdXk5geDecMbUClVNlRXV15MFX4DZ7L5278AhxP76Zf138w58pZTQM6BqQqQAbc/VnP6oPlNzIfKrSNYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyznLRZQcUnJaaV7Vc1/Bzmm6zgCxL6D1DLr2vudAQY=;
 b=HXZbcz4AH+sGMAYkE9MmOxrHZp2x/LOoLPpbS89qI0R9GlwEtnddhZBULDXx77TUETku/tnxzPWUX8tc3oPO5oo0b5SPgX5e1rmMwVK0XUW3KOT2cSv6lgixReKhEf/dBdnY6vlGRGISJYrUcXcvu3ZDVfBKybTiVdv2WyP+hfo=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB2770.namprd10.prod.outlook.com (2603:10b6:208:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 21 Oct
 2021 14:39:33 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:39:33 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 09/13] qla2xxx: edif: reduce connection thrash
Thread-Topic: [PATCH v2 09/13] qla2xxx: edif: reduce connection thrash
Thread-Index: AQHXxk3WtCv/fgL9+kCgR12D59xyV6vdhk8A
Date:   Thu, 21 Oct 2021 14:39:33 +0000
Message-ID: <16C2318E-D633-4F06-9AF7-AF3BE497D079@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-10-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ee77d20-ac9d-43ba-887b-08d994a09939
x-ms-traffictypediagnostic: BL0PR10MB2770:
x-microsoft-antispam-prvs: <BL0PR10MB277053141B6DC8FC39411A1FE6BF9@BL0PR10MB2770.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZkKKQIfOnVx2a4zVTFafdj7OXkCrd15owxt4pZ7devswkRzL3WsJMVIJhEK0xtBU9qJHAeUXnYcMpbS0oVBPB35SouyTCD5kHFp6f2mBAa/0SwPSJgGFnLeMf36ZleK7l4owv8OPZWqIQr/ato0w3gM4wU1qOWBXkBO/HqSffyCg4wR2spIg8FUcX4yr4UEm7XLx6nyp5emeWHkjHybe3rZoc3dP5o7L1sSM0mLyjKi0RAQFDGmN59gHmcYwk4QkkbJAu8ZhpzbNFLrD3fK0AcSL/JkIBUggXHUllXLIvrPvVANCiqzZcZiT+ag+8KwDmfr7lQ14sZMikFHyxcPg9kKCAJ43mqlnlChushhmmRsy6T/Spy04Zoxm8u+L1MNf29pQyBRdGf2Zps8iXMDYPjXfoYR6Q51D02Go0CM9pzBUY70/pPcsjvzibMu/CGyC+6+Uaa6n6rvakc6w+JHP7d+vb+KeKedHl2IRSSU8HHSMyV/OOn2MSrVKuNzv6/JIiPDRNMfn0CyYd96NLospNeXKgAUG1OMberElTEsaaHgz1CB6K0QN/KhY5G250IfYfNzf7gPZ0nKui1dpq/5r/VayOeWX+DU3oSSv9PRDan8EiSTE5bffgaDjpziOa1sjUwXIUO5HtgGHu1H985/Pxt/Ohywte0zX8+1+dW6UBE360GkF9SRkgEsI4sIQiDLHdA/f1Ih6SnVL3GGPnNspae50IcQ7zfwDDrlt+7DCdgY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(91956017)(76116006)(2906002)(8936002)(6916009)(26005)(2616005)(316002)(66476007)(38070700005)(66946007)(6512007)(5660300002)(6506007)(66446008)(53546011)(186003)(83380400001)(64756008)(508600001)(86362001)(122000001)(71200400001)(66556008)(8676002)(36756003)(4326008)(38100700002)(54906003)(33656002)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f2StT9zQ5c46Pn3QgsXRrnnOFGVL+76QIG+fm7JmR3eM4PUXwa6H4p1mdbza?=
 =?us-ascii?Q?IuuR3Mol3oh7NL7nJ9UrguDyTgrAmR9PG/HufYZm2WIFry+7ogage5RTsEo9?=
 =?us-ascii?Q?HwgGg3cSbf5BpMiqpwDBMrUZaxjoQYNj3KnjoRdXtSjkL+KeHBjEomSK7j66?=
 =?us-ascii?Q?L+BHjz2dc+EDJLNym57q7LxTL+OuDNlcMaU+2UjkRHptq29lboK0H88xVOva?=
 =?us-ascii?Q?o0IMnR38oQkiMcZdjgLi8SyBAWs7TGG1e6CVEiEw7Dc+rnCnIGznublcN2N4?=
 =?us-ascii?Q?MYXTzdce1mNm+kjtsQ2X4J5Sw7KZqxKiZmynmyTKpjpK8CXZei+HOx46U6CZ?=
 =?us-ascii?Q?ctPXwK8uk79mFsfIMv6DAnCJuuPzg6t5dpuBKzMHqaKxRaViQj4iHkRnhIui?=
 =?us-ascii?Q?u3F0E9qjUtX9pOcVn/BwbW7E7AxgoebDD9JO9tjhs48L8TqSweffRo4kIV5K?=
 =?us-ascii?Q?NZzRDvzWPX7+2W8UE47/bPUILneyDm/NaImysjc+lMpZD5Vj1FGB5rcoET+p?=
 =?us-ascii?Q?5ieKlySI8PsEdZhelHPSRa6RlPoMjxchCn7mzQkttx6uksj0hVoeR4vaFWsZ?=
 =?us-ascii?Q?Ny8I2jUEybMu+SbzIn5pcbLRxF9FIX6m++OqnvmqJkDPqMGu2FBxAoAQBgrs?=
 =?us-ascii?Q?OszefqU/8/+QrXE7JjVYaNSBmd2/AYZbxhFV8RonQMCJcOamxTpEK/ooYDZa?=
 =?us-ascii?Q?L72qawgsrwSC8B2Axl1t/N2TcFDzpvgXM5YYFRHLB8a2YBqwK3zD66okNyc1?=
 =?us-ascii?Q?6NxhJaqhA1kpDkL0VDPEElfty5EOeUWhgGwtZbLxBvVCA9KA7V/46ArEhsB5?=
 =?us-ascii?Q?YbkZfecqRh0LZVU2t700F4JxZKt5zDmbzylHjp2RNe2lg8jSunUxKuF4R6NF?=
 =?us-ascii?Q?FYONAxkudD9uu+DVBMjUc4hLtVLZwdI66KoweOrP57qGmdMWMadR4aHyMF+b?=
 =?us-ascii?Q?166d/8bMFE6iAInDuQeTJz3IpGnnbmMb1I+xtsBPGcSnN+yiXKI9s0TsQGLS?=
 =?us-ascii?Q?ze+IyUTU5AcT+AQZvPAyiQLzEOexqaGs2uYnKqpabGy41aGishK4DKh0GWjO?=
 =?us-ascii?Q?DK7udFY5rAXhkxk2RGdDMCE1OVhlxMqYKlDU5ZU39Hlzo4w+5dybtO3+XVsb?=
 =?us-ascii?Q?RDYHuqL781OrDhVEY+/Lx4O3kQwyrOG3QSYGvBJs25561kKAC8iNVGY9udyU?=
 =?us-ascii?Q?4w4ZB2gp/E1yvvgWeeMZe9SOteDjurWvUp5hMvG3ePMiVOUX6tmPLv9nlH84?=
 =?us-ascii?Q?tw0cFyU3vheS+0GcqT8gm+xgFvJZQDJbyZXI/ZzU1lbER0AaJiEZxpIxfxh0?=
 =?us-ascii?Q?QBo8XQRs1cY8vBLjNo870ywuUu2AktviOOitJ9C4aRayxw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E798830C28E8EB438E567BC2DC4072B1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee77d20-ac9d-43ba-887b-08d994a09939
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:39:33.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2770
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210078
X-Proofpoint-ORIG-GUID: yYilEefpwo4Kkof0EmiPe1Cue2jwoPCr
X-Proofpoint-GUID: yYilEefpwo4Kkof0EmiPe1Cue2jwoPCr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> On ipsec start by remote port, Target port may use RSCN to
> trigger initiator to relogin. If driver is already in the process
> of a relogin, then ignore the RSCN and allow the current relogin
> to continue. This reduces thrashing of the connection.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c |  7 ++++++-
> drivers/scsi/qla2xxx/qla_edif.h |  4 ++++
> drivers/scsi/qla2xxx/qla_init.c | 24 ++++++++++++++++++++++--
> 3 files changed, 32 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index cb5f2ecb652d..41a9fb04b663 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2757,7 +2757,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
> 			if (fcport->loop_id !=3D FC_NO_LOOP_ID)
> 				fcport->logout_on_delete =3D 1;
>=20
> -			qlt_schedule_sess_for_deletion(fcport);
> +			if (!EDIF_NEGOTIATION_PENDING(fcport)) {
> +				ql_dbg(ql_dbg_disc, fcport->vha, 0x911e,
> +				       "%s %d sched delete\n", __func__,
						^^^^^^
Same comment as previous patch. Please use more meaningful debug print.=20

=20
> +				       __LINE__);
> +				qlt_schedule_sess_for_deletion(fcport);
> +			}
> 		} else {
> 			qla2x00_port_logout(fcport->vha, fcport);
> 		}
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_e=
dif.h
> index cd54c1dfe3cb..920b1eace40f 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -132,4 +132,8 @@ struct enode {
> 	 _s->disc_state =3D=3D DSC_DELETED || \
> 	 !_s->edif.app_sess_online))
>=20
> +#define EDIF_NEGOTIATION_PENDING(_fcport) \
> +	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
> +	 (_fcport->disc_state =3D=3D DSC_LOGIN_AUTH_PEND))
> +
> #endif	/* __QLA_EDIF_H */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index dbffc59e1677..999e0423891c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1793,8 +1793,28 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, str=
uct event_arg *ea)
> 					fcport->d_id.b24, fcport->port_name);
> 				return;
> 			}
> -			fcport->scan_needed =3D 1;
> -			fcport->rscn_gen++;
> +
> +			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE=
) {
> +				/*
> +				 * On ipsec start by remote port, Target port
> +				 * may use RSCN to trigger initiator to
> +				 * relogin. If driver is already in the
> +				 * process of a relogin, then ignore the RSCN
> +				 * and allow the current relogin to continue.
> +				 * This reduces thrashing of the connection.
> +				 */
> +				if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> +					/*
> +					 * If state =3D online, then set scan_needed=3D1 to do relogin.
> +					 * Otherwise we're already in the middle of a relogin
> +					 */
> +					fcport->scan_needed =3D 1;
> +					fcport->rscn_gen++;
> +				}
> +			} else {
> +				fcport->scan_needed =3D 1;
> +				fcport->rscn_gen++;
> +			}
> 		}
> 		break;
> 	case RSCN_AREA_ADDR:
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

