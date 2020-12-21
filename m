Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACCFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA17B22CB1
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgLURBP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:01:15 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9007 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgLURBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 12:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608570074; x=1640106074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KCjn+UtiD5/oeQjjY80UYNPb4fUoobTIP2NbhtwSOYY=;
  b=Pr65KwJ1HxFfF3mmdzSo8UR4Zhulkmmq4bvi7MH/mia/tIymCoyO7zUq
   jJzFgMyzC9CINvTLPAQdua3SE50wv9bNjz1Bem7OOm2pAFvDAzfsdqsUh
   517ro5zdaTUJilc/+E6y80cTLZzz7SqccHcn3Ok5gG7tMkvPAD0094cnn
   bGij06dh0JKttPUBBmOSuzs1QKkqXXCfMPiVBkULfgbfhNfeyywhCDvvE
   uGApop9JF58PWOj4tvK101n59EDsGqhFWqGdeIwuQi3uw1EcXgq5HR6Sr
   iS1y3+a3tWSsT9mpDajKbLHM2uRtqxykDgx4rL1IYSshgT6DMe6L1GRcn
   w==;
IronPort-SDR: uaALJep5UpViUizWriQTcPHUPCeUUedk9ynbmte+G4A5AVsePRcGLWZYeYyw+tgtwNnKLaBazt
 Cd80jzhOQav7FmoqSGJZ3vL6PAykqxauEw3x3df8O4x5UKp3yK3ux69bzkQFNaL0xSI69GFq7+
 gxfpr4pdW1ioxEcpGLVNsIZFFEFGQuyvsg2HMgf9m4cIMwW/LnMeKiIzl1FU41QQ3o/8JIDXnf
 k5enE668TAqScop6OVadqi+rAnwy59EAlhNHVzXpCM0EIZ4c36wD1VBcx2ozivSgfoWB3MoFDA
 xH8=
X-IronPort-AV: E=Sophos;i="5.78,436,1599494400"; 
   d="scan'208";a="156917248"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 22 Dec 2020 01:00:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDr8NbQbcCzBCtxGYAqMdaSMoRNfYJAqDePraOSI2lpq5oBGoyIz63W/3VtXcD6MvLv6NcGd+ULCgC5suvxQG9nOpxRPhcCZJx/9zbkso0/s7JPHF4HBvJ2Z1WcZd1lVVTK7dIbIh5LO7poSljv302oGcZ1u66YMwDrXL5+pd/vQlPFjKTNcFXT0fw4PUYp4PwzXYrssTLseMuUZTN9uRThqU1Kfkh82xTC7BXu/SO834jciN/LK2sZhdcysuVOVN4G6o2u+ezxi8xDDuqshKwE3kxDZtKAn4oHZApgncg8FJh4MqvnTJSzOI4lWXwXXQ9K4jAsj9A8aJt6/DoVG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGhegSfcFz5YZ5tfBW6QjDszkHDdX/6SreDTCo5L2MQ=;
 b=Ez8v69mW3cS5/fWTPh1oiEQyeM3YWNeZjYLn8WcvXftzeacxQzr32eeQ+EBgir75sTozH8Bml4OxeUsJS/sp6obJuZ69wag8jpNZBypRwv07kLuq9aPE3f5Z+s99WnFf3eTslBkdc4gcBZ2mp5GYpjgpR0GuPUuTMV8cr6sMXiVykABUGEmFlyjunzVbn4YsOQ6OXw2Y9JhhG++yCo9jopdvwcKA7wMcL3AUB3k2EnVn4Cf+DXUxw07BZkJwZ7kfcWm/lLHsXrjXyxw4ZKMMmZxkqKwel8yYcjNdEcbTc1H6VGOfpqfaGw8mEIbMWaScBLbFcMQtBMH4M6rJzqhoug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGhegSfcFz5YZ5tfBW6QjDszkHDdX/6SreDTCo5L2MQ=;
 b=OXrDLGdylUVsqOkIxeIq0FeYaI5Sso5GQvUsiVoIlQirHTNlOQe/c9AzwwrGd7D+CjUX3wsrt6a6IdeVN0R3ZB1ZrbmXOVJBfoqU+Gsb5QmYP7wVSw6Oph1VEU2nZn+lZDN1Zi0TOklhTQp3qLR1rGaagpZWXiTzjkdVZ+69GaI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6969.namprd04.prod.outlook.com (2603:10b6:5:240::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.30; Mon, 21 Dec 2020 17:00:06 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 17:00:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Topic: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Thread-Index: AQHW1O5Lq9Xt0bukCk2VnSNzzSWPAqoAjHbQgAEkMYCAABqVAA==
Date:   Mon, 21 Dec 2020 17:00:06 +0000
Message-ID: <DM6PR04MB65753B9D31B3643C757E4E23FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <DM6PR04MB6575B8729A62E6FB9F19930CFCC10@DM6PR04MB6575.namprd04.prod.outlook.com>
 <X+C9+1p1CbssKRdO@google.com>
In-Reply-To: <X+C9+1p1CbssKRdO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3439f44-b64c-460c-3afd-08d8a5d1de12
x-ms-traffictypediagnostic: DM6PR04MB6969:
x-microsoft-antispam-prvs: <DM6PR04MB696924AE6F292ADC8B33ED69FCC00@DM6PR04MB6969.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPT+cgQYZFrjN/MWr9k4j3DwjUqVnrfsd20KlzeE+2QM3nHb0JeQWRYOJu7SF4oo6ckFedDlUQw5H6C5jErMiTUwuoa/nUZ8y8Lj67tzq7jqG2EehAdK4uDrLZ37SOwg7iZ+FATTqXxQoyYmC1cyVTD5qyOh4Y8RFzlmMO6ZMRGAWBCZSU+ft+YhxT4ECU62VOwFyumOAVjt4v+i1Vp32vrrXQhcGNpWoLWBY/68L18iyUuqqozng1fn5CSgUUbEypHmR2p3CAslXMszOmEwNI2uvFX8jkBCen1uu27h+DG7f/m6Xq6N1nNmfL5Kac3go65EPSjUut+nfGMRygIkEzKJ3FhgBlqinzyEdlY4GENVRM2nJEaFirP8/6/nS+cdyguGL8VVphTWmZbcP9UoOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(186003)(71200400001)(66556008)(86362001)(66446008)(7696005)(52536014)(26005)(316002)(8676002)(5660300002)(54906003)(478600001)(6506007)(9686003)(83380400001)(33656002)(8936002)(55016002)(76116006)(66946007)(6916009)(66476007)(4744005)(64756008)(2906002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EFindwUQ3dl+9Ou0SHym4pRG9Du7pnXFx99Ygf0hSh8vU5mHZHY1JSUbhPsA?=
 =?us-ascii?Q?wbTOPojQKig7tT0o1atnKAxrtYlrHFL+E6KK76sswurz77Mm/pkjorUCntqz?=
 =?us-ascii?Q?eXVsBn6I2lr8uL2o+gtWf/IHxfBq0PUdg4WapP5gHW3LBB3AoUc06aPPPplB?=
 =?us-ascii?Q?Wq+9stwudeDJaik1oNbMcADd92TS05berZjWBlwokE8x1C9qp5GH7gJvDz7e?=
 =?us-ascii?Q?nnN3rO5hLt5/4vKxjsnHK5pzW0fh4RPeSPKiNMUeDzOWU4hLpcIsK5oBGeUY?=
 =?us-ascii?Q?dvqCN5jHUnA4ja7nvSequ5QBw9UBY7XFjIxOxYbG1PmwfKTTxJ7uFZOHqWGF?=
 =?us-ascii?Q?YabJcjsbblqoWjH3P29mX2ybksOR9kTCtN7xwYrZkAn7YR/tsLfst+VAjTFm?=
 =?us-ascii?Q?/9XLBMOBoHdBnjbOIugmwDUTyCyrlg2nfZEHZFhY7/pAzKrA6E5i/YJtT/xM?=
 =?us-ascii?Q?NtaaUkDuk4jfybA12aCvPlPa1fEPmIUKSDvDFolcXKaMTeZqBolqsVwVhkdr?=
 =?us-ascii?Q?jVwUaN+vjT3wxvcmvtLKnbaPQjpJlT5OD5dZQc+856InbLE12kIlzJoTUizg?=
 =?us-ascii?Q?/c5LDNGavCCruLhpe9jcRPCF3+C5nlM+V7qhZ9JdBIRSoERQNvjPNp9KoO5K?=
 =?us-ascii?Q?iBxGn+rjQgE3jLLU3kd4NoFPNhxm5XGFp6c+9nMrrYPjnP6fx5zppLiUYOju?=
 =?us-ascii?Q?uLS1R0uuWNgZYZ0MfadhDXGz8bSsCM550FfpDjerbshL5cvwXJ+Ds5eJyRxP?=
 =?us-ascii?Q?OgUQ5gp+ta0pDv7HTo9htTQlXJRv6TDxB/bS2hDniny6bYTDTDTB4HiXe+Mh?=
 =?us-ascii?Q?mvcO1d5k85mXvZoHmmmZUSRqzAShyvGLJXkaKRk4eS41LALIIekefkwAnjOE?=
 =?us-ascii?Q?GC3kkSKDw9cEBkiUaWLb5zSdNeouakTQ39t4jFL9kiUoC0B7hkYR/4BmYccb?=
 =?us-ascii?Q?L0C0z6EXU/c05VzoM9vgnZEHT0F15DPdWymw0Fbpi3s=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3439f44-b64c-460c-3afd-08d8a5d1de12
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 17:00:06.4115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eiRO3cEenmBnZ4ZOyCjxLT6m/IylpLW7wzzWG2d5GkOCM3wsL19yF/3/zaNXmMSHbRdJLSlceKS+lcoOiCsK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6969
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > When gate_work/ungate_work gets an error during hibern8_enter or
> exit,
> > >  ufshcd_err_handler()
> > >    ufshcd_scsi_block_requests()
> > >    ufshcd_reset_and_restore()
> > >      ufshcd_clear_ua_wluns() -> stuck
> > >    ufshcd_scsi_unblock_requests()
> > >
> > > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recov=
ery
> > > flows
> > > such as suspend/resume, link_recovery, and error_handler.
> > Not sure that suspend/resume are UAC events?
>=20
> Could you elaborate a bit? The goal is to clear UAC after UFS reset happe=
ns.
So why calling it on every suspend and resume?

>=20
> >
> > Also the 'fixes' tag is missing.
>=20
> Added. Thanks,
>=20
> >
> > Thanks,
> > Avri
