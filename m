Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B63EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Jul 2022 07:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiGXH1g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jul 2022 03:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiGXH1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2022 03:27:35 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB863183AD
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jul 2022 00:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658647654; x=1690183654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ALwB9ZpkVRU0Q+uM74mvv/0j+uFg6u37Id9mu6xNBss=;
  b=WpOK9hgEj5z4TA7eALsjydlrSDFUdRemg27G9GqQQT6TGCS6WJkSxxiG
   mEpIiLmWH8q25Qk7aeT7733aW3/BDtKrWj0Q/zNpQc+dqFVQWii8BJ+2c
   mADV7AfnoX40KSZockPG3eNIESUk5nwV1/64RGfUdyrd9hAqKfLTFOVG4
   H4zyE0zLNV8yNlH331ecgRST3ZqWYUzjAR35VfRhqx4dofq1TZqJTDlaR
   PZzd8OFlBffr+UwtQdDZ+BJdqte5Bav+W8DPIGibN3TZ23+CRV18CAS/9
   wNdi/ZGaWMdZbGD3vW6zzftqBLU+sYl8vjuK4tG1WG77Ut/A0bTkg2GTb
   w==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654531200"; 
   d="scan'208";a="205312694"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jul 2022 15:27:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/9lJ6B73DT8EqtZP42vTB34zIza7xNrYPswavroWxXZinhCRvTxzZihidJE+uAITiEInEZ6PghyQNAszku3UE66SJugRQB/rX2MKpr3zAQe1Ogq349p70RNdATAROiKjBUaBwWhRY8YllW8ik0z52SF65gyWiu6dpAXS2XYXtNEGnFyajuPyMxYeAXmZrhpHn+ya+f0RQtGpMAya/nvfQBoHhIJGO8c0TRDH0kNGZdZ4A4eV0D1Ss2KfwtISFXwZcgPYR6p3Z+UlL2D7tjiTtI+CRSDoRORodce5Leqff0Ex4sEtUqax/of86OjEL3CoUgw5+qw+PRfrYyrebQtNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALwB9ZpkVRU0Q+uM74mvv/0j+uFg6u37Id9mu6xNBss=;
 b=O4Ghn+lnuNiQvqKTbr9cxTV5Me1fmDbkxIv+Cty2i8TFt2EQlNRTdag7HAzROyrXa0XdeUSm8ETrHUYcZBgK8miQmDnbVFTw0tUIEC2YPlpbWo0mqyP7IQhRbF28Exgj62kO/sevEOMVED4Ok6M5ADczPAOGJaFDXpCz1CK8GwSv4azwjb1NZJPiS0RCotrwT1gIvDCI2Hr+MsF54esMFL74cKNfP7M/KCqvyYxY0kg+B9/gmAPz+zolnGA9s+oQduw4Fv3oEleNe5J/jUDw9KXbf65KY2Scqnf+p95gGbNKkBpLFcZOikUC9yzWM5ihhnMcH2PseRNePyJcNtck1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALwB9ZpkVRU0Q+uM74mvv/0j+uFg6u37Id9mu6xNBss=;
 b=gxAfHvYkIwD4DWaJxlgwsTu/BVz++LaYjZHX9D9BjLTxw8H1hH0ZFdM7EiK7+sIZyK1vUNpFTbt7hfnkBOPlRD7lXa9rqLC7876AkUQM6GKm9WOKE1lBOwjGDPxx4kMd7Pxhkl4p/TQyq0H4FsybhXthcbdjJLAE2IWuE4J/qZA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7635.namprd04.prod.outlook.com (2603:10b6:303:b1::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Sun, 24 Jul 2022 07:27:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%8]) with mapi id 15.20.5458.023; Sun, 24 Jul 2022
 07:27:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYnFqlEXib/0bkm0WwZ/l/9PK7Za2KD59wgAAedrCAAHueAIACejyw
Date:   Sun, 24 Jul 2022 07:27:28 +0000
Message-ID: <DM6PR04MB6575783FCDE3596D0CFC95FFFC929@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220720170323.1599006-1-bvanassche@acm.org>
 <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB6575D4AE8FC800F0A7429AA8FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
 <69a25298-5c2b-6efc-2a5a-9a2409d69b4b@acm.org>
In-Reply-To: <69a25298-5c2b-6efc-2a5a-9a2409d69b4b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab0b9e07-de00-42d7-51f9-08da6d45f67a
x-ms-traffictypediagnostic: CO6PR04MB7635:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWhn33dFbg6CdRHV6jaFDm7bfer1zk0ZDg/tYHEdhgXE6DaR5U0GxLwFptsab//++MgWXjDVoQFXG+L5n9JPzbVYuNFaladJcEF5ZZ9hw2m9nt5/bZIT7jk4QQ2drb0dolYTW1yPsywo6QS/uWSVcTnsolKAaVgZqTzfns+xbCkatr4HmVFGho6MBcsJrIJmojR9DQFpCQmFmohVmhW577bAOAtPw4efH6eblQtegS8lNQD5XwEFuR236FoQonFSG0D3pnaowtRcQiIUUmY0k4BJzozSDEMLUQj2qG7+kgkhDVvI08IGSKwzWCPboZVOQK0ElenhNvaKMT3ZURKNqYv9OU6Bdtg0Hqpj7n8fiGkCg+DOEtWrJfYAfGRwNo7WMlQQoX1+Gy/UIisYjNGTlnfKFelfmeQ++UyxxFT+e6DI5qpeGEZpCVdKIvpzvdQxeBCeajZ25EWKd2oj/XTIAxqobqI5WWp2pidKWF5zMRggmMhgEsp+/3YpoVZl2zC9tNiCEG8hEQZelvBYS8TMqFzfXbHLEDYLBhKGc2kCIXsLOrYw3NNx8fL574lKKI2rR/q/CEpGak08LKgkQZrysw2osl2AxeKCNzy7Mq/NvY2QJqzT4bF8QbQ37EDSDldscs0P/fP8nfIdLgAJr5DU2d3Z8MHnofiyJN6M0Ye2Kcg6trV7gWV7CO6uRb7y0g81zJW5VH8v8pZje5c0f7s0VXBSi/5QP+UuU3CIPyIhgYQDqOS6Qs+LrL1f1Kl82NTO/Grir5VfBUQ8HcKtlI9TleEy9bDZ+FGW10IwlnDKo516ApuiZqiHyNJ4KekgoS9R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(84040400005)(186003)(55016003)(83380400001)(71200400001)(4326008)(76116006)(66946007)(54906003)(8676002)(66446008)(64756008)(110136005)(66476007)(66556008)(9686003)(41300700001)(7696005)(6506007)(53546011)(26005)(2906002)(33656002)(38070700005)(86362001)(38100700002)(122000001)(8936002)(5660300002)(4744005)(316002)(82960400001)(52536014)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHg5OWxqa0RDbnBVTEpFRDUyOXpldlpRUG9EU3JmQVF6NHJKRlpBTTRQbnBF?=
 =?utf-8?B?ZTBSZ3VjRWdNSW05dVgvbWRPSkJHa2c4ck82dWlEcllIWUtKOVJWTmpNWXlt?=
 =?utf-8?B?TUd2WUtUdmY1TnJpb3NqVnVXeW00cDE3SnJVMVJNa2tTMHNYTUxET1h6cFln?=
 =?utf-8?B?TEFIUzcwM3Jzci9IZXFNa1FCUGZsdXBBU3dOblI3U1ZnOFdkVjQvb0dCYnB0?=
 =?utf-8?B?bVY5c0hHYklqNnJMV2lMYkdBQy9qc3ZGRnFGNWFqdlpQUjNrM0hLU3Z2eHN6?=
 =?utf-8?B?eExKMnBhU3VveFFCMElsbWtPTkh4N3YrMi9WMDdwNkI3bENXUkRxcUxQRVhs?=
 =?utf-8?B?UFVWRnZQYUZuZ2lHVVh3aURFVmZZUm8zalUwUzkrckQ1d2dENEN1QTRHL0hp?=
 =?utf-8?B?TjI2c3JZeFNBR05KclJYU3Z2ajNnY0FZaVNpZWlnejFCRmJpUUR4MFYxM21k?=
 =?utf-8?B?Q2ZQaW10SjBMQUE2dDY4Ym1HVVRQbjZCRlUrYk1wQURBR3pVRWhNd2lRc0RE?=
 =?utf-8?B?U2JTbWF1eDJqTVpPc0hJMnhlejI2ZFRWdldvNDV5Y1lJU3FwV2FyRUV4V1B5?=
 =?utf-8?B?NjM5MmIydEtyMzhEOStBVjV3VDV0N0UraWNaaHR4aDNUWGpEaFExMCtiSnNn?=
 =?utf-8?B?a21GcGN4bGdNL09ERGhKOW9jRktVYUVGUGk4dDM4ZFQxLzRPaGgrUnFkNkxy?=
 =?utf-8?B?WXhucDdodFJhcllaYTlQeHUrbmNWQ1J5dmxYckVZZ0hTbGxjeExycHZWUjNR?=
 =?utf-8?B?VlMxQmFxL1ZZMzhtL1BmUk5VVy9qTFp3UUNlNWZZS1E3V3BJaSt1ZE93RFlX?=
 =?utf-8?B?cGFteXA5ZWZNTUxpTFAvOG5aM0lWWW85aDNtUzM3cGR5V1hqZVpsVU9hN3pp?=
 =?utf-8?B?MWNzVHloVnJaY2l2YzdhWUo0RUZzWU1WdVpJL0ZBU3BKREhLTVhpM04rS0Na?=
 =?utf-8?B?SHFjRFYzVEZwRnVGYnBpeFJDRUlQQ1Q0OXZnMGJ0OVdCcjN4QlBGb3VFRGJE?=
 =?utf-8?B?YjZ0b0V3N1Azdm8wclZLMFp3cW0rU3o3U2VOVHh6d2VZTWNTZUNpUkJxQTNC?=
 =?utf-8?B?aC9vbGg0L3ZlRUE4NXJXc1dZazVGa25qb0NrenFnN2h6ajc5Y3VKc0xNaWR6?=
 =?utf-8?B?TDl5OU9uZUFMdytHZGNLNVFCZnVoT1A4VENSTnVac2FRTy8vY1hvMXNFU2xn?=
 =?utf-8?B?U2tmckdndUpVUmVuMnJCaGhKYy9abm9BeEM5c0ZYc2NLanM2Z2lpdEFlRXM5?=
 =?utf-8?B?NDF3cUwwczRMdlJBV3h5VUIrY2Yrbi9NeG45NVVZYk9qemc1NzExRVBkRTJ2?=
 =?utf-8?B?a0tYYVNkL3VTcUY5R3QwcGoyc1p6VFRrVG0wcFVxbDJsYVJRdVh2YlAva3o2?=
 =?utf-8?B?YlFyZkMyMW1qZkwxcm5Hd1dZaGxEOTB0ZTR3T3Y3d0dsekpUNU5NU2c3bUVs?=
 =?utf-8?B?VUlIcXBUNUNmMTkrZ25pbjByb0x2ZThxVkZXVHg5ZEpOZTVtTW5sVVlCS3Vs?=
 =?utf-8?B?M0hWOTZNcEd5NkR0cjNPdnliMkEwbmhGZ1BOTjlxSE8xSHlING0rengzNTRh?=
 =?utf-8?B?TTN1WGJtRnMyTU1EQVAyNnRBVUVjTEZkQU5HYk1wLzhNMVEvQWVrWUVBM1or?=
 =?utf-8?B?OVlLS2J2YzhqMk5pT1VFK3BWbVRWQ0QySGJpWUhZNHFNelhaaHRnRmhEc2I3?=
 =?utf-8?B?RzZoUUJudm1ZbVQ5YnZ4aVhOSzBQVVk4MlVoWTNja1RLT201dVNwaENYdXZo?=
 =?utf-8?B?L2NrVGlGdWVaNlk1MFZYakt5VHJlcHRyWTVBdC92M05aZlhGY0VHUVpkYUJH?=
 =?utf-8?B?WXEreFdpdm9RRVh0WS9vcGpkOHplcXkxaTI2TXVCRTZ1NG1weTc3SnFKbGxx?=
 =?utf-8?B?aUl2RUpwRThLOTd2YVZUWFNodkxJbTJIaE1pU0pISlBuaHVzOFd4aitNN0w0?=
 =?utf-8?B?TDRNdlhIbDFMNEFodGk4UzNUMHBVRmIvTFROTWNXbFdwMlY4MHRrVHFJaGhh?=
 =?utf-8?B?ZlU1c21qTHNVV2I4RGFyYU5LR3hIT0Jrdis0SmhmcG9ZTFk4UXVOWmpZY2Zn?=
 =?utf-8?B?ZVB3VjRmQlhPRGhHRU5Gai9pYmUrVVFCWWUyT3F0K3RCZFhZMjNwdHdER2lT?=
 =?utf-8?Q?yif/bDIyfEfCSNZk4Qo7WHE+2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0b9e07-de00-42d7-51f9-08da6d45f67a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 07:27:28.1105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tryruUt/o/6FHOo7EnlNkVlvx3xAg2ZiTlHxs236SPP5Oc3nPQ3w0Q+MY7MttnHiEgpZk8RgfIZ6DLP2yueWwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7635
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gNy8yMi8yMiAwMzoxOSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+PiBOb3RlOiB0
aGUgbWF4aW11bSBkYXRhIGJ1ZmZlciBzaXplIHN1cHBvcnRlZCBieSB0aGUgVUZTSENJDQo+ID4+
PiBzcGVjaWZpY2F0aW9uIGlzIDY1NTM1ICogMjU2IE1pQiBvciBhYm91dCAxNiBUaUIuDQo+ICA+
DQo+ID4gQ2FuIHlvdSBoZWxwIG1lIGZpbmQgdGhpcyBsaW1pdCBpbiBVRlNIQ0k/DQo+IA0KPiAg
RnJvbSB0aGUgVUZTSENJIDMuMCBzcGVjaWZpY2F0aW9uOg0KPiAqIFBSRFQgbGVuZ3RoIGlzIGEg
c2l4dGVlbiBiaXQgZmllbGQgc28gdGhlIG1heGltdW0gdmFsdWUgaXMgNjU1MzUgKGVudHJpZXMp
Lg0KPiAqIFRoZSBtYXhpbXVtIGxlbmd0aCBvZiBhIHNpbmdsZSBkZXNjcmlwdG9yIGlzIDI1NiBL
aUIuIFNlZSBhbHNvIHRoZSBEQkMgKERhdGENCj4gQnl0ZSBDb3VudCkgZmllbGQuDQo+IA0KPiBT
byB0aGUgbWF4aW11bSBhbW91bnQgb2YgZGF0YSB0aGF0IGNhbiBiZSB0cmFuc2ZlcnJlZCBhdCBv
bmNlIGlzIDY1NTM1ICoNCj4gMjU2IEtpQiBvciBhYm91dCAxNiBHaUIgKGFuZCBub3Qgd2hhdCBJ
IHdyb3RlIGluIG15IHByZXZpb3VzIG1lc3NhZ2UpLg0KVGhlIHRyYW5zZmVyLWxlbmd0aCBvZiBy
dzEwIGlzIDIgYnl0ZXMsIGFuZCBJIGFtIG5vdCBldmVuIHN1cmUgdGhhdCBydzE2IHN1cHBvcnQg
aXMgbWFuZGF0b3J5Lg0KTWF5YmUgaXQgd291bGQgYmUgbW9yZSBwcmFjdGljYWwsIGluc3RlYWQg
b2YgMTZHQiB0byB1c2UgMjU1TWlCIGluc3RlYWQ/DQoNClRoYW5rcywNCkF2cmkNCg==
