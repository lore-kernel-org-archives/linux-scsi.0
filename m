Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B3CC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFE9320658
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 06:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fzEpzkVq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BRGfqR5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGUGoS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 02:44:18 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:39604 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUGoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 02:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595313856; x=1626849856;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=YvvaXSTSSARqdryLNgdoF8Yk/MOQ2zKncdqUdLrpU0g=;
  b=fzEpzkVq5MnnW3m7M3zbn/Eq/jOZT4fXI1hrV06Y/fsh0XM0F62zf6tw
   C7rdLKXK0BYpcodyk0GfiS4WDAgi2KNhTdqral0yJlFYmipyZWiZu595Y
   QkTG5L+/mNmgmFt8KVzAWJcuE5e3XlbWiALsC/tDVfkcx417niyX982yc
   uTPuMemjxyJhI2MIG7MOzLPc1/vaesQpFQKaGv0FXnGiCAKHzh3B70MQa
   UTizzvIbm6aBDl6vPCz2U6gZUQNZNubeg9kDdQ8vi26YlQCMpFMKRG/W9
   klN90KVytZMxumP3D+6jzwCqVUIKupeVnN6/WEV2GqAjFpf/4hLoUExe/
   Q==;
IronPort-SDR: aZdO0HclTHqib3MdyTcSFxs4XAR3DPFR0ztfpxl834+kc1rxODuNcH5lVrJT6E+IPZz2XtkRez
 pT5G0cK/ALt3NW6+sZUOTLcE+Ve6r8m96QbKeAZiaiJW8XY3ICtyaUnAVCzrS/O9XvA2/Gsadz
 KOpg+fgjUfL20GG25feTCvHwoC9xLQrPB4SLQqVkSDeSfyaQuk9j9/s3LcVlCkCa61VBKB+9vj
 8mOO1XQfRR4S3wLsWancfPN/c+ATgtNwnTGJmlGAJc3n+vjQ3SLbUM56yGrmUoRS5w/rdQcQng
 u84=
X-IronPort-AV: E=Sophos;i="5.75,377,1589212800"; 
   d="scan'208";a="144256012"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2020 14:44:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MV+KoCUxq7NtMMIcOjqWS4nnQm27SnIWGLJ+0AqDfhQbnUy1kUMC+0mRF3uGg5m5JkICjiqCdSHVL3yCEOj+iljqQ3vBQrYxMOJtFQ/+SkWYmiNVfCe1z4Xc7nb00V4/zqOYQrmtoudRSlpM1hy5nwBAqP4KocaJZXJHov40Y2KdeDajm30ocpU2f/f7qo6iW3ZB7ZSilwpze+aGk+NCkIQjShBvQGr5hDC+ZDFx4OKjGw8fQgCunZlPeTl1kEp+d8B8RPOPFqe0i01BlzecH4azynj+6GIJN9FmSA9ee5G0411/O+M7g/TswAaMkT+MBGxNRhVN6GiaTU3IMPSD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvvaXSTSSARqdryLNgdoF8Yk/MOQ2zKncdqUdLrpU0g=;
 b=cbDWUXkHYA4caOD616LcrOTrIds5lT35lK8SALUT/fIogIzLvxsqsWIvreCY4+nniSSCDROVGkAH/a8fZDvh0efzNsiR138xVEAdFeI3HSVv2G8n5Su3Yn0dZnTtQ7TBmoag6WFe2l1hlwesrXUSAmhaWrxzwWTwThcNGvvFPRXHTyH5a2fcbIjk4ASiRXJWqxrdxQvLkLiLSiaNwwypARdws5KSApB2YXlEzcjz2W3FPozJ/E8s56+1yIvwag5sssMsUP2hz4Zou+wIrEdGht1JeSmCnVM8Ompq6eFvqROZjX9hj93DnbwMUrJpKAdppK7vipI/R8PUV17sVjlq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvvaXSTSSARqdryLNgdoF8Yk/MOQ2zKncdqUdLrpU0g=;
 b=BRGfqR5xhv5BC+dJrkdzcxfRB4zZpDpN9vg2KRwDb5C53en2BhlwVnZTT+x4WW9EmA5OYTAhP1NoxPh1JpE7vloZZiXF8sv2+Gc9fed93XWiKvdrlD9cjANPNKCI4Hh4xd6kNwCnZZycw1R9DLhkl9ixeBMHa4w9KPqQkmvuBzA=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4576.namprd04.prod.outlook.com (2603:10b6:805:ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 06:44:11 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 06:44:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     =?utf-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>
Subject: RE: [RFC PATCH v1] scsi: ufs: modify write booster
Thread-Topic: [RFC PATCH v1] scsi: ufs: modify write booster
Thread-Index: AQHWWQeLXwaekXNY8UmcbodY5rX5g6kGm9kQgAm5UQCAAUy1EA==
Date:   Tue, 21 Jul 2020 06:44:11 +0000
Message-ID: <SN6PR04MB46404A4A4B78B20BA6E5ECFCFC780@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200713111949epcas2p47da38b91548e7a13123380b9a7093642@epcas2p4.samsung.com>
        <20200713112022.169887-1-hy50.seo@samsung.com>
        <SN6PR04MB4640C3D4BEB8307112C5F42EFC610@SN6PR04MB4640.namprd04.prod.outlook.com>
 <017901d65e83$9d7007e0$d85017a0$@samsung.com>
In-Reply-To: <017901d65e83$9d7007e0$d85017a0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9550b91-eae7-488a-2ee4-08d82d4179e2
x-ms-traffictypediagnostic: SN6PR04MB4576:
x-microsoft-antispam-prvs: <SN6PR04MB457674E57974E7BAD56295ABFC780@SN6PR04MB4576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DUo4xhEPrHoXLkLoaES6R0QO9CeuV49jhsV1+xgJ18ZwdeEfhN1ORx0jBCu+v4mHsbleS5JUm4XF1zNFZChZfhl/xEisklrazwQD1P7++Xjzx74fhdAFC7EHu/1ZJilEIXkjqSc1r8ON9vPcWX0cUssAcoStBcu5TVK/G26xVmMuDj9+Nomuf0HILDdDdfMS1IcPI3QS06rBbQMv8B72wbYosOU6Q0lg0tTLty9yehGSL8QOzngM4XSS7WuDxGKUsmTneGaqXX3SAhNGii6VxYx0ITe19sn7AYh3RDb72fbbw76pBdz6bYCcf+ywE7FYUzI+y2D4CohnIiqGr4K88vOT3HdFYAD4NbUwL0L0PwZrEJRl3WI2HlQZcnTfWhEyswHNy0nt50KmtnbvcegjXH15xi+8WH/y2S+uFRh691ih0+zAwaen2Z/InVbaGFXQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(33656002)(52536014)(2906002)(64756008)(66556008)(66476007)(66446008)(66946007)(26005)(9686003)(71200400001)(8936002)(478600001)(7416002)(7696005)(8676002)(76116006)(5660300002)(6506007)(316002)(966005)(186003)(55016002)(86362001)(110136005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZbFOQvf/1ob8odUm9QzSShZVt9Lqxcrs8/aCjPejkRcrCbRhIHOCnXtvMiznO5oB6lTm5BPNBYejvLPAlYi30AWbhzvd5vGFDvlbeqmN/zZo6MXLied08aJG4UxGPhLJN++Yfdh29Ydjvk3uMmA9B5mnAlXLBD4AuvV80AB8/e7gC9HixFFzwoF93AyGu6iYI2+pXu9Gsa6fU3W/Q6jzGfFbhqZeMRXuYKgtHdUDUPitEFkA+V3cZpl29iVt3U1v5RI5qRcwb9Pus90Nn8HrLDToPLhvl+nJqHpcYRXfhKuYkIBjTJABm5E+RVden8fwDHB2tjhhjFdYBIsPwrb9lNKvMP4gBRoKULLmokGXDcdDUfZZ+MNJbICjQq+crY39/ubwQ7/zmOz0lpBhcTJ2yGhSXYmP1CTSPhFv9m05Y9vCt93/2hKfBR778mpgpCuj6UePljJQp64m5NWGT2PXJ8phvqqVU4Bg3n/+wTU2his=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9550b91-eae7-488a-2ee4-08d82d4179e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 06:44:11.2806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3u6UenlCLJxryxF7MR2lL01zuzxEvXE1sRkMGScFX70KkMo5cjhgxreS0gGBHE9g7C0RalYcRjWLGjQjDi2nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4576
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ID4gLXN0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF9yZWFkX3VuaXRfZGVzY19wYXJhbShzdHJ1
Y3QgdWZzX2hiYSAqaGJhLA0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGludCBsdW4sDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZW51bSB1bml0X2Rlc2NfcGFyYW0gcGFyYW1fb2Zmc2V0LA0KPiA+
ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU4ICpwYXJh
bV9yZWFkX2J1ZiwNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB1MzIgcGFyYW1fc2l6ZSkNCj4gPiA+ICtpbnQgdWZzaGNkX3JlYWRfdW5pdF9kZXNj
X3BhcmFtKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGludCBsdW4sDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGVudW0gdW5pdF9kZXNjX3BhcmFtIHBhcmFtX29mZnNldCwNCj4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdTggKnBhcmFtX3JlYWRfYnVmLA0KPiA+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB1MzIgcGFyYW1fc2l6ZSkNCj4gPiA+ICB7DQo+ID4gPiAgICAg
ICAgIC8qDQo+ID4gPiAgICAgICAgICAqIFVuaXQgZGVzY3JpcHRvcnMgYXJlIG9ubHkgYXZhaWxh
YmxlIGZvciBnZW5lcmFsIHB1cnBvc2UgTFVzDQo+ID4gPiAoTFVOIGlkIEBAIC0zMzIyLDYgKzMz
MjIsNyBAQCBzdGF0aWMgaW5saW5lIGludA0KPiA+ID4gdWZzaGNkX3JlYWRfdW5pdF9kZXNjX3Bh
cmFtKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+ID4gPiAgICAgICAgIHJldHVybiB1ZnNoY2RfcmVh
ZF9kZXNjX3BhcmFtKGhiYSwgUVVFUllfREVTQ19JRE5fVU5JVCwgbHVuLA0KPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwYXJhbV9vZmZzZXQsIHBhcmFtX3JlYWRf
YnVmLA0KPiA+ID4gcGFyYW1fc2l6ZSk7ICB9DQo+ID4gPiArRVhQT1JUX1NZTUJPTF9HUEwodWZz
aGNkX3JlYWRfdW5pdF9kZXNjX3BhcmFtKTsNCj4gPiBBcmUgeW91IGV4cG9ydGluZyB0aGlzIGJl
Y2F1c2UgeW91IG5lZWQgdWZzZmVhdHVyZXMgdG8gdXNlIGl0Pw0KPiA+IElmIHNvLCB5b3UgbmVl
ZCB0byB3YWl0IHVudGlsIGl0IGlzIG1lcmdlZCwgaWYgbm90LCBhZGQgYW4gZXhwbGFuYXRpb24g
aW4NCj4gPiB5b3VyIGNvbW1pdCBsb2cuDQo+IFllcywgSSBuZWVkIHVmc2ZlYXR1cmVzIGZvciB1
c2UuDQo+IFdoYXQgcGF0Y2ggd2lsbCBtZXJnZWQ/IElzIHRoZXJlIHBhdGNoIHRvIGV4cG9ydCB1
ZnNmZWF0dXJlcz8NCmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXNjc2kvbXNn
MTQ0NDA4Lmh0bWwNCmFuZCB0aGV5IGV4cG9ydGVkIHVmc2hjZF9xdWVyeV9kZXNjcmlwdG9yX3Jl
dHJ5IGluIHRoZSBwYXRjaCBhZnRlcndhcmRzLg0KDQpUaGFua3MsDQpBdnJpDQo=
