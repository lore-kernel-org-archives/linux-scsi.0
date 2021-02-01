Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C93C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315E664E08
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhBAHxZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 02:53:25 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64172 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhBAHxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 02:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612166217; x=1643702217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CEuaa5ddW+u1ahPU3X/REvKfK1e2vgRBTxh0sqo4tJ0=;
  b=r69+XQ3cYnncCVAdRgZQHsVfzyXWtkC8ekGvzRlBRE3b98M3yrPrZqkt
   oKHqwSnNxtMlFGWtxcvNj1m+IcoLU5Lsnga7kHAw36fgHRnmIUlA05SJk
   zZC6QtVkKvjAP3vIZelm+bRU9ZM1WsSgntKzTjvZ0j2xMr+M74tN6s/UT
   KvMnYkd220o5Z9Zni3K90lSLTA/THnIWqrBiFOJY1asRjTKNCkW74HuJD
   b8yiSgJT+K1D4EvZBBT/FLEuwmdmJI6cn1q3bOtCFysyoKTbdng07Bo1z
   C+OLjRYP2AgCWhPtngvI1JPRVgZs00ngRXLkJlfwXhhKlcgfbOqjVRn/0
   Q==;
IronPort-SDR: HFW2+yC8xaIk2nfrePjBUkfi6LSlski6g7c2z4nEadnlN7pVbH4EC36VQQr3O16oQbweY9ZEIv
 GdE0M3cTt3FXgdmWA8ib89FbQm8uMgYkGvfqERgHrbfZal0WCP/zaXEroRHgxKXMmZ1JZtuQTs
 qT/+kko9CnQnprQMfeQjyvN8vTP0FVqMn5moTRkjWhq++gcmpoAeP6uWZdN+rFTeKty02XYFhO
 gyYBsVww/LOliSC5rTdnfNM23H/8q7sbkUkkcn/FMbO3Gz91mEMpNBIq+FAflQQszYy4LG3Nya
 Dsw=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="262859854"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 15:53:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9+KZF0MtEUPH4hMVDJgABthxSLk6YzidZ5wnv7rMIJNWB+wDbsdlrN4tiddtK1fiQmUgtUadPbst2rEPpW4pLlRJIqQFJbvqTdV5UaB9ZIuwcZMW2p/4Tk+2xHUYa5Xs5vS6ksGLJv8PamYkNWSb4E8RD6HxMBhl4hKAoons+BYv3U4Azm9xFnwkiiq+30O1yYT4erK3yJgjf3V5K8qeTHkrGCWVQS1LhZMyqQrhVr00/hnRS5+J+u4sazn734mW26fqzDApAHYbYFDEtBktPRwE9WUGdOOTDnlIPmpI9M4i/F9UHFAVIDoDI1sb6pWdqeGovlxPNelY23N7hhTcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rkvgl7D96wYVRKsFEpcp4BsDIAPpm0KIhFEtM4nuqRU=;
 b=USgppsx7CnY3vKvGmOTxKdMN8aHDD7Gnz8WgpDPONmWb/TAZ91I7AfAh9/DitSr4PsZ6DMDqopiZEWvaXrDe1k2ltQUGVVIex2eomg9cZCPBKzwj6RoyYieMMz0o+MyiSv1x/vRpjRlDMYIBN4UuO/wFKBye8Q4pyVzzqFyLk2U6NhkvTrSz10RNm2VAwytyUjvEb1p37I/0qHDl89jSpvQXs6F1oEEcpMmoOSEz9iAtEm8AMvNRC8sYZpk/FjrQXoThCxX+Pm6XdWm53E7fAjS8ifQY+xH3jDuGGoD+gJtE5hQkzd4oYPG4z7Z2kpY7Ieg5W0Bzt7XrxAdsTLBpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rkvgl7D96wYVRKsFEpcp4BsDIAPpm0KIhFEtM4nuqRU=;
 b=XVdzuH/B5YFCvztlrMKQJzTiAjit96cF4ogwaIMd9r087nFvF9noMxar86a7BfHZb+xut5+cqGlIaZgXP0UGQL4vU7OQKq9JG3ZZR3YGi9WmudS2J10d1/8SskLWMld0GBOCM335/X1wnICxUI+2Zv93IJfo1hLrJXl3+XqDdCg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4156.namprd04.prod.outlook.com (2603:10b6:5:98::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.17; Mon, 1 Feb 2021 07:51:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 07:51:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW9L7x4iaxfLLWbU2VlJGMVSiCUapCsZUAgAA24sCAAAZggIAAAoYw
Date:   Mon, 1 Feb 2021 07:51:19 +0000
Message-ID: <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBeuK92cgBkvYpk1@kroah.com>
In-Reply-To: <YBeuK92cgBkvYpk1@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9676ee64-4941-4947-f107-08d8c6862996
x-ms-traffictypediagnostic: DM6PR04MB4156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB415620B69DD230CC909ACC17FCB69@DM6PR04MB4156.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gQ2Swq3FIxHTprlUC4ozB1/GP4B17vTOvH92AjC/pr02K1tCoOj2N1quRqlpw3mPvVlR6dxaE0rwmMTffxL82q077HOHiWDucdfQpxXp8y31umq0FCCFznpNeUe0o6Nm6lMSUIU3cmV1TR2dfjNzyJ/8U1XymVetarNpCALzElhfeCZJ2ugh54sv1F1UJ9L4gH3LBmOCahDD5MIfsUZn0TI9MUZBOcBc0MMGsBAv6LOKFzgP9Ztdn9xYBgyUb2xWTK7nBj/m/1JWrCUgyLt7QPjVkAaKKsdHiDxefdnQUcug467QY/6mQgHp/SVLPs4aiC5D5R0k3krV/+3hH30JpA+3lw0+5QjBNfAVw0u4OuaaDdDFNOO/6TkNeA0JauYAnaAJhj9GJF4K7MJdSmm8ezhWul4w+U5U1X99GovIfHl2pL7gbawDeSM4RYUOBQXqJRmokadpSIHn592Tr+wVsF88fOBZmMntcowpwc+omcDIgkoFacoE1F1m8eA1GmpoOdq/i1ckf/UttwNHtIxmdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(186003)(478600001)(66446008)(4326008)(66556008)(2906002)(76116006)(64756008)(33656002)(66476007)(83380400001)(26005)(7696005)(71200400001)(6506007)(52536014)(9686003)(66946007)(54906003)(5660300002)(8936002)(7416002)(55016002)(316002)(6916009)(8676002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qmvtXXTOk0K1zZ0NEJbcHK3olA59FO0aaz2zuy/xBocBAUr4dLrXPSd5N6gv?=
 =?us-ascii?Q?TRNZmgAgNNRt6jFr5Kwg6B9Vt5KSbe+IMlgePJySinAYQGt8MDBfn8v8emn7?=
 =?us-ascii?Q?qKwWsCdsCP3KtcnBCtBUrAss70ciwnx0bvjKZ1uBzBECZw0rA7mCBM6vd5yn?=
 =?us-ascii?Q?Ha+a3LBzPHXJ35LtfimHUEphjLxKCQ2sCalimMhYN92GE+wFAzzCvEhFKRo0?=
 =?us-ascii?Q?58dtz14Scw1yaRgbEff1EZaoOVACaIkLaS1l1myud+jOsqPpXBLGONPwu9LA?=
 =?us-ascii?Q?lq+pljxaZo1BcIYR6qJ1ZZV87f8vJwGc9YSPkeQGOSFUMKi+Q3TXGYGeBW0z?=
 =?us-ascii?Q?wEqhOZ7Cys4k4hcGItsRovtYnEGJvayhf0o8B+bj8NZjS0bK2KDiRSPPNj8H?=
 =?us-ascii?Q?QANkMf0woJDQ1SfYm+nAEmHYBTpN+BVZamLQ6UJki5zaGpGSD9j+4ae8JHeM?=
 =?us-ascii?Q?ScFLbtHICHzLUJuHXEY0flWFyrZCRCZe0ptf/HslUX+u8CpjERug/C2XsUY6?=
 =?us-ascii?Q?ihdGKoSVoy/8j+4Y0iOdsgQSXHPV591BLtRpyzY29ptF03M73PUnE8tpRn/u?=
 =?us-ascii?Q?Q0BAUOBAG3K2QnaRIe5gXlYo+sk89rKszRbi0+CMMnKjZClgHExBaRn0VCuk?=
 =?us-ascii?Q?gCtLwxi7iZtLX9CqWalxU6/EHF9j+tUD8O8jMZYWQtY/eJYeQ76IfBn5PSeI?=
 =?us-ascii?Q?24M25DrTQrS4MQQbSxmnjmB4E4tbVhTZQgbthTkxqSUEcy2IjFPe9Orn5yC7?=
 =?us-ascii?Q?bK31x2SBJatKpEVjYli08y0SjxG4Q6AQZ+gNvgTngSoEXUL9ldHp5p8ShQgX?=
 =?us-ascii?Q?tbvNDx+7e5w1J+qXX+FfoVBM9Li+rOlc1ZJojDNXj7CXfo9kyXaDYGFGadu0?=
 =?us-ascii?Q?D3Ein+M0kKhX9VbdxXr+qVKUAf//hObwypiZV0+IsFFGVtOZtr53WtnIvTDL?=
 =?us-ascii?Q?KCDqtNzz8LBtx6C5hn6Dk6Ezr5ceGv+2h9B4bH8EpJyoZtLyLaJ6mVwSBNbb?=
 =?us-ascii?Q?dnO+JsjZwRl4ZOIqeEcy7dN6J+oFQOjHasqViTiT74rQWN0MaJYlotaJ0/C7?=
 =?us-ascii?Q?AAMdvk3I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9676ee64-4941-4947-f107-08d8c6862996
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 07:51:19.7943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CYNjkCQBWEzZi2YO5cNZrXIS/Pk5UrfRcmEqWu1b1WAIV3c7qabwa8LHFcdKRKo/AKChEBm2b71XgXHZ18dfxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4156
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > > +#define WORK_PENDING 0
> > > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > > Rather than fixing it with macro, how about using sysfs and make it
> > > configurable?
> > Yes.
> > I will add a patch making all the logic configurable.
> > As all those are hpb-related parameters, I think module parameters are
> more adequate.
>=20
> No, this is not the 1990's, please never add new module parameters to
> drivers.  If not for the basic problem of they do not work on a
> per-device basis, but on a per-driver basis, which is what you almost
> never want.
OK.

>=20
> But why would you want to change this value, why can't the driver "just
> work" and not need manual intervention?
It is.
But those are a knobs each vendor may want to tweak,
So it'll be optimized with its internal device's implementation.

Tweaking the parameters, as well as the entire logic, is really an endless =
task.
Some logic works better for some scenarios, while falling behind on others.

How about leaving it for now, to be elaborated it in the future?
Maybe even can be a part of a scheme, to make the logic proprietary?

