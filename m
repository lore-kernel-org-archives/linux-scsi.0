Return-Path: <SRS0=cDh3=35=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28637C35250
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 07:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8869207FF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 07:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qEmpm6xb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TKhhl2bK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgBIHDL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Feb 2020 02:03:11 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36670 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgBIHDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2020 02:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581231798; x=1612767798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
  b=qEmpm6xb20MveaoDpbVrMEN2tfru9SHWEZh2MaXostJLazOXp9eVuWJC
   T9FllZhDXjAM5R3W/TJNpWAy0ja1BdM5Fa0kAKs8TEYBHHRzjJ6KV5aC9
   QuzafMi0LBvtu2TWoPtxlH1CYDkkkGszh2L9SluU7dlR4OLxoTQa/CBmD
   AzHwlyK24iwPw8/HY5uKuohWrF9YvQnquBCRbgIpCSWfzTwCskhDb1rYZ
   ibGCKA4/2DF0xJFgmk2WuiZrPWspdhUx94pPEj7X3TpVDgrz4khnBT08H
   Afx2dgMbStjL1YnpaAzNK9pK4BZs1FNjRI23qNPlt+9W25ZtCtX50AeNp
   Q==;
IronPort-SDR: RXLsc7J++2wPMr2YZHkw4mvsTetXFMnnfWHRZ/27r+G7zatV5/kYOEACflmcMjhoXMJCr1CZVM
 m2CS3s8pf5UtJsnUcF9+tzrrk/OXSZ3nMxWc18ObE2jeuXHLBNziNailSNgLZJykIEWO8AmhAb
 Hq3kgreU+IHLfShuqCx/rqUUBW6d3y0jj7dEZn5fGVAb19lQDLvU8btabIs7TvrJjGCwb8EXTD
 fptYSHQk/z055t3fUifTfGKg0OGiBRBKW3CsRhUfKGPfpp0PVQaPEyAKpqVu3A89Khr4KWEqqD
 ryg=
X-IronPort-AV: E=Sophos;i="5.70,420,1574092800"; 
   d="scan'208";a="231218139"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2020 15:03:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAaRWxks2OaIGQXKR/wedYg6Z5tDaQ6YjYmqfuf6GGdJ4nazugAH1AxedS4DW74Nc+TQwyjG4sH3cLCr+r6k9Krxb66o0XQti5tkbS7t4rL3ujT1gq/T5Xe/dvfNx3VBXqo57PDxvN2W8e/+X8b5EDN6m5DLk6PEycSpMgCIWVwuGhgyl/HIwWXgWsqTZG2hcFiCNcVWqmJnvcmxxJxDm6GxyeECUyOYOx9k7rFfgOPubghrYx8hU9wbshH/mOR2FYGgiQURKdA/tnAOcpwd08RWklN3FpjSuqjooldoQXBwysWeu/8UCImQFKYktvuzJbrBnjRUNBMS7y7lrSG4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
 b=Jj1KljtQua4sUtkN8C2FzTsHSHJ5QgqTfo7PhDpm+XGJzsbfxSgqtfWGANLUTOvDqopIQql/zJSmTiuVrH5LzvRImajc2gH1XqLkxzht+bctwHs5LSyZiABpbBRQ7dBbZRCuNpaFQycWjxudHr3uB1iVCdIdq7deVzFE39breq6ge4Q06A5C6onX5Fprq1JJYvJjkQA+ofFhCABz/h9FwV467+DNrMT95XAHJ4ZWZz0nwIreHulcYEedI7dIIXJZiXaSB2j8gBuS9xXgMWFOeRYicN99lUPJqMRrVkrxCHkGwB9YEe2wlh0ZuyiTo8C7Y9nCbyaBgTEKU+kWA5jqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
 b=TKhhl2bKnMH8gTg18FhbkcbKdoC17iJsWgz9hjneUFFCq6nKb8/rZgp0pOrQtgJyJAxcQKH0ywv2xTY4uK+UPdJ41njctipWK/PEnrTw9Xtb3iDgghUU6rtI/2tTmV3e4GD79Lqt+pPlZx/4uRL4RQvQAr9M5g2RPOiHv1PTIik=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6349.namprd04.prod.outlook.com (52.132.171.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Sun, 9 Feb 2020 07:03:07 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.028; Sun, 9 Feb 2020
 07:03:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 2/2] scsi: ufs: introduce common function to disable
 host TX LCC
Thread-Topic: [PATCH v1 2/2] scsi: ufs: introduce common function to disable
 host TX LCC
Thread-Index: AQHV3YTLmKd3QNgd7UGc9fDV0CDqxagPn8Hw
Date:   Sun, 9 Feb 2020 07:03:06 +0000
Message-ID: <MN2PR04MB69913BDCACDF64CBDD3F4AE6FC1E0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
 <20200207070357.17169-3-stanley.chu@mediatek.com>
In-Reply-To: <20200207070357.17169-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5308471b-0d9b-43a7-6d6c-08d7ad2e1d8c
x-ms-traffictypediagnostic: MN2PR04MB6349:
x-microsoft-antispam-prvs: <MN2PR04MB63493A6D34E847EFC96162BEFC1E0@MN2PR04MB6349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(189003)(199004)(8936002)(9686003)(86362001)(55016002)(110136005)(52536014)(5660300002)(7416002)(66446008)(54906003)(64756008)(66556008)(81156014)(81166006)(558084003)(316002)(76116006)(66476007)(66946007)(8676002)(26005)(6506007)(7696005)(33656002)(71200400001)(478600001)(4326008)(186003)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6349;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m00NrtPdm8u6LBEuawRFWIR5U/neik2w2C62zjRfjDSuzeUYcy62WECSUR4qNMyeqISjI21dIpsltvRXh5Vj7TAcTrXTY2eDoYVhGxF8aIuroJFmN1xXatUdGLjy9d/i5LJuEnyaL5nL+4XHF5i9l2kocSYqE8DUoTRpG5QD0qVhEwfQIq31VJ4b/poure7MKPzIcLW+87Rt5OY7MM0OW1l8Rt17Z2WaMajizQv2VQtsQGhOcm/5VdskEVAw5e0lER8SEeKABF2iISRFLHy+ZkLYAq6TtDmYWHkj+njeiwcAOMJtsi6pQvd9oE4UyqWl+rsrQ9p5s5iYgUUEg2aKMGVlnFqzv4jFkLxujrIvVO8yJl8teH2JYAvGm5/LZtXCOs6GYFnrd+PxeKhQemDwPJYzqRJHS9RyiZ61OqP4ABZDLaFNiDgbHKKUfTALF76o
x-ms-exchange-antispam-messagedata: x4iPWdfdU5k9QrJTRWgutVPFN7yTIP5gHxoP4BldCVyQr0THtAespmn+wq6w3dauPKGu4MMeTpHUb1/r4lFXZEFxbWFGmFC852BPSGtKHHGIuexgwmykEkRSGbQYAEeXNPV32+fm7UV8KnPg63eqEg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5308471b-0d9b-43a7-6d6c-08d7ad2e1d8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2020 07:03:07.0922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DueVSj3cS7IVPWf7wLDjCtzLzRHHLluHwDXOee0qj+YbBM0jJ8dqkHjpqnJEtUK4x7ytOhpyCZatvt/Ntp9RKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6349
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Many vendors would like to disable host TX LCC during initialization
> flow. Introduce a common function for all users to make drivers easier to
> read and maintained. This patch does not change any functionality.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
