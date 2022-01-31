Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869A2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348392AbiAaKPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:15:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42201 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiAaKPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643624107; x=1675160107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=I3i1wnqUoNQ0LjEHevgpX50HfgonDpN9oK0OJgWcoP5ZEoeXcYNUrAi4
   hZ/p4JzgWdigYiQ2bqYSBoJ/G4g59kWFjtt4cpmBSMISu5f2H+gA5iMAb
   ZFefxoDQxubSSHRU4vUMTuXk6586A9tItxY1u61c4cWjoyr8ZMMPeUBww
   0xhG9Pebhu+ljbZh0GDbyQKzsWW5Xjn2Ukij1pBLK/qVBro2YP/IkGXsr
   y3X9e5UKGha/T6t7tt7BlfmYzGm9xKc/Z6UVHGRehH5I1lTvLjmSyaFkN
   CJvfwgSJnS4CKBAeIlT8HzVuQu7mTYQNMQGiSW4dZ10nFK/dRi+n+XpRb
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303677458"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:15:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtCJqOnw79Y1r0QEdR0mmL8ZJ6OI+QMlxuUTKl283xpUbHLTKYRXqfS8hbg0+kYMqRLX/Bh/NccOlDYzffM9rczxOiQfsPXalI2QNmMS2ABmxQ4YDzCyPAuSTqauVNn/szRSyw91vBlVphmGlvBb8n3Ksd5J/e6DRTevKrEib3yCapyz0tjNr+T3NSr6ViKL/lolS6s3EMTZrtlBkLHAT6gjW1ERnJraC4tGlRgY6eOsZ8j1RoEzixJLmTfbMzoCgYVTxcjKCkDo5qhML0X0sDdf7O3/7kp541/pdW3IXMKabcJdUr4x9Ecfrxa5zNHJOkaueTCKdc7paR8oUuGT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=QHb+pbZf6PHkGY+HsuBiU47QIgSjuRF/R4iJeONcs5TtsdwumlG62Um0Rihz6lN0axO7yDbXoPKnTREmZy1jhnPDxAaeSt4baSgDy6pfAgVjLbJg/K9kuDn8HKne989sYeBvWCKhPmodrDk/xSo3E258aKsIHJ9BXd85pT1r2uMbhD9gq0br61GTuC3Rn56k5e9Z4zn8IjTBlI50fUxzdO0ilPfwU8hsGLOnjyCWvax2J8dc0UcF7adqW3xtWBMaOnZxORjDFKFx3oD3+Xg9k8VvXSpTVodYAay4jMAaHg+zbfXTc3OPeUH9OSvoDR2pfLI2OXuuzRhTju07UrsE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=v7uE5Vbi5AXNHLyCvv7uV4EoXnZxhNjH2858hQ6deG13S+t8jN9mDYPnXMHuuSEtwwvlCkcSys/sAWvmgXlNfsWRTd9o3hak4s+hmITZ5q9jzHWA5DOODIxaDTQjMfft0vBj/6YPfBKQd9GGx0vQqs87P2o9EKyudU9Xt7paJQQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4498.namprd04.prod.outlook.com (2603:10b6:208:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 10:15:05 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:15:04 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/44] 53c700: Stop clearing SCSI pointer fields
Thread-Topic: [PATCH 08/44] 53c700: Stop clearing SCSI pointer fields
Thread-Index: AQHYFJVXUo+0AG9gsEOBP9mitz38Fqx87aeA
Date:   Mon, 31 Jan 2022 10:15:04 +0000
Message-ID: <59f4bfa14f9d3e124e788ca81e67ee2f8681a083.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-9-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27b937fa-37f9-45ef-c253-08d9e4a28c8e
x-ms-traffictypediagnostic: BL0PR04MB4498:EE_
x-microsoft-antispam-prvs: <BL0PR04MB4498D1A49FCB18CA50868BFE9B259@BL0PR04MB4498.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CStTBhtVFRE8S1ltF72bBlRk1cHVW7XD34jjDWPYvQ0SSNGsjZXy5kMD42cxGpjCgtAfLWOv9kNEtT5cnnWDpd0H6vTq4VQ+Qz4jgqIde/im8QPXBS6Y0lDUP185ORfRNd+AP4gEs+5dZ8cy+B71a/Z0rSuofyO7gFzE0i/k9SOn7KNSF1k4ad2/NjCn8rFW3KGDUK+VmFNXx3lKLzECFyFPqopIMjjYGTmg5H8DhsyIuOh0/P31VBY3YBFSJtNn1liEyMV8Qt7r7Q6GZ9DWgN8ZVdKEkQ7vBn4Q2xNnYnJtCZq4Fflg/SyY+pl5ZjsSnyX1NkatWZdlPXkRSCzewWz541XwhV2DtHNj6QI9czdajh2Sgf6ag8r/EE079Cj8LMd2uz4I+blYEGyvhQ3JwPh/MBJ5yTFNvX2o4x/C+xV81AKPJuKyPsEEz/PAHMQIgyf9f0kO8cJOhotm0x6lXLRCLQodzaMn3ep9D/7BxGJDSKpL37n9TrEsF9mjvh2qfOgtLcGyiJhkv7kXJ20BR0ioVGjIKQZ/7z5xltZ/7hgEV/UlGxyVrEX93zoXhAy3zZlvp+S7iwv9SrO4iUo2Y2JYy8j+IlYRS/DqoiZ66eY019NFrC6HtTz3RHLL45UmqTevks2//OvzPctlxTkdv1JAMy2nbe0JH1oHUXXB9QhUsXrPM/aw+sJ3Hp1xU3s3q/LAPxj/Y0DRB+5c3cKc2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(91956017)(8676002)(508600001)(6486002)(8936002)(558084003)(66476007)(76116006)(82960400001)(66556008)(64756008)(66446008)(2906002)(66946007)(36756003)(6506007)(6512007)(26005)(2616005)(86362001)(122000001)(71200400001)(4270600006)(38100700002)(54906003)(19618925003)(38070700005)(316002)(5660300002)(4326008)(110136005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3FpL3VlL3hHck5VQ01yT0tWNllhdGIybXA1VGhoSjFWa1pCbnRrRnl1dUQy?=
 =?utf-8?B?eGw2OGUxa09NNFRndVNmaEkxTFVFUEJvUjJrbHRMcEx4VHptWHgvZkZId3Zn?=
 =?utf-8?B?bkRoSG5PRDM5WGNOTmdFUEFUdllwT21SZ1ZCYVNEQUhGTGVvL1lPazZ2a2pm?=
 =?utf-8?B?bHBaRW1EVlFwenQ5QTV3R3gwWC8zT2FEU1ZKbXdDR04wVUpleXFOSXQvMW1y?=
 =?utf-8?B?VU5uRXFxdTE1aENTVGpMRHNnSzhWNlNvVEpXcEFFcWQwZENwcDNOdFY2bk41?=
 =?utf-8?B?NjY5Zis1WWxSc1R1RkZ1YXE1ZlowTGtvTkxKWnl5aGRvcVpTUzJBR1JiaEIz?=
 =?utf-8?B?Z0c2WS9ZT2JTdDI0YmdkTzY4ZXl5R3d3cU00WUxNLzNDRFpWSlRvRnB0azR2?=
 =?utf-8?B?aWpZZ2lHNUw4WWRqaTZwSEQwUlpsUFZ3ajJlbzFicGV5Q1lWakJXd3ZSbnFS?=
 =?utf-8?B?b0NhbDVFNG5hSXFPVFFVOHRzRG1VelNUU0tVTHlkRlZqd0VlY29SUTdoZUFw?=
 =?utf-8?B?dXFEZ2p3dmFON3RtQUdKcGwva3Rlcm9pOGlUVHVPcWlzQ0d5U3Ztb0NVeE9Q?=
 =?utf-8?B?MTRIcGhvZ2swUHRNWXpiQkRyUjl6QWZWS2RpdGh5Y3BQT1h4VTY2LzZkejZM?=
 =?utf-8?B?MHlGVVk5SnhrTmFWVCtYd0tZSzZsVDZpVWVWT3p3ZWJPMTFWZ0lRU2loNDEx?=
 =?utf-8?B?MU9VQVd1elIzVk1UdUtmZXVnL3BxOUJWMEhid01nQm9kNmV0SHA1Um01b0hR?=
 =?utf-8?B?M01JcXg2dzEvOFI3MzkvNTg3dUU0disyUnRsRDRIb2pCMDllcjBKUThySmRp?=
 =?utf-8?B?NEFsU1JNSzI5T1ozazkraTd1OXBNRmd2ZTVzUFRjdkVIZ1JzYkR6amRFKy9X?=
 =?utf-8?B?cUNDUy9NRFh5bWtmY21UNmlYZkZndmV2VDJyMEdSOGc0THVtYUY5UFRFdzZs?=
 =?utf-8?B?YmFvYmJSRDN2L2FJZ3NscEVNT1V5QS9TazBEbzFCWUFaanhFaFlzQ2I5Nksw?=
 =?utf-8?B?anhPYXVIVjhCdk1HSGJ1bnlCZmp4VVVDQk5VVEsxaUlkeGFicVJ2TW03T3RR?=
 =?utf-8?B?OHZTeWVrSnFmcGMxVVR6dXovVWlBN05VVjk0OStQdGZjMFpkd1hBNm5nRXhV?=
 =?utf-8?B?eGI4VVU1RG9lN0FVbzg0eGE3ZG1tNXYweHlobXpIRGxKWnNuNW15TDdTZnd3?=
 =?utf-8?B?RStuNE5NbjJiYTQ2OFVQL2NkTnhzRHQvOGNDUG1NNFpIdlc0MnNNREtMdG5P?=
 =?utf-8?B?bXVTQ09BaVg1WnlReG9qbUFFY2MwUnU5cVlJNVhDTTBmTUg0UkQycllmNTFW?=
 =?utf-8?B?akxvVVYvSFpDRUYrS3h1eGdmN3RFZ3VRUlFNaXkwdTNUZ1NaYklyWFpHVGY4?=
 =?utf-8?B?amJLdmpHWUR5SVpwcGtXUXBTV09McGE2ZXlWeWRFR2haaWhRaXFiTmtDVEhS?=
 =?utf-8?B?T2pCZzhlY05JSlFFemJmOUs4Q2tKQVpoSDA0RlFncHlVanljbW95QnY3NnNw?=
 =?utf-8?B?NkF3TnRWaXZQeklJb2ZiY1BnTmV0NDJxMWtCZFRlZDVHME5FRzZqQXJ2SnM0?=
 =?utf-8?B?NktxeWJpUmRTRmdjUS92TjNtaEVUSENPMjB1eFNIK1FVZWRpN0pPa3YrMlN3?=
 =?utf-8?B?SEoycHhpNnBnQWFIQ0V0VjhFY3N6SGJDbVZNWS9UR1BIVG8xbUl6VlpkQTlC?=
 =?utf-8?B?cmZLV053OURIQTRzRmgwc3RJcFMxK1htSHdYbko2ZHhmOGJqUndQajZuTlZG?=
 =?utf-8?B?TFgxeEdXV1YyNnlJKzZEcFpMSm1lOE1YNzZhbXhONFBPeGE4OFVtQlM0ZktP?=
 =?utf-8?B?ayt6dXFTeE1ZQ0t2djFoY3I3Y1o0amNNcExjdTNvMWZGdU4ybWhuZ3dkNFgz?=
 =?utf-8?B?aWt1ZG5IRTNISGRBSVZvM3BRbEF4ZFNjWGgrU2ZCMU5teThLb1hXRU9KcmZV?=
 =?utf-8?B?bDVwdXZ0aXZyWkszUXUzZnBuZjZwMlFpRkFVMHkxQWZtRDUzOVI0dkl5cHMy?=
 =?utf-8?B?YXNuclpSNUJiWU5UN0FlV1c5VlNQQUVFbmxqaitvcENGSEIwMzNmN0U2cTBh?=
 =?utf-8?B?N3p5UGZQVkRDUVRzWTJzNkpZYStRdTVNdEw4Skt0cXYyVGVwZ3dwdFI1MjVR?=
 =?utf-8?B?YlZ2ZkE1dTh6VFNGZFF2NlppWnYxWjV0cE1XSnZOQU51azhpclF3N3laSHkr?=
 =?utf-8?B?dk4vL1ZRbEtvY29waFU4WGlHUzZSOGMwNzlKc0dsdCsxRjNqcGZVOW5XY3Ur?=
 =?utf-8?Q?lDXYjglpnVp9r87h0dS+masoY3zjcVuBeq/w4C1GPA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2966747DE5943458F09A60C75F2EFAC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b937fa-37f9-45ef-c253-08d9e4a28c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:15:04.2373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kFy/rKNNJiiUY+Du7OiiAEtintTvgNdPcC5OT6UdAq1QF6nOjSAyOTqVTLgF365FgNFlI5yh1XuF2n9kgWEO44rxBoqVy37QlwvhcHugDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4498
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
