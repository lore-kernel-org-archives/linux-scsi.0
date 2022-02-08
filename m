Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D96C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 18:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353522AbiBHSif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 13:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiBHSie (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 13:38:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1658FC061579
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 10:38:34 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218Gf1RE011047;
        Tue, 8 Feb 2022 18:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hUrzNKXu4NGdZOoPn6HABRplVjC+FZy21qXknQOjSqc=;
 b=JjAlzw9ae1E9OXSa5A1FJDP0lgUrU2/HSlYxMDpFiPixbyPUDqxZQASYTcgjegoJMMVu
 isJlRpqvmuybBd6QDt9jOa1Ds4rm9wVky29CUuRDgmG9GEvUYahmHYJq31sP6RV5W9L0
 5JdL2JTIUsqdCIqEWzXWgaSCz+jMYAgwkBDBZh0ybV4YmVw6zKy1xmkK7W2JQIcYNw2Z
 QQZAYUmbznfjLue1MISQ/r3kXOBq1Vf6f7TxlF3hGzdXzMFMlToMQG9jmYY39F+UZDwe
 EZLSm2dYsMdQ+DnbNTMCcSb4VwP5DUemDcZalFl7FiG823WkhZP5NhJpKu70JAx2r4sG 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdst9xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:38:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218IZYUY159331;
        Tue, 8 Feb 2022 18:38:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3e1h26taep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:38:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/5ZH1EZYxe0VhBfVoxbF/sJCocWbZzQSNtt1VpYe/8E+msFoX92gfjvS5y6KBATs7d8LVYSZ/Yb4mXcgIbKsSfHadiymaRbEnpQEbRBb9HcTf4YQ8TwJ0AcZH/I5zpjQ8sFeqHwuI16ssBVCKj1ZY5bDyFXNlAXI8bCWp5gsYh2XCM0Iw1/0H8wNTYaD7rlQ8NZ1yJBUUq/fgnvhgPkmy4px59UmxYldxLNWJ+jbu4qCdlJHvytDVddnMMJp84NKu8rstn6euGjKywGfipejNnumKL3KqIXmgqqc448CUkJq+56shNvCZJv0NMnFQiYGinQ5610fpKpdXk3pNMYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUrzNKXu4NGdZOoPn6HABRplVjC+FZy21qXknQOjSqc=;
 b=NPzJFtuEBsuqzNnBicHQYOTOdbU08YBW6KJTKn1jp/krtpZxX5Z3gf3NlBspLFOaG5NB614Uyfc/smN3BPqZJ/DUBl/pjqp6YO2q1zWDTnklPQlo9zgr4tSktuzTXhZP8DtRb5Hb0lMC/8XLRqvfVKfCeKQ+KvwT1ZuhaY2r7J7WKORHYMnAn72yIXKI8GXFMxDnUcRfQzhpE1akY2nYx206hC3YVWuh61pYDxkab11zrfWyZRPGlo2Z4tcU+pFhPQmQQWJ2aJ6cTzXayjaG+P7ft9NKXkao4IuzzTTs4gSQPmHoLCjRej2OzGc8l4HBPMXwxx90XOsBkeVlbUEmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUrzNKXu4NGdZOoPn6HABRplVjC+FZy21qXknQOjSqc=;
 b=j32bFmf/lDRS7F/kFDQRGDs57Ez6sTLc1PnSi7nmoUtl8BOBzCI5U+CddoppUV42ugV3mWjsTpd2F5a2tVnyQH461xr4NpfT2wfvseqGecVdWSeaxahFfBPPHZ00kOYEaqD/RxTXVlWMxdQrYLE8FDh9BS/pLvMzvHAKOOpeH4I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BL0PR10MB3076.namprd10.prod.outlook.com (2603:10b6:208:7d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Tue, 8 Feb
 2022 18:38:23 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:38:23 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 37/44] qla2xxx: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 37/44] qla2xxx: Stop using the SCSI pointer
Thread-Index: AQHYHREflo2+FJ+PNECf7P9mYgNwZayJ+/YA
Date:   Tue, 8 Feb 2022 18:38:23 +0000
Message-ID: <4C624356-EC6F-4FAA-B8A3-6C46750FBDD2@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-38-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-38-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 975a3491-1d4a-4280-6849-08d9eb322ffb
x-ms-traffictypediagnostic: BL0PR10MB3076:EE_
x-microsoft-antispam-prvs: <BL0PR10MB3076EDAE361ADC3AF9980B80E62D9@BL0PR10MB3076.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Abl47aulc1PQqaqTBO/9Hhm5vgOFuexyTLWTlI08vUPX3OSWJ2yYNp7rWk3u2koCuErUqDMgR0CrtssaKW2ss2AZY/q05nKuLbd97J7Z4h3DfTFQNobA2kej5jLitBQezjNJbJzC55JhGoD7l/1JNWgc+5tlu1eRhxtlgCykGuRH2KNf9ObwT90sbki6+7CMaOBL02JN3lB3rLbXQsfzDGz+plypDXigVHTGdB8Xl459AEbkqTc9347pCqrBa/2AGM3MPWICu+LIWxDjAkPhN0jweT4rOKuUsebaI4oX/Qb8hK1b9mR1gb+/fLVHPyz1RWXTVFndq+nRBSc69+C2IAFh1t6JYgk0qMRNJTVkmtKpelShrYHvphzJ4tHhtfS+7hlcEdczAEZTgyE2rEZren6P5h61vWgONUgCxyd90usfXWgapJgCBZiIa2LDWJzsU+QjOKz/ZdIjAN5figPi8rCh6gx2hDIdTJQeG+G3dyE/nq/QNM3RsmyooVUv/c/UBzAZ1M6LC4YVdaH/verpyzy+BfZbu+lDFN0cetX2g5P67xqQxOLpseVanKHsDXOA6Jm5MIxS0R8Uc3xCf1tjHJjDzthOAAKAe5vU/WM75gLy0kWvyfkgQc+fJnugMZxh5PeJBAOLoZcyQNvTN4QVj+b2CKez2yr+jG8ueTClTP3XbUrYDvf4BPvcfIOUBdIKxSxL30liTKvxY9LJi8AZNQKVBcelGsr/z+gF28y/UhOmXHh6ezm8OJ/5hEhU7OHm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66946007)(71200400001)(26005)(76116006)(83380400001)(6486002)(186003)(5660300002)(66476007)(66556008)(38070700005)(91956017)(64756008)(38100700002)(8676002)(8936002)(2906002)(6506007)(54906003)(6916009)(36756003)(508600001)(86362001)(316002)(122000001)(4326008)(33656002)(44832011)(2616005)(6512007)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IetexqOyGR+TsR6ouBNwN94+onWrcvSK7ZsQYXdtxJyvsG1wH4uJDf6AS7K/?=
 =?us-ascii?Q?y4EaJ4mvbGOwQQ7Ldn6t5HZfPP7L3F26X5yr5roqww9Yb7Qg9skBe4WOeZuJ?=
 =?us-ascii?Q?9z9Z9501ZlJk7IKVQt05r+hqpD5Bw7IXtDVcZP/SzqKqegjwDcqZSJisokfo?=
 =?us-ascii?Q?UqAezX/5Im5mKEY+dLD9h7epl3LaOohwmLcSVZQxWIyYa93nexSnzhxmyam2?=
 =?us-ascii?Q?ePUcGzwq8UgRD/6sTTZx7Pcz51yF6H01G2wQvTLJWg7361XwY9g5xCZVPwZG?=
 =?us-ascii?Q?c0UmToZUtqWn8Zdf9/wQkUz1K8lSlg1jrItrefSawpnNTjG+6Ntd2PPTrwzH?=
 =?us-ascii?Q?C452fFtcQVbK00CyRMAmg7TTMppvKuqQaTzZnx8xlY/Tw89TIj6jzh3+VGnP?=
 =?us-ascii?Q?fCY5PKxfyuxsihtt+SdP6v64dJKr5dJHqf+LQTE62lxFCxK0fw1AClWqBQ7n?=
 =?us-ascii?Q?sP9HeOP/8F8qOb90SnAafxxSnQ9t03ikGjXiz9aj46T9NOzbyycJlsA4D53U?=
 =?us-ascii?Q?TTXn9OLV4ZzJFtzrPrQIaNtPyCCeiFDqaSGdOATCA3sJz0XmZXFQmyduLquE?=
 =?us-ascii?Q?pvonx8CMoXhxnoQ6nCc30kprHURmuWDoo36n3Qpql1pRPZ9Nx9MzB3MuqpIX?=
 =?us-ascii?Q?3wUTv4cmxLQrcsih6M34TB3TeMPhXNhARR3ZTwFDQgAi+FRJBOYXuHpFEhei?=
 =?us-ascii?Q?l6OJUSwewXLagiO2YaFKDJNQ+4apNICEBJLMeMY36tY5E6JbrIdOEGD52riz?=
 =?us-ascii?Q?xi7DjcYFEC0RgFv8dD7QhK1ZxurIlINIp7FUX6fLNdONS37hx2m1LBIo8+sz?=
 =?us-ascii?Q?lRu52dNBB4vEYyjZHMdWAwHLvc9xZEEueVCnJeg6Txw0QaCxMUZHlPHQb/Ix?=
 =?us-ascii?Q?OrOOTW1bkhSeajFPjPVcvmhjXXt3crkUh1QoBEsMLS5wIW2EgflNdAjIgoel?=
 =?us-ascii?Q?vdwQiFlQQomT4246sUM17UyGK050HfELmU72PRbwYXkdciE3BAgWjNcF4iVA?=
 =?us-ascii?Q?LTlhkz20JPKYd9h6IufD29t/W3xoCON/acN/6t2rI1uwlyx9alXsCM8V2xUt?=
 =?us-ascii?Q?aI3ACRWNf+qYDduMbwLEHY6Q4rhBh9eRL6/pBpHUgQ1EDrh6so+voMYVIog0?=
 =?us-ascii?Q?JSzluGHbYlzqqodPtHK1xiOBfLXPTW/2/3KpzkjlIaHPPqiUeensAu7AZvso?=
 =?us-ascii?Q?aEnKdghOnlOwo///DqOY3yRFB+coEZAElD/xdEycKK4IGsFXRbtvPPy0xis5?=
 =?us-ascii?Q?PGGvpAKS2xiLG52R+F7Gv07TRlBS/TOsjXvEL1QBtxLM48JsJejLnqAjs9zH?=
 =?us-ascii?Q?IGa8gDE2VyssIrJcqvVJY/WXA0etvjJ4kIGErFIzUE6OQBhRTAMeYOol92Fr?=
 =?us-ascii?Q?zTNKy2F//Cp0puZXiJIhGaf0MrjtBVa3bozYfua9Q/DwT4Jrgyqxrai9r6Tp?=
 =?us-ascii?Q?vKKiuNe49YXZG0mOeCu/smDzHKYefMwzpfAJeI3/h8NQNpyoKO6Ra+4iUEzl?=
 =?us-ascii?Q?5fcUW9JKnx+O7zfVi4wJrRiUbbRK5FBn2FbbPCE7yfwgPHr7zg71WkK7b762?=
 =?us-ascii?Q?NjxeZQuOmGWVBefS9xI8HyxN3ong9zNwhhcgxhhIERa0AGdwq5NHzqvLb4qF?=
 =?us-ascii?Q?tR5D2jIm9buoZei3Zh+fkI5Xka8juRPkwfu7hsx6RTw3c+6BDsgVofukFuNe?=
 =?us-ascii?Q?gz7OU3CUd+THEly0b/bIy/SO7II=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24A77D35493EBA438283B0F1EDF0A085@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975a3491-1d4a-4280-6849-08d9eb322ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 18:38:23.4283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKPh3RcTLw5uqK+j8qrpgCJQO50KPdOsHkdL6GaIwOVpUQWlYugJfUCHzbExKcwDcDA0IsxVZsTx8x+8Vv3sN81vG7UFsMTOWnd8RQw//TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3076
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080109
X-Proofpoint-GUID: tEIuEBzV_Ho2v0uuPrsXuzd6G_uUQPpQ
X-Proofpoint-ORIG-GUID: tEIuEBzV_Ho2v0uuPrsXuzd6G_uUQPpQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Instead of using the SCp.ptr field to track whether or not a command is
> in flight, use the sp->type field to track this information. sp->type
> must be set for proper operation of the qla2xxx driver. See e.g. the
> switch (sp->type) statement in qla2x00_ct_entry().
>=20
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_def.h |  2 --
> drivers/scsi/qla2xxx/qla_os.c  | 13 +++++--------
> 2 files changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 9ebf4a234d9a..064496f9eba3 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5191,8 +5191,6 @@ struct secure_flash_update_block_pk {
>=20
> #define	QLA_DSDS_PER_IOCB	37
>=20
> -#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
> -
> #define QLA_SG_ALL	1024
>=20
> enum nexus_wait_type {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index abcd30917263..6c45379a5306 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -730,7 +730,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
>=20
> 	sp->free(sp);
> 	cmd->result =3D res;
> -	CMD_SP(cmd) =3D NULL;
> +	sp->type =3D 0;
> 	scsi_done(cmd);
> 	if (comp)
> 		complete(comp);
> @@ -821,7 +821,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>=20
> 	sp->free(sp);
> 	cmd->result =3D res;
> -	CMD_SP(cmd) =3D NULL;
> +	sp->type =3D 0;
> 	scsi_done(cmd);
> 	if (comp)
> 		complete(comp);
> @@ -923,8 +923,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct s=
csi_cmnd *cmd)
>=20
> 	sp->u.scmd.cmd =3D cmd;
> 	sp->type =3D SRB_SCSI_CMD;
> -
> -	CMD_SP(cmd) =3D (void *)sp;
> 	sp->free =3D qla2x00_sp_free_dma;
> 	sp->done =3D qla2x00_sp_compl;
>=20
> @@ -1012,7 +1010,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struc=
t scsi_cmnd *cmd,
>=20
> 	sp->u.scmd.cmd =3D cmd;
> 	sp->type =3D SRB_SCSI_CMD;
> -	CMD_SP(cmd) =3D (void *)sp;
> 	sp->free =3D qla2xxx_qpair_sp_free_dma;
> 	sp->done =3D qla2xxx_qpair_sp_compl;
>=20
> @@ -1057,6 +1054,7 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
> 	unsigned long wait_iter =3D ABORT_WAIT_ITER;
> 	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> 	struct qla_hw_data *ha =3D vha->hw;
> +	srb_t *sp =3D scsi_cmd_priv(cmd);
> 	int ret =3D QLA_SUCCESS;
>=20
> 	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
> @@ -1065,10 +1063,9 @@ qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
> 		return ret;
> 	}
>=20
> -	while (CMD_SP(cmd) && wait_iter--) {
> +	while (sp->type && wait_iter--)
> 		msleep(ABORT_POLLING_PERIOD);
> -	}
> -	if (CMD_SP(cmd))
> +	if (sp->type)
> 		ret =3D QLA_FUNCTION_FAILED;
>=20
> 	return ret;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

