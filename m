Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0518EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbjFOAgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjFOAgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:36:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3012726A4
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:36:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJngJl015550;
        Thu, 15 Jun 2023 00:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=06EQiiverik+ncX28y0D0F0PiFciVh+7Gg/YJj9xF4A=;
 b=0zttqhiNXvq3vAhtwvFjNveIvVLBPUYhgLWOpwJe5f+x0ua47VxqbvSlBEypOZkIT+vz
 +/7TzEBG2DzYIPR9XtH38PS7gqOtAukDoRbQPp+c1vcmY+H+LGeXdX7reHNItNwt7VJX
 Lg84ieBNxCXT6+Fi29sekV18OB9CFTxgmjX8ZeoRuG8E2ghD/usX73ceG7LyEBzfJ3IB
 E4MtMNIo8uqX3wwIUC8X6MScYk6uAiWwAZhBF8w4iJlIFjOupUn5oid4Tl79gDFZ2UUr
 yZHqrPoI2nLSXAmpijS5iKjGfiCVwK7VUVe3XXP4HjrtAqfOZaS4WL29t7o/CnBRKJ3H Eg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2arsfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:36:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENEVV9021641;
        Thu, 15 Jun 2023 00:36:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6987k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:36:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4ipZp9pqoDh8FSqvytBEfCDijn/22IfGUfZHSSrRo7UaCFyuT9DcVzV1aLXYVk5gkaAkXxQd2lkzRO8CzXJFBWQTxJHTJr22MntXUxm6jGY9q9AxKpWT9AnDyZJYfDP8pbt98wMzuXuHCZIC2WGSFHxD3+ZjVDO62FieJSI6ssjCv9OmlnMsZ9LUHhRvYmE87QSg0xgQTu8o5pxsvStFJ/OJdesjTYH9vV3x9FtZxnsXhDp9MFw73JNMg+Gwqw/vHkgmy8VJ5kYXyTYLyAM2OiFuM46SMyvKDlrKLOCX9yWmsGfDnc6ya1+5XNA2ze1RDzVh4fIoA7UmFdwhSNxgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06EQiiverik+ncX28y0D0F0PiFciVh+7Gg/YJj9xF4A=;
 b=leBR8XKTmUNA+erDZuPozWz+ycqd8o5nN7O9LuZZk1a4HfyoRVhhO6PwrtD+gH0e5tv0GR5+tLx1xFDPDEDhJDxO2megUkeOv5PNh/hxWNAwByx5XjPpg6Y1lRqKxK19am9BTA3d3gGfMSMEYpIF3/UURl+B2nZ6iX6ccv2jkO+CI7DOl3XqeBLf/jEnSmMYn+ORpQCgBTZuqVYiv9Leq3OrXwygeVnZwzl7iF2ocra6IZujDQTs6q9zt5pO1ewnds09YHQ3EDILRjzsiY6jUpe86sxGmf77Vx5u4Ei8x1j8ooT4bVM3TJ82hWKQL+wadyffwDa+XRvvko476ZdSJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06EQiiverik+ncX28y0D0F0PiFciVh+7Gg/YJj9xF4A=;
 b=XVNpQ0CmLL4hxZxjmek+RPabxFrKeFB0y3oTg543EhqiYFwi2vuu+c6VPqMKzEx6JEPmhCUuIpf9OyJQXUdJtT+MN02fmVf+fe8+Nh66P5kfbq2ngr1da8KRds6qPxZmvI+3aeZguXy5cc7uNeuPzuVpM6mRgIxMz/Y0U5vYe3c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:36:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:36:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 4/8] qla2xxx: klocwork - Check valid rport returned by
 fc_bsg_to_rport
Thread-Topic: [PATCH v2 4/8] qla2xxx: klocwork - Check valid rport returned by
 fc_bsg_to_rport
Thread-Index: AQHZmTSthRITfzc3+kOR0IoEPb6EBq+LEGiA
Date:   Thu, 15 Jun 2023 00:36:28 +0000
Message-ID: <96D50F64-8043-48DF-8D15-79BA54D52CDD@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-5-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 812f212a-fde0-4839-3162-08db6d388e96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rXojUyFEwB2/YH5gjpCZoJx3purVWebmXnjWyLft8PRBVoRxsp9gyPUVTN1rFFk5ahZjfFdG06f/JGkpjYwbLWcU9KUTWXXU2pENix/hF/y4wFkH+XVoyoHsHQyIAT9hyliMXw3XeEHT9/a4GGob+0cDhJda7DFst+VaNswPOsuJfJ6DDaR20a8GMMNuLkEQGQfKx4bXaQ3bwwiwdPtGvuBoKHaLdLDVJqknHG2Sz3lIyukS3/e7f2Xj2AhSBpiNGJl6mKX4A3P4uM/AsFGhbGPiQUH2f2AaX7GWjBRj9FCdcSSqkfTM2yG/dpoqAKdGksAQbLFqPaZ3yQRA00CkV0C6LRhDsD1MZOzo6rzEAu8y6MwSwEGuBvHkbmE9CLJJmAyU34hIfd3gBJkki09QWQHVAoWfSaDxqTe7TevW1YCK1ws5NJVw6VBjaBmcaz5dCCpehOdnvDjlKJn5rzVjPS9VyBUYK8gzAfSJ6LMtAzcC3IAv8vkJz3ZzhIN8XdznDuWlfPbrET+ET6wS9u49RdlLWd6eDbGGPHIgDBvSKiJ7Hb9OH//ZJKdj6KlJhXwZ9be/ur4U2nn36/F7nhelp0lB5fgV+xYhRbTRALJZ5cMUs+dGENa1S3IgOLJhiMTErlhJgbHEvHTdhIKjSwF+iA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6fTMvJ1Ry1UEeM7M5T9RVdwTVk+1lmVA60UyJJmoDDpQZ/gKYZdW7bN26oWx?=
 =?us-ascii?Q?EbTSyPbo6ScFIAHpn7CuSx2doGmLOmEzIvzibBCqusUO+svnggqR07u4naa7?=
 =?us-ascii?Q?z5TERZL2wFJ4aGyxaXFXW8zhbkCY9bXM2xHD6CHngVJXzADjtFJdjwmblbIu?=
 =?us-ascii?Q?o6Va1Mlipz36H4xyK/ywx19HJQoWJDgDmPVSETGNJymF3jg/gba3vALDgFSN?=
 =?us-ascii?Q?Ix7C0H227ry6JTtKmSvHvj5+o3rz2EHsZg8h6fdGfuTJzo6HkMaFp/JmArZs?=
 =?us-ascii?Q?4MFunN9bMgy7SPmY2LC2KZ2p1eNEjINoqOSOq4cdmJqH60wu3dg5rTMbNHhj?=
 =?us-ascii?Q?WiqoAmHnm3uR/Hy7XAHLaeheLFlNCrgiNoPyTJaKKN0Bbf5Bnh2wZqnUgFOu?=
 =?us-ascii?Q?QBF/ZplWjI8ZL/gj+LSGaAUbKiSblFSAcGsZEfa2qXsW+A1N9z8BV0mdTJDY?=
 =?us-ascii?Q?5Y6YDWiqtwTO/jUSY/hEof7Wx2HxsKhUUHpdDrMCC8mPYM3bSFpHLoZVGmH9?=
 =?us-ascii?Q?rmn3fpKClAM/r8Qk5lwb8so731QfU1XvXsaXNdF5NUkRjotpyvnQVDo5nc+1?=
 =?us-ascii?Q?qSuIWMTQsw6ZN4Z3He/D2T0l5G0Ig/julw8HHPyVbpeGUvH/KPlSVW7Q5Dnh?=
 =?us-ascii?Q?p/o5I0eFA7fMteUEQ9dr92pIRgecpveaeXGitYxDoiR41h3nEJZNqWyU12R0?=
 =?us-ascii?Q?ieUA1UotJUbe+YUgE/NDJ1i07oRqnxJqRfW1MwP4ZN2LVoYcntNmx8Svh5gw?=
 =?us-ascii?Q?8ymhr9F80s+i68dR+pAiWuj2lI3xQZgsL6Bj9y6cfveFc3YCGozddc1+EPzk?=
 =?us-ascii?Q?y/bqnNND+wmeu3gH2aIHXGzZmDDe7NmNYwf36cCdfcI0McqnfkphK8qXzWrL?=
 =?us-ascii?Q?mxlwU18xpIWPoSeU+vFyO5Iy3E5/MCryL8ATY5Sev9njbdbnxsz5jark7ylG?=
 =?us-ascii?Q?+hdhOp9Pd2VZmtgaKR9VMUHS0osN4h/lbG0G2NI+0U6JD+GeTBoJLffXyEsK?=
 =?us-ascii?Q?//1LdprjWRWM/og9CX4qWtOjVAoZXSN7pE65HnFR2a/5ts+Cc9+v+9EeAUzA?=
 =?us-ascii?Q?Q0jBY+wkLPBmU7O8GCjFBAOnnl53FE0FGDEDBsia2dcmejCDEzHP1wRPHxd4?=
 =?us-ascii?Q?B27fkyFKUlPkQ+xWOw0RmsMl312mxhPAOPm6XevlkZTTJJaKFKYCq6Let4WG?=
 =?us-ascii?Q?Vk/tFqA9zVgJBRkkakg9bbQs/HsIbkfNBOP8sDcIBGdxf57cj3OyjlG8VemW?=
 =?us-ascii?Q?1nxIiA6Ze8G0TM8fdpBXXQFtT1s9jY8EXktf84VJba00Nan5uBniBXl8Bdwz?=
 =?us-ascii?Q?5aPRTG4mcrnYYHn0QwHpEDewWlqi8yd5cPPiPwar7o0No9Y/+5pMTtlBMYyM?=
 =?us-ascii?Q?lIOrqTTtzicyNeWmUa7YAlI18GGle/OPu36qAnde/LeoJPUlzMGg9Y7jtOeJ?=
 =?us-ascii?Q?N6KwNMv2bqXxv5Yj6Cvx/SqLR3vuWKUqtSAUiqtqiOMWUVNUdMDjSa7L6YBl?=
 =?us-ascii?Q?hUettZpIuuFgN6yY11E5mvu7WnK4/eu3L/5uLJB3Uu5pwPMMF1a9XPGOvvis?=
 =?us-ascii?Q?THnuno0UNrt86FzHlL/jKlZZaDUWtizYguJfrFW+pBKeljcLgrYKM6eGSu8S?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2EE4679C3F21BA4AB85C363B90BE61F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mTiJRx2sOzmzyamoE2LnioBKgNhMPV5J58yGReUClT9t9ssul3nif56ro0wR5bOLC8lig6mcq8Z2gWFTn7LpBtflMMAMPj7Rmh1qX5Ie5H6Dg39M9eb4jr3FVJp0JXslB55LgxAEy57lb0TnqcnVcJsDMRmeddChgys7FJNP72Y10s/h8kE+uph4MMUj9ZX09QRiRWZFhvGsQ2WxzM39cs3w/Ly/5OdeOk49RFwtA6YKEYn7TDoFqUEfg1xKEMv7U93HHlYVNoFOnoZMa8Y9s5cTrxqmzOiZVFPZ6qble5c4sHcr1ZE+LgH6tyzc2rfBcLGtxI8YXm/4PK14i5UXlHaFGnpiPccF/CWIJsNtcPWiWXsI7vIsxt0AoeZlajjA6IdPl/3Ooi7HW3WNNI7xvQJtd48gvDc9+rBukshz8q5WdnO1k/pnFii9BckiAQ/ZsALZ2g1FANPCjIX+vS+iPZKOhQeBRJDw+M4aHobZ5sahbTvuHIDJZDq6stppntoGJPVs7c3lZCZObJ3nbNAfYTyfdGv35LveL9vAS4VdtCLOfN5kzho/dNeeEpu89D7Y18XSFk9pasygBvepSI9sHkMifqHLX445JXYnU7SfKJJFY3nMaQDRBG67tQB7ADfi+SzKKZaxELhOan3fjGjeI8R5FxG4e6BZXbpaB4IbNKlPJ4WhQh2f4ZRlpeqNhLQPSpTMsFi0WrNYcB7EXbTT3QuvicTKsurEqV1rZzS8VXf8Wu7YiiH5QC4ZVoebhtZFX/BesZR9MMjcOmQP0bxc/eeaSnmXscpYa2Jo1l5oD6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812f212a-fde0-4839-3162-08db6d388e96
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:36:28.0257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHnLvlpCjBu8NUMxoZ4goZdajCSeqqFfPvc90rygLKzaLAeV5Ny1TPJVlb3eiM6hTx7TGaWhnKRBVWGfnPPWFbHNJXYgA4OpjImljKqVHt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: mCo-rvdW3ZSqj4QYlFolPEnIjAZKOSTP
X-Proofpoint-GUID: mCo-rvdW3ZSqj4QYlFolPEnIjAZKOSTP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Klocwork reported warning of rport maybe NULL
> and will be dereferenced.
> rport returned by call to fc_bsg_to_rport could
> be NULL and dereferenced.
>=20
> Check valid rport returned by fc_bsg_to_rport.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index dba7bba788d7..c928b27061a9 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -283,6 +283,10 @@ qla2x00_process_els(struct bsg_job *bsg_job)
>=20
> if (bsg_request->msgcode =3D=3D FC_BSG_RPT_ELS) {
> rport =3D fc_bsg_to_rport(bsg_job);
> + if (!rport) {
> + rval =3D -ENOMEM;
> + goto done;
> + }
> fcport =3D *(fc_port_t **) rport->dd_data;
> host =3D rport_to_shost(rport);
> vha =3D shost_priv(host);
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

