Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEBAC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF292078D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PgT8EVEY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h/VdJSk9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJEIKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:10:31 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61324 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEIKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601885430; x=1633421430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h5zEmfOQ6OjPThExaSDg5fhXlIC/H8IhGUhXmwCI1BQ=;
  b=PgT8EVEY7pg2aALCpo+cXuOAnlzCHK6TjClZ1puf6sRk2qtl+WUylqaR
   9ujUqF3Ff3Bqu5KvMpGluaLamJXsirZcpKvYfB/T6LvyFB3UX3AJPtqTG
   M8YMfQNjgGY5u/GAcMNqvmtYXY3gbrcCEFlR03Ai7H1xapBLZTAoqy7Nz
   xriGuUvSREkRx6BfUBiZlpO06uAWkZlKmo0WJVDdE3GdgPhypNHqxj7s0
   DaB+411/hZs893bckluTHz78HBMXXk/ztJqIHUp1huw6lYisKWCtNTV3l
   55pB1HdKJ0MMX0ashiID3EgpaZjO94U1d+mKVdeldkTrzof6GRGb3Ji1l
   Q==;
IronPort-SDR: omCubWnhWzw/9XfoL1fy4rLaIETO7+e1dRRg3/qY9NFeLGdd/jKE8QRY6oWaOEwMS4kS4LwJ5V
 c1VYb2lKHtx/YYEbWkJijHEu1BbEJbRTb6gF9NBtTvpY7ggL+tp4PfvS0nDz2JR56m+4dV1yCt
 fbUocP/fa24GqlY8T/wvGnPowhMslNpl6NbzdT8Jnt7rwfIdgOrwrxzCHNl1RXR0kTtKMkXQwP
 4VgOgLvZwTYhDZ74lsE5bVWJIdZcYiVcCBfMsoQhItmsN9Xchxa7vYkWlVL0xHBrpJcOr/pEeT
 1QU=
X-IronPort-AV: E=Sophos;i="5.77,338,1596470400"; 
   d="scan'208";a="258847590"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2020 16:10:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcjKQOITx/5GiQU3mjMP6iPmowJxOcHNJ1Q3Qgaq3D6o5D28GOazj2vj0lfYsnH3q5sgU6J4vWpJlxl197AgCmlbuzx6L79LZeRyEYkq8SgzoAkG6mJEPZTZTdlGx26Ut5DPzT1Dlanm34BhIHrWg5dusCEpkkkvWg9+u78IEfHNRNbLIBW17UX7T9TkW57EX0rAyuQDUOSybI8uRZctfZl1uuDM886Xl/kxTAZlbCdArtlRDFVjRVSCeRflt3Nn9QaavmJByqWnxboc10CMPmqSZdb30uIbEQ5BF+JHbHWsJQ7sDlPYOeggnvjwlocm88CUjmZS4SLOA4Uqt6kPJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5zEmfOQ6OjPThExaSDg5fhXlIC/H8IhGUhXmwCI1BQ=;
 b=Jc0A9ZzNToSjN8ZcgKQn2EHI8cZj2JDDXYwPWIQ/2VQl888SoMveudEO+hoBF+nJr6UsmQI/0s4KKyMP1xeCf15upiw2pmSDOKQsHNVi8J8wmsu/kMTuuX83JMrQBIQrwMj4drV0vkTaa25F3/m1eAcz1QXtciwejBfbTGNXhUOeASq1iRrI+CYfN2ujUME9P2lmPNPx7cR1KTR7GInS+z3fL2tSVg47ylr+m8qyFTAIzUbbsueCliJTNJKsIT/XXVP+Ge0bIf2lKoUyJa10sBs1XQm8OVJ1oz2Y/GaKRrR37biZQ6vEuhEKr8oaaNgidOSNTUe/UaJ2DMKXwbIUZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5zEmfOQ6OjPThExaSDg5fhXlIC/H8IhGUhXmwCI1BQ=;
 b=h/VdJSk9ISOfbkkuY3oaw27gVf0/vadzelfnBJOXM+Q+7F6Zd0dMTQbg8nd4UBH62CnJYprCzCk+POp4dYtKUDurovl0Ej7YkOxo7BxCa/ZGmztyHcRQntymhFfbikO/AFmDhTfMkNOEC3q0BVvhCUCqoY6Vx0/jIzRSRqP96Ys=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB7010.namprd04.prod.outlook.com (2603:10b6:a03:22f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.42; Mon, 5 Oct
 2020 08:10:26 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 08:10:26 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 2/2] scsi: ufs: Workaround UFS devices that object to
 DeepSleep IMMED
Thread-Topic: [PATCH 2/2] scsi: ufs: Workaround UFS devices that object to
 DeepSleep IMMED
Thread-Index: AQHWmLlYjXyGtFcL/USRFG3wyzeVI6mIqviQ
Date:   Mon, 5 Oct 2020 08:10:26 +0000
Message-ID: <BY5PR04MB67055FE554CAA5C5F5673FDDFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-3-adrian.hunter@intel.com>
In-Reply-To: <20201002124043.25394-3-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94f31486-37a1-49eb-8fef-08d869061e0d
x-ms-traffictypediagnostic: BY5PR04MB7010:
x-microsoft-antispam-prvs: <BY5PR04MB7010B18F7AB76555B0EAB273FC0C0@BY5PR04MB7010.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qfo7zWgY7Nrg0W0eS5RMVw47ZgaYvExKtpSA6ew5Q+VmfvcwngMN2T9WCpdtVWV/u5mEdzjrvmk3PwEK0vKNXggvzDhXELhtlyvWwaV23W802DkLr4SrjstcgbCDmHQ3CUkQ5qJjeM+OqYA+qU+23J8Upsm04pdipSzwaVjtP/P2tLiUzce4o5AfJvRkoZRiQhTdod/xSKcUz5kTuj0rTA8OI6OC4P8eAf9EaWI2wXVfSFf+0/UNKgrt9uxOc5mN7Nut83SrOeHVt94URnbQY7Dq630UMdviduDcKODKDjiFwSuCIU6H/1HhSGg3uLPJ1FOuu3Bb2bCpUYuE6kI2/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(2906002)(8676002)(55016002)(33656002)(4744005)(186003)(110136005)(71200400001)(478600001)(26005)(54906003)(86362001)(7696005)(4326008)(52536014)(5660300002)(8936002)(9686003)(76116006)(316002)(66946007)(6506007)(66476007)(66556008)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1u/8Clzq0cJRfw5xRYXxHS2cqIdXqgU8FA/OYH8TyqcIs3V/zQu/z3ub8FOyRcm3xDZpvPTsEX5HfD5aPeyB3vaNtQZAxsLv72KkxLblslTWuGx3JhxMAoBncA7n0sdCU+A83vV8pC2fgyDSP3B4gVVu5Oa6ODN2Job1mrzOJ/uF3+g+dwXZrW1ynd4CjaGd2RFB9H15AnlAYPoDCLLH96H/YUuyR1AaGhI/wMYsj9kksTokvNo6qX0i2CghxhjVHKQie/M7hY2qXR1MeqRGPRWZ9kyFAUYOp43SDhsNHUcC/UYddWNJLd2QJrwEmppU+AtJ4PVNhx+f6XJqG2S5acudxfKCHI7YT7//bh7P1aePHHIYpalBdTmkKKvBmkUwL/PxXGk8FjTGnrIXxnuFexG4W+j6wBqVZ0/4xexZENdTWJgiJBgq4yQWpSye8TOFB+wdgt8dH3rpaBFbzJdWYFfb1MUIpSxy9w3iroCMcxRhL8Wq0P72KVRDI5etFv+Ou4TptwIZeIunCX0JeEXdiI2cqDc6CncrXKvsRmJfgk99ZfuCfsdsheKhF2J0ARD3sfbsMBLx9+2BlppTadO8/9xZxlEQLXMC1JtJx3z8rEXfEX9vbJZ4VaNuaFdArJP0ECgVvCDM4tu4jBA+iIrOyA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f31486-37a1-49eb-8fef-08d869061e0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 08:10:26.7034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ThjCj8S7pq9fQfvZMJ53JfKMO8Lp+Rv/6IqcXi5YIBGSWZlua+xeGs9vdEeV3NBjXj/AD6A5yri0o+Bykg1J8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7010
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> The UFS specification says to set the IMMED (immediate) flag for the
> Start/Stop Unit command when entering DeepSleep. However some UFS
> devices object to that. Workaround that by retrying without IMMED.
> Whichever possibility works, the result is recorded for the next
> time.

As aforesaid, this patch might not be needed once IMMED is set to 0.
However, Any spec violation should come in a form of a quirk.
The driver is not supposed to figure out the peculiarities of each vendor.

Thanks
Avri
