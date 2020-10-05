Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C07DC4363D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4136A206CB
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 11:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CmPxaEoc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aEVwrFXx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJELOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:14:36 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8423 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgJELOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 07:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601896476; x=1633432476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ag2lpnppfLokmwt8X/zB/8djnrJd0cVu/qCcNBPp0+0=;
  b=CmPxaEochc3gcEqXowPZZkJD22rSTPAabuitY7pIDjzQdz7W2SA3ihgt
   iatk34FkAOE9urj6a09Rs4VcuOiqs12e6odxgXRU0lUU1cudexbjc+F6p
   7+RSlfM03My8l2zTrCFy9EcNWAvRmaKmOnkT2+LBmrGZfk9DMdzog9ap6
   RRlwwiSP3vvfcn5e5koUoxbft9/OdIyqamBTKEmUlb9M6fluuxRs/w4Ki
   7YeKFjoT11Yycu57Je4gQYNyk8kRa4h3Q/lMsXy4Bqwunc90nm2Ea+FXc
   e1SmEXjTupcZVsWqTf14XgvtNvlmHXzCrYhEPqLkqie+vRtvoMrtRfR70
   w==;
IronPort-SDR: oRepP9bBM7oh07jBG685BlhVlvomgXuH3z54aV/Yuk2hbqxwnURhO+sWHo0P2FbDUImgGA0P4Q
 CE2gsXFmM6sPiZDzS3N1NOlWX0np9jght3aJDIFMlxQisS61RryKS75XGOPEqEGcdBlSvdVW+N
 TQOunXPQ/73Ocdf6gRzXsW2/dyoTkvxHVV67R9vAXPJVZAqGnashQ4AHJgcU7UEkPNAfsT2dOv
 Cko1rlCiKt69PsYfXHdZLs8Tj/E8jNmhy3ptuAFB2CDdzo0tg8RvyZyPaAJo1DOUZ1kderXMc/
 mOw=
X-IronPort-AV: E=Sophos;i="5.77,338,1596470400"; 
   d="scan'208";a="149125915"
Received: from mail-sn1nam02lp2057.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2020 19:14:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnTMUhsssu808eYh+e8sWrgLfnyXMq2sNn90B7xSalgLX9gWbW8Iz5jB7vZF05nkRz3qNyENH0fvzBGBKf4CnS+9VszFR7O2ZzdHM61qhfRRuQurLVhJiCsVqTAOxp957eYWfIBet8RpNyf43HTmpqx4vCDMqqzmuw13GH6y9B33+kUYRsVyNC92DAJh6foBSVX/5/nlvThmtIwdxNAKqwZjMNNyPBCc+PI/K1doPtocmu4OCJwcHUNcRUtTJ+IP2r9eKJ9Aa1NtrR5frm7T9ojPtGpvsc7foQcBwBnC75KP3Uposws8OxAOEoIFjE15dI2+lR9hYUslXECCYL84Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag2lpnppfLokmwt8X/zB/8djnrJd0cVu/qCcNBPp0+0=;
 b=Ds3q12w8f1oqeH4z5pkxi8waEJLYYaDNQO8wK5E5NxSLrGuXeJdQYtBzLUSkfQD437E81PLpzxziZ5qEmTrKcgBD09O9HonJ/IX5BHU7Y+1xo1Ehmm8fYIzsmxCHMzAxFeAObwWHXJU3yvIeK2g/AaBs0v1dnpiZnNeR7zk5a0yhqFNG9IpaUHKpw5Rgx+lPGqYktkgcaWNxc1WgN2Y2VADka6ci6gqnftI/uwLM0zNdz1ERa4O8lRT7tgX6QaYHCahRByahTSBmK+jFWPk2CPoXm7yW+NBSekBcPxfUx11WT0XckW8Xww06XDtkcWPy4NKYgeSoLYjOrdRBLMBODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag2lpnppfLokmwt8X/zB/8djnrJd0cVu/qCcNBPp0+0=;
 b=aEVwrFXxvNJeK4F5zcGP66t5RXQyX/DeGDsEXr2iI11eKpEQv5XwrDCQ0ycdlzbVU35ZPLbkrMlNenURJo3zB+rEa6TKHr7fu46emCuOnykpYdg/B/GOMwb6DbcH2FQDJMr8YlEi/qI2tBxCUpVnwXsWp6xMi/pAh7i3hSIPJCM=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6660.namprd04.prod.outlook.com (2603:10b6:a03:22f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Mon, 5 Oct
 2020 11:14:32 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 11:14:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Topic: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Index: AQHWmLlX/36ef3l9WEy26/6zpaIUz6mIpxKwgAAOnICAABKTMIAAFYIAgAAB8ZA=
Date:   Mon, 5 Oct 2020 11:14:31 +0000
Message-ID: <BY5PR04MB67052E848BB5D7327454FEC2FC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com>
 <BY5PR04MB67054C67CCA53AB5FC5CBCFAFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
 <a3cd3d32-0dcf-ebaf-d6fe-e8f21539dff1@intel.com>
 <BY5PR04MB6705E5FFEDED858772890DDBFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
 <af91f0a5-1378-cbf4-b1d8-097b2d94decf@intel.com>
In-Reply-To: <af91f0a5-1378-cbf4-b1d8-097b2d94decf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 597ebf4a-1c00-4112-2238-08d8691fd59e
x-ms-traffictypediagnostic: BY5PR04MB6660:
x-microsoft-antispam-prvs: <BY5PR04MB6660DF4A2F0018FE7C9BA76DFC0C0@BY5PR04MB6660.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ziYFhQYwzGLF/FmmKbckgJL6e9ERGzTe+bLaUp8NM5/9QMhtUEdspkjUjDw9GLk+aRTft60TMKMFcKSlaJHZUrMUVSWNO9Ji2DxjEV+EGqxCKlEJ76oTxDcgb1YlHrdbfUXDZBO6WxaRZvo0uSiUuGQ1+U6UGC4wwQjLbaCIaO+Gb3+AvKcHWLLfAJWHCwKBLaNMW6TMExE6VeLFcbmAFjF5RzRgUOzTve8/1412Pof4PohIORNN7WwXQrpGZoQ3RADLObqnilmoZDm2B4Jez0HWCmt+YP1Mwh/0+W0vby29Tp29eSGMxFzeJFFnDeO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(86362001)(6506007)(55016002)(53546011)(83380400001)(8676002)(76116006)(4326008)(52536014)(7696005)(110136005)(316002)(66946007)(478600001)(64756008)(66556008)(66446008)(33656002)(54906003)(66476007)(5660300002)(71200400001)(186003)(26005)(2906002)(9686003)(8936002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: f5UtecSayilnrMgDNqMU0TXN6SdM/4mobuZ0S+BaLvgwteNgp2c0Mx9/Vo214hMGXHIwieLac9z4pIpCxmcdg4lPtTVRtMMnMXXC3K9UatPMlpoKcKRzWKZE8oQZcjDP0UzlZ32Oyk/XbBi9BElotKLH6jN7LckK0tRJTIoi+K7bc0ldrlff8oAEt2iydMfPmoIicXEzZGnlh9bkG6WWeWBr9eqa02hANMN+o75AlQGpyyyTHWoZsvjcRy7EpS3xxElmGgnFPtsx6kg4gFCgJMAdNgDct2jgNX5GhD2uUwIBFSm/O0e4r2jMX+opjRw5Q0TmtDmkwypLxNd8GxgcxwZZ4draFkAp5xGtLRo6P1ZM5ZCOhmrHjlrtpnPN7M3D5eprgABc/QeaECnwGn/9pNB8sHhhgURdk8g07xl9UVLUwvxE/7drrEGJo5mTgRXFSTPO8ddykyu6R0cbAkEQbQmRrs4gubwnyVMmhp4TPkmTcEdDmHo2fLCen+9eKu0uDrg4HMhKjHsFoumxx2njRfMPqGEfnSITSNHGAc1mztkF+ZrB6X+Pl2aineR0gcFXVKzKEHDuHUuSCwdvs0MNSIj1uEf5Klk0tqupx+22aXeTMbC3ctlZ+jwV8ZqLiFeZSJFabJ2FDYhKE6pvAhSa9g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597ebf4a-1c00-4112-2238-08d8691fd59e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2020 11:14:32.0214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6UfWLEi1G4W7XzcZJCChqvE/RvYwhMiy/1z4EHm6CpSypm8YHbSotJbAZ/azwQxsB0Le3ZheHptRSNd8bjz2CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6660
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gNS8xMC8yMCAxMjo1MSBwbSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+DQo+ID4+
DQo+ID4+IE9uIDUvMTAvMjAgMTE6MDIgYW0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+Pj4gSEks
DQo+ID4+Pg0KPiA+Pj4+IERyaXZlcnMgdGhhdCB3aXNoIHRvIHN1cHBvcnQgRGVlcFNsZWVwIG5l
ZWQgdG8gc2V0IGEgbmV3IGNhcGFiaWxpdHkgZmxhZw0KPiA+Pj4+IFVGU0hDRF9DQVBfREVFUFNM
RUVQIGFuZCBwcm92aWRlIGEgaGFyZHdhcmUgcmVzZXQgdmlhIHRoZSBleGlzdGluZw0KPiA+Pj4+
ICAtPmRldmljZV9yZXNldCgpIGNhbGxiYWNrLg0KPiA+Pj4gSSB3b3VsZCBleHBlY3QgdGhhdCB0
aGlzIGNhcGFiaWxpdHkgY29udHJvbHMgc2VuZGluZyBTU1UgNCwgYnV0IGl0IG9ubHkNCj4gY29u
dHJvbHMNCj4gPj4gdGhlIHN5c2ZzIGVudHJ5Pw0KPiA+Pg0KPiA+PiBUaGUgc3lzZnMgZW50cnkg
aXMgdGhlIG9ubHkgd2F5IHRvIHJlcXVlc3QgRGVlcFNsZWVwLg0KPiA+IFNvbWUgY2hpcHNldCB2
ZW5kb3JzIHVzZSB0aGVpciBvd24gbW9kdWxlcywgb3IgZXZlbiB0aGUgZGV2aWNlIHRyZWUNCj4g
PiB0byBzZXQgdGhlaXIgZGVmYXVsdCBycG1fbHZsIC8gc3BtX2x2bC4NCj4gDQo+IEkgd291bGQg
bm90IGV4cGVjdCB0aGVtIHRvIHNldCBpdCB3cm9uZ2x5IGJ1dCB3aGF0IGFyZSB5b3Ugc3VnZ2Vz
dGluZz8NClJpZ2h0LiBMZXQncyBsZWF2ZSBpdCBhcyBpdCBpcy4NCg0KVGhhbmtzLA0KQXZyaQ0K
DQo=
