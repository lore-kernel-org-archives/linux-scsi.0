Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475F6C07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 19:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D88861629
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 19:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhGHTNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 15:13:07 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59274 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHTNG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 15:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625771424; x=1657307424;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cjnK9FOD3K2PPXHRoxSTP2t35JmrwvAPWHO6rnvRYZ8=;
  b=hoxF6i1ugxeLpY5tnJz7O2wRXFzEN6WO1+YGegfnZw+XAO7IUuu6KulZ
   3benaRvdpSNrPqHFu+7Mg9IFIcdnCtu+ZCmsExlX20cUzf8m2PMYeT4zP
   0iipzBgKL2mKsZTAGfBvob7S3J32g5rl1uMaJAkye6tHPrc8OkfL/S5W5
   TN/aWTV02uEPYOs+esvzwiqklvN+NUamufmuPWVIQdsfAYkpSSkzxD4cv
   77t4nXc3aXQMQgmDW1jRRjd/Jn8pldM5quD7Zlg4yHsgRQV6V7vm03Lw3
   kLzTXhzOuWmXuLBYC9ErAVA4moYA2ymr1twd44WDKCpfo2BZEbii2nlS5
   g==;
IronPort-SDR: s2gPcDwFHCjyy+hCsljWYGz2icO5+WiY2tdgc5kMnz4xiT4BDKLW/PDAabVH4OC76iaOiN3kaL
 Jc+0JL4JN29HmMrVcY61gPaKXHf3E3W/Prgi+9hBYE9m2GiMfluYB5ry6cn+uKpYqW9jzo3Vrf
 yDyl4uCv7+7LJ38/Ve4+fYGj5q7RuOqbUDJ73oYoJ5woyQc9XjJPZSZc1aR8X3Nds5zL96aOJE
 qyiC7cI8PDJoqWtoTutEnJPOc/AnqkrA4W9+babtSsuJ9OyV4h4Tu2e5KvX71OYHjAGCPtQfCq
 NBE=
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="123948761"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2021 12:10:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 12:10:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 8 Jul 2021 12:10:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQXEf6bRIHABNXlfoB2BGbEx+BdNxC7eSaf/MhTFwM3S3WWBqB5aSKFYRuwhOKKIr4JaYerwcTl/Ws0j3bdGRABAtgz1xM1VLJpZIawJqIPEmPHK6rNQmvA1Vje6AjTegd0tAP7lCqIqQ65ZeKgE4qWXfws2GA1/6UuzeATe3IbhX3stgxUQB/e1L/oPn6768KlgPCbYwS8j1qdde1abOG6q9eHYhsW67DUpCgo76Aps4m2KbUUZrBFw/kVyLBPo4UU1AezrUcxRz+MWy8OgAw/PbvGy68HXP4cymkks+urVvh1DHYhp31A5SCf8PI8C5vht5ydemk1xpTl+d/MZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjnK9FOD3K2PPXHRoxSTP2t35JmrwvAPWHO6rnvRYZ8=;
 b=eInjrLw47EYE26RSw7qcnmQKpqsgU6rHPZZ4YMdMxHAX7XH15ph/WGzLUJxwRQW2uRq2TXL5vURi+KV2XjYIx+yovRiQuvK9C/KHd5yqiC4wnA51Fsy0g/Zu867wjt7Jdii/IhsYw/TLDd5LPYpKde2QTEDmf+59zlc9VVZlEe9U9zb3ZZu/vygf4xzKwgQQ7FEwY5UuWyhMBEbj52eYxfUhRGExkpuDRFHZLIw/0oOa/xnTpcw37t9WTY5bAGYFzQTrXVyKqncnqjG0XvriuVWmLWtqkuFK77LWxkMtVlnVfnpHGUFO7WfI/OM8G22+1YfSoZmHMPKARi7h0VJPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjnK9FOD3K2PPXHRoxSTP2t35JmrwvAPWHO6rnvRYZ8=;
 b=MyZ3rA2/mlRveYNPZd0NwJtxKab9eqqYhTChcXFerLI9ID95iXgT57aE9jqsBUg7flMURb/rjo1zdp2LNd0RwLoGPT+LaNdHtDYdaS6VtygOjTTb+dBRlDFV1QeQsF4QYqrhGNOH62jpgFylO783dzameaeagS/abxW5ugQcDDM=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4826.namprd11.prod.outlook.com (2603:10b6:806:11c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 19:10:20 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 19:10:20 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>
CC:     <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 3/9] smartpqi: update copyright notices
Thread-Topic: [smartpqi updates PATCH 3/9] smartpqi: update copyright notices
Thread-Index: AQHXcwKnGsUL0LGftU6+xkHipKINZqs5c2vg
Date:   Thu, 8 Jul 2021 19:10:20 +0000
Message-ID: <SN6PR11MB28481179C4B17F71CC983318E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-4-don.brace@microchip.com>
 <274bef24-bbcd-7edd-140f-38e662f67199@molgen.mpg.de>
In-Reply-To: <274bef24-bbcd-7edd-140f-38e662f67199@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f544fa9-b43d-4cb3-bb48-08d9424407b1
x-ms-traffictypediagnostic: SA2PR11MB4826:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4826B1A0878D9159C2C32864E1199@SA2PR11MB4826.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfPH/EAehidGwwQa1NqKeFRLxVteWUxTKXO+IUpnXkTzjs/uAb/uxuRagoMaBpMO6trA5CiElGERUvRAZ9qUowQX/jcZHhFP4w3yBhda0IXtyMN3YItGurYPzgVxdXYk9zY7YEmY711ZQFKLo4KYGVJvfOfarp0WSdFo0WohdoqYxdXMFrk9jod2FDL1esZooXUlSGZO/kJwDcpqXYe9xFbQDztNkmAqlXHkhaz8yZfpVipnwDJLXEcy0uPTNFTWFeWfsJyoGn5DELNwAENmxpCpq0sjfrZQJLpSUwqq47xZmlWzzJG8iGgIQrYm1t3OraStPCgj7zRiYtZ3N2IrJzKEYK4wH4D9Ht9TYT45q+qn1PtXVh3TZC+Z21KUOZ/NDtUp8FqOfKT7Bcp3uK/1R3X9iWVskd/3vuIQZTHd3G6PodenYMQxiD3/uraka4gHIn7CjoCSM3wn/Grln9WekV8ard80DnAORzPaCP09fmpQC3xZrGIYukGnwHJVtmDsGV5BCwKYpUVeZmwMbr9wtckdOaZeCGd/YOSdHTkz1q885u6k4yETg0P9cksSdI/qxiY0+dst9DsSoLbcU12d7iXJ0erXcWluCcMfpeaM3BHgyP2/WNBP6ghGLHYctmQ1PeWm1d/tdN5z8LUgjjJmvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(376002)(136003)(5660300002)(86362001)(9686003)(52536014)(66556008)(66946007)(7416002)(55016002)(71200400001)(66476007)(54906003)(66446008)(64756008)(38100700002)(110136005)(478600001)(186003)(2906002)(26005)(122000001)(6506007)(6636002)(83380400001)(316002)(8676002)(4326008)(76116006)(33656002)(7696005)(8936002)(15650500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ym5JbEN3K3orOFdiV0xIeUtYQVdiZk55L0JZV0g2NEt6OTFFZlpWaXlvSFpD?=
 =?utf-8?B?Q1lBTFAxbHV2ZGszT0U2RE9lejJLc2N6dEJGOFBTNEpVbkNtR0tTQS94VlZD?=
 =?utf-8?B?SzJKdUpYV05ORmI0b3N2akFJSjdMVUJITmIxWDZsMzBMQ2JMWDNWNGszU3JT?=
 =?utf-8?B?RGFMWStkRHE0cC9vVUoyUldSQWw2c2FLb1pFTk50RXB4dHZ0akl1cVpCZHNZ?=
 =?utf-8?B?aFBYNi9LcTNwb0ZwTEhOUUs1cmF0OG5XSnRHSFVPRHhnN3Z2Y1ZvSy9EaVZY?=
 =?utf-8?B?UW8zYkExVHNLTW9wUjJiRDdlWUtLVmM5Wng0TGswVjNiL0ZxWXZiZTZJU1hs?=
 =?utf-8?B?MThiNG9taGd6QVFzaWVHaFRnK1AyM2FOMXFPMmM2a2pWS1A4UStYQkVnTklL?=
 =?utf-8?B?Q0pPb280VEhXUGk4QmlBUWpVa1ppeno1VUZ4ejRoSFh6K1M2c3Z3NXh1YmRo?=
 =?utf-8?B?TnY3dkFEOE5lR3pUakN1TFkwOUthMVRHejVKSEVPTkkzMUJLZkJ1UEV1eVI1?=
 =?utf-8?B?ODFidlRBcjN1RWxwZmNLQU5uZVo4SHhYSnB1dzZudkN4amw4ZEdLZEVwT1Ra?=
 =?utf-8?B?ZkVIdUhwOFpTNmtsNG5vMGVhM0lZU3FPTFNGMDdTeEpzcUtDMTE5OFE0NmRI?=
 =?utf-8?B?SlNsZEtqcW53U0Ezc0l4Rm4zNVdEd2J5OTR5M2NVMktkcUZmNnZHanFFbGpj?=
 =?utf-8?B?bG1sUGZoV1Z3bDdFSG9BOWRCWnlyL1h3UG1haTRkNzFPQWtNUEoyNWduTUVS?=
 =?utf-8?B?T3BCTzlpYzN0NXhVdE1jckFnSTUvcXV1WkdVRzc4NzhLekNIVFFWbDFFeEdz?=
 =?utf-8?B?bmFiN3liSllUYmdSZWYyMzNKdG5uQU02UVU0czhJNEpWVFJZUFROVXZyRlFM?=
 =?utf-8?B?S1I0OVBhcWRUMHRqSVB4clpidW8vNUFQM0RKeTk0Y0VJdHVmWU5kN1VPYWZZ?=
 =?utf-8?B?UnhCeVNjVURvczZpa2RzSmE1eUtBNjB3eVBheG1QVGQ1bk1DVWZIMVF3S3VR?=
 =?utf-8?B?SmFFbmdjSE9tZTRUaDBYb0N2MzJ5WUdnbGxtT2dwVlNTdVAyeFdHYVZPcytY?=
 =?utf-8?B?Q2FDZVlMeHQ5Y1lRaERyVlZwUjhVcUVGRzArZEpWY0g4WHNHanBzUHRTOEtt?=
 =?utf-8?B?NTF1R3hJMlVZMm5yR25iOGtRU2Z3MjJobzJXYU92UnAwZDRRKytBT0lOWGJL?=
 =?utf-8?B?ejBTT1pxNWw5TWhMQ3N3WVA5SnQyelNBanFVVUJzd05DckVuVGcveFlKQUR4?=
 =?utf-8?B?UmdTQ3JSek1BQWRCWEpSL1FiWmdJWUE4MmFwUXJVWEdpaXZacUxrdG1waFpB?=
 =?utf-8?B?TkFyNnVQQ2gvVG4vT05DajIyMGpVN2xYN0FxeCtFTExpelJDOHN1Q28zTVBL?=
 =?utf-8?B?NjlvYVR2eGpieHA0SVl1bThPc3VyZ05LN2FZWTl2SkFXcTRPakNXVGV2OE1E?=
 =?utf-8?B?WkxIbTdaMWRCUFBqdzdhQXBtVHAwdlNZNlozeE1vcHIzL0o5elJaeVhnVUxT?=
 =?utf-8?B?bVc1SG9SaUl4Q0dtSGNPcVAyRzZkWjlabTVWUjJwVU0zUWxaRU1UNVFpeC9I?=
 =?utf-8?B?cE0waEl6ZU5CMmpMS2ZGeFprZEZWek5BbHRaOXhad2NleHNNUmRvUGxCUFA1?=
 =?utf-8?B?QnBjVVNZeWhXdFVtMDZWZ21LYnNzazUvWVhrTWk2VTQ1dm8yRkpkUkVKaU00?=
 =?utf-8?B?NDl0SVU2dC9FUzJuNWpCZGNBdEZQcU52M3VWUDNqWUNRekpIeWw4M0xyemdm?=
 =?utf-8?Q?/xD+DKD5bbaDemHAuMhP93yihb5wk1Z3xPX+dY2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f544fa9-b43d-4cb3-bb48-08d9424407b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 19:10:20.1664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ot1/e00G3H8eMHaNRcviRq7exV+cU6RH9+IUfQeWSWX4rknVkbABHsuSci2FS6zaI8yVkuMtKWCIxQxVaKMvEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4826
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdWwgTWVuemVsIFttYWlsdG86cG1l
bnplbEBtb2xnZW4ubXBnLmRlXSANClN1YmplY3Q6IFJlOiBbc21hcnRwcWkgdXBkYXRlcyBQQVRD
SCAzLzldIHNtYXJ0cHFpOiB1cGRhdGUgY29weXJpZ2h0IG5vdGljZXMNCg0KRGVhciBLZXZpbiwg
ZGVhciBEb24sDQoNCg0KQW0gMDYuMDcuMjEgdW0gMjA6MTYgc2NocmllYiBEb24gQnJhY2U6DQo+
IEZyb206IEtldmluIEJhcm5ldHQgPGtldmluLmJhcm5ldHRAbWljcm9jaGlwLmNvbT4NCj4NCj4g
VXBkYXRlZCBjb3B5cmlnaHQgbm90aWNlcyBhbmQgY29tcGFueSBuYW1lIHN0cmluZ3MgdG8gcmVm
bGVjdA0KDQrigKYgZnJvbSBNaWNyb3NlbWkgdG8gTWljcm9jaGlwIOKApg0KDQo+IE1pY3JvY2hp
cCBvd25lcnNoaXAuDQoNCllvdSBhbHNvIGNoYW5nZSB0aGUgZHJpdmVyIG5hbWUuIE1heWJlIGRv
IHRoYXQgaW4gYSBzZXBhcmF0ZSBjb21taXQgd2l0aCBhIGRlZGljYXRlZCBjb21taXQgbWVzc2Fn
ZXMgc3VtbWFyeS4NCg0KRG9uOiBJJ2xsIHNlcGFyYXRlIHRoZSBkcml2ZXIgbmFtZSBmcm9tIHRo
ZSBjb3B5cmlnaHQgcGF0Y2hlcyBhbmQgc2VuZCB1cCBhIG5ldyBwYXRjaCBpbiBWMi4NCg0KVGhh
bmtzIGZvciB5b3VyIHJldmlldy4NCg0KDQpOYW1lIGNoYW5nZXMgYWZmZWN0aW5nIHN0cmluZ3Mg
c2hvd2luZyB1cCBpbiBsb2cgbWVzc2FnZXMgYXJlIGFsd2F5cyBjb25mdXNpbmcgZm9yIHBlb3Bs
ZeKAmXMgbXVzY2xlIG1lbW9yeS4gTm8gaWRlYSwgaWYgaXTigJlkIGJlIGJldHRlciB0byBpbmNs
dWRlIGJvdGggbmFtZXMgaW4gdGhlIGRyaXZlciBuYW1lIHVudGlsIHRoZSBuZXh0IExpbnV4IExU
UyBzZXJpZXMgaXMgcmVsZWFzZWQuDQoNCkRvbjogV2Ugd291bGQgcmF0aGVyIGp1c3QgaGF2ZSBv
bmUgbmFtZS4NCg0KDQpLaW5kIHJlZ2FyZHMsDQoNClBhdWwNCg0KDQo+IFJldmlld2VkLWJ5OiBN
aWtlIE1jR293ZW4gPG1pa2UubWNnb3dlbkBtaWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTog
U2NvdHQgQmVuZXNoIDxzY290dC5iZW5lc2hAbWljcm9jaGlwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6
IFNjb3R0IFRlZWwgPHNjb3R0LnRlZWxAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
S2V2aW4gQmFybmV0dCA8a2V2aW4uYmFybmV0dEBtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBEb24gQnJhY2UgPGRvbi5icmFjZUBtaWNyb2NoaXAuY29tPg0KPiAtLS0NCj4gICBkcml2
ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWkuaCAgICAgICAgICAgICAgIHwgIDYgKysrLS0tDQo+
ICAgZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYyAgICAgICAgICB8IDEyICsr
KysrKy0tLS0tLQ0KPiAgIGRyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9zYXNfdHJhbnNw
b3J0LmMgfCAgNCArKy0tDQo+ICAgZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX3Npcy5j
ICAgICAgICAgICB8ICA0ICsrLS0NCj4gICBkcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlf
c2lzLmggICAgICAgICAgIHwgIDQgKystLQ0KPiAgIDUgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0
aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
c21hcnRwcWkvc21hcnRwcWkuaCANCj4gYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWku
aA0KPiBpbmRleCBkN2RhYzU1NzIyNzQuLmYzNDBhZmMwMTFiNSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3NtYXJ0
cHFpL3NtYXJ0cHFpLmgNCj4gQEAgLTEsNyArMSw3IEBADQo+ICAgLyogU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4gICAvKg0KPiAtICogICAgZHJpdmVyIGZvciBNaWNyb3Nl
bWkgUFFJLWJhc2VkIHN0b3JhZ2UgY29udHJvbGxlcnMNCj4gLSAqICAgIENvcHlyaWdodCAoYykg
MjAxOS0yMDIwIE1pY3JvY2hpcCBUZWNobm9sb2d5IEluYy4gYW5kIGl0cyBzdWJzaWRpYXJpZXMN
Cj4gKyAqICAgIGRyaXZlciBmb3IgTWljcm9jaGlwIFBRSS1iYXNlZCBzdG9yYWdlIGNvbnRyb2xs
ZXJzDQo+ICsgKiAgICBDb3B5cmlnaHQgKGMpIDIwMTktMjAyMSBNaWNyb2NoaXAgVGVjaG5vbG9n
eSBJbmMuIGFuZCBpdHMgc3Vic2lkaWFyaWVzDQo+ICAgICogICAgQ29weXJpZ2h0IChjKSAyMDE2
LTIwMTggTWljcm9zZW1pIENvcnBvcmF0aW9uDQo+ICAgICogICAgQ29weXJpZ2h0IChjKSAyMDE2
IFBNQy1TaWVycmEsIEluYy4NCj4gICAgKg0KPiBAQCAtNTksNyArNTksNyBAQCBzdHJ1Y3QgcHFp
X2RldmljZV9yZWdpc3RlcnMgew0KPiAgIC8qDQo+ICAgICogY29udHJvbGxlciByZWdpc3RlcnMN
Cj4gICAgKg0KPiAtICogVGhlc2UgYXJlIGRlZmluZWQgYnkgdGhlIE1pY3Jvc2VtaSBpbXBsZW1l
bnRhdGlvbi4NCj4gKyAqIFRoZXNlIGFyZSBkZWZpbmVkIGJ5IHRoZSBNaWNyb2NoaXAgaW1wbGVt
ZW50YXRpb24uDQo+ICAgICoNCj4gICAgKiBTb21lIHJlZ2lzdGVycyAodGhvc2UgbmFtZWQgc2lz
XyopIGFyZSBvbmx5IHVzZWQgd2hlbiBpbg0KPiAgICAqIGxlZ2FjeSBTSVMgbW9kZSBiZWZvcmUg
d2UgdHJhbnNpdGlvbiB0aGUgY29udHJvbGxlciBpbnRvIGRpZmYgDQo+IC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX2luaXQuYyANCj4gYi9kcml2ZXJzL3Njc2kvc21hcnRw
cWkvc21hcnRwcWlfaW5pdC5jDQo+IGluZGV4IDc5NTgzMTY4NDFhNC4uNWNlMWM0MWE3NThkIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfaW5pdC5jDQo+ICsr
KyBiL2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9pbml0LmMNCj4gQEAgLTEsNyArMSw3
IEBADQo+ICAgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gICAvKg0KPiAt
ICogICAgZHJpdmVyIGZvciBNaWNyb3NlbWkgUFFJLWJhc2VkIHN0b3JhZ2UgY29udHJvbGxlcnMN
Cj4gLSAqICAgIENvcHlyaWdodCAoYykgMjAxOS0yMDIwIE1pY3JvY2hpcCBUZWNobm9sb2d5IElu
Yy4gYW5kIGl0cyBzdWJzaWRpYXJpZXMNCj4gKyAqICAgIGRyaXZlciBmb3IgTWljcm9jaGlwIFBR
SS1iYXNlZCBzdG9yYWdlIGNvbnRyb2xsZXJzDQo+ICsgKiAgICBDb3B5cmlnaHQgKGMpIDIwMTkt
MjAyMSBNaWNyb2NoaXAgVGVjaG5vbG9neSBJbmMuIGFuZCBpdHMgc3Vic2lkaWFyaWVzDQo+ICAg
ICogICAgQ29weXJpZ2h0IChjKSAyMDE2LTIwMTggTWljcm9zZW1pIENvcnBvcmF0aW9uDQo+ICAg
ICogICAgQ29weXJpZ2h0IChjKSAyMDE2IFBNQy1TaWVycmEsIEluYy4NCj4gICAgKg0KPiBAQCAt
MzksNyArMzksNyBAQA0KPiAgICNkZWZpbmUgRFJJVkVSX1JFTEVBU0UgICAgICAgICAgICAgIDgN
Cj4gICAjZGVmaW5lIERSSVZFUl9SRVZJU0lPTiAgICAgICAgICAgICA0NQ0KPg0KPiAtI2RlZmlu
ZSBEUklWRVJfTkFNRSAgICAgICAgICAiTWljcm9zZW1pIFBRSSBEcml2ZXIgKHYiIFwNCj4gKyNk
ZWZpbmUgRFJJVkVSX05BTUUgICAgICAgICAgIk1pY3JvY2hpcCBTbWFydFBRSSBEcml2ZXIgKHYi
IFwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRFJJVkVSX1ZFUlNJT04gQlVJTERf
VElNRVNUQU1QICIpIg0KPiAgICNkZWZpbmUgRFJJVkVSX05BTUVfU0hPUlQgICAic21hcnRwcWki
DQo+DQo+IEBAIC00OCw4ICs0OCw4IEBADQo+ICAgI2RlZmluZSBQUUlfUE9TVF9SRVNFVF9ERUxB
WV9TRUNTICAgICAgICAgICAgICAgICAgIDUNCj4gICAjZGVmaW5lIFBRSV9QT1NUX09GQV9SRVNF
VF9ERUxBWV9VUE9OX1RJTUVPVVRfU0VDUyAgMTANCj4NCj4gLU1PRFVMRV9BVVRIT1IoIk1pY3Jv
c2VtaSIpOw0KPiAtTU9EVUxFX0RFU0NSSVBUSU9OKCJEcml2ZXIgZm9yIE1pY3Jvc2VtaSBTbWFy
dCBGYW1pbHkgQ29udHJvbGxlciB2ZXJzaW9uICINCj4gK01PRFVMRV9BVVRIT1IoIk1pY3JvY2hp
cCIpOw0KPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJEcml2ZXIgZm9yIE1pY3JvY2hpcCBTbWFydCBG
YW1pbHkgQ29udHJvbGxlciB2ZXJzaW9uICINCj4gICAgICAgRFJJVkVSX1ZFUlNJT04pOw0KPiAg
IE1PRFVMRV9WRVJTSU9OKERSSVZFUl9WRVJTSU9OKTsNCj4gICBNT0RVTEVfTElDRU5TRSgiR1BM
Iik7DQo+IEBAIC04NDQ4LDcgKzg0NDgsNyBAQCBzdGF0aWMgdm9pZCBwcWlfcHJpbnRfY3RybF9p
bmZvKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2LA0KPiAgICAgICBpZiAoaWQtPmRyaXZlcl9kYXRh
KQ0KPiAgICAgICAgICAgICAgIGN0cmxfZGVzY3JpcHRpb24gPSAoY2hhciAqKWlkLT5kcml2ZXJf
ZGF0YTsNCj4gICAgICAgZWxzZQ0KPiAtICAgICAgICAgICAgIGN0cmxfZGVzY3JpcHRpb24gPSAi
TWljcm9zZW1pIFNtYXJ0IEZhbWlseSBDb250cm9sbGVyIjsNCj4gKyAgICAgICAgICAgICBjdHJs
X2Rlc2NyaXB0aW9uID0gIk1pY3JvY2hpcCBTbWFydCBGYW1pbHkgQ29udHJvbGxlciI7DQo+DQo+
ICAgICAgIGRldl9pbmZvKCZwY2lfZGV2LT5kZXYsICIlcyBmb3VuZFxuIiwgY3RybF9kZXNjcmlw
dGlvbik7DQo+ICAgfQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0
cHFpX3Nhc190cmFuc3BvcnQuYyANCj4gYi9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlf
c2FzX3RyYW5zcG9ydC5jDQo+IGluZGV4IGRkNjI4Y2M4N2Y3OC4uYWZkOWJhZmViZDFkIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfc2FzX3RyYW5zcG9ydC5j
DQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9zYXNfdHJhbnNwb3J0LmMN
Cj4gQEAgLTEsNyArMSw3IEBADQo+ICAgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0y
LjANCj4gICAvKg0KPiAtICogICAgZHJpdmVyIGZvciBNaWNyb3NlbWkgUFFJLWJhc2VkIHN0b3Jh
Z2UgY29udHJvbGxlcnMNCj4gLSAqICAgIENvcHlyaWdodCAoYykgMjAxOS0yMDIwIE1pY3JvY2hp
cCBUZWNobm9sb2d5IEluYy4gYW5kIGl0cyBzdWJzaWRpYXJpZXMNCj4gKyAqICAgIGRyaXZlciBm
b3IgTWljcm9jaGlwIFBRSS1iYXNlZCBzdG9yYWdlIGNvbnRyb2xsZXJzDQo+ICsgKiAgICBDb3B5
cmlnaHQgKGMpIDIwMTktMjAyMSBNaWNyb2NoaXAgVGVjaG5vbG9neSBJbmMuIGFuZCBpdHMgc3Vi
c2lkaWFyaWVzDQo+ICAgICogICAgQ29weXJpZ2h0IChjKSAyMDE2LTIwMTggTWljcm9zZW1pIENv
cnBvcmF0aW9uDQo+ICAgICogICAgQ29weXJpZ2h0IChjKSAyMDE2IFBNQy1TaWVycmEsIEluYy4N
Cj4gICAgKg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX3Np
cy5jIA0KPiBiL2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFydHBxaV9zaXMuYw0KPiBpbmRleCBj
OTU0NjIwNjI4ZTAuLmQ2M2M0NmE4ZTM4YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3Nt
YXJ0cHFpL3NtYXJ0cHFpX3Npcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zbWFydHBxaS9zbWFy
dHBxaV9zaXMuYw0KPiBAQCAtMSw3ICsxLDcgQEANCj4gICAvLyBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMA0KPiAgIC8qDQo+IC0gKiAgICBkcml2ZXIgZm9yIE1pY3Jvc2VtaSBQUUkt
YmFzZWQgc3RvcmFnZSBjb250cm9sbGVycw0KPiAtICogICAgQ29weXJpZ2h0IChjKSAyMDE5LTIw
MjAgTWljcm9jaGlwIFRlY2hub2xvZ3kgSW5jLiBhbmQgaXRzIHN1YnNpZGlhcmllcw0KPiArICog
ICAgZHJpdmVyIGZvciBNaWNyb2NoaXAgUFFJLWJhc2VkIHN0b3JhZ2UgY29udHJvbGxlcnMNCj4g
KyAqICAgIENvcHlyaWdodCAoYykgMjAxOS0yMDIxIE1pY3JvY2hpcCBUZWNobm9sb2d5IEluYy4g
YW5kIGl0cyBzdWJzaWRpYXJpZXMNCj4gICAgKiAgICBDb3B5cmlnaHQgKGMpIDIwMTYtMjAxOCBN
aWNyb3NlbWkgQ29ycG9yYXRpb24NCj4gICAgKiAgICBDb3B5cmlnaHQgKGMpIDIwMTYgUE1DLVNp
ZXJyYSwgSW5jLg0KPiAgICAqDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc21hcnRwcWkv
c21hcnRwcWlfc2lzLmggDQo+IGIvZHJpdmVycy9zY3NpL3NtYXJ0cHFpL3NtYXJ0cHFpX3Npcy5o
DQo+IGluZGV4IDEyY2QyYWIxYWVhZC4uZDI5YzEzNTJhODI2IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Njc2kvc21hcnRwcWkvc21hcnRwcWlfc2lzLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Nt
YXJ0cHFpL3NtYXJ0cHFpX3Npcy5oDQo+IEBAIC0xLDcgKzEsNyBAQA0KPiAgIC8qIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wICovDQo+ICAgLyoNCj4gLSAqICAgIGRyaXZlciBmb3Ig
TWljcm9zZW1pIFBRSS1iYXNlZCBzdG9yYWdlIGNvbnRyb2xsZXJzDQo+IC0gKiAgICBDb3B5cmln
aHQgKGMpIDIwMTktMjAyMCBNaWNyb2NoaXAgVGVjaG5vbG9neSBJbmMuIGFuZCBpdHMgc3Vic2lk
aWFyaWVzDQo+ICsgKiAgICBkcml2ZXIgZm9yIE1pY3JvY2hpcCBQUUktYmFzZWQgc3RvcmFnZSBj
b250cm9sbGVycw0KPiArICogICAgQ29weXJpZ2h0IChjKSAyMDE5LTIwMjEgTWljcm9jaGlwIFRl
Y2hub2xvZ3kgSW5jLiBhbmQgaXRzIHN1YnNpZGlhcmllcw0KPiAgICAqICAgIENvcHlyaWdodCAo
YykgMjAxNi0yMDE4IE1pY3Jvc2VtaSBDb3Jwb3JhdGlvbg0KPiAgICAqICAgIENvcHlyaWdodCAo
YykgMjAxNiBQTUMtU2llcnJhLCBJbmMuDQo+ICAgICoNCj4NCg==
