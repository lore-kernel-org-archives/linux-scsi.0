Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F63DC678DC
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 00:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356729AbjHRAh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 20:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356738AbjHRAh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 20:37:57 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A79E2D50
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 17:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692319076; x=1723855076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X0+V4liEop1XWLRbhvNNj1lZTP/KfJlIxbawCEXH5c4=;
  b=nOgobENM5mZ7zQenBlKQRyWeTx0eoxzFc5H1s0wWoI2hRVcNxkjUo6Gr
   pRhj5ViM7aPg+HEWFivmO9EhDtwI2d+2THhrNDU/tYH41/DC7rquiGxSO
   tJU/x7E31oec90U/4bDHOy789VFGskfXuln3ZXDADd3OYu/kLbe/fjTDS
   s5Z0ZIbV+7qG0uNw0xhW1TvrMwK64x2BKvpTFCaHVpehydpRjZru4GF6A
   dwUANRmuGdYYQlU+qt2afA3vWWLkFFQgWQPfd0uhyopNTrMpjKLQo2nwP
   h/t9w+SMXw+6sbJIUlCp1cXRBavHJtCG4Bva2xwEPqw48OcVv2dJ8tq6Y
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,181,1684771200"; 
   d="scan'208";a="246044555"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2023 08:37:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSQIX5ipOehWLEuoIqbBPOMNiIYtoje7S5hXSZTudaC9lWUvbYu0SmTdAyESa0YV+SyMzoGa+bIw2p7vdqp6PlJUx5pT9FRCWAOVtEqm/O5ad3SECue0pcVgJkKZTFMjj2gfcWPQHpcvzNEOkuMRW+sOMcxz75h2AJDrnTZteiFDah1rfSBUBzO3QupbdFutB+s6fOqYnlZUo0Xu5cpJFStvFtebDNxTPyVj8A72Y7IalYrgcqH7vCPPyYxvTrNPUzNHfgxH6DFxpdwbCtYeLHFk1L/57Wgst1ynEZVR+Fg42odBcuXcJHia6J8RMRnoTcs+OGf567uRixk4NweUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qnUGxa/00xpT1nknI/7EwSRCHApMUKdzMg2mzMeRMs=;
 b=kB+ntQA7rlOoaHElA7Gibbhq/XRevSJecPx70mS4quDoqQyeqSy6UkuR/3444k36FaYRVO4rvA+DIei6ksBjEWLP7JsqLPZgA8xHOnjMyy9+hhoAUkk6UkvOXxCmO7zt88XsyZZ5msw6Fs9xogbWtVuzQxHBKM63Xdu4qJqZ3GQm9ot0FU1AqTd9TcpkAT2KR1m31sUQiLUeq4zxspajUHxqC+wJxWj6sZ5HfDwV/0KMkeNELsOqGkBmTcoiqG0+LJeRtjWZM3gmtZTmWKjw32WOJRzX5bG61ZD9wNwHCJLl92d/+JrbszTpoUJ8/K7OAtboUPxAP/lSnN6ILipVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qnUGxa/00xpT1nknI/7EwSRCHApMUKdzMg2mzMeRMs=;
 b=A04yhWiVu5Y6bSVrLPgMrk5NENhiKCrTUQUJwyg/J+rIYSkgIllty8EToX5BGo900V2f4JCNrLIjobfn0LW68Ebm6FX4oJkjfznCr+WeD+KlHfjXWrECDgeS6aJY2PD4/8M2UV13rwQuNkUAOEmr62wB8GLSpqMZGZ7jmXQJ4hU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BL3PR04MB7963.namprd04.prod.outlook.com (2603:10b6:208:342::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Fri, 18 Aug
 2023 00:37:53 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6678.031; Fri, 18 Aug 2023
 00:37:53 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Topic: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Index: AQHZ0VO0fxFCEX0RQUu2CJj+KjRNT6/vJK+AgAAI4QCAAAg2gA==
Date:   Fri, 18 Aug 2023 00:37:53 +0000
Message-ID: <ZN69XeEyHN4CNtjw@x1-carbon>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com> <ZN6vB0COt0eJU93A@x1-carbon>
 <4e139042-948e-1bab-4c43-02a309ccf357@kernel.org>
In-Reply-To: <4e139042-948e-1bab-4c43-02a309ccf357@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BL3PR04MB7963:EE_
x-ms-office365-filtering-correlation-id: 19300f04-59ac-4d15-672e-08db9f835bd0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8iwn1XE4Ofm6oSobZbNuH6vpLwMkdhNeozgCl1RZzEuYdEZ+qgWoCJ368zmyO2PaffUQ99VVIHf/yW6IPN/uQrvyN5tj7oYw2riqFMdaJ06nXea3thpbb9P1FKKBMFxuKslelGJ0D9MhbRd4RFF13M7VDAOGqn3nVx43N0yEOX/92Y3ZOAS6JsDvV9FhXGSgvarqD38H1dYcMj30a4PTuetPLfI+os+cDxOtwaZX/VSU9bLbat2a4573C+i2/s/TgBv5N1BxWF9+Bx3F9XZNIFBUIWkB9Dl3Ci7NxLeGJ4u0pMKkibZf4Tl0qYVbXFrkusf39F8DGNOeANbMudNqxWIf80RH8VfTzW/b+S7zfU/Qiunc+sT9PM2ohyVpZyZ6Pn481xHqwUlwOX/JW3ldFEfL7iwBQgfMnmBgnigE+YpZ8UvEdGYiAhcieIss/648+ErleBfPL+pBWagrtPitWWlfKKEdurrk07tqiwXBU3UGWLvPHEiwVY67JLmUGDYAd1lakKZMxBdUKLoka0H0Dz++EW3x8SmRFR3UjxAGLfU/creroEBc6877lhGbPk304JnLOu8w7PHSui6imPNe5LSW4pgtyg/9Ie+tG+jLN9s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199024)(1800799009)(186009)(86362001)(82960400001)(122000001)(33716001)(38100700002)(38070700005)(76116006)(966005)(5660300002)(66556008)(478600001)(6506007)(66446008)(66476007)(66946007)(53546011)(91956017)(6486002)(54906003)(71200400001)(64756008)(6916009)(316002)(26005)(9686003)(6512007)(4326008)(8676002)(8936002)(41300700001)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C267K98tf3Ob8Y9+8Va0MeLQF1fWeWdQnkIAu5m8158M/5nH8byCySY2taFo?=
 =?us-ascii?Q?kimMBfuE12M6fbXLrc90jL/yF2Esw3LG8xZvX8oEXLj7Gpl2cOJFscW00an3?=
 =?us-ascii?Q?ygzowF45gUcYz7b5T5nxHKaYcZaWUDjCqG90xOtY71MsQgvI9FeS6+PcFe7H?=
 =?us-ascii?Q?FoZD5QNKAAzabROcm9lx7Kbg8LwjpudpJ2GDcnRJLsHDBHPvPTvb+Mzg/htG?=
 =?us-ascii?Q?dL3TYKqFWgTNW81tTrfASek9f/DGo7KacDKdBOgpCqMscIWNoR2uj1yQ3FKU?=
 =?us-ascii?Q?uJKppbNvciNek6XwwRaxGq7qh5jrQ0kjOeP3EWRDfF2K++PiwOgvzEc4bXNq?=
 =?us-ascii?Q?5l9RP5TSgkCoUx1i+U5eXfHxhh6bJ5h/8q57ixG30CXWWHTiXUYR3lv2h7Vd?=
 =?us-ascii?Q?pm32zEy1iMYVY/ezvRhRaTRIZQgOTIrwKCgOIZc00SEKIVUqggJHYyS0ohkY?=
 =?us-ascii?Q?rm6cL9o2A0wyESbjrRntkrsfaVDYpeP3dbCyggo0b7got6ofZdBDhiIjFKUB?=
 =?us-ascii?Q?CO3c+SAvSL25tg9/nNELueSDlvT72LZs5jEe4VxksTKSD8VfrA904J2NddkR?=
 =?us-ascii?Q?fTLkJFRTJ95/ywa8U3oEzgNVYaoYp0O5Gstor//Ye7smwprJtFPlDnA0okwh?=
 =?us-ascii?Q?8KEmXrhFHYVX/arrlpPCRT49bXT8NYEE9XC+sfcmzX8PZ045Z7LmJ/EBJnTT?=
 =?us-ascii?Q?Scu2b7tmUWPlmU0mmGBZXTFg6w8xbGaY4kxbQ+p9APvAkKsxE11uTIph6yrZ?=
 =?us-ascii?Q?BvClYacN/YgWQJADycOUegkkX9uxj04aBHEj4afg1KR2ZegbHjcIlLkTWn6Y?=
 =?us-ascii?Q?9YBXP/qV7QxJ8c5y2dSmxxT1IWjTzSUAYhA+RMGyMOA8mdP3N0lYw6HjSVFl?=
 =?us-ascii?Q?AY+zBclAvNR242so2cwAMAAxXFPbOI9uOP/Q5/tOd9rQPJ65tWzNudMctELg?=
 =?us-ascii?Q?jHGKIr2V/LhNaucH7gnD/beRUfzG+1i9py+Mn45FUAhUVgBBxUkJyuI5ut2U?=
 =?us-ascii?Q?0bJrSmTlYUclkFPbOqubx+E5cLg5uc6TQ/FkXOsf0YTcyk6UsH3y500OXirc?=
 =?us-ascii?Q?Px03Tn1PM7SW8OSlp7dUXhzMTXJhfcRfakl113VrmaspvWvmXzQLKBdIk61w?=
 =?us-ascii?Q?jevyqghiKdvz5cS4SVGmDGkey35P0Nfx5gU7INbO0gCLcPCTWi7h7x/wn0mk?=
 =?us-ascii?Q?eroIbYJ3DUA4DyjPX9y7RXRgJLBOJ5lUsTzmvtLy8Xld1UaB/YWLWgwY4G3l?=
 =?us-ascii?Q?ec+kWtk7wC+PelFTePMYXXNae+WZ1qM8jl0A/RqDmpfvM+WluX+DijlrLwuz?=
 =?us-ascii?Q?rpTkFZWJ7d9ZrC1wry6dXnn+m2RL3wlX1kaIZ83RrrWl00FcyteQDTSco2i7?=
 =?us-ascii?Q?gmxPxbEb4JwL4VoOS3J7lo0WlgeIQDYv/H55E2ywUEwSgxcWQ9hI1/tLPJF0?=
 =?us-ascii?Q?T4ReEE7VGMOUgGxu9HG7GRCgRKCkkImi2CZ03g/fooaF0iTlONhzh8RK14Qv?=
 =?us-ascii?Q?og30NqLyHXuu/gZeuEpjoqDUTg92cXDFaiaaMFA99GNKmtiG8RTw9SwgI6Na?=
 =?us-ascii?Q?mstgMkIw7tGrf+H6KedP7zwUoiMU5psZcO5rONlBsvSPhDIVPArr2myhy8RR?=
 =?us-ascii?Q?Ug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3ECD916987017F4180528D11B9647B04@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?semVUFbBXlBAdqDcf40lXGpCDbtY+G4d9meuoDShrGCpCYzdWAOA2VI/ovYE?=
 =?us-ascii?Q?LMiZVNpDIvJzKrm292c5AUJjkI4C7HFHdhMY4UVOrDBSDJYAIWQCbT8eRcF+?=
 =?us-ascii?Q?GTtFp5Vw0pQ8ye1i1cFemPQjzDZYl5TbSBpdbrJ/oYwwwFMlrnshIZWaXnyQ?=
 =?us-ascii?Q?RDe2VCyyrkfn3/5JTqVt6UpkP2Rtt5FqYsEPx8dKJZDccFU18zf3xQWS2Ouk?=
 =?us-ascii?Q?iN72Esu/yxQk69+wSauBIfdyIoqTjFBGNwhg4fsLg/KYQ9UiKd16CO9A55J9?=
 =?us-ascii?Q?iEEydwBj0K6o/XwNpVavqPqJa2lcUU5lBXATbXN3/jSqaVFaEK06QxARDYTu?=
 =?us-ascii?Q?gVxnSJ1SjikRAZ8FkrATfwpThGyo+rJ1nNrW/+Wg9XxM7G+P3Rq4q298gwaY?=
 =?us-ascii?Q?sA+kUvD08O55+gq082WQShwB4AO3d9ZrWg99R2b1PphscPdpbQYJjA5i91gj?=
 =?us-ascii?Q?hJPKAfw3f4IAMOPvvhn2KsnD1iOZFjUc+5QgcQY44r7fpiUFD3k8gS0/5wdl?=
 =?us-ascii?Q?K0soyn0fBsh6dEe0CgRyS5ENyX72Hww58s6jHrbp60vWxHxKcvyInqEXull7?=
 =?us-ascii?Q?jJnqXqP0K9l63rj/ZLeXI/SCoYG/5SPcP8OrnY7xLzikStvLwd/pZsOuQ0Ed?=
 =?us-ascii?Q?nVaPIrmvtwGNTudnC94QChLQnhve+08ct3zNZ11xe0786264RNk4CHTQGZ2m?=
 =?us-ascii?Q?3h9cXjo3GgrGL2cwZ4PafMOZdfsXUN9zFXxfmh3pJqsPl+3IWlKPVH4fRH8C?=
 =?us-ascii?Q?/aGTafOP4RVLXkYyWTZTSjGbTnng/fLfHVKslakhUk4MTHfhmqbPtCfAuk8Y?=
 =?us-ascii?Q?S7b32WKBIzG1WmgPK+N9tl+FthXHMsUSCVm+NDIPcJSDTEJFBAVdbLln/Paq?=
 =?us-ascii?Q?Pu+itqEaYO+GBhJmXeLOXHMQNJD610W7RAH6OXgoGjOJNLGAlWoB932vHt0l?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19300f04-59ac-4d15-672e-08db9f835bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 00:37:53.2703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lj2GeH10jmdb3dpv/x5RulzxHFLkjyE0B/dXoymzgMUrfPsM7Uv9lCQATPq4QCH5qX4Ce2yRCwQmrH+V6xkNOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB7963
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 09:08:26AM +0900, Damien Le Moal wrote:
> On 2023/08/18 8:36, Niklas Cassel wrote:
> > On Thu, Aug 17, 2023 at 02:41:36PM -0700, Igor Pylypiv wrote:
> >=20
> > Hello Igor,
> >=20
> >> For Command Duration Limits policy 0xD (command completes without
> >> an error) libata needs FIS in order to detect the ATA_SENSE bit and
> >> read the Sense Data for Successful NCQ Commands log (0Fh).
> >>
> >> Set return_fis_on_success for commands that have a CDL descriptor
> >> since any CDL descriptor can be configured with policy 0xD.
> >>
> >> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> >> ---
> >>  drivers/scsi/libsas/sas_ata.c | 3 +++
> >>  include/scsi/libsas.h         | 1 +
> >>  2 files changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_a=
ta.c
> >> index 77714a495cbb..da67c4f671b2 100644
> >> --- a/drivers/scsi/libsas/sas_ata.c
> >> +++ b/drivers/scsi/libsas/sas_ata.c
> >> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_qu=
eued_cmd *qc)
> >>  	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
> >>  	task->ata_task.dma_xfer =3D ata_is_dma(qc->tf.protocol);
> >> =20
> >> +	/* CDL policy 0xD requires FIS for successful (no error) completions=
 */
> >> +	task->ata_task.return_fis_on_success =3D ata_qc_has_cdl(qc);
> >=20
> > In ata_qc_complete(), for a successful command, we call fill_result_tf(=
)
> > if (qc->flags & ATA_QCFLAG_RESULT_TF):
> > https://github.com/torvalds/linux/blob/v6.5-rc6/drivers/ata/libata-core=
.c#L4926
> >=20
> > My point is, I think that you should set
> > task->ata_task.return_fis_on_success =3D ata_qc_wants_result(qc);
> >=20
> > where ata_qc_wants_result()
> > returns true if ATA_QCFLAG_RESULT_TF is set.
>=20
> I do not think we need that helper. Testing the flag directly would be fi=
ne.
> If you really insist on introducing the helper, then at least go through =
libata
> and replace all direct tests of that flag with the helper. But I do not t=
hink it
> is worth the churn.

I agree that there is no need for a helper.


Kind regards,
Niklas=
