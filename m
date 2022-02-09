Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD632C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 17:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbiBIRrb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbiBIRra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 12:47:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98B6C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 09:47:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HJq0P013540;
        Wed, 9 Feb 2022 17:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zAKfAcOnM4IltO3Be2Rqrm32Tl+iiuomhqVI4WxQ4Nc=;
 b=CMFEvV8CSgK3MLEBPyjTwF/X7W+1UdoXnIDTLWsgnJ6ac5zvptbQM4z0AWfZ+iq312SB
 hgPVwtWDJIQj92fT2u7lBqWmhGG+CPKNtnRV+q9wU90RbDEel8ay7GxIwYcaXPTQ6jv+
 sSG0/aKaQGQGCRgC3K9xkuvBLve7/+2HVg3jsLovb2WH+mNpkZomXaG6wXxUqUYia8Op
 1/vlzN92m4ACLh8Zn40c4RrVtv43Lem0RB7Fr3Y0WCbDJv5DolaqSTX/v3lxVEsXTHux
 gdQIhoDx46njv0yUN+g1kCEoyUwhTzTz7mVHuamb3RSyfJA9kfUO6jBKaeSGeTN9EYq2 jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sq8pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:47:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219HaciY059805;
        Wed, 9 Feb 2022 17:47:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3020.oracle.com with ESMTP id 3e1jpte97j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 17:47:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMhg5Olx7kfePFgUl3P9UQ+Y/WAUSBGDDDiNrhENjhqa4Mll4ub++vglP3eUUMlPx5BfmhsjDNiAdQsX5GJT8DJWZkLtBjvvkQW9RqzQWQXqmz54St6vLSApO9Ve9G5PrbzK6bSJMR1sK/g19aHGB24tYRy1Kq0ub4llfDIywunQswMW80CkLF2LcHfmKSpRdAx7X0hb4CkbKR+Oi2mNh+RBAXU79K5OsX9MH69g3gzJMqb5mUGhRxTPxDNsQ6Ul5EFaiLlRdBqUjPmtwXTaXoFAL0ufYoAhwVvZ7pTjjYtApEQIFZKMdBzr/BePZETPZ2Qs1aOtrFCXAYACROh9YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAKfAcOnM4IltO3Be2Rqrm32Tl+iiuomhqVI4WxQ4Nc=;
 b=hvRbrzTYkHw7Etp7UTeJI7QICNn5dO1w81UMXaCga3LAbIA7O1ef2JMKOacCB/sbtkLo+uzItbpF7VwK905Hd03NSgGoietjEFlAIXGrX2t0XB5ZpWidHl//H9VJyvyb4cR/MYAV2GDunsTJN12Bmj2Hoxtma87PjcUcXJj/5v9Cj7aX8Ib5KXoE9CCyhdgK3bYRnoH/UyjCq5DXpvFd3ZgS4xCL7kIRQKO0P2JV6aUT1XSGhdQreso4SnRNOtD1lcGwK1c5VhXR0G+CJgA01xqs6lXTZMZ3RypfVHKdTox1nx12yxFQ7bugTd30p+hrSm1dbDXEDLTlAQ4ajr3Z3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAKfAcOnM4IltO3Be2Rqrm32Tl+iiuomhqVI4WxQ4Nc=;
 b=eeCqjOz5iXgV5BSshnd0ud02+pTZ0mr0Ti+Ob+lBkzX6KyJVsFUZaV7TejHi8lDu2tDTCDlaVZb7BX8n2c9iodDgGDwwQTr7YEutMW9FS/sUd9cI5Fh6DyP4HOgIA2kY92MVP41BcBO9CLdO35Mhy3jY3Z8MToAYSSsaLF5sxcY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH2PR10MB4264.namprd10.prod.outlook.com (2603:10b6:610:aa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 17:47:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 17:47:21 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 09/44] aacraid: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 09/44] aacraid: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHREtlJIuzwDa7kKLXUoTrsiZIayLgAqA
Date:   Wed, 9 Feb 2022 17:47:21 +0000
Message-ID: <398FAAAA-EFA7-42FB-8EB1-909C0B4AFE31@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-10-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd9fa67-e191-463e-3eb7-08d9ebf4396b
x-ms-traffictypediagnostic: CH2PR10MB4264:EE_
x-microsoft-antispam-prvs: <CH2PR10MB426429A6EE6EC6FF68C53DEDE62E9@CH2PR10MB4264.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ovLEF+Hfr5Ma8dzjOrWeamFRzqqCvy6Us4ZLoN8ksRa0xYfuPLdMEVQjcWmmlb5LFtO2LrRKzMzNUDE4q1Xt6/3xH7v6UgcLgP1cJ9MDKLI09GYUk/Lr1xp4TLENgd0HDPUpzFkzQ8ONStBRjhNhxcLhW/F83C3jhxCEjUTlMJQe/mh0GI0RB6CUi4KomXZgmm27YVzkCUZW6+FMNsAv3qZOul05h1AC/5LhZTkvWXB3nNGkMTBMPM1U1vdUQMr2mXMsr4XmjJ2TJu6OsQ/hj/8+coJg/6pSrAS9z1yL12nGPsUEK4dXY22ciVbkNYGeQQbNtz0ddhZLxg9eDCCVaTZ83lj9pWWz7mBnMN8L+CssIfin5VYVhwYJVUrQ6PTAfbgR4K+xkun5kO0E0urOeNBm9gF2wziQs/Leme2OMQEw7QxZ7wsXC5mZWHHrtV8Jo2JwjW215wFMy7FjFB6vX/mBXkPb4mZ+1nlMm4IluGl8lOAeTc5wRHVBp3qb0KkaEleVKbEZ9oif3iHgbh+tpYvJEgmRB9dYW5dCd1K8ft7YlVBWNDNb6vRMZxcxdc4xVVbP7vRtIlfuFSyL3TaPeAt/6OrrjJfwHIfH1557hCwg71cmZL/gjxnkwDb1P9W+9Szk1k2rejWa6A5exQ6Zxm7IIe7w84wdXa7Cge3+n3JDUy0M0yKRXCWOe596lR+ni3bgaJCf79Ars1s0LK91lAxiYgN4iZMkY+vDL3/qYkoZYFDeoCZIjkOJuLWw/GsU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(86362001)(316002)(66446008)(30864003)(6512007)(2616005)(44832011)(2906002)(66556008)(4326008)(122000001)(6486002)(38100700002)(6506007)(36756003)(38070700005)(5660300002)(508600001)(66476007)(66946007)(8676002)(71200400001)(8936002)(54906003)(6916009)(91956017)(76116006)(53546011)(83380400001)(33656002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2NEbtOjR7rjb282sM2i7wNpgLSzt4NWjm6GZAMChbKe0Ev8XE6NEUyBhv8SK?=
 =?us-ascii?Q?kcxQMb/kB7JpSCWbJeZg5THloy8dQxDMqyq8PX/fN35idt4PNKbIGaOwZtxZ?=
 =?us-ascii?Q?Tqe5ZvMW1RCl+JGG3zhWiHF5lcXaRsLODVcz8MRiFiIYbjXtNuOZP33g7Zqf?=
 =?us-ascii?Q?Np9jfy+Qq7Z9gGU3tzcSfmvpzGRqBhFAD2Lh/MxmbNYINAGDKA+BahTXzTeF?=
 =?us-ascii?Q?pFvqkv/5x5eQobC1/3mGkqcjDOJNor90fo7PkiW20uT7JSAvec5TPnpurlS8?=
 =?us-ascii?Q?XuPiR1LUN+tLqOUvMyjbANVKMsvlBsEr2unJ+bBLtMkTnuloNhNuRdg+/Dcb?=
 =?us-ascii?Q?095KFgJZl968XHrhuEawtHNDnp8m/856r6/w8RtuKpjc1Q/uXOVQCIP+LnBh?=
 =?us-ascii?Q?MJpqzzcs5pJM8sw3tRig2aXPV6r9VcUks9q8akjmHkovCouazC+2eFdu5quR?=
 =?us-ascii?Q?P5Ff85vrRuZTlrm2B6UOiuhbAmisjMquWcmYehnmBqKKXnrGOS7J6eAGQlSY?=
 =?us-ascii?Q?AoBCPorS6prRNz94gFgr4XbyUrywrMEgHho91dWUOACMoTEEQts36L/J30x2?=
 =?us-ascii?Q?6kUXab0cv0BDymnPus8b/ncDtYOtB/CJUy5cYZobSw2/jc3a85a7YKwG00Rd?=
 =?us-ascii?Q?vcX38O0l/p0TNvJp9XYozkzMSxLeQamdqh8urzCihmEh6c/8RN9114esVkGu?=
 =?us-ascii?Q?/b+qbo6ngEVCRJppEGmLFFW4EwC+5t1Z/Q/upWfcs0lLrhKix0gGYU8X+g6t?=
 =?us-ascii?Q?z2f2helVeyDgU17AooSfG+pDgj8QH63dPYyovQu5cEuidbOnvYURFoj5mWMK?=
 =?us-ascii?Q?19dAvEmbee5MBxlyVLkgPbIuo0/xW2yGEXJmOgeEndhQ/CDZjLXuUisofF4n?=
 =?us-ascii?Q?R2wyinADx+Eg5TV1XX9fG6HiTMIGlB7eZUxJtgKNjs5jDUCFYvltfKud7hQ6?=
 =?us-ascii?Q?KTZYPwH2ohjuTZD+AqQV6In8wzb7eiL3T7UXpGtXSAisngisc69kJf7TalNb?=
 =?us-ascii?Q?ArkAK0H6qzovpbv+K+MbPGKJ0Hta8PC4QyPE0KoTK02TZj0mIR+797jC/pXM?=
 =?us-ascii?Q?6/zZWKwyCSnRBkC8dlxVC7VaZ6eJzpq4EVSB25P8Xmx6JlXjmS1M+Jbz0iAp?=
 =?us-ascii?Q?kHPg8cGNkgyIlUmyOqFbBbAvEH3ZF/VhHpE/oa4iHhEeqSxGaF+FfbLgXvZh?=
 =?us-ascii?Q?cckj21uup7wNil2TgfCg3SU+VQOmPJduTpiOJCm9mnfRPVtRgPjrEXBgCcYE?=
 =?us-ascii?Q?/J+agehY11vwr4VeWVtkFazVPAB9FRUFN0+evo1mfG9vfpgl8y2RzsUbc1Zc?=
 =?us-ascii?Q?58ce4An2CASDhL5xFdL9Ff4BkIESusmRs0X4d5MRXhqGry2iiZHTmpy/yZGB?=
 =?us-ascii?Q?p4sDTvaCWU97D7bgXszy3BjR+JQrTjS4Kgz4mwnluJORcPNG7oSCJjXcjuyF?=
 =?us-ascii?Q?WXBCZGiS9HoTEmq1gVvYLmesylAI7aywcZDUhkkp9lw9cwbUiHW5Kn+MvNbF?=
 =?us-ascii?Q?vDuTnzQR8SW4LP9wqdHiViU7+b049wx/iV4o8b0PUHi2Kg3/XUdhE7rk5NVJ?=
 =?us-ascii?Q?09lQ6ZUdSqTbIVaoKBZReTUFqovnMesUnXc6pH/YVyv48cxz028MyiJhCdud?=
 =?us-ascii?Q?2mFoMMRzfjd8DkI8CtPPdcF2sjgPfzZFFFwqz03TtSpnOQ9Bv+G6sn6gNXsD?=
 =?us-ascii?Q?oYLcXW55Q74cU25VwRHLDhUpxrxro055N+q8NvxsW0Fm9Y9B?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF30DE7C62596E4F81E16D8FFB872547@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd9fa67-e191-463e-3eb7-08d9ebf4396b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 17:47:21.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +qXzMXHTrlfmDJ972ED9pkAMj7bB/GE+6RfqmmZ+xq9kMfmlHDG3gqAD3AqCDH1JQgNiD+oZxG0A9QjMfffAnGluqty3SEj1z4pt3ey4vag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4264
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090096
X-Proofpoint-GUID: gZUHIiuQZuOntD4gJD1kjvLkQ3vBGSPC
X-Proofpoint-ORIG-GUID: gZUHIiuQZuOntD4gJD1kjvLkQ3vBGSPC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/aacraid/aachba.c   | 43 ++++++++++++++++++---------------
> drivers/scsi/aacraid/aacraid.h  | 24 ++++++++++++++----
> drivers/scsi/aacraid/comminit.c |  2 +-
> drivers/scsi/aacraid/linit.c    | 21 ++++++++--------
> 4 files changed, 54 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.=
c
> index b04d039da276..81462f4ddb90 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -338,7 +338,7 @@ static inline int aac_valid_context(struct scsi_cmnd =
*scsicmd,
> 		aac_fib_complete(fibptr);
> 		return 0;
> 	}
> -	scsicmd->SCp.phase =3D AAC_OWNER_MIDLEVEL;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_MIDLEVEL;
> 	device =3D scsicmd->device;
> 	if (unlikely(!device)) {
> 		dprintk((KERN_WARNING "aac_valid_context: scsi device corrupt\n"));
> @@ -592,7 +592,7 @@ static int aac_get_container_name(struct scsi_cmnd * =
scsicmd)
>=20
> 	aac_fib_init(cmd_fibcontext);
> 	dinfo =3D (struct aac_get_name *) fib_data(cmd_fibcontext);
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 	dinfo->command =3D cpu_to_le32(VM_ContainerConfig);
> 	dinfo->type =3D cpu_to_le32(CT_READ_NAME);
> @@ -634,14 +634,15 @@ static void _aac_probe_container2(void * context, s=
truct fib * fibptr)
> {
> 	struct fsa_dev_info *fsa_dev_ptr;
> 	int (*callback)(struct scsi_cmnd *);
> -	struct scsi_cmnd * scsicmd =3D (struct scsi_cmnd *)context;
> +	struct scsi_cmnd *scsicmd =3D context;
> +	struct aac_cmd_priv *cmd_priv =3D aac_priv(scsicmd);
> 	int i;
>=20
>=20
> 	if (!aac_valid_context(scsicmd, fibptr))
> 		return;
>=20
> -	scsicmd->SCp.Status =3D 0;
> +	cmd_priv->status =3D 0;
> 	fsa_dev_ptr =3D fibptr->dev->fsa_dev;
> 	if (fsa_dev_ptr) {
> 		struct aac_mount * dresp =3D (struct aac_mount *) fib_data(fibptr);
> @@ -679,12 +680,12 @@ static void _aac_probe_container2(void * context, s=
truct fib * fibptr)
> 		}
> 		if ((fsa_dev_ptr->valid & 1) =3D=3D 0)
> 			fsa_dev_ptr->valid =3D 0;
> -		scsicmd->SCp.Status =3D le32_to_cpu(dresp->count);
> +		cmd_priv->status =3D le32_to_cpu(dresp->count);
> 	}
> 	aac_fib_complete(fibptr);
> 	aac_fib_free(fibptr);
> -	callback =3D (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
> -	scsicmd->SCp.ptr =3D NULL;
> +	callback =3D cmd_priv->callback;
> +	cmd_priv->callback =3D NULL;
> 	(*callback)(scsicmd);
> 	return;
> }
> @@ -722,7 +723,7 @@ static void _aac_probe_container1(void * context, str=
uct fib * fibptr)
>=20
> 	dinfo->count =3D cpu_to_le32(scmd_id(scsicmd));
> 	dinfo->type =3D cpu_to_le32(FT_FILESYS);
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 	status =3D aac_fib_send(ContainerCommand,
> 			  fibptr,
> @@ -743,6 +744,7 @@ static void _aac_probe_container1(void * context, str=
uct fib * fibptr)
>=20
> static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callbac=
k)(struct scsi_cmnd *))
> {
> +	struct aac_cmd_priv *cmd_priv =3D aac_priv(scsicmd);
> 	struct fib * fibptr;
> 	int status =3D -ENOMEM;
>=20
> @@ -761,8 +763,8 @@ static int _aac_probe_container(struct scsi_cmnd * sc=
sicmd, int (*callback)(stru
>=20
> 		dinfo->count =3D cpu_to_le32(scmd_id(scsicmd));
> 		dinfo->type =3D cpu_to_le32(FT_FILESYS);
> -		scsicmd->SCp.ptr =3D (char *)callback;
> -		scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +		cmd_priv->callback =3D callback;
> +		cmd_priv->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 		status =3D aac_fib_send(ContainerCommand,
> 			  fibptr,
> @@ -778,7 +780,7 @@ static int _aac_probe_container(struct scsi_cmnd * sc=
sicmd, int (*callback)(stru
> 			return 0;
>=20
> 		if (status < 0) {
> -			scsicmd->SCp.ptr =3D NULL;
> +			cmd_priv->callback =3D NULL;
> 			aac_fib_complete(fibptr);
> 			aac_fib_free(fibptr);
> 		}
> @@ -817,6 +819,7 @@ static void aac_probe_container_scsi_done(struct scsi=
_cmnd *scsi_cmnd)
> int aac_probe_container(struct aac_dev *dev, int cid)
> {
> 	struct scsi_cmnd *scsicmd =3D kzalloc(sizeof(*scsicmd), GFP_KERNEL);
> +	struct aac_cmd_priv *cmd_priv =3D aac_priv(scsicmd);
> 	struct scsi_device *scsidev =3D kzalloc(sizeof(*scsidev), GFP_KERNEL);
> 	int status;
>=20
> @@ -835,7 +838,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
> 		while (scsicmd->device =3D=3D scsidev)
> 			schedule();
> 	kfree(scsidev);
> -	status =3D scsicmd->SCp.Status;
> +	status =3D cmd_priv->status;
> 	kfree(scsicmd);
> 	return status;
> }
> @@ -1128,7 +1131,7 @@ static int aac_get_container_serial(struct scsi_cmn=
d * scsicmd)
> 	dinfo->command =3D cpu_to_le32(VM_ContainerConfig);
> 	dinfo->type =3D cpu_to_le32(CT_CID_TO_32BITS_UID);
> 	dinfo->cid =3D cpu_to_le32(scmd_id(scsicmd));
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 	status =3D aac_fib_send(ContainerCommand,
> 		  cmd_fibcontext,
> @@ -2486,7 +2489,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
> 	 *	Alocate and initialize a Fib
> 	 */
> 	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
> 	status =3D aac_adapter_read(cmd_fibcontext, scsicmd, lba, count);
>=20
> 	/*
> @@ -2577,7 +2580,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
> 	 *	Allocate and initialize a Fib then setup a BlockWrite command
> 	 */
> 	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
> 	status =3D aac_adapter_write(cmd_fibcontext, scsicmd, lba, count, fua);
>=20
> 	/*
> @@ -2660,7 +2663,7 @@ static int aac_synchronize(struct scsi_cmnd *scsicm=
d)
> 	synchronizecmd->cid =3D cpu_to_le32(scmd_id(scsicmd));
> 	synchronizecmd->count =3D
> 	     cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 	/*
> 	 *	Now send the Fib to the adapter
> @@ -2736,7 +2739,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd=
)
> 	pmcmd->cid =3D cpu_to_le32(sdev_id(sdev));
> 	pmcmd->parm =3D (scsicmd->cmnd[1] & 1) ?
> 		cpu_to_le32(CT_PM_UNIT_IMMEDIATE) : 0;
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
>=20
> 	/*
> 	 *	Now send the Fib to the adapter
> @@ -3695,7 +3698,7 @@ void aac_hba_callback(void *context, struct fib *fi=
bptr)
> 	aac_fib_complete(fibptr);
>=20
> 	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF)
> -		scsicmd->SCp.sent_command =3D 1;
> +		aac_priv(scsicmd)->sent_command =3D 1;
> 	else
> 		aac_scsi_done(scsicmd);
> }
> @@ -3725,7 +3728,7 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsic=
md)
> 	 *	Allocate and initialize a Fib then setup a BlockWrite command
> 	 */
> 	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
> 	status =3D aac_adapter_scsi(cmd_fibcontext, scsicmd);
>=20
> 	/*
> @@ -3769,7 +3772,7 @@ static int aac_send_hba_fib(struct scsi_cmnd *scsic=
md)
> 	if (!cmd_fibcontext)
> 		return -1;
>=20
> -	scsicmd->SCp.phase =3D AAC_OWNER_FIRMWARE;
> +	aac_priv(scsicmd)->owner =3D AAC_OWNER_FIRMWARE;
> 	status =3D aac_adapter_hba(cmd_fibcontext, scsicmd);
>=20
> 	/*
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h
> index 3733df77bc65..f849e7c9d428 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -29,6 +29,7 @@
> #include <linux/completion.h>
> #include <linux/pci.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_cmnd.h>
>=20
> /*-----------------------------------------------------------------------=
-------
>  *              D E F I N E S
> @@ -2673,11 +2674,24 @@ static inline void aac_cancel_rescan_worker(struc=
t aac_dev *dev)
> 	cancel_delayed_work_sync(&dev->src_reinit_aif_worker);
> }
>=20
> -/* SCp.phase values */
> -#define AAC_OWNER_MIDLEVEL	0x101
> -#define AAC_OWNER_LOWLEVEL	0x102
> -#define AAC_OWNER_ERROR_HANDLER	0x103
> -#define AAC_OWNER_FIRMWARE	0x106
> +enum aac_cmd_owner {
> +	AAC_OWNER_MIDLEVEL	=3D 0x101,
> +	AAC_OWNER_LOWLEVEL	=3D 0x102,
> +	AAC_OWNER_ERROR_HANDLER	=3D 0x103,
> +	AAC_OWNER_FIRMWARE	=3D 0x106,
> +};
> +
> +struct aac_cmd_priv {
> +	int			(*callback)(struct scsi_cmnd *);
> +	int			status;
> +	enum aac_cmd_owner	owner;
> +	bool			sent_command;
> +};
> +
> +static inline struct aac_cmd_priv *aac_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>=20
> void aac_safw_rescan_worker(struct work_struct *work);
> void aac_src_reinit_aif_worker(struct work_struct *work);
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commi=
nit.c
> index 355b16f0b145..940a6deab38f 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -276,7 +276,7 @@ static bool wait_for_io_iter(struct scsi_cmnd *cmd, v=
oid *data, bool rsvd)
> {
> 	int *active =3D data;
>=20
> -	if (cmd->SCp.phase =3D=3D AAC_OWNER_FIRMWARE)
> +	if (aac_priv(cmd)->owner =3D=3D AAC_OWNER_FIRMWARE)
> 		*active =3D *active + 1;
> 	return true;
> }
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index a911252075a6..b91b72b923ec 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -241,10 +241,9 @@ static struct aac_driver_ident aac_drivers[] =3D {
> static int aac_queuecommand(struct Scsi_Host *shost,
> 			    struct scsi_cmnd *cmd)
> {
> -	int r =3D 0;
> -	cmd->SCp.phase =3D AAC_OWNER_LOWLEVEL;
> -	r =3D (aac_scsi_cmd(cmd) ? FAILED : 0);
> -	return r;
> +	aac_priv(cmd)->owner =3D AAC_OWNER_LOWLEVEL;
> +
> +	return aac_scsi_cmd(cmd) ? FAILED : 0;
> }
>=20
> /**
> @@ -638,7 +637,7 @@ static bool fib_count_iter(struct scsi_cmnd *scmnd, v=
oid *data, bool reserved)
> {
> 	struct fib_count_data *fib_count =3D data;
>=20
> -	switch (scmnd->SCp.phase) {
> +	switch (aac_priv(scmnd)->owner) {
> 	case AAC_OWNER_FIRMWARE:
> 		fib_count->fwcnt++;
> 		break;
> @@ -680,6 +679,7 @@ static int get_num_of_incomplete_fibs(struct aac_dev =
*aac)
>=20
> static int aac_eh_abort(struct scsi_cmnd* cmd)
> {
> +	struct aac_cmd_priv *cmd_priv =3D aac_priv(cmd);
> 	struct scsi_device * dev =3D cmd->device;
> 	struct Scsi_Host * host =3D dev->host;
> 	struct aac_dev * aac =3D (struct aac_dev *)host->hostdata;
> @@ -732,7 +732,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
> 		tmf->error_length =3D cpu_to_le32(FW_ERROR_BUFFER_SIZE);
>=20
> 		fib->hbacmd_size =3D sizeof(*tmf);
> -		cmd->SCp.sent_command =3D 0;
> +		cmd_priv->sent_command =3D 0;
>=20
> 		status =3D aac_hba_send(HBA_IU_TYPE_SCSI_TM_REQ, fib,
> 				  (fib_callback) aac_hba_callback,
> @@ -744,7 +744,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
> 		}
> 		/* Wait up to 15 secs for completion */
> 		for (count =3D 0; count < 15; ++count) {
> -			if (cmd->SCp.sent_command) {
> +			if (cmd_priv->sent_command) {
> 				ret =3D SUCCESS;
> 				break;
> 			}
> @@ -784,7 +784,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
> 				(fib->callback_data =3D=3D cmd)) {
> 					fib->flags |=3D
> 						FIB_CONTEXT_FLAG_TIMED_OUT;
> -					cmd->SCp.phase =3D
> +					cmd_priv->owner =3D
> 						AAC_OWNER_ERROR_HANDLER;
> 					ret =3D SUCCESS;
> 				}
> @@ -811,7 +811,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
> 					(command->device =3D=3D cmd->device)) {
> 					fib->flags |=3D
> 						FIB_CONTEXT_FLAG_TIMED_OUT;
> -					command->SCp.phase =3D
> +					aac_priv(command)->owner =3D
> 						AAC_OWNER_ERROR_HANDLER;
> 					if (command =3D=3D cmd)
> 						ret =3D SUCCESS;
> @@ -1058,7 +1058,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
> 			if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> 			    info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW) {
> 				fib->flags |=3D FIB_CONTEXT_FLAG_EH_RESET;
> -				cmd->SCp.phase =3D AAC_OWNER_ERROR_HANDLER;
> +				aac_priv(cmd)->owner =3D AAC_OWNER_ERROR_HANDLER;
> 			}
> 		}
> 	}
> @@ -1507,6 +1507,7 @@ static struct scsi_host_template aac_driver_templat=
e =3D {
> #endif
> 	.emulated			=3D 1,
> 	.no_write_same			=3D 1,
> +	.cmd_size			=3D sizeof(struct aac_cmd_priv),
> };
>=20
> static void __aac_shutdown(struct aac_dev * aac)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

