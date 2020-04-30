Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E2FC8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 09:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41DA2082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 09:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kWk0vPz5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uZwQ3kew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD3JLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 05:11:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20242 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgD3JLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 05:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588237898; x=1619773898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kJHPRZ/fAxtVMiUVgWSrBpMxyCzup/fiwspTh8abZdE=;
  b=kWk0vPz5yh72umxIJhVVur75FJWEooV6F2QiNyQ9w7YarkTHYaW5fiGw
   MEJrorCv1HF0J4P4JbfqlVTP9JX6CSAfJqttFr9D2CQqYsUMbZgItHLk8
   SU/pfhlfxK4jrz3Hk2XR6s5UqAFgAvyFqVMuoB5W9v5GWUBwCDkEc1d73
   2GPdxWqBikBwf2QWW8dhPNpbQ1Pl6kC0RtRJS17AAPjdgx29yW3qhAXzf
   3xh8/xcW9KyOPs9Nv/GUqhwqfstf1NOyS1pL6lh0XBf+BGMH8o3EMw8Qd
   iMVbfuqsLwjRepLjQVSD+luo1oPYYDJBTv+qIZaD9xGiidjOQpDHYv2o3
   w==;
IronPort-SDR: 5JmFdMxN+kjoczx7hcxK2ol4MlTS3PKI8Giy8ZUK1RwFu31Uzr859H4ACep6Ki2mwLrK/0DLT0
 DP/JIUx/u8I70mvSfpakqO9S/P2CKJijHinm5xKYg38rVqWV7Q/vRsUqfuGJZdZQ7Dq0RJxkBj
 QxluFGfOlrhomPpfVUHFN5vRPHmqp+1LNMB1um6LUA1N82v45lxyeK7Fl2W7i3e0UcLom/jg8R
 F+gw804dmu9hknMYePxW+5LpmufrqWn+QIG8RwJryYim8ZpheRB3XPONVoGk7EunB9VXjeUCeb
 umU=
X-IronPort-AV: E=Sophos;i="5.73,334,1583164800"; 
   d="scan'208";a="239120862"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2020 17:11:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCu+Nxpda6yQHn6VFAopuZUevXqLTg0cnlO9/Ww7fnvEE885telpryeMcNZ9PcZrsoWfQ7HABNKGfAhs96Du8tVZJKDXbKaxeYvrJLkMJ2FsHuAencnZ6ZnqGlOQXRiDdykeOQkl6i30JNDQaa6D83yCMtOVX6UIkvBgrXksx/V+9gnCAylNWN+NDNqvP/0Wr+xnCfyqp0Y3pM6JzjoCk9FYu+tpf0ZdvKrzEg7DROEK0rRNf8DxPEqNoKqrOAnySKj0AN2TqpdE1K6Kb4I8+AIaH+DC9xAM+3Pwoyov4nTsFvQxgubrnXl5jik4vlZzVPTK0n+0ZtMaNmPz9i1m1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJHPRZ/fAxtVMiUVgWSrBpMxyCzup/fiwspTh8abZdE=;
 b=TE7fJys2F0OphjVOEyevr4oNwJKZ6LICNbLsC6ME2yADsA98QmzbHSRMKAwMoL2Rzl6JCnOkeD8lQ+b+Eok+Yr5y4IAoprniSCVOi+VqncPzwqHHnA7BUp/xLAydb9Yg6SBGVHT4pFKICW08eA4OkWGQbwaOhv5f0HHmfbGzfrwWWpGDBuPm4M7LhK4Uztr3N1AiB7K3qmleFrc7udDzpu0puRI1f7rWE61xjPKNyCrIiT5ieEnsGDxBK+Az6QCujquDYcJ3J8xFqr9P6w+xunxQC1/LTWs5DA+DfcbSdryGDce6yiRqN6eaYajQbQcAQT2uhvKjv4EEw8nGhL8DDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJHPRZ/fAxtVMiUVgWSrBpMxyCzup/fiwspTh8abZdE=;
 b=uZwQ3kewE6P5voiI/UrZffpg0cVwKSiWtCY5QDVRi+a+RHcOsIKLLvihbXAE+0RVHLy4hV94wr0k8X+FuDK7B4dTUxP7A1aReml0/68h8cwknXwox4b6jejmSwel9QGNx8zgB3PZJscuFGkNhS5OqQnvQVfyg9NkSAtqYgT+qQs=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB5270.namprd04.prod.outlook.com (2603:10b6:a03:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 09:11:17 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 09:11:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
Thread-Topic: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request
 queue during system resume
Thread-Index: AQHWHqVGSF91HyU4vkOwo3Qg+cIe4aiRHZEAgABCtJA=
Date:   Thu, 30 Apr 2020 09:11:17 +0000
Message-ID: <BYAPR04MB462931F8DF1112CAF7F80CA4FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
 <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
In-Reply-To: <9e15123e-4315-15cd-3d23-2df6144bd376@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9306f963-643b-4c6d-bb3a-08d7ece670a3
x-ms-traffictypediagnostic: BYAPR04MB5270:
x-microsoft-antispam-prvs: <BYAPR04MB5270A81A543669C082AC4296FCAA0@BYAPR04MB5270.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(53546011)(66946007)(66446008)(5660300002)(64756008)(478600001)(7416002)(9686003)(76116006)(52536014)(71200400001)(86362001)(2906002)(6506007)(26005)(66556008)(66476007)(186003)(7696005)(55016002)(316002)(8936002)(4326008)(33656002)(8676002)(110136005)(54906003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oXq99EymvX86gdRnMF2NwSRS4pU19O9OKHiZhEMTVn8zUZ7D9Uv7aEoQ7QlFYxyHSZ8GVyWioOXbrpmdgFs8eiJI16BuWSSLrHtGeEnQ3QR9HuftW9YMkiFjzcpRCQhsgv4rxMIirBtqSW3XYhL/dVs7YNXtjwNYdW9DpCu5SucewiUraCw7GoaDANPiHv3V7i+C1jJHxnMue+E3USyRLFuxVHAFQDfcm3yVpiPHgajEVq04+WW0GUKkUTBWlN/yLk70s3hfJf7MwyaG6Mzyp85VVWnrebjU2lWqeW9TrCGDM29aGz1wlAuUwh3XLx7aegmMxdTm66sNgWHUk6v2xVCK8UUPmq659mxqJuVaU8/iKki5e/juXfW94daBOaIxapsUM47lt0Coo3GPMFgjZrDu5oXUCxcWIzAeVWFSZzARDO/U8pYX1aA4xUkJnVA2NlONymjbZ8IEfhG4f0VXqs3mdFv3ET8iiEoP4WkSVVs=
x-ms-exchange-antispam-messagedata: F1NuzIyQiJsQZ/FSSNj+prGAhsNu5LFw9W/YHER53fK7TtGX6mFhMhTnGKvNQOUUEkqcw1TgZ8yUFgi39xyIH18e3jEXcwjPtQs06KgEp3cMkNygrihpoAMsDJnNNewqZ8xNY9ts2ZRpmYdONn1Ro137zGuG6TPgiAswBYgmPsd5ll+pK+5kwLVYXvLsISpKBaQqDlCt6kzyizKBwqcznaxv67Lhfxrqc2pDC/orx7xKoxRD/ClmBQI9JKB5jfklC1/X4TXeaM1y6vsQRrDPPjH1EAO1nMQNACQMzNCyvYt0wJrYpT/GR5TvwNBGNaSGtu5RauVJ2NOSwyBeiVHNI1Iuli7C4yOlTS164ATX+VnxQYLGRno/nzjFJmBML8fo7Hy259u5hLHlE+8E6b4jVUwzJdk46DV9Z9CT1wNMzt1xKyooIZiDqgzx8T67qdh5d2rfa8QwPBX5aa20mB7a3NXY1q5b71UxtaI73Newbw06CVJTESiLSz3aSyC3Sp1C1j1MPzqbtxjo4Ba8344f8P3EqQ4/RoeeeqtnrQDnB6+9YmWXgbCj7Eqx+tppHcahMvWfQIHG/hH6ZGqdBsfXSWWiKEZsGSfg084uGC4W7eZ8jjN9mjKd7xwvv5PN2CX/WhGsH6tFlTBf/RkW/hpfMARN0Cn0W/GNvNBdo1+ZJw98NouCj618hUDBWdPKh6s1s5qCEVxlMQVmXpg23CRQ8c0zSg5cF/UgQxPnt2x8YqPoh3Yg/l0edqgGo5mv5WSL9ASYlti4DkQw2Zy+3nKdHPSEvtiYpdnokIm71pm4tUo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9306f963-643b-4c6d-bb3a-08d7ece670a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 09:11:17.1197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GNeu2eoHsL5jQpV8W9O734/ZAF+eF3tIL41oYhCbtpPe8vQaKgW7FdyVUL05KOpD+RjXeKYN1NKy4My5TGYtQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5270
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gT24gMjAyMC0wNC0yOSAyMToxMCwgQ2FuIEd1byB3cm90ZToNCj4gPiBEdXJpbmcg
c3lzdGVtIHJlc3VtZSwgc2NzaV9yZXN1bWVfZGV2aWNlKCkgZGVjcmVhc2VzIGEgcmVxdWVzdCBx
dWV1ZSdzDQo+ID4gcG1fb25seSBjb3VudGVyIGlmIHRoZSBzY3NpIGRldmljZSB3YXMgcXVpZXNj
ZWQgYmVmb3JlLiBCdXQgYWZ0ZXIgdGhhdCwNCj4gPiBpZiB0aGUgc2NzaSBkZXZpY2UncyBSUE0g
c3RhdHVzIGlzIFJQTV9TVVNQRU5ERUQsIHRoZSBwbV9vbmx5IGNvdW50ZXIgaXMNCj4gPiBzdGls
bCBoZWxkIChub24temVybykuIEN1cnJlbnQgc2NzaSByZXN1bWUgaG9vayBvbmx5IHNldHMgdGhl
IFJQTSBzdGF0dXMNCj4gPiBvZiB0aGUgc2NzaSBkZXZpY2UgYW5kIGl0cyByZXF1ZXN0IHF1ZXVl
IHRvIFJQTV9BQ1RJVkUsIGJ1dCBsZWF2ZXMgdGhlDQo+ID4gcG1fb25seSBjb3VudGVyIHVuY2hh
bmdlZC4gVGhpcyBtYXkgbWFrZSB0aGUgcmVxdWVzdCBxdWV1ZSdzIHBtX29ubHkNCj4gPiBjb3Vu
dGVyIHJlbWFpbiBub24temVybyBhZnRlciByZXN1bWUgaG9vayByZXR1cm5zLCBoZW5jZSB0aG9z
ZSB3aG8gYXJlDQo+ID4gd2FpdGluZyBvbiB0aGUgbXFfZnJlZXplX3dxIHdvdWxkIG5ldmVyIGJl
IHdva2VuIHVwLiBGaXggdGhpcyBieSBjYWxsaW5nDQo+ID4gYmxrX3Bvc3RfcnVudGltZV9yZXN1
bWUoKSBpZiBwbV9vbmx5IGlzIG5vbi16ZXJvIHRvIGJhbGFuY2UgdGhlIHBtX29ubHkNCj4gPiBj
b3VudGVyIHdoaWNoIGlzIGhlbGQgYnkgdGhlIHNjc2kgZGV2aWNlJ3MgUlBNIG9wcy4NCj4gDQo+
IEhvdyB3YXMgdGhpcyBpc3N1ZSBkaXNjb3ZlcmVkPyBIb3cgaGFzIHRoaXMgcGF0Y2ggYmVlbiB0
ZXN0ZWQ/DQoNCkkgdGhpbmsgdGhpcyBpbnNpZ2h0IHdhcyBvcmlnaW5hbGx5IGdhaW5lZCBhcyBw
YXJ0IG9mIGNvbW1pdCBmYjI3NmY3NzAxMTgNCihzY3NpOiB1ZnM6IEVuYWJsZSBibG9jayBsYXll
ciBydW50aW1lIFBNIGZvciB3ZWxsLWtub3duIGxvZ2ljYWwgdW5pdHMpDQoNCkJ1dCBJIHdpbGwg
bGV0IENhbiByZXBseSBvbiB0aGF0Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IEJhcnQuDQo=
