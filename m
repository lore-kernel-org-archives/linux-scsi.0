Return-Path: <SRS0=2nUe=ID=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70994C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 20:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFE365081
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 20:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCEUqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 15:46:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:3111 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCEUpf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 15:45:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614977135; x=1646513135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eE/bBaEwWTcMACXI22pD0G8g+PbIt8chw/U7BVSgwj0=;
  b=Yis4j9+xFTIVGecvCpPdoLb27wX3lppLl7CivdaO/p1CeSDQhkWFimav
   LgPSusEHlVL/XMoCwcv8SKzGKriQ6w8+DUEf+lQuj9yzU/OOefB72diNl
   EIOAic4e+YvWdnQVQL6KeQB0s9YpTJmPfk85wxWgO/skNB6iMAU+kxJ2C
   vaRSAJZ7GZhtyLDmGHQ92vDV0ROPCWe72UBVh/fYh5+f14PESTHGTgTzU
   O9GO+3bqKK2Cw3QVFsDC1RY4lDjaM65TND+21RLM3XInhyHEndozsULV2
   DQXT/4QaZm94ID2zIqGzThLabZK8QXwpBgEAjmJ//O/vbRBRvcsZDkr8s
   A==;
IronPort-SDR: i5Av7fjGda0r2RboiDvQYGhfKdcUuKSaWHPzOXSMsLzJvZtndM/DCaE74I76ak9k8rK0M//RZs
 kmFJ0ewlv+6an058hm9PSSG5D0cbghPUYJvVcj1OeGPiU5CfLkSr4i9GgaV9mcCPg4umYZNp/m
 bIzi5LhkCA4bizmP+00+m9D2QP11Zy+NEHPbUmsuYZmU2BsGBy1kAxSUM890YoQzwOHE4p1U1N
 exJCkojJoVr2/RaUW5msmbrK/ppcNRNypIzXkOuvPrtFxzvKposhh7IBsGEKrH8jzP/XGo9AQD
 eDk=
X-IronPort-AV: E=Sophos;i="5.81,226,1610434800"; 
   d="scan'208";a="46467953"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Mar 2021 13:45:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 5 Mar 2021 13:45:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Fri, 5 Mar 2021 13:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvD7YkWiKGXJdHTAybFO/e5uwNTZNdk5aTL7wkYI7ASZnN33p5muWTWZgZieEUYQA1RYvSQWF2vwQQ10Ri63077XNAYNm3mhiaaAoJ70mqMy6IxkiRn4t0W/LVBMYUQ0L/3NGMkh+nf3JIQqaKQRo5C8EbQqBO9uPktlWFTuHSYWS9W31+r+zoDx+LS321N9TXVMTJmxYsguEaYYMPCpH6rNXc2XvM6SKNNau6F6XPu7F1qWnK2SUj53OpahlVnPdX1jzb/TvB6467bOs1mYw/cziKNCjeVkLHZiYe3ZDi0HzQTzAqNIqlkue66seBIxihvhIBXu+G5srHu5VublNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE/bBaEwWTcMACXI22pD0G8g+PbIt8chw/U7BVSgwj0=;
 b=Jl7Qg9BepCC9ueO8Mjdm6bOPrt81jEnRlBpfDayq1hX+ROio9jYD3mH2QK4/Gy975Sp4iALGKQycS7kLi34cgryiq+MemxO2B6aAGm220EANc3b061jUghBiwZM1hZYtb7RPNTHLaAwDNe5MSchKs3F8+wG8ErV0ngYAPf78wMJmeORYjFEvMifa3GaWecJuNRmJr/dZF9H5JuEUvK/2aOm6Q3/WdgQLd15cSvEwXT6KdbqczWuiGH4dP15KcF9TcKuDJh6smX+JmtpRGR2qTZn0r+UoeFqIb06y9hqJFySSlYdxPi7BkrYPE8Y3YIbMt05ZOzMHQLPWCCjxM/0E6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE/bBaEwWTcMACXI22pD0G8g+PbIt8chw/U7BVSgwj0=;
 b=W+/olUNifZruESYWgr+ebXU4tu6I0pPOtkTKPhi8VsaKJMQyp2N6taqVZqwBvAvYvvP8tiRbESPhCmb+uffuDM8LkDhcn2t4hXNhehWgZ5hltfqe6UKDeVFfBVAj2/WEuH8p3IwgwHU0dKDniBK3t7eHB6YsVU1j7CqgGwLdAfo=
Received: from BYAPR11MB2837.namprd11.prod.outlook.com (2603:10b6:a02:c6::17)
 by BYAPR11MB3815.namprd11.prod.outlook.com (2603:10b6:a03:fa::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 5 Mar
 2021 20:45:29 +0000
Received: from BYAPR11MB2837.namprd11.prod.outlook.com
 ([fe80::5480:4244:dea1:8108]) by BYAPR11MB2837.namprd11.prod.outlook.com
 ([fe80::5480:4244:dea1:8108%4]) with mapi id 15.20.3890.035; Fri, 5 Mar 2021
 20:45:28 +0000
From:   <Don.Brace@microchip.com>
To:     <arnd@kernel.org>, <geert@linux-m68k.org>
CC:     <slyich@gmail.com>, <glaubitz@physik.fu-berlin.de>,
        <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jszczype@redhat.com>, <Scott.Benesh@microchip.com>,
        <Scott.Teel@microchip.com>, <thenzl@redhat.com>,
        <martin.petersen@oracle.com>
Subject: RE: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Topic: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Thread-Index: AQHXD8NYByGFLRaE+E6Jw8YXZ2Cxsqpx9mmAgAB7hnCAArCfAIAARbkAgAA7DVA=
Date:   Fri, 5 Mar 2021 20:45:28 +0000
Message-ID: <BYAPR11MB283776005C6D41BAE51F91BBE1969@BYAPR11MB2837.namprd11.prod.outlook.com>
References: <20210222230519.73f3e239@sf>
 <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
 <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
 <20210223083507.43b5a6dd@sf>
 <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
 <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
 <20210223192743.0198d4a9@sf> <20210302222630.5056f243@sf>
 <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
 <20210303002236.2f4ec01f@sf> <20210303085533.505b1590@sf>
 <SN6PR11MB284885A5751845EEA290BFCFE1989@SN6PR11MB2848.namprd11.prod.outlook.com>
 <CAMuHMdVLFfSoC-UYW+3sijeZhLf9xt3rqS=7LTYhzX_1RDxpYA@mail.gmail.com>
 <CAK8P3a0EhxvQ3pP6iMwHdR3RwF3CcAaWvfodPnzPip2iW2wBgQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0EhxvQ3pP6iMwHdR3RwF3CcAaWvfodPnzPip2iW2wBgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24c5a2c0-1935-4c4d-664d-08d8e0179c90
x-ms-traffictypediagnostic: BYAPR11MB3815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3815C72E4744F654C5CB7884E1969@BYAPR11MB3815.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pvoHL7Z5qyxbL4+dbuW34c66BNEXGKvUjlciao+Y+ISDh2OB1nff8t3ElQAddgO6cm8LZJkptflGCG29wn91EA8sYbKSCiAEKA7qCtDfiOGpKk5xAcFwmL1lkX3l3XiJc5bc8Rvetx973jZS47eLt4YDjQATlSeKKASBqPjDBbwqmhuwBftCJ7vLrF4ORxfN0lu4FzxGK0igkAfJnQd7C1P6q7sDyPnQhUHDlBbMnUBEv3Szxoqd/khXixNK15GdTwObcBnTEpXWa5yqXDtAe9EptYyk5ouK/SCWOoOBgjUXJopxCmYsUWLDe8+944s9mkLpaB/XXPrQ80SkptJXWo92+y2HqMzy4nduCs09RIfqC8TOBsScALOGJk6ieyU9/vuTjvSd5Fv8Tec4+tGfDaEyPY96aQ1wcjnONMzEpfUJ7dp54t892Kjx2uIfg4ZfhvY9hvD0n5lXsSMhsCEwAn3gubn015s6t6Z6pJ3qUalrnSOnKtyP43uzRtdhLaFmtCoz6fg7MdGAE18+QJqyjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2837.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(2906002)(9686003)(83380400001)(8936002)(316002)(53546011)(7416002)(110136005)(66556008)(478600001)(5660300002)(4326008)(64756008)(54906003)(6506007)(52536014)(186003)(7696005)(66446008)(55016002)(66946007)(71200400001)(76116006)(66476007)(33656002)(26005)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WG45V01KWW5qQ2I2cnVCK1FMMjl6UjhTT0QxVUNla2VSRGp1TGcvZlg4ZGZZ?=
 =?utf-8?B?ZjRjeEpmOE5WcEtyaVIyMXpkZzBoczhhT1BGZjBhUS83MEE4cnk2MWprN1px?=
 =?utf-8?B?SXMyTEJUQjZIcGdDdkJxVGNpekk3a1lEVEl2ckZRWUp6MDBBSDNHZ3Z0QUs1?=
 =?utf-8?B?Z1hJcnU1MThFOU1zNExuSW1vSFhYL3l2L3NPUU5aNWlsRFZwbTV1YUc1cGtj?=
 =?utf-8?B?VXFnOHRKbVNQNVM2dEZHM2JYNGErOWNyZU9yKy9ZSy9xU1lsUGh0ZndDSTVk?=
 =?utf-8?B?SE9uVElXMVZyUWJoS3Z4b2MzTktISElDeDBQUlA5dG1jNjFES09aQkJlUmE4?=
 =?utf-8?B?UUFVZnJ0eW9FM25XSFpLc1kyQ3RmR2duQU9ncWxjeTBZZlhYMDZBUmdiWWpG?=
 =?utf-8?B?STdWaTg4eUduL2JZcm9CTmlicDdXQlFjM3pmVE13SnFwaWNkNGhkUW90M2cr?=
 =?utf-8?B?TlkwZUhVcGxQelFqdk42Wk1xdm03R092VUpTdis3TXR1SDNhUTNndTdEUmV0?=
 =?utf-8?B?bWgrUG9odTFiSFlpWXJCcStpNGhHOXFCVVdMZGh2dHVWV21VdFUrV1BzSi85?=
 =?utf-8?B?NExnT01EY1B6UDFncC9Zc3gra1I2aHU0SnVrS2kyR1ZKLzZNZzRnTlhFbGVj?=
 =?utf-8?B?RmFiNXdDUTV0SXRmMjhXMHh5N3VTZXhnZjhvdmZSNmtBNDg4UE9jVmVQeWZF?=
 =?utf-8?B?eVVEMW1FWnpEZ0oyWVM4SnFhV2ZTb252QlAzNUV4UUI5TjVDcGxqdG5KejFU?=
 =?utf-8?B?WkJNeWZ2THl1VEt1Z1dUM1Q4bkxRRE8zdU9zMGpuVklpV3NpMzZ3T1V1R0RK?=
 =?utf-8?B?UFFoWVY0TU5rV1l1bjdhTnduK0ZBOC9BSnVQK3FLU2pUamltTjZURlNIeXl4?=
 =?utf-8?B?QjhkYVF5RldGaCtCNlk4V1V2dHlCOWxleDJPVUxqQnp5UDI3V2FZRjlEMUl5?=
 =?utf-8?B?YzlxTTdJMnlEcGFVRnNuSXVqbGxxZTNHaFFLWW52WDBuZzkvTjF5ZjJWUlRu?=
 =?utf-8?B?WlNtaWdvZ0Q4SHNXakZSRUN4WGw0U3paTkxBZXNCRkRxT2RvWjVQS3hBa2hN?=
 =?utf-8?B?OFZUdkh1ZXpWaTVjOW9YVktMOGcvaDhwNlhRaDlSaEQxTUJrdU1vNEdKNCtE?=
 =?utf-8?B?MDVrNFU3b1pXLzdUNUo0Ym9LQ0J5dzgrdUZkMmduT1FnTzlPdHVGWStxdThs?=
 =?utf-8?B?dDNNVGR5U3Q5Tk5XSmo1WGtrRjNTcUl6amp5N1lBK2g2TjhmamFWOHQyQ3c2?=
 =?utf-8?B?eXlUZ1g0ai82dHJ2ZHlwNmZ2MTJldEJxRkRlT200a2FORGhRM3BXL3A3U1lm?=
 =?utf-8?B?aEkxS2xXOWVrZDhuSk5xSXBON3dVTVJPNXBVOTJFL24weHZXL3lKdit2cXpu?=
 =?utf-8?B?MXBXOWVZOVVPKzg3OWFiTEVabFFGM0ZCVTVPUXRtYk8zL0tuTHo4L3d0THlp?=
 =?utf-8?B?U0pobG9lcy85N2hXUzZGMDRuQ0RFWkRaSUtoVkRnS0JmTDdIaUdsdkIxeG9F?=
 =?utf-8?B?UTU5S3htQjFyWHJienFWaVlLMzhnT0VQd0crdVBoRGJyS0lIYUZ0TXBIQSsx?=
 =?utf-8?B?NjkrdURsNGQ4UXVLUklkQmFYQytIL3NCWUI0NnMxSk9UL1RsRzZNZkNaVmtS?=
 =?utf-8?B?V25wd2ZiTUtHNEwyZFdyNU8wYksrUkptbkIrVGJBME1hZzdld0trYTFybkFM?=
 =?utf-8?B?WWJsWDc2Umh1czQ0eHRPK0hkKzBpc0VsMXBwYUxiQVR5VmdNTHJUQVZ3T1gz?=
 =?utf-8?Q?iZqqu2j/F1irX5wI6c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2837.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c5a2c0-1935-4c4d-664d-08d8e0179c90
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2021 20:45:28.7244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Df43aG/wio8XpK5RHk/5KUzwSP6gURtgFN1JYZe+P29fvuEKpu1cTycA4Vut913ySM4KeF5A9hwCxSGhl7s/DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3815
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEFybmQgQmVyZ21hbm4gW21haWx0bzph
cm5kQGtlcm5lbC5vcmddIA0KU2VudDogRnJpZGF5LCBNYXJjaCA1LCAyMDIxIDc6MzIgQU0NClN1
YmplY3Q6IFJlOiBbYmlzZWN0ZWRdIDUuMTItcmMxIGhwc2EgcmVncmVzc2lvbjogInNjc2k6IGhw
c2E6IENvcnJlY3QgZGV2IGNtZHMgb3V0c3RhbmRpbmcgZm9yIHJldHJpZWQgY21kcyIgYnJlYWtz
IGhwc2EgUDYwMA0KDQpPbiBGcmksIE1hciA1LCAyMDIxIGF0IDEwOjI0IEFNIEdlZXJ0IFV5dHRl
cmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+IHdyb3RlOg0KPiBPbiBGcmksIE1hciA1LCAy
MDIxIGF0IDEyOjI2IEFNIDxEb24uQnJhY2VAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+ID4gPiA+
IE9uIDMvMi8yMSAxMToyNiBQTSwgU2VyZ2VpIFRyb2ZpbW92aWNoIHdyb3RlOg0KPiA+IHN0cnVj
dCBDb21tYW5kTGlzdCB7DQo+ID4gICAgICAgICBzdHJ1Y3QgQ29tbWFuZExpc3RIZWFkZXIgSGVh
ZGVyOyAgICAgICAgICAgICAgICAgLyogICAgIDAgICAgMjAgKi8NCj4gPiAgICAgICAgIHN0cnVj
dCBSZXF1ZXN0QmxvY2sgUmVxdWVzdDsgICAgICAgICAgICAgICAgICAgICAvKiAgICAyMCAgICAy
MCAqLw0KPiA+ICAgICAgICAgc3RydWN0IEVyckRlc2NyaXB0b3IgRXJyRGVzYzsgICAgICAgICAg
ICAgICAgICAgIC8qICAgIDQwICAgIDEyICovDQo+ID4gICAgICAgICBzdHJ1Y3QgU0dEZXNjcmlw
dG9yIFNHWzMyXTsgICAgICAgICAgICAgICAgICAgICAgLyogICAgNTIgICA1MTIgKi8NCj4gPiAg
ICAgICAgIC8qIC0tLSBjYWNoZWxpbmUgOCBib3VuZGFyeSAoNTEyIGJ5dGVzKSB3YXMgNTIgYnl0
ZXMgYWdvIC0tLSAqLw0KPiA+ICAgICAgICAgdTMyICAgICAgICAgICAgICAgICAgICAgICAgYnVz
YWRkcjsgICAgICAgICAgICAgIC8qICAgNTY0ICAgICA0ICovDQo+ID4gICAgICAgICBzdHJ1Y3Qg
RXJyb3JJbmZvICogICAgICAgICBlcnJfaW5mbzsgICAgICAgICAgICAgLyogICA1NjggICAgIDgg
Ki8NCj4gPiAgICAgICAgIC8qIC0tLSBjYWNoZWxpbmUgOSBib3VuZGFyeSAoNTc2IGJ5dGVzKSAt
LS0gKi8NCj4gPiAgICAgICAgIHN0cnVjdCBjdGxyX2luZm8gKiAgICAgICAgIGg7ICAgICAgICAg
ICAgICAgICAgICAvKiAgIDU3NiAgICAgOCAqLw0KPiA+ICAgICAgICAgaW50ICAgICAgICAgICAg
ICAgICAgICAgICAgY21kX3R5cGU7ICAgICAgICAgICAgIC8qICAgNTg0ICAgICA0ICovDQo+ID4g
ICAgICAgICBsb25nIGludCAgICAgICAgICAgICAgICAgICBjbWRpbmRleDsgICAgICAgICAgICAg
LyogICA1ODggICAgIDggKi8NCj4gPiAgICAgICAgIHN0cnVjdCBjb21wbGV0aW9uICogICAgICAg
IHdhaXRpbmc7ICAgICAgICAgICAgICAvKiAgIDU5NiAgICAgOCAqLw0KPiA+ICAgICAgICAgc3Ry
dWN0IHNjc2lfY21uZCAqICAgICAgICAgc2NzaV9jbWQ7ICAgICAgICAgICAgIC8qICAgNjA0ICAg
ICA4ICovDQo+ID4gICAgICAgICBzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsgICAgICAgICAgICAg
ICAgICAgICAgICAgLyogICA2MTIgICAgMzIgKi8NCj4gPiAgICAgICAgIC8qIC0tLSBjYWNoZWxp
bmUgMTAgYm91bmRhcnkgKDY0MCBieXRlcykgd2FzIDQgYnl0ZXMgYWdvIC0tLSAqLw0KPiA+ICAg
ICAgICAgc3RydWN0IGhwc2Ffc2NzaV9kZXZfdCAqICAgcGh5c19kaXNrOyAgICAgICAgICAgIC8q
ICAgNjQ0ICAgICA4ICovDQo+ID4gICAgICAgICBzdHJ1Y3QgaHBzYV9zY3NpX2Rldl90ICogICBk
ZXZpY2U7ICAgICAgICAgICAgICAgLyogICA2NTIgICAgIDggKi8NCj4gPiAgICAgICAgIGJvb2wg
ICAgICAgICAgICAgICAgICAgICAgIHJldHJ5X3BlbmRpbmc7ICAgICAgICAvKiAgIDY2MCAgICAg
MSAqLw0KPiA+ICAgICAgICAgYXRvbWljX3QgICAgICAgICAgICAgICAgICAgcmVmY291bnQ7ICAg
ICAgICAgICAgIC8qICAgNjYxICAgICA0ICovDQo+DQo+IEhvdyBjb21lIHRoaXMgYXRvbWljX3Qg
aXMgbm8gbG9uZ2VyIGFsaWduZWQgdG8gaXRzIG5hdHVyYWwgYWxpZ25tZW50Pw0KDQpUaGVyZSBp
cyBhDQoNCiNwcmFnbWEgcGFjaygxKQ0KDQppbiBsaW51eCAyMDMgb2YgdGhpcyBmaWxlIQ0KDQpJ
dCBsb29rcyBsaWtlIHNvbWUgb2YgdGhlIG1lbWJlcnMgaW4gc3RydWN0IHJhaWRfbWFwX2RhdGEg
YW5kIHN0cnVjdCBDb21tYW5kTGlzdEhlYWRlciBuZWVkIHRvIGJlIGFubm90YXRlZCBhcyBwYWNr
ZWQsIGJ1dCB0aGUgZmlsZSBhY2NpZGVudGFsbHkgcGFja3MgZXZlcnl0aGluZyB1bnRpbCB0aGUg
JyNwcmFnbWEgcGFjaygpJw0KaW4gbGluZSA4NzUsIGluY2x1ZGluZyB0aGUga2VybmVsLXNpZGUg
Q29tbWFuZExpc3QgZGF0YSBzdHJ1Y3R1cmUgdGhhdCBjbGVhcmx5IG11c3Qgbm90IGJlIHBhY2tl
ZC4NCg0KICAgICAgICBBcm5kDQotLS0NCkRvbjoNClRoYW5rcyBmb3IgeW91ciBpbnB1dC4gSXQg
aGVscHMgYSBsb3QuDQoNClRoZSBwcmFnbWEgc2V0dGluZyBwcmVkYXRlcyBteSB0YWtpbmcgb3Zl
ciB0aGUgZHJpdmVyLg0KDQpJdCdzIHRydWUgdGhhdCB0aGVyZSBpcyBhIHNlY3Rpb24gb2YgZWFj
aCBjb21tYW5kIGVudHJ5IHRoYXQgaXMgRE1BZWQgZnJvbSB0aGUgY29udHJvbGxlciAoZnJvbSBz
dGFydCBvZiB0aGUgQ29tbWFuZExpc3QgdXAgdG8gYnVzYWRkcikgYW5kIHRoZSByZXN0IGlzIGRy
aXZlciBob3VzZWtlZXBpbmcgaW5mb3JtYXRpb24uIFRoZSB1bnN1cHBvcnRlZCBjb250cm9sbGVy
cyBzZWVtIHRvIGJlIHVuYWJsZSB0byBoYW5kbGUgdGhlIGNoYW5nZWQgYWxpZ25tZW50LiANCg0K
SSBoYXZlIGEgcGF0Y2ggSSdsbCBzZW5kIHVwIHNvb24gdG8gY2hhbmdlIHRoZSBhbGlnbm1lbnQg
YmFjay4uLg0KICAgICAgICBpbnQgICAgICAgICAgICAgICAgICAgICAgICByZXRyeV9wZW5kaW5n
OyAgICAgICAgLyogICA2NTIgICAgIDQgKi8NCiAgICAgICAgc3RydWN0IGhwc2Ffc2NzaV9kZXZf
dCAqICAgZGV2aWNlOyAgICAgICAgICAgICAgIC8qICAgNjU2ICAgICA4ICovDQogICAgICAgIGF0
b21pY190ICAgICAgICAgICAgICAgICAgIHJlZmNvdW50OyAgICAgICAgICAgICAvKiAgIDY2NCAg
ICAgNCAqLw0KDQogICAgICAgIC8qIHNpemU6IDc2OCwgY2FjaGVsaW5lczogMTIsIG1lbWJlcnM6
IDE2ICovDQogICAgICAgIC8qIHBhZGRpbmc6IDEwMCAqLw0KfSBfX2F0dHJpYnV0ZV9fKChfX2Fs
aWduZWRfXygxMjgpKSk7DQoNClNpbmNlIHRoaXMgaXMgYSBtYWludGVuYW5jZSBkcml2ZXIsIEkg
d291bGQgcmF0aGVyIG5vdCBkbyB0b28gbXVjaCBzdXJnZXJ5IGFuZCBpbnZva2UgcmVncmVzc2lv
biB0ZXN0cyAoYW5kIHdlIG5vIGxvbmdlciBzdXBwb3J0IHRoZXNlIGNvbnRyb2xsZXJzKS4gSSdk
IHJhdGhlciBqdXN0IHNlbmQgdXAgYSBwYXRjaCB0byBjb3JyZWN0IHRoZSBpc3N1ZSBvbiB0aGVz
ZSBsZWdhY3kgY29udHJvbGxlcnMuIEkgaGF2ZSBvbmUgcmVhZHkgdG8gc2VuZCB1cC4NCg0KVGhh
bmtzIGZvciB5b3VyIG9ic2VydmF0aW9uIGFuZCB5b3VyIGF0dGVudGlvbi4NCkknbGwgc2VuZCB1
cCB0aGUgcGF0Y2ggc29vbi4NCg0KRG9uDQoNCg0KDQoNCg==
