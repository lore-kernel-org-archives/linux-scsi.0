Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD6CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 21:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiBIVOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 16:14:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiBIVOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 16:14:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C580C0045C1
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 13:14:12 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HE2wn027620;
        Wed, 9 Feb 2022 19:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ia2i+e01dJTcamXnbm6WCv5VKpIfAx+BvRrsZRe4dMc=;
 b=sY1uz2biXXrV8ITBQbLODiaG6Wp9lwKoU4t0FCW5upnxMzuoLViWoStlQfnvrOkGB87n
 U+A9yn9rXRT7abdpfajGhJq8JcZn5slvMS/plQsXDA4maD4ufAmAW8Bs/+UXvkHaxrKR
 Gx5MQo+KLzbx3vafZAmvwlqEdXiDI8Gow3bEkVKlURQtc+ss2A7hgKR5Zjl5V9ScITzu
 8mDdXcd5P/arbKoqnbHmFSVg4JKnpcpu+4H46UNDCee8eVIbQsjtJ8rQ5HbJWC86G/N9
 7tAVSmgDc+m5LwtgzgVunqxCI3MW2NENRJs0mJC8a9kC/72mEylg69JSHUp9JJjQtUpb dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdswh6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:11:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219J5cGe157377;
        Wed, 9 Feb 2022 19:11:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 3e1h28tytj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:11:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcwFixMpEGZvp4x0TCXCBo6ueP75p4QAiEQmRp+WAT+VfjMg6W01D1Yi0q6XtCNcFKFK9F6AH76ANq2rrya9hkV+Q1a0/gIQ2Ja6bTm0Vkmkq6V8C2tMtrql5GJWbqku5DXEDiNdVBhCXZ0B5TIgh69mKMndOD/gltZZSac1s7GHVkCzjRD6n+/cwCwUfnzLEulpAxS/oU1lntl5JAqIJdEAC2XGStxicy/swRQ7s9AGd9PMIO9G/arWICpdBd49X3OTAxDaoBzrx+oLSk9e8e+q/73ayF0KMcWWgaq5igY87iRV5zuHy2v9LMNHEaVLJHb2TvXF3w2lq35mFJ2rpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ia2i+e01dJTcamXnbm6WCv5VKpIfAx+BvRrsZRe4dMc=;
 b=NpiV/r+aFU/weoQmn0InmgwG5GsW3S67cSyjRqTUSwCWdRiBOPF5pxRYeZG49jib0CB7UbTGhCkgnEu/e+fMLVDeqStl1akM7XLVE5QmOs+ibCqfmdK5+UGv0EJoYtfGSK9EeZyn9fzotGvs4LTvN4vLvu8zoN8uiqtXl0hE4Oci1jDGqp6bPv0LMqxWRrRgLlmp+0pmshrsJE6qsqbWQ+mXBAf1XdGQsSkSlaWcpYtXB2/cTbijjnrp47VgIHjNts15BXVHrdp48TafjoIMXmGaSRdzuKE/527Z/xeFLpK95hQswVhou3ko+xq8YLGU5/B7Q1XG/oD+Biq+PDfYlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ia2i+e01dJTcamXnbm6WCv5VKpIfAx+BvRrsZRe4dMc=;
 b=s/XBHIS2UQfa+qD9gkPSewicZmeC+ZGeAHRTYApB7MJ9qbDpG0owayKKTfG8DXo988hUHZte1DlaY5RIHqWsi+aoiho2ZAPct7E5ApApiw5eAt0pzStSdOLnr/lMRoEo7xU3Qw9PPM8uuVQnwu0ftTtqSPDoOcwwSGIz8L9nbY0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB4098.namprd10.prod.outlook.com (2603:10b6:408:b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 19:11:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:11:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Helge Deller <deller@gmx.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 43/44] zalon: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 43/44] zalon: Stop using the SCSI pointer
Thread-Index: AQHYHRFHyqMAqJMXyUKTD7LoPFvP3ayLl38A
Date:   Wed, 9 Feb 2022 19:11:19 +0000
Message-ID: <D709F32E-C0F3-4434-A9DD-DBE08722DEDF@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-44-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-44-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecf561a8-3b39-450e-4772-08d9ebfff3f4
x-ms-traffictypediagnostic: BN8PR10MB4098:EE_
x-microsoft-antispam-prvs: <BN8PR10MB4098C1231E898CA0157C8FF9E62E9@BN8PR10MB4098.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQd9kp7YAnOE+GD1sgAVKwvv+jtc0pHzb+j6h4X9ljw8cuQrLuqB/S+VfKkVu6Q+nmUJmBXcxbJ3VI6UlLB5azAUGfeun1NbareCKHi9UzRAi59Q0uA8J3L/6IdOORleFdWHtz2oK/tceF5Lqe7Lw8upjTMm4436VcVzldk+cLlmJewoEUTOe/xpH3Zaohd7prvcaareDuX8zP4x8Ui3ftkJ1mmV4Sj6fCwGFZOxR+jdScrjdIZLpohFhzkcPsrdBGIyjofycApyq5MnSaY+3TpXn7Mm0CeewOfaTZj0v8kCvaFtwJE3q8eEz4RTpFI0+GzFAAOTqnTFU0tvOaSHbfU/mWMeS2jKf5Lp2GK8oBA5St5wwM5NzUpDqa7WPm1kiqQMUNWZzY/o4/W4f/nL06ADKk79nhe+NRc96S94Ibbpv0XtGAPubNbiBmGDRA2DDjnZdYZy/FqxQIo6NXe5Se21IbuMgb31Gsg36rdXLQkxi630cB4YJ7Th0I/QbdCzImY8Uh0o1DUgwD6QY+qOJBpQiW7kYYZUjk4sqRHn4iKnVyPr2yal+ZqyBDSoEMccPoRhGlli9xhx40tW2gCMtWt02N3CgsWu2uWjdETG5Z+AGjooiZe2yfTU2DkceyZ4KyChqL7Y3Ho4fcsvgMsvuGKqpegnrSvtyuooWKZrSUmKAPqgOY9nMY4+cqskdPTM9zkUVGBlh4+JOxAYfStjK8zAifwKNjxzb/clGCg5B+sTlVxqiwyxCpu9fyuYNvZO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66556008)(64756008)(66446008)(66476007)(186003)(66946007)(4326008)(122000001)(76116006)(8676002)(83380400001)(86362001)(2906002)(38100700002)(44832011)(54906003)(6512007)(71200400001)(316002)(53546011)(38070700005)(6506007)(36756003)(8936002)(2616005)(6486002)(6916009)(508600001)(91956017)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cnqZBsUHx4BnV5lACp18M4ZhyVtHt5Uo+i3BiY8+WC3xsjOt7w3xUZQoD6bF?=
 =?us-ascii?Q?diDLgYI0ptaySPzb3mO7QF97vOrFUHfE3/5TvwsJLJDhD3HedEz/JZQ5vWKj?=
 =?us-ascii?Q?jkLT6Exaj3YPUaIN96p+nIy4/Wu+zK/yLkjwWINEBE+vwWGTL5OCwTvSxPJU?=
 =?us-ascii?Q?stHKFGLqAvkdEEfoduRAOEg+EsgTV/8Rr38KURSkEO7jRj6IrJz3GYqTSGxr?=
 =?us-ascii?Q?W8TrAYn4xOLsbwvfqIG9buIBfPF4ZihTsuYSYZaKbFbw0FoUJyg8UErm/GSX?=
 =?us-ascii?Q?FLMhn8nAp0S1unaBxAPShr3GBGMxAlSyU7zjzH/b6h3jvklwIpCTRUS6k0pk?=
 =?us-ascii?Q?tVIRGNqGxTYPcdHePtLvB3iQNs+seviA65rncanLs/mPWrz+T5/POWU9+Pe6?=
 =?us-ascii?Q?WoFgo6kOjqKPpd8bwvV8Mb6TQ1zefpKBAbpyBt4aF7xaq4tAe7CH8jpDPWkR?=
 =?us-ascii?Q?FFBD7axXLJue36YHZzfGJRrGCdpi26ENJ7Smln+MlyXQYLn7LyjR7640FWex?=
 =?us-ascii?Q?tYBnL4fS2NO3tWftXXGXx0Z8eFqhZ3uSVhk9LCJcu6Dhj9NEN/K+W+mPcKiP?=
 =?us-ascii?Q?bodvbi2GLDBmzG+58qynxvQJSE2whpiFzV8A18J2QEoLILc5nh6HKTlpprGG?=
 =?us-ascii?Q?Nvkjscqv4SC1gWboUzkw3J6IC3Q7zsk8BM674qG7FOBUDfrVekgOTr6yiY18?=
 =?us-ascii?Q?2/qEUZPwy0HOhvkVmW3HAufYM3Qs5YbHdsv0Z3Tm9O/O9dF7HGG4cj20V1f4?=
 =?us-ascii?Q?Ymrn3tQytIeN5QHNHEkVIJeKtV1zOpfMHMDp1DbsYJ8TV0C5hMQ5qDeriigL?=
 =?us-ascii?Q?NGnY1SY3v26ZXHduMj1k/TQ+SkX0OvvnwHqWXbj0+0Z8PZb5DgsjVH8d6DAY?=
 =?us-ascii?Q?IRZNjHKn+4X3Cx8Par6UJrojFAmg2pBZj6WVBMGoWJSnFw7hRmhsK1un206d?=
 =?us-ascii?Q?C1sjjAtA34SIziCfDIVjS4ReneaY447OQcd//Ewrii4MMlPgrKq+1zapZw53?=
 =?us-ascii?Q?bylsL9Ysz8cB83R1uwtMq+XnmY2VPQEBc8aNx8EwfyfpTZY+15NyfBKjUy1q?=
 =?us-ascii?Q?uTgmKWkf4sOZzzQlhXLhJQOYHGgrXGBXHzyCf8VtOwqmg0Y0cFKmkJ9XHJ7m?=
 =?us-ascii?Q?+RkPKSt4kZFuN5YYfONYTAzmQtdQVdT1jrsPmWWYIyTt7lvS+gx0gyzNL47v?=
 =?us-ascii?Q?aPS/5kt1VciWGtlOFBe1Clu/UyondK4VwcbHcLhapIyCxNuSzkUb1mikNfot?=
 =?us-ascii?Q?SsyUmqdtdgjDRvFe6L7b4sn7xYJt1KlzxyXOhrgp7aS6khW+qOxuvuUmuZDd?=
 =?us-ascii?Q?cFnDlBNC+q6kULvAMq8ffG6yqfYzQbwdqmuiFCz/rxykmJJAjPpVuk6wsJu3?=
 =?us-ascii?Q?1tzBiqKA8PRubRevFaJJL+cuU9ejw8v6anbbiWZgDnc18hliwBouKhfWK5e4?=
 =?us-ascii?Q?6LjDzauro6m8/v1D/b5oZDy10icnBllWc+OK5ereCNsnr2FtseFXaNQCl1Oc?=
 =?us-ascii?Q?0I5IOfYeubxsWH0B0lAnCIEwU829uTFk1v/oSFlc83qGXlFR1DQjYUTnDvef?=
 =?us-ascii?Q?fZHVGa4r/2BSm4dqlpV3qEe+vBfsXk0jMbQKcG3D22X90UpVWvoMzm1ebrPM?=
 =?us-ascii?Q?cClcRfpsWD8tcZlwmJEn1wLCUK45o7yMIXDd0emVTN1OMO/LC3Un4smMqS1U?=
 =?us-ascii?Q?fE36Ht+K7P3/aOXFuWRDQEFZkfwDPqJQSeahB7y+GM60Nw/z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC7AE34F36698349BD375CC6B7BC0D5D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf561a8-3b39-450e-4772-08d9ebfff3f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 19:11:19.0758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csHCx2/Roa+DhhV9MYPtlZ7Z7yQ7b0GR6NOvGO1DsX+b5eXV5n1abM2dr5l2d85PyP4T4EzagbNifns0GVeOd07bIPcGHd62lDnF8QCWXlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB4098
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090101
X-Proofpoint-GUID: 8BbcqWAh0PjulxDOkNAgvx1QIrk3sZUg
X-Proofpoint-ORIG-GUID: 8BbcqWAh0PjulxDOkNAgvx1QIrk3sZUg
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
> Cc: Helge Deller <deller@gmx.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/ncr53c8xx.c | 22 ++++++++++++----------
> drivers/scsi/ncr53c8xx.h |  6 ++++++
> drivers/scsi/zalon.c     |  1 +
> 3 files changed, 19 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index fc8abe05fa8f..4458449c960b 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -514,30 +514,29 @@ static m_addr_t __vtobus(m_bush_t bush, void *m)
>  *  Deal with DMA mapping/unmapping.
>  */
>=20
> -/* To keep track of the dma mapping (sg/single) that has been set */
> -#define __data_mapped	SCp.phase
> -#define __data_mapping	SCp.have_data_in
> -
> static void __unmap_scsi_data(struct device *dev, struct scsi_cmnd *cmd)
> {
> -	switch(cmd->__data_mapped) {
> +	struct ncr_cmd_priv *cmd_priv =3D scsi_cmd_priv(cmd);
> +
> +	switch(cmd_priv->data_mapped) {
> 	case 2:
> 		scsi_dma_unmap(cmd);
> 		break;
> 	}
> -	cmd->__data_mapped =3D 0;
> +	cmd_priv->data_mapped =3D 0;
> }
>=20
> static int __map_scsi_sg_data(struct device *dev, struct scsi_cmnd *cmd)
> {
> +	struct ncr_cmd_priv *cmd_priv =3D scsi_cmd_priv(cmd);
> 	int use_sg;
>=20
> 	use_sg =3D scsi_dma_map(cmd);
> 	if (!use_sg)
> 		return 0;
>=20
> -	cmd->__data_mapped =3D 2;
> -	cmd->__data_mapping =3D use_sg;
> +	cmd_priv->data_mapped =3D 2;
> +	cmd_priv->data_mapping =3D use_sg;
>=20
> 	return use_sg;
> }
> @@ -7854,6 +7853,7 @@ static int ncr53c8xx_slave_configure(struct scsi_de=
vice *device)
>=20
> static int ncr53c8xx_queue_command_lck(struct scsi_cmnd *cmd)
> {
> +     struct ncr_cmd_priv *cmd_priv =3D scsi_cmd_priv(cmd);
>      void (*done)(struct scsi_cmnd *) =3D scsi_done;
>      struct ncb *np =3D ((struct host_data *) cmd->device->host->hostdata=
)->ncb;
>      unsigned long flags;
> @@ -7864,8 +7864,8 @@ printk("ncr53c8xx_queue_command\n");
> #endif
>=20
>      cmd->host_scribble =3D NULL;
> -     cmd->__data_mapped =3D 0;
> -     cmd->__data_mapping =3D 0;
> +     cmd_priv->data_mapped =3D 0;
> +     cmd_priv->data_mapping =3D 0;
>=20
>      spin_lock_irqsave(&np->smp_lock, flags);
>=20
> @@ -8085,6 +8085,8 @@ struct Scsi_Host * __init ncr_attach(struct scsi_ho=
st_template *tpnt,
> 	u_long flags =3D 0;
> 	int i;
>=20
> +	WARN_ON_ONCE(tpnt->cmd_size < sizeof(struct ncr_cmd_priv));
> +
> 	if (!tpnt->name)
> 		tpnt->name	=3D SCSI_NCR_DRIVER_NAME;
> 	if (!tpnt->shost_groups)
> diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
> index fa14b5ca8783..be38c902859e 100644
> --- a/drivers/scsi/ncr53c8xx.h
> +++ b/drivers/scsi/ncr53c8xx.h
> @@ -1288,6 +1288,12 @@ struct ncr_device {
> 	u8 differential;
> };
>=20
> +/* To keep track of the dma mapping (sg/single) that has been set */
> +struct ncr_cmd_priv {
> +	int	data_mapped;
> +	int	data_mapping;
> +};
> +
> extern struct Scsi_Host *ncr_attach(struct scsi_host_template *tpnt, int =
unit, struct ncr_device *device);
> extern void ncr53c8xx_release(struct Scsi_Host *host);
> irqreturn_t ncr53c8xx_intr(int irq, void *dev_id);
> diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
> index f1e5cf8a17d9..22d412cab91d 100644
> --- a/drivers/scsi/zalon.c
> +++ b/drivers/scsi/zalon.c
> @@ -81,6 +81,7 @@ lasi_scsi_clock(void * hpa, int defaultclock)
> static struct scsi_host_template zalon7xx_template =3D {
> 	.module		=3D THIS_MODULE,
> 	.proc_name	=3D "zalon7xx",
> +	.cmd_size	=3D sizeof(struct ncr_cmd_priv),
> };
>=20
> static int __init

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

