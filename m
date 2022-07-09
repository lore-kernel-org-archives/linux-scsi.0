Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9067C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiGIAC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGIAC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:02:56 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B29DEC6;
        Fri,  8 Jul 2022 17:02:55 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1970CC0D66;
        Sat,  9 Jul 2022 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657324975; bh=Jvg/PqeYumCE5boowzQPKhoyuiH5y4OAJ51Iie1aBio=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HG1SA4z3M2kSTfcmvojbCIcdmDZeIjYW+AZrVD0k0G0Di4o5+/XRiLi0qizgQpZux
         jy6yFRD4WxJK8qvVja57WxWS+S8v2JmZVMaFjOI00TxZpc252GHJNJfeeOsHEdVq3p
         N+PRhOC7tET835djR66JA8hgnjxvRYQJSFQQZbLjRW0ZeLD42g8/PMmgWb/MRnmUXN
         8PGw7A0AbAFRTfM370xBxQTLnxmmx3TTsQTA+btB8HVevNW+Kiv4+HhKyP2G4ECNud
         ulRFCaf+BoDES5pwEH4mVF5AJiEjzqQcy8b0CP1tZH96pZY1VUz/fO8KYtJ05gdxHP
         M1RziMdNbQBrA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2E449A00E9;
        Sat,  9 Jul 2022 00:02:53 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 62FED40053;
        Sat,  9 Jul 2022 00:02:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="TncfiWA9";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLyaIQrTQZvPiDfMhTEk2tChipisEdjRDgBRglttZ7BgGK58va78SIGOuOBhWxuR8cVT/jN+cqoHjTbWFa1uMH2KrQJYyYAniGzd57iJY6xG5tSz0u6JOXLXtPQ16QmzoTsU+38Y5vjYGUTucdKEXVAhvb1PzisZf1vkl/H+XUJ+mF75Rt/q7J6P3+XUNzKxaLIUyqt/kNjsZZCmrhdZL8iEw0Stze6FHpxNp+IiccU42evlkPCyqu6r8M3ErsByFEjGSlU+tSXHMmyBkDyGb4AbhgILRhdoMgCCH/SgEC8RzFMcjhXFroSqtSVpYdgp9ztz6sIX1FazIk2K1xMUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jvg/PqeYumCE5boowzQPKhoyuiH5y4OAJ51Iie1aBio=;
 b=aFc70N+loaZB1xHm5UhllMfz7569Hlb4znVhOHeOzbMzBWofF+ZObXhSD2h79AN+jQg1Oft0yerBH+CT2V/Noz6VAjaRPR6pHs3E52Jx8XX7KW9N+1YynM/7X8p9/pcYJErR8OXLHUjJOPbmbsO9plXvlzHfKW8qe/rXHvAeFvD4oYtsfeHEwjNbE1GyX7KaMCXPcUDQfLbE2AxJcDgs8iX66BIJyFJixT27O/n7nxZztnaO6SOQN+RLKmwiaFe63ay/2tpDFcshii8Ct2aIDjGNdZvyxChTEaVLbS0F5X1mPLaB+8theRlrVZ/zEhE//M0slrZfb5Y3fNnQsZglPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvg/PqeYumCE5boowzQPKhoyuiH5y4OAJ51Iie1aBio=;
 b=TncfiWA9scuRcfICoA7Sg53FWV8cdqzFQKTLhbEh2JOxiaE3ai3SoK6o1x2J/Z0pUEs9M/5S8D9ODI3f5zjGwueYBvPU9wQR45BkuHxtrzw/kZ0kDcm45+kdVFNw3RUiuCSFMFzqZfbXl3cOteqW3fjyTD/TlOv1qSTA2Fefg9k=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 00:02:49 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Sat, 9 Jul 2022
 00:02:48 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 08/36] target: Refactor core_tmr_abort_task
Thread-Topic: [PATCH 08/36] target: Refactor core_tmr_abort_task
Thread-Index: AQHYkZENuLA3iBekFk6EI5TlCY1iya1y6xUAgAJAOwA=
Date:   Sat, 9 Jul 2022 00:02:48 +0000
Message-ID: <c2d0b5ee-c05b-75c6-8833-50aa9235126e@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <5b89eee29b74fbafaa9df34ca3f6170d1cfc5728.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707134024.GF23838@yadro.com>
In-Reply-To: <20220707134024.GF23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d82453e6-42e8-4ab5-e473-08da613e5c27
x-ms-traffictypediagnostic: BL1PR12MB5301:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJKdDWhB5SuSJhbSOcYWXPPdhx5TFgPt6rLz/ktTDZz8z3kBqJVAYhkdiWV1TpD+GJNJtAHixtcpkXWVydNks2ZmzmkzD7h3oc44sXndsleuBo7aPPzCL1abFty4rDJUXqKyvZp2eL5hHk3dPdn+HlVadruEG9s99JrF3Dg7CwjhcM3MojmaEIecOrrQfhiqBNFfv8sIziy+QlPWhNvC8Nt9ToL5IG/FFDGcrxc7IBgVPCnpYFjqweS15FVaFup/1bXWn1B431ZSt9m+gyJCPkbkl7joypXhcp6Qaald9Gt7kgR0oUkBWM8iUcg0RxqRXBjjXOeyxjxIPsdpIvo4lo/0rGSwbjByBkCS7lSVIxNGl/UJrje/oyD5RddNlwvG7F02r9WuIrMiLNoxuHMbWvDrGR20hH+byTsyN2QPfz2pe/Hznqg/Nk//R6DttduP1furWXaLaulLoKOBB8RzBzzpYNMy9lWQ67sI2QhOvUUH6I7h7BscYa0A4TYyVouOY+SXGDEEvVfG+Nwr00hQ1V9IhEcJr5kqLh34gP+fx1yfraEkjlj0lu/5UNLaL2CDph3kHP+JwhW0IuiIijW3w6tYiEFOXn7409fnLHz84Oxkhxqzqk5DQD5yUvdFw5iMVjIjPwgUWtJH5kxW/biSy3r4vZ5nfWNUZjI5CQ4yh4oso2zOIL+Xr/cOV8oymmu01c1jfJsOu3AXt2SPVvk8bZUwzTbqKYg+zKE8b33OgCBr5sFc9U9WiLWIjrzAHEeZUJHh1/e++fa/lwyDaTSAJkBvm23VLSiDE8wcI5tciqWpTF+AXxTxo5Vj6ucCcihCHWDM/4MCXuuiQqLVImHma0M2gr+J9zMwrTE6nyDtFSvzG0tryb5LEONguKr9DAVC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(39860400002)(366004)(396003)(26005)(6512007)(6506007)(2616005)(86362001)(5660300002)(83380400001)(8936002)(41300700001)(2906002)(478600001)(38070700005)(6486002)(122000001)(186003)(31696002)(38100700002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(4326008)(76116006)(36756003)(54906003)(110136005)(31686004)(71200400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTJmNGNwZEhSM095L1AveU9hazlWWm44V2M1dktqWWI4OU1sYVMrU3ViU3JH?=
 =?utf-8?B?Z3V2NDNzNWFpMVIwamJTK3JsMGJXTDJrMCtPRnQ1VE9rTVJ2RWMzNVFKR3BX?=
 =?utf-8?B?V3psbFU0U1NIYlFLL0psZ0x6NWIxaFdXSHlzVERFMk8zYk5rQlRGMEw1YWVa?=
 =?utf-8?B?UkNDd0s4WG00Um1xRVJEclYyc0JVWkdnR1hyamhYblJONVYzcldGdXBGdUZW?=
 =?utf-8?B?d1hFYUptUTIxMmROZFBFRkwyR1RjZG9LWDF3V3NNSmVTT3lhMTZBd3E4YnBD?=
 =?utf-8?B?c3pScTlpVnVibzhpL20zUjhmMnAvQmVtM25PTGVmKzVyMURyZzVkcGRmaVJL?=
 =?utf-8?B?RGVTdHVIOWVZWlNCVzlnT0d6by8wK2RjUlV5QjRiRlJidkVNakE5OWJ3ME5x?=
 =?utf-8?B?aXZXamlIMWJQM1BLUHZ5NTdjMWNlTG1Ta3FNdVlOL3pBalF1K0VuZ3Vpenlj?=
 =?utf-8?B?bENHa1Z2ZDdBUG9jM2R3cG5pVXZRNTc1UXZZak56NGpBNUkyVUNrMGdUWHNZ?=
 =?utf-8?B?T1NJYm5QTkZma2FlcDBxeTc4RVRabG1JR3ZaR09pc1VMVUtZREZpdWlmWW1Y?=
 =?utf-8?B?SUphdjF5VnpQV2phdDZmYmFvWld3UUg4M29RMXBpMUkwRGZCNXB5S1UxQTE5?=
 =?utf-8?B?UjJWKzk0K1BpQzlpQkM3THp6K21ZaHBrcmJ0MEJENDZLdEFGUGlwczJ3RjFw?=
 =?utf-8?B?akJkSzA3UVpnZjErcTUvWEhmelQ0dHJ6WTQxZ1N2eHJtZUpmWDhkVVlwM1hv?=
 =?utf-8?B?ZndIVEczb1pOdEpiRWNYdEJ4UFVadTUrMzNTbnNvN0Q2clpLdFpRS3ZodS9X?=
 =?utf-8?B?NnBxbGN2dTZJc0p4UDFxSlZyMHRrL0lBQVVlSWs5SlNWeGplUDJoMkQ2bWFk?=
 =?utf-8?B?Ykg3cjlhMzdvcXJGN2Ewd0ZlSURQcDliekt2MzRtZFJaYk53d1BMVEZ6WUFt?=
 =?utf-8?B?QlgwNmRIdGdGcXIxZWdoTmRXdnZsdXk3cVFiM0FIZlFudHoxVjVtYzJCYUw5?=
 =?utf-8?B?TTBhOWFVTGFiUUhoSHRSUS94UmRMZFFac0dTdktHdTVmeVBna3ExOUpsdGRv?=
 =?utf-8?B?eHNseUdzY0pXU081VTFvZTdJMlZYZTZCTFhVOWxIelNFV3RseExBRmxwb2hs?=
 =?utf-8?B?akdIK3oyVlpYcWhWV0hoeC9TazcyOTJONFQyam4wMy9EOTR2LzdGcGhkUU9n?=
 =?utf-8?B?K2xUK3RCeWlUZWYvekw0eUQvN0xMSVBUd3lTREZGUWI2NnF5cEhDMllIWE9w?=
 =?utf-8?B?STdzczRjQnJPRDhUMkYreUdYV0Y0ejhkakQvdnMvQjM4Z0lDSFVkeDJHTTNC?=
 =?utf-8?B?b2xLS2RLcm5CUTNTTVArb1lWb0wrMzhNTmZJM0hnZWdOOW9uaDNEV3FyeDRI?=
 =?utf-8?B?T2R3QTVrMEVaamJmamxnNCtkdGpCQVJ4TmNCbkJON2NlZ2F0aDRWejlNUC85?=
 =?utf-8?B?NzZyc09oOGc3Sjhvb1E3NjYvbDN3U3N5ay9uclVOK1JFWmhNZHozUHBNbkR5?=
 =?utf-8?B?dy8yMDRtUzFVdFdhdzl6U1FFNjlaVEZVc3d5UU5qMEdvUm9NRlpLSHNMakYr?=
 =?utf-8?B?QTNIQXdjSEMxTzczdTB3RDJYdTFadU5SRWFqbkJJTllIa1pCVHBZdXZqMldl?=
 =?utf-8?B?T2tUeWNsM1F5QkhNR0N1UFlUSUkwK2lyanJJYUcvYU1WY2NoRzlhNjRRNHpW?=
 =?utf-8?B?YXJoZC9HclRuTDh2eDBQcVdqTUVZeUp2Q1pBMklzRGd2SlZiWEpoWGhnVE5D?=
 =?utf-8?B?UUxIN1dEMldaTnJNRjJDM25kZFdOdmNzTXl4VUVDYWFmdDdXYTBrN2p2SE4z?=
 =?utf-8?B?cjFTdVhQd2RFT3Z0ZUVlQVZtYVVUOWVhRGthNHJFVEI1S3pKc1ZPM29oU2JM?=
 =?utf-8?B?OE5sdVJLRWl6S3JSTzJkSjJtaHVoaEszejUzY1hFL090WVVhMVoyNDI4Y1I0?=
 =?utf-8?B?djVuaVY4V216STBKY3FuSzJ6ZFZYKzFIOUZGUDZvWStydnJNMjFIRTBVcnc0?=
 =?utf-8?B?cUpUQlBLYnllaUI0K3NjYjRFWjRnVU14MDQ4S1N5SVpTWFZLR0tPM2hEQXda?=
 =?utf-8?B?NHRGSTdaa0gzR2p1RXJmWEVzenllclBabG0wOHlEdDlmd2NERFdyeURoczll?=
 =?utf-8?Q?6murRgD+Xqn/uLtg+gmJUxN42?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BEDEF8B9F82EA49A8D5FF42675EC7DD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82453e6-42e8-4ab5-e473-08da613e5c27
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 00:02:48.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35TnhUyyejkVPzrug1xKY1xWHASAPZNCMRrz//J7h+XuvrUPNvNu7QIyMcyZ5dYElYFiAVfpMXUAQil2lmdjpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gT24gV2VkLCBKdWwgMDYsIDIw
MjIgYXQgMDQ6MzU6MTRQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gTWlub3IgcmVm
YWN0b3Jpbmcgb2YgY29yZV90bXJfYWJvcnRfdGFzayB0byBhdm9pZCBkdXBsaWNhdGUgY29kZS4g
Tm8NCj4+IGZ1bmN0aW9uYWwgY2hhbmdlIGhlcmUuDQo+IFJlZ2FyZGxlc3MgdGhhdCBwcmV2aW91
cyBwYXRjaCBvbiB0aGF0IHBsYWNlIGlzIGluY29ycmVjdCwNCj4gdGhpcyBwYXRjaCBhbHNvIGJy
ZWFrcyB0aGUgc3RhdGlzdGljIGNvdW50ZXJzLg0KPiBkZXYtPmFib3J0c19ub190YXNrIGNvdW50
ZXIgaXMgaW5jcmVtZW50ZWQgb24gdGhlIGVuZCBvZiB0aGUgZnVuY3Rpb24sDQo+IGFuZCBzaG91
bGQgbm90IGJlIGluY3JlbWVudGVkIGZvciB0aGUgY2FzZSB3aGVuIGNvbW1hbmQgdG8gYmUgYWJv
cnRlZCBpcw0KPiBmb3VuZC4NCg0KQWguLi4gSSBtaXNzZWQgdGhhdC4gVGhhbmtzIGZvciB0aGUg
Y2F0Y2guDQoNClRoaW5oDQoNCj4+IFNpZ25lZC1vZmYtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmgu
Tmd1eWVuQHN5bm9wc3lzLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRf
Y29yZV90bXIuYyB8IDYgKystLS0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3Rh
cmdldF9jb3JlX3Rtci5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdG1yLmMNCj4+IGlu
ZGV4IDcxOGQ5ODVlNDg2MC4uM2U3M2Y2MDMxOWQ1IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfdG1yLmMNCj4+ICsrKyBiL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9j
b3JlX3Rtci5jDQo+PiBAQCAtMTU4LDE1ICsxNTgsMTMgQEAgdm9pZCBjb3JlX3Rtcl9hYm9ydF90
YXNrKA0KPj4gICAJCQlsaXN0X2RlbF9pbml0KCZzZV9jbWQtPnN0YXRlX2xpc3QpOw0KPj4gICAJ
CQl0YXJnZXRfcHV0X2NtZF9hbmRfd2FpdChzZV9jbWQpOw0KPj4gICANCj4+IC0JCQlwcl9lcnIo
IkFCT1JUX1RBU0s6IFNlbmRpbmcgVE1SX0ZVTkNUSU9OX0NPTVBMRVRFIGZvciByZWZfdGFnOiAl
bGx1XG4iLA0KPj4gLQkJCSAgICAgICByZWZfdGFnKTsNCj4+IC0JCQl0bXItPnJlc3BvbnNlID0g
VE1SX0ZVTkNUSU9OX0NPTVBMRVRFOw0KPj4gICAJCQlhdG9taWNfbG9uZ19pbmMoJmRldi0+YWJv
cnRzX2NvbXBsZXRlKTsNCj4+IC0JCQlyZXR1cm47DQo+PiArCQkJZ290byBleGl0Ow0KPj4gICAJ
CX0NCj4+ICAgCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXYtPnF1ZXVlc1tpXS5sb2NrLCBm
bGFncyk7DQo+PiAgIAl9DQo+PiAgIA0KPj4gK2V4aXQ6DQo+PiAgIAlwcmludGsoIkFCT1JUX1RB
U0s6IFNlbmRpbmcgVE1SX0ZVTkNUSU9OX0NPTVBMRVRFIGZvciByZWZfdGFnOiAlbGxkXG4iLA0K
Pj4gICAJCQl0bXItPnJlZl90YXNrX3RhZyk7DQo+PiAgIAl0bXItPnJlc3BvbnNlID0gVE1SX0ZV
TkNUSU9OX0NPTVBMRVRFOw0KDQo=
