Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1830C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiACAqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:46:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61754 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:46:23 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2028cVFi007165;
        Mon, 3 Jan 2022 00:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TXTmgY16WppwHaB+4+VB98lWQc1ZKCOEU2drW25QaeU=;
 b=IXY87pv6717yaICIDwBEY64JHFSMgMUysNtZZWun7WId5CYg6d9seUH7lDx5E2CmkxFO
 D54a74MT4qWs+78wzWQU8KOu3cNO+SsmYoIAjsHlMJJCyP2rXMVpJAZV0jAvyQcp13WC
 PpSGTqSrhkdoZzbUea9EyTSxMpLfKQBz997y1bmRriXYqTEMb2MkqzyuZ/MB5f4pWd8v
 GJl4vvf/+vk7Z505qS3ExGmru3HhsvElMwMEXAQR8aMM8KpVDDUcThYvGviI3AEf/PVN
 Lzz5raiGt1LK/dF57X40uwrvIPPzXbW5T4GBEYrN3any0Cv6ZICro+x4I5i4fMT2TWQe Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dadcd1qut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:46:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030fVqc190288;
        Mon, 3 Jan 2022 00:46:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3daes1nndp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsTPGi9anGWyvoeCN1bIbSh8OgWsqXkrahbm2Wm+THa5Qi2wdDQyL9dYyhds62CcQQd3zuMT1uS2BEROZD1+oV6rZhcnPhepxGOey8ubyNSPE5PC3cVOSvfw4l29Eb0MrM95KtO3ZGNfIf1BA6K72dzHryB1lebDLSQj4SG0FaWlRbCsfQtA+NZD+lDQeWOhdP39bGGXN/DEf6HqUxWiWCgLmVfOSVHnmJ30qwbM9odD9dI2W/+pxmpXjAZVbPcl/Ag43U8dpC50J5HRbjVEJfb68+eeu6mvQVivuonq0RSQ+4kjjjBhVvEav7/+QuTQ1GgEOtcSzOOhft+GcH57zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXTmgY16WppwHaB+4+VB98lWQc1ZKCOEU2drW25QaeU=;
 b=NZE3G86MpMxvsbG2pQ8ooxzTTiZpqls9AbxCLjQgWd7M1JcH8BJEuYK7rfUsH/TrVnqHlUR3QZ6DbOMBTaED5wj32v5NPw8hHMXg1KKVQ2KbxaCyBW2t8O/ZFgglY7o6SYcF7ZYWncJfnkK7XDJ5VObOS0HTYHCOhCC3tdKmbk25u8Dp6zYOtBPjJFJjVwfxFTtviEsEInKyIU8PQnGXvS+GHjpeSuGzXpMg+VsnLzC/fHOFbRE13BYlj8N7AZczI/lR/Dg+RfGVzzbtkmOpCW2dmgDymHI4lmi6FrIfz1simHTF9MBgEmUgez7zlRU5flmH0R3UZe7953p8dGQSZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXTmgY16WppwHaB+4+VB98lWQc1ZKCOEU2drW25QaeU=;
 b=GcA1Uxsb8EFrj8e9t8V+K2oGhcv/ixmCbrzx0jBefaloepdWn/QDfICTb28KqPt9GUKaTRqguX1fVUHn633BnB2Am4k/8giKNsk0g7dKWjInCd1FNm+B5iy0JVc7TKBFtIue9D/v6kXRMn6Vtk6YLpAGm811MFK6VgDPhmEv8pc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:46:17 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:46:17 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 10/16] qla2xxx: Fix device reconnect in loop topology
Thread-Topic: [PATCH 10/16] qla2xxx: Fix device reconnect in loop topology
Thread-Index: AQHX+JUAfH6HcD0eYkWT2smxdGNEV6xQhXYA
Date:   Mon, 3 Jan 2022 00:46:17 +0000
Message-ID: <4B568028-AF98-49DA-BF6B-8DF75083FA1B@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-11-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79edec20-107a-45c0-0999-08d9ce527399
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB5710487C9893162BF1AC452AE6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uylSsWIObv5SBAjKvfPckSwqJhMa/p27Eao1zfRrhdoSqqrqK0dXbn3uPw7Bw4ycKf6UP9kWio/Mx45doM3l8tT1dl8csNALmfY83ifZHuttNYcU/P6EXFGI5OcZTHhlBenGf2+UWY/DEKNylMmrBavjanbCGaGk0E5sfURXKWtR6aI5AWLc+2dhzNjybIcfZzjvbddRQCAtZ0Qy0m6lY/EDcuv4wkg+2/l9QCubvm05wLCOU3oDp4HPFGqsCKGFHJ3MNzHrWI6kfC75LoMfZrRIzRYgbZD/KiQxs+KvoI5Ro0QUqDngycz5yvCWFg43vFJrtpmqnfMxsF4nKtLr1I3+0DgK77u1F+2TCTdhNHdl3zzIDF/8knvfilbw+4PA1FyvLTSFO1pa64snJfcP5ixcE9kAwHqQXEEX+SWO9ZCMej9Y7B9Q1wy8FSF+yDQH+zULy9JFqsczUnoGU2EnDJ/5pV38q9CROX5Ufwaz5EXkB0+z4cWOYnRAlsmUdFJQMiUdLr/l7HJ7TK/JQI8tBxeds4ITZVqsADbGA4iCSOf9l3aXeN+1z2SA7GxA/BgmaVeUXXgixskhpO1O5bi9iDQXssd794Do7DgmMsJZTnbJClAKMPRsla+4XlepWnzaruBgy4KeT+WevVe7aRRxms8b5i9VxpEgRzTwYt5EtRBWbCE1NTlK74E6ccuH44IW/tJ0vp/B0qIrZ1ihEOvayh54DM+4HEnc/wsPhwOCIcY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(71200400001)(122000001)(64756008)(186003)(66476007)(86362001)(8676002)(26005)(2616005)(38070700005)(6512007)(83380400001)(316002)(53546011)(6916009)(6506007)(66946007)(66446008)(76116006)(36756003)(44832011)(8936002)(2906002)(4326008)(6486002)(508600001)(66556008)(5660300002)(91956017)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ScBoAumqd7tc54LbRpY9A9BYE/kZPQ+zxLQFd4mdVcwR+HkV9PIBxmOP/+aJ?=
 =?us-ascii?Q?IJX1BfQ0CzFKjMTuvSMDGlxh5AaZ9rxMTPzdTbJkfgVrLOc4bo6OJimYK8eO?=
 =?us-ascii?Q?MoGLbcIWbpZpFDh+3DAcGKnTvboSaF5Y68BHa8/NHaEepocxipic2eXbUujW?=
 =?us-ascii?Q?iMkQCX5ksgSr8epyxQEe0hAe0WGThPXq5aY+e2Q2MC3jFDc1YOiD85q511fE?=
 =?us-ascii?Q?/1N+++SaeMGCBPNzpkq+puqHmYKPXAs7hlYEt+hKviJp9M8KRe5sHipv5Qk8?=
 =?us-ascii?Q?J+ebqWgysBeao2QVZfHm+uYf86EARAPguyu2uHs0ObVHFmZa1g1k4iIKayFa?=
 =?us-ascii?Q?G0LJ1jBrnhiKg0AklC+BgTnshhe3hzXrn/uyUa5kjav/qPKFcaN1bup1y+Sg?=
 =?us-ascii?Q?W6+B2W5niJCUxx3Q54H+AqA6jDUGNX+2tj85OdBrCCh4icI7xSOEBATsFYBx?=
 =?us-ascii?Q?vOWslPlIeAFHnF5o49BrnzdyBSaaUVqK8/XJXOohPyHR6LU8IkyG7Nhcq8Qp?=
 =?us-ascii?Q?uBPBD/msv3DJLlnLex0gBQMMnvWttw1eXiH/5wtLc7/UjdPkd77t1EB+h/UK?=
 =?us-ascii?Q?UlpphK2XFiITQu2cQdDJhcdyDy0xZNE/h0F/9q3im7YFWsHNDq9EaX3Ff5nX?=
 =?us-ascii?Q?4ubGPn1HUFRPBPPFB7jvn9QPBS3eUMbVRJYhXeD5BmB8l8dQGndAsdg7E75X?=
 =?us-ascii?Q?56vPTBnFrvaoX8ZBZ2ApHIrsXbXf93O6mJushVrwHDvGxk1xw/dFh9PM/pHL?=
 =?us-ascii?Q?FyhFU2vpAB8YpI4pmz1/3O39dn+oQ6tSzE04vqx54GzkSVEcCasb58NwcGQ+?=
 =?us-ascii?Q?JiXGqSaQiAJq/avjymC0Yy0uhIvkYbxp0fwzJMoKJc2nNJ238rc5rs1084ns?=
 =?us-ascii?Q?lr9NAotUtYBbbKhIZLdULgddMhOiqh8x7ncwxjIaXOu9Mi9RLB5lyRQzTrxK?=
 =?us-ascii?Q?+xnfXBfdgLafqyZzPaCx9Tjh5msd0redrttquIr4OG17zmg/+5TzkzgaC7Vy?=
 =?us-ascii?Q?C182LzFh6hN6lijzYW5V26Bx+ByBRLAav305/ZrWR3tHTeNVQcf7CfaJ+YTf?=
 =?us-ascii?Q?FelCaiFCor2vLPW/a9JL3nT3xmWdXBHboclCKZ9PAR6XE6pOKgi5VivKAbFQ?=
 =?us-ascii?Q?GDs6MEt5qV+/7SZ1z/AnoAQM86xPMG5eLi2ZJ4+415eCbTkUNRwFwftWR0Yp?=
 =?us-ascii?Q?irpvCqmsC9ElfJmh6o6afaH1Mbe8mDsj+RqKoZHcxOWo1Z0C461Qwuao9w1H?=
 =?us-ascii?Q?tvuwD8mkjgmtogq2AhmvOfsjQsBMTveG1xcKjKqlVnz9YMfV9VbmZfOtnGjE?=
 =?us-ascii?Q?wgosnOiDZcxeaLZaXsQoEDGgAZbWVm71Cn3tz3BQu07y02OIdqCw+uHMKGwE?=
 =?us-ascii?Q?qXE4SJ+9hd9Vgl/Znpd6CkrZpwuxWhc4DM7kKqRotLiBhn7qRte+nKHb/U2D?=
 =?us-ascii?Q?RxVWK2M/TyeWPbT5CWN/yGi31oODrgH1AcR7GNXMCSb/zHF2gtHxPOHUbFp2?=
 =?us-ascii?Q?XVgzxFceBElJs5qplc/GDEcD6Zb0A9J7CrYDZHmV6nW70cZr0GAwRQ03uR81?=
 =?us-ascii?Q?nlYO47kH9wRlXG7yQUOHKSSdluMGuloi9YqShB2qMqBHK0yNhZFBTfIR94QB?=
 =?us-ascii?Q?RCvvTkcLVrd4wKcmusdYlkY/w+n7jqbHjWLLfVeICITgEjWA7IgNkScgBmyr?=
 =?us-ascii?Q?21BO4vFBC6TL3og/0rHSZqfJ1Nc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72F4ACF5E2085D4D98478FF77E3193A0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79edec20-107a-45c0-0999-08d9ce527399
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:46:17.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3NoO3wvHWbTWXPV6NODCcAfN2kReA12GIZRXV/ZZeuhWs9r97dwtmu6jCnn3dzNG6T80E1/uee/gdeh0QK3LHzcLdMYruhT7zcTCHWHfRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-GUID: 4ln8qkB4nIAHhb81pFIgIXuw8QzLu7XC
X-Proofpoint-ORIG-GUID: 4ln8qkB4nIAHhb81pFIgIXuw8QzLu7XC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> A device logout in loop topology initiates a device connection teardown
> which looses the FW device handle. In loop topo, the device handle is not
> regrabbed leading to device login failures and eventually to loss of the
> device. Fix this by taking the main login path that does it.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 15 +++++++++++++++
> drivers/scsi/qla2xxx/qla_os.c   |  5 +++++
> 2 files changed, 20 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ac25d2bfa90b..24322eb01571 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -974,6 +974,9 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_ho=
st_t *vha,
> 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> 			}
> 			break;
> +		case ISP_CFG_NL:
> +			qla24xx_fcport_handle_login(vha, fcport);
> +			break;
> 		default:
> 			break;
> 		}
> @@ -1563,6 +1566,11 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_h=
ost *vha, fc_port_t *fcport)
> 	u8 login =3D 0;
> 	int rc;
>=20
> +	ql_dbg(ql_dbg_disc, vha, 0x307b,
> +	    "%s %8phC DS %d LS %d lid %d retries=3D%d\n",
> +	    __func__, fcport->port_name, fcport->disc_state,
> +	    fcport->fw_login_state, fcport->loop_id, fcport->login_retry);
> +
> 	if (qla_tgt_mode_enabled(vha))
> 		return;
>=20
> @@ -5604,6 +5612,13 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
> 			memcpy(fcport->node_name, new_fcport->node_name,
> 			    WWN_SIZE);
> 			fcport->scan_state =3D QLA_FCPORT_FOUND;
> +			if (fcport->login_retry =3D=3D 0) {
> +				fcport->login_retry =3D vha->hw->login_retry_count;
> +				ql_dbg(ql_dbg_disc, vha, 0x2135,
> +				    "Port login retry %8phN, lid 0x%04x retry cnt=3D%d.\n",
> +				    fcport->port_name, fcport->loop_id,
> +				    fcport->login_retry);
> +			}
> 			found++;
> 			break;
> 		}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 7d5159306112..88bff825aa5e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5540,6 +5540,11 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
> 					memset(&ea, 0, sizeof(ea));
> 					ea.fcport =3D fcport;
> 					qla24xx_handle_relogin_event(vha, &ea);
> +				} else if (vha->hw->current_topology =3D=3D
> +					 ISP_CFG_NL &&
> +					IS_QLA2XXX_MIDTYPE(vha->hw)) {
> +					(void)qla24xx_fcport_handle_login(vha,
> +									fcport);
> 				} else if (vha->hw->current_topology =3D=3D
> 				    ISP_CFG_NL) {
> 					fcport->login_retry--;
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

