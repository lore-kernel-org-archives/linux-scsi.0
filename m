Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49115C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 03:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiCGDSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 22:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiCGDSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 22:18:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630DC45AEE;
        Sun,  6 Mar 2022 19:17:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lc6bIL2y34APYLgGTw2py3kmubfyq1SMZioshXfKCHi0Ym+NBDQdduDD85kTAGFQBhg7YLBHMxR/vxJfgPuGQBHNoYZdJH7mgHP/0D2p59xJktKoip9PRhDN9sjd7ZKnYx0fOJrl9CyjsLe1Lq05Nz8Q1yhxqH++7urhwuKTgJqxAn+//A+r5R/c9qTZ2nwsOoU4wBQfpl0PPag9V3O/zAJRMxTHZsm91wqpSWTr6g4H1dVKHmsXGzU5nvvYRfZtiLckAgDndPRT4e14PviTj+aIokycx+9oIeQGLW+nz4+0Bguz4dOZnp/e6ppDIAmGv4uuU8+JUqx+PJIktq+61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hnh1h0T4fwqLgK1p6RaZHKzg424xzlMCRivkSfEIrGo=;
 b=GJaRqwtdWiNiH1BDLMhZtMWlIkevwBH813Sn6ylupZAMPJi3QKW/inG9Sm+PQWPoKOhQRr/NwH3Rx5d+1EqJUna3V5qhavuVvSkN7bzL6gLMARU3oF2thPfr4CF+ZoC8Je8vbdb0FDafZW0fyqJQM0HWAskMLK5OTgyg4Sirshtjqju426x/sgw/1o8bBeEMX6kyeAFDEngnO6xgk1UdL8Gx22+WKOR20nX7vjVgUHsQNocNoWVP+v5/icjQUGEKbmzkXik3X4M+hu4YWI6aG3QA17ZG3RqpBKd2UjMw54fEx6/f9Lqvpv/Q0dG3VJnHzxJ+/fekMsDnEYEDHF/v6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnh1h0T4fwqLgK1p6RaZHKzg424xzlMCRivkSfEIrGo=;
 b=aBYJp/4LzLBRb4KMrJGPQHFiMaECH4dTkHiw2m20MHQuDPMJb2LUotkPULj+KPf+5AcwrQ8ylX0Yg/P22F8YoD3PBGqmPd85MhIJulybY+eXX3KytFylElv8ypFCrZu1zZH2L+9OkQyZKW2f5HNBkRB0MMkn1qLz6aMuxfGVW99wrlMzXU2ZtEwxSZWTv+9k28SJodJyNwgq9CRRHBdqlzsVUfspGkipo7tJIOwCFHyMgoy2if4eh5bscK7pUUY+I/vxUsSczBGMEZTGIpB4U2KS0tBsBIjsvgiXs7nozEqfibzGIYWKHFThybndxqX5zIi9iSi/JV7MqR6MfuSyTQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:17:18 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:17:17 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 06/14] sd: delay calling free_opal_dev
Thread-Topic: [PATCH 06/14] sd: delay calling free_opal_dev
Thread-Index: AQHYL+F5puYmmkFnpkOsCsnByu79iayzQ++A
Date:   Mon, 7 Mar 2022 03:17:17 +0000
Message-ID: <0d119d4f-39ec-5df2-03fe-f00d90368fe8@nvidia.com>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-7-hch@lst.de>
In-Reply-To: <20220304160331.399757-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1864a224-0f8e-48a9-f6c4-08d9ffe8fc39
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB185334367CFED4AA1A83F70FA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4sXpcQI6tBoOX1TaRujIn/rtGZqiKUCkxbwQrrm8B8FyUaFgHD38AiyFA/wkBhMgpiM8jIz9wo9a6Vyep1BV+Pak0eFQOO2/HNFSyLnngbJioG3CQMK5gzEL2QcTr7HqzjBrgjcycdlEORknIJvVB4Ni262UZ1JPqSAt+BQvCCW3+0aRuH1LXbMSZj9ewSJJ8H6czhR68tZqgtuaLrOqlPwO59SJ/+Mt+6xS1fM3scVQ2ziYxpjF5j7CaOCP/9XRrBGfKjv+B2oz4qaAO94RXN15u/wDxXh3dVDufu8cvPwxpNv+J+R546Evv8gTDKKctCpZybi3mlAfatptOzHoqwrtXmb4o3KHiTcyKvM6whKWMH3LTy5GUDorips69H1Zb0fcCU6vdCYtDN82kYDR857mlI3BFiYlf72sfppOO7LAu+XgyalJnR4/cIp0WQmbsPf4j06l2bLj7iDtrJuB7xLN6aEkY/cJLpFi64KhCjfUFuG9gjouskCCAr9wvCzY0B96TDauK6KT6kBxvHXpFRYGPxb1X6XNn7UtxxjT6vSAqQaM9P+NsvdBMaz5OYY64PuSfoenADk0CU+4vgl+g2UTfxG4NPhgx328pwQLq7ehV1vB4Z7jL5Rd9QEMGOHkX92EQAzLwJ7CELJKhiuN6fuipBEjsaQC+q0JxuGAq3QKbddQ5ts1Vh5JGf7imS6PD4WfWOMp8+CagrogZlMj8QHXm3JETolxzmQJSwE+Juxqo7edu6VuV1HDY+qdhc73oF1S+EaD7f3Y7k1DBTdpug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(4744005)(186003)(5660300002)(83380400001)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWp0Sk9qUTdFTzZ2cEpIOUJWZ1ZwYjJxbWN0cW9xNWdFaTcwV2pXd1hJdnk1?=
 =?utf-8?B?eXliWGM2RGZicHlCYWt1SXN4c0FXL2pLOTViWTl5VnNPUjFxbUxWL1R2eTNN?=
 =?utf-8?B?UUQyaFJzS3JoTVlFQ1BTdU8zVHhua2Q0TkxGTXJqN2htRnNXYm92OTBLQXZt?=
 =?utf-8?B?R2RML1NIKzJPTUdxR3AwQ0VLZmlzQllRU0VpemU4ckR0TmxlYmY2a21lb0xz?=
 =?utf-8?B?TkhGejhkamI2VG0wbm4raXlkNk5tdTR0T0t5SFFyeUZUV1RJa2RUcmYwL1ht?=
 =?utf-8?B?YTFESWVVYTErSW53ckREQ1VZamJFaDRYTXZHSTYvK1VEbnlkTURTa0prdGh2?=
 =?utf-8?B?eWJEZUtObTJaSnQxekpBY2U0QTNGbWxSb3dXb1pSeFRxM2FYZUw1L0dWb0Jw?=
 =?utf-8?B?L0ZHVis1YlYxN2hxcVhEM3BaSHFFN2k1Z2JHSUZNVHZDQTM1NHoxYWZndUNE?=
 =?utf-8?B?bDZHS0lKeUUwMGxHVk5XTmdUaTJDZGlVY1pVaktwNGlSWDNGMysya2N0UGNZ?=
 =?utf-8?B?RUF1ODJtbnRnTGFSTElreU5PVVdydm1xSk5HbEthTDA3NjhZa3pKb1UwTEli?=
 =?utf-8?B?TFBvZ01YclRZdGhXQXN0MGY3T3VNeEViMDgvSUN4YkdXOE9YTmZHMlB4bmpj?=
 =?utf-8?B?ZHlEN2w1Mk1qK25pYlZyU0ZSUXI5SmlHWWI4YjJaY3lNemM5RWJ3c0RGUzVa?=
 =?utf-8?B?N29yeE9CUVRKZytmVnBtV0Nxb0dKbEtnS3AzaHBOTHFOeFl3RWg5N2tWTlI5?=
 =?utf-8?B?OFhnUkpFdnV5Vml3MTdJRWRDRStSbmRSUlBzbmQrQzF5MlRLQXo3eHJnMWRq?=
 =?utf-8?B?VjRQL2c3Ym5LMmJsNE9hNlJhbkhjTEUwejhrSE5qNS8xRElBczkyZStkRHc2?=
 =?utf-8?B?K3EwaCtxRzQrUm9HcmU4NUVDNS9LS2E3Z1JrUUVrcStGN1BCS3poTXRQWEsz?=
 =?utf-8?B?YitzL0U5SDRKZHVIT3pRb25EMUhLV2NTdXFIZmtNMi8yMWZBZW1KL2tYS2ow?=
 =?utf-8?B?WWJyck9PblFoVEJmK2lzQkRSOSsxRlZ2NlRCRkV1c2dzaG9oSnBobUI0ZXl1?=
 =?utf-8?B?QVo5RTh5d1M4QVRCMkdSUVVHc0tNYVoyZEFocHdMQlNSVlZrZ0xrNHF0LzFB?=
 =?utf-8?B?S0lwSzVwNGRxT0J0TE1JUTdqSDB5bktETlQ4MEpJVnpLRm8wa3g5WHFUdFd4?=
 =?utf-8?B?MkU5cHhuLzJVTVE2Wkd1MWFtakEzNHJVcERDWU9raWEveVNxRE1PaG9ZbEZT?=
 =?utf-8?B?eGVoQUN1TEdnZ25HQXVZZUYrK1E1Uk5iQ29GZFV3MU5RSXJObXI4WkVNbkJ2?=
 =?utf-8?B?MjRWc1ZocDBTQlJ2Tm9iZlJIWWNITTZsMk44cTdFVEZ2OUdJSTNWbnBrb0FJ?=
 =?utf-8?B?QmpqOE5WQ01qVkVuR1N5SUpYRmk3bVN5dFdJYUZNYktQVm5TWnprajVUY3lC?=
 =?utf-8?B?WEJLanJiT3FHK1dJY2JhcVBBNXE5VjRJSVpBcjEwUXNmdHNVTThhRzZCV1kv?=
 =?utf-8?B?UlZMMGlUMkpYSE5nT1JDVS9JUkJlMmhuQkU3bzIwbnIxaFhialE4VEJWRms4?=
 =?utf-8?B?dXAwaUVSSUpFSW1xTnN5WHA1SGJhQ0l3MmJiLzIrN3hIS1FaRnBjdkwwWlJ0?=
 =?utf-8?B?dTVmQmU0aGV2elFocnozK0xKOHUxYkxjTCtadFNrSjFOdW5DaXN4eXBJK1Ba?=
 =?utf-8?B?OUpOOXVUZngyWERldkpHcDJpQVkwZXlKNE45MVBWUE1mTVU2eXdDVnBIWWVY?=
 =?utf-8?B?NlZkNXgrUjVGSmtvZy9iREZIZ1BkSjIzMGpLV0tpZm5EQVVidmZPeGlTL0pr?=
 =?utf-8?B?YlpxRGR2OC9QU3B2dklkN0F4N1VCMVBmSm5SY08vVnVhYzM4M1J2UFZ6Y3di?=
 =?utf-8?B?M3R0ck1nVkJ1Zk1sUmlvOW1pRWU4YXltRFlTMVRUMWZocXd5c2ZNRVhlaDNM?=
 =?utf-8?B?em8ydlE0ZXkyUnNnTDI3NEhZa0JpMk1kNFRpOFdkckIvZlhnaytpNVpsYU5q?=
 =?utf-8?B?ZmVEOCt4dldWSEtKRUYzVHJLSGMzYWFpUGlPZ0xXSjdVMEpaOXpFeHhnUUpY?=
 =?utf-8?B?TWtlc0xkSnlaQVFRaG1ERXphbTdDMjkrTE9HSUROci93d05oNGlRa0Z4bzUx?=
 =?utf-8?B?bHNBM3RQN2ZGUGZ6QlRRNFltZmJSdCszc0p5SFMvL3FGY3krZ0RiR0NXMTZx?=
 =?utf-8?B?YjFQUGNWS242ZXAya3Njb1BhbjZka1VNaFMvaTVTU0Nza2lyRkV6S3RCblNl?=
 =?utf-8?Q?wG6jzJ0J55CBr+GV6BLClMENDjPHKz/YCGrobySb4k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <393C2975232E314E8E5BD00AB0D0FA92@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1864a224-0f8e-48a9-f6c4-08d9ffe8fc39
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:17:17.7538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xa+VlUCrkORseOwf2EtE42TeshDLgdpbFo1xnwx3sB5fEDLSFKZY5Stq5TPwKzO7NLUyPfNw7bLDrmeymkRCVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMy80LzIyIDA4OjAzLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gQ2FsbCBmcmVlX29w
YWxfZGV2IGZyb20gc2NzaV9kaXNrX3JlbGVhc2UgYXMgdGhlIG9wYWxfZGV2IGZpZWxkIGlzIGFj
Y2Vzcw0KPiBmcm9tIHRoZSBpb2N0bCBoYW5kbGVyLCB3aGljaCBpc24ndCBzeW5jaHJvbml6ZWQg
dnMgc2RfcmVsZWFzZSBhbmQgdGh1cw0KPiBjYW4gYmUgYWNjZXNzZXMgZHVyaW5nIG9yIGFmdGVy
IHNkX3JlbGVhc2Ugd2FzIGNhbGxlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1i
eTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
