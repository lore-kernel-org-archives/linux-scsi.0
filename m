Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D6FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8835A64E2E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhBBLYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:24:19 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41364 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhBBLXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:23:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612265019; x=1643801019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4DukFa4m/vR1pCvQt+igc3m0mfOhHZn55IU4qX+B3X4=;
  b=bi/cw3WkRTehFVuiSpMTRG+Bjv6v4eEJ28AMbqw29ntogPx0nU5BMMTD
   vOAGroq38wJrC+e3dVLRkhI+APY4ElBwsmiAlLg+LxnGyHqWuZUF0LWeO
   ubwtGpBRsGUtuBbzvJV8W401lw9TAI8yaPGJapt7lOZ+nzzZ9rn5/YAOw
   7c1i3rmS2JhznS0WHoaqng84y22MGyhcul106AGEz+9FujiBysq9C7SGM
   A13L4b+hVzv2/x6n3JjEYceQy8Zl5mn/WTTFPfTXe4bPvbJlNEZV+XrfT
   Gc3y/1o+JTUT7oEo3W0/1myemotie8ek+/IqbbEqDf7+YAd6xJnNpZRYE
   w==;
IronPort-SDR: S3pzDHYJhCymGynkOl66t4npkj4eLeB98YyjbphwLxZkvmm9zVEGnMGGjxO9tT4HqJBC5pG+vJ
 Vv391s7OmQyrSYl4xVst7wC/20em5MXgcRilYFQLfY4hiOxFbGAbaQ9x8GCRgant0tRS7OlAU9
 32EC44spHUQk5tMohnA/5eHQrwr4AerRhzB09ClhN6vOJsrto7iYrj5nl7CNGDwEzFvw2aw7wa
 XTG/435GGZxE2cjMOtGwlUqbIOfF0eduVwZA8VHLb1iRfjG3jvsBJouQySaAiuH7PcErcjJ+Bp
 y8U=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="269330163"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:22:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvg6NmA1qCfsjAUQX/TctkFutCFRcIx/OCDZ56yih/ozGhJS2xaPmNQP2fQI7SpWTZG+tFjScKikh4BHRhEGYgXz+2LGS5kSSi6JderYgHQmJTKrjQkLpMaSiprWACdSj3wpu6ih0Dt3m62OIQYPhWc3bZx6g4PO9otAZGOAWLrsDDGo7fA9pd89GAIaDutpD79+D1kBsjv4yoM/y9PcZn2fKXdD18EMkuWh2mP6l39OwoVSEqkwIfvj9bVqFZiigiUj0ws9ovRzyA5tBmWI9PL/nGElnHUuNDRjPafYGrKg3WiGRl+26Tw4Zf3GZg2IUU2DhV006HzNLm+0uh/kNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DukFa4m/vR1pCvQt+igc3m0mfOhHZn55IU4qX+B3X4=;
 b=h3kOsinGLS4eUEtTNv9KzE+gx2z/6u0knfpBLp4tJuidshZUkJQYzjsuGEn7nlcwww0bW7PSVMN3G3dgXJzzAS3/0Yl0MtEImEm1ut53efxQO4a54VCvQZg1Gv5E8tK7HXzckfN/rJ3bvBRmfVdpSWOl56mZJMs/6vopYJfC9N0mkeTO6o9/D3JGrBxjNyuXjqzLJ8w5wlEjJzhUdXIAVmgzRuLJ9CiVGijCeP7sKV/woyWm7vPTtNvMnaBqZ06kQsn2dpUu7k98tGrCPyzz4Yq0yrqg8UgIpFvkWu5H9UTn3MGfT7LgNRvNPDslXDolwSTGSe1Tr33o+00WB9CPeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DukFa4m/vR1pCvQt+igc3m0mfOhHZn55IU4qX+B3X4=;
 b=wJyuOuOi9ms/knRqCaAuZMN59+yNj1rp1ogo/ye2LkqMPgQTV/5l0Y5fCmeV85t2DizTXSw4csACQMUYAcV64Zf6OQ42TY89Gz6CMNCeJx5Plue8bbhpzIHwJJJ0G+rIo91XOM6Zf55v4H6E6miYZglGAzXRgrrwH8AoWu4NZL4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 11:22:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:22:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW+T24Unmd4UenDUy75lZ2X5mw2apEtz6AgAABg0A=
Date:   Tue, 2 Feb 2021 11:22:31 +0000
Message-ID: <DM6PR04MB657554648FE570429D02445FFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-4-avri.altman@wdc.com> <YBk0kaymYOrrBr8h@kroah.com>
In-Reply-To: <YBk0kaymYOrrBr8h@kroah.com>
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
x-ms-office365-filtering-correlation-id: a89ad187-c333-4d1e-96ce-08d8c76cd4f1
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB02668228D3EDBB1012F0A8F5FCB59@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vIyhOrIDWjv9Y0I2YnLw/cNjVINKUypGgaoUcoRk+Q1UlTvrUvYFr1nDigr+KGKp0jN9OAy0bSGulOr+2xTNpHP+SL/AdU0K1XK2zO7D4Yx7tZ1Vd1KA5RguC+dXqCP0myFZXmN/9J6doNwtn+SUMpS1ZgQsgzLZ28cjlAJM/qJtVsew4dkGq+wSmqxzjJ1vmXavhmvwRcyR/3EvsjIcS/u38OcJXO+agZUMFzCAqyWHZhPlGlHS94904taqGUt6jKk6eLGwtUdrqVQje/ffC9F96OZrxo4nMJPriYJ53YvEh3/ci2ggL3nqR8sCE1Oddxy8bc/rZtXsV1/iJpDZnAUNbU/yI9X1xXGpg6pPaCdEqN7f/yMbJehkIKOY+rXEu34gC1olRNS75TWzXg+Rh9C4wrJmgniaP/u9scPKzX5apbiqtcTXZ+SFup/SI9zlMSitnO9xkt29FV8hUSwRI7047aAu5Nay8LW7QKO898j6AHaFPYQDbFI0nTeX53Rjg+Kjood2NVeI7++jvh/XNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(8676002)(4326008)(66446008)(6506007)(186003)(64756008)(66476007)(26005)(7416002)(33656002)(66556008)(8936002)(66946007)(7696005)(2906002)(54906003)(83380400001)(86362001)(55016002)(71200400001)(316002)(6916009)(9686003)(5660300002)(478600001)(76116006)(4744005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UkxtdDB0dTdUcjJMRGR2Z0l3M28wSEpJVldDZjl3NjhrK3gxSXpGVjJMZm1Z?=
 =?utf-8?B?cThXdzRZTkV1NWgvYVdXSnBMVHI4U2tvc2czTmxycjByNy90S1lYMVV0VXkr?=
 =?utf-8?B?NVJJYzRvU1h2Q2VaL3MxcG84bG1tSXByZUlXNnk0ZGVPcE5FT283Zk5RQ2tE?=
 =?utf-8?B?bmhCakk0bUJpMzRyUkM0bEpwZnJOdWsrMGZkQzA2UjUzVGdTbGdBWGJKeUpN?=
 =?utf-8?B?bTFsSUFXN0pOVTRWQ1d1OVExTWVHR0NUSm82OXhaT2ZOVzI2WE00cjc1TVZy?=
 =?utf-8?B?cEUvWERISnJ5ZWF6RE9jUTRlNkNDRTB4TmZFZmovdVVBVVoySFpNWmVyVnRh?=
 =?utf-8?B?anVZNTZWeDdqa2o3Q2p3bjZETzV1NlJFSFpPcFdPcEE3U1B1ZS9ENjV5QzNl?=
 =?utf-8?B?Yi9rMGxndjFDNUlRUXFTY0NzMFd0OGZhejFBK0xSeFQzRitsU01TeUVrcDJ4?=
 =?utf-8?B?MkZvN1pKS3R6U2o0d0UrZk04RytwUEMzQ2x0c3dFNzFOK1JsVVA5ejlDMnhC?=
 =?utf-8?B?amZIa09pd2VYOTRvT1lTUDRacFJpdjd5OXBpaVh3a0c5SVVpWG93dmRtYXpV?=
 =?utf-8?B?M1kzWmFXdE1BTEE1YURpU2ZNUkFrbHZKQ2g3ZTZleUtHMlNRUnBXU0h3OS9l?=
 =?utf-8?B?eEpPdEorYzQ4MEpVcFo2WG4xa2tMWnlLdzQ0WEZ3U3cvanVCRk03anh0azFW?=
 =?utf-8?B?WHNERFR2YklFd1NJUndIN1RjWDBFQW9YaWJHa005N2ladmQ4TkE3NlV4WnNW?=
 =?utf-8?B?UmFJUWl0ZjNGNWVFd254WGhXVzFrVWpiOVI5SUprd0lVMi9YNGRBRUo3Mys3?=
 =?utf-8?B?MkpEVjl4VlgwNG1KQXlXcjllbWg4VHpxeVdJWTRLTnMramgzVitMTXJoRVVP?=
 =?utf-8?B?MTh3MEpCUnF3SDRHbTdDK2NmN2ZNZkVPTzRNU0FEbk5oYk5RT2MxNHpLR2tS?=
 =?utf-8?B?eVkwbjRXUHVwTjFoWTB1bXYwVnlvVC9qWW1GTngvdHRDL1RhakFxQ1NPS3pH?=
 =?utf-8?B?TlpkQWQ2d0lBTmJCL092dHZXZDNJbGhnSXNYa0VjdWE5TWxqbGZ0NzdEOHpQ?=
 =?utf-8?B?dDhISXFueHRnREFzTVZqU0l1YkJCNktWZlJjOFRxT0ttcm1wWTBnbFZhdlBX?=
 =?utf-8?B?bE1QcEhKNndVV1hvKzlIYjhHeTFwbzBXTWgzU0VlMG9aMm5VaDQ3N29uQlNq?=
 =?utf-8?B?U3lRbnFsMko3cklJdDZrZERUZXIxUVJIMEIwNUNyUWF5YTZMT3FlZlV5bmt4?=
 =?utf-8?B?TWZ6R0M2bWFjZm5xTlVyUkFFd0N2TXJaRGVPcm10ZVFzRFBvcDRqOU1KNjcr?=
 =?utf-8?B?VzFqV2RxSFdtMGpZMVNaZVo4Y2dscTBqR3h4QVFoSjRCWlhmYzl3dFpQWEtQ?=
 =?utf-8?B?Z0xyTW8xR0pJeU1sQytzcmo3VytIU01maGdBbnpHYXFxMTJ3N1JFcTgrSXAr?=
 =?utf-8?Q?4QoISG6u?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89ad187-c333-4d1e-96ce-08d8c76cd4f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:22:31.4788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N4nacQGI62nu7N7qwPvy2hdoxsupNl+k0pu3b+5vIv9IsXOhGQEDsGcWzLtlSgFmZYrR9bmU02y+/9+HGrMK5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gKyNkZWZpbmUgV09SS19QRU5ESU5HIDANCj4gDQo+IFRoaXMgc2hvdWxkIGJlIG5l
eHQgdG8gdGhlIHZhcmlhYmxlIHlvdSBkZWZpbmUgdGhhdCB1c2VzIHRoaXMsIHJpZ2h0Pw0KPiBP
dGhlcndpc2Ugd2Ugd291bGQgdGhpbmsgdGhpcyBpcyBhIHZhbGlkIHZhbHVlLCB3aGVuIGluIHJl
YWxpdHkgaXQgaXMNCj4gdGhlIGJpdCBudW1iZXIsIGNvcnJlY3Q/DQpEb25lLg0KDQo+IA0KPiA+
ICsjZGVmaW5lIEFDVElWQVRJT05fVEhSU0hMRCA0IC8qIDQgSU9zICovDQo+IA0KPiBZb3UgY2Fu
IHNwZWxsIHRoaW5ncyBvdXQgIkFDVElWQVRJT05fVEhSRVNIT0xEIiA6KQ0KRG9uZS4NCg0K
