Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86755C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 695116121E
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhJUOZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:25:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24240 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhJUOZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:25:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LE4Q6H005250;
        Thu, 21 Oct 2021 14:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NNKnaFefiDVqlTrhP8RxjYqDcqAfOOr+Pwd4JCI+DjI=;
 b=grGr9QkhFBw7yld5B04/Lk69rG2COkFcaC0akkzqJouGXobMtnSFf7Zz/VdY15tuaGlx
 HJr424jXiPPnN7DxFnIKTN7Bf3FV62aWIveJraamEwJB1uf7/W4qCv6l5d4lAZt6B565
 p8hVsI9dxNpP9M0ntyHaoBqV9wIRt0PSwyzee+o504iF7nsOK/NykC/Npv90zJo9p9tv
 tW6HNH0Hk/5Zj8lXa1eCrFJJiFRaNfjh4WpY4yXTGXQ9jXT4M47aw0RniWYvSS9BSmtC
 x2I51hBNQQzzJYhTQntDKpRbcM24S9skPtSRNrj+asLO5Uu3jXZ1SDg02dGD4KBWbVYQ dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypnf8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:22:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEGuNK196238;
        Thu, 21 Oct 2021 14:22:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3bqmsj85e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a49441M4Dqye/xHJJvOHc7S43JgkuCrhmUJphxTl9nj4j0lmqBiAwVEnK7ZU2cck94Hcp5+SiZ9VcclnT+ri8RGfNRe3h2FGxKWg8XOAtk7cr5yI4o3gDZQBiw4sfYy7Km4et1x3Af4YsouscGHtcVEvgFIbGLr+rX3OqsUPZug2Q6hJjwRjw8eGrRHd1fGZipIaw7XKla3YZ1uXmKQuiyTIObypllSDQbhZhQmokn3Y7IgWwqpizgeKROBRKafOpeKR5eeOrjNhNdIPBh6v2J6qIGhQ3l4zGynnHIJuREHwiUB3fdfujTz3pA/RNcICuzjAf1fS/SpJ/EiE6pOYlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNKnaFefiDVqlTrhP8RxjYqDcqAfOOr+Pwd4JCI+DjI=;
 b=RVN2E6GxWO1LURYgPWOAw1YXVzvl09uBzV4ZfwoV77mfCS3lSrOU755TEr3RxCpqyRthdRpRRI8MDtpjE4nOU+lUBDPVHGxEBa8th7gLazDYwsF3h2WqThkwSOukWq5etapgNSgpCPLfRSfAU/m6tk6okorMZ2MDSx7Y/coU+iAiDKxJYi7T4U3kcI19absIF+2LdAz7s2vMffHJZ/HGNj4cTnsQ3KlTa31K9MqTVqwaCJ6BEX4jfVYhAg2Z2EteMe2G7sTYyA6X29dyFvC3ErI4cDVY0jHZQa36oJiMxXpdqzZ7KQtnTZsrpp687ytMdYAEmejjLYhdeckuEcN3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNKnaFefiDVqlTrhP8RxjYqDcqAfOOr+Pwd4JCI+DjI=;
 b=AtTetRbFixjfC84z7zAQwL/9QSiHZnAhbYmnTHIjf8MzNrGv50ls3wJ+H1b5xoe85Oei6ZsC7FpgD/tfnbQJhHPpaLSwbUDxzENp2d3sCS4iQls31cNj1EXQDQTeEd6/dU02GO3fdtzFH5zODop8Ux/b4qvRwvzoaK69WslgsIo=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB2931.namprd10.prod.outlook.com (2603:10b6:208:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 14:22:40 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:22:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 07/13] qla2xxx: edif: replace list_for_each_safe with
 list_for_each_entry_safe
Thread-Topic: [PATCH v2 07/13] qla2xxx: edif: replace list_for_each_safe with
 list_for_each_entry_safe
Thread-Index: AQHXxk3T3OciQemiSEauiVc3FKx1UavdgZiA
Date:   Thu, 21 Oct 2021 14:22:39 +0000
Message-ID: <4E68B45E-A1AC-4955-8825-C2FAEDFA07C2@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-8-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 374c3345-ca65-4a7d-63b5-08d9949e3d1f
x-ms-traffictypediagnostic: BL0PR10MB2931:
x-microsoft-antispam-prvs: <BL0PR10MB293192805EBA35B49F8538A4E6BF9@BL0PR10MB2931.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0YEIpsORZPT1LPcSXODzjybVhewWXhHDTANqizbguvwo85BOXex7eDYNqV2jQs5cEYOmO5GO33J4StXPbkp3XzZSMxudko7upvQA3tLbhnzQ+PHta6fciCOFbaClRMpKV3T4Q6sj4f4DJ85qQh+xMIixSP9CQSwlJ+cBysbslQyeiiAMh0+gDPsJ+KrpsII09/KAuDfqJtl6IoLf4bHIpB8S8qN7/QDpQF8aaCAlKk0uvC1k5jWN4pzGMdudT2rBIE7NIsXcHvRjOS4WD9+g3E+vs2ShC6EXI875IWDa6OCRDO6dZTYWxtLMdFLZZJ2xg0Q64hWzEekIx2OTLFOAAMhaXVpuXdHapxc5N8Ifd1ZLkucF7GLSUrABG5oiKfKu/2LY5IqE7QXvIIQ72TO4bUxdDk6TvH5Q3yz73LGlFnVv6HYbbxR2RxpZ5qmzqMQR9IxTF1i1bPXYw6GaNSIN+FtVYs0HobmCJg8WlGmks1ygYfh0akVdZRYRyJMTacfooN1VaYWdYjj6LdASgLcWkyxDWIGjAtRrVDnuC5swlc4JfRAYavjdZA2r/PrEBtenT/nqBCvVMxIBLiLLJd7Xtig0zbKM0Er62qkuMPpeWsedi4rBCE7DFgj2Iw8ctzPIIWCgl9MMEJP696iUAj83bM7tknRJYTperzK8uzMvBr6kHfecmJI6qMS8f8but0Y49i+PmqzAtRxl5xH/eMYdlVjXXSukRkJxgbkJ68KSJU2RUhG8+KfolG0o0YQM/xfg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(53546011)(2906002)(4326008)(316002)(44832011)(8936002)(6486002)(38100700002)(6916009)(2616005)(6506007)(26005)(36756003)(54906003)(186003)(122000001)(66476007)(76116006)(66946007)(91956017)(66446008)(64756008)(71200400001)(33656002)(5660300002)(8676002)(38070700005)(508600001)(66556008)(86362001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a/Zv69ZobRuiZuUHMccPktwszZg8PFq6rqKnYSNTRAjDpgwv1qTN9Wnelg3Q?=
 =?us-ascii?Q?eHUBRlPXeBwpramlXxKLSCpuk0lnQ4mbF9+zT/T/rwkxuj2H9gNnmyGn+z7O?=
 =?us-ascii?Q?COMyVbD/4OM/P+OkUwV3jbjnGa/l0a661O7HVtlCZWzCELhCyJv3phBTp49l?=
 =?us-ascii?Q?r2kv8isX4ptj55ky/xzH/hI4vgyJm20mkNbmmLatndyj7alnwlo+WR9nEPij?=
 =?us-ascii?Q?+68REl+hr7U5f2BbmgzgPY3y6Y6iw6xh6VpIRtmdx5CMNLOOL0KT5oqAyem9?=
 =?us-ascii?Q?gcT76tEPtBw67D34wrZJJ+UncugviqM5bLrubux5xPma0drS4HS2wJLM8vq0?=
 =?us-ascii?Q?/eEAoyoFRnd6th3ZCv4g9ozvYL9nd9PVqaEFD/6kIqfWaGZEKJQneGUHa70v?=
 =?us-ascii?Q?aA3cyJs/k5afapfNENXQTJ4p/MLb//ZVi8C/lHeFHIIjqIl4rl3KMXcWaixa?=
 =?us-ascii?Q?z6uAnzNFCLlmyEubT6zstdcXO8jOiFr/Mfco/OYnU95Lpwb8mu89MBFkxwv5?=
 =?us-ascii?Q?oQL736pYFx0dA5dsxNhWBcXQlfEcJov0Jtw0mkzvm9ZXCoe2RaEtxpB1edaj?=
 =?us-ascii?Q?HOQWzj4Dz0HatHiQ4/5Hq58OitWCgFzwlicrp2xL1+e/ifV+aAMAeYiqk5kS?=
 =?us-ascii?Q?09JguobzAM3mVvkxB7VWHukwvyHM1QqFw0V68DUp8wVc4xg+/CX5/Rgxt8OU?=
 =?us-ascii?Q?EdDJLqdYP8MgNFGyql6CJXYC92zitLPrEEUHHWlODITQR3jWMlCjYCNvl/0R?=
 =?us-ascii?Q?KWIW+3LGm3SuravQ7J4r0R6aHwHNBMnlPP427crdKwQVNU+l/tbyM8OWf/O4?=
 =?us-ascii?Q?JWc3D76RwK8zJ1nBz6pIvyZ/ffh3pFkV8Y8Q5qqaEqx1+NaGg0CUBNSgpzZ5?=
 =?us-ascii?Q?/6axqiv8pPdtKEw4E66ZOU4znHtQPGpWEWjo6GSWALhTES0ZW9u532k1XPFN?=
 =?us-ascii?Q?Bk/gVSnehVWSr/JD/ZH2yYCQLbCvZ/7Myis45GIiU3b/BcwSS03RYsYXn3v2?=
 =?us-ascii?Q?l0JiYtvOdnGHjeum0CB/g3MURAl8nURmZffVtgCRL1TO7hVxAaM1540rUzPk?=
 =?us-ascii?Q?XfNyM4ms9iANaxefuIszbEsgzkdIq5Kgnn0iL58QbjkN6rYH0jMDRu1gspzk?=
 =?us-ascii?Q?73OFbM5dmYwHYDjkrbL129MrLIN0E7pmkRPrKN4vklfv0yuy6sMKVErkJPtp?=
 =?us-ascii?Q?V1yTRhfoOBkwGShpVdrDJCbQa9i6gtrgRa/AsCIlCFpAkSMuqXgs97BoRv68?=
 =?us-ascii?Q?6CVEm1ThK0+VgNe293nhRMTjROqFjJAD8CmfHR0iK0UMPcxPGFdkGVeQRF81?=
 =?us-ascii?Q?tdY74iLb+/+FxGDTYEcv0lwmZhWc6wCoEFpn0GsrRXwsU4deDiQNz9241GQY?=
 =?us-ascii?Q?BRMnOF0HqHJmcFaI5diKyF8BFQs26DquD5ITOuxduRNTk9y+h2y4tSnRH+c1?=
 =?us-ascii?Q?wrGZzWd8KSCOKLrSm5uedNu7GCBbzsFYOzM/7MR0p6LPBpnYwAKXow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <47B8F88048046F43AD6A9BBDD1E254A4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374c3345-ca65-4a7d-63b5-08d9949e3d1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:22:39.9827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2931
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210077
X-Proofpoint-ORIG-GUID: TKjBfRFRGsZwJ0o8RsFKe3ykiuv3vA6q
X-Proofpoint-GUID: TKjBfRFRGsZwJ0o8RsFKe3ykiuv3vA6q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> This patch is per review comment by Hannes Reinecke from
> previous submission to replace list_for_each_safe with
> list_for_each_entry_safe.
>=20
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 39 ++++++++-------------------------
> drivers/scsi/qla2xxx/qla_edif.h |  1 -
> drivers/scsi/qla2xxx/qla_os.c   |  8 +++----
> 3 files changed, 13 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index b4eca966067a..ca3b947770b9 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -1674,41 +1674,25 @@ static struct enode *
> qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_=
t p2)
> {
> 	struct enode		*node_rtn =3D NULL;
> -	struct enode		*list_node =3D NULL;
> +	struct enode		*list_node, *q;
> 	unsigned long		flags;
> -	struct list_head	*pos, *q;
> 	uint32_t		sid;
> -	uint32_t		rw_flag;
> 	struct purexevent	*purex;
>=20
> 	/* secure the list from moving under us */
> 	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
>=20
> -	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
> -		list_node =3D list_entry(pos, struct enode, list);
> +	list_for_each_entry_safe(list_node, q, &vha->pur_cinfo.head, list) {
>=20
> 		/* node type determines what p1 and p2 are */
> 		purex =3D &list_node->u.purexinfo;
> 		sid =3D p1;
> -		rw_flag =3D p2;
>=20
> 		if (purex->pur_info.pur_sid.b24 =3D=3D sid) {
> -			if (purex->pur_info.pur_pend =3D=3D 1 &&
> -			    rw_flag =3D=3D PUR_GET) {
> -				/*
> -				 * if the receive is in progress
> -				 * and its a read/get then can't
> -				 * transfer yet
> -				 */
> -				ql_dbg(ql_dbg_edif, vha, 0x9106,
> -				    "%s purex xfer in progress for sid=3D%x\n",
> -				    __func__, sid);
> -			} else {
> -				/* found it and its complete */
> -				node_rtn =3D list_node;
> -				list_del(pos);
> -				break;
> -			}
> +			/* found it and its complete */
> +			node_rtn =3D list_node;
> +			list_del(&list_node->list);
> +			break;
> 		}
> 	}
>=20
> @@ -2419,7 +2403,6 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **=
pkt, struct rsp_que **rsp)
>=20
> 	purex =3D &ptr->u.purexinfo;
> 	purex->pur_info.pur_sid =3D a.did;
> -	purex->pur_info.pur_pend =3D 0;
> 	purex->pur_info.pur_bytes_rcvd =3D totlen;
> 	purex->pur_info.pur_rx_xchg_address =3D le32_to_cpu(p->rx_xchg_addr);
> 	purex->pur_info.pur_nphdl =3D le16_to_cpu(p->nport_handle);
> @@ -3171,18 +3154,14 @@ static uint16_t qla_edif_sadb_get_sa_index(fc_por=
t_t *fcport,
> /* release any sadb entries -- only done at teardown */
> void qla_edif_sadb_release(struct qla_hw_data *ha)
> {
> -	struct list_head *pos;
> -	struct list_head *tmp;
> -	struct edif_sa_index_entry *entry;
> +	struct edif_sa_index_entry *entry, *tmp;
>=20
> -	list_for_each_safe(pos, tmp, &ha->sadb_rx_index_list) {
> -		entry =3D list_entry(pos, struct edif_sa_index_entry, next);
> +	list_for_each_entry_safe(entry, tmp, &ha->sadb_rx_index_list, next) {
> 		list_del(&entry->next);
> 		kfree(entry);
> 	}
>=20
> -	list_for_each_safe(pos, tmp, &ha->sadb_tx_index_list) {
> -		entry =3D list_entry(pos, struct edif_sa_index_entry, next);
> +	list_for_each_entry_safe(entry, tmp, &ha->sadb_tx_index_list, next) {
> 		list_del(&entry->next);
> 		kfree(entry);
> 	}
> diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_e=
dif.h
> index 9e8f28d0caa1..cd54c1dfe3cb 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.h
> +++ b/drivers/scsi/qla2xxx/qla_edif.h
> @@ -102,7 +102,6 @@ struct dinfo {
> };
>=20
> struct pur_ninfo {
> -	unsigned int	pur_pend:1;
> 	port_id_t       pur_sid;
> 	port_id_t	pur_did;
> 	uint8_t		vp_idx;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 3fca6b8bb23f..df0e46ef3e96 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3885,13 +3885,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
> static inline void
> qla24xx_free_purex_list(struct purex_list *list)
> {
> -	struct list_head *item, *next;
> +	struct purex_item *item, *next;
> 	ulong flags;
>=20
> 	spin_lock_irqsave(&list->lock, flags);
> -	list_for_each_safe(item, next, &list->head) {
> -		list_del(item);
> -		kfree(list_entry(item, struct purex_item, list));
> +	list_for_each_entry_safe(item, next, &list->head, list) {
> +		list_del(&item->list);
> +		kfree(item);
> 	}
> 	spin_unlock_irqrestore(&list->lock, flags);
> }
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

