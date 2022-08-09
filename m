Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C983EC19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 11:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiHILJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiHILJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 07:09:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A35511C18;
        Tue,  9 Aug 2022 04:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9RGWpDpQQHMwZryBlrzvWL9o50ZAq1w6otznM0YAYJuzb86HhTgyMcpGcIwoVD2RLIT1FGbI7lVhELXwA2GKagwD/W5wbhMy4u/2si77/gNelUGQvuIWP5spQJJ+g2Pg6OqjivW08lImMp/ojeaTFW8gyWW5PDZbAbmKk8NIiqLaD7M7gawGM/Z6Sj7z/2wSMtr2jMHY5cM3dfo+B4xqslZX+i5qxmvyeLipYrkjniWmcYcQZf9K6cfuBkTYYhkWWx3AZED4yUJnr7Yz5U+7tj2Wjb9cMJbTYwt2OccydtwCoSMA0ONTBNB1oybQ84T6yxcAEYQTUCwY/hGD50+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oi0dKMj9sVpxYnT8I+Yx6QcR+hcprPyplFsyZikf4I=;
 b=ZAQ2M96i3SohtGVOgEOcWnmPv3fi67absUCyd4AkjPn3n2IQMwFaepgs9wUp9S7wiFV9bH9QVmZmJ2N2RfjqX5JoQTYwW392odq6imTzhYue7fLRI7q+H5rvmKiblUFhnQCy9O/Om0So/VASpjUQ8fWYQWT2+fFsedLUOAjoIwexYp+pj0qhUJY8O/KSJZbSKeDqHG0nBAcmg3RetH7vGrVNrgAjZDlUYT4jQaH/vAPUsQJmb2EMS+DLeO6T8Z3GCPTwM13+koF0PLB0Y3lyESnSnum+JN6CPQ7biN0Cprs5z2dKyi4LHJbBk14g5mTI3vcLzYjVfPs3RAObYVukqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oi0dKMj9sVpxYnT8I+Yx6QcR+hcprPyplFsyZikf4I=;
 b=RUEVfibCCIZ9XiMen3r9dzjUZl4CyRzOa7E7Lth5SSx96UuZko4KNbuZzIKUyNuezLV/rUpwW8xpOgdlTWGF8DS7mh5dY/Oa5vumcrNGvFo6E2U/FEhbkVAwwq82nKzI5//l8OZxoEXHlbPYJHs8O1DtRJ6X/BDP759CPQsGrcjpWmL+wQ0volopkUw7VfnUzaw6Ey4JPZ82TSqfP5lVGEhbi3uucQPqLT0Yc7GxDA4ZaLU1x5Hg1WHIXkelDEhPyDysItz/v69DCzm6wpSOv6Huc8z0s4hZQF7Rh9VzG/Wz7Cgpc2SvZGZPmyobaOO18F1IewUOtTSgOYCyn2XYGA==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by BL1PR12MB5849.namprd12.prod.outlook.com (2603:10b6:208:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 9 Aug
 2022 11:09:21 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Tue, 9 Aug 2022
 11:09:21 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v2 06/20] nvme: Fix reservation status related structs
Thread-Topic: [PATCH v2 06/20] nvme: Fix reservation status related structs
Thread-Index: AQHYq4OnQJFgwy96dEGx0Jin94g0eq2mKb0AgABALQA=
Date:   Tue, 9 Aug 2022 11:09:21 +0000
Message-ID: <6df45cd7-7824-6676-8ce8-3e6e06838444@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-7-michael.christie@oracle.com>
 <20220809071938.GC11161@lst.de>
In-Reply-To: <20220809071938.GC11161@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3fe32db-db0a-439e-b5e3-08da79f79c3f
x-ms-traffictypediagnostic: BL1PR12MB5849:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJP/+QcQb6//uARap75l/qf/F7Qy5PtnNl24fh6TEr+3hYPH27dCYQ9TKqUrTzDyNYturbDWsI4LnYz86E5cDnD/U+SnQNZ8T+0+MwPl0vSrevTIq7opouk6WBCy1nH5QOLwy6fHCp+Uu/EpNsnIHNkBMjyzuROAMCUyfphVAzNm4+1FB4LmyTm+5bPdc4JuNtf6DX/MczIfo/Ew4QhlfbGnkipK9KeZceKP5p52W3DLZHWO6+m5/5LlOZJV6CiUTMsvhkteEFGMRdLKVMKYrVR64JlWC3CXSmoyxEHJmU1uH5X7I4PfcR+IhaMijuFkJslJyE6CwdU/tWlgO1M1TThwmuu2wwuOaeZ6imPuFyXtCx81GzpCOnsDcQzr8WDi9MONZEZiAwUytWjr3TcvcXTYcEtOg/e6eOVf1wg7qWe/Ry3JfxRDpRvnD8McWS8saERJRRXboKZQjcvj9Eb0e4VYBjwNbLe0oO+G1ZslB3UmjxVMT1EeWMIEiPjuHgC2WB4ga074i2eomTswKq48cGeFcFdwNOKZOlGTllKYPXEr0XSw+Lmbt0+wyDrMiMRfEK9FUkMs/oLF55FwhVL1WZ0DiV1/MF4G5CgZR656phdZrx7KqmjHALoXJFyuijzEM3jnlWdbW8cxmT+x8rJDkp2Cp5Kz7YQ/7iBRaCAXGichYXiKHeaAihf+Ofn6C/Z9r6TVNv7/6c/6htp26CtO3PVXtwuG7BSZf4lQyuF4ReO2OkKVhOzSLnX0E5Brt4lpsbuFxoC0YJwWeV4XV1/dGNm3BjjE+jZCd0Pd71H7TVC3zw+GxBC81MJqowLFZNZtlMxeHp4cnGiamK5h5AyP18KIHW2vGDax/b+zm004Gso=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(6486002)(478600001)(54906003)(316002)(6916009)(38070700005)(122000001)(186003)(2616005)(41300700001)(7416002)(31696002)(71200400001)(53546011)(86362001)(6512007)(6506007)(76116006)(8936002)(91956017)(66946007)(4744005)(66556008)(2906002)(5660300002)(64756008)(66476007)(4326008)(38100700002)(66446008)(8676002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1E2SHF5US9rUFN3UHl0RUxNNGdNcFA5U1hCZFFyRzE3V2FEdkRpVFFac2Ja?=
 =?utf-8?B?ZFNsS1dKSUdYSm5GeU0zeUZxN1IzZDR1Z0E4OEFmVnM2TURqMnJsRkF4cGlR?=
 =?utf-8?B?RnhNaHhlMDZBbTdvSW5xRXhvWEQ4aFMzNVp3Y21ZNnBGVFhpN0I1UkNhU3I3?=
 =?utf-8?B?ZjBTaGszZmMxN3h2VVBGQ3VLOGl6bFM1WEhVaHIzYVNqbXFyeC9VTDVsYldN?=
 =?utf-8?B?V2dWMkpmR2xnOE1SZnVZU1ZNZFl1eDM0UFExdmtQWEhTWDJ0YU9nV09ORmo0?=
 =?utf-8?B?WVIvdnFQM25KUGRZQ3hrOGV1KzBheURKS2lKWGIzcmJacTMwS2kyNWJ4d1U3?=
 =?utf-8?B?a0oxbXk0OUhJcWdwc1NpVS9JNFIxOFBHT05RUlRPVjVCcTVlOEk4ODlLSzFD?=
 =?utf-8?B?aUFVZzl3Z1hKcWJicmJrZEtranAvQnJMR0ZHZ3htM2lUMzcyMXFJVTV0MzlX?=
 =?utf-8?B?Lys5ekRjYXVXYzlFVzNud25UT0xRM0N4aFo4MHNreVpZYktQdFd6eVhpc0lu?=
 =?utf-8?B?elNSZ0IvZ3ZBbnh4SWdDUlVSbG5LTUUxdXFpUUl3SG1zeVFwRzhmL29zVXdz?=
 =?utf-8?B?alo4cjgwcWNZN0p6U3BlekJKczdMd2laSnB4TDJmRXQrR3RuT1Njck9nbUwz?=
 =?utf-8?B?Yno1eEo4bnkxVE9ValpjUTNHblJabitTdUF0THV3QUdFdXMzbmZpcmpMMzRu?=
 =?utf-8?B?cGh2T3h5aGFiK1F1MlJ6cTJVZk5CRWlyb3dNRi90RU82Q1FvSjQ1ZFhNYm1m?=
 =?utf-8?B?ZHBYb0ZXK0JUTFJ5NG8wNGF5VGhrclN3cFh4RDQyMjVveWlWNERNU0Rlb0ky?=
 =?utf-8?B?bGZhL0tlRkZIUGRxdWZlcWxZWWJSMlVaRGdyTVFEUkkyRThJT09ZeGk3T0Fn?=
 =?utf-8?B?dkh1RUp5UWt3MnlBL1VmZjFvUGZKTy9IWlRLdU44Yk94ZWdUYnZCSm9UbG9Y?=
 =?utf-8?B?Z0tmRmo1Y1FoYkovUnVXN291dHJNS2xjVjVsU2pLQkV2eVlTNmJPNWZoMEFB?=
 =?utf-8?B?UnQ1UHNTUFNxVGY1bWwrODNGRWlmem13a2FOc2xyeWxVQy81K0tvb0tKV0xl?=
 =?utf-8?B?czNGdXo1ZURmOHhycDFJbnBvOVJ2S2M3QU9CWU1GazlUOFZFdy8yK2ltRHM5?=
 =?utf-8?B?TVd0RUdkVHdTRmdnbVNmNmdrZHJpbStGU3JvYXdORFF2YUFsR2p0TFJJQmsx?=
 =?utf-8?B?c2Z2VEVNWjhKcThrdG5CdFlLaWIza1lmeHBTT3l0UTZQb3pmTkprdFJINkNv?=
 =?utf-8?B?dHNxdnYwczJ3L3JpRUxzVm5MSXBVMXMwN1JYT2dxazd4R2pTZXVEZVczcFRM?=
 =?utf-8?B?dlU3QUhKT1lrWjFkN2MwSnNWVGtFSzNJcFExdHVlUC9QSkhseWFvSGcvOW9D?=
 =?utf-8?B?ekVhZWpWQUdwcndXWTVseE05NkRuQjIzN0U5Q3czMnFmcTRlN2I3bHo1NmZO?=
 =?utf-8?B?NStBdDhrM0xGQ1EvVVdMbXFLZDUzSTJvU2FaNVZmM2VKdVBSN2NEZ2QwU2N3?=
 =?utf-8?B?SHdDRHg5MHJSM3VtdWZRTzFobTlGVzkvR3NjOXZKUzMySlpsY2p3aWNrZ25u?=
 =?utf-8?B?QUo5ck1QUkJLTTlmMnoxTDBUSkxRRzBYRzhzK3d0Zi81di9iMnVUSkN3eG1Z?=
 =?utf-8?B?c2hYZVMwdDJLUnoyMERuOElXOWZIeW8rQlpMMEcrQ2xIdTJjUFRjMklXSDcz?=
 =?utf-8?B?aFVzWSs5aitLRkUxOGhjVHZoM0EyZHNYYytaMjBBQ01ROC9xcFdSNVRnUDBu?=
 =?utf-8?B?bGd3Qis3b3ZHMWI1RHR5WG5yUnpZeVFFSFpkTEErUTd0eUtvbDJ1cjFCY0Zu?=
 =?utf-8?B?TmswWkYvbkdJMXJ0R2l1RmdCM09BalcxQWNtbXk2RGN2U2dQajc3dmJyejJh?=
 =?utf-8?B?L2R2RHFjTWJ1ZjZzV0VQR25ZcHRyaHZxUUJRYmxmNG9xb092dnl1LzdtdGlT?=
 =?utf-8?B?U09qSlFpNUpKYVJKTWJIN3VaVFRGcXR1dEhkSHZrUjFCVTN0ZmJhUndSaDFo?=
 =?utf-8?B?Q2Q1TlBDbnRVY0xHS0R2bjdaR0ZYTzVTODBjWlVrbWNzbEIyZjRTMkVxRFNz?=
 =?utf-8?B?aXZCdHJ1ZFcyNVZzUzMzMUxnUFhrMkZlejE0NU8vem1QSUpuYnYxN0ZyZG0z?=
 =?utf-8?B?emV1TytySVg0d21uTFUvOVBIQ0pnMUp2M25ocExyKzdUWVdqLzBEbVpZV2g3?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53B54AE095576F4FBC26B095C458EA9D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fe32db-db0a-439e-b5e3-08da79f79c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 11:09:21.1181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dGsmueQQrLUIaey02ZKXvT21gXZJ6pPgQ9a92m5CWWAqE97ktOfdmbhuARJFPrK9YsWb6QyOac/fFTS1SMrfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5849
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gOC85LzIyIDAwOjE5LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gTW9uLCBBdWcg
MDgsIDIwMjIgYXQgMDc6MDQ6MDVQTSAtMDUwMCwgTWlrZSBDaHJpc3RpZSB3cm90ZToNCj4+IFRo
aXMgZml4ZXMgdGhlIGZvbGxvd2luZyBpc3N1ZXMgd2l0aCB0aGUgcmVzZXJ2YXRpb24gc3RhdHVz
IHN0cnVjdHM6DQo+Pg0KPj4gMS4gcmVzdjEwIGlzIGJ5dGVzIDIzOjEwIHNvIGl0IHNob3VsZCBi
ZSAxNCBieXRlcy4NCj4+IDIuIHJlZ2N0bF9kcyBvbmx5IHN1cHBvcnRzIDY0IGJpdCBob3N0IElE
cy4NCj4gDQo+IFRoaXMgZG9lc24ndCBhY3R1YWxseSBzZWVtIHRvIGJlIHVzZWQgYnkgdGhlIGtl
cm5lbCBhdCBhbGwuICBXaGljaA0KPiBJIGd1ZXNzIG1lYW5zIEkgbmVlZCB0byBnbyBiYWNrIGlu
dG8gbXkgdG9kbyBsaXN0IGFuZCB0YWNrbGUgdGhlDQo+IGRpc2N1c3Npb24gaWYgd2Ugd2FudCB0
byBoYXZlIG5vbi1rZXJuZWwgYml0cyBpbiBudm1lLmggdG8gc3RhcnQNCj4gd2l0aC4NCg0KSGF2
aW5nIG5vbi1rZXJuZWwgYml0cyBpbiBudm1lLmggY3JlYXRlcyBjb25mdXNpb24sIEkndmUgcmFp
c2VkIHRoaXMNCnF1ZXN0aW9uIGluIHBhc3QsIGluIGNhc2Ugb2xkIG52bWUtY2xpICh3aXRob3V0
IGxpYm52bWUpIHdhcyB0aGUNCnJlYXNvbiB0byBrZWVwIHRoZW0gaW4ga2VybmVsIG1heWJlIHdl
IGNhbiBzb3J0IHRoaXMgb3V0IHNpbmNlDQpub3cgdGhhdCBudm1lLWNsaSBhbmQgbGlibnZtZSBh
cmUgc3BpbHQgPw0KDQotY2sNCg0KDQo=
