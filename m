Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A42C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350277AbiAaLug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:50:36 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:24315 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378184AbiAaLsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629688; x=1675165688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=rsP5czMSBUI6Gd/uABMQH5/vz/N2T7zy33oau4eQaB5PudcLv/GfDcQO
   lR78mheGClo5ZZRErNf2+KcrgDQIuCD/cbfNGl/4Ga3MY5Gucbd3f7iCa
   g+Pqs3/kjwP/Gqx/Yuh5SA0gGeELOFf4SUKfyPET4MZrETa0Os50rHdP6
   H4h3Sq73cziiLSyhj7NwwKYaGLrBucdALJkJTOZlbftai97bwH1GB7S6Y
   ghzFO/bsxPadP+uuUo61pJcJ5uoclyUYLjyJuoL+y3mAqe/b5wcKEFB1g
   gD72q9e4zGgdsyMh/Z+GaAx1O8eY14eH/Ftosdl7GfVH0KlnSPNaS+0MT
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="191798119"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:48:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nzv66xk/uxcQRVrDWYA8eKWt7/PGiQp7+Xo3N/oeShB/OWK7PeNrJa+GEot6Hk0fDt59SNLRuIyWs0SHdJj5G3CbCfiYNREdHpHxw0rJyemyqRQ4H+e6WZr8NLlPo5ubMVVIBrmNWOt5BvnuvTjPW8MPxKgcas3l8jHthiGirvdkyyn85S6YXpP3HFv2hR4h3vXvH5jSjbjQAy+CkZbPfezrle69wjMlUovIUL55RSkKU1qOIC0+cz3dQ5uZDVezXR0WCogDA7Z01UTe1VXiQYjN4Ej/o/CrNlYsMWZbnal0DHFJhrKi2q8quHenptIKVu7PGzOJ7llNlBv/RzF13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=VUs4N5WNuLQ0mw407l6fF8IjXgFxcjNQocahhuysBzayt0E15VseSBabxVjA2wM79DE1TohxYMOlycy3cBbPK6DbGuUc1fhXsSpU+MI3jPoD82Ku/sdhIhbLZB+sTVTCoD2nRPsAyeL7ruucFrsFtP2wyJ0mbkipxqKjRKWieIYhsicTGoYZ6DzCeNh7GxaxlwqHjJODoHY8yjRl77BZR7a858m92DOBVdTRCzmmrbkjN+1LjS+b+sUAPmnAtR2wQuoAQxUXAiezyUJh9fPdvu2cCVHBb34FHwmYK5AMKuvq1m1En8It9wMpvzWhaOv9Q25ePCpJ/I6JBXyXWVl2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=dw21ia8Z+3bdwcIJKdhbShEL/obvdnpkE/Rk8wnkmJKFX4n+gVMnH81fZuomrx8NxZ96Su3+zi3NMfxtdtCzeMg8KbG8W9jFYvY6WsVCj2SOyorexlxqiJgKTpPtQ0V9G6HyOyvIqb2f5Lt9I2KQ/XqAicp4uSErOh/nELDpyOg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR0401MB3651.namprd04.prod.outlook.com (2603:10b6:910:8f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 11:47:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:47:50 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>
Subject: Re: [PATCH 44/44] scsi: core: Remove struct scsi_pointer from struct
 scsi_cmnd
Thread-Topic: [PATCH 44/44] scsi: core: Remove struct scsi_pointer from struct
 scsi_cmnd
Thread-Index: AQHYFJWFFQ4+I1xdI0ytED1n7mB6Tax9B5KA
Date:   Mon, 31 Jan 2022 11:47:50 +0000
Message-ID: <8d68f364cf1d064513a74f52cd992f514f76a453.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-45-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-45-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ff285d1-04fa-413b-b635-08d9e4af8221
x-ms-traffictypediagnostic: CY4PR0401MB3651:EE_
x-microsoft-antispam-prvs: <CY4PR0401MB36513C1802EF15CB7E47A5509B259@CY4PR0401MB3651.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h8aMQvd3fNc52OgokbvmHwDQ8QYgfj2Dup9sY//gVA8dYYGFffR27mLNfA++D5ex74s+4OAOb2l2n6J59ZfwoG5joLvoAXumy6BjHVOiivp+Lem440KunPf2/YGWoXsP4PGSBfiyBmUkvYVR3j+pYDffUpB38VWTGf+3FVkqvo2hFOL6JTobgx6mF7XRcYmwjWHY87tvQx+Mrdt3AdWkjKquLL02K3+0RaG4QtPhaXdgKZUpIR2I1AhswDL2699rCfM6iK+yQAMzw7HdrDWk0/zgzkYDQUS9dEabaHLV1c7KS0yI3SNHNBCn06dkZoYEFfx6hy4rQaVvbqU7C95yO3FNrvCbIrlKpS06voHQa46F1PxOiGQji7RRINcqDAT7AMAGKFe5PN3bpB5JQUVGPITVEZR5M75ZQ2StAl8mOwZSbI4YMflsdOwbobt2xv0naEMVKMexErfh71wd1yttKWze9mnuoIuFDt8YH4KR3kIqHljCYGm4Eux9vLA5l+7f3soXB4IxFhMMhBnJmVccMLi3+BNGy5fossBLaGk5qWd+8IVgPqxwQZtKuqSO7DgC2atRqkuwKQz2FNQQtU/JXxBAWee54vMngmU9mxgfzOKhVqmWekdLQvpqR+8TQU7zeG5IsOtjh28wP7C3G+mJxNSRomTS00EyyTuat3kRYhzHklKbC+9KUDNmfJNZ5NzkV7u3YlIkMmw8aAK81Bfnfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(19618925003)(6512007)(186003)(71200400001)(2616005)(6506007)(4270600006)(36756003)(508600001)(6486002)(5660300002)(26005)(558084003)(82960400001)(86362001)(38070700005)(38100700002)(122000001)(316002)(8936002)(76116006)(91956017)(64756008)(8676002)(4326008)(110136005)(66446008)(54906003)(66476007)(66556008)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE9oallablBTTXdKR0lQRVMxdjg1WEZaSndCUDNMd2Z6VEg4Tm1wT0JTYnN6?=
 =?utf-8?B?VFQ1ZzM2NXZ2blFkRWxNaTFqSndkNmhyMlFNZGFFQlJOeFdBL2xRaTZncm5U?=
 =?utf-8?B?aDBzZTFCa0x5YXpuL0RZOVpET2djOUk5YTM3YWo3L2pINFJhOTlzK1NkbXhI?=
 =?utf-8?B?L0lsbU90NmhqUmhNUTh0VXhmSCt1ZTRYRksvUnpOTVZOeFdTeEx5OTQ5ZG1i?=
 =?utf-8?B?dDAySEpSdCtLZWhrME1QVWx5bnVZQmJLUUZ2Rm94WHNVa2hzOUZMUmRZc0pN?=
 =?utf-8?B?MDRmVTdnM1c3QnJvMmg5dTZQQVh6V0xZeXlXdWZFS1B3bzlkcGRFbmdFL29E?=
 =?utf-8?B?TUFrV0xlbU5ZTTFQTmFLUkpsd3l0S1NMWTRyaW1QY2ViOWtTWSszTjU0U0Zl?=
 =?utf-8?B?RVVzTVNheWhHd080cVBKTXNTOTRJZUlXc0xmSmVURXBiQmFIVHo5KzdVR0NU?=
 =?utf-8?B?OTllTldDSHd3enp3eEFKOGJ2NGtXL2JHb1QvdURKbmc5aWxQeUF4WW9OOWUr?=
 =?utf-8?B?YVBZMC85bVpCcWY5d3pnTjFWMXErRzByWC9hS2IrTHRQajdkZmtaNko1MW0v?=
 =?utf-8?B?cFA3djVaVTV1U2tmNFFHZ3FyZEZsM0UySldQZ01xTXhTSkQwclNneVZCR2Vh?=
 =?utf-8?B?Z3Ird3g0aG02cnU5VkdVcmQ0VWJSUTV4L25vSURYZStpNmZhZW01OVVmWEsv?=
 =?utf-8?B?d3ZSaVNjQ2h4ZGczVUVKT1FRL3JvSks4QkJGRjJKYy9zRlNHR1lBZGVkL1JT?=
 =?utf-8?B?cVFTZVlRZlREekdCZE5lTmhON3NUTEdWWlptUDMrUGhjM1RMYXVtQmt5ZUlS?=
 =?utf-8?B?YXdZV0VtN0pmYzJBb0RsYVp3eWl1VWhkbHROc1gzckZIazJVZjR6ck01OEdD?=
 =?utf-8?B?R1RuZ0RUQnk3cFNST3dCYktaQWZnTi9uWGxxNDY2M0hvR05jaEUrY1Zqbkgx?=
 =?utf-8?B?bWtFV3NRTFY0NHFES0JGeGpwSHAzdktrUDMxQWpwcEpzWHVjaDBJc0tyWGFD?=
 =?utf-8?B?SktEb01LVWp2UWp4R1BqV3YxYTVMb245RHhuS0ZjTGFYN0hTcVllVmdlWERV?=
 =?utf-8?B?RG0wUjRsK1lVbHpIbWdUM1BBZDluUWZKVGgwczJZRWhNRklTS2lKYWlyS3dU?=
 =?utf-8?B?NmJRd2I2QUlndElLY2ZqR1FFS0U0ZkJxYlIxdkVBeEFCdVkvQTJQSDRWbkxW?=
 =?utf-8?B?Z3pkTHcyM3dlaVdYY1BGcmNSNERZQXRTOFYvcjRKQXorVmxmN2s5QnJqK3hX?=
 =?utf-8?B?amROMzF3N2tLcVFDYm9RRHZoN01jSXZaMFdLNmRtMUFmV1YzQlFIOExGaXd5?=
 =?utf-8?B?ZXIyOFRIZXVZQ1F6cm5zQ3ZOKys2K2dyOHhNOGJZVUJnbTJRMmRBazNYcCsx?=
 =?utf-8?B?cHVKU29HMTZuVWxycWRFZWJMNHBod1duMTZmRFZ1V1VVcFlFVm03R2hUeUxz?=
 =?utf-8?B?WHhLYXBqZmJMU1E4am52R0psK0VuZXRuYjU4emROcithdUdFcXhBMlRtK0NF?=
 =?utf-8?B?amJHNCtBc2lPTUJVMmcvdFpBZHYzbkVMSW0rZzNXeHI3TmIvSU5DTG5oMExm?=
 =?utf-8?B?ditRTml1MWpXdzFkWEFWNUJSblhsaDdQRk1JRmczem01LzFLTW1MN09yWXRC?=
 =?utf-8?B?c1J3cDJhTUVsZU4yK3dramdkOVRZQXllSGJVK2d4MkZpV1VOd0RKNGtwTnRW?=
 =?utf-8?B?OGRrQlpKVW1DMjVSeDdUQjNEbFQzZGJkakRVRkNzNlozOXFWOU1nd0F2VU9W?=
 =?utf-8?B?NkJyc3VrTWRMQjVlRGVWRDJ2dUZnbnppSHdlN3VrVEZXUUVERGd0UmN5YnQ0?=
 =?utf-8?B?SlhqN2gyNWRmTHlhdUxmZXhDU1VOOWw0TmIwOHdRUVo0SlJMUjdpcHhCUXUr?=
 =?utf-8?B?Nmh2S2Vrdys4Z2tRZlRQb1h0RG40dzY5UVQvWVRXSW4rOW9EY1I4dThYNGRO?=
 =?utf-8?B?ei85dDRTV1BOZmpLeGZlK29RM3U4NlhjZTFRMzVFaU1KMVM3QWJjZjU0QS9u?=
 =?utf-8?B?YVZwSUVsWFZSRGN5M2FMNGdJNTJaOUNKTVhpWk5DcnhMSSs0ME1XMFovNjNn?=
 =?utf-8?B?SHcyN1JVS3JReXdRN25CSi85MHFkYnFZcXYrK012eUQyZVhkb01xRUtCYlhu?=
 =?utf-8?B?UGVObFNQK1hML0NWZitYdGw3anptaFZUVkJ4OWp5UEk4VFJzcENmQmE2ZlZ2?=
 =?utf-8?B?RWpNeDNkc1VmdmZUaXA2MXlpWHBUYjBSK01iTmxJTzJMRTZmcUtlL2xIMUVI?=
 =?utf-8?Q?H3gRFBxX4PUHe5nkzJEhQXfhTqPIDVuO9GxZEabR4g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EB328E61613A84D9417771F77BA8888@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff285d1-04fa-413b-b635-08d9e4af8221
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:47:50.2199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ra9QIcLyx4w+TY7ZdeF7yI27ukGEmu2B0nFTzQzwpf1eAbXWelHMLlrWic9u2OJ7SmMxksb9KIHBvWkb+TbmbAVj0gaKbrheLH4mUaSWHR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3651
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
