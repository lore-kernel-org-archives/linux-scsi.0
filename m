Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1AAC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 08:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F3E61875
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 08:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244662AbhKRIjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 03:39:05 -0500
Received: from mail-mw2nam12on2047.outbound.protection.outlook.com ([40.107.244.47]:43162
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244684AbhKRIiM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 03:38:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJJ8rQOouQWUGjEkjvp6svva9/oWm8HZbufusfeswY3D0t2Oh4ToKTo4RnRzgaMxBzaHE1pl3mK5Q+WacOpO52S649xMR8ISOXFjrU8tmP7M4zPBUDLVzyZOO6SdjEVy6Mht8ah09q3G5aO4T792bFMaoKY7JKd/LEkArBI1yfpnGYmuiMDhIDXtzeuB27KxUDOHC5+o95beQoisSKmdwaNewSH78fYxajnuHmYn1M3iSBU5ETBvzi0xP+4ESsJdg8Gc8qECRzpzp2v2CUYRUOJvpzdT85cfEJAC9mjoCeOR+RGmWeX6Da1bktNdFOrlryuY6IYsz4hsN5xClodmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGjOEEDxo7mn9cbL3PoGxDzZGWJv6fUlUaMQ6qT+ZfA=;
 b=M/iOF5G5EfvCEhaCXRkladLSve8nYFxxdQWzV8f2OqkeRHhi4YaEjyK0LSp75r7yDcj3VUTpkp3PMjkqynlhhd4dYo4ovYF5curPZlPwcPrTMPtQqFqnF4cvynph/QucMi3RINiA1Vxt8g8X1/pmcyzC5eI6BdnPJgR+PL92Z7QRNuahaU5eH7/GnDECGGVtqYBPghCeBZ6joLgnNDysZX34GFTmkJ1rtZIalkb7tX4zAo5ZnXs/xIutV32nQAJYEZ81BuE3FmfhANGm70DwyUt3rsPPH3h2+buGKyEzV6Jzb2Y0trcvIZoJcj1zKuN2/TtUAI6kLSejFTLUJZHbuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGjOEEDxo7mn9cbL3PoGxDzZGWJv6fUlUaMQ6qT+ZfA=;
 b=T5JeBw75P+V26SvXYY736Jq8/lAod31A9KCcwyoRrwkQUQABqwGLRY7S+x5d7wPOJ9ldvFtuXKbkHKmBzv+2IOLWMQIrdOodyf/Sqe9suCG6yWoYYUqnsyjfD6yFKW+iqKGJ6mo4lFbK9BtAJDkXuxiyIU61Nz95LgnhTGCpNJ48Yg7mmDyvuXQpm/NUKaVDZjtNwVnHO8Fs0oDFxhvxRNp8/3uN5eXiWkf4hbqV4+6VFHzL5FCziOWzb1uejED/9caCYsT5pwKzMJ2/vmxkLQQ5dUfU1VZOdlIlmDARyzrllFMb+UgdSTbWqDIbGYy3hh+46O5Bae8EeqF195g6Aw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1264.namprd12.prod.outlook.com (2603:10b6:300:d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 08:35:11 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c961:59f1:3120:1798]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 08:35:11 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 10/11] block: move blk_print_req_error to blk-mq.c
Thread-Topic: [PATCH 10/11] block: move blk_print_req_error to blk-mq.c
Thread-Index: AQHX25NjzcTMaSO2NkW3PyiXtFBH1qwI9z+A
Date:   Thu, 18 Nov 2021 08:35:11 +0000
Message-ID: <eb4f13f5-5496-fe64-6ba8-a84be43defb4@nvidia.com>
References: <20211117061404.331732-1-hch@lst.de>
 <20211117061404.331732-11-hch@lst.de>
In-Reply-To: <20211117061404.331732-11-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb37b61f-3921-4831-4246-08d9aa6e55d0
x-ms-traffictypediagnostic: MWHPR12MB1264:
x-microsoft-antispam-prvs: <MWHPR12MB1264C40D7BE64D77C4497918A39B9@MWHPR12MB1264.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KiS8Y1M8e1f57TjGyPL9gOANGgQh8gO3T+VIDYANJhlwqm7DdQlaUowmgmzIxUeMMadD2T60N4x2sQRo65lPkEOxM+K6B7a2nuVjNxlcRU7apbSs32iQ7gDyosjQj0qArQXk95aV7R61YHBaL3rceHWjKk2mRY41ivuw8J0bTaZqruDSv+XQC4qx1KtINohji8Jn4+SKBWXAHOJSXxzM4hiLxAvfx1nuYvwoReEBl4Fm4Yb4ifU/kMcEt+Kmo8UCNIRWJDS+/aAQXq/RDLoHjgZfZaD6azoETPTcnMhjbZqHwFMfSrzWyzJUdQcc9j+fVfLfKDj9Dz+6P7zozez14HBCdw0K50i4OJse/8ig1ay2yVjtTL1/e6AQWNxX5Cvk+fAzrcYmHlmRr8euH+8K8TzHAu7SD5exvPFOkI11ZQnorJ8oGo6nuhKy5BMXzhspJU9G8dh8k71gwknifT7E/AYH5YJMXo5gCfbYSxPJItoHIhNhk53hTbmz7DWniBB0WHyWsssSi2hc0B2prORnw7j5i5an07y74ldzVj9pwntN+mKm90H+0bLnlx5pqfmaMC3WP6lsCBUkAXEYMzNyGKPgb2V1MThfMtFXnTQW5ViBhTKDne0i/z7+kMDgtKH9Kk2YVj4EhWscA1s4SF2bXD9rsxHoAjZwij3VkQDTIkIsuG1UqjkEAlGC6Q6zZFxZ0J3+P60+ObTabYh5e+KsP7gPDiKs75V723bha+tWOZll143ztEeMXolvFxqZa8DsbeWKWtN0balzcEWkQ1tW0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(558084003)(6486002)(38100700002)(122000001)(86362001)(76116006)(91956017)(83380400001)(6512007)(66946007)(2906002)(508600001)(8936002)(66446008)(8676002)(64756008)(66476007)(66556008)(53546011)(6506007)(31686004)(4326008)(5660300002)(31696002)(71200400001)(36756003)(186003)(2616005)(38070700005)(316002)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzBzSy9DU1g5RFR0aHVkcjhlK2dodTdGTk8zVU5xdU9NTThEVGRGdU5qQnY4?=
 =?utf-8?B?V2hqa3lIWTFQUHVURVo1Zm5peG1kTTQvK0tZbXlsRDJaZDZzT1ZvUFJ3TjBS?=
 =?utf-8?B?dFRqbXhJbytlcEdISEVOUkU2WTVveGEydXVWUERWQkpHd3g4K28xZitnTjht?=
 =?utf-8?B?aWdEaldUSWU3SWZURU81Ui9LeXJKU2FkVzVlTG9PbDdURGlOdm9NWm9zdGta?=
 =?utf-8?B?alVVQVVDMUtwRkZRUlBhN0VXcnh4Tk15di95d0NjcmNVWmVGT1IwYldyNWZP?=
 =?utf-8?B?QVZHckE4bml6ZDlXZlhRcm56dG1UVUlFZ1JndE5UMURNeWJjdVk0NFB1ZTRC?=
 =?utf-8?B?ekRIeSt5MExGOERPWitGdDVOeDV4RnlFZjJ5V0ZodVlOTUhBVUlWUTd6WTAw?=
 =?utf-8?B?RVQvem83VzdWcFFTYnBNNnBTZ2lmRnlTdFdmbGNuR09mQjNaSDRIbEpITkty?=
 =?utf-8?B?WmM0eW5tUGt2djdqZGJ5cXdQV3JuU3pmY2ttM3lxYVlWejJaTDQ1bkdGRFdX?=
 =?utf-8?B?MnBOSFBYL0RKTU1XZ0kxaU9wQ1R3MXB5a24xQkdUU0tDQjQxMm9KU1B1SFBR?=
 =?utf-8?B?bXpmbWpZRE9OSkNrVzRLUitENXkvVHBSTlk2K0ZEZ1E2eG93TTIyd0NCa3NU?=
 =?utf-8?B?L2Q1S1lsaHpVbis5UGhoVTB4M1hWbllDS2FpNFlzM0QxTlptU1pEZEFPR3Fw?=
 =?utf-8?B?QXUyZmRvcUZUVFVvTGk1b0Y3eUtRWlpqRXVCTFY0UjE5aXYzaCtsUzAxYkZL?=
 =?utf-8?B?azhJYlY3OUtRK3p6Y3RjNG92eXRwNUt0dDd1aGx0dndyZEx0ZnVLUFJBMnBV?=
 =?utf-8?B?YWdETFZEeUtJTldESHMxMnl1d3RmT1Z1aXM0cC9KaTZZaU9Edm5ISDJVNUNy?=
 =?utf-8?B?VXE5VGhDdGY5blNURGY4RC9yRGtoclhDL2JxQjdiMXdVdyt5SnUyenA3dm1C?=
 =?utf-8?B?OFUwbXpzR25iVmNPWnVoblpNaVN6dTB0STZWZGpZM3FOd0lRSGdQdWEvVU5E?=
 =?utf-8?B?V0h6RHlCYWJqcGdUdkNvZmhLeGtmSlB5Z21yV2xpMFlldzR0QS9lNk1hb2RU?=
 =?utf-8?B?NGE2RjBPYnU4TWM4clkrWXVpUjVQM3N1aTYzdkJ0dnlIdTRBT2t0RWdHZnFp?=
 =?utf-8?B?RDR6d2UzR0ExWHNBRGZvUlc1OWRlam9zVU9PZVBiZUpZdVFoeHkvNk5sVWZY?=
 =?utf-8?B?cEhMRzV1Sy9rbFBYUXFvRW1ZSWs3VVhId3NwSmNjWkFaSzdXd0ltVE12V1FV?=
 =?utf-8?B?K0VXMlpMSDZRcDFSVHJqRXZoMktlZGhaaUM3L0x3WVp5ZEFJVlUvU0x5Q09k?=
 =?utf-8?B?OVhYWFlXSERodDRFZWRtOFVXdnZSK2JwbHpmRC9Sc0tEN3QwT3JDZVVJN3hh?=
 =?utf-8?B?WVpFYXFjNWpGNU1mK0FRMFF6QzhvQmlhT3p4WU5pYU1iSjhDUUJsR1lybUsx?=
 =?utf-8?B?R0tHd1JKNk1taWx6L3JGWDYvdUg2NEVhdUpNSjkwbHVGOUNQUlJ2eDBvOHAw?=
 =?utf-8?B?M2liSC9pNWE4b1F1T3k2WXlBZUZaenhaOG40VVJSVkdqMlljY2wwaFI1U2Vt?=
 =?utf-8?B?TnJGeUc0bzRiUUN3OWoxelFBVERnOVlxRjRNeTdIS1RWZFR5cnJkdHQwTDZJ?=
 =?utf-8?B?MW5xWG01Q3Yra3p2dlI4OG50T0ZGSGtxdnlXUEp2blZsbnNkYkZwVjlvZGhp?=
 =?utf-8?B?a0p6a2V0YWgrZnNyck5hVnlDL1h3SWRRejhOdDJhREVLSVBlTlp4cXY0OVdH?=
 =?utf-8?B?dGM1aENFbnJrekZmM0w0WWNEcGNMc1RtRkx5NmxndkIvZGluVXJhSzVndUJO?=
 =?utf-8?B?RVAzSHRIWlhMOTQ5S253QzFISFFCVFBmYXJuYXFFKzgxbERxVE5paWZMOUcv?=
 =?utf-8?B?ODFNVHBMd2MrUHc0LzRWOC9NWkd0V0syT1FjVlJDZHhTdFRFdUZUT0p0UDAw?=
 =?utf-8?B?RHVUUXAzaThoR1UvWkxjL3duU0c0enpaZXJMTVE5eUxOUFJOeUFtODAzd2w5?=
 =?utf-8?B?QjdMV3Bxay96MEZoa0kwRzRjZ1FmRGo2MjF6TCtib0kvWmw5ZWtIUVdZM2tO?=
 =?utf-8?B?aG5PWlRZZVVneTRLRjJRWDNqbnFrVGlydjZTNUU4STUxWFB1Z3lvVTdPdFN6?=
 =?utf-8?B?a2JRODBJSmE5bTZmc25ZMjg0QUFhSzdVUTZQbW5PNDFVYWNoVk9aNFhsaWdH?=
 =?utf-8?B?MXgyOXI2dVVRNUJndVJlUm9FV0dmb3hFZFI5RGYyYk1VaWNzSTNrcUVhKzVl?=
 =?utf-8?Q?2rQw2rqoquhGkuf9A0G6HlzHq//rdBUff9o/0XMm0A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E36A15B156AF8D4180489305752F6B70@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37b61f-3921-4831-4246-08d9aa6e55d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 08:35:11.1432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DV+XFxuKOJh1dEtY6yk7w85x5mb5DU7PR3sn+TQEIv1R9uPN6ZMzscXJ9oMcrAKEFMJgHS9dRcB0SJ6nWw/l+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1264
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTEvMTYvMjAyMSAxMDoxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoaXMg
ZnVuY3Rpb24gaXMgb25seSB1c2VkIGJ5IHRoZSByZXF1ZXN0IGNvbXBsZXRpb24gcGF0aC4gIEZh
Y3RvciBvdXQNCj4gYSBibGtfc3RhdHVzX3RvX3N0ciB0byBrZWVwIGJsa19lcnJvcnMgcHJpdmF0
ZSBpbiBibGstY29yZS5jLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+DQo+IC0tLQ0KPg0KDQpmb3IgdGhlIHdob2xlIHNlcmllczotDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0K
