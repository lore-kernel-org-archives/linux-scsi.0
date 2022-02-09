Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E6CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 19:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbiBITCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 14:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241655AbiBITAW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 14:00:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD7C02B5ED
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:58:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HCr5o027653;
        Wed, 9 Feb 2022 18:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Msk8nsZ5jXROwRdYpOKplKxG/UgTw9ETHB40Es8vLFE=;
 b=I7vbRTpiDtptBiLU75gVTFpICaWzUNsxVoP/LfmK7GD19TOIUYimVvxUYTfY3MiLZZ49
 2VZ9Ocbcp7vzjkRle/3NH8S7ivzr2ez/3QtnvH9y2vvAYhumfhBXhm81zhqdGEFY6621
 /MhgC8AIYjKeK/fCuTXYWMNkI/BhHavW67gp8MfcWjdUQcvk0pSGo8Hw1CmUHqvKFG8F
 dPAmyjDaPJIc/C5E6M0T6fDVg6GuwAdY8gAHAEt9KZTfqdYj4enhV16kkI1RCkVQSAXF
 DqaiKGXE+wEzJS4dSITH1JekwIhItdA2Ji0EqzJjcceE/nvpR0A5Sw1JUOAscSQvK76q rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdswg0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:58:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IpvwY018483;
        Wed, 9 Feb 2022 18:58:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3e1ec37r47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:58:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixpLK3EU0RCFfplevH1TwSGuCIfXCVTZDHzCPevYnDs0hgVttUNe1E5/cBVSr2DXQlOMMHzz1HHQOR43NNW8x7OZxwzUFggOnVVEPhN0SmuBHRiYCl/Y5aP9fdP06NzzwT4wosgqvZ9sUG+4Vw0V2MZHpB2Nd+Wd/R0ayeVjc25KiLaid5hk61oEObeBpwXTLB5olv0ZDIKtkq/nB7XiJ+SgzfAQDz0jj/oqcH3v6QEIQnBmWCi4VuJSBo5yg+geTx2OIlKVcTnry+nQRjnZL7ST+QmslOB49JLFp+4fZJyqZfcpQTkpkxXQdrOE1t9MaG0Md1baAxgqd3QKVz3mfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Msk8nsZ5jXROwRdYpOKplKxG/UgTw9ETHB40Es8vLFE=;
 b=S0M94ZS8Blp8KU0T3dU9AE9q3nstnZ8zOfePC/+R+60Gi4jlMu3C1aGRebjzDBSBlCvhKoP8sENbzV+7IyM7zWyonMymmUllDuNPgfizAtH2lj0uKzft6mRObQKTFff+7S8nwRPAQN0jsmruEMZGGkfHI25M8ohhqK9PzmjjtXKnc7ed0QLFILGkT8f0I4s5GH8Cl6Kz4aD3hna7eeCo/zQeX5BNyIIEjK9H1qG95I43e56hS5eV71AUoprklc037nVugNqjeR+A5i0kBUbgQJBuVmom+oKZxCtPMis6KMk5iswT68hRzQXMZV16JwjdSaj6c1AcGpCPWHhMfGQqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Msk8nsZ5jXROwRdYpOKplKxG/UgTw9ETHB40Es8vLFE=;
 b=CY5De0+OT6T+zhsicwtlpvPq8AWI/evQ0IlvZwODcoSTdJdVH+yXXVA0Z3bxy89aoTQIcQte7Cp4o13K3PAeQqY7n76ZV8tGeVMM/AsdCbMjm26ViPzjxihzo6j+RMlzK1CBSZrM5a2wB0n6tZqJgtuFRbBg1ECFCbQTLCbzsdI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB4106.namprd10.prod.outlook.com (2603:10b6:5:17d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:58:16 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:58:16 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 36/44] qla1280: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 36/44] qla1280: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRE9WM+k26RNoEC7aU4d3u7DMqyLk9mA
Date:   Wed, 9 Feb 2022 18:58:16 +0000
Message-ID: <2A17F424-6989-47AC-90DE-3E88B420A1E2@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-37-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-37-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48b61e65-3f48-4dba-e02e-08d9ebfe2139
x-ms-traffictypediagnostic: DM6PR10MB4106:EE_
x-microsoft-antispam-prvs: <DM6PR10MB4106A7148D67D62790B65C7DE62E9@DM6PR10MB4106.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TO+efkfvViizf1KDe6yhX9mf4XkPu+TwFeNJNeVlPYRoXtQ/4tM2q/a9UE90cHBq6Av2VDuVrPp1PBJzTtQGW07MFsTPeRJbcqoIH/rlwUUSTH1DtbRJXf+DXiNlTEGZKuBhhoT0jv6gIVN+FA3WzVuM10JnZi8HfLLanR24mMx5p6m/9hM2IvxRVqeRkY58KhMyqdmRQPGIMYo030jZF2bXL2FIYSayzn2qnv7qsxDiRfe9sGPD1bQ38UaBhST38ESKz6rph+MGho+L0hYrzeHMugNzg39f0LIOxnFjX+KNs32kioojSbnAbtYy9GIEtZrbTFH3jEa9pROgUyZAQ6wCv9iTFKCZ84rToRHzWSGXJ6dBs9K4HHJN0A+e1xKTlYE56xYWl6YfxwXPQuFOI6xU+NVbwBH+M8vmJE3H6lRu87LCDRiHwTtpdSV29TUoDgHU9WVgz9ogrJcys2/5AJFFCKbKuMIkh6mjeqIqMHQJQxeePMCMD2xyeEDqe13oPlmxv99av+Z6k8Jd4HCMEFtl04zgrWQBYQ7cuLSWidMUum4icHkjzjYw+a9pG5mctWAf5taPB/CK3zNO/PLP3LDOz2v9zba5MXb4hGUpRCzvsI2VQJIx0kd00vc0lIpNgnY4Mrhi1zoItgQK2u8YzWJYZIYatlax32IHfNUqfxZhg7T0Ta7N3vHCatJ1GtsLg6IBwtqMpHWQmE6K6AWPa0gY07CvZT/O6FjtrkKEaCvEn8uUv8zwSN9QWFHQTLbI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(71200400001)(6506007)(33656002)(6486002)(6512007)(2906002)(86362001)(2616005)(38070700005)(508600001)(38100700002)(44832011)(122000001)(8676002)(6916009)(66446008)(83380400001)(8936002)(186003)(4326008)(76116006)(36756003)(91956017)(54906003)(66946007)(316002)(66476007)(5660300002)(64756008)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iK+U6q8et4aPV5f5vCuYu5TBSKT67wRTRTs3R1vwzAPvtpdrUzjgydZaZ9gO?=
 =?us-ascii?Q?XltvA5XZWTMH011kd6JRLMKMCCi8T+Aid0bMCtH05gZuPvod6l8XIy1ctedT?=
 =?us-ascii?Q?x67o70K1BQNqoLqUoPatHWcmC5AAXC6M27oK+a8oZiZbAzcWP04H32hu+m/0?=
 =?us-ascii?Q?Cf/Kdv5hboVp5/ewtRKHvvxzTFgUQifNGz/Vl08rv0RfGtmhH2H183yKFVba?=
 =?us-ascii?Q?GyuKyyFd7/yUIN/2i/aIc+FgNDk77XODaWZ0Jt9j9sRO9BWAu6LNI2ForwTC?=
 =?us-ascii?Q?I1fjWWewSMsjTbD6TB6C87Q3H+l2zUGEW5sPP5RtpWrVg0IQYmVCo7QV0qGj?=
 =?us-ascii?Q?SIjP0wT99G08C5+ZGav+O/WmATX9aQzfTdrhyyos8AKBbBOjhLsnoAEOP29g?=
 =?us-ascii?Q?qQZPMhCbI/d5dj4PXnsD1YRwQJFhEAAbTxhPn/Vm5TgLxr5DRtWmNfiieKj6?=
 =?us-ascii?Q?es6qMIEt3zrpYFu6Msuf0UPT8W06UJkf3zDxY/WL9J6bhZRvXFjUoU1ShcWE?=
 =?us-ascii?Q?k6qY8ZoElnfxK3IlALJ6ybXcdQ/MSUxgEarqTDmNrZ0TvTbwliP3XSj59lKp?=
 =?us-ascii?Q?Lx2ayvAlcC9/FB3yp2XP+14M4ZnXEiU+217ncWcSoqu976SHovMtB3R7Br2K?=
 =?us-ascii?Q?lqOffaj8U9i7D72FigdV3lezFw9TOIYfqAcyicTU3Kb9+ECX7B6JLieOkkre?=
 =?us-ascii?Q?1Vh83Feuc3M+i5NTEigrsK5rLA3li38IM7cX1EqLNgLkPglNDyJv6W5ofWQ8?=
 =?us-ascii?Q?ta990NAISx1Ym1tw0BmLksx/oMdWA/Ms6ztGFi/Y62Ll3htPg93mM6cZKfnp?=
 =?us-ascii?Q?yKXbktQvaq8Pa8QrXh6H28c6VoPqDBfLw9hts2YFM9nJEAH0jzwasYtULtoE?=
 =?us-ascii?Q?b8XpHFPWfeORkrUs7A1+W1L3POs3F3DjalIDlPLIXTMS2C1ms6p6XRFUXxUg?=
 =?us-ascii?Q?HsjeIMcbTJzBsMyOoMUKxIZobfZqahaxSbjPHt+ipvWouuI081UtYj9YtQR7?=
 =?us-ascii?Q?ilLAN7xZccTyIMkg0JL6XN/pGNJQ8EbkPtbKLFrBdVon9eF3AQXx7V98ekvd?=
 =?us-ascii?Q?GqmT3YfGzu2CZLN4S4CblLjT6ER34y7F6KwL/g3RKnUmteknsLt8ZD2Pjg7+?=
 =?us-ascii?Q?lNTgCmlhgHc5zCRHgcItL6iaGB7uTs9X97ddVWjF6O/FjpaUAbbIynXXjIpR?=
 =?us-ascii?Q?FOX12V2J82f4j4D9mvKeBnTGJvNleUZosMKuA6O4ZJhbdiAYqUeC73qKesIr?=
 =?us-ascii?Q?vaxWqO+lIzBc27GXIxqi4ktQHHWl0fRTeKsHIauCurOl1lv6ovk3FH6CLBZM?=
 =?us-ascii?Q?8salYHtiEcWfbCVHNnclqePeK4x/ObiiTDTDjwnrontA9tsZVG3RCciOP4IA?=
 =?us-ascii?Q?/+u2eoJpcPIz4U5REG2BluXpLZvCJRAy5n22hXII95xzsZx/CerWPehD63i7?=
 =?us-ascii?Q?WJHLfDWBYGOb3Jbn+8JuwO/D/Ms0CtRx1CRtPlkyd7f54aE1pOX/GWuyG7sV?=
 =?us-ascii?Q?QhaJCAq0KIRFgwcZkT3Bd3ytm6FOn4zwRdsfQIUibm2N8ua2fiNdHFo3oM2w?=
 =?us-ascii?Q?pDiWUpPsg95NCiX/LCjheOJw0jBhjiWRfOYGfK37wq4PJsnLBfRJwUbcqtS2?=
 =?us-ascii?Q?0wXTXld5quoGDsX6vYwNlLgMTo4X7Kl71VH6DA2Q1goz83NT/TlHAd+7SIUn?=
 =?us-ascii?Q?txyYzDKEi//bsGlui4HMoEyUIfySl2NSYXFNPqCEFiLJDyHc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C06B43E7DF01B84BB3D5BC31B8F034DD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b61e65-3f48-4dba-e02e-08d9ebfe2139
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:58:16.0360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V4jpUbpnGzo7XUoiHg8h0awoB0xX0TPx9CaFxJkx+eDsUpTxsiuLjgDIhgwF/4HweBKmTRZmVsluLZhKKlfL1Tc74Dbj82gS1Vt05zK4MLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4106
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090099
X-Proofpoint-GUID: 6BE8XSR4Srr9WkQUw5eGJttTs6zgM0lK
X-Proofpoint-ORIG-GUID: 6BE8XSR4Srr9WkQUw5eGJttTs6zgM0lK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla1280.c | 21 ++++-----------------
> drivers/scsi/qla1280.h |  3 +--
> 2 files changed, 5 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 1dc56f4c89d8..0ab595c0870a 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -477,13 +477,6 @@ __setup("qla1280=3D", qla1280_setup);
> #endif
>=20
>=20
> -/*
> - * We use the scsi_pointer structure that's included with each scsi_comm=
and
> - * to overlay our struct srb over it. qla1280_init() checks that a srb i=
s not
> - * bigger than a scsi_pointer.
> - */
> -
> -#define	CMD_SP(Cmnd)		&Cmnd->SCp
> #define	CMD_CDBLEN(Cmnd)	Cmnd->cmd_len
> #define	CMD_CDBP(Cmnd)		Cmnd->cmnd
> #define	CMD_SNSP(Cmnd)		Cmnd->sense_buffer
> @@ -693,7 +686,7 @@ static int qla1280_queuecommand_lck(struct scsi_cmnd =
*cmd)
> {
> 	struct Scsi_Host *host =3D cmd->device->host;
> 	struct scsi_qla_host *ha =3D (struct scsi_qla_host *)host->hostdata;
> -	struct srb *sp =3D (struct srb *)CMD_SP(cmd);
> +	struct srb *sp =3D scsi_cmd_priv(cmd);
> 	int status;
>=20
> 	sp->cmd =3D cmd;
> @@ -828,7 +821,7 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum acti=
on action)
> 	ENTER("qla1280_error_action");
>=20
> 	ha =3D (struct scsi_qla_host *)(CMD_HOST(cmd)->hostdata);
> -	sp =3D (struct srb *)CMD_SP(cmd);
> +	sp =3D scsi_cmd_priv(cmd);
> 	bus =3D SCSI_BUS_32(cmd);
> 	target =3D SCSI_TCN_32(cmd);
> 	lun =3D SCSI_LUN_32(cmd);
> @@ -3959,7 +3952,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
> 	int i;
> 	ha =3D (struct scsi_qla_host *)host->hostdata;
>=20
> -	sp =3D (struct srb *)CMD_SP(cmd);
> +	sp =3D scsi_cmd_priv(cmd);
> 	printk("SCSI Command @=3D 0x%p, Handle=3D0x%p\n", cmd, CMD_HANDLE(cmd));
> 	printk("  chan=3D%d, target =3D 0x%02x, lun =3D 0x%02x, cmd_len =3D 0x%0=
2x\n",
> 	       SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd),
> @@ -3979,7 +3972,6 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
> 	   } */
> 	printk("  tag=3D%d, transfersize=3D0x%x \n",
> 	       scsi_cmd_to_rq(cmd)->tag, cmd->transfersize);
> -	printk("  SP=3D0x%p\n", CMD_SP(cmd));
> 	printk(" underflow size =3D 0x%x, direction=3D0x%x\n",
> 	       cmd->underflow, cmd->sc_data_direction);
> }
> @@ -4139,6 +4131,7 @@ static struct scsi_host_template qla1280_driver_tem=
plate =3D {
> 	.can_queue		=3D MAX_OUTSTANDING_COMMANDS,
> 	.this_id		=3D -1,
> 	.sg_tablesize		=3D SG_ALL,
> +	.cmd_size		=3D sizeof(struct srb),
> };
>=20
>=20
> @@ -4351,12 +4344,6 @@ static struct pci_driver qla1280_pci_driver =3D {
> static int __init
> qla1280_init(void)
> {
> -	if (sizeof(struct srb) > sizeof(struct scsi_pointer)) {
> -		printk(KERN_WARNING
> -		       "qla1280: struct srb too big, aborting\n");
> -		return -EINVAL;
> -	}
> -
> #ifdef MODULE
> 	/*
> 	 * If we are called as a module, the qla1280 pointer may not be null
> diff --git a/drivers/scsi/qla1280.h b/drivers/scsi/qla1280.h
> index e7820b5bca38..d309e2ca14de 100644
> --- a/drivers/scsi/qla1280.h
> +++ b/drivers/scsi/qla1280.h
> @@ -87,8 +87,7 @@
> #define RESPONSE_ENTRY_CNT		63  /* Number of response entries. */
>=20
> /*
> - * SCSI Request Block structure  (sp)  that is placed
> - * on cmd->SCp location of every I/O
> + * SCSI Request Block structure (sp) that occurs after each struct scsi_=
cmnd.
>  */
> struct srb {
> 	struct list_head list;		/* (8/16) LU queue */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

