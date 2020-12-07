Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BA7C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BCF8225A9
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 08:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgLGIEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 03:04:11 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11561 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgLGIEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 03:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607328724; x=1638864724;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WmyBayX7xN3wlfWHfD0JBCjaKoMG0vezY/E7IdbhZ+M=;
  b=AgBdCmRAI2XWrMus1dv6533sHrovjl95bTxkhlXukZxoG3sYQkd276uW
   S4Tk0CXhhPgFhSBfJx/WdanPY30dSKj4/+rO22Q/KMQXVFFDMMDVFgBMX
   l1lDZLE+8H8RFWs5UQ5Rf5MiRPdbJ2T5atQuVdtTxWhVH8zutnfa/Y54O
   JRT/9bGvo8dPx1UHdyDxn0Qzhp1++NaYi3snwErAkwIgPUMcnP+3tqMet
   t6YDAsNIJxQP/7MpdH28WkNCtIMQv13Y3kGEEWl2d6xSDR0MuGr10O5H7
   R2JrcE1rg+E63LsEIxD5tB1D9OFmSh87RUHz+pZKApVhssY9iDKDWByDG
   g==;
IronPort-SDR: fdtZIUKt+uxBSl5TV519mi5u9nPUupurDtREzoiW/fWOQ9NvTOZbJBavcWav0R8rh6+ihwj8b/
 7GRos+1BYS3uf7HUf1whl8i0jhTae4zTzcBnR019CDoarhGu0+LiFjj4pGESM4sRI/jPZCsdPT
 cllAqLRnP6IHi930rL77hTfpgns5+vK1/PmR0oWztznJ6gM6eFMCBHrgQc7Nl44xpTJCtzd50j
 SO7MG8BfZJ8/GiwE1ZA6FXUP1S02PnaHkMIrvpvaWgo9m2897ELgpFlvQx20cMwe7y74BmFKmF
 GQ8=
X-IronPort-AV: E=Sophos;i="5.78,399,1599494400"; 
   d="scan'208";a="258294297"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2020 16:09:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfXvzYmhK4vpmkcl80zAep+ANDDz37wGkRuIsqPToe/DW2eSu/MNp/1xFNOvh+9okNpT8zpAdKS1szZEX4Bdm4vIM7xrUWYGoLY9DrvZPRpl1Nz9gxWV39YogC1SdvLsJOw5PF2rxfC/VkAmtXm8Cb36eT1uKxlDZx++B5gC/8ieg9Hj5FEfLMN6fxuKKcMTSnOOIMRVhrJiTxEvr1e+e5a4PuBO250tK93OZAXm2y9sRweUUSICgcfFTjpBrGiBsdhEYfdb67Z3otP4fRuw+30Javx3xc7fcx3lI1TOieIWmIWT+yxAUnqijnYZ1SwKmmOWsS+LH9dWBPvh+mNPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmyBayX7xN3wlfWHfD0JBCjaKoMG0vezY/E7IdbhZ+M=;
 b=jacZEm3jrPUeHeve3ah4V9aCY+/8+s4gikMnLLCUI5s1U/gQuKc8xzcta9+D9SXKonPLgVmz8N4bdRbgXkjvjMTVbdklJ3JorRWI+zJwtNVdaJlvvjDnuuofvLpZ4A6rHHDl2ugmCjtrQoM5gN4r9n+5Q82b/ltM/6kpoE3M/ccfH7s8A+A3mvvALRy78qDiLWWcDGX0XGsCwd31guuaGLOsOsTsZCttnpPac/DaqgiKs0XeanB1THks62sOfp4qSv4iPG2IhPuv5bU8O59/AeiXmNFvABJ09SroMdo96dVK6p8P1scpQJilXsP8ldic7A3gkQ0pwbDYsq89feo0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmyBayX7xN3wlfWHfD0JBCjaKoMG0vezY/E7IdbhZ+M=;
 b=nJ/IitcymUy15cQYe6CSR11xII+d5vDa4q2KmvWD9Kkcu+93c9CNu0Y7JLRS/zcFPOG+HW9A2NC5uD5wgkXbknil2stxLvINOXblsoIJfl+Fcs7zu9SRBqTYeeEO/GQqFGtgilp1XYwPAS1KvUEBEaKl7lwQWTDBPANtbI6AX60=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5020.namprd04.prod.outlook.com (2603:10b6:5:13::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.21; Mon, 7 Dec 2020 08:02:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 08:02:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWy7iCBBJB+/QbNEOT3LqFCSOQUanrRfZg
Date:   Mon, 7 Dec 2020 08:02:41 +0000
Message-ID: <DM6PR04MB6575AED736BE44CA8D4B8998FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206101335.3418-1-huobean@gmail.com>
 <20201206101335.3418-3-huobean@gmail.com>
In-Reply-To: <20201206101335.3418-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e9fea04-45fc-4da4-0027-08d89a8678e5
x-ms-traffictypediagnostic: DM6PR04MB5020:
x-microsoft-antispam-prvs: <DM6PR04MB5020B3691958393A953DA0ACFCCE0@DM6PR04MB5020.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y/asLkRqktB92nvevjUkmAXriR3JnwnVpJqa4x9UcJdTM7BVtvx/9cnLOiksZqfJwH/f8gl+5NEPQLlonlATZ75TEHDQGvf81MtTmDE20R5YWQgYRzJAL+sF2MRt0f33IDpWV3VS0cn0Cb124I98HyR2kvQYau2HrWotdVN2/vV+rwUMrczEWHj0bXrg9UyBRYd5J7eFLwtBldSLCQK3uir11qil7ONGix2uZGwWWE/OFv6w6eYAFhpJyO+3O+2E2OhN5/RuhszUh7Uti6kpmkxa12FdFC+FAx8MxZqmBx4b8f3KZj9Ru9pL91a2l0V9Uw6Omj8OewpqIAwOVjT0eTcTDM4cTgfoGtKy82zB6mYzDF4whLdQ4kqaJSavzVKBFKwn7RiDF+A7AOZz0uC+gLYwO00e2L2SeBIEGueIvuY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(4326008)(86362001)(186003)(2906002)(33656002)(478600001)(83380400001)(54906003)(8936002)(921005)(7696005)(6506007)(9686003)(55016002)(76116006)(66446008)(64756008)(26005)(66946007)(316002)(8676002)(110136005)(52536014)(71200400001)(66476007)(7416002)(66556008)(5660300002)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gtBR5rpUmBxenU7W2ha4uYnRg+NB9GlX9TGFeKkAg+TCSQzeHeLN+wSwlbiI?=
 =?us-ascii?Q?U6GzkPdU4KK5eqbCf9QuApDMoC+aNVNwSA+/52kPhRN2Jz4LmWJsgQkMnBFH?=
 =?us-ascii?Q?8e1Ze0rL9XAa/ddBx7GftJufbQNTvs3IX8+iU7hOevoyQ4PF0/dHYzwv28ID?=
 =?us-ascii?Q?jlsnjQaJB500134H1ETCdRq6mVjVhSyW//kZT9roq0zjb1+WVRGJef4o75j1?=
 =?us-ascii?Q?CPbkr0A8b41P7M/yzL1fpH+963W59kaPnPpG1yOT7b8Y7tsUcFsa2D/lZ8sJ?=
 =?us-ascii?Q?JJ9zzi1OEBtJK4THLEySsQE2eaoYbS/Me6kPaUi78vKYPPg8h9A1toynUbFi?=
 =?us-ascii?Q?lZGir7XUAIdMC6zQ+woz0AUkXgg0uz9EphxZPHCF+1AsU7IYaS84an/r97Dm?=
 =?us-ascii?Q?dx0gcnYz5SDqxgh+hcqXF3Jng0odAMWH1okjpm460NV0YitMWAPaLbzqBj1H?=
 =?us-ascii?Q?21XGU2wF9DEY9729tp6X+xhZkJ2CdbwyxYPGad7ubT7FGvwSLJ7iLfcFe/qR?=
 =?us-ascii?Q?oLpZ8+rBkIXtANrF283blMpzVeDnoNrS0gDIyxSaL3oi9TlzpSUqNZzXWHO6?=
 =?us-ascii?Q?PRVh5h1hV1ShlVJ0oZf/nTGb1xq2fqq4N2ymFYdW4aVLufRwch7FkbV9f8+D?=
 =?us-ascii?Q?dJHi7Vt66h2b8yPW8hrN6gCMkB9sAuoJkUDLqZ0aPUZAAkjk7xwuQhD23gaB?=
 =?us-ascii?Q?dnuPUfIJE8i03Y6Fz4XqBZD1Oze+viOpzm3DED/f4LZQCEzR35au8xrYfEjE?=
 =?us-ascii?Q?pMx3z48w0KBNzezM51BRajIoSF6ZqA6aSAYwLd7bX16UylJfhaw5F9aJo+xo?=
 =?us-ascii?Q?GZl6hSc4weLGqOeZFPPBFmxhiB9qfiIXMIaKo65veZzBLjeVP2D7+JrzHJ13?=
 =?us-ascii?Q?nnPEVnmPgU+E/R2PWTkIyo7To0d/BPB/F5K6ISBrHbyVA2gjZ20fFkDQMvQA?=
 =?us-ascii?Q?mzxB6xEacm3qUYvN4TSb38CvuYVGs6hgw56DqKwajCA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9fea04-45fc-4da4-0027-08d89a8678e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 08:02:41.6737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ki6icQ25phd8qj1XqZuxzWcS/eEiymcC7aIrVPD0NBwvAr0gR2OPZzId3VJbs/t2+PhptI4rLmyaSxrEv0bsIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> According to the JEDEC UFS 3.1 Spec, If
> fWriteBoosterBufferFlushDuringHibernate
> is set to one, the device flushes the WriteBooster Buffer data automatica=
lly
> whenever the link enters the hibernate (HIBERN8) state. While the flushin=
g
> operation is in progress, the device should be kept in Active power mode.
> Currently, we set this flag during the UFSHCD probe stage, but we didn't =
deal
> with its programming failure. Even this failure is less likely to occur, =
but
> still it is possible.
> This patch is to add checkup of fWriteBoosterBufferFlushDuringHibernate
> setting,
> keep the device as "active power mode" only when this flag be successfull=
y
> set
> to 1.
>=20
> Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime
> suspend")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
You've added the fixes tag, but my previous comment is still unanswered:
you are adding protection to a single device management command.
Why this command in particular?=20
What makes it so special that it needs this extra care?

Thanks,
Avri
