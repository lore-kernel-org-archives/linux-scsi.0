Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1C0C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358629AbiAaLqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:46:31 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26699 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379822AbiAaLoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629462; x=1675165462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=PDFZTxy8V7PjjjrzPk5u8H9DgLPggEBy/mPTt7gqNAryObH60mTb5YwX
   KZb9aTUD/Ur7YX1PUxka3CHxUeZtwrQ7/xl2DqO+cbPf5OjdGx7l4nc6J
   Ds5KqczZplAN9OcRNDDBlPy7AsLrGRDl0Py/4fb2hscfodz/3eZGY67ZU
   J/rAv0bblGnVglpADTTaLVUCtWVJ0eXGGKEQ/5XfjysyGo8Bpup5ZGX01
   NLZLR9ArgV6WSwb5ONYHFkZMn4gyhNtiKLgf3sxQRQmaLdHBYFJSza1Zy
   gLSot4Krh/Ok0jkeZQQwcriHFFZ6RBEx4zssXB+lAAjHsRGAbazZeYQz+
   g==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="190747460"
Received: from mail-bn8nam08lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:44:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlYgqiawdcWZsSOMd63QmCdpUNHA9ZmEG0oKTtUkVttf376xivEOuBAxZHzNRF3lJ45Q5PD71t3CtQje6jfe+CR+AlaqhMpFk2T3Pa9PdGwBUp1SsMo1ZsJORQVCYOWzKjZn0P5POcffvjMtpM2loHo+p2g+4BXVxaJ0kiffHmDkhbHIB9+HWv90u7kxnPgKpyeyHU1pPWUMM/WUxjbLiS9WZy/sYKxFRp8bPDwbpWhXjLC/XJudxBh5Sm0m2XhMffuGSoI/+ZpchexmIn47HBpIyedKhb4oO/xe8UgmWaTPFCItNYsCVrdpTCRkgpcZU2VSUE0KQLFQVl0TNFTLMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=TaQzgIUAOUPvOmmI3gdNB+ZYBHPYoAT64WpyjzmKHMlDoP8cZIeQUxZLTCP59s4DFOonKviLNTf6Tz2mTUju6wjxqloyAMPVUED1hYHUv/pL14wmtoaGcH/7TosikVHcmWqvS7BM/6nDWSv4nKu5p7dLPKapqFTGjrPB8rg2kHEH3LV6qF58PWcB7VLmOzvXBpfzMDiOLIjvfgkUvOmb8gtId9wPqQ1rcrJuaUkE+OTyzH3APcojUxxgycuYPKJQF8zvLguEOAlpOGZ8AX1Ij5DXsmU6LRASTu8Q9jS9XW4wJBDfAZ9cH0NCfnzEihez5LUFsGx6P8nahwvg2kZaXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=NZJFNMxfBtE+kgI7Ua7xcIz2mD9/ZR0jS7vgg/TdIqg3x6Cw7msBCjF4RzHAyspWHqpNAti97hgHn/l4bz8vVGdrV9GzRqeccPRS5iWUu4M+8y97v4Qo+TjW90ImBNBOhICClv9KESZnku5xsQPftJTYY5wohZywrPajGZEzY9U=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN4PR0401MB3629.namprd04.prod.outlook.com (2603:10b6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:44:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:44:19 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux@zary.sk" <linux@zary.sk>
Subject: Re: [PATCH 41/44] wd719x: Stop using the SCSI pointer
Thread-Topic: [PATCH 41/44] wd719x: Stop using the SCSI pointer
Thread-Index: AQHYFJWEWfN2ps9+Wk+M7A4fFzhJoqx9BpWA
Date:   Mon, 31 Jan 2022 11:44:19 +0000
Message-ID: <e769226ebb0afa4e6c11f514aa7150ce3606400c.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-42-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-42-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 320ad4d4-4de7-4762-ca26-08d9e4af0458
x-ms-traffictypediagnostic: SN4PR0401MB3629:EE_
x-microsoft-antispam-prvs: <SN4PR0401MB36292240C7E4ACDA6269DFB49B259@SN4PR0401MB3629.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3w5/6JLqGiYkgrmauJA+0Xc8W41eydV2o+nejd3nOEHgLHrGgY5IBidW1tFTSNfRO1cx2d6X17G0k0xhJ37AiYQbXQVpQ7ZMoc/vKXCTWcdPEI6kUDQeLTwsN1ZYHJ7K35JIuVYmBkrvbMRzSTXVWycOfa5/AwJbxbPwnOYmbPAdM2QcZpK3auzbfhQHL5GhdLDLhu4s8iXYdGdXdxZScqRSyZg+gsNPKf5Uq6afhwyPigI+pU3TyAyztCBRlV+2Wv9K6Kygv53BzhxsbH6mF4H/UmwjuiYzB1NNS6pfzqUC2yxSE26Yj1JFqdrNgv21C7fT09zu9rzp23LGuLLrDsrajc3mBrpt7VW4oTb3TLYwp5dvBYojcBTBHDVhJE1CgSSJWW71mqLyYlt8n4egkPmfBFPYeOtGODkM3CL2wDkwSvzLhQq6sLpsSzAInImhpb39vZkrY5SFItuhcGuTWie9MswF1I6UF7ar/t+FE8E7YBCBchmjpKLk3CxavgbjtdoquAChsBjN2bzBgF94eh44i3m9gnAt60UjLH57cpgSvNpZldODPxxck9EpZPAwDjnKrBG77ZLoWTrQuktoLRDyJP5UyI7zV1E01NUAGuPNyymd/1WwFud8FX4rxrD8I1ncwczPWE3FwwwEwYN9Hqmr570poCOXZdlYtslvVe9vDwiDiacERb//viAjxA2efoTzoWU79w4Q9v0lxJNvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4270600006)(6512007)(5660300002)(6506007)(2616005)(71200400001)(2906002)(26005)(186003)(19618925003)(86362001)(64756008)(66946007)(66556008)(66476007)(122000001)(66446008)(8936002)(8676002)(6486002)(4326008)(38070700005)(508600001)(54906003)(110136005)(82960400001)(316002)(38100700002)(76116006)(91956017)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SStZNmVnbWFFcUEzTWdMRDNGRWkzVVg5d0RCYVNYWWtpWjlYbEY3SUVYMyt6?=
 =?utf-8?B?M3JvMWVQeWk3RGJ1UG5hMVRtOG1ZcFplOWhDajQ4VDBnY3UwMUtlQVQydk1p?=
 =?utf-8?B?UGNMVzFkNGR0Nm4zcTA1dDN4czFzZjExSFR4YUNIb09jV0tYcVp6VDFiTkN2?=
 =?utf-8?B?ajhWcG5FRU9GOVhSNFhab2x2dy81TlpmeU5xbzJSYUt4cjVJL0F6TWZ6WnVt?=
 =?utf-8?B?RjNNNmtBVHVyQk5yWTBLOVl2ekxNUGpXYVp6Rk9Ic3N0QzBRT1hGeTJyUlJE?=
 =?utf-8?B?UXhjR05nSFJ3QU96Uld6WTdhaVcxSkJzUTdZYjA1aWpVaVY0TTlGc0RqR1F6?=
 =?utf-8?B?cGF5d1E0M2hVSGZVOXBxK2tCbkVVWHg2dzlUMEZadWcvbzRuWng3TzBhMFdn?=
 =?utf-8?B?TjU1WHdKVjlxTTNFYWV6K1hiMFpuSW1MR205ZTRweGpIVmJodUszYUROa3M1?=
 =?utf-8?B?SVZpUFNITjBYMVJuOVJQdWhpbk1VdGhUelVNREs5WTh5NG8rd0NGWkRPZkFL?=
 =?utf-8?B?RXRSazhYN1ZyM2d6NUdMeWxBYjVHMDVSNWhLbDhsdjNGVER1cGNhWFNVd2R0?=
 =?utf-8?B?Sm4zcVRTcTEwdjkyUWUvZlRodW5JVytKMjNLK21WN3pwRTBZMzF5Y3dobTIx?=
 =?utf-8?B?V1Y0QXVLUVhTOXpjeGFuU0l4Qko2aXo3THFDcUd2WEduemZiRE9PLy92QUNI?=
 =?utf-8?B?dDdEVlhhdzZOMzlJbG92RGdZZHE0emZtYUxyNkRRbWZTVzZnT2szdjVpT2p4?=
 =?utf-8?B?V1piNTI3RUJVc2NMK044ZC95V2tMRnpBajdjU293eVM4NWJXMVJUaHhNY2x3?=
 =?utf-8?B?cFJjRm45WWk3dTJlS3MySWZTVG5qbzUvdWE1WjZVS1BwZHhxWFpEb0NPdU1r?=
 =?utf-8?B?aExTckVDcjZzK0s0RTZTZzBXQWNVVWUxMlhNVkhzd3pZa3JGVlMrMjZiMlJr?=
 =?utf-8?B?V1d4b3pWbzJKem0rRitrYms4K2wzOTVwRlVFWExHSFYrQTB5YVlTZEY5YXNo?=
 =?utf-8?B?bERoVUN1cC8vMGM3L1prRzVuUEN0ZGxGZFkvUHVEVmtEN0NOOWRzSlpUMy9Q?=
 =?utf-8?B?MlllZmJHZDNUdEd5RUlMMkpGM3pJM2NkbDVqdVpsS1lSdGtjRURFV3ZQeGI0?=
 =?utf-8?B?RGhVNTc0SUtENnhOT1BiVnBWYU5peW9ldmtQUDJaMzVvcTVuRDBhNmNFdTZj?=
 =?utf-8?B?SFBSUS9KemVQVy9RNENSYXhUZUoxYS9hcDBHWEoyaUFpTW1zS1JzVmFvNkVQ?=
 =?utf-8?B?NncyYk5iajdtNHErejhNMDJmVE1KNmswaWNkTGpyL01jdGJ6T1ZxdVB1c1R4?=
 =?utf-8?B?a2RzejFpTEhkekpzNkRSQkE0YlZEK3ptb2NOeFFSWTVXR3J0UHJDcnlxWm4z?=
 =?utf-8?B?bW4yaS9xaC9iTUNuTUcxeFVMWmFiVWJodi9LblVtNzcveHBxZElUTnlGL2pq?=
 =?utf-8?B?aEc1TnRvbStVMElGM2xUZEZmeC9pSzkzL2dhL0lUb3MrUXFYOXdjSlM1dU5F?=
 =?utf-8?B?WmNGejF5K2V2emJuR2VVYmpIRWxXQ0FSNEZjckpJVWEzQTNXUU9BNlhBdlc0?=
 =?utf-8?B?UUpMOTMzRkc3MEhTbVE1ajZjamx4enh2OW14dFQvdWlucEdkK3JleE9HUmVp?=
 =?utf-8?B?M2pvQk1mM2JuVm50dkZ3OFhDTDZ2VEJDNGFESWc5NE1JVmliYzA1ZUQxL1lQ?=
 =?utf-8?B?cUpqMXQ3OERyejZiQW1IaVQ5eXNaNERaN2docFZBdEhiM2RSMFZxMGJqRGNi?=
 =?utf-8?B?UzIxemp5ZmRTZGdaUW5IczU5OWlJU015Y0VJbWVDYXJpc3VWNVY1QWNDNUxp?=
 =?utf-8?B?UVZXRG5wU3pZZWlTejdGTGVQU0dTYlJFT3AzUFpkVUducFEwVUJnQXdaY1lR?=
 =?utf-8?B?OHcxZmFHR3FaZGIrdmJBME42VDk4SU0wb3VwQWQ5NzZ6WG55cFlFU0xyTTNu?=
 =?utf-8?B?WnRRczIyOHlMK3g4amRqb254N2FjcjkwS3hjWHpjUUVSR3ZEejFudEQvTFI5?=
 =?utf-8?B?enhhRm5yMHJIQjczRkRrdTR1OGM3czljbmJqYmpLZFliNDQrVlpLaEoxMEdu?=
 =?utf-8?B?UVlOVmhpZ01ua3ZlRGdnSnZwZDFXUjJia2l5Y29QVWF0N0phMWtZeUpiNlhG?=
 =?utf-8?B?dmFhNVJ3dGhGOHNPKzZHVzVvRE9TSHg3dDZGRlY2ZzlVQVkxL2xIN2RyaDNJ?=
 =?utf-8?B?NmhndHNJcE9PQVp3MUQ4S2t5MTNQM29oZTRWZHQwWUYzNXVhQjVrSDBVdVhT?=
 =?utf-8?Q?CpvZeSoDCTyeEH9a56JZlkcD2Sa6ZTHOkxfsmqlK0o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A9E04791DFDAA4682F545FDAB312CD4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320ad4d4-4de7-4762-ca26-08d9e4af0458
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:44:19.1723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //JUTjKgWa3XrHY70rziPxp2PZkJFqE5UxzbKnzZwxUg+zs7Gd6I8gM1vzfJXbiP5xh/vPmbqKO9Bsj2aUzEH8sArYY2sNGPi3DOiK8R8dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3629
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
