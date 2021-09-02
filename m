Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F074C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 19:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C22610FD
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 19:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbhIBT7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 15:59:17 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3390 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243090AbhIBT7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 15:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630612695; x=1662148695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9IljLJvthoswgvl3/Xjdhe6v5ekyjIGaDuUv5jet5w4=;
  b=lbQhCRQN8YGEBM7rhgbvyI5QpnKDUqxLWZiaBL9FO93S3RpAQM/q1Dor
   FwtEeVADI/KRjFbcDTLYmACIY6oBiKzvhLeWmWCPBQHBWH0O9LEF/XbQk
   PsfQ7D5Fnpq/4xgbLaO+KaJlepMMllUCGvg7gZSDo6TYM7MYrcreMzX47
   umrmtGowm18HxejW3k7vubEoYAAq+wRwNCCftVsiKeJDwQ4RtaqJ3/bNV
   4gm9QYSBtDrgQ36H86xNB1wEiYr2uElPKYYHVyDN8TqlG+AKXQBJLCzkk
   /mVQFw3uRqIRJ4brjScyRR8mpAlO+GzMi65xm6jekQkqAXMcFvMHDGCWt
   w==;
X-IronPort-AV: E=Sophos;i="5.85,263,1624291200"; 
   d="scan'208";a="179617374"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 03 Sep 2021 03:58:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3t/a7kcEKfnVdpCJoSXwZ7D64RAkwykmFUD6g5b22p6s9UekJScbzgFZcc7/wKm8ZnfjmAQODNUWKXm4jRwVzV2vZwefWnrfBbZY5ZR73U48qRfl2jweaJnTYtGIQcPlnYyGU3aKEYt8inVxaTqdG3hjcGsRReP3xpbp+dd7FSaeQRtG/zPCuYgkhSaK+bON0aYkU4mYg3054909K25FX+ZQSlXQM9auK6oQXrLXsHyVV2c+85rj81ipyf3Z88VpMqfE70JdMdd7J6DIMCaaYRl9tvQeL1DN7QmrXMWnMZrm7jStiAYCDzVQ7DVVWdYZb92Rp4BZxCjoTTBlbxCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9IljLJvthoswgvl3/Xjdhe6v5ekyjIGaDuUv5jet5w4=;
 b=ntDt5S/xAL78OYK79vf2HOW/7WpVeF5+nF3PZy7YNLswBI5KWgIwMNPHYQhhiOCmXqTQjrkg2zEmrVskMamhkZ2kM04JnO0xHYXhiFw9RQidvj1m6aI26oAwBMdj0f4NN8T1fE2FR4iSeU0KR2g2oIf3EYZ9ilA/+RM0HydhpnPpfrCR4eXm/POYtC1kUgS30wn21krfCnmpCxNVQRhbXrpoZ2wG8akwRHTXVmcDFIcn2YJjbr76++wfQCWcASOrtVktN/MaYrHbzX42rIBBZURcd4Hcb13Fm0xMqPfG1V5vD+n7QE7+aftL9bJqM1wHM4sIEAEVwUw+dovATSIYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IljLJvthoswgvl3/Xjdhe6v5ekyjIGaDuUv5jet5w4=;
 b=jleJroIS9iIM1a4m3yTd4W/N6LPg9rPQhnamE9kZ4Bmte9aGOEUZvSl27yFzcrV1d10Q+YLMymNQEugWdKSb+Sbg5XBPAjLCLqwoMvPY60v76acANhhmVWZKlG5hPulxHQ7ctAmEEO8m/Junq0eq2S/QrJ5V4PlPfFxrI78pKtk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5083.namprd04.prod.outlook.com (2603:10b6:5:12::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.21; Thu, 2 Sep 2021 19:58:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 19:58:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature
 notification
Thread-Topic: [PATCH 3/3] scsi: ufs-sysfs: Add sysfs entries for temperature
 notification
Thread-Index: AQHXny5PdQ2tnJxsz0q33tHp7qZa8KuPZTkAgADo/tCAANv4kA==
Date:   Thu, 2 Sep 2021 19:58:11 +0000
Message-ID: <DM6PR04MB6575A4C54CE94CBE735D0550FCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-4-avri.altman@wdc.com>
 <0c547d74-481f-0c5e-9f7a-8c29218a0d3a@acm.org>
 <DM6PR04MB6575999F5D92901B5D2791EFFCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB6575999F5D92901B5D2791EFFCCE9@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: deeecfe3-db6b-4423-f0c1-08d96e4bfe05
x-ms-traffictypediagnostic: DM6PR04MB5083:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB50836E57D50FE96D1482A98DFCCE9@DM6PR04MB5083.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DYNmKO56mSk1a3o/I+H+Et24OKEaCS1zN4H5ECGPU/638DjALTKrNvZCAd1B+8YhWzoBCCl+NANXJ0LaS88EScLZFHYcZSYshK2B5pwo0sy/b11nkwiqe7oWg1TBaeIrkL5DTVFKq6h4a4Ioa/2jH8GRxSAlolXEeJHNHpZ3ozVYsoIPeOiD3/3l4i5Exz1xLGOqVcQhcfKLlfWsr8cdL3KppCQA206e5REo8rIr47omd0HPDgERg25OFgYA9uYr8v16j3kIn/4EUWeTP9pQoh5zenB6FhVdzz1avbGeH+T5IK6FMsJhIjalIGOPahNqV2MBncbtROpZGnF9/kldceh3f38DvbCurSFK/f1XVglt9oqsJH7Lv9gZkRmNJaB2EJIL3/+/ZT9PtUSjzQnpOFkFQFRC0agqSVYq6h7XxRJDohwYL+t6qLxr+/3cc84N7CLytpHdNrSoarq4yMSJSLO+m7awLl/V2d2JngHst5+Lj8YN1wb14ahFAw4JwORjZaD3I4w7MRJJeCWQcXgGW7I1GMnShwrYiw8IVOftItIagCOEgRxPqFyo38z2UlmkGTv7iOf2TRWfjWAsE6WjCXeldjVezbzolYHRRglqPUN51uF/xKfLavS5KnWBlXLfsMzppYPTkf1dNxIi9zrn5sMZzOKs3H7ASkFMR6ndBp4F9AZo/smEIngqcRw0KkMQpxclyC3VMPVSEawHHp+mcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(26005)(9686003)(8676002)(71200400001)(2940100002)(86362001)(83380400001)(2906002)(7696005)(4744005)(76116006)(38100700002)(122000001)(66446008)(186003)(316002)(66946007)(64756008)(66476007)(66556008)(6506007)(508600001)(33656002)(4326008)(55016002)(38070700005)(5660300002)(52536014)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T05KU054MkN5STVFb1hXeTBld1hSK1hlTkVzZFk0L0V2U1g3TEFZVHhQbjAy?=
 =?utf-8?B?WWNudjZJQVZHVGxLTit4SmxkT3JkekVzZFdxQ0ZaSElTNnZWTTlpQWhQYWhD?=
 =?utf-8?B?bWJkNlFRYWNFb2x5K24wRE9YWkNKcEJXSThsZDhnemdJOGwvQ1ljWkpSUEJT?=
 =?utf-8?B?VHdRN2kwK3JabU9pUm1ZcEd1ZXhCUkh2SWc5VndNb080c3pZWDZSc1ZNVnhD?=
 =?utf-8?B?ODA5bm0wam11bzl2SDJBNit3aE5ZczRHYWhnRGJwVnVlQUw0NEFuRU5FNmp6?=
 =?utf-8?B?eWhyU003N2orTTdwcUdUQkVVbkpLSVgwQzB6WVk1cXFaNkRyT0ZEazJSMExS?=
 =?utf-8?B?VzRWbDdkcTRDUDZyVWllblpIY1lIYU5EQkgycUxQOURDK1VjdTBuamFOSXd6?=
 =?utf-8?B?R0FOVy9Ra05qOFZ6RktvWGFxc2M0ZDFxUGtlN29SNjdQZ0Q4bXIwdWpyUGwy?=
 =?utf-8?B?dC82OElUUm1SemZWZDF5alh1MS9lQVdmTVBtVGVYUmIvbzJReElvZVBRZXhR?=
 =?utf-8?B?dGtPSFd1cGZ6TE9FeFJrdkY3YkZBanIvMUZ0VDE0TUJzQmxrU1RHSE1XaUt0?=
 =?utf-8?B?RkJFWDlKZHVxZHNZejJYL2ZWa1dObWhSWFZuZGR4Ly9FTjIyaVFNRnpZM0dX?=
 =?utf-8?B?VUY2bEhmZjUyZWM3Z2ZxNGlXNFE5emJ5ZlpLdVN3YVN2MkxNUHVwQnljQ3BX?=
 =?utf-8?B?SVFGemtyN3RVYzNlQS9DK1VpV2xjN2pXVkw0c2F2V2t6UjlDLzlNUTc4TXlL?=
 =?utf-8?B?MnZrU3lGM1BFb0swaGJ3NkVvekllWlpNeW5pODNuRUVwalRpZm55aFZLNVRH?=
 =?utf-8?B?Tnd0R2hManRjTjFPcDJUb2dyL3ZBSHZOTGJxbnZpTW9VWGZaWUFwZGZ6bksy?=
 =?utf-8?B?WHZPSVgvMHRsZzh5WHR3OW91dnNoVi8xNzFaQjZSQ3g0RTNnak1FbzZMSzA5?=
 =?utf-8?B?MzVJNDN4a1VmWXFob3ZoTkFYWFdqNEZ1YkdqQmtPc3VDNDZFbmdGMkVBU3JF?=
 =?utf-8?B?R0oyWkpqVUkzdGdYNFBQUXlkQ3JoeVZ0K0FaWk84TStXeEZySHhWL1Nra2x0?=
 =?utf-8?B?cUIxVUZkVGc4TW1DUllhajcxRWt5V3hKc1MvbmpZQVh3NS9lN3pPVzVBV2xs?=
 =?utf-8?B?UEgzVUZTbU81VmNCV0VUd1pCS0o1ZWllbGdzeTg2RHg2cCtHN09VZDFuS2RB?=
 =?utf-8?B?cjkrUlk4L2ZEUUY2UlNHc3pWU0doQi8vZnZMbUpRRzl1VExKVUN2ajNSemR1?=
 =?utf-8?B?QTU3ei9SZkEyQzdqSjBreEw1ajYycm5WTDdzbkpTRWhmY0s3WVBQOEtqbE5j?=
 =?utf-8?B?Tk9pYVJsNGNKc2pwenM1azNwdnlUQmxIMXVWWmxkMUJhU1pJRkw2dHdJSHB0?=
 =?utf-8?B?Y3pkaUNobUN6ZDIwZEVPRUV1Zlc3UjlmcHR0d3dGb04vWWp0WStXT3dtS05l?=
 =?utf-8?B?QllWeDlYSDBDbTN0TUxVSndsQnRSV0ZjVUkvajN0WldaQnlCR2Q5c04zVUox?=
 =?utf-8?B?TkhpRUFJdndrZUpBUitheXVDWlhtYXBkeWlhZkc3QlUxTG9MNDVxL0RJQ0Nk?=
 =?utf-8?B?OFhnTGdLdzZld1FtdkRJMUhSWU1VSmtYWW1uRk1iWW5sVC9XUE54R3NYbWF1?=
 =?utf-8?B?TUd6UWh3NVkxTVlYbWNSOHQySldqMjZXK3hwLzdaalJxb0UzakJsQk1pTTFP?=
 =?utf-8?B?akQ5ZmpqTktEUUFsNnRXNGpiYnZSaGNBYkhka3dNb2tSUytBa0ttd2xtcmVL?=
 =?utf-8?Q?wpH3TDnBAX7oCPqO0Yy94edvV/L028IWcaPbZwn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deeecfe3-db6b-4423-f0c1-08d96e4bfe05
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 19:58:11.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P1lE9pE0KO+W3uTdkOccuHD6ySWooYyQOkkNbuMwzX209CK2vfcTiUkXOD9xrj3wnfhXUXMh1yU/GcxYnZ8Emw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IEFyZSB0aGVyZSBhbnkgdWZzaGNkX3F1ZXJ5X2F0dHIoKSBjYWxscyB0aGF0IGFyZSBub3Qg
c3Vycm91bmRlZCBieQ0KPiA+IHVmc2hjZF9ycG1fe2dldCxwdXR9X3N5bmMoKT8gSWYgbm90LCBw
bGVhc2UgbW92ZSB0aGUNCj4gPiB1ZnNoY2RfcnBtX3tnZXQscHV0fV9zeW5jKCkgY2FsbHMgaW50
byB1ZnNoY2RfcXVlcnlfYXR0cigpLg0KPiBXaWxsIGNoZWNrLg0KQXBwYXJlbnRseSB0aGVyZSBh
cmUuICBBZGRpbmcsIGEgQHVzZXJfYWNjZXNzICBhcmd1bWVudCBlLmcuIA0KQHVzZXJfYWNjZXNz
OiBEb2VzIHVmc2hjZF9ycG1fe2dldCxwdXR9X3N5bmMgbmVlZCB0byBiZSBjYWxsZWQNCkRvZXNu
J3QgcmVhbGx5IHNhdmUgYW55dGhpbmcsIHNvIGxldHMgbGVhdmUgaXQgYmUgZm9yIG5vdy4NCg0K
VGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCj4gPg0KPiA+IFRoYW5rcywN
Cj4gPg0KPiA+IEJhcnQuDQo=
