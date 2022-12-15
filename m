Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5D8C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiLORl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiLORlz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:41:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE5F3F063
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:41:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEnNLU023071;
        Thu, 15 Dec 2022 17:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=F+KcVDXSaEt2MsEiuPqcFJo+SRFNhI+NAkI0XvsC9YM=;
 b=c0pUv34zumzMeeyHhj3q/lXLn8gykwsK9MFaOyCVp8MeUs/fJzfnUs1gsFYCo2EQBi7x
 R5VirCnXk//eUY+hG2vh9nzWTWW9rPVDpp80v4+PToe6KdE6KWAYwInVzO+jezh95cU5
 /vdRmWOoFwgObRkjrzw9DA28xFDdTH9GxIV74ePY7sjYfWrCV0K4O5nIoVCgUXgGt/Ju
 MiU+vkNw39f9igUIFcmSr182jamN/V+b8M2Wdi4sX+OGEr1AWHXknals15HYVtKZfr7J
 MqPw7NIjplVSIZ2VITqN6XSE+cXhD4PSmgGiyowP9k1laugxQjL3JRWGVEtBB1R/dIyC qQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewdpt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:41:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFHEFs9033131;
        Thu, 15 Dec 2022 17:41:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyer2ux3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLp9ypZf54hImt0WwE8QDg5J2wZ+k+2q2Iv+p8bfSIGsuXVQ2vEoJnVhIiilru6Gc+NwqJb5RCa1CnMMi9EDBnX+MKCMph/rrbZlCpbpu4tlZUAyzm8HI3q7pwe646msu52ByXvbcFc28y+OeT87WJv+HBNRlTr6kAkzktk2jNiUlWwpFoJVPQuk61gmihjPaN5ByKNQcB6ARxoZUZvJCliYN+1kzBtNpXBsHYuLDHWJ4oMrN9/1Ja+dwO/S9tZpA+4PS51gTeXB1Bg+8LxA1b6xdAXxSNT3SMm6WD4ug0q3K/KfqnOg/OW3pomBp2XliXFWt1P1rUL0F0GNxxVeVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+KcVDXSaEt2MsEiuPqcFJo+SRFNhI+NAkI0XvsC9YM=;
 b=Fz9uSF20hPC5f/RE2CmWHAAsE3lUXmTBbxRDRDPM/RkFAvDHTT8cQ3rTIx490ea+4uw9iMfTrRPk+BeGFqNDsTZMfASQlWw8AJc0zBVPIbEonCBAmPAuwYCRqCrLY/5R0K3KkS/3R7gWumvH+HEIXis3n1btFHEUIm/ydVAIYUqK/rvTu3vBkIjtSpop4oTyj8FtQlmPOyAsMCaEQYBbjUQBNxm7B7CkWlaVPQ6GfNAW/6/gHgZQGlOcs/kzi0ZXty4QFtzbsC8JYxQnCC/afxiHS5J4hEn3yWBO0y0FX2GI7Av2b2UOC3aZjVvBP9LO7B9aXSaOxqEot6BsZEiUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+KcVDXSaEt2MsEiuPqcFJo+SRFNhI+NAkI0XvsC9YM=;
 b=oozq7Ko1xi/YQO+btRF9fBbcn8qZQbBqOPPGdkLePiWE+2ljRPEFj8jlYJak4OeFNxv20VU836hF5aLfPmxn2cfDfuIYkKbgJ/KlOwdMm3WfTFnTXB5p5hPyPzSX0svBcb6JyjbwZSH1xIWhxLs4yUfYthWENr+JYZhVIHeWu6g=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB5257.namprd10.prod.outlook.com (2603:10b6:610:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:41:51 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:41:51 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 10/10] qla2xxx: Update version to 10.02.08.100-k
Thread-Topic: [PATCH 10/10] qla2xxx: Update version to 10.02.08.100-k
Thread-Index: AQHZD3eujvt2nO2PokipFFaOS4gC4a5vOhYA
Date:   Thu, 15 Dec 2022 17:41:50 +0000
Message-ID: <A5AAEF35-180C-4A3E-A95C-E3C9F6AC58A2@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-11-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CH0PR10MB5257:EE_
x-ms-office365-filtering-correlation-id: e8ba2550-ddf6-4fff-6baf-08dadec3a5ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tGMJ7zOPF3NQjUq52iP7/eFmYcs6BFcJ1Z+C9IFrH7sON/CqEnYqXyTBOD7+IfUBW/0izqdQiDAQj3eD9Soc5+Q1lTTHnC7Qw9cgNZIC/0Y9ML55IFXqjAqkIguI/eiJ2JRrixR2+yZvZvzic1GGr1eA/npKc001deRKOyH9FHeaD9liVu0b2PmfGyWwT9kFi0JHvtsGmtRSlOxK9ErklJvGYyE5Eo5U5j9kwR9MCIsatAraneeg4gYPP+ovGQMBwiy35uwkpz2JQ/bvL2BQ/BgxEjCYh742OwWQ39ggMJwEkjCsGfS6cUxFy9nMbEdRt2UIvYM1B4OJIT8eS5Xw9J2/0OJnDDyfDag2XXxbS4A9diGp4eTpqbsMjfiRAWzqaEAqf2GQh/iakNdk5bCFLhzNr1wPmsvBHbvHHd7FcpgnoujD3zYUtwzf4GdPxyEB/GcNG0z67e+J4TkyGjWIusf822BIWTNQ1h81WeqU+FlInektLzgoHvytb/cm4m8K1Rw9QDVCdF8vZa7cKJlV8RxX47kXyQBkxrJqYslSz/AjdHSbN//M3I6kyn6H70g2Up+xzaJVdnGqal2Ibzg0TQQJDoOa4nRhuuWKj/1Z2Qht2vUrfbQjOCIsJpKPDII98rQ3uEHPpnPtvhecdABGLQAQyEhIR5mKFQptFWJD4JasVrM/+AeoOOcOfY5ve62L+bomcxwQGz5GoWJFfjQlFVc5rGbW2VGpSLZ1ZGUw3hU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(38070700005)(8936002)(54906003)(5660300002)(122000001)(6916009)(2906002)(33656002)(6486002)(44832011)(316002)(41300700001)(6506007)(478600001)(53546011)(66556008)(66476007)(66946007)(71200400001)(91956017)(4326008)(64756008)(66446008)(8676002)(36756003)(2616005)(38100700002)(4744005)(86362001)(83380400001)(186003)(6512007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QiCfS7r309iA+tPEvbJzyDuFWl5WFz9qglY/9mvzRJ9uFO6X+/Ysj44jhq9f?=
 =?us-ascii?Q?qdJM4LVu7XII5glI+bKa+rDit8g1oR1fpUxhsTeeYiejliQMTZ1fndoJIGWK?=
 =?us-ascii?Q?qQX912OeLJtB2eG9H89sH/7NgAp9ShJlI9nW4EFsqrPeglawBVyNdX4hdtHb?=
 =?us-ascii?Q?Py0vhaqiLhP6aU9sbyAHGAPAI2Kb2G8fanD/u0iGQhgPr7Lk/TfeNPacRVwP?=
 =?us-ascii?Q?YPD0KufGRxC6xCrLzH++wllk9+nLelXkqQRx2vcp8ek6981nlLj7eryVkcNC?=
 =?us-ascii?Q?bDlOrhpTLN5ElV84kHy3jXtcMqcj1d23mNOZymtFyO8nBN8q/6IIBmNOwR7J?=
 =?us-ascii?Q?NmzzeXcENKON7SiGTlely9zOdQbRAm70dsZXmkA9M+1sftAYc+TiNKOqAZuV?=
 =?us-ascii?Q?v5EsLHp8D+co5+4pMTRvl2uItH6N9YsGjiaufeZ35SuxsfzH76KlyWm/Aqhk?=
 =?us-ascii?Q?ehTk0pStfTzJOe7UiixO0roAnEFJhtuGX61Ga5ze+V+zabEHahF53yfIxgNB?=
 =?us-ascii?Q?EUz5L5aH0wFfeOpqEIlR602Mg6S+OFSRutPFNe4bJh1kqwKSACcfyz+E/5ja?=
 =?us-ascii?Q?qyMw5CHzi4Rcuqz2YNme+UlVOMZy6UhCGszM7fFfptIZKpbjjMfk40kwqFmA?=
 =?us-ascii?Q?cib3KL2eK2TLsgEBeFXaGjzzYtBHW/dNDDNgc6vyMVHh679M2IOGYL04ODJU?=
 =?us-ascii?Q?oNJGAzoAZURpRrPuc871HW3xeY/7bMCViCIkee9VPXfZ3H+hVdreXqrAOtrE?=
 =?us-ascii?Q?zHf4nINkQ/h/zxXnNkWMDgdlfXifFOAvya3CwOaaJzSfySJvpnBqCYJKPaTS?=
 =?us-ascii?Q?DdPGwL5ZiuOPYtpcdjA5jGheGJtYkQZaWwR496nYPyD9gGNRZYMz62wX6yJ+?=
 =?us-ascii?Q?zmhSf79p0eej2wt2LgNpxRMXrfi0nZzlM+T/gUPwkY59PeMKmV6t+CqiXBFO?=
 =?us-ascii?Q?+BZJCQOo9TsjtKxQ3MXlD+OAr4+neaO6Yc2zzyB3NEsiu9uNg84gZyX1Wgim?=
 =?us-ascii?Q?epAg8jnTH5HaGLQQtSpjK6/znzCLMbg9q73AlOxEYfJoIWPYwEEdjUfBxlZn?=
 =?us-ascii?Q?a9xj5lL+oT19zvivG+5K+0MUN8INyW8rPlltQRYePncJjD4BWrBpetipdmkc?=
 =?us-ascii?Q?SD7Nvt8+doIiqEX1+bZh5NEFvWifmuwx8XW61G366bg60UjPwCbfbzWhcJw1?=
 =?us-ascii?Q?tn0OgAo/YavMUkJEfw2qMUkHyPeCjavnnlJbMBWjeBD7fyv8FvkKejQcNe3O?=
 =?us-ascii?Q?JZnmqmLZlZTdX2dr2vOoEJ6rhRsKHsDXA1DChKcEI288jL4SYSft+o4CSmkY?=
 =?us-ascii?Q?+7nZpu553n35VAi8FGXsan0pXvLlKN/bZjqi3zGjef2h7KUnb0mkoTjHAAUs?=
 =?us-ascii?Q?tfnTunH64Di842/S03Ni+J3ONOKRvsMRNEVOR0Cw2UcebU48NJQQQRw5NfmG?=
 =?us-ascii?Q?/TWeKUuDcgBIzoiY6RfPZ4xSwYDvxPTWNRWeoRPCEJeW7cVuGZ3P7vvD+MQA?=
 =?us-ascii?Q?ojvRNn8Lyj8wQobgCL/Z7/h5mwE7+vQW9KGtVRpfBgqElWTyefrHa44ekw1V?=
 =?us-ascii?Q?78/m/FDD8rZfRmviHiX8cbKVin8blbWBewAdfYESzh4n3eDVDYeFs2cZxGMA?=
 =?us-ascii?Q?fQNAOKNWnW+E4tA3OODz+2S+LM/9nwjcEsHbaXaXYwYH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E71ABCBF4DB5334DAAF9FBA3A0D1A9CB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ba2550-ddf6-4fff-6baf-08dadec3a5ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:41:50.9314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hCPBtwhyoo+CYRffhGYVuyftHqX6wlXIB2y5iHJvNyXECCMwiaMxDtxxkuxuphU+cmXht6721YPJ7+ydi0D3WWslgyzoTNdkXWrGVw40gaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150146
X-Proofpoint-GUID: _xJTrye54JGiqRUBhvL9MTvyAFb1PLUa
X-Proofpoint-ORIG-GUID: _xJTrye54JGiqRUBhvL9MTvyAFb1PLUa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 03f3e2cd62b5..9f55f75c5890 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.07.900-k"
> +#define QLA2XXX_VERSION      "10.02.08.100-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> -#define QLA_DRIVER_PATCH_VER	7
> -#define QLA_DRIVER_BETA_VER	900
> +#define QLA_DRIVER_PATCH_VER	8
> +#define QLA_DRIVER_BETA_VER	100
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

