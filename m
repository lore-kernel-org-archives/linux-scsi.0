Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A135C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiBISzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiBISyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:54:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C448FC03FEEF
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:51:02 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HFfu3017435;
        Wed, 9 Feb 2022 18:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RXDt1sMXgJzoI3jUWBPTjZgoyhtwAMupoNU7W2A1Sog=;
 b=KvKcWUVki5SLD84r3oUHp6hGGqNGijwfkDjiGUfhx1at/kVy/ytyCgbkc1nSNvqUL8zv
 wm0OUbzlDZflHMoam6N9lptuoABGL5bdLjjwr3qqDZMQ45s5CYwhU1Kq1bjn1RcFGKOO
 dnMZJkNZUED6Dv2znR1EzzG3ythJp6b/aqrxo5Hx+leAg9UU23dALS6yRn19yLCi9SUE
 978ATbYUJIvJh+SSrJ3/GrPvh8rNO/Abs0BQujegMSgsf6XSjo/QElxnO8NK1dzGO+z7
 iy4JKQ6iu0QoxO5SWwNMaMXwnTdYipKHr8lWUAD0deAxfkOA5g+uwtm8FGmnqtjIW2aY rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28neg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:50:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ihx1e184580;
        Wed, 9 Feb 2022 18:50:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3e1ec374nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra8Gg6XWKm/qzkz/sooPvs/KD78/RYQWiJgQPCg38DpvL03RIOFPuXM1EnUTekHRFF1gxXp2I37xy9k2dm3tqosDQyPDbBIVU4n8UpydbnChFrZAVs3lfd9B9AXzRFoOkb3c/u54X+iJom0+rejSihzmh4W2p8aKrnQIU91BQAFQmyeOEZ+T6IpA0qApBBSnNtsjy4Wy7enPPAqOqZ+WZjPLSxvgNj8OJ7yvr51cZLUuTMeqeLTwGdSKZKYtafg1uP2rYgz21WyY1QhzBVtvogC3Dd1Ru9V31G15O4MPA3udvnO2js7kWfK6ei+eED/FEktCYF0m5NnqdvZKeod2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXDt1sMXgJzoI3jUWBPTjZgoyhtwAMupoNU7W2A1Sog=;
 b=UPfQNWC2yzG8bVT3eTZF9FBLpoEAuOHC8PQnRw7mcEIxL9ThiETLM4bJGh8Kc9dL/rGTt0Ur/P1ffpsv6LdBvelLewcB/OHbxIkgoXt1q0rvIWR4NwUkjZj11TNpNoQhxNfaDzjNA9X+Gx5/2rZY1TgNJ9dI3TFm0McOKuKqVFu14m20F+Z7ErsWHXcuRZvBELvoMwSPlxp9AmfMQZPfvKjB9QG3K7wueGcff/aqkGiFsZ9pyd+RtP06cYGOGCBgh35E2K5MxB53ucLQf9x3DnI59vuhfu3RIltdgRxMMMJ1Kb31vDXuo/00LtkTFAoo4fH3a+6wUIQ4r6j3b/FZDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXDt1sMXgJzoI3jUWBPTjZgoyhtwAMupoNU7W2A1Sog=;
 b=d8r4cbZ4RFGt0TbysFWbQsM3rU60pqSHYJCNS9IWsOVdr7i5Mc0vgCexAleCY3kgKkuNk1kFgVxdMZ7aiDQZCGNDTqcdwXmEVNOmh85C/m5HoJRMK8yKwqROCqkMti9TMAIeBKENyNL9Sns2eLqKEGRKNc8VjnSgfMavQvyLxVI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3363.namprd10.prod.outlook.com (2603:10b6:408:c7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:50:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:50:54 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 33/44] nsp_cs: Move the SCSI pointer to private command
 data
Thread-Topic: [PATCH v2 33/44] nsp_cs: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRFGYl5MOYB900e0AHSLfYIOlayLkcqA
Date:   Wed, 9 Feb 2022 18:50:54 +0000
Message-ID: <8ACA6765-F798-47C9-A629-28565C9C35FA@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-34-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-34-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b317286e-fc18-4d12-a0e7-08d9ebfd1a46
x-ms-traffictypediagnostic: BN8PR10MB3363:EE_
x-microsoft-antispam-prvs: <BN8PR10MB33638D0220FC79A67B823D03E62E9@BN8PR10MB3363.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ciqtd+SsUUIM31pf1NHtDG39qeQjt1Zax5HWWliro20PYuqyX8LRdI9WwJmFnanx5MuWszDg8kWORSm2kSTBOw9JzFbnsVBWw7aAMqijTP0NtYsZDi9QNAsehVlEaY44dYQ6BRoiFbFJAEDTlZh9klGctyuVU/OC7dHfUlWgQM+AIN8uOA+ZxYt7A5oiEXf4COpIob+TZkm5SsG/Yr9m5A3ScVBjvprbsEaOhMxVKAMDXEbGkak4r4uf5kx6ZQW7wG1I6iaJ3qH6/T5Gc9PoPByQ9Q5RGqrgubYjh/OYzKKBss/ZbXrmggVPvbOmOkYoAopWbUGfiViiu/BoNKfg4C6yF9kdw5kZVbD48+SMptDHIbGX1Z+Doag7dTiQeTrIyQ6vJ3zL/fe1p9o521Ia0TbhmZcrmKrtnHDrCXJvds/G9a0K2inA5/q0Kou7wimuXIvb9ETGax50oxNfDNQpeIIUbR/vfDuVXsztuO+S3D8wqMuMaL1bvB3mJDHD3VTGJCL24PpVU8Y1uTg7pY5yx/uzApYh1NN2nSt8k+jBRiUvu2BAFAPPGXasq9ZHksaPZoYW81/dKLI+aKF2YAo0xzCYMqLJt0fFiA91kFsV+vFiAsiBHRpHrEs6iCtETWX5m4rV4M7p42DZJhJoUOY/0cX1y0Em/Nc89LOzpzQ8Tuk2buVQfiEs5JeG10iDmDmpDX0HaWbkJdps2UHwYXdIxYKiIS2rtbKx4Iz5oeftaFZGDQt05DoscLrqxI/Q31sY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(86362001)(6512007)(36756003)(316002)(6916009)(83380400001)(54906003)(71200400001)(2906002)(91956017)(44832011)(6506007)(30864003)(66946007)(66446008)(64756008)(8676002)(4326008)(53546011)(8936002)(66556008)(66476007)(6486002)(122000001)(76116006)(186003)(508600001)(5660300002)(33656002)(38100700002)(2616005)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q/n0v+cHegrA0KUGr6pEYuWr/8OxPJaSPtMSNlVlrvK6e7fQEQusTdW7kRw7?=
 =?us-ascii?Q?wSEClbAPWG+zdPMOq7phuwlsFG5EZ4/EHn7AtVd4sEeuvnohU8+ox4MufctA?=
 =?us-ascii?Q?Lv9Jv60i6tdUSE8h9WdQol5bojEzKYg3zjjnkzfuz5b39QOSW800J4grXzO1?=
 =?us-ascii?Q?HcvWfc4OzFsQFix02yX9+ADAQhkFK5zLxOyOvy9soiPDxkMdp6tzFclAdG59?=
 =?us-ascii?Q?5VC0bxeoWu3rEJrdtGmMkRRvh6sNJtcTHuNLLSm/e3H9rjYGafJr02KcXmq1?=
 =?us-ascii?Q?5YkC1w43861w1MQWqQ9t3FM/UMRQWklTLcMtrLf6tSv32UWr6f0z2N8+qfAq?=
 =?us-ascii?Q?z6R30UKNIW/T+uz5CJBsta2qnSu8e8WtUYgXGSLbMSq3RgVPyTrPvGR3Q33l?=
 =?us-ascii?Q?pWkjzXaVleJHhqyovmkQ0uKyBRtAWKaQDNXoP0EpCnVib6tKFovXmquJ3y+h?=
 =?us-ascii?Q?4Y9aobPQjx9ThJqcCPWJg+kJ8U++Gnv0Smag3h2JgkzfchE/ahLrPRkZ0lAJ?=
 =?us-ascii?Q?gS4rrBrpmZ37/uvzDRYa/eLdvFBB2zippvTFnam9DtLmnG1u+c8VW4xXXdTi?=
 =?us-ascii?Q?BOZNzgohQ59tmTEV04DZay2XYxXNjW689RKHhyMCeiSsrQ2ceMyKuJxGkPdv?=
 =?us-ascii?Q?IbwC6LKTKN2gWMFdIo/5ZLrGEczaZW6FHRvyoFYtKvzlf39RLiPajEdwA97T?=
 =?us-ascii?Q?G4wf06nK9LdIrm9/6eFM13C2bQ4aLCwFcxsdCOmpDwg/fr5L52OldwG1rnOq?=
 =?us-ascii?Q?J7x16EzTAr+WW4hqBrq1lclV/LjreUXEVLC4UvuVkWhivwcH6NBsr31cTwxE?=
 =?us-ascii?Q?VTHHkECtHxQIFI+uYj/CXtDlvIOq5qZzzjfQ3RDg5Qpf31u5nHBbOJOh5wle?=
 =?us-ascii?Q?gpUMn3TMTCG6uL8h/fWxENKgEIfUgsJ5HGzZTUN8RTDF4iPWVmNKjS4OSVIN?=
 =?us-ascii?Q?bmCHph4JWHzQfC7Rk29igdWERvTUdb6UZdqJH9Ukzxlqll8AMuj1uAvK+sMA?=
 =?us-ascii?Q?Fn5cxp/j2AGa3WfETM+bQZunReddVP4fA2SFvN7I1meng3PbmcVM6hWegszN?=
 =?us-ascii?Q?1H0yQsqs+5xpOLqppiEAIjuE6BgPML9Tf8e0PGBXC0n2m4eaHoKRb1i3nRac?=
 =?us-ascii?Q?zfFSVqpDBiFlXk5crgc8mj3NAFZ1Imi0hN7Zqo55vV5Q8CqA44ePFTdeKN2L?=
 =?us-ascii?Q?SS6rGj8CufiDNnV6cxE64lznuot+vEB1mmQBv4dPJlJEp8YF8kBaBn4f4vCx?=
 =?us-ascii?Q?bVKSzkxja2z8s8C69QGd2lnFFoLZLgBzfhnjyL0dxrqMa4bg0dn5j3xSQp/H?=
 =?us-ascii?Q?7CvMwZKxebZRJbVHKeS1fUFUo/WG8tjZ4bfMvpVL+8Nmz5FDsTec3kuth0KQ?=
 =?us-ascii?Q?cSUHNV45Gr9H05dsmyhftoHoCWww4zMN98twnSpji3WgfYaZfiW7WRdSVhQK?=
 =?us-ascii?Q?TzfZ2er8PV1dYHWzcOX8KEhp2WCJ2TaCgY8MmJGz4tqd+VUZu3LL2nnlLn5g?=
 =?us-ascii?Q?d6LYPfc912OeUlappxViA4uao/uwsyM/jKs1cB/YXuULxYTsW4G5qQpesT0G?=
 =?us-ascii?Q?hqNfpWoDDqjtoMTbOaHMba5jKCIrCmVYnYhnVeK52xB10bWfLks4NtHiEY6H?=
 =?us-ascii?Q?bZo7qVr2bbSCx6QTgXdRb0Y3xvX0lHEjCeUPthkGUwQWoC6C5w1TWZhTuaQO?=
 =?us-ascii?Q?KnHRNf31tdsI7SFO7H63uf6xlxVIBUd7a/UNAmqMRO0//Z1U?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DACE76885333A5478E6FC7CC706B7D32@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b317286e-fc18-4d12-a0e7-08d9ebfd1a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:50:54.8944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0PW3W6p6UEL/HnAosmV+1rO68AlXAFAJvcb3U9yx41gNAQuaw6O12bg1eqmKFR/oKCsrqiNn1L+myk8HexcZIzHAXY28kh5w/O3UfJcIpkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3363
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-ORIG-GUID: bocE3QtLqixYmoeZxv5tf1Sa2cqWPBCx
X-Proofpoint-GUID: bocE3QtLqixYmoeZxv5tf1Sa2cqWPBCx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> in struct scsi_cmnd.
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/pcmcia/nsp_cs.c    | 206 ++++++++++++++++++--------------
> drivers/scsi/pcmcia/nsp_cs.h    |   2 +-
> drivers/scsi/pcmcia/nsp_debug.c |   2 +-
> 3 files changed, 120 insertions(+), 90 deletions(-)
>=20
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index dcffda384eaf..94d8185d3190 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -70,6 +70,17 @@ static bool       free_ports =3D 0;
> module_param(free_ports, bool, 0);
> MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (defa=
ult: 0 (=3Dno))");
>=20
> +struct nsp_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static struct scsi_pointer *nsp_priv(struct scsi_cmnd *cmd)
> +{
> +	struct nsp_cmd_priv *ncmd =3D scsi_cmd_priv(cmd);
> +
> +	return &ncmd->scsi_pointer;
> +}
> +
> static struct scsi_host_template nsp_driver_template =3D {
> 	.proc_name	         =3D "nsp_cs",
> 	.show_info		 =3D nsp_show_info,
> @@ -83,6 +94,7 @@ static struct scsi_host_template nsp_driver_template =
=3D {
> 	.this_id		 =3D NSP_INITIATOR_ID,
> 	.sg_tablesize		 =3D SG_ALL,
> 	.dma_boundary		 =3D PAGE_SIZE - 1,
> +	.cmd_size		 =3D sizeof(struct nsp_cmd_priv),
> };
>=20
> static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
> @@ -180,8 +192,9 @@ static void nsp_scsi_done(struct scsi_cmnd *SCpnt)
> 	scsi_done(SCpnt);
> }
>=20
> -static int nsp_queuecommand_lck(struct scsi_cmnd *SCpnt)
> +static int nsp_queuecommand_lck(struct scsi_cmnd *const SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> #ifdef NSP_DEBUG
> 	/*unsigned int host_id =3D SCpnt->device->host->this_id;*/
> 	/*unsigned int base    =3D SCpnt->device->host->io_port;*/
> @@ -217,11 +230,11 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *S=
Cpnt)
>=20
> 	data->CurrentSC		=3D SCpnt;
>=20
> -	SCpnt->SCp.Status	=3D SAM_STAT_CHECK_CONDITION;
> -	SCpnt->SCp.Message	=3D 0;
> -	SCpnt->SCp.have_data_in =3D IO_UNKNOWN;
> -	SCpnt->SCp.sent_command =3D 0;
> -	SCpnt->SCp.phase	=3D PH_UNDETERMINED;
> +	scsi_pointer->Status	   =3D SAM_STAT_CHECK_CONDITION;
> +	scsi_pointer->Message	   =3D 0;
> +	scsi_pointer->have_data_in =3D IO_UNKNOWN;
> +	scsi_pointer->sent_command =3D 0;
> +	scsi_pointer->phase	   =3D PH_UNDETERMINED;
> 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
>=20
> 	/* setup scratch area
> @@ -231,15 +244,15 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *S=
Cpnt)
> 	   SCp.buffers_residual : left buffers in list
> 	   SCp.phase		: current state of the command */
> 	if (scsi_bufflen(SCpnt)) {
> -		SCpnt->SCp.buffer	    =3D scsi_sglist(SCpnt);
> -		SCpnt->SCp.ptr		    =3D BUFFER_ADDR;
> -		SCpnt->SCp.this_residual    =3D SCpnt->SCp.buffer->length;
> -		SCpnt->SCp.buffers_residual =3D scsi_sg_count(SCpnt) - 1;
> +		scsi_pointer->buffer	       =3D scsi_sglist(SCpnt);
> +		scsi_pointer->ptr	       =3D BUFFER_ADDR(SCpnt);
> +		scsi_pointer->this_residual    =3D scsi_pointer->buffer->length;
> +		scsi_pointer->buffers_residual =3D scsi_sg_count(SCpnt) - 1;
> 	} else {
> -		SCpnt->SCp.ptr		    =3D NULL;
> -		SCpnt->SCp.this_residual    =3D 0;
> -		SCpnt->SCp.buffer	    =3D NULL;
> -		SCpnt->SCp.buffers_residual =3D 0;
> +		scsi_pointer->ptr	       =3D NULL;
> +		scsi_pointer->this_residual    =3D 0;
> +		scsi_pointer->buffer	       =3D NULL;
> +		scsi_pointer->buffers_residual =3D 0;
> 	}
>=20
> 	if (!nsphw_start_selection(SCpnt)) {
> @@ -353,8 +366,9 @@ static void nsphw_init(nsp_hw_data *data)
> /*
>  * Start selection phase
>  */
> -static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
> +static bool nsphw_start_selection(struct scsi_cmnd *const SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> 	unsigned int  host_id	 =3D SCpnt->device->host->this_id;
> 	unsigned int  base	 =3D SCpnt->device->host->io_port;
> 	unsigned char target	 =3D scmd_id(SCpnt);
> @@ -372,7 +386,7 @@ static bool nsphw_start_selection(struct scsi_cmnd *S=
Cpnt)
>=20
> 	/* start arbitration */
> 	//nsp_dbg(NSP_DEBUG_RESELECTION, "start arbit");
> -	SCpnt->SCp.phase =3D PH_ARBSTART;
> +	scsi_pointer->phase =3D PH_ARBSTART;
> 	nsp_index_write(base, SETARBIT, ARBIT_GO);
>=20
> 	time_out =3D 1000;
> @@ -392,7 +406,7 @@ static bool nsphw_start_selection(struct scsi_cmnd *S=
Cpnt)
>=20
> 	/* assert select line */
> 	//nsp_dbg(NSP_DEBUG_RESELECTION, "assert SEL line");
> -	SCpnt->SCp.phase =3D PH_SELSTART;
> +	scsi_pointer->phase =3D PH_SELSTART;
> 	udelay(3); /* wait 2.4us */
> 	nsp_index_write(base, SCSIDATALATCH, BIT(host_id) | BIT(target));
> 	nsp_index_write(base, SCSIBUSCTRL,   SCSI_SEL | SCSI_BSY                =
    | SCSI_ATN);
> @@ -568,8 +582,9 @@ static int nsp_expect_signal(struct scsi_cmnd *SCpnt,
> /*
>  * transfer SCSI message
>  */
> -static int nsp_xfer(struct scsi_cmnd *SCpnt, int phase)
> +static int nsp_xfer(struct scsi_cmnd *const SCpnt, int phase)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> 	unsigned int  base =3D SCpnt->device->host->io_port;
> 	nsp_hw_data  *data =3D (nsp_hw_data *)SCpnt->device->host->hostdata;
> 	char	     *buf  =3D data->MsgBuffer;
> @@ -587,7 +602,7 @@ static int nsp_xfer(struct scsi_cmnd *SCpnt, int phas=
e)
> 		}
>=20
> 		/* if last byte, negate ATN */
> -		if (len =3D=3D 1 && SCpnt->SCp.phase =3D=3D PH_MSG_OUT) {
> +		if (len =3D=3D 1 && scsi_pointer->phase =3D=3D PH_MSG_OUT) {
> 			nsp_index_write(base, SCSIBUSCTRL, AUTODIRECTION | ACKENB);
> 		}
>=20
> @@ -608,14 +623,15 @@ static int nsp_xfer(struct scsi_cmnd *SCpnt, int ph=
ase)
> /*
>  * get extra SCSI data from fifo
>  */
> -static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
> +static int nsp_dataphase_bypass(struct scsi_cmnd *const SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> 	nsp_hw_data *data =3D (nsp_hw_data *)SCpnt->device->host->hostdata;
> 	unsigned int count;
>=20
> 	//nsp_dbg(NSP_DEBUG_DATA_IO, "in");
>=20
> -	if (SCpnt->SCp.have_data_in !=3D IO_IN) {
> +	if (scsi_pointer->have_data_in !=3D IO_IN) {
> 		return 0;
> 	}
>=20
> @@ -630,7 +646,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCp=
nt)
> 	 * data phase skip only occures in case of SCSI_LOW_READ
> 	 */
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
> -	SCpnt->SCp.phase =3D PH_DATA;
> +	scsi_pointer->phase =3D PH_DATA;
> 	nsp_pio_read(SCpnt);
> 	nsp_setup_fifo(data, false);
>=20
> @@ -704,8 +720,9 @@ static int nsp_fifo_count(struct scsi_cmnd *SCpnt)
> /*
>  * read data in DATA IN phase
>  */
> -static void nsp_pio_read(struct scsi_cmnd *SCpnt)
> +static void nsp_pio_read(struct scsi_cmnd *const SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> 	unsigned int  base      =3D SCpnt->device->host->io_port;
> 	unsigned long mmio_base =3D SCpnt->device->host->base;
> 	nsp_hw_data  *data      =3D (nsp_hw_data *)SCpnt->device->host->hostdata=
;
> @@ -716,24 +733,25 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
> 	ocount =3D data->FifoCount;
>=20
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "in SCpnt=3D0x%p resid=3D%d ocount=3D%d ptr=
=3D0x%p this_residual=3D%d buffers=3D0x%p nbuf=3D%d",
> -		SCpnt, scsi_get_resid(SCpnt), ocount, SCpnt->SCp.ptr,
> -		SCpnt->SCp.this_residual, SCpnt->SCp.buffer,
> -		SCpnt->SCp.buffers_residual);
> +		SCpnt, scsi_get_resid(SCpnt), ocount, scsi_pointer->ptr,
> +		scsi_pointer->this_residual, scsi_pointer->buffer,
> +		scsi_pointer->buffers_residual);
>=20
> 	time_out =3D 1000;
>=20
> 	while ((time_out-- !=3D 0) &&
> -	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0=
 ) ) {
> +	       (scsi_pointer->this_residual > 0 ||
> +		scsi_pointer->buffers_residual > 0)) {
>=20
> 		stat =3D nsp_index_read(base, SCSIBUSMON);
> 		stat &=3D BUSMON_PHASE_MASK;
>=20
>=20
> 		res =3D nsp_fifo_count(SCpnt) - ocount;
> -		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this=3D0x%x ocount=3D0x%x res=
=3D0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, ocount, res);
> +		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this=3D0x%x ocount=3D0x%x res=
=3D0x%x", scsi_pointer->ptr, scsi_pointer->this_residual, ocount, res);
> 		if (res =3D=3D 0) { /* if some data available ? */
> 			if (stat =3D=3D BUSPHASE_DATA_IN) { /* phase changed? */
> -				//nsp_dbg(NSP_DEBUG_DATA_IO, " wait for data this=3D%d", SCpnt->SCp.=
this_residual);
> +				//nsp_dbg(NSP_DEBUG_DATA_IO, " wait for data this=3D%d", scsi_pointe=
r->this_residual);
> 				continue;
> 			} else {
> 				nsp_dbg(NSP_DEBUG_DATA_IO, "phase changed stat=3D0x%x", stat);
> @@ -747,20 +765,21 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
> 			continue;
> 		}
>=20
> -		res =3D min(res, SCpnt->SCp.this_residual);
> +		res =3D min(res, scsi_pointer->this_residual);
>=20
> 		switch (data->TransferMode) {
> 		case MODE_IO32:
> 			res &=3D ~(BIT(1)|BIT(0)); /* align 4 */
> -			nsp_fifo32_read(base, SCpnt->SCp.ptr, res >> 2);
> +			nsp_fifo32_read(base, scsi_pointer->ptr, res >> 2);
> 			break;
> 		case MODE_IO8:
> -			nsp_fifo8_read (base, SCpnt->SCp.ptr, res     );
> +			nsp_fifo8_read(base, scsi_pointer->ptr, res);
> 			break;
>=20
> 		case MODE_MEM32:
> 			res &=3D ~(BIT(1)|BIT(0)); /* align 4 */
> -			nsp_mmio_fifo32_read(mmio_base, SCpnt->SCp.ptr, res >> 2);
> +			nsp_mmio_fifo32_read(mmio_base, scsi_pointer->ptr,
> +					     res >> 2);
> 			break;
>=20
> 		default:
> @@ -769,22 +788,23 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
> 		}
>=20
> 		nsp_inc_resid(SCpnt, -res);
> -		SCpnt->SCp.ptr		 +=3D res;
> -		SCpnt->SCp.this_residual -=3D res;
> +		scsi_pointer->ptr +=3D res;
> +		scsi_pointer->this_residual -=3D res;
> 		ocount			 +=3D res;
> -		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this_residual=3D0x%x ocount=
=3D0x%x", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, ocount);
> +		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this_residual=3D0x%x ocount=
=3D0x%x", scsi_pointer->ptr, scsi_pointer->this_residual, ocount);
>=20
> 		/* go to next scatter list if available */
> -		if (SCpnt->SCp.this_residual	=3D=3D 0 &&
> -		    SCpnt->SCp.buffers_residual !=3D 0 ) {
> +		if (scsi_pointer->this_residual	=3D=3D 0 &&
> +		    scsi_pointer->buffers_residual !=3D 0 ) {
> 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next timeout=3D%d", time_out=
);
> -			SCpnt->SCp.buffers_residual--;
> -			SCpnt->SCp.buffer =3D sg_next(SCpnt->SCp.buffer);
> -			SCpnt->SCp.ptr		 =3D BUFFER_ADDR;
> -			SCpnt->SCp.this_residual =3D SCpnt->SCp.buffer->length;
> +			scsi_pointer->buffers_residual--;
> +			scsi_pointer->buffer =3D sg_next(scsi_pointer->buffer);
> +			scsi_pointer->ptr =3D BUFFER_ADDR(SCpnt);
> +			scsi_pointer->this_residual =3D
> +				scsi_pointer->buffer->length;
> 			time_out =3D 1000;
>=20
> -			//nsp_dbg(NSP_DEBUG_DATA_IO, "page: 0x%p, off: 0x%x", SCpnt->SCp.buff=
er->page, SCpnt->SCp.buffer->offset);
> +			//nsp_dbg(NSP_DEBUG_DATA_IO, "page: 0x%p, off: 0x%x", scsi_pointer->b=
uffer->page, scsi_pointer->buffer->offset);
> 		}
> 	}
>=20
> @@ -792,8 +812,8 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
>=20
> 	if (time_out < 0) {
> 		nsp_msg(KERN_DEBUG, "pio read timeout resid=3D%d this_residual=3D%d buf=
fers_residual=3D%d",
> -			scsi_get_resid(SCpnt), SCpnt->SCp.this_residual,
> -			SCpnt->SCp.buffers_residual);
> +			scsi_get_resid(SCpnt), scsi_pointer->this_residual,
> +			scsi_pointer->buffers_residual);
> 	}
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "read ocount=3D0x%x", ocount);
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "r cmd=3D%d resid=3D0x%x\n", data->CmdId,
> @@ -805,6 +825,7 @@ static void nsp_pio_read(struct scsi_cmnd *SCpnt)
>  */
> static void nsp_pio_write(struct scsi_cmnd *SCpnt)
> {
> +	struct scsi_pointer *scsi_pointer =3D nsp_priv(SCpnt);
> 	unsigned int  base      =3D SCpnt->device->host->io_port;
> 	unsigned long mmio_base =3D SCpnt->device->host->base;
> 	nsp_hw_data  *data      =3D (nsp_hw_data *)SCpnt->device->host->hostdata=
;
> @@ -815,14 +836,15 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
> 	ocount	 =3D data->FifoCount;
>=20
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "in fifocount=3D%d ptr=3D0x%p this_residual=
=3D%d buffers=3D0x%p nbuf=3D%d resid=3D0x%x",
> -		data->FifoCount, SCpnt->SCp.ptr, SCpnt->SCp.this_residual,
> -		SCpnt->SCp.buffer, SCpnt->SCp.buffers_residual,
> +		data->FifoCount, scsi_pointer->ptr, scsi_pointer->this_residual,
> +		scsi_pointer->buffer, scsi_pointer->buffers_residual,
> 		scsi_get_resid(SCpnt));
>=20
> 	time_out =3D 1000;
>=20
> 	while ((time_out-- !=3D 0) &&
> -	       (SCpnt->SCp.this_residual > 0 || SCpnt->SCp.buffers_residual > 0=
)) {
> +	       (scsi_pointer->this_residual > 0 ||
> +		scsi_pointer->buffers_residual > 0)) {
> 		stat =3D nsp_index_read(base, SCSIBUSMON);
> 		stat &=3D BUSMON_PHASE_MASK;
>=20
> @@ -832,9 +854,9 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
> 			nsp_dbg(NSP_DEBUG_DATA_IO, "phase changed stat=3D0x%x, res=3D%d\n", st=
at, res);
> 			/* Put back pointer */
> 			nsp_inc_resid(SCpnt, res);
> -			SCpnt->SCp.ptr		 -=3D res;
> -			SCpnt->SCp.this_residual +=3D res;
> -			ocount			 -=3D res;
> +			scsi_pointer->ptr -=3D res;
> +			scsi_pointer->this_residual +=3D res;
> +			ocount -=3D res;
>=20
> 			break;
> 		}
> @@ -845,21 +867,22 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
> 			continue;
> 		}
>=20
> -		res =3D min(SCpnt->SCp.this_residual, WFIFO_CRIT);
> +		res =3D min(scsi_pointer->this_residual, WFIFO_CRIT);
>=20
> -		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this=3D0x%x res=3D0x%x", SCpn=
t->SCp.ptr, SCpnt->SCp.this_residual, res);
> +		//nsp_dbg(NSP_DEBUG_DATA_IO, "ptr=3D0x%p this=3D0x%x res=3D0x%x", scsi=
_pointer->ptr, scsi_pointer->this_residual, res);
> 		switch (data->TransferMode) {
> 		case MODE_IO32:
> 			res &=3D ~(BIT(1)|BIT(0)); /* align 4 */
> -			nsp_fifo32_write(base, SCpnt->SCp.ptr, res >> 2);
> +			nsp_fifo32_write(base, scsi_pointer->ptr, res >> 2);
> 			break;
> 		case MODE_IO8:
> -			nsp_fifo8_write (base, SCpnt->SCp.ptr, res     );
> +			nsp_fifo8_write(base, scsi_pointer->ptr, res);
> 			break;
>=20
> 		case MODE_MEM32:
> 			res &=3D ~(BIT(1)|BIT(0)); /* align 4 */
> -			nsp_mmio_fifo32_write(mmio_base, SCpnt->SCp.ptr, res >> 2);
> +			nsp_mmio_fifo32_write(mmio_base, scsi_pointer->ptr,
> +					      res >> 2);
> 			break;
>=20
> 		default:
> @@ -868,18 +891,19 @@ static void nsp_pio_write(struct scsi_cmnd *SCpnt)
> 		}
>=20
> 		nsp_inc_resid(SCpnt, -res);
> -		SCpnt->SCp.ptr		 +=3D res;
> -		SCpnt->SCp.this_residual -=3D res;
> -		ocount			 +=3D res;
> +		scsi_pointer->ptr +=3D res;
> +		scsi_pointer->this_residual -=3D res;
> +		ocount +=3D res;
>=20
> 		/* go to next scatter list if available */
> -		if (SCpnt->SCp.this_residual	=3D=3D 0 &&
> -		    SCpnt->SCp.buffers_residual !=3D 0 ) {
> +		if (scsi_pointer->this_residual	=3D=3D 0 &&
> +		    scsi_pointer->buffers_residual !=3D 0 ) {
> 			//nsp_dbg(NSP_DEBUG_DATA_IO, "scatterlist next");
> -			SCpnt->SCp.buffers_residual--;
> -			SCpnt->SCp.buffer =3D sg_next(SCpnt->SCp.buffer);
> -			SCpnt->SCp.ptr		 =3D BUFFER_ADDR;
> -			SCpnt->SCp.this_residual =3D SCpnt->SCp.buffer->length;
> +			scsi_pointer->buffers_residual--;
> +			scsi_pointer->buffer =3D sg_next(scsi_pointer->buffer);
> +			scsi_pointer->ptr =3D BUFFER_ADDR(SCpnt);
> +			scsi_pointer->this_residual =3D
> +				scsi_pointer->buffer->length;
> 			time_out =3D 1000;
> 		}
> 	}
> @@ -947,6 +971,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 	unsigned int   base;
> 	unsigned char  irq_status, irq_phase, phase;
> 	struct scsi_cmnd *tmpSC;
> +	struct scsi_pointer *scsi_pointer;
> 	unsigned char  target, lun;
> 	unsigned int  *sync_neg;
> 	int            i, tmp;
> @@ -1025,9 +1050,10 @@ static irqreturn_t nspintr(int irq, void *dev_id)
>=20
> 		if(data->CurrentSC !=3D NULL) {
> 			tmpSC =3D data->CurrentSC;
> -			tmpSC->result  =3D (DID_RESET                   << 16) |
> -				         ((tmpSC->SCp.Message & 0xff) <<  8) |
> -				         ((tmpSC->SCp.Status  & 0xff) <<  0);
> +			scsi_pointer =3D nsp_priv(tmpSC);
> +			tmpSC->result =3D (DID_RESET              << 16) |
> +				((scsi_pointer->Message & 0xff) <<  8) |
> +				((scsi_pointer->Status  & 0xff) <<  0);
> 			nsp_scsi_done(tmpSC);
> 		}
> 		return IRQ_HANDLED;
> @@ -1041,6 +1067,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 	}
>=20
> 	tmpSC    =3D data->CurrentSC;
> +	scsi_pointer =3D nsp_priv(tmpSC);
> 	target   =3D tmpSC->device->id;
> 	lun      =3D tmpSC->device->lun;
> 	sync_neg =3D &(data->Sync[target].SyncNegotiation);
> @@ -1063,7 +1090,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
>=20
> 	//show_phase(tmpSC);
>=20
> -	switch(tmpSC->SCp.phase) {
> +	switch (scsi_pointer->phase) {
> 	case PH_SELSTART:
> 		// *sync_neg =3D SYNC_NOT_YET;
> 		if ((phase & BUSMON_BSY) =3D=3D 0) {
> @@ -1086,7 +1113,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 		/* attention assert */
> 		//nsp_dbg(NSP_DEBUG_INTR, "attention assert");
> 		data->SelectionTimeOut =3D 0;
> -		tmpSC->SCp.phase       =3D PH_SELECTED;
> +		scsi_pointer->phase =3D PH_SELECTED;
> 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN);
> 		udelay(1);
> 		nsp_index_write(base, SCSIBUSCTRL, SCSI_ATN | AUTODIRECTION | ACKENB);
> @@ -1115,17 +1142,18 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 	//nsp_dbg(NSP_DEBUG_INTR, "start scsi seq");
>=20
> 	/* normal disconnect */
> -	if (((tmpSC->SCp.phase =3D=3D PH_MSG_IN) || (tmpSC->SCp.phase =3D=3D PH=
_MSG_OUT)) &&
> -	    (irq_phase & LATCHED_BUS_FREE) !=3D 0 ) {
> +	if ((scsi_pointer->phase =3D=3D PH_MSG_IN ||
> +	     scsi_pointer->phase =3D=3D PH_MSG_OUT) &&
> +	    (irq_phase & LATCHED_BUS_FREE) !=3D 0) {
> 		nsp_dbg(NSP_DEBUG_INTR, "normal disconnect irq_status=3D0x%x, phase=3D0=
x%x, irq_phase=3D0x%x", irq_status, phase, irq_phase);
>=20
> 		//*sync_neg       =3D SYNC_NOT_YET;
>=20
> 		/* all command complete and return status */
> -		if (tmpSC->SCp.Message =3D=3D COMMAND_COMPLETE) {
> -			tmpSC->result =3D (DID_OK		             << 16) |
> -					((tmpSC->SCp.Message & 0xff) <<  8) |
> -					((tmpSC->SCp.Status  & 0xff) <<  0);
> +		if (scsi_pointer->Message =3D=3D COMMAND_COMPLETE) {
> +			tmpSC->result =3D (DID_OK		        << 16) |
> +				((scsi_pointer->Message & 0xff) <<  8) |
> +				((scsi_pointer->Status  & 0xff) <<  0);
> 			nsp_dbg(NSP_DEBUG_INTR, "command complete result=3D0x%x", tmpSC->resul=
t);
> 			nsp_scsi_done(tmpSC);
>=20
> @@ -1154,7 +1182,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 			return IRQ_HANDLED;
> 		}
>=20
> -		tmpSC->SCp.phase =3D PH_COMMAND;
> +		scsi_pointer->phase =3D PH_COMMAND;
>=20
> 		nsp_nexus(tmpSC);
>=20
> @@ -1170,8 +1198,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 	case BUSPHASE_DATA_OUT:
> 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_DATA_OUT");
>=20
> -		tmpSC->SCp.phase        =3D PH_DATA;
> -		tmpSC->SCp.have_data_in =3D IO_OUT;
> +		scsi_pointer->phase        =3D PH_DATA;
> +		scsi_pointer->have_data_in =3D IO_OUT;
>=20
> 		nsp_pio_write(tmpSC);
>=20
> @@ -1180,8 +1208,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 	case BUSPHASE_DATA_IN:
> 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_DATA_IN");
>=20
> -		tmpSC->SCp.phase        =3D PH_DATA;
> -		tmpSC->SCp.have_data_in =3D IO_IN;
> +		scsi_pointer->phase        =3D PH_DATA;
> +		scsi_pointer->have_data_in =3D IO_IN;
>=20
> 		nsp_pio_read(tmpSC);
>=20
> @@ -1191,10 +1219,11 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 		nsp_dataphase_bypass(tmpSC);
> 		nsp_dbg(NSP_DEBUG_INTR, "BUSPHASE_STATUS");
>=20
> -		tmpSC->SCp.phase =3D PH_STATUS;
> +		scsi_pointer->phase =3D PH_STATUS;
>=20
> -		tmpSC->SCp.Status =3D nsp_index_read(base, SCSIDATAWITHACK);
> -		nsp_dbg(NSP_DEBUG_INTR, "message=3D0x%x status=3D0x%x", tmpSC->SCp.Mes=
sage, tmpSC->SCp.Status);
> +		scsi_pointer->Status =3D nsp_index_read(base, SCSIDATAWITHACK);
> +		nsp_dbg(NSP_DEBUG_INTR, "message=3D0x%x status=3D0x%x",
> +			scsi_pointer->Message, scsi_pointer->Status);
>=20
> 		break;
>=20
> @@ -1204,7 +1233,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 			goto timer_out;
> 		}
>=20
> -		tmpSC->SCp.phase =3D PH_MSG_OUT;
> +		scsi_pointer->phase =3D PH_MSG_OUT;
>=20
> 		//*sync_neg =3D SYNC_NOT_YET;
>=20
> @@ -1237,7 +1266,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 			goto timer_out;
> 		}
>=20
> -		tmpSC->SCp.phase =3D PH_MSG_IN;
> +		scsi_pointer->phase =3D PH_MSG_IN;
> 		nsp_message_in(tmpSC);
>=20
> 		/**/
> @@ -1269,9 +1298,10 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 				i +=3D (1 + data->MsgBuffer[i+1]);
> 			}
> 		}
> -		tmpSC->SCp.Message =3D tmp;
> +		scsi_pointer->Message =3D tmp;
>=20
> -		nsp_dbg(NSP_DEBUG_INTR, "message=3D0x%x len=3D%d", tmpSC->SCp.Message,=
 data->MsgLen);
> +		nsp_dbg(NSP_DEBUG_INTR, "message=3D0x%x len=3D%d",
> +			scsi_pointer->Message, data->MsgLen);
> 		show_message(data);
>=20
> 		break;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index 7d5d1a5b36e0..e1ee8ef90ad3 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -371,7 +371,7 @@ enum _burst_mode {
> };
>=20
> /* scatter-gather table */
> -#  define BUFFER_ADDR ((char *)((sg_virt(SCpnt->SCp.buffer))))
> +#define BUFFER_ADDR(SCpnt) ((char *)(sg_virt(nsp_priv(SCpnt)->buffer)))
>=20
> #endif  /*__nsp_cs__*/
> /* end */
> diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_de=
bug.c
> index 6aa7d269d3b3..23b68dd26f74 100644
> --- a/drivers/scsi/pcmcia/nsp_debug.c
> +++ b/drivers/scsi/pcmcia/nsp_debug.c
> @@ -145,7 +145,7 @@ static void show_command(struct scsi_cmnd *SCpnt)
>=20
> static void show_phase(struct scsi_cmnd *SCpnt)
> {
> -	int i =3D SCpnt->SCp.phase;
> +	int i =3D nsp_scsi_pointer(SCpnt)->phase;
>=20
> 	char *ph[] =3D {
> 		"PH_UNDETERMINED",

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

