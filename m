Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497B0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiCITKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiCITKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:10:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2A213A1F8
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:09:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229J64bH011037;
        Wed, 9 Mar 2022 19:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eymkidUlbqGZdnqd6ZaTEaUT3DO6fzMFweMd2B8fnE0=;
 b=cghz3zOS8Fl2CGPWjgIXTZ9jS6iMy07tj3TVtDJc5yIw3Kc5ErrNER6hTqEJgfa/1y8D
 6DIKSLwnItCIlDulnxqPDkdKIS2yy4zm+e8Ypf4KA/E1TtP3teJWL3dxlYEO5hIj07CL
 evmeGPfUJWJzgE+JqTJ9cyWiXLqjlY7KxPqAZMcTMsEVKLGsS8s1GiKp8ZZ1SfT+nYw/
 JoXOHY5Q1PLQXoI1EhzDqyTDRCTaBq2ZC8xZqfs2cerZWquUu/K0VYRR4Tn1xrsxXQB6
 wjdTsB1bZuzyghqMKIWPKFlvumTdpgIMWg5eC5v18DOxgKm52shDdnH4/vRpJI68OD/J yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsk6v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:09:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J0QxE127320;
        Wed, 9 Mar 2022 19:08:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3ekvyw3ke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzQqlTSmg5KEozH3I+mksU63UYhRCVgwgVf6e9SmWLDQbFfMwHRXBqOexy8QOTDR96v7iZC1nrQaRSSGy/u948KKPenKZNcXnQB/KToR40CxcfmDeB4/ee3dJ1kPMWLVKAKsjMnLLudrTtgHCZaMKuziyPgkkGW8JVJ9LzmEwm0o29EoXbs+8TjCRudTHRejYfOt5isqJOccoi1bO3970NYghi9Lku/Yc15500vY+1wLFyTIUEwuaMg+SmMwUeHvW9+O7hf9AQyyt1Ob/fpWfKwl69R12A56ZgKSJfldS3CxzAl3b99FOe8B+8vktpgr7m75psFCBioMoOIflxmyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eymkidUlbqGZdnqd6ZaTEaUT3DO6fzMFweMd2B8fnE0=;
 b=AeQdjPP3rTy39TOSR0vnQN994g60cSjzDXlBmquHiSpnyYOGUv/bilLuA0ZaaD2KVCWNsepViXy7LKdzI6hwZms3UPrhEUFTsIZtV5jFUyNu8bqmrkZjUHPoT99LC1OWHeDiKdM4AWa3yPkmNtwDvRMJy88TKFwUxRnuzHuPzYaS19ViCRQ0gWsUz6Ur725fXO+8jW5WuPF6WwezjA2q0A0Sj2WVQdFlGIWgC4UZqTf3oqsPz0tbXfR548EQGxh5MxvGklYXnejjD5MBt0u3D8NFd9f+GyL5CofHu9fcxpFLHVidZDKBC4Mr6Bku978C+YIx5fRgY78afVFwLh1rpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eymkidUlbqGZdnqd6ZaTEaUT3DO6fzMFweMd2B8fnE0=;
 b=VE24jdzpc82bnFS1c4zFCAG4cc6ZV9BgGSp2LvusDTszyiYKMTZ8djvrcBv/1QSQpl7XhTAAMCcE1J9vJ5+Tv/QlOuFxcgaVXCxSuVjIjHXWEslnG1HEaM7kd1v4D10JwEsE/mtIJy/XAoOub2LuJdc5j8GnPhV5/CRWwXxotIs=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3393.namprd10.prod.outlook.com (2603:10b6:408:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 19:08:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:08:56 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 10/13] qla2xxx: Fix stuck session of prli reject
Thread-Topic: [PATCH 10/13] qla2xxx: Fix stuck session of prli reject
Thread-Index: AQHYMsWGgIBx48P5JEWno/2TRyZgHay3bLOA
Date:   Wed, 9 Mar 2022 19:08:56 +0000
Message-ID: <A529366E-DADB-4019-8CDC-0FCAA35DC079@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-11-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17f6430e-5768-4241-c916-08da02004274
x-ms-traffictypediagnostic: BN8PR10MB3393:EE_
x-microsoft-antispam-prvs: <BN8PR10MB33930D9C8638754C6D58A5BDE60A9@BN8PR10MB3393.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ia24m+Nkhk4I3Vug5V4tikKfxIKw6u7Ux8LBZhG/hWJN06lG0mQIjCtt5rkPKjMmP4VlHOVJ1Ze5xmif0qlWdNQh49yPD9qakfDH8yl2DNvIOVzc7oJy/vVJDD0f+UI9EKImPLINfyTwv6QRh7dEcLDz3EPV7Sosmv7ESJKdjNDEpcsIHJ3y+HV5L/mcK5pgkz5KmAC31sBrcM/w/15KwnXL+SLVFJPqHi4MH0+/J7Z2G5okHK+ZnSwAEHa2hkFIKctMhfq4B1f3oOnmmj8cmay827cRew6Kl+YdoWxLryn9i95AWvwoXz0rni7HqHJGIWE3bsfKgtebbnK91h1H2K07b3Npf0LVGCR3VFL2SSRZHuVV2YMG9HrmoV4gRGo6sbnwLtF1gPnUW4iFA1YjI7BDBJu/pB8Ef5ugbnGcVpJIQs/Zlp8LjMtbsIJURyIN9lhJz8PWmsCgLeEQQrIsoIsqsdO1xY1Bmf8jv2JfbYS1YwgHfXPYdjUNMiJPz3xOMTu71J91/5w4QvKuKHCuAHB6JyZXpjFjqvlKgWYsEKwpsmRFDNTQ3C32ADMFZFRILlOsDSA0HdnJ9wpHywTT2Q4j2DoNLZOcLt7vAC/u1noKnrhvzXj7NePD4GCFACbGrOhUntaEDTRs4DwE082zOlKovxgbGe4zpjRRl7VMvD19i0IuDflc+pY9TowsjBV6OYHVtXS4SsUTJXlCZyikLV4OTtvevJ37VpdsqIScm7KBzJPVKdhUoEtx0pHnffD9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(122000001)(36756003)(53546011)(6486002)(91956017)(38100700002)(83380400001)(33656002)(71200400001)(508600001)(6506007)(2616005)(6512007)(2906002)(6916009)(86362001)(38070700005)(316002)(66946007)(66446008)(66476007)(66556008)(54906003)(5660300002)(8936002)(8676002)(4326008)(64756008)(44832011)(186003)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mc+ICt1EOEUwJ8eykehusJl5B2sQ4Zo5u2qJt5pWcgES2YaSHxTj5wMh7NlG?=
 =?us-ascii?Q?RONeRB0hSfV8hoMvU0UF7aakwI5ofDC2UUj74tIbTxQsr4ijPUeLrqSSRBc5?=
 =?us-ascii?Q?9Jqj901MiID794SYvuzgSVVLeoBa64vZzp4S7OYA63itYeJu2jMrptbDcVgs?=
 =?us-ascii?Q?aiR3ELRYWbioS5rv5KNl+Z066ObGPkqeLKRfbssgd+xRpCxewD0O7l2PesfR?=
 =?us-ascii?Q?vzi8DY+DoUpkgf6T+7+SaCNQghqItSREEtwvhvCs0BuirR8CaoWH7qJQdgg4?=
 =?us-ascii?Q?d2tsjvJGvjXWbIA4QLqLiKo7D8cpYEDjM0YSINpi1PDKNrd389LhgRad5T0c?=
 =?us-ascii?Q?CQCPq1lmqfYyKNN18HrvmuVs+QGHvD9BJFlC2lrD+lotSQTa2viPV8za0rcB?=
 =?us-ascii?Q?xa+FXYol9wiYWYOatCARNCHpYjs2ojRFTDxvohSyqf8GAiOgY2cTHdK3PywK?=
 =?us-ascii?Q?FxhpEcniXz5TZmYZy8L9K0pg03vya7/cC57qzp7jvy9uU1RCj0yBsTf1h1s3?=
 =?us-ascii?Q?ilqpVefQrQELNR4FV/zhkksjI6FGSxj0YWS/5tAhjiSgxVIzs/ogTOoY0SBl?=
 =?us-ascii?Q?pxOFAk3e6hRFz5kSqnCOWI8jWVf/+IYza828xw51PwLoytbJCAb5Cc6bzvhv?=
 =?us-ascii?Q?5iuKHYHLpKUbvTdujGA1Fd4l+S8nHvmXFq/9iuqWpe5uPcEatO4J/jLB7r5+?=
 =?us-ascii?Q?+cJrOtTBhkIET1IlwfqqM1kf81C5DXmoU3X3HDtVij7i/Dg5lQxLKMZgRC6U?=
 =?us-ascii?Q?CLNuFyNsHmLaHmgUyoLkssozjke2iPEwltsUfLI/C3iUSvOFqvbNbcyfJykl?=
 =?us-ascii?Q?GPGbect6VXeFXJHf66OJMN4Ic7orFk8J7+S5ZYs68cjxDN6KOLgwQx8orLPq?=
 =?us-ascii?Q?uWW6IMBJvu4KbbWvf8LB2TKAyu427FEfnqsBuwidskSz33lyu/YIwrDPTSWa?=
 =?us-ascii?Q?7Ob4I58yMdvsBkVbx82V7aHZlwKe8WQ77Yrv1EDnuEyAiqx6pgJfpD69V7iX?=
 =?us-ascii?Q?vc7Zmnx88t/1lhkR3/l+8xj0CBEL6XdAQdvQqlW987HWK/2VombU2AI/Inrf?=
 =?us-ascii?Q?F23eM8vRZMFvetMeEtsicmzQlSUeymIASOdbzvvyA29oRqO/vPrhnNLl9yGB?=
 =?us-ascii?Q?iYoCzycVpiVkwdDy7HxaFave7yuwWvMqO0pum2VUqxxcj5S+iGoqe6MWgq8A?=
 =?us-ascii?Q?y9HdiA1CR1ed6aYcnDZdn0d0qbWDL1emxdZnKAY1HX2ZHDve15tRd8cvWw9L?=
 =?us-ascii?Q?Ec9i9n0fVBF+F8HxvmFu0KfH3kecKUoFro1X7Gia1p5OvHOOjrOYCKz/kYKt?=
 =?us-ascii?Q?AchIrk3KrtwRv0H4N2+oPGG6pXppsIIDIoJuxDzls98J77X+NcnJN1OrA8BY?=
 =?us-ascii?Q?hVZtm0JIEjvU3dcOsJIuFHww4YQ9NiipxuL1URaW7gTYumH/rWv6vyLB/ei/?=
 =?us-ascii?Q?3a5f5w2D1VnulvJ57duedx/P7y1nWhqATX4+7oPU8Q+HHNeTPSm0Z57AqG/I?=
 =?us-ascii?Q?JrF5Hy5d2ath5yKf0XSFwOqyVu8YOy0dDnqqhYx8WnzEr7N9iLZ1MdjzrwHN?=
 =?us-ascii?Q?nIePdp3ag3mKb0TvA6dLndJhp4zV72S3n+E4djRfuCO5QYEIK7rhe5/Lu/ne?=
 =?us-ascii?Q?q4UVA6YueObYE3y37tSEa+uaFJiRVP+QP/nYcnsXTB6pexvZC0yzkeBZRY/Q?=
 =?us-ascii?Q?JAmPxxwxd1PNe7WAHRaOJ4CoK8I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3436A601B24804499A6EBAAA8AC6E26C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f6430e-5768-4241-c916-08da02004274
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:08:56.3458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZUm2Td2VVBMCcG/IMstpKhfhVy9UA9O+zffHkjGJAs+r8RtF65m77d+HqPq/PxrF0Ils2GUnE7GqZVWvcTRF4XyQUiwvcx+X9B4YroMSG84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3393
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090103
X-Proofpoint-GUID: T22we7J_p-7eZbhnLXYyMS8YkYIjJuqy
X-Proofpoint-ORIG-GUID: T22we7J_p-7eZbhnLXYyMS8YkYIjJuqy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Remove stale recovery code that prevents normal path recovery.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 1cbc0efcd9be ("scsi: qla2xxx: Fix retry for PRLI RJT with reason o=
f BUSY")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 7 -------
> 1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index a53894444460..bf6979eb478a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2105,13 +2105,6 @@ qla24xx_handle_prli_done_event(struct scsi_qla_hos=
t *vha, struct event_arg *ea)
> 		qla24xx_post_gpdb_work(vha, ea->fcport, 0);
> 		break;
> 	default:
> -		if ((ea->iop[0] =3D=3D LSC_SCODE_ELS_REJECT) &&
> -		    (ea->iop[1] =3D=3D 0x50000)) {   /* reson 5=3Dbusy expl:0x0 */
> -			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> -			ea->fcport->fw_login_state =3D DSC_LS_PLOGI_COMP;
> -			break;
> -		}
> -
> 		sp =3D ea->sp;
> 		ql_dbg(ql_dbg_disc, vha, 0x2118,
> 		       "%s %d %8phC priority %s, fc4type %x prev try %s\n",
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

