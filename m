Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCB1C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 16:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiLOQyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLOQys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 11:54:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F78F389F2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 08:54:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn1Px014327;
        Thu, 15 Dec 2022 16:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=LokTTsGl5YYVhRxbnie4ltj2QinaaZG7dLic4+i8sUA=;
 b=qBbdTtTVw5BsFBkb3ZChELj0CTL9GYm2Rer3FUUWvR0IF8zGtJYLwCIKcmz4dxq2cgpc
 uvxZQb2K1srgo1n9UIUc6RHA3eR420IpED2aNwOYcUU6nWBDLZY3o3/n8U8W3fU1ll2D
 y4GOe0gMrU7x8G19+trkkPMyF4PaKxkq6cFlVYP0lIUlJpXP4wHK9IXWFYJOlWxi4Z/0
 zN+zC50ohX8dUzO5579WeeRqvIAxeBWoE32lMI6/mSNMqXqec392kdxHEei6Ux2AKk8R
 an/Rlvtu5TXv8TA/NZAj4xsjdn/pZiVgW3uKgQr2GtX0DnLjM8Q6PK5jWIBxF1PVpcNm Ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerwndu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 16:54:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFFmbjR000415;
        Thu, 15 Dec 2022 16:54:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeryyt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 16:54:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdypwQVIVhfaG11uOvAgS5TQ3y/5lejx4usdtveC1AEz94K2/LmbuXrPjtb7wLjOH6es5fdcwK2zHl11rJF5KLI5jUDg4OH1SjB+hgse6w/typMcNzY9h6mYhZhJahzfoCOoW0/iT7WgUW4KLq5HrDS1QJHiMWcyNyUW8QhLU7sUJYCH2TlcibbZguGd0DOB9ZQv8a1PU22pnr6E4VQalZphtW2XUkdD2klmB/aGsG4/7VhbACR6CA6cqHoDxDhTzmSALjM6YWMs/PmR+2FwZzHz5Qn3HDJrraAk+5SxACUOpRqULIUtFNAmlKqGzkn+45t7/Ky4HfR60y/twVQviA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LokTTsGl5YYVhRxbnie4ltj2QinaaZG7dLic4+i8sUA=;
 b=AjXlwlu588JsCQX7TIyFQOk9ARL66yKBi32IBzFrGX/0K0kh6B5kSSDBFXpb7YYfjAXeP7llpzPdYHT2wkK1pOPnJA03ipoAP1rvaJbccrqzi8TmKxzprGfvOJ6IuEWKpkJWQzY4iBuVuqsPiTAZs7+3WQXe8ZPTHKZ9NHOSE6Sm/ABwX0T/mgJB0/TT4DmCnOe994d/iYjYhggyz5ADkWGMm+kKAIOSVt2SG2g/2+RRy1tdBVgY2SbdOwJLvmaWVFsaX2iUbUz4Zv6pmWiAhN7pX7t1HObUiDsqFwRw65yA1eX/ebtITw8HplXbIFHeU0kxR0bWUAYx41u+W9oFDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LokTTsGl5YYVhRxbnie4ltj2QinaaZG7dLic4+i8sUA=;
 b=jKKLlVb4Iw1ohm0X+P8ELA+4tV81LisP2EXcpz0anB4hvsGOBhx8vTm1T4qgl6w6pvQUNuLma55NuHSqQYg5GFt+C/5e5Q6KjvRTjIFH6kvaJ4jmLRFE9I1SX+9FjRWJTmnzrQqE2tP8GfwaoGM2T3G4RNPYneCTvZ3mKIIaIrU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB6987.namprd10.prod.outlook.com (2603:10b6:510:27b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 16:54:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 16:54:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 01/10] qla2xxx: Check if port is online before sending ELS
Thread-Topic: [PATCH 01/10] qla2xxx: Check if port is online before sending
 ELS
Thread-Index: AQHZD3ed4sbtL/8DKkSrGkxXO/y5eK5vLOgA
Date:   Thu, 15 Dec 2022 16:54:41 +0000
Message-ID: <3504B995-5DFE-4479-BAE7-2E94D187F13C@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-2-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH7PR10MB6987:EE_
x-ms-office365-filtering-correlation-id: f9cb73e8-932c-4075-f0aa-08dadebd0f32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pUb00xUQ1X5yYGTKtq7L1/iAjjSnjysn8b5qlHgzM26bSqoAU75G3FX0j51xxKFOrfNPxBJJreHi1S7zANUukxyyXgALhoh1hjXxk1fopZ+dm5VoO2L8WdwbXJCrTJEe8NDspiFUE16YgOhEK4sp+jxQ89CKPbuTDfndIa4+ShjXh2o0jO/x1VKzxg/QHWipV59U1PHwSTgWXzt6mrTqiBG3EwQ0ITW2iNUInZZmt7mEJPdVgALggiSX5KXsx2PO4NqdBNG0tFl2bMNMLQz+Rsbyq6ASBoO9JzMY9AAXJBz0JDspYoME7ryrMV+MAtnsjsEX5jbHq43LiatOt7ujUyKBZvnQsw/rrco/u3NTBLVyMVj1nBAJVn+DptrTtM222w0aK3X/STjmbz8wKsikj1u3be/rR6Q0yheabwEZyx8rjFKMhTAfgudEdUqll8ML9BNERO/clC7gceabznpkPuFzy+Q5dOVQrT2PCb84Pt9YPLAw+VSpmLMgMOc0DU/xbSwIFhtwEo4kAppoITDP8gAIeGu//+qIdXMs3IqiBISN68KQ7X1xUAZTfw0fnWZwctW/d8qQjUoD1/S7+RyS1Mad6AHCdghawbHu+L87U88I0+kcm5WEVrD3IeK7VsFzqXE6V1npdXAqWmVMDRKwZgX60RvRE0YVCL2ZWJ/8AcahKLMcgMHinSEmMeHNB8gAsPFfpRDOH3B6wwk2Z6XKW+L6xqXZATUmpQDDNi9G2v8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(36756003)(33656002)(2906002)(38070700005)(8936002)(5660300002)(41300700001)(6916009)(83380400001)(38100700002)(122000001)(86362001)(478600001)(6486002)(71200400001)(54906003)(44832011)(6506007)(4326008)(53546011)(76116006)(64756008)(91956017)(66476007)(316002)(8676002)(2616005)(66446008)(66946007)(66556008)(186003)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?keOnK6qUv2kGxfKhy21OTocBQvG+XFBiACY/LVj1n2q13VvA+9LwJsnHpafJ?=
 =?us-ascii?Q?dhpKsghwX+pwR2dJjg3ZhQpw9RgW1uIM8bOedezUKxuWuLx5Vjbzt0Xp1Ek2?=
 =?us-ascii?Q?KbfE+60KznkATaTpz4MkKiLngpdg+qyj1KG1FcbyBfpBbInn0nqocuN3KyVL?=
 =?us-ascii?Q?ilG1f3jHVmEPBtoT870tyfmn6hmbzEon3nrbXmUGgs2q7qQOvlDdGqpNxAG1?=
 =?us-ascii?Q?yLSkIveb1i8vO/AQzF/dkvrvBoV+96bi7GvaBl2xMoYmtZY0jFO4d/Wj4sEE?=
 =?us-ascii?Q?QbSg0M0x7AU3YMfEzP/IsIHVV9jfxLdlX4ClTXqoAjLDJ9WyeYtLwtw/Y+H4?=
 =?us-ascii?Q?cSX7ptxeDfhny8udIuKLe7fDb+XiIx6IQRdZZVDbRc0/TRpINsF4jGutkMIQ?=
 =?us-ascii?Q?nbbk47i4SgMAxwXnmVBkwt9j08ofHh5bzKRzl6jGAqktsRAE/OdGC8iJFfLH?=
 =?us-ascii?Q?MYyjFp8KxrB+vBMpR2OP7VfPWnq6Zc71cfcIEeymxWlUOH8keo+XqmThK1Pp?=
 =?us-ascii?Q?xXA3o1+6ZRvEQm6RCgaMm+ODTgfLA6ZpLJ9eZOaPAJPMh4veKiIqUBaG61sV?=
 =?us-ascii?Q?dlzoLfp5Sf8W1Io24qTjVyAXsrN4/zImPiIZ+HM0EpWCsDXlSdjeM2u85e7j?=
 =?us-ascii?Q?SzkZ7lhiQkrp4ephjM4pVAN4LzfnxAa4PEmk9/dNU2Fvseo5i23qEKP11gPq?=
 =?us-ascii?Q?LixhH75gDHrFAxWypO4upHgvfJY5W2U1CfSWLoVPEoWoKNNSjsndtCJYQa3m?=
 =?us-ascii?Q?RJhJfPP7P5/uAItKqTRxcbvcwQJKBjM+7+u+7oQbZ+OS1raZAAMuW0hUfond?=
 =?us-ascii?Q?qwYBcgbK8ekc8CvrxtyTizwI7CnQhlU/Tx4MhyoXP23qCcpi3p5+wrQ82vVA?=
 =?us-ascii?Q?GI+yeXZ1ewFA6+nyPNI9HH4aw+Y+rgtBGkh2Si0+Egd4eayHOu/6K25+5YiX?=
 =?us-ascii?Q?ZDeK3ylkidQquCt4PR1ScLGDKzAQ4T1wBWij8z0OzgrDF+Yr2gPxs0Qhw49c?=
 =?us-ascii?Q?QqDTkrP1TEp9G2ONA60hZUTCPeK2RM6r1I5nDCl3tN/fsUifg1WGD+yJFuEJ?=
 =?us-ascii?Q?+yJrXFs5MYXtGFwN+UmKvJSYvf9XbM54fhyCWCYllwUkZGT5SOQGm2+Wut0g?=
 =?us-ascii?Q?SjRDpzh1tEnMH9yHiSOrJK0EgmO/Cy9f8gIfwimJ3Ta6zOL+uqZjpgU5If7U?=
 =?us-ascii?Q?+LcX1CMcUYbGWNZCAqpFKxJrfQkFDlAQ38PNxwlxZqS+LoVb7/qHE2N0g+00?=
 =?us-ascii?Q?90Q2quPkokoDVy1Lr0tsYzUdCl39USBWV8bdwUy+DEPgy2rBNgGrXIWg6b/C?=
 =?us-ascii?Q?m9C4OOAKnP3BijiaWgjP6s0iO+kEas8lPLgsQmImQAAl25x85+ihGYK0G8qC?=
 =?us-ascii?Q?0CiWFFPb+sm7wGHfZPmOnFdz2JGNzZcITqUL5ahgmw55XiOyXBiDSczJX02Q?=
 =?us-ascii?Q?+Arg9yKJ4WrEeSDqbIu5k0/pOcY7qLJV8aJALwcqGPe2D8m6z6loAI/W+2Is?=
 =?us-ascii?Q?OkVyaAsme6SiOOZA2q3yyegg0Jw+kGoQwnoiVI9fXPYrDH7lLDn5x1rTX5kr?=
 =?us-ascii?Q?ja+TjIo88xNdLYaWLpzSo9ANLpgp8oCYIaRwr3ZVErMfEn1REnasp/lffDzZ?=
 =?us-ascii?Q?GO4bnxBDYzW/qLMVG8/p0qcbNemTm1C7IJEmn6fDUXHQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8BB4B24C8AAFA5449F0D886AD3B8DD6E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cb73e8-932c-4075-f0aa-08dadebd0f32
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 16:54:41.0903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtnNkk1s4g6wGwbJM+WNY6l1uABirlx6npLlR+AjG7BevSs0CaHzIp63evCYdxjl281nHw5TKM6Sba6eAu3vDwbgTDjAL02YAKTDDYdIUac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150140
X-Proofpoint-ORIG-GUID: ukcpq5ddzRBIc7BFmXf9SAN1shR1xdUc
X-Proofpoint-GUID: ukcpq5ddzRBIc7BFmXf9SAN1shR1xdUc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Shreyas Deodhar <sdeodhar@marvell.com>
>=20
> CT Ping and ELS cmds fail for NVMe targets.
> Check if port is online before sending ELS instead of
> sending login.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index cd75b179410d..dba7bba788d7 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -278,8 +278,8 @@ qla2x00_process_els(struct bsg_job *bsg_job)
> 	const char *type;
> 	int req_sg_cnt, rsp_sg_cnt;
> 	int rval =3D  (DID_ERROR << 16);
> -	uint16_t nextlid =3D 0;
> 	uint32_t els_cmd =3D 0;
> +	int qla_port_allocated =3D 0;
>=20
> 	if (bsg_request->msgcode =3D=3D FC_BSG_RPT_ELS) {
> 		rport =3D fc_bsg_to_rport(bsg_job);
> @@ -329,9 +329,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
> 		/* make sure the rport is logged in,
> 		 * if not perform fabric login
> 		 */
> -		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
> +		if (atomic_read(&fcport->state) !=3D FCS_ONLINE) {
> 			ql_dbg(ql_dbg_user, vha, 0x7003,
> -			    "Failed to login port %06X for ELS passthru.\n",
> +			    "Port %06X is not online for ELS passthru.\n",
> 			    fcport->d_id.b24);
> 			rval =3D -EIO;
> 			goto done;
> @@ -348,6 +348,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
> 			goto done;
> 		}
>=20
> +		qla_port_allocated =3D 1;
> 		/* Initialize all required  fields of fcport */
> 		fcport->vha =3D vha;
> 		fcport->d_id.b.al_pa =3D
> @@ -432,7 +433,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
> 	goto done_free_fcport;
>=20
> done_free_fcport:
> -	if (bsg_request->msgcode !=3D FC_BSG_RPT_ELS)
> +	if (qla_port_allocated)
> 		qla2x00_free_fcport(fcport);
> done:
> 	return rval;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

