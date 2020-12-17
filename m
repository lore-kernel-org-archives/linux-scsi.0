Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E51DC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 11:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4202389B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 11:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgLQLHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:07:18 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40457 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgLQLHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 06:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608203237; x=1639739237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dddxoM1ANtx0qCZr1wkbT7gwfk4Gs0TO13lZNlmyj18=;
  b=lpY2FYvr/sbZWLqStuWssMzRPHY5giUDCM+kwRXK6m/LmEKYkyWUd2zh
   ALoP0Nxz3E3X8tN01x9q8/9RpLepBD4pACWCdqw729g2Z0La0BM0L0nRb
   KzKBIt1YvyUIY3/sypglUPjz5u65uEiWwXxK+fOL9X4axVX5vdUFgsxfa
   XrmWY4BPkikvtAqwwAtyLkOj6w0X8MvwtNfaPM2T5WoGgFpO6Ua0yO1z4
   QaR59RWOxjQcPytaw6WK+ybsWpQZ2+LBHTfLFBShl9BWYkd2uNSMF++SG
   kKdhOI7fx0gkbaL96rBdVnRctJ6U3f3G3BrYxp0tF5IcVMnQIFEPfNaFQ
   g==;
IronPort-SDR: sV6gJPzLWzXoYgIny4gG7DxfGaHErqsKppPJLt4NwzQkJ4BPiEcB7uDUEX3Nf0EKRcpDWtxNcY
 LMEuBhffPPXue0AEhppdKHFmfOl56DN3xGtVQUi1ByZCElT+TLG03rDiJVq6v69Z9vOYlisjbC
 O6CwVMf+qyMlvIe1WCHVOvwybNASgqKzP+Orn5hJ1GeiS5ec7+kB6mPMn8i1e22swPVcTPFYsY
 8AODABOwrJaeE3rUCWmzcvgzguZilzszHxYR/tjRvNQWA8Zv4H7t81zIzqxE9VQFkyle48dJqY
 yFg=
X-IronPort-AV: E=Sophos;i="5.78,426,1599494400"; 
   d="scan'208";a="159814863"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 17 Dec 2020 19:06:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Di9As6SOqu+JyZ3lxHPZfenoRV7W2lNRMfyPMyRfZ0oPal2W8i4pAOUHYDAFJwkvqxZuoPjS9bSO3P8N1oZ7w2QdXLDyOtlN889xQhgmIU+tM53xCUGMmtojtdiLCZDtOv9IMusI+SHv5gidaqwsyRzFKnDu/HOPTWSdZKPR/Uuieh096/vanNAJkYHEJnVtp3yf6qnQCWZbdrX+BuN9yrxvJR0BTFkHLzQj0ebcfQTuXOxC6RsOSuwGwFcLOyKQGlhyfUyHYK0GGZ1/VYCzz6ecPb5vTKhxTEG8b0sN82NgLFKqa2ASVxOtvE2z9AldOsV/fwyxgoyMU4XSYeE1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dddxoM1ANtx0qCZr1wkbT7gwfk4Gs0TO13lZNlmyj18=;
 b=KEVA0Inzw3l6SHjseJ9YEoKjUnyUpPQcsLErYlRORahn5ADYWMfeYboKxhs8NNpUcnZnkhaOcm3e6g6UqmEBYrJYJIQ+mxpJNtWS/ie7vrcs9m2zyBdT6QVzZH8zICtkrWSz/MIQ/Mb+1Mm/lc/XmqP7TZI6e0heYFQKNuhuYWHoYy2/WssbDXcif1zd+5USW1RyfSzCfGpkSSyNmdN9qNIDGNQFNqUyvP8l0Tf4KL78gfa6o+jGLx1jH2VZk8k3bB0TYowWNdeXiQjsZ/1FV2ybEu2767eHOA2X9iqenYNWggenkC+npSFg3og1QNgr/9juhzJi8JkypuKYXtlwIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dddxoM1ANtx0qCZr1wkbT7gwfk4Gs0TO13lZNlmyj18=;
 b=oWmoclXFnBEcYrk6iQe2bGYlgYkRn/EI0Rip6ulQBWoSNWWArnISlTLchW/Bz6lyGNtW2net/br0OwEL+iqVN5f9QI6mH8rk4JrgpL1DcNmftOXBUHiRDd7mPJ3Vnvwx50csOJyxKKeQNXNivRXxCr9/YKncHGerhaXxSXJ0GgY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7131.namprd04.prod.outlook.com (2603:10b6:5:246::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.20; Thu, 17 Dec 2020 11:06:09 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.025; Thu, 17 Dec 2020
 11:06:08 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: RE: [PATCH V2] scsi: ufs-debugfs: Add error counters
Thread-Topic: [PATCH V2] scsi: ufs-debugfs: Add error counters
Thread-Index: AQHW09yJ2fr8QyM9Z0SeUL6f7j1fx6n6KREAgADi9wCAABUXEA==
Date:   Thu, 17 Dec 2020 11:06:08 +0000
Message-ID: <DM6PR04MB657575C9287D07090BE2FC81FCC40@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201216185145.25800-1-adrian.hunter@intel.com>
 <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
 <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
In-Reply-To: <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b0efa96b-663f-4172-32e5-08d8a27bc166
x-ms-traffictypediagnostic: DM6PR04MB7131:
x-microsoft-antispam-prvs: <DM6PR04MB71314C6C44100C65C0855470FCC40@DM6PR04MB7131.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eG4d79+/CxavTt/glyVF0XX+kmpDgLtYt63YqRBMiEgyDuyeFDMhx2o1DteyiPG3WnNp1h6pdKN5WsxSCg6M6HmjbMhDBPMssKjgay91hmWC91IsPEPzMc47in8tSyU5nnyNsKJZxW2A6tIqZ9Vq4vdVQyKDOuhslD+lmAqUjznaUAwmt4QpCGVqVSmrQx2V7BJJI7VYvtlGyOM1zUPbXv/1BwPTR1Ss08sx5kWKrB+gCBd6NsMdzmAZJ3lp2HFCuxdRnIrqhKMLNYMc7t27au/nGywBU3KfOy/SyTEcKzCnxD26Uv2zf/vE+IFmQGuP2yDQ/I2BAbvumHhbbpY3tVWKMlVjWhMDGT1lL4VEBLAA+Vw70ZrlXOu1t8dyNUaK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(33656002)(7696005)(55016002)(86362001)(9686003)(8676002)(54906003)(8936002)(5660300002)(76116006)(66946007)(66446008)(186003)(2906002)(478600001)(110136005)(26005)(316002)(64756008)(83380400001)(66476007)(66556008)(4326008)(52536014)(6506007)(71200400001)(87944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SFQ5cndKamp2UHNFZG5yNDN3ZzZHZ2VZSGVhTldaYWtDMkswUXh5UkFKMmRO?=
 =?utf-8?B?cVdMNU9Bb215QmEyY0c2ZE03VEVmeWh6VVM1eVM5Y2wzSi83NERmZjhWRmpE?=
 =?utf-8?B?MlB0WVQvajlPSFBCcmo2N1VzdFlMNG1QUXNWZ2h6VkF6RWkwdUZtMHlzZmcy?=
 =?utf-8?B?V1pDN3BiNjlUbmF0R2IwMk9OOEw2YnQvcUdMeXZjSk1sL3Rta1JNdEpjUmIx?=
 =?utf-8?B?QmZXRVFoaDBMOW90Mnh2bnNpVUpJWmNqT2tsN2pYc0VQbk1yeUpSNU90SjdQ?=
 =?utf-8?B?aERMT0wvUmtKalU4MmlHOGJkeG9oS0tCY1FTQ0UyOTU2YjlMMTBidzdiRlhH?=
 =?utf-8?B?aXhNUm5GQlpEY3hodG5SS0ZhdE1hQ1d1YUpJRXFybVhQZjBNVzFxZUpYU0xI?=
 =?utf-8?B?d29xWDdLNjFMYUYwVmVyTTg3SDdVVkJaUHRZRm5aUG5ING5qbHBhQ0RXczM5?=
 =?utf-8?B?eS9pM2grWnRQSkxjdWpFaW1yYVlpSGcvY290SlhRZTk2ZzQ0SXRVTUJQM3Rt?=
 =?utf-8?B?eUIxMGZDM21pR0RCYlNidkd3SWJmYSsyalRUUXp2YURoRm9iTTM2eHlXQlZn?=
 =?utf-8?B?RUFHQVhBdjJRUGlXWTlpOU5iSElZNGJVb3hQem9VbFNrYXpMcThXamxqYVJz?=
 =?utf-8?B?a2N4QzU4ekg1NkJjbFJQdmU1TmNJdEZvMFJxLzNJZE9TTEppRGV2SmVkMVNs?=
 =?utf-8?B?VEh0cU9yYm1qeDdFdm9vdXJjNlAyd25SRm5nNVZTQ3o0c3FGMzhxMXdTQUJ4?=
 =?utf-8?B?QjFpNjFhMVR5NElIVVdMSU84ejZwV3ZabHRHQXpYMzl0d1lxU1FoZit0eWM1?=
 =?utf-8?B?M1NZYUhuMXMzUHdxWTQ4ZFkvWjNwQzhVN3NIa0o0ZWxEa1hudTVaSCtaMExV?=
 =?utf-8?B?VXJZdE9tdUxrak1JdElmRTNPcUVia0lEWFFZSkNURTFwWnczeHB2cDM2MEdF?=
 =?utf-8?B?OTVrb2IxQlVsUEtsYmF0eDdPeVpYc090MDJKOFUxN1B2R2FDQ2hBUmJCY2M0?=
 =?utf-8?B?NDhYd1hhS0I4d1FRUjNaTkVBanhkTlRzNk9FOTZFYXQrdlhlWE4xTzRkeFVS?=
 =?utf-8?B?VkVncTRXektsamtJY1BkeGVjK2J6MndxbENOZnU3a2haTjhjK2xDOGdka085?=
 =?utf-8?B?alZVN2RvaEtRODNUenhub3Z4WUJHSTJmT1FiWHdwTXQ0a3pTb0oybzBidnhx?=
 =?utf-8?B?c04zUlpjRHB2Z2V6Tlcyc3oralUzeEIzRTNhMVlIeVlTRm5McE5uSTR0cVJT?=
 =?utf-8?B?OU5kY2VKalREQU4valJ6YXlMVHpPTFZLK3VpTlZXMjdVWGxJc2RPK3VYUTFh?=
 =?utf-8?Q?U8gP1PCsAovcw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0efa96b-663f-4172-32e5-08d8a27bc166
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 11:06:08.1506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ztXqq05bBCTr8+ig8KE2UIW5olWQPGhMg79Y2lkdsPWVumHV7QTNYXsegeShFWWtWfKmQM50keFifUDop1MUmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UGxlYXNlIGFkZCBteSByZXZpZXdlZC1ieSBvbmNlIHlvdSBmaXggdGhhdC4NClRoYW5rcywNCkF2
cmkNCg0KPiBIb3dldmVyIEkgZG8gc2VlIGEgcHJvYmxlbS4gIFdoZW4gYnVpbHRpbiwgaW5pdGNh
bGxzIGFyZSBvcmRlcmVkIGFjY29yZGluZw0KPiB0byBsaW5rIG9yZGVyLCBidXQgdGhlIE1ha2Vm
aWxlIGRvZXMgbm90IGhhdmUgdWZzaGNkLWNvcmUgYXQgdGhlIHRvcCBpLmUuDQo+IA0KPiAkIGNh
dCBkcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlDQo+ICMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEdQTC0yLjANCj4gIyBVRlNIQ0QgbWFrZWZpbGUNCj4gb2JqLSQoQ09ORklHX1NDU0lfVUZTX0RX
Q19UQ19QQ0kpICs9IHRjLWR3Yy1nMjEwLXBjaS5vIHVmc2hjZC1kd2Mubw0KPiB0Yy1kd2MtZzIx
MC5vDQo+IG9iai0kKENPTkZJR19TQ1NJX1VGU19EV0NfVENfUExBVEZPUk0pICs9IHRjLWR3Yy1n
MjEwLXBsdGZybS5vDQo+IHVmc2hjZC1kd2Mubw0KPiB0Yy1kd2MtZzIxMC5vDQo+IG9iai0kKENP
TkZJR19TQ1NJX1VGU19DRE5TX1BMQVRGT1JNKSArPSBjZG5zLXBsdGZybS5vDQo+IG9iai0kKENP
TkZJR19TQ1NJX1VGU19RQ09NKSArPSB1ZnNfcWNvbS5vDQo+IHVmc19xY29tLXkgKz0gdWZzLXFj
b20ubw0KPiB1ZnNfcWNvbS0kKENPTkZJR19TQ1NJX1VGU19DUllQVE8pICs9IHVmcy1xY29tLWlj
ZS5vDQo+IG9iai0kKENPTkZJR19TQ1NJX1VGU19FWFlOT1MpICs9IHVmcy1leHlub3Mubw0KPiBv
YmotJChDT05GSUdfU0NTSV9VRlNIQ0QpICs9IHVmc2hjZC1jb3JlLm8NCj4gdWZzaGNkLWNvcmUt
eSAgICAgICAgICAgICAgICAgICAgICAgICAgICs9IHVmc2hjZC5vIHVmcy1zeXNmcy5vDQo+IHVm
c2hjZC1jb3JlLSQoQ09ORklHX0RFQlVHX0ZTKSAgICAgICAgICArPSB1ZnMtZGVidWdmcy5vDQo+
IHVmc2hjZC1jb3JlLSQoQ09ORklHX1NDU0lfVUZTX0JTRykgICAgICArPSB1ZnNfYnNnLm8NCj4g
dWZzaGNkLWNvcmUtJChDT05GSUdfU0NTSV9VRlNfQ1JZUFRPKSArPSB1ZnNoY2QtY3J5cHRvLm8N
Cj4gb2JqLSQoQ09ORklHX1NDU0lfVUZTSENEX1BDSSkgKz0gdWZzaGNkLXBjaS5vDQo+IG9iai0k
KENPTkZJR19TQ1NJX1VGU0hDRF9QTEFURk9STSkgKz0gdWZzaGNkLXBsdGZybS5vDQo+IG9iai0k
KENPTkZJR19TQ1NJX1VGU19ISVNJKSArPSB1ZnMtaGlzaS5vDQo+IG9iai0kKENPTkZJR19TQ1NJ
X1VGU19NRURJQVRFSykgKz0gdWZzLW1lZGlhdGVrLm8NCj4gb2JqLSQoQ09ORklHX1NDU0lfVUZT
X1RJX0o3MjFFKSArPSB0aS1qNzIxZS11ZnMubw0KPiANCj4gU2hvdWxkIGJlOg0KPiANCj4gIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiAjIFVGU0hDRCBtYWtlZmlsZQ0KPiAj
IE9yZGVyIGhlcmUgaXMgaW1wb3J0YW50LiB1ZnNoY2QtY29yZSBtdXN0IGluaXRpYWxpemUgZmly
c3QuDQo+IHVmc2hjZC1jb3JlLXkgICAgICAgICAgICAgICAgICAgICAgICAgICArPSB1ZnNoY2Qu
byB1ZnMtc3lzZnMubw0KPiB1ZnNoY2QtY29yZS0kKENPTkZJR19ERUJVR19GUykgICAgICAgICAg
Kz0gdWZzLWRlYnVnZnMubw0KPiB1ZnNoY2QtY29yZS0kKENPTkZJR19TQ1NJX1VGU19CU0cpICAg
ICAgKz0gdWZzX2JzZy5vDQo+IHVmc2hjZC1jb3JlLSQoQ09ORklHX1NDU0lfVUZTX0NSWVBUTykg
Kz0gdWZzaGNkLWNyeXB0by5vDQo+IG9iai0kKENPTkZJR19TQ1NJX1VGU19EV0NfVENfUENJKSAr
PSB0Yy1kd2MtZzIxMC1wY2kubyB1ZnNoY2QtZHdjLm8NCj4gdGMtZHdjLWcyMTAubw0KPiBvYmot
JChDT05GSUdfU0NTSV9VRlNfRFdDX1RDX1BMQVRGT1JNKSArPSB0Yy1kd2MtZzIxMC1wbHRmcm0u
bw0KPiB1ZnNoY2QtZHdjLm8NCj4gdGMtZHdjLWcyMTAubw0KPiBvYmotJChDT05GSUdfU0NTSV9V
RlNfQ0ROU19QTEFURk9STSkgKz0gY2Rucy1wbHRmcm0ubw0KPiBvYmotJChDT05GSUdfU0NTSV9V
RlNfUUNPTSkgKz0gdWZzX3Fjb20ubw0KPiB1ZnNfcWNvbS15ICs9IHVmcy1xY29tLm8NCj4gdWZz
X3Fjb20tJChDT05GSUdfU0NTSV9VRlNfQ1JZUFRPKSArPSB1ZnMtcWNvbS1pY2Uubw0KPiBvYmot
JChDT05GSUdfU0NTSV9VRlNfRVhZTk9TKSArPSB1ZnMtZXh5bm9zLm8NCj4gb2JqLSQoQ09ORklH
X1NDU0lfVUZTSENEKSArPSB1ZnNoY2QtY29yZS5vDQo+IG9iai0kKENPTkZJR19TQ1NJX1VGU0hD
RF9QQ0kpICs9IHVmc2hjZC1wY2kubw0KPiBvYmotJChDT05GSUdfU0NTSV9VRlNIQ0RfUExBVEZP
Uk0pICs9IHVmc2hjZC1wbHRmcm0ubw0KPiBvYmotJChDT05GSUdfU0NTSV9VRlNfSElTSSkgKz0g
dWZzLWhpc2kubw0KPiBvYmotJChDT05GSUdfU0NTSV9VRlNfTUVESUFURUspICs9IHVmcy1tZWRp
YXRlay5vDQo+IG9iai0kKENPTkZJR19TQ1NJX1VGU19USV9KNzIxRSkgKz0gdGktajcyMWUtdWZz
Lm8NCj4gDQo+IFdoYXQgZG8geW91IHRoaW5rPw0KPiANCj4gPg0KPiA+IHRoYW5rcywNCj4gPiBC
ZWFuDQo+ID4NCj4gPj4NCj4gPj4gbg0KPiA+PiArDQo+ID4+ICttb2R1bGVfaW5pdCh1ZnNoY2Rf
Y29yZV9pbml0KTsNCj4gPj4gK21vZHVsZV9leGl0KHVmc2hjZF9jb3JlX2V4aXQpDQo+ID4NCg0K
