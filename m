Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7A8EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 07:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjGCHY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 03:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjGCHY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 03:24:27 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3459E44;
        Mon,  3 Jul 2023 00:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688369066; x=1719905066;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=K/HAs+fby1SH4kQMlYcyeh/BMTQQAQZxPxMFyV3PNIfXa+oHV73Q3e3E
   V1TQ1XaMZxTvi+tsqANDwZrtPoF9w60tUmou+Yv/6h3oA2rx3aWhHk6u7
   RsAFvaAZ48dftOS5Lw/VeH+w6Vx05y8J6sRbeMqVQT0p58NQ89nvvq0QV
   w2pu24muLqsI1MCDFhI2rPaPtvEecB43/uyBoubImmSONloTkNO8wEA5d
   JTld0wOZd+ZyfYLNK4583we6Bg3BV+Wx5h30u2DeI/wULo6YOIiALZNxi
   v5V5+A+YmdXzHS4GFJQQYIefosvsqwyE6KgZ+7qZ6wpj2S6mJjdPG+x2y
   w==;
X-IronPort-AV: E=Sophos;i="6.01,177,1684771200"; 
   d="scan'208";a="241745345"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 15:24:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUoIRhD9x+jAw0ka3dSbVSX9/Hmx1vGn+5TfNSjSpZ/I8WVNkmWOvWjbDukFvQGjsEhRcwXlSNpzFM/KPGQPSqbTQWxMZ4hRrGoNOkRVaT7qjW0n+Q9I9swF7Jr5nOqNN1VoUj4tvMzznZSZI8o1hv3T7iLTtOz+AZBTVjBJorwezUMnqhaU8hlu52e9DR2UQWbfCK/ONzKpDjfV9uqM/b1zKcxNkEtjuKu+hw9kJq73Dbm5kRbtrPetVrFK2XLBI2jA85J7AXpjYl3Ie3m4mugbtQSgn66EI6dmwWVxRY6syPQnTi7IjQogeUfOiHkmhVJ2ZsqbkTpJ6PXOIuvYNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=aOaOUQZzKBujar1R06vWD/ZaTo6GlC5L/ceeDyzDESBqlrHGBAUjDu8FUTevCkRxnl2IxcZrjltaYikgdRFqhhjqObVJm5DvWCNTPu3IJJ9zYolSRcYkIBr4T3i9FArtK17Te/lbngUIX/JyK98x5DrEOA/7OLQweYkmNGdpiQjrLMg+2jObIcIUFl0T8MWUoSiEZwzwoE8GvQSEFKN//+8NCXqSZ7lfweGNH+hSRJh4jpJLa9xqtIkqjjtM7aCEynexPkGJ/nEqh6lymnx92KMBYM27rfRNeXzNqFKeBX7lYpNB24AsmsQ1vfyFYtYuN4Svu35dkMG1qgUmPNC8gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=LG1SE5wV2NY9Uy9wiNEQrkH1H5zYIxNpDatYVEghoU9nm5U3OKTKMc3qOrQ3uPqIRXrReu6VhnaS12onpsRlg6hQ3T9jwjulrgC9jiCj7JQjOCsJp1j+X80k5rbe+4MzFmqQvxuEiGWaQN/rWqg3cnyzXGV2N0CVzlupLcU3b4o=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB7019.namprd04.prod.outlook.com (2603:10b6:5:246::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 07:24:24 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%6]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 07:24:24 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 3/5] block: nullblk: Set zone limits before
 revalidating zones
Thread-Topic: [PATCH v3 3/5] block: nullblk: Set zone limits before
 revalidating zones
Thread-Index: AQHZrVjbFikfec6Gx0yRhd9WC21p4a+npBYA
Date:   Mon, 3 Jul 2023 07:24:24 +0000
Message-ID: <1ad0170e-1ede-c91c-1086-75324683708a@wdc.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
 <20230703024812.76778-4-dlemoal@kernel.org>
In-Reply-To: <20230703024812.76778-4-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB7019:EE_
x-ms-office365-filtering-correlation-id: 2547f360-0cc6-48ea-fe09-08db7b96872d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /9whV00w1cZC/ZQ43m7TbTjnhD+ZUCQVHLBETyrfn4yQjCumYpoP8rqaOSjJh1bBnCB3mm8ATgxc2bQD3MGczhlaGakijbyUHsQGG0YWFXOo9fWn1WuByvMHr6/SJC+l+uha0Pk4ZlBzYF8ShfmoAFgE8x3gDaWerCxWU5Es2xinLIf4Ok1/MZpYU4++dnMvO2h6gRgaKMcTQHeeOS4foN/75bzrM4uGrmWgaMlegg/LjjWtxb+ZUjkkE4etVW53NOl/sV9SiE230mbOGZCnnmiHyQ+78XFxmTz3UADEjw4keIv2zJ1eJpPL2olf/xqDZymKiKXxnS0jnwr/43vNZERwrg/a5qmRYwHa6wp7kyqyvFqxGqfJd+UhUX/wyLj7TbuMIPa7pOtpGQLBfUOVQplf4IIk/gLlVNuoWlQPe9/12on9PdvwsaTFv3Uc6kFQFLH+VCy1yGf+SYDAcwG3Ak5LDS/JSgx7GUdLTWfjX4YTLCNXmtqwTUBzUmmBjlNgQJDJo3jSzO1Xjt/OB/Emzi8JL2K5QDPg+uMbDNGNgk6htlaLP12yTPnlFvsukpwzda2XAyS7EqHvG5QZwCkzRjlXYUUjHYRP7pJKuldNoexc5Tb0mVX69DoWyV3+xZWWXsG3oOpN2351+JGmaL8zNhcQNE7stnq2WAPie9xQoxRTnArTMmaAxR6VoZ95QWlZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(31686004)(82960400001)(478600001)(71200400001)(6512007)(6506007)(31696002)(86362001)(2616005)(186003)(4270600006)(38100700002)(64756008)(66446008)(66556008)(66946007)(66476007)(110136005)(91956017)(6486002)(76116006)(316002)(122000001)(5660300002)(8676002)(8936002)(38070700005)(19618925003)(41300700001)(2906002)(558084003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUpKY3hjMWdnQXoxMGUwaDg1K1Q0NlFmNkQybjRRd3dXSnVQaUtmaExNWFZC?=
 =?utf-8?B?OVFvcTVIam5BeVhkSG5Sc1NyT1VSUFNoVGpiZitodEEwRGdSZGM2UXlDVTdu?=
 =?utf-8?B?bEpYR01CcUhyQjRMMGZBOHV3QnpWRmNPYXZFbVZFNk52ZUc3ZWxBTWJhb2Q4?=
 =?utf-8?B?VmM2WDBuUDFQN3NrZ0phaUwraGtkdlFDOFFqWTRQSXRyR1FJT0crd1hmMUk3?=
 =?utf-8?B?YmlXU01FWXJTN04vbTRaNWpSTW5DRDBkUnJGSXhLNDdqMFJmODNrWkpqSHd5?=
 =?utf-8?B?dHBPUnlmZE1tU01xUTYwdEs3WC9YUGR0Z0ZLM252V1MwMTB5QURsRlA2UlNB?=
 =?utf-8?B?ait0WU12SFA1eDlqV1Y3RnB4blAvMWZXK003QmZzS0VWZE51dmRBRW1VajRN?=
 =?utf-8?B?R2hHWGxEQ2x5YUNPeG1WS0xCRm9XS2lQRG9mdG9ZZ25WK3JCSjhvUWFaL2pm?=
 =?utf-8?B?elh3dEdFcXp4NFVrVE1nckw3aWlrOG44dCtpcWUwcDk4aktIWkJ5Z1dyQlVm?=
 =?utf-8?B?djNGb2gxVzdHL1JhRFBqN3lobGg0dytQQVEvZjdPamVqU3MydGpaYmxNZDlm?=
 =?utf-8?B?dzE3Y3hLOGU3TzJhTmFWakowOW5xU2pXcDVUUG4wbSs0RWZyamdadm53dmdL?=
 =?utf-8?B?eTU0MmtzbTFHU3ZMZHFwTHROK0toVDRMeXhHTDloTU5PRjRocW1nTEpmeXQ1?=
 =?utf-8?B?My8zWDdjV3BVNHI0TmpaSGRKRm03WTk3enUveUpJTkVZN09rU1M4THZLSXZC?=
 =?utf-8?B?VnlLSWR0dFBBcHFIRHlULzVNWUgrcHhqVjUvWFVaQWliUjBqSWpHWVRaUStM?=
 =?utf-8?B?Lyt3U2ZnL2tEZnNjdjJmN0pIWTd3SjZGU1FET3JUWDBzWkc3OHRjQUptN1pi?=
 =?utf-8?B?TlErb3NFVjdraWs3STdqdm1XdmhaZEZDOEpJTUlhelVzVlBQQnZ0ZkZnNnhC?=
 =?utf-8?B?TDRhZDJIcFpYVXo5MGdZZjlicUhuY0Q1R0JJVDhKMHo2aFN3OU9mZG5DSE5r?=
 =?utf-8?B?SE5yZ1NQczFWandyTy9ybzdOdjZnMXBBUVZ2bnZmaFdVb3grclA0NXBWa2Uz?=
 =?utf-8?B?YXNHZjlNRlNwU0RCZkFhNTJsUFNQaldqaGEzYUtPTWxLSzIxTnZIZlNsR2ps?=
 =?utf-8?B?azR5eW8waWhYT3Q5dThyM2o5V3REUlVoYXBLdHljdVJrTlk2UFRWM3F0T2xl?=
 =?utf-8?B?QWtaaitqQ0JuUS9ITm9wRmFac1pXc3A2MXZCcGc3c0lCVVM0eEpjVjd2eWtQ?=
 =?utf-8?B?dWx4ZUxTb2QxdENEdHVpU2ZUNWlkYkpIMnpVTW9adXRTYVpZMWppK1lROVBW?=
 =?utf-8?B?cUk5WE5CajR6SzFNS25XZTM3U3ltaU5YRHFYVmFDTHF4S3FRKzQxM3JGdGEy?=
 =?utf-8?B?SHdZemljSmlEWjJtclRKQUVLVk5hcWxQK3ZJc041MFRtdzIrckh0RHhFSlpS?=
 =?utf-8?B?WXNneVVULzBEa3hGTTgxeGNPSlV4QldXOXpUQlAvT1hDRHF2VytNenA0YVUr?=
 =?utf-8?B?bmNlaG93RnoxSWRpNXpXK3I5THRVdXo0SkdtcW9tdmVIamZPYlgwdlcweDN6?=
 =?utf-8?B?RnhqNVR5cVhhMGp5N3NmVW9xNHRFd1JubGxlSnpyaWJMZ3lWN21Bemg5eWMv?=
 =?utf-8?B?TVdDSE04VkRDN1Bkb1g1Rlk4em5GeHl2WVl4K0JvemwrMm0xd0pCemZ0dlhE?=
 =?utf-8?B?WTdvOWl5aHhaV25nckRoODlQR3I1VTBZNHQyYWlUamZFck1WMmI4ZC9wQ0F5?=
 =?utf-8?B?Y25tdFQ5RnlwWElVVlFQVGY0VzgzRkJKK2ZsSS9TZzlDRXpHL1dzZ3pwbVFh?=
 =?utf-8?B?MEVLdmxFek1NMFN4RkNXMjRKTFJ3MEhNUDRTU1cxdng3eHNJZUVoZFpFMnpr?=
 =?utf-8?B?SEwzV3VDTm5yeklkeER4UkFST1JBU054R2JScnRyZW9NV1p5ZzZSM3c0NnQw?=
 =?utf-8?B?dlgyS1cxMDNpRk1hZXlha1JLTHJ5WW1QMTl6czd1UFc4UDRaN05jcUJtYkVK?=
 =?utf-8?B?RmNXa2EzZkx5d1huaTVDeGMyOVpFZ3E0WmtnbVVaMGpCYW9oK1UrTjJnYllm?=
 =?utf-8?B?VzljVVl3TnN6SnBabEF0UitLS0FYR2duSkcwUlFrdTdrdDNvNFRsd0JUaEJ4?=
 =?utf-8?B?eGxzSHlaalYrRjJ0YU9MT2xNMkcxK284dU9yYzY1MmhscFdJcXhzSEhpT3Q4?=
 =?utf-8?B?NUJJZEZ0QWxYUnZXZGNhWmduVVM5TWlYYm9RaXFFTUZRV3BRalNmTTBDTHdC?=
 =?utf-8?B?QUp1NmtVY1Q4RmJRSDlBQmxXT2ZnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26CD121166A81B4A99657D3205845AA8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RGMyaDNBWlJXb21YMUtyekU3NnAyVDk1MEp1My8yVHVWNHgvRWFVSFlvQVJJ?=
 =?utf-8?B?bllLNmt6WlltNWZlUE9kSWpzSDFjYkZUVERpRVJjSzJmUUhWU2FhVkdrUnVF?=
 =?utf-8?B?TnRzMVcvMlh1NytIT0dZUEJHY1dyRGkwaVhNRU1hbTN3VHhSZ1hzWVpsbFdM?=
 =?utf-8?B?Sk9KdzRzVGtEM2FTOG5xRzZyU0M2bk9QUWlJS3JXbEtORHRzU05Qd1Z5Vk1Y?=
 =?utf-8?B?eUQ4RndEL291QlB6TmVBK3EzeUt5akFtRksrR2l4c2pXVnhhNU9iRHU0R1JK?=
 =?utf-8?B?eDE2K20rUDRnQld0T2xGU29DM1BhaHhkdXQwU0Q2YUk1cVNZcGdNQ3c3RG5G?=
 =?utf-8?B?Z3F1ZDBmUiszbzhhc29FOUQwMW0rSWVmMU9RZnp4bFR2SFFqaVhRcU1VRnJW?=
 =?utf-8?B?eUp4Wkh1NEt0RkJQUlJYN2FaSmlKRndtMGtRaEdSZ3BVK0h6bHMxTS9SVVlQ?=
 =?utf-8?B?TkI4UFNXaTlXTnhVK2NWcFFpcThmR2ZzbGxqYm5QNGRmRTBRQWhtZ0drczBH?=
 =?utf-8?B?ZTJrUlZTRkFJMVdpb24wUjdFMHRPbk9rT25GUlk0UXhxcEVXYVlNbkhFSC9G?=
 =?utf-8?B?VHBOUUVlbjdRQXZsVXcwWFA3NENuRWJrRkdMS2hKcWJKWmYyQk1iY1c3MVBi?=
 =?utf-8?B?L0hYTVlSdGUrbUxndlhXcDNoQXRCNXowTmJJQmdvWG95U3JEUS9ERWNjVWpx?=
 =?utf-8?B?SHJxZUFJcTdiMndVWElXWUtGQ1pJNkJXMFpuS1pZNXFGaVh3QjgzUm4yOGI5?=
 =?utf-8?B?aVlHUGpHR240bG80TEQ2KzMxNGFmM21nQlM3K3FMMTQxc0oxcGdGM3FnRkV5?=
 =?utf-8?B?a1RaWVlTNW1JK2YxRzZyNlI5Z1Nia3Z4QW1BNDN5RzNQbS9leUNySWRiVEZu?=
 =?utf-8?B?TFF4dFhNWXRWMnlkaWE2SmIxbUJZbXl5MXdhREQ1QXZZOXJDT0VmekFZN0tP?=
 =?utf-8?B?K1QzbHBhby9pSTRJSWEycXk4aG9CWkRVUExjWFNydUlzN2xvOTZNVVBFMk5X?=
 =?utf-8?B?R2JRak10djJGOHZLOC9KUHdxdjkzQlNNQTNtakw2SXRoKzlYNVZVV0cwU295?=
 =?utf-8?B?Qmp6bFgyNE56UUhHZ0dOcy80QmM2N2xVaGc0cHNDTXM0bTRIK1JKdlBrWXl5?=
 =?utf-8?B?Q1RBeFBxZjFFL3JBSThkelNiRk42UlI1M0FUU1RMLytKb0NPd3RiNTlaT2Vh?=
 =?utf-8?B?aElqQVBxSVNYVU83eVdOTHY0aGhIS3lkZWw2SkcwMTZYU1puTUhtTGxDejVi?=
 =?utf-8?Q?WcPI0oPqGvrFo90?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2547f360-0cc6-48ea-fe09-08db7b96872d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 07:24:24.6172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4aI3DVRjdigeqSltiKC9rfBB7OlrhDER8T7Hob+KTybRmOMKJV0vVWG8GPCz3Eu3sQhY08IiuEo5H7JwUKjqgQTVEKEMEkL/1NiSdXq4wv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
