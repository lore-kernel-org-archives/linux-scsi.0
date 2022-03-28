Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDF0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 10:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiC1Kys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 06:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiC1Kyr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 06:54:47 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE2F4E387
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 03:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648464786; x=1680000786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ndeulbY+tLEgcAGIuDm/3zY93WLBZsS3w28rRk/edcY=;
  b=aq8P1AOcpFb5m115E5DoquRXYxZetNMVrMgXViY0pWwuna+ddAdSaTLO
   lr7LcWZWBOD48Qn7g+7u1kvCL3cJzAwmvsL2uJIBfZnWUSfDBYBQxtlE2
   VcpTdoFYfWrHVRX6Bd+VMsGWPryQ8aTtIneJrzI5l1Zfq1PEFcFrRyQxe
   /c/etrU3YqtTRVEcdEKMhkLYVD+6Mkdw0WNEwyZN2FwjaT8779NEzsEZq
   +UIXeK04UksW8v1q+NXdqIJCx+CiFWBWA2EKoiSTteAT1oE4e4AhrKe2u
   fqshz70hBVhauUzXUZ3PXLc86YDxXa95mq/CQ44sRo9YFH/PHXCzRc8+m
   w==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643698800"; 
   d="scan'208";a="167335240"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 03:53:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 03:53:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 28 Mar 2022 03:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuULXPE1fyd0h4nK8YAjHoiy05CFaUWMTWoNjHQZMDCbcJBchXbjVSQdDXrrBSLTMlqjtyOyakpFswqh/jAV1NP3TLtbq6Q4JuAati+WduQIp808H/D94a6qY30vKVckVpmlsly6+5ocAnGeBrtf7c6FLlLUzVpYY+c1Y9sPjkorpwYH0edQ+6JUNs4Sgi/ab1P5rVNBce/sunzEVTpnQ/lEVYOxruodiwjl43SQLPwpcYjzG7EJe2sSSfK+vYxvwHH0nzvMi8oFxCg1mVek4+w8rnFEumOo9Ye+dDPYj6u7MojP9ARceqJ8AeP0GN9natvOFt8NV3LwclWg/OsjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndeulbY+tLEgcAGIuDm/3zY93WLBZsS3w28rRk/edcY=;
 b=eiQ7sQIsuVFh7Sirt2Y3PsIOgrbTvF0mXmvNtKiH3a9NrzcwqAZGUQ+kCpiIjKu8BP5rhacS5+SSFb1h6F8k+uk+nU0Ds2ovoe1DPWl6EUncIFsZ6Ngd9CugoNKLtiRpZZrrURtfUEHt/FXXDX4lyc62QJyoT9ol73kKrj584YedGWE1zuZ52wPESJcCkvKe1hsZ7bBl+XrFi1spwkNgvxVLD8YrsNipOFa4OWJhONle3cpllfyGyq6qGn8ObHM+OkHktOHM3KU65x5FwMIejRkV9S2nRR8KZWlTUqcVV+tU2yvGB1zp+wxne6d2AX7Zkgro+PcpsU9cRsz/VuqReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndeulbY+tLEgcAGIuDm/3zY93WLBZsS3w28rRk/edcY=;
 b=Q0Eu7ymVPZ2lSpYw05dglLaSh0isqGEpSvyEvObNgJhL1OUKsWwXEx5fD/qr8n/XzC4M0XHBm1JkNbhbZqFs+3LdqftNJLgzH8BdJtM23dNV4VH5GdbjBBNBSmM3o904avR8SJOEcz5fMJllq6VfLCrDgbZZlaBFFrctoejN42g=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by DS7PR11MB5992.namprd11.prod.outlook.com (2603:10b6:8:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 10:53:00 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c%9]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 10:53:00 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <jinpu.wang@ionos.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>
Subject: RE: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors
 32-63
Thread-Topic: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
Thread-Index: AQHYQofEzWnn/sUJi02WWvj0FJklO6zUnp0g
Date:   Mon, 28 Mar 2022 10:53:00 +0000
Message-ID: <PH0PR11MB5112C3127B63AA843279185EEC1D9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-2-Ajish.Koshy@microchip.com>
 <CAMGffEnQr0cQSwJ2ionZrFwLPb7Uvr8zby+y76+BDAX5E9jzbg@mail.gmail.com>
In-Reply-To: <CAMGffEnQr0cQSwJ2ionZrFwLPb7Uvr8zby+y76+BDAX5E9jzbg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9be4620-a851-4469-e474-08da10a9207e
x-ms-traffictypediagnostic: DS7PR11MB5992:EE_
x-microsoft-antispam-prvs: <DS7PR11MB59924AE1BE4A4CF31FD12ABEEC1D9@DS7PR11MB5992.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vIgVWgUB4EWS4hVaq4R6dzhswnzlYz7r13gXFLDluXfcgdN7gsXokwtjxehw5js0tVgi5qz3n5p7VRfWoJ5w6xdJGFRZUY7I6iWEl+vcVzTFgUqWlt9RnoFkzfZFx6uLx+LOMLUyjrc+esixnhZGTnZLDMTC/AOOPz4gDMzBiR/meS4sk+oKp3H3vDK+NkyUKGutXvswSWMkvvgo4svjoRdSa1jx1+LJCFy4KuWj+JhREUvTftMZE3VombSqDmFiA4q4pHSlluSdGz7pXpEdo79zuYc70H3dKH3kMHEm3t1/VinetBTG0xyaRtDlPWnw1Xsal6aedZsrRyqZi6PChHqs7jH7IKJAuhEpXppy44PAYAX4HRJR1neeOEVgsQjJzJqJp9ssdj8jfvAnBldw/gHPD/CP/SdwYD55Gx2dZDdES5XXN4B9JmPa24rRY23tEUiW5G6/+2XFXamKZNrXtGUmnK9pH9lbMfX5fcE2+ecMs5XiglIltGYn5yTgil45Z0DePdqqS4msirRlM1spL39i/TTIt5Dw7y7NyKHsGSKgnbaInHSSLbdTbBY0ba+gM2rVXMRIeWPxWT+aCZ7QTKfKs21XEly3abvxsf5LexxkbOZ5n6Ewbo6tzeyVcnyZq/1R8R+N7Z+s+RlF9Y3hTHJE3nZc9WFECUBQKrnIkyaNN4DQP/LHgYwJPxsY/3zey6aVZ+Jvv+s5q6RpR3lQPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38070700005)(5660300002)(38100700002)(54906003)(186003)(122000001)(316002)(6916009)(83380400001)(8936002)(52536014)(33656002)(7696005)(508600001)(9686003)(66476007)(66946007)(86362001)(71200400001)(2906002)(64756008)(66556008)(6506007)(53546011)(8676002)(76116006)(55016003)(4326008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlhJOUFFV3I3T21ENEpHWWU0VHlyVnM4VDI4SEthRVM4TitnZG1DRzQvUU9W?=
 =?utf-8?B?TzdaNHFWcE1IV1hsNzN0a2UvMDBWa08zNFZ4Sy9IYWZrVFVIUlJpN1UvWnFq?=
 =?utf-8?B?WGhvZEdYc0R2R2c4cW4yNDZCVmxGcUgxMUlyS3lraUw0aDFnTmRhU0ExbVda?=
 =?utf-8?B?TENyUzczQkxqdkcvTlREWUROY3QzRWc3NUlUZE1zbGdQd3gzeWJOWDg2c0NJ?=
 =?utf-8?B?aUU1VWdWbHpEM3NWRldwdVpZdlpqeUhYL2pHS0JHdGFzUmpjZHUvVVBFay9W?=
 =?utf-8?B?eWpWanNkQ3RWOWtubUdVRTBORDdYR1NnSUVNVDcrOGtDYzdTcHNSZ1VlcU50?=
 =?utf-8?B?cWI2TFhIRFFkeEV3N3VMRTExUWlQUmRTT09NWHh6TG5sTGgvWTA0YnFQdzRK?=
 =?utf-8?B?b3FoL1FxNzdQUldoZDRVOWhWMWgwRXUxU2pUTVQ1bW5tRTNTTXRJYlEydjQ5?=
 =?utf-8?B?ekpsbGlrS2V4ejhTLzduUzN3NWpldjRzL2VKNGVCRlBMcHRKbHJhSzNra1ZJ?=
 =?utf-8?B?RUJ1ay8wN2g5OFpuclBtUmFYUnJab1VPWlhJU3FkNnpObjJFRUJ3QkVKVGc5?=
 =?utf-8?B?TXJ3SXY0WnJzS0FIQWVNaTBiQkNvN0tzelo0SHZkWjFISDBkanBtbzJyYmM3?=
 =?utf-8?B?ZE9IQTFJRFNXOFZKckNwMWt5WTcvcFFwRldQQ2pKNjVickNxTFpzWHFFWmhk?=
 =?utf-8?B?ZkRtQ3A1ZW9xRzNNYkpuVnMvWXBlb3FBR1NEODFwdkNyN2gxb1JpbjlNbmZl?=
 =?utf-8?B?K3VLTzZuS0VtRDh6eU12RTFVaGpxY0lDb0kreUswT1QzNlhtS1NYYndTcXZr?=
 =?utf-8?B?MThGU3BCclpVVFAvUExKb2JLbVFQaTkyOVJjT1FqV1hKL3lPcU1aNnUweVI4?=
 =?utf-8?B?U2dGZWxkbFY0NjNrcmU3TkQzdmovWitQZldWclM3SCtBVEVOOU9SWnJEeFdG?=
 =?utf-8?B?czVVMFpUWjNseVRGQ0svNXY0ZGwwVXBVYlJWV1BIMElYRlZmZEEzbnBERzRq?=
 =?utf-8?B?dUFnbTJmS1MxZm5ZTHNHT1htWjhjTDREN3Q0K0VrcEtSVXB4Z3VTY0R6bE9l?=
 =?utf-8?B?N2QrUWQ1eHB3NjV5NDFHc0pkN1NBQzY2R05YT25PVVZuTUhCMjhGMldXM2Fq?=
 =?utf-8?B?QVRqcFF0YVVZNWF3bEVPd0RIT2pORU50SmplTmZ0WHpyWEpacFF0YnQxMlhY?=
 =?utf-8?B?VjQ1Mmc3M2Zjb0FJZlFnejk1QjhNamg2QkdLYVNoYUhZQVBScUpyclNObmV1?=
 =?utf-8?B?Vlo3cElSb0MzYUprMU50Y0JuWDRMYnBYdm84cGlRTVFHUU96VjRhMVBLVjZ3?=
 =?utf-8?B?RStMcVR1bERFR1d3Y0xHczdvUmJTQlRUZG1vdUZoSm0vdWl3cUkybk04cTNk?=
 =?utf-8?B?YkZINkNCb2ZzUEVhbUJQakd4NVh5UmJpd3IrejRVaWcyR0Z2SVJKRHVTZG9Q?=
 =?utf-8?B?SEs2ZzM2MEcrNjhUbUhtdXRHUlRQVGNyOXdCcTNCdnY0bWljNUpiUFhJUE9j?=
 =?utf-8?B?SXZiK2E5WWRrNGQvbGZGN3VwYnZJTmVvWUZERmwzWTRzMmpLejJTUFZLMFJT?=
 =?utf-8?B?ZjZwd002YmlXY2d1NmxJcFRNMWpXekNvcTJZTGRYWUJQVG5ZZllwbm9WbmFD?=
 =?utf-8?B?ajdvQW5HNnFaVjlNalFoR3c2TWFmekljN2Flc3RieDJUMjF3RDRBMld2NW0r?=
 =?utf-8?B?UjNwOTZDaU9mM0pHWEc1TTFpQjdsZ2pKWU5xaVhjUTdRR3czR2FvTXZrS0xy?=
 =?utf-8?B?MzVSMldsZk9tSy9vSHdqeFZoblZmcTUybVRrZEd1aWZPM2s1Q1pYdFBxVG1n?=
 =?utf-8?B?aWtnZE03R2ZVVGQ4bU8vdzFRR0JGTUNGcFRDRjNhVzh1U3JaNWdsSWNpSFBB?=
 =?utf-8?B?OERPcDVncnY2WDhJd2s0MVMvdjkrbHNNM0xFZDZBVUZRODhPNk1nUmF0b0k1?=
 =?utf-8?B?QlM1eFZMbnJOak1LMWhtVlpwNlUwOCtrY3E5YmRJRnZPeHZkR3B6bHRhYU1O?=
 =?utf-8?B?cm8zTnA0ejBRRlREbkFZWGpWRSsyUEVTTVl5U3haeVg4ZlBxa1RRNVZQVUhK?=
 =?utf-8?B?d01HTGx3NWhqUHZzT0l2b3IzRnBGWitOaHlrWW5vL2FrRkhTT1pvSlJobXJv?=
 =?utf-8?B?aXRqa2xDeVF4SXZjUHRxUTJoRXR1QlhSZndUT0ZRZGwvdEFmWDBaS3RVR2lX?=
 =?utf-8?B?ZFh1Zyt1QUo1SWhRT0pjYTExakRkbHcxWUJyQjdwcGtUek9SZkdWbEdqb0No?=
 =?utf-8?B?YjM2Ym9tQzJhaldLeFBDbjVUSWEvZlNZVHd0Y09MMEhDdGtSeDNWUi9nWVdh?=
 =?utf-8?B?WUttRGgvVkd0MWI1MXVCZ3l0ekdOOVVWdXNZOVRhNmxzd09XRHpoVDRVNW5I?=
 =?utf-8?Q?7TTnjhNi+cAIrcgk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9be4620-a851-4469-e474-08da10a9207e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 10:53:00.5801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPnGlLG+PtR47vSXZ4drlMSt7olLhPZlZxIql0ZyfYyQhCsDx59o9gmaib8aCMdLwNxGD79kQRjxYpzGZDHlRKcKL0D4FHSjnHuLEijHLBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5992
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEppbnB1Lg0KDQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlDQo+IGNvbnRlbnQgaXMgc2FmZQ0K
PiANCj4gT24gTW9uLCBNYXIgMjgsIDIwMjIgYXQgMTA6NDIgQU0gQWppc2ggS29zaHkNCj4gPEFq
aXNoLktvc2h5QG1pY3JvY2hpcC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gV2hlbiB1cHBlciBpbmJv
dW5kIGFuZCBvdXRib3VuZCBxdWV1ZXMgMzItNjMgYXJlIGVuYWJsZWQsIHdlIHNlZQ0KPiB1cHBl
cg0KPiA+IHZlY3RvcnMgMzItNjMgaW4gaW50ZXJydXB0IHNlcnZpY2Ugcm91dGluZS4gV2UgbmVl
ZCBjb3JyZXNwb25kaW5nDQo+ID4gcmVnaXN0ZXJzIHRvIGhhbmRsZSBtYXNraW5nIGFuZCB1bm1h
c2tpbmcgb2YgdGhlc2UgdXBwZXIgaW50ZXJydXB0cy4NCj4gPg0KPiA+IFRvIGFjaGlldmUgdGhp
cywgd2UgdXNlIHJlZ2lzdGVycyBNU0dVX09ETVJfVSgweDM0KSB0byBtYXNrIGFuZA0KPiA+IE1T
R1VfT0RNUl9DTFJfVSgweDNDKSB0byB1bm1hc2sgdGhlIGludGVycnVwdHMuIEluIHRoZXNlIHJl
Z2lzdGVycyBiaXQNCj4gPiAwLTMxIHJlcHJlc2VudHMgaW50ZXJydXB0IHZlY3RvcnMgMzItNjMu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBamlzaCBLb3NoeSA8QWppc2guS29zaHlAbWljcm9j
aGlwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXN3YXMgRyA8Vmlzd2FzLkdAbWljcm9jaGlw
LmNvbT4NCj4gc2FtZSBhcyBwYXRjaDIsIHRoZSBmaXhlcyBjb21taXQgc2hvdWxkIGJlIGFkZCBo
ZXJlLg0KDQpXaWxsIG1ha2UgdGhlIGNoYW5nZXMgaW4gVjIuDQoNCj4gPiAtLS0NCj4gPiAgZHJp
dmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMgfCAzNQ0KPiA+ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9wbTgwMDEv
cG04MHh4X2h3aS5jDQo+ID4gYi9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+
IGluZGV4IDliYjMxZjY2ZGI4NS4uYjkyZTgyYTU3NmUzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4gKysrIGIvZHJpdmVycy9zY3NpL3BtODAw
MS9wbTgweHhfaHdpLmMNCj4gPiBAQCAtMTcyOCw5ICsxNzI4LDIwIEBAIHBtODB4eF9jaGlwX2lu
dGVycnVwdF9lbmFibGUoc3RydWN0DQo+ID4gcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEsIHU4
IHZlYykgIHsgICNpZmRlZiBQTTgwMDFfVVNFX01TSVgNCj4gPiAgICAgICAgIHUzMiBtYXNrOw0K
PiA+IC0gICAgICAgbWFzayA9ICh1MzIpKDEgPDwgdmVjKTsNCj4gPiArICAgICAgIHUzMiB2ZWNf
dTsNCj4gPg0KPiA+IC0gICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJf
Q0xSLCAodTMyKShtYXNrICYNCj4gMHhGRkZGRkZGRikpOw0KPiA+ICsgICAgICAgaWYgKHZlYyA8
IDMyKSB7DQo+ID4gKyAgICAgICAgICAgICAgIG1hc2sgPSAodTMyKSgxIDw8IHZlYyk7DQo+ID4g
KyAgICAgICAgICAgICAgIC8qdmVjdG9ycyAwIC0gMzEqLw0KPiA+ICsgICAgICAgICAgICAgICBw
bTgwMDFfY3czMihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUl9DTFIsDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICh1MzIpKG1hc2sgJiAweEZGRkZGRkZGKSk7DQo+ID4gKyAgICAgICB9
IGVsc2Ugew0KPiA+ICsgICAgICAgICAgICAgICB2ZWNfdSA9IHZlYyAtIDMyOw0KPiA+ICsgICAg
ICAgICAgICAgICBtYXNrID0gKHUzMikoMSA8PCB2ZWNfdSk7DQo+ID4gKyAgICAgICAgICAgICAg
IC8qdmVjdG9ycyAzMiAtIDYzKi8NCj4gPiArICAgICAgICAgICAgICAgcG04MDAxX2N3MzIocG04
MDAxX2hhLCAwLCBNU0dVX09ETVJfQ0xSX1UsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICh1MzIpKG1hc2sgJiAweEZGRkZGRkZGKSk7DQo+ID4gKyAgICAgICB9DQo+ID4gICAgICAg
ICByZXR1cm47DQo+ID4gICNlbmRpZg0KPiA+ICAgICAgICAgcG04MHh4X2NoaXBfaW50eF9pbnRl
cnJ1cHRfZW5hYmxlKHBtODAwMV9oYSk7DQo+ID4gQEAgLTE3NDcsMTEgKzE3NTgsMjUgQEAgcG04
MHh4X2NoaXBfaW50ZXJydXB0X2Rpc2FibGUoc3RydWN0DQo+ID4gcG04MDAxX2hiYV9pbmZvICpw
bTgwMDFfaGEsIHU4IHZlYykgIHsgICNpZmRlZiBQTTgwMDFfVVNFX01TSVgNCj4gPiAgICAgICAg
IHUzMiBtYXNrOw0KPiA+IC0gICAgICAgaWYgKHZlYyA9PSAweEZGKQ0KPiA+ICsgICAgICAgdTMy
IHZlY191Ow0KPiA+ICsNCj4gPiArICAgICAgIGlmICh2ZWMgPT0gMHhGRikgew0KPiA+ICAgICAg
ICAgICAgICAgICBtYXNrID0gMHhGRkZGRkZGRjsNCj4gPiAtICAgICAgIGVsc2UNCj4gPiArICAg
ICAgICAgICAgICAgLyogZGlzYWJsZSBhbGwgdmVjdG9ycyAwLTMxLCAzMi02MyovDQo+ID4gKyAg
ICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1SLCBtYXNrKTsN
Cj4gPiArICAgICAgICAgICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJf
VSwgbWFzayk7DQo+ID4gKyAgICAgICB9IGVsc2UgaWYgKHZlYyA8IDMyKSB7DQo+ID4gICAgICAg
ICAgICAgICAgIG1hc2sgPSAodTMyKSgxIDw8IHZlYyk7DQo+ID4gLSAgICAgICBwbTgwMDFfY3cz
MihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUiwgKHUzMikobWFzayAmDQo+IDB4RkZGRkZGRkYpKTsN
Cj4gPiArICAgICAgICAgICAgICAgLyp2ZWN0b3JzIDAgLSAzMSovDQo+ID4gKyAgICAgICAgICAg
ICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1SLA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAodTMyKShtYXNrICYgMHhGRkZGRkZGRikpOw0KPiA+ICsgICAgICAg
fSBlbHNlIHsNCj4gPiArICAgICAgICAgICAgICAgdmVjX3UgPSB2ZWMgLSAzMjsNCj4gPiArICAg
ICAgICAgICAgICAgbWFzayA9ICh1MzIpKDEgPDwgdmVjX3UpOw0KPiA+ICsgICAgICAgICAgICAg
ICAvKnZlY3RvcnMgMzIgLSA2MyovDQo+ID4gKyAgICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBt
ODAwMV9oYSwgMCwgTVNHVV9PRE1SX1UsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICh1MzIpKG1hc2sgJiAweEZGRkZGRkZGKSk7DQo+ID4gKyAgICAgICB9DQo+ID4gICAgICAgICBy
ZXR1cm47DQo+ID4gICNlbmRpZg0KPiA+ICAgICAgICAgcG04MHh4X2NoaXBfaW50eF9pbnRlcnJ1
cHRfZGlzYWJsZShwbTgwMDFfaGEpOw0KPiA+IC0tDQo+ID4gMi4zMS4xDQo+ID4NCg0KVGhhbmtz
LA0KQWppc2gNCg==
