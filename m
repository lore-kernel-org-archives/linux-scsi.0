Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB2CC55192
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 11:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E941520787
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 11:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="3LWhmyAd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgDWLBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 07:01:16 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:17345
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbgDWLBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 07:01:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4SFvZKJX9Fe4FC3TujIx6cnLD+j45Mzt3Cxd847MCe4KZpWxtUcxkEA3GFR51FUj6dMVAIJfxyKiO3mXGeDGifYtpRyhgR1PYjXxRlmDCGjujEO0JmJsd5QetMMetmNkLmCN3BMrauDP2q1TJsA7CNWvGVpJhbjhNWz9//ixd76w2J4ITT+/969NH7AN85BCM0LayZHpDz+pEUN8mHTqPOtwyHbTfsj3VaX/CtvtoFuDq5aqDAcBeutWiIU8WVrdk003aHo9GvlkmGxej5pNLZ3B6vbiQ5Lu1ImjtLMFGlDyVdgRmnvjzbXlv3O/oi21jnwIGD+ech8X52dFqAV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ4U99gAUOUWEHNnqYQflPG9AN59kkYzX/pF9tQ60uY=;
 b=jM04M9ucICDpnTeATJjLPUZ2RLuhhI7yAte/85EHHur9wocV3nC/N0nEyBMnN1Snzv1edj5rBsatL85Xv4EjKGQzq+hZqofdjdvORx4eygIXDxBPsBJMv8clyUuya60WEA0mwwNrMz+X/vWOsIztNRp5rlLZq0BEzH2iJ05Fz13drOUXGSv4gItA1s/f+YG8B3zq8GOlQgM7XkJNfYVX4USyAcDiocPySh9oRsxoyU9pjjJ7/fHQL1v7+9PK6bykOQtrsY0JHUHd1Y4PIi+vGpVohrlh8UfR21ceNri99zFfAV2WUBclOhZEkBmYBHr+hhWuMXs3tAm0PY6AiGkN1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ4U99gAUOUWEHNnqYQflPG9AN59kkYzX/pF9tQ60uY=;
 b=3LWhmyAdeYTywsKa2X5FX1vP9v/CG7GplTNPybNRvlgmB4ZizGCM9/u+/F1F38gsZ2FD/U3o8Uw/+lXA4qUTO5WgKDEu+0AckamrVShazNxHfb22wPUTBGwSUk1z/yJbmucVBAt1lswi1gWYsqdJcpbvMv4c1x3fixHctYCJPCw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4114.namprd08.prod.outlook.com (2603:10b6:406:84::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 23 Apr
 2020 11:01:13 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::5dbb:4fb8:f0ca:6988%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 11:01:12 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 1/5] scsi; ufs: add device descriptor for
 Host Performance Booster
Thread-Topic: [EXT] Re: [PATCH v2 1/5] scsi; ufs: add device descriptor for
 Host Performance Booster
Thread-Index: AQHWGPtnA7Fw8mUJC0qjkFZon51x26iGiptQ
Date:   Thu, 23 Apr 2020 11:01:12 +0000
Message-ID: <BN7PR08MB568449A01D10F89B5C7F0E8BDBD30@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-2-beanhuo@micron.com>
 <6e092ac1-7e7d-3f12-8c81-b88369f1f621@acm.org>
In-Reply-To: <6e092ac1-7e7d-3f12-8c81-b88369f1f621@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWJjNmZmNGE2LTg1NTEtMTFlYS04YjkyLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiYzZmZjRhOC04NTUxLTExZWEtOGI5Mi1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijc1NiIgdD0iMTMyMzIxMTMyNjk4NzgwMzQxIiBoPSJIUGw4dUhXQXl6aGtUL2NDd2ROMDQyVU5JQkk9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUMxd3NsK1hobldBYlNFMzFuTjBuUTh0SVRmV2MzU2REd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQVM2dEFnQUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.109]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62c352ea-7149-4c18-1639-08d7e775a314
x-ms-traffictypediagnostic: BN7PR08MB4114:|BN7PR08MB4114:|BN7PR08MB4114:
x-microsoft-antispam-prvs: <BN7PR08MB4114691746692365AB3D1E0EDBD30@BN7PR08MB4114.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(55016002)(76116006)(26005)(66556008)(4326008)(478600001)(7696005)(33656002)(52536014)(66446008)(66946007)(53546011)(64756008)(55236004)(6506007)(2906002)(7416002)(66476007)(8676002)(81156014)(8936002)(316002)(186003)(9686003)(110136005)(5660300002)(86362001)(71200400001)(4744005)(54906003)(921003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s6M+DVL3EM3l6NGEUNsHu9VmcunIs5zTIH36rEYf+CllKuuMEhxDWEKDlrGNoYzhnTmqjqCZgqQXRF96wh/oWLk6PeMcof4Dipl0S+Cd3/5jKzpy/K+PY7psjjSZjIO6jiNMh3hiwDgC/dLAYX9RvVoBZ7o4E8NuXeppoafZ9k93a0KqE3Xqzr6Zns/sosz9aNaS4zDM9SVx6ksCsXRG0iYmu4V/nRH9DBsyihqK8dBVNDkIPbhHg4C6rbu9ooiDe+MGy0Xxce31iJ+fb7WOOVFFVQIlLkfM86nal6zlN4R6RHTRnq/Vob1CNpcadOqB+gdZM01CD8ZTCsaCV+vXzRMC8ZvP23QlPZSO+rdKiX6rn1GNTA2s9X2RKuZHsLcTKhb4lb4O6zKerISMgYbrOfFQHSfmDRUAp3cGmV3J7+oypDpSLEB+bVU/s5CmTFhMxUk2gKKJIZqOTaG15KSmiavc0v3bL1vZYF4TRn0dpsE=
x-ms-exchange-antispam-messagedata: py9EXmJ2IdqN8WELAjekg8CcBit0t2F2hap1x/5CyNgF7zRa+SXjTzdHqUiyr1WQTSzoVlEut2PRyvY5XepVAXznDFNJgcKtWvxcHWtpRcKtIKjDUlLJWBceWjO8OhmlBdWIGhECtCHh23R7SOF6VMKGJsA1SF9vn6NbF71ZN2YUSvL2K/kloctJdrfINQqlsTHVS0nMPwQSPPVsNdVHsH/bX3FNYpHXSRSc2ZQP+/O4+IoF5OxNmo2+H0/ewMZ2ZM5vqIHTfW1DAzUWssPDv76hJxNoD66TGLI74Dx92pkoMuri/z9t5nzOrnm5yQdQ5WZ+r5V8luVRoek9kcBd92BPVtEIYItLeG5lQpLiiCaFG0szfdOQ1U9BSPVa4KtFSs6m2D5QfCg1XmXn4B9cBov+3Buu4VcVFeU/1DlcuBdU5bh+AvDf9PqWr70aVw6Id7M1WsGSbxbiP9cZuaMxOmDW3QVnYuFRmC3saSLLMnT4BPG1AAnuhYBqxzNaoPdvaqpp80TPNXldz2EG+L9B0HJoyI/dMTAtYfnNB8whIDibt02DDOL/t/XYeyjee6I4l6ggeL/Cq1JP4JjFQWAb8fEYNKobegkBGZcAKFmL+EpVw+LuKjFP6Xjvg/l3hIvQvtuzwspuCtRgOXDbJN1YqoVEd0R2eMw88Q/38Ct45hYEMpq/Rkme+VQi8Sa5ypRDZYAZdBuYmtQGp1gT4KvSIuQ8Yf2d8kS70qok91OWFmMx4qlmLQHI5TpprPyfTE9yHRBF/HWUglutjKhU0LNsPfeZYfe/7e/80taN4yQZWVU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c352ea-7149-4c18-1639-08d7e775a314
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 11:01:12.7048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y108IAjNDUXtdxNTr/h2mhyE1SfSy87FnL7Y68asXrRddsxtquTvpFszNh52dLVJ2tb9u5ROygQPP6ba0XE38g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4114
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydA0KVGhhbmtzIHlvdXIgcmV2aWV3LCBJIHdpbGwgdGFrZSB5b3VyIHN1Z2dlc3Rpb25z
IGluIG5leHQgdmVyc2lvbiBkZXZlbG9wbWVudC4NClRoYW5rcywNCg0KQmVhbg0KDQo+IA0KPiBP
biA0LzE2LzIwIDE6MzEgUE0sIGh1b2JlYW5AZ21haWwuY29tIHdyb3RlOg0KPiA+ICsJaWYgKGRl
c2NfYnVmW0RFVklDRV9ERVNDX1BBUkFNX1VGU19GRUFUXSAmIDB4ODApIHsNCj4gDQo+IFBsZWFz
ZSBpbnRyb2R1Y2UgYSBzeW1ib2xpYyBuYW1lIGluc3RlYWQgb2YgdXNpbmcgdGhlIG51bWJlciAw
eDgwIGRpcmVjdGx5Lg0KPiANCj4gPiArCQloYmEtPmRldl9pbmZvLmhwYl9jb250cm9sX21vZGUg
PQ0KPiA+ICsJCQlkZXNjX2J1ZltERVZJQ0VfREVTQ19QQVJBTV9IUEJfQ1RSTF9NT0RFXTsNCj4g
PiArCQloYmEtPmRldl9pbmZvLmhwYl92ZXIgPQ0KPiA+ICsJCQkodTE2KSAoZGVzY19idWZbREVW
SUNFX0RFU0NfUEFSQU1fSFBCX1ZFUl0gPDwgOCkNCj4gfA0KPiA+ICsJCQlkZXNjX2J1ZltERVZJ
Q0VfREVTQ19QQVJBTV9IUEJfVkVSICsgMV07DQo+IA0KPiBQbGVhc2UgdXNlIGdldF91bmFsaWdu
ZWRfYmUxNigpIGluc3RlYWQgb2Ygb3Blbi1jb2RpbmcgaXQuDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0K
