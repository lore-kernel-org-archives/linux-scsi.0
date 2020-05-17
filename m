Return-Path: <SRS0=qdST=67=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C413C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 06:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA2B206D5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 May 2020 06:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PpjDoYeP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OOVCxjsx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgEQGMn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 02:12:43 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:9878 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgEQGMm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2020 02:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589695962; x=1621231962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dZ7xDRy+NDRy9VrDiWRcAask7gO6JXYBEm3+7xuYEVc=;
  b=PpjDoYePznsk6JMN5CgxXt8MB2rJbOwaBWmIrMegH8pwvM3vSgrWRkD6
   s7sJ/iWUjDjyrq/hX+oiMDlzz3RMgyys46bX3yLgPLtGdjhqTWLBxqv+q
   0efTqxPK0yr4+cC6gnlvmkjS+wvu5vwKjZLpoclk7V/mHqV7phKekvd0b
   mJVDgWaxlV3jStAKoec6GnK1xr+MLVFsrckrqazgFzp3n7VCLQ2OgitTN
   FZYSd8rnpjDG9gbC+RICa0H7YayH7G2U8FFYWStH+BpBI4mr6YnJW1waR
   iL7KpR+MLlnsEoyLaqGqEvU/+iCI10fH6Yg9Qadibnj+/TF0dYLJBTAjh
   g==;
IronPort-SDR: YPIGDOFbQR4wwZU2/37k7OUjuS7kvB9oQZcuKIYDBkzZYWYmJxivtklO03oPN9XD4zU+Fgfbud
 vhktaLO/UjgrgoM9EbeSPs3gzJRYF2PZ1m+olu9SyOzMu6d/2re+g4lk7m4DTgpf94bCUPfacm
 QGDHue5+R56rfezUbAe9ln0ZHhmQFFHtIB++ZlYsOqKFJ2D+/QaNSkC8ZeiVDR6wwnEpP4/pH+
 FUPp8CLEXhAH04f0mrDiNwLx3LwkN+xMN6H7zlXzSKp4dYAWU6NJKiE12us2qgqY7w3wg8WSDW
 sUQ=
X-IronPort-AV: E=Sophos;i="5.73,402,1583164800"; 
   d="scan'208";a="139303402"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 17 May 2020 14:12:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU+DACGenf8zDVztRNkEBoZqM3w0h9oiirDThHt8Gl9yGbLA1E1VIuCh08CNnHhkiwAbidReF31HPf6PfBHSZoNRNhHKsr6lm2zooQbESVsW1YTqt9dMHxGBu2b97/2nGHQQZybAxyNVRDyjHnZjbYt8bqEQPU1TKQcm5Dk0X9mC+s+LPnPR8D074weT/iIg4gMefL+TUMDT3uyQYNPldCMXlp3oXj9B6nYmxnoFOkLHFqaX+ECQUJ/oH4rcLqWz7+IWqbvlootnHulQw7PpPBfLmDS/h2/FhAKjDcAOmjBn3KXJ302gZ4UbNq8+720EPs+cAOq4qKs/Ym7SiSU9Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ7xDRy+NDRy9VrDiWRcAask7gO6JXYBEm3+7xuYEVc=;
 b=AmDbA3OmkTrDBtvall6pKBQxU5mjKJrOFVFYVtmjSeRqapgQA3oSXvTnaGOo4ob/bOAEOWE4DyGaLtBt3q7qSjRi1ltlEJv2C3m3dexd/H8mEIW/9r5kIQSXe8qsrEp4BA3afeKrwAmAO74vKeGCMMOW1IthDtp+reNSIwaBoC0i/b69yY7CJsd5REAI6yRr3HPfT+Ux0WHrnov8207ZJMginrgXQGO/V8U6+6H6tYnFqHJ11JQUB/fJ2fS+gR3ptlIOLn254IhP6df1EgQcpf1Mve50Yt/XaLueLwUE5UoA2L1Gtsxi09Krm3ZEl4VQQXCu1eoRpOXHVMpnC3o0xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ7xDRy+NDRy9VrDiWRcAask7gO6JXYBEm3+7xuYEVc=;
 b=OOVCxjsxRcBwZv8M0iwsywg6RT0uMcsMwhuonJMfsHIuOwTrgHWDHFOLXSX1yc0pqBHyXFGlBN30yjHyWje4WG6vSsWaVB04sSNf6sdFwTw2dOwvwH6ztBmGb/MvBCUf+kBJRtcmewrYwJJGFTXa7dX4XBLraW9y0g/gIOHsD30=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4351.namprd04.prod.outlook.com (2603:10b6:805:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Sun, 17 May
 2020 06:12:37 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3000.022; Sun, 17 May 2020
 06:12:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
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
Subject: RE: [PATCH v3 2/5] scsi: ufs: Allow WriteBooster on UFS 2.2 devices
Thread-Topic: [PATCH v3 2/5] scsi: ufs: Allow WriteBooster on UFS 2.2 devices
Thread-Index: AQHWK6nuV0cbBolOlkSPSPwHxTr6fKirzNTA
Date:   Sun, 17 May 2020 06:12:37 +0000
Message-ID: <SN6PR04MB464093981353EEF1A5F6E3B1FCBB0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200516174615.15445-1-stanley.chu@mediatek.com>
 <20200516174615.15445-3-stanley.chu@mediatek.com>
In-Reply-To: <20200516174615.15445-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b3e97a7-2bc0-4261-a018-08d7fa294c70
x-ms-traffictypediagnostic: SN6PR04MB4351:
x-microsoft-antispam-prvs: <SN6PR04MB4351DDFA4CC02077DE660296FCBB0@SN6PR04MB4351.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 040655413E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbDd9VfwYeAW8MvJkNwp5EYWFV+/3QvIiLbzN6p5COKnPRnj+JGOkmWiQi3amcapBaG8Hd1mzf2cX7J2wf/rLMivFhHGnv3vN67aFmShoJBeWdSGFMR84rH4kPwbhFJThDnfYbiR7ysjSO0bJWOpoHqwPvjgBLjW0UsQvVwUGmhd3Yd+XHUISlIfmUldaxeJ/Bqx4YKlshkR1uDL7r3uY0O/QKGN6JM2NZhSe73AfUY29EE/Ji/R5kyj2g+rv2Aom5V7jH0iCUgUc2CDbOLxWhUYJilOzKnBv6+GN9VjJVfjfksnpgphqhwMLB5B/eCaPZJ/k2Lx6rk756qy7NkuPZY0He/TbIvaDgh223M446/6AAQSjXDyFABO6ibGrNa/5adpYCozG1zuWXe5ywABsc+Op2Ug9MiAl3OZWi+NxtIIIjBzk5J3H1bU3/DnyNTt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39850400004)(366004)(396003)(136003)(346002)(2906002)(6506007)(33656002)(52536014)(55016002)(54906003)(71200400001)(7416002)(9686003)(4326008)(86362001)(7696005)(26005)(110136005)(186003)(4744005)(8676002)(316002)(5660300002)(66946007)(66476007)(478600001)(64756008)(8936002)(66556008)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0OwEKp35sr+eShAE3NeqRq64oSQPQlNOGDll/r6VWK56c8HnxbgHTR19zDP/52NWl6jRP3V37aCuXFuuCROGiwgfeTONgiNRnD9b7ORs3olPAZL2GAeL67w8QbwNdSjONbkhggKSNRsCKjXsi/pZRWg9lrEJtDS5uPpBgBNsbAAOL+tLeBTxXylDo1V2PtXr5U0MDZV7soMJPQQpjb+X0A+ZNpIRxqcGi9+gk8MfECDSdKDf7MJp+/HNxE27of1b2j4Re7Sb4g0kAkawvkczsY2r+1maL8/2SsovR179eTONBqAQqbE04lwKx2hhahrAmeiaS/YsSzOJSofGh6pLN+isVUXv/7g8JkG965tc+7IKEoaA259PQ1ZNG7AYCNc3x2lXyrufkCgf8QRdH9F96y2hzKYfkWNT/AsgUPNDtt1ybp8UE5VidiJ7396vvjKpPJHolfnEj/O4ZK+bcCYNHOssBn989G5m4dVgBnzIEc0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3e97a7-2bc0-4261-a018-08d7fa294c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2020 06:12:37.7977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9zH/svPbWPht0NNHSwCZC4EqfIpbcMRD8tUnDWQsNMJQ2D19xC+6cKRVrsFauekty7m/Hnw5yFYWjTJmiGEdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4351
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> According to the UFS specification, WriteBooster is officially
> supported by UFS 2.2.
>=20
> Since UFS 2.2 specification has been finalized in JEDEC and
> such devices have also showed up in the market, modify the
> checking rule for ufshcd_wb_probe() to allow these devices to enable
> WriteBooster.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
