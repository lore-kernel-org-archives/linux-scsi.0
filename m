Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609FAC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE1921775
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fw7B6IvD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DT7mRgg1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFNUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:20:12 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:61723 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgBFNUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 08:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580995212; x=1612531212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tci7fptay5cIyGHz1i0H9LCfHINfwD/bcMD9HqaGfjs=;
  b=fw7B6IvDE7YTKUXsibp0goYRksX3jE+ICTGZZ8Ksjl4Fm8zvjL5Z1bRi
   il6SclhcqH7TFlGMPRaHW02vsp0z6hac1QQqs3DCvinYPPB0VB5wKiMRp
   krKDgieSwfvaanMO1WIJoynPNLNYC8mvws/fu6TC+xTKvFK13DGzlHJXX
   pEGv1TBXcpWyaPbsLDm17zQySTP/I2BYP4xZmM4uw+BKV33l2KqEVAV9l
   vzKF1DE/FnjyiFFCM/l77c14ls2He6u7+gYvWbw1Wu6SjQk8BBsJiVwbg
   Slkwo85zV/Q8r8bIaKP4HCHllDNAkl7dmFQqJqSwwKTmrlEvEJZqos+b3
   w==;
IronPort-SDR: zY4WxZFka5XFBS3OqYwMIuqbhwXzbHdLc/lVn4XB5HgYoOHZ7roASaNHxZQWxSSaJIOPSlb82k
 GBJS59iEBeV9UtYm7QoEMF+GfLsWuvHZXHZCW8vBRYPyPXjqMNfiAlLpEsKQYPAko5SSeljk+L
 3gPzjVubRUICdbMbUdEwycifOphbn336v8N6iOaiEcrxA2MCoil7fqnGmq8uLpKoubDJRiLCNa
 xXdidZdTlBu1fl7YZ0G9+MCGLRe2YL35vY28y88vN6iGDKSnHxaRbTS5NQpWGbHTryQXuQ2sRL
 BtQ=
X-IronPort-AV: E=Sophos;i="5.70,409,1574092800"; 
   d="scan'208";a="133602647"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 21:20:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSi4d5Yc3b2Hc71vEj44GKONZwDiA8istSXLAAkI4TrdgtY6RWjFSHYwgutD+RGaxDtPUH9wyyaT9JSm3GCaXlyFJvr+RzmzNO6x7u/JAv7K6ZWCeEMqLgrbfDRLITBB0vKQYif+w2SPz9hFEtfz5SlR6reg5vkzbiXCwpz7kukWlw/HW6lrhev4+n18I8wxIE8A80cFeee1VT0W2z/ed+ZC+QGb9fMk+1WbREywR6C/hT8aqwET5b3GkfX8d2eQ6FKfg/vGuPgNyW33U0h6P4wMRQCe5XecV5Mi74OXDSRxV3128yGiSloRpwJOTzl+jkjXfidqD8PmjiyWEnZWUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tci7fptay5cIyGHz1i0H9LCfHINfwD/bcMD9HqaGfjs=;
 b=Xzmf7Ux4lRhb1vd0zO8FVmWzjDRTQqjrvlKo0IbpPGBaMjDlnndeReI8RlNpKdTPjj77DQDFuna0LEA6/i+fpdR+LHh8nmo4+/CDG376HgcsNltuUhcWPUvZ44sQMoP7/N4ZTY6kf7z8VVfpddUpsdE7c76+uAq5R63LThz3Ab96KIfJWSivJ0ySkVdjl7wsHVRdF8ugH8pXMkTRSCDfk39sTGJDEPBJxIDUTAaosa1W4ievrh/F3gl9qFanJiwYLP4HfPJZWPeMHmlY26Ki0S4vHlBvKPkvKBQ42CA7vtEep55Ss+A+Fo3jFx1ze7svo3tDX9NoJW8fCXdHDGqG5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tci7fptay5cIyGHz1i0H9LCfHINfwD/bcMD9HqaGfjs=;
 b=DT7mRgg17VK0x+526Zud+pBVWakijBRtR0MxeSPxuJMRgPIkovh7lZdhVqo/LP4kpW7Q7zI3XP8PiAu/xCqGfSfGnHA+BejUn3wVMmZk63mMFY3GSYEdXE+oyVYSstLRaMHOw5spKKDqVLuf9CbfO9mIyJzVXdYhz3jOzs8D/Yc=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5662.namprd04.prod.outlook.com (20.179.20.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 6 Feb 2020 13:20:07 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 13:20:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pedro Sousa <sousa@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
Thread-Topic: [PATCH v7 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
Thread-Index: AQHV3MhOcPND5Q8f/kqjkSYvDk+3nKgOJc2A
Date:   Thu, 6 Feb 2020 13:20:07 +0000
Message-ID: <MN2PR04MB6991EA027BB31FA58EEBDA81FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580978008-9327-1-git-send-email-cang@codeaurora.org>
 <1580978008-9327-9-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580978008-9327-9-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1726033a-1546-4a2c-3d0b-08d7ab0748f4
x-ms-traffictypediagnostic: MN2PR04MB5662:
x-microsoft-antispam-prvs: <MN2PR04MB566246AE152457BF753D6C3EFC1D0@MN2PR04MB5662.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(64756008)(66476007)(66446008)(66556008)(8676002)(71200400001)(81166006)(81156014)(8936002)(55016002)(9686003)(86362001)(76116006)(66946007)(6506007)(2906002)(7696005)(186003)(478600001)(26005)(4744005)(5660300002)(52536014)(4326008)(7416002)(33656002)(110136005)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5662;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYt/SdTAynx6CTqX5zUDAjR4sDWT7+Vn7tqs/E9q4NNH61xOpOxXTlSsJOszJjLQOxu4A0bSze4uJN6urJPorAv5qSPoI3E+0pXDH+ibFa8GY+W3f71OyRWJt2J8o6ZMFxxAa2MDhzNiE87tH/WwsZ+lLM8GvkHTotId6t528qDQcSSLMRW5ioaKPUpxaIAO39ToVu0RzdkhoVrrRP3hYO0oiRhbVw8yLAnBQ9m4q8nFvv8nqBt15oon1neqOjGliroI8QGa0PHWrw5TVa7U1P0ZmZ3dNSlZGz9neh+YwfKa9usJ4Qu6hg85B5M1Ul4m4NI2FuQ8y5aW5Yr1dBIu8UJ2CRq7dVgEwOwhHc8hlnoQf8oRoqLA0WHUmV1UfSkxEG1GMxMMZa4NgptPoOVuNw+EPaGAj2c8rMsw8cBGjAb6LgOrdPD4CEBbrmgIg4h2
x-ms-exchange-antispam-messagedata: ZdwY18G+4CHbJhtRn8Vxp/tiOs2suQ+PwkES+bi8VgGKkRZl1dnbREnbgNqDbhBB03z7J3hpoKXmVm9vJYcWB45lOOr6AVmrAoTn8wgWKH3ReniYBNlhrLEoi1eHO3CyLSiTeT8Q3mUVbIiFFPyPVQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1726033a-1546-4a2c-3d0b-08d7ab0748f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 13:20:07.2225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zExoRXxyy3sgLru2xkZf6SE9vvrB4CCdCGD4RL9IRqqdyo61Y5zx62D9LBc4CO/C7qyBE8FLJqo/fcISHCFgwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5662
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,

=20
> ADAPT is added specifically for HS Gear4 mode only, select INITIAL adapt
> before do power mode change to G4 and select no adapt before switch to
> non-G4 modes.

UFSHCI 3.0 says:
7.4.1 Adapt
The use of Adapt isn't mandatory but the specification provides some guidel=
ines on its use.
The HCI should perform an Initial Adapt in the following cases if the link =
is running at HS-G4
speed:
 - If DME_RESET is initiated.
 - If an unused line is activated for HS-G4.
 - If UECDME.EC is triggered with bit 3 set to '1'.
 - If a change between Rate A and Rate B in HS-G4 is performed.

If it's not mandatory - why are we setting this for all vendors on all plat=
forms?
Or am I miss-reading the spec?

Thanks,
Avri
