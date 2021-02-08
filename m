Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D46DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 433C864DD1
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhBHMYi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:24:38 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:40710 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhBHMXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 07:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612786995; x=1644322995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hIEeR6gXuPhDdRJVSQeRZoKpI0F4b5m25S1EwuyMOfg=;
  b=Tpc3qf8wCpHiVhCPMkOHc+VQiMwGn6QDM+eGduhH4WSZgrQnrimtQG5B
   iivJb7U0WE0P7HDYdXb/KbtB477GwSQqR6oNijzH+y5NJypdUZOW8RIbT
   cwHkJ6ToV2it/aHIPpXDz0tTaYmgAu3IVtxwe0if6l7YyOBtA63jkno3N
   8AlpOYu36SzgWKmEsQtGVwqa5tGNaDdSxwdqxbDDLvhxZmm38lqI6fAlJ
   RWyN/ldoWm1ClOx9YZeup7u+C2B5wKiAfJpGCY705sbUCj2anEsOgtlIk
   SLRXZvDU6DxroitNZpqQmft+FNv4I7Rk7FS4O6ejfXZKQoQitff77xy3E
   A==;
IronPort-SDR: De4D/9RBpkl1UeHfj4z31irv58ofKrOghdBpj085KR3ZxSTwpU3S7XF4XCEQtAkHam2Sqg+Tcy
 PH+NB8FARQwH5LDwxXaAOaRyqvecwbEXuBsbEHH/gecfL6h1e6e5wlvNe+6fzhU5PuNVqse8cl
 BGXgs9z/U6snwk1IWzyMZYjG6Kd8GaDY6mgMry8jHoyiP1BXxLDMm+kbb2ArFsQND7zSVnGThf
 piJYp/0s+3vSikSZIfgPUx53ZCdZIy4IaPrMaD9lVTdNuGVsKjMcmbB7EXEm+A8ooN/7d0pKsX
 rGM=
X-IronPort-AV: E=Sophos;i="5.81,161,1610380800"; 
   d="scan'208";a="160615331"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2021 20:22:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRhkW/ejCCQEbkHFRwpcT7UJQZ91hecKeXyc1RFewuGYViaN9eLEBQfUsYaVrZpIIL2REfmao2CBlN7S5km78E7qSH6FEW25cAD65k7JMtD8MjhFv2TVmZ1yBtrAhE5PP0GbeofSn3uRKJoCKNBwBG7j1xm9+EPU0SFyksocOCJkJXQEQFSEOWZJUFL6YAsbZk9vxy0BJvcY2Gxg8/XGAsKsNMHpvfuKeTGq4tMr2jhMt+Ol6sM41bqcqYKkabUH7mB840ucd4lLJ0AT3ZB+KirHcPLjMj8h4dWK56wcQbcAf5LGKQF1oP/KDwS+8/9B4xkSeY4+3tnVBAID/ZCV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIEeR6gXuPhDdRJVSQeRZoKpI0F4b5m25S1EwuyMOfg=;
 b=eYR8r2Jcjqkvp5hxozd+7v+E7DdqWJZNoLDsoDCBRAwf7nT6BwuNq4MIf/gWSkNUBQvyQLnTHHwN7u8BwVLqrbOwKkFeJOHnl3BeF74SPxKQgBZFUohjz+Fj7Ppu7sor3XKk6Scf96zm4zMJpO5AwLC+LG0I4+lqChsm3Ikt88ITQsRx7l0mdkjIXw8by/o/iySWS/rVc29zXAtT7Ui3A1i4oxofKAQgoxkrECRZAnQokzMUpwivxOtlFvCRVSFvqid1oT2lJOQAugsXm/1glbMgtWalXUmmhP3s+6E7XpqaxRO4qhZU1XSJ7jQrmkLXSmWwA93UsvZVJ4RVxaYesQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIEeR6gXuPhDdRJVSQeRZoKpI0F4b5m25S1EwuyMOfg=;
 b=DfKGEEz+eAuaEPaVRGVMk32EVPcjqR1eaDwuwln+cKsU+K2PIXpz4o/t9H2LPxURRCHj0PzZwnmDSTWEGjp6ZbdJ8LQbWMLIloJQXvl/H8N+G4/aqO0jrOc5b+V0ZsYbDLHFybS78G4v/qlQLoAu60OPvqivX7IOjZoPZGBCDZo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6636.namprd04.prod.outlook.com (2603:10b6:5:24e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.21; Mon, 8 Feb 2021 12:22:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 12:22:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "nitirawa@codeaurora.org" <nitirawa@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stummala@codeaurora.org" <stummala@codeaurora.org>,
        "vbadigan@codeaurora.org" <vbadigan@codeaurora.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage
 level
Thread-Topic: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage
 level
Thread-Index: AQHW9ZZmeK7PA8AawUSfMfIJOx/dhapBx6jwgAxYJD2AAB6icA==
Date:   Mon, 8 Feb 2021 12:22:05 +0000
Message-ID: <DM6PR04MB65757109C5292CD42F7799EAFC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
 <DM6PR04MB6575D0348161330D21A9B6C5FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
 <48fbd86b319697fced61317bd15c4779@codeaurora.org>
 <2fb825d458fb87a522b4a64370ee83b1@codeaurora.org>
In-Reply-To: <2fb825d458fb87a522b4a64370ee83b1@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f639a0bc-597b-4d08-7438-08d8cc2c25da
x-ms-traffictypediagnostic: DM6PR04MB6636:
x-microsoft-antispam-prvs: <DM6PR04MB6636AD7C4DA1A28E51D540D6FC8F9@DM6PR04MB6636.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pIGV1/hwJL1m3aX0lwWDVJAdU7Qmd290DLOZu49S8n999qZ+8Z7cYIqPCk2EqzJOqUcTWWV6cXKbwW5s+ASn+NR5udMb81XNkyUVawmY6v5PqlSiq4NdavSH47isgKr95qd/0V1jl9HBUBEQGtQKbIDpBG4c6qYrvTv2pe5cIWSI1JrgjNjw2C9b0+v4+BfY63rcRFrXNqZu061kXkRqBy4xD9iXsVYjg1X7IERsx32+R4ermq4ULbOOyNxYJECc9NVvHt4GOOzrtdANg6UbMRXJCDTxfSZNQkjybaSUFBem8DtmWLUe1HED90VEzfbOKo6HIdqePuVbY1bYXD5jenAPLZzrfhIv2bjmBc4kpvsKOHfcA4JN6cJKTrf+5nffzIXWvLi5L39TEvLfEyPzOE/Gupd1yGytys1ud+VNcZ1r/08H94nxLAyfoeKIxNzOm38R9ZBfHA1NLeIEUmWEdTIsCJ1y5vT4KqPkIYhCqcJWgjhM5s9p6WeKo23roape0oXKsbYHA7Lj1sZ/brr++4nfOKKpgdSpG0zwnYdfhiFiEUe5lzh7/Ii4jHgP5sa49gngQgF1y2fMrQO+/Iwr4gSNbBcBu2ovqDlh2sdlzYU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(966005)(9686003)(4326008)(2906002)(55016002)(33656002)(478600001)(8676002)(6506007)(6916009)(8936002)(186003)(83380400001)(7416002)(7696005)(71200400001)(5660300002)(4744005)(52536014)(86362001)(316002)(54906003)(66946007)(66446008)(76116006)(26005)(64756008)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RS/MOij2yY/7lJkoApfOim0yvDLekFwc0k6knY9AWke5F5ctgWh1Ovfx+En+?=
 =?us-ascii?Q?dYuOI9TkK9ygdMOrebxMzSrSUwZkqvY3fFKwFjv2XU6w90PiKq+7A0XyV4vT?=
 =?us-ascii?Q?bGcSCER9K+i1S7UQVTzDC8D7vIMVWRjDbWZwgXkLbRWL2Kniu7fmECCF58F7?=
 =?us-ascii?Q?2E450aCSz96a7Sjy5giHidMnTwNwU61XPbNvDH4sz/lWHV3psFGL5qU7RU3K?=
 =?us-ascii?Q?2UZaOWdMj8UuYpjDoqBIQzgokntEV3OId8FiJuFA5SQqJWFuOrHQyAwynTDK?=
 =?us-ascii?Q?59RQfr0zUHHx0P8XbWBFckfjPhud04tdIcYMRvXN9weMUPk9+B2IMrXGFDSH?=
 =?us-ascii?Q?K/PCuynxq7nkl335jeWWJuikxkVs7YzUGuhNFPu7gvHVJ0bqYFkbw8nL9cjc?=
 =?us-ascii?Q?mVds6Ju13MP8zD0lw5aZX3C86lS7myT4a8Y8UBqaA1gb/mP0TkZAUFVhkAjX?=
 =?us-ascii?Q?6xhf9MgcZvdYJgW2x+QbKPO0PgBgle6o1D4rxEHRT4cQQRrCswgq5cJU4jMM?=
 =?us-ascii?Q?uNYBNqANljgrUq4WQp08L7GwI4jwRDr2fnDxnaEDlYu9c3HowjZf9342e1g8?=
 =?us-ascii?Q?aQziWcje4ze9a25FYDj0FtqrHKfMKqvxN0e1GpVVtEN23lrNHZrHLJIutAGl?=
 =?us-ascii?Q?A384Y7z3uIJAe+D8VMFEhAx0K6P1o18sdeRiGe/KVE7lP6JRBpodVjFwumcp?=
 =?us-ascii?Q?gKvZhGiAf9DHR6V+2KMT/o3bKnc43VXr0PsFiPvYjiaDp8nTNPMAtJO2+MVg?=
 =?us-ascii?Q?bNA1ckqKdorTvFAKrpBupVzOORnp5Ra/+2GxQYVKfdHB+MHaxhzj2kcLy/qr?=
 =?us-ascii?Q?v3Ym7/g+G5RwGWfJzlsbeEWgKFwJpAtBIJ0JtVjvNSlc3IQ5QMEVUxE1plgk?=
 =?us-ascii?Q?n1iPDARbqdVlttatA1eJIfx967qCMPCiTd87970TTc6Rvmo+FLNnkwnquqUG?=
 =?us-ascii?Q?QYVxa4I9xqLiCG3tkfiA82I8kyBZvJdXzkb0wRgzQ9w8eFy259DcJ1guxFBU?=
 =?us-ascii?Q?WRQx/ZOf0YYu0oZInBHZwly4+t89lOdU6hghZi8KFQwvCJ8R0PFK/dLObbnr?=
 =?us-ascii?Q?Y1ZA1u/mMAncAFqmEbLCIuJzu9eqs/LsWqRf+9AD2MbVu5MVJ+v78+GiA0El?=
 =?us-ascii?Q?HU+2KyWBeG3GLtzDNRa+s5UswjINTmMPwAgvEY+4A+nmLSUTwgHhyW/BIE80?=
 =?us-ascii?Q?MkR0aomda3WCTLGVfOs28rO3z2tcgfnAq5AUpMgRAglQ7DezLlLYYmvKAip9?=
 =?us-ascii?Q?6VewdEx2FnJ/PdZflCz8UmxPfedMGa1Gqlg1tP0+DvKssz09HgOykLTA93+V?=
 =?us-ascii?Q?KIaL/qa2u529j66KU1woX2GR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f639a0bc-597b-4d08-7438-08d8cc2c25da
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 12:22:05.7301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RzgMBMgnqCT/53IiYL2+kAznYBvtB43L6JBpDqFY2GPJiVIFEe4LkgEHrolZ+MNvuoRlgG34GsmBl9DDenUq2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6636
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> The flow should be generic - isn't it?
> >> Why do you need the entire flow to be vendor-specific?
> >> Why not just the parameters vendor-specific?
> >>
> >> Thanks,
> >> Avri
> >
> > Hi Avri,
> > This vops change was done as per the below mail thread
> > discussion where it was decided to go with vops and
> > let vendors handle it, until specs provides more clarity.
> >
> > https://www.spinics.net/lists/kernel/msg3754995.html
> >
> > Regards,
> > Nitin
>=20
> Hi Avri,
> Please let me know if you have any further comments on this.
No further comments.
Looks like you need an ack from Stanley or Bjorn who proposed this approach=
.

Thanks,
Avri
