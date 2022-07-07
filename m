Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4039AC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 10:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiGGKbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 06:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbiGGKbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 06:31:19 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FE7564FB;
        Thu,  7 Jul 2022 03:31:19 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CE614C0767;
        Thu,  7 Jul 2022 10:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657189878; bh=Yd2aEdEE9cu/u333X0ce+CfdmJDGskggKlon7UGuc+0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YP9qtYF0bHppJpd9gB2ta8b7rWU+pKULrwZU4/hc1T9wNsQwrV1bOpv3GAef+Pozn
         kTz69a507fuFJwAR+x8k6EMAGMU9XIat/fk+uS5QyDrDI1CN2sct//g4ULD44U6jFO
         xfSUOEJsLPh+1c7xBZ/o6LjRxJLxlHbUgymSWYOyUDuabCOmtAvqI2zPNxtRgUiLSb
         u/2dBSf9GcjmstRuZRsWIfcsgg1rG6EEIzf6nqY0P4OwjAZNfwVSkWc96+86a/fc5x
         Kxi1ddUugEKdUsxb+CMfPj1kOg6FnromhTZ/3KkA7odWQ1e3kPrK/BI3W6TWl9CHQ6
         mQ93HccFIPwZg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3E5B3A009C;
        Thu,  7 Jul 2022 10:31:18 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id B64EA800B4;
        Thu,  7 Jul 2022 10:31:17 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="GkklYAI0";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+qa0OxEFrfTIqf7BU24oyy1xNW3t6050MdTgRB6aQAc7O5UztPob0fZ8Aa76WiJNkCwwIbTkgOOvvRss9mSj2ReDwNlyX7aTGBgXoHcGPuVvbqqGYjHZkIxeUjBMg7oSB4W36Sy47UuMwwepioyvH7ngMC+Gw5C7cvsXZt/4A3msfQPJ2pmUQkY7uoj+WJw/XODcnpfAGVPMbJuoxcrWwdUP0JM3Kb6iJxasZfczvqBl+S6fRnjbCHRoZe4lLD73rXFmw4kgq83BXYa7QaNkONH44jk9mSFGqICazqvkYpkU7zWaS89RqkaqiUbVZz/opn7A1HTM3bD2IP2X1tzkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yd2aEdEE9cu/u333X0ce+CfdmJDGskggKlon7UGuc+0=;
 b=TJIIUNZihxMAx7EjqOc0a6MWIsmDgb5QD2r9VH/W1fGCFI696pLExGS5ghxq+gTlpOwaX8MmMZjiIn+5S60tG1Qm8IHSV4YoCPd4smgGk118F84FLrfWwXUdRjqXxKuT9ckMTSPkhYqOMgKR8ac/yZ4X65gCwudRtrej6jQnE+oBX+hQgSQqOY2voyVPdGI8tiJuin3UbWau1wSVBnhBZNPeBpTf803IbQtSC92YPiC0Oh0uvMlF9MLslIkfVd6Mehkunm0pdb9touF5LJka7Z8EN6RBAjSsU4wDnWDtVNlw4zzCl0uZ4WQ8HZMB1h7nJnswkQpV3fI1+Ab+MQp87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yd2aEdEE9cu/u333X0ce+CfdmJDGskggKlon7UGuc+0=;
 b=GkklYAI0GLURR/RqEHlWAwxHMrlCmJhAq256MhBhsMd4JaMlBcjBHlWS3OtRbXH3kQtf69klK+sRXf4xq0KwYjDBYMELrA1n44JyX6z+zTTUgWK4IuvL1TVw91C7IprU4G51TRCJPsizWLL+CwGm6HR6DrzGsprTd+w/xTfiECk=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN6PR12MB1730.namprd12.prod.outlook.com (2603:10b6:404:ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 10:31:14 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 10:31:13 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 20/36] usb: gadget: f_tcm: Limit number of sessions
Thread-Topic: [PATCH 20/36] usb: gadget: f_tcm: Limit number of sessions
Thread-Index: AQHYkZE54KU2RuPxqEe5mAlGbAtht61yepIAgAA7qIA=
Date:   Thu, 7 Jul 2022 10:31:13 +0000
Message-ID: <1836e1b5-0aca-460a-ea96-e86593f9960f@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d344403eb32d950eafacf616ccc19ce742a6b3b6.1657149962.git.Thinh.Nguyen@synopsys.com>
 <YsaD5lqtetyVBUD5@kroah.com>
In-Reply-To: <YsaD5lqtetyVBUD5@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3ba8cb8-5ffd-4bde-c7a8-08da6003d151
x-ms-traffictypediagnostic: BN6PR12MB1730:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yYgfM4mcxRIZNLELPimi3LWGIuvaCdodQUwmkvq9RMGg56z3eT8BJunSPBNSM4Fpa3ZZWU08e1Qek07PEHh/XDBmFDGGeRPsusL2uFkXPXvMy7aDY6pQJFMrNB2k8R5XZwrsBRomMebTxKfSsLw6R3wORM2E0Mh8AQnIFZQ3J5w24rrweaQXHvXJ0VO5hPOoUClxo2sTxhF33n7Y7DQvrvg6BMkKl7UJIFqONQNlF6P5nNfsDkukbwXm/+rS3UcIJMtvLglVeKAkoaA45Ga16WzE6/Lzni0dNrYIILDz0R3nhxaCvlTSj6QMdh0bN9n5QwBZYAW2F8LNgV/vAe057db4Q6qeAfrh+pR8iY5PnzqzX+VJV6fn6LaTP5l568antvPckT0p+pu4qQHB2AYpfe9AXaZWxIQZon+xHt30QElselqIxYLdmJTU/xN1xem/R2j/Hw6+oMV9C4iIZF142J7IdoWv0qGEnec+eA+wgRe7KBMaZ9QOJcL/48Jh8m4RLbIWvR+WJVCja4n577iYtiC9yhZViSwxqv6U8vRju4QFMfH7bk+QvqduiZSMFH1o4/E0uG/Q4c+cXO8zTk0yK459uqIYrdc4pdn/peHMI9Q30NlezVc2QhHnYKQvXmFLYo3nxK16OiCrrdCc8AReI7R4K2vw9TPVctAWGVHCkO889suP0O2sGfSkNYlBC2EKqU/LhhvXGXLv8FROfQgfzVI3hO6oUQEFDHIysUtPO5clJrp2uZU8iBs94FxV4SycztiENilgIeBXki41GPeftNfIrkuapmxkWVtGkdZBGRCoYgwVUZ/KZV1VGM7q5R7MJZ5bn/qJyDfH0KCqebHuaiey5XYgeACiXwS92S3DHbECHDfYy/qtoschWTuawY/I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(39860400002)(376002)(366004)(86362001)(26005)(6506007)(6512007)(41300700001)(2906002)(31696002)(2616005)(6486002)(478600001)(8936002)(5660300002)(4744005)(38070700005)(122000001)(83380400001)(186003)(38100700002)(64756008)(91956017)(71200400001)(31686004)(66446008)(36756003)(4326008)(316002)(76116006)(66946007)(110136005)(54906003)(8676002)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TW9hUit3dHBjaE9wck1tK3Z2TE53dG41YXBMUVU5WXYzY0lpam94TlVRbVFq?=
 =?utf-8?B?K0k4OEFUNWpIbUhQRzNQSlVKNXIvVVNJNDczRnFlZVhDTVVsek93MnFlUkJw?=
 =?utf-8?B?YzV3UmJ2emdJbjM3K1NWdGxmYWljUklkSE5Ja3h2WDlDcjY4MDl6N0JTbjNn?=
 =?utf-8?B?WEVtbENaWVpteDcvSDBMSFVXSVNXcE4yMndNYTVobUtQR0J5UGNzSDBTaVJQ?=
 =?utf-8?B?cU9GWTlEYjVjcGxiNVZXMDVXQk5IM2pFbVNxRlVmTjdvU3crdW9CdzM3RG9w?=
 =?utf-8?B?eHlFdzgrM21XTng5UUpLL0ZQN3FyT1JuN3U0MmcyTVplNm0rUXc0bXlBMlIx?=
 =?utf-8?B?WkxiV0RLTDhxTjkwMkd2TStGOUtsVGNPVHFGa1k3a2RTb0s4REQvaWRCYTVZ?=
 =?utf-8?B?VmpKZFo4TllyMEZnb2ZvWDZ4cTUwOTRTbkZQWnpwQmdSY1ZQMEQveGVycUMr?=
 =?utf-8?B?SzBhZ09jVC9TUURqRHNxRlE3b2JtNHB0ZUJybjdwSHB5QldOanRsUmwyOGVz?=
 =?utf-8?B?MzBid004UHI4TkZPeWQ2aGhDaUJVeGNXSDVOb3lmVWhlNTNtV0NOZkkzcEcy?=
 =?utf-8?B?VkVyeVdQNXNKbm5UUWhBb0pYTjdYUzJja2ZuN3NYdUtkdUNXanNOODNNT2Fo?=
 =?utf-8?B?MFFNL1N6UXhuUTVPMVlPdFNnR040RmZNN1d0alRrWi9LOENkb1VrMHhnZW1u?=
 =?utf-8?B?VnZHYUNzYUVRY2Q5RzlxNTBBcWFENmlaNU41THRVbWJydFFsMW1lM1NRMmFU?=
 =?utf-8?B?dXBVSDZWRFdhcm96Ym44TDVUZHN3ZlhyZEJMVzljN0JUN0xBR1o3U3JMTVV4?=
 =?utf-8?B?NEVGbDVRZHI3RVJDRjBCd0dqZTNiOGlTVlRKY0llSm9HS0ZLQjFtT05sUUJn?=
 =?utf-8?B?WG1hVWlHMkdUMHF5U0ZyN2NYOFQzS3dDS0o4eVF0ZUtaeXZBMkVmNXlzNkg5?=
 =?utf-8?B?WWpCU04wVm92V3g1d3VVQVE3N3JlcERMYmZKRm5UMk5DY1pnOXV0cVJwQ1BW?=
 =?utf-8?B?Q0p1SHdzTlRYUElXZXQ1UlZDSTdjQnkwV2dya2pLbVIvUEdFaWNhOGVsOXlz?=
 =?utf-8?B?YnJZQkpUcHlzZ0FvaFRIa1dCMUdNdmJFdllWUEczNEVoMWF2aitZUXZTcTI1?=
 =?utf-8?B?RXhXM2JKTzhORVhvdHVRYlpVQ2h5YmltTk1JOUx5YlVUelJ5M3orRkp3T1NM?=
 =?utf-8?B?RHNMNlg1YmtkZzV4QXM4czY3elo0SitXcnEvQzdBUGJRb01iRVNMcTFxVFI3?=
 =?utf-8?B?YmtFcEpwVG9FV2kxM3ZIeTl0a01YTVFWbXQ3VzRUSmQxcUo4WkcvdkxYend5?=
 =?utf-8?B?dzVRcGNUbVNzL2Y5NnBjYlFRaEdNdmMwdUE2SjlFUy9ZYmVpTURaWnBVL3Yz?=
 =?utf-8?B?WnlVSFBaNEhDU0l3aVhnaEg0b2EySlJPMTdTM3FvME4zamh0aVNraytHTWRI?=
 =?utf-8?B?L1pTdFdVYXN4OUV1VkY1ZmloUmxxaVhORTk4bWdmN0lvQ1Myay9ZY0Z4VlZI?=
 =?utf-8?B?Skp0bHd6UjFrRTVBZklzbm5ucitqcXNNSy9wc1lxZkRWRytQbldFMjVmRmZZ?=
 =?utf-8?B?b0JRek43UWU5YTdIUDd3Z21aYW9aM0FnZ0FVcFRkVnJRYVdMMXA4YUk2ajVR?=
 =?utf-8?B?R01rbGJjVEI1MHJya2QrdndqNlB5NlkzTU1YWlNXS3plbVBRVnc4aGY4Uzl5?=
 =?utf-8?B?N3hrekpNOWRsNXVib0hJNkNEdjNNellienZWbWduMTFYSUtES2F4aHJTb2lo?=
 =?utf-8?B?OTRSYlY3N2pFenJhd2FmcjUyZXozWTBSL3lOdm8wVGtvSmNZVWxBbk9VS2JR?=
 =?utf-8?B?VUhmaFBYcWxsMnQyTGNUQ1JxbVFQZVpoK0VOcnRXLzdpdWxVNjRRWFpRUW53?=
 =?utf-8?B?RjVrZ1JXdUg4Z3RsdHRVa0NILzRGTWxvZGVFc2loRlZ6Rk11YmM1UHhyZElY?=
 =?utf-8?B?Qk1HODQ3UHFGZDQ4T05RdEVDK0pNTW1aNElZYVNHeC9nWW0wZ2lOcXlyY0Jo?=
 =?utf-8?B?MjE0c1laR2E0azlNU0FEZy93b3Q2UVgvRE9XZE9ZaG94OW1lV25tbHJNOHlX?=
 =?utf-8?B?bUVkdm9Ba0xHZlJBQVduTW1tWEtlWTFubzJWa2l4SGVsQU1MZjlaVVd1L2hR?=
 =?utf-8?Q?p2LjorhT/gYtEZOynBE/rWaCM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <691169E939C9454895679B8449D0AE14@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ba8cb8-5ffd-4bde-c7a8-08da6003d151
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 10:31:13.9156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/6gt/VueKCzX6B55JDF5m5Ces+p7/4X1gW043qa3LrgrWPadTRo8+x+eh9paAa8HnyoAsGL9MmuEWvUyy4SMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy82LzIwMjIsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gT24gV2VkLCBKdWwgMDYs
IDIwMjIgYXQgMDQ6MzY6MjhQTSAtMDcwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gT25seSBh
bGxvY2F0ZSB1cCB0byBVU0JHX05VTV9DTURTIG51bWJlciBvZiBzZXNzaW9ucy4NCj4gV2h5PyAg
VGhpcyBzYXlzIHdoYXQgeW91IGRvLCBidXQgbm90IHdoeSB5b3UgYXJlIGRvaW5nIGl0LiAgWW91
IGRlc2NyaWJlDQo+IHRoZSAid2h5IiBxdWl0ZSB3ZWxsIGluIGVhcmxpZXIgcGF0Y2hlcyBpbiB0
aGlzIHNlcmllcywgc28gcGxlYXNlIGZvbGxvdw0KPiB0aGF0IHN0eWxlIGhlcmUgdG9vIDopDQoN
Ck9vcHMuLi4gd2lsbCB1cGRhdGUuDQoNClRoYW5rcywNClRoaW5oDQo=
