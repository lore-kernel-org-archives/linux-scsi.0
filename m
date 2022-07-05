Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A00CCA47C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiGEGmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGEGmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:42:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A986F2B5;
        Mon,  4 Jul 2022 23:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MK0geH3ngOKeImXRds7ebi9zRkpAkK9LfhFTbOTmsXbNuFTCxJbBzA0DsZw8/PJciw1Xpbxny4vRj4TCKhMgbmHeCWs9dUU4Kj/l6DnJp+NpAAOmKuMUy+Q5GgvisM8gS/wngpl1h+9qGe0V/urIGpQx07KUxh0V2KtaOMayx1yc7TMpcsoRP0WCfUxrQUPSOwFty/HlJAUBd2074pjhOANOKrwbbvgH4kONKcTZEgltCISiUSLydZYP65E/cMdUrkp5h5yubVQF3wBYg1e/1FogE+emkOLrjtoP++N2E5ySqBMVK+w0dWvD4xx2em/z0WFIonRdvnZnyfdjyLhToQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueJQdi40F1OTxDw2Qt5UBDgTL7GClcspviH2wp3nTPE=;
 b=F98voltMKPtCKGfw8CyEA4eKbs6NTSWwJxszphzrxs9cnN+3UBPs7Cbhe+QapaxFG3k6k3Jc62dL6iDjktGtdauU9bUIK3fk2bnNirqzW8wJw4N+hEnQiM/CuA8CJMW96ExX7szB+cLNFWEvJcKr9fAppRvK5vnsdu6KBOiIwO8Ds+QzReUvpSnmFjTIa0kUon1sqSUNLErl2G6YDKhIN8Jsq/DnCOd1hgEdsSI0W/uSxU4/UwhqnejP+UkH8aci8Av4QL+dQWLL/GPf/DJe/JlBfaCuioIf9MkGOEyB/VtyCZNA0i2u6RZ2G2YcSELuipzCAX8XlMgnLUMwvlspmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueJQdi40F1OTxDw2Qt5UBDgTL7GClcspviH2wp3nTPE=;
 b=IA49WAQeTluUCaszZAQD5+RaJ9BJuzr5rcgKBgdUHjkXpP3xZLp+A0wwvoXpYnsAJVQrdVFqe3MljG7YuUuv0Vq1rq+1JvEPB6DBU6EVF2994MJLEnI8v03GXibJRvEWK0iIJxkRteI602gZEUdUMxvREo1WwChiRvebIZqoHShHjQD4UHJgxmCVPk87LdLuF4SwgwPqsOjCOK9tgB0phciGuRz+T7PVbq3Y02PXXAbTZTSqpeUEhKZ3CrNUOn8VqyDXOcuAPYynpi1YVd8EhDMrH4A0k43V+pzPGz0vVefssSbqb2UOoEvs+WoCp7JQ7zfEqafCAhofXpLjPTydwg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:42:36 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:42:36 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 13/17] block: replace blkdev_nr_zones with bdev_nr_zones
Thread-Topic: [PATCH 13/17] block: replace blkdev_nr_zones with bdev_nr_zones
Thread-Index: AQHYj6QEyQ3cQdKvGkWmk7qRtNMn461vVYyA
Date:   Tue, 5 Jul 2022 06:42:36 +0000
Message-ID: <cf1ea2b7-8de2-3217-669b-875593c2f467@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-14-hch@lst.de>
In-Reply-To: <20220704124500.155247-14-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5288ee8c-b386-4977-ce19-08da5e518c00
x-ms-traffictypediagnostic: CH2PR12MB4837:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GqTpphg4R2JBKBu7LRdjW+mrtdjfN8Bl32bDWKq4ynhj16XerzQGLacVNRcWLp2GlpFjtjEE574B82SU7yhx3i2nQvMwhbdvCC2zVBpF9+GSj5A//0y583LAxJKTO7UnBptKqH0twcuil9Uwe2lsHp/NP/qdw8Ed979icT+kB1zwSzXB5dKs/fCVEq2wyvr1JwFy8VC6tAx6WnLRT+GbRlSWecOd8Vc6VoQaks12zuDNHHqqmmKLu5jdIrdUuQhLHgLBxjG3dkTj1MBBhDeMwSvav/bxmJqbkdBIdlxKpvSvpBYeMZjgfHPonVebBoZqPpyPHbLAR7qwsZT46W66IKcNqXyCr2cIsAYSoJjwJDoumgNEJDXe3TjO7FD6lo8Gw8uB7630F6ol/CF1uqAc2jlprasPwJhDVPWVXND23Awxn00DkLbNfb29OTV7WW3/BAGgikTAxi/HPnpCcUxCLYeX6NQahUksnmFNXCKCaTXJ5O3WfdejIIqE4G2Fq0lLeX/OkckFIzq7g1D1pforTEtDLBadl/Y2OBzxgwbwzk2IptSu34yl62FXnQ0Ii/DxKMDadbGfRYJHVK2bzWX7XragBEM9//sUotlROXHDJCvOsrITssQZzSCS+TS8V4MZQtui95EV2I+CZksBGy2oVtlMbF39uqlteG0esIfI0u2ocGQAwJE8rHDHGLqDnbpfSAxyStTYYEqTI0v9Gm0TEdLM0e/U7wXMiM5W1DzWGH2UeKSam3p8OVS43y4PzA9/fNSEgvWfEywu6CNPsyPNEvjnZSVDKnBP834UxUnQYqiavt+uaOUxJe10Sx3EeQlW7G75n3Nt5he+Z4xH97CjTPVvs7jyovgRg8Hwg6c4gSGbBFRtUfFspW1OtLgV8RWl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(8936002)(31696002)(86362001)(478600001)(6486002)(83380400001)(5660300002)(558084003)(2616005)(36756003)(186003)(31686004)(316002)(54906003)(110136005)(38070700005)(2906002)(6506007)(6512007)(38100700002)(122000001)(41300700001)(91956017)(53546011)(76116006)(66946007)(8676002)(4326008)(66446008)(66556008)(66476007)(64756008)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2ZETE82T1pIang4dmR0QXQ0RUJnU1JxaS8vdVJ5ZXUvM0VkTlZETjFCUlFO?=
 =?utf-8?B?bXBIRFFxalNCMjVqOGcwcCthMDRNeE9zRE9pdllNUWV4MUtkM3ZGNlovbmM2?=
 =?utf-8?B?TGNyMTZTMnVWMTQzLzJ0Q0lhTmJpL1JYY2hWQnhGdFR3MkwwekhzdUQ5M0hq?=
 =?utf-8?B?cURMUVhYbUtMSldCZS83bnBUNUVVTXRZK2R0dlArWkMxVDdzdms4bEZVTzhj?=
 =?utf-8?B?blRDUDBZL3Zycjd3RUh2UjdpOWtXUGVXRU02MVUzWldKcHZneXl1QVBvcStD?=
 =?utf-8?B?V0liMktwUFo2c0ZycFhhTDUrb3ZJSEtXOUZ2UmRrYjBvOE5taFZQRWsveUFk?=
 =?utf-8?B?U21FV0JBSzIrWFpTYTloYnNCQjFWR2R6dDBGbXdkTmtveVRrdlZEU1dsa2N6?=
 =?utf-8?B?NDI0TDk3ZnhFSmVwNzlnTzljSUtqN0kzK29tNHF6amZaUHZnYURmc2dOZitE?=
 =?utf-8?B?NzYreDRZSUd2akZUeTIvNW9MdzJ2TkFYa2tvU3hVSThVVzVMRjBXbGlSRHJC?=
 =?utf-8?B?YnE5b2s4b2l5cFc2T2hLaVlpQy8wKytUd0VqSG4xYi9OTjBWcUFKem5VeHZM?=
 =?utf-8?B?UUxaOUFrTVdid3FjNC9OL0c0Y3loL2pBa290VnNza0NRRW1mTmtxSEUzODNJ?=
 =?utf-8?B?RlhjTERaU1F0ampTSkFRWVMrMXNHS1ppM3c2Skh3TVZVb3ZmVGtYZ3F2VEhm?=
 =?utf-8?B?eWlSWTloNEpxSHhqVXF3OE1HUkFUN2VnbXRXRlNYTXFuQnVQNGJGWUtXOUlm?=
 =?utf-8?B?TU53ckd4SDQvTnNldXhGU2hDSHBRR2Q4bWdkcUhPZXc0djQ0M01QMmdyUFdY?=
 =?utf-8?B?YnJ5MXdGZHBvVmFpc1hHNVgwUk1xUkVrNnRuZmp6VUxTRGZtU2tMMG94eU04?=
 =?utf-8?B?b01GRUxvOVJsTlpUWThzNDZoblZWQXZlZDlma0luWkdDeXV2a28wNEF5Smh6?=
 =?utf-8?B?OElTM0wxVnRHMlp6eTd5bStucEl6eWxieVdJc1dVZFYrMUt5bng0RjdRRXAx?=
 =?utf-8?B?dTJwbGVXNko5TU5kM0lJczM1L0YrcC9ENXh1dkxMd0ZVWWUxVlVoMk00M3Nu?=
 =?utf-8?B?VUhmVUVTQ2dTRytvMlJPYlBiNGJJblF4MDh2TklTd2Z2UmQ1SzJLU2lsWTA5?=
 =?utf-8?B?OWdTa09yUWlVU1pjbE10WGQ4YmszT0IrWmo1K3czSUNNbDR3a1dCNEM4bmVN?=
 =?utf-8?B?dDBUQmtoZERaZmJHanI3TUdWN3IyL05NTmM4MWlJNnRiQldtQklYQ3EyZGJZ?=
 =?utf-8?B?dWNXT0VNYVlGVXZxT1F1NHF2N0MramtvUmk4bDZoZUh3U1V3b29tbzZOaStM?=
 =?utf-8?B?THlHZHFJWk0vdGRub0tSVTlXYTZwSU5TVzRXbFZQUEZwUDFKSUwwczlqRk9J?=
 =?utf-8?B?SzI1cStSRUZITlVTSG5EbUNDSUdJby9jdWVJaFZsZ1lPYmV4WUJFQStrMnQ5?=
 =?utf-8?B?Q2xyTTFkazdkN09VOXJ5RXpwQUF6MXZ0bGFmNG5rZW1vQ01YczN0WVEvUFdr?=
 =?utf-8?B?a0JsRG1pbFNwdXdtUDN2eEtuTkFKbEd0dnVTWFp4RjI1MTFKeEd2aWJNNi9I?=
 =?utf-8?B?WVNzTytSaXBoRDliZ3BzTjFhSnVyNzNFeVhQdUJNTHNsQmdJbnZCMDR3KzR1?=
 =?utf-8?B?bTZuNWVOeHlJMFNwUjRvQk5uZEhnRGNSNHBUYVhiNlA1d3dTc2FqK0xDQ1Yz?=
 =?utf-8?B?TmZIM256OVpoSHEyRDB0WGd1Qmk1NHNrcU44aDlUOXNBaUNzeUhKcWxXd2M0?=
 =?utf-8?B?UFcyT25EZFVwVEhibW5yTEFXUGZFYVFmc2JTNVVzN2tVRHMwdmNkRXVYc2Jq?=
 =?utf-8?B?MkVUNWZjZFRSWURnendJelo1aTNaeUM3QzFveHFtNXpxblBicUdOajlQRUVB?=
 =?utf-8?B?MEJlYTRrZjlKQU5ZV2prcFN6RUloV0t2azRmbEVNcThNeTF2SGJ5RGV3aVp1?=
 =?utf-8?B?ckdXWXRaM2EzTWRtaHFZYUEwWnFRV1hSemxROFNqYWdIQ0FwQ2ZseXlUZmVr?=
 =?utf-8?B?NENxOE0rYU5XK3o0cDFEVjd3T3V6TXo2S09uR3R2eE1FNzRCNkdOSXJnNmF3?=
 =?utf-8?B?QUdHMHVCekg5bXlORDJYZTRXTlVVUEw0OUxYZlowQ0x2cG1XbjlMTUpjMWhN?=
 =?utf-8?B?UjBKOGhMMjFnNWFuM0RLSW5QYkJJVHhqYU8rbm9qWklzVEViRE5raE4vdnRG?=
 =?utf-8?Q?jprFIdPQNb6atdqCR+oX/+oTbHLx9AXSqLaC+66yT9zE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EF3C9EA19F5FB40907675D8DF845A27@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5288ee8c-b386-4977-ce19-08da5e518c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:42:36.0415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DursRe41LgAl59MWbFo1ATovFHE0VlF63CSct+PlrR/vT+ycYRbyFTzPVTzlKQutatNzaqNFXpkECvGho1K6+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy80LzIwMjIgNTo0NCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgYSBi
bG9ja19kZXZpY2UgaW5zdGVhZCBvZiBhIHJlcXVlc3RfcXVldWUgYSB0aGF0IGlzIHdoYXQgbW9z
dA0KPiBjYWxsZXJzIGhhdmUgYXQgaGFuZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpSZXZpZXdlZC1ieSA6IENoYWl0YW55
YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
