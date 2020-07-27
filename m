Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C00C433EB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE7D206E7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 10:46:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LdvWncjI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eloYusz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgG0Kq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:46:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:4551 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgG0Kq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 06:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595846837; x=1627382837;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j6Rzy64zoC4ZU7XIY61BAMb5m/N4Y7UuxmwqR+wVpCA=;
  b=LdvWncjIvQQhDfG+ivjxdqI14Vf6n+6Cz38Ku0hMxk1Z6YCu8xaDMIm4
   4rwZwGcZopAms9ONwPf9hXKQw7trRGwVqOrXM3tlc3rC4oUjYQUqjVvHH
   AM61+HwWlWbolPhRB73wiShQcWoghPMBiXPWzM04hB0IioKgZLeHtMD+2
   Eu8T53SPHgiru2J+wQv8DzHpngOoXRdCG+56LCj5Vs3iysdbjTUkL7NmU
   FZ3mkt0re3wDIdvvH0EaoyN6t7bPHeyy7eHN/2iopCbmetM7d+Da7UGj3
   zilXgC90XoAV8iIVRA6W4YCXsJUAHaMvZXux0XU7WF3StL86BStL7wUSR
   w==;
IronPort-SDR: ciYy0iLo79LQuiBMG/LIo4ENwTu7+nuV19iNuQN/gHt48LmHUxay7savo6gCRQjmkygiX0/vT2
 phR4f5zPX8xkNZqifU0zM09NjgjMRB4cZUHEGMt/622aeqrKl0RRw7s9p/lizoZBg3db+9s8Q+
 kP7EX29oPznlOFtJfzdH4vF2og/y9XUcrz9L5zHQgcynb+3WlJuh5CgiApnD6ZbxfJbfqz3YRp
 5+67B6ySeyWj19GCzeeHK9zlBvGC4VNuhxTLSeZzeTCGA4VALGlUsfqNhQnbACGbAhYYxFe/fh
 9kc=
X-IronPort-AV: E=Sophos;i="5.75,402,1589212800"; 
   d="scan'208";a="246543177"
Received: from mail-bn3nam04lp2050.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.50])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 18:47:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzsdvQlfeppTVX2uZX3sJNTHFOkoCju6iHPfVFoYyxaVfv1XPt4ukNXgxcD+rSkOpEQSpJQp3QZeE9M0gFnC9ULgR16FbEShW1F98H8i/Fl+EOOfmPrIVKnn5K/DIS7OwG/jl28q+x0p/QaEujy0RVhffY8t9inRgWUHRQux6oHIz/zBhgdtsPBDom1opCDJ3BDDMhqx8yhaLDrwhovFD3gTppICtfGoI1CaoINd/ZuhX+jDZ9HiIRyUpBNpKaTg5qJwU63gKzVEhqPajuvnQ5yyNsXVKtGsIbevtqdszOSrvsQj2BKcIbEHbcY89eeaobqlOfpG9vYrUvidMJUiyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6Rzy64zoC4ZU7XIY61BAMb5m/N4Y7UuxmwqR+wVpCA=;
 b=NnxRYcRJcfHyA4ahrpO7zoUcITGcrr6JrZinfSYzwacxHURFm9xsaWBBfX3muLAs2k+fw4K3WzKS6puVz7n363b9WKAtR+pITJ77VbZLZ8FEFQzSt/rSdD/mb3IHW1gQDtwVS7gfHYznoj5xrGXrqwz9vRvZyspBHRAjvZfUoe7HzT3OWuWSC/wuBgjlMpdeXgKcBacaCDiFPYxUZ/5M+0bVYSgG6JTex9fbsz2LZey55P2NRXbC3xNzOSs9Nj9YjDn6WFyWWWexVAtzrkvMNS9eR1Ltey/0FZc/gOjVmDoWbCbZQZ9+rZl61791t4su7s/yJLsTAKSs7XQ+IhVk9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6Rzy64zoC4ZU7XIY61BAMb5m/N4Y7UuxmwqR+wVpCA=;
 b=eloYusz7vygAy1wRgE7ilrqbHsX5G8F9oPFrcMc5HKCsUO2Q99BrYtSWu54wtUDrJCjtC3r7FknzlCkyT0DB9SOwjqe3cZJVSdX6pj61KraASFQMhzC5D1B1C8lwGM/UQIWOrXVBCe/Bxz+nZCdUv2sfSM+bAKIaXqLwQ88fEgc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5438.namprd04.prod.outlook.com (2603:10b6:805:102::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Mon, 27 Jul
 2020 10:46:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 10:46:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before
 shutdown
Thread-Topic: [RFC PATCH v3] scsi: ufs: Quiesce all scsi devices before
 shutdown
Thread-Index: AQHWYAkzclwz5Nu9F0qZh2VTtgbNvqkbRdjA
Date:   Mon, 27 Jul 2020 10:46:49 +0000
Message-ID: <SN6PR04MB46401CB0D89FFD24496B33A6FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132218.21171-1-stanley.chu@mediatek.com>
         <2465978d-28d3-e30f-248e-87333c789743@acm.org>
 <1595409534.27178.19.camel@mtkswgap22>
In-Reply-To: <1595409534.27178.19.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 049f745c-8daa-4ef0-eccc-08d8321a5e0f
x-ms-traffictypediagnostic: SN6PR04MB5438:
x-microsoft-antispam-prvs: <SN6PR04MB543861B59BE0ACB70C0BCE77FC720@SN6PR04MB5438.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UH5lGeKQ+iadKC33Y8oug60ekpNXxUNmJQz+ad1fMlIz18APdvWPziATHjkmLD3tqZyLm9xb+7HF+nN+Ycn7PSzy3O2IpFFEW55MysOJG9L695D2xwmTE17s81YHRtA2JENjuPI1m35sNLg+WNU0T51eH73PToFIoByTOJwmCfQEIeyYuLgW1OuL90QlbGCamEcrPw9j8623KU4IANzskGefV8SvGmnQvCmvVV1cZBgW2gszBleagmgRfRpdjAwrDkNXF6QrzUTssx8WIu8HREycHif2jRLLdZJGXgKSLjoINgWCJeOiRw5nr8eMSImmD0YSkbRUxP0x7v+4wd0iDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(55016002)(5660300002)(316002)(54906003)(9686003)(110136005)(4326008)(8936002)(33656002)(83380400001)(8676002)(71200400001)(7416002)(7696005)(26005)(86362001)(6506007)(53546011)(2906002)(66556008)(186003)(478600001)(66946007)(66476007)(64756008)(52536014)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AE2tOC9HMI1o4/BgLhqNbq0X7hiD7PAjDTAhB6g70wq/lLM+h04cR+llVLvpzprKC++oneBaxmopZVh2FX+N+0iWr3kAEZAkqFQl1Y0k66X2YiLyFoEIVxDKEPZX7tJOwYV2GdKAEafBQ2rW5/5M9ZCshldFFmc7mNemr1o6vSQEGJJ2w/Uf5SljXSBatBsjXl3I6kKCu/tlSi+XXY9O2Th4djFRE0p7w3RK+EFRI5IgxMc72ukXux0vQE8kCIRd5VjaxG4oyY2qmu62ELxQrFOU/oFUzF0B1jHMTUtVdUcJc4qT3yAg4wEUl8WVMB47qTO3einr31FOOigTAEMZZg4JHoosyV5JUnvRUpmixU6Y2kiZTVhN8QS4rjEKUKYxbyboleOX5r4H0tqdl3FjOPjwSJ65I7n1DwbcDNbBZNLxWRNFoYue6rknayPsT+Zi4kvAp+1jaAKcuL3A91GZ+b1LBilNofqPns6FYwsC561TZr7A9PoDKY5n3NRU/HUm
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049f745c-8daa-4ef0-eccc-08d8321a5e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 10:46:49.9986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 688ynMJQsp5qkKYIFjc1o1f+uDXSdao7T8BFJwNVBslzbzmh6FvCMlOACGHva34YFHBptbwIW5EZBNADTW+WPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5438
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSGkgQmFydCwNCj4gDQo+IE9uIFNhdCwgMjAyMC0wNy0xMSBhdCAyMDoyMSAtMDcwMCwg
QmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IE9uIDIwMjAtMDctMDYgMDY6MjIsIFN0YW5sZXkg
Q2h1IHdyb3RlOg0KPiA+ID4gK3N0YXRpYyB2b2lkIHVmc2hjZF9jbGVhbnVwX3F1ZXVlKHN0cnVj
dCBzY3NpX2RldmljZSAqc2Rldiwgdm9pZCAqZGF0YSkNCj4gPiA+ICt7DQo+ID4gPiArICAgaWYg
KHNkZXYtPnJlcXVlc3RfcXVldWUpDQo+ID4gPiArICAgICAgICAgICBibGtfY2xlYW51cF9xdWV1
ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsNCj4gPiA+ICt9DQo+ID4NCj4gPiBObyBTQ1NJIExMRCBz
aG91bGQgZXZlciBjYWxsIGJsa19jbGVhbnVwX3F1ZXVlKCkgZGlyZWN0bHkgZm9yDQo+ID4gc2Rl
di0+cmVxdWVzdF9xdWV1ZS4gT25seSB0aGUgU0NTSSBjb3JlIHNob3VsZCBjYWxsIGJsa19jbGVh
bnVwX3F1ZXVlKCkNCj4gPiBkaXJlY3RseSBmb3IgdGhhdCBxdWV1ZS4NCj4gDQo+IEdvdCBpdC4N
Cj4gDQo+IFNvIG1heSBJIGZvY3VzIG9uIGZpeGluZyByYWNpbmcgZmlyc3QgYnkgcXVpZWNzaW5n
IGFsbCBTQ1NJIGRldmljZXMgb25seQ0KPiBhbmQgZG8gbm90IHRvdWNoIGJsa19jbGVhbnVwX3F1
ZXVlKCkgaW4gVUZTIGRyaXZlciwganVzdCBsaWtlIHYyPw0KPiANCj4gDQo+ID4gPiAgaW50IHVm
c2hjZF9zaHV0ZG93bihzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+ID4gIHsNCj4gPiA+ICAgICBp
bnQgcmV0ID0gMDsNCj4gPiA+ICsgICBzdHJ1Y3Qgc2NzaV90YXJnZXQgKnN0YXJnZXQ7DQo+ID4g
Pg0KPiA+ID4gICAgIGlmICghaGJhLT5pc19wb3dlcmVkKQ0KPiA+ID4gICAgICAgICAgICAgZ290
byBvdXQ7DQo+ID4gPiBAQCAtODYxMiw3ICs4NjMyLDI1IEBAIGludCB1ZnNoY2Rfc2h1dGRvd24o
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7
DQo+ID4gPiAgICAgfQ0KPiA+ID4NCj4gPiA+ICsgICAvKg0KPiA+ID4gKyAgICAqIFF1aWVzY2Ug
YWxsIFNDU0kgZGV2aWNlcyB0byBwcmV2ZW50IGFueSBub24tUE0gcmVxdWVzdHMgc2VuZGluZw0K
PiA+ID4gKyAgICAqIGZyb20gYmxvY2sgbGF5ZXIgZHVyaW5nIGFuZCBhZnRlciBzaHV0ZG93bi4N
Cj4gPiA+ICsgICAgKg0KPiA+ID4gKyAgICAqIEhlcmUgd2UgY2FuIG5vdCB1c2UgYmxrX2NsZWFu
dXBfcXVldWUoKSBzaW5jZSBQTSByZXF1ZXN0cw0KPiA+ID4gKyAgICAqICh3aXRoIEJMS19NUV9S
RVFfUFJFRU1QVCBmbGFnKSBhcmUgc3RpbGwgcmVxdWlyZWQgdG8gYmUgc2VudA0KPiA+ID4gKyAg
ICAqIHRocm91Z2ggYmxvY2sgbGF5ZXIuIFRoZXJlZm9yZSBTQ1NJIGNvbW1hbmQgcXVldWVkIGFm
dGVyIHRoZQ0KPiA+ID4gKyAgICAqIHNjc2lfdGFyZ2V0X3F1aWVzY2UoKSBjYWxsIHJldHVybmVk
IHdpbGwgYmxvY2sgdW50aWwNCj4gPiA+ICsgICAgKiBibGtfY2xlYW51cF9xdWV1ZSgpIGlzIGNh
bGxlZC4NCj4gPiA+ICsgICAgKg0KPiA+ID4gKyAgICAqIEJlc2lkZXMsIHNjc2lfdGFyZ2V0XyJ1
biJxdWllc2NlIChlLmcuLCBzY3NpX3RhcmdldF9yZXN1bWUpIGNhbg0KPiA+ID4gKyAgICAqIGJl
IGlnbm9yZWQgc2luY2Ugc2h1dGRvd24gaXMgb25lLXdheSBmbG93Lg0KPiA+ID4gKyAgICAqLw0K
PiA+ID4gKyAgIHVmc2hjZF9zY3NpX2Zvcl9lYWNoX3NkZXYodWZzaGNkX3F1aWVjZV9zZGV2KTsN
Cj4gPiA+ICsNCj4gPiA+ICAgICByZXQgPSB1ZnNoY2Rfc3VzcGVuZChoYmEsIFVGU19TSFVURE9X
Tl9QTSk7DQo+ID4gPiArDQo+ID4gPiArICAgLyogU2V0IHF1ZXVlIGFzIGR5aW5nIHRvIG5vdCBi
bG9jayBxdWV1ZWluZyBjb21tYW5kcyAqLw0KPiA+ID4gKyAgIHVmc2hjZF9zY3NpX2Zvcl9lYWNo
X3NkZXYodWZzaGNkX2NsZWFudXBfcXVldWUpOw0KPiA+ID4gIG91dDoNCj4gPiA+ICAgICBpZiAo
cmV0KQ0KPiA+ID4gICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgIiVzIGZhaWxlZCwgZXJy
ICVkXG4iLCBfX2Z1bmNfXywgcmV0KTsNCj4gPiA+DQo+ID4NCj4gPiBXaGF0IGlzIHRoZSBwdXJw
b3NlIG9mIHVmc2hjZF9zaHV0ZG93bigpPyBXaHkgZG9lcyB0aGlzIGZ1bmN0aW9uIGV4aXN0Pw0K
PiA+IEhvdyBhYm91dCByZW1vdmluZyB0aGUgY2FsbHMgdG8gdWZzaGNkX3NodXRkb3duKCkgYW5k
IGludm9raW5nIHBvd2VyDQo+IGRvd24NCj4gPiBjb2RlIGZyb20gaW5zaWRlIHNkX3N1c3BlbmRf
Y29tbW9uKCkgaW5zdGVhZD8NCj4gDQo+IHVmc2hjZF9zaHV0ZG93bigpIGNvbmZpZ3VyZXMgYmVs
b3cgdGhpbmdzIGRpZmZlcmVudCBmcm9tIG9yIG1vcmUgdGhhbg0KPiB3aGF0IHNkX3N1c3BlbmRf
Y29tbW9uKCkgY2FuIGRvIG5vdywNCj4gDQo+IC0gU2V0IGxpbmsgYXMgT0ZGIHN0YXRlDQo+IC0g
UmVndWxhdG9yIGFuZCBjbG9jayB0b2dnbGluZyBhY2NvcmRpbmcgdG8gcmVxdWlyZWQgbG93LXBv
d2VyIHN0YXRlIGZvcg0KPiBzaHV0ZG93bg0KPiAtIEF1dG8gQktPUCB0b2dnbGluZw0KPiAtIFZl
bmRvci1zcGVjaWZpYyBzaHV0ZG93biBmbG93IC4uLmV0Yy4NCj4gDQo+IFRoZXJlZm9yZSBVRlMg
c2h1dGRvd24gY2FsbGJhY2sgd291bGQgYmUgc3RpbGwgcmVxdWlyZWQuDQpBbmQgdGhpcyBpcyBh
bHNvIHdoeSwgdGhhdCBlYWNoIGNoaXBzZXQgdmVuZG9yIGltcGxlbWVudCBpdHMgb3duIGRldl9w
bV9vcHMuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiBTdGFubGV5IENodQ0K
DQo=
