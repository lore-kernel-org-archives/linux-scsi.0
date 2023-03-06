Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE0BC678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 08:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjCFIF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 03:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCFIF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 03:05:28 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D0C65C
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 00:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678089900; x=1709625900;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=+ZGh4Tbmk1Tmmc6HHLHAlwZ3r1WMwgKTxp+LuEU9QK8=;
  b=Y2cVBBugCH7Zm66hmC5iyVFl9qMKDSs3fQnPXG/J5pDJuvRuQ/KMYxQJ
   omcWuux9Q0gpzHhmyyOS3dPycpLm2dcZDC5DkOwI6R0RJFXcRY8uA2Tg6
   BEci/hqGdgmtAq3W2M3dnay0fin4ScXjH9VaZDmBxuicd+xK31HqgxBw4
   O/rx00v2Nmv3JLlwLF2oEWX5xkA4FVDjETBDbY/YF3TTSSqhJyernt29C
   U8MPxUyOV9Td43HtzX18/lHMEhVSal/1jQm18Md/I8WDnlfVpDSywXCIv
   9Gh1ZuOI2kqeZs9bxGzDBvJ4PGnmTZblbZwZiyY86BzK++420CmRbUWn7
   g==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="329217827"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 15:58:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN2w8e/EbYCgi/SCmEIJPNUU5f5eKrGFJ42/NStyjbv7IGAu5darZJ52ciqxBpQdqmkcQFcT8XfFYN4W4z9F7ucn7pcoKKRJIewjDaO4o8FbXqFo0i5VYD4WHn7T5EGGiJpeS46/6kKdfk1jaCTg21zE7zSpPkq1VLJsstS0mSLbyf4V/UvtbLLGHqGVrD6vTwRPgyQK7D9F0ImBffokJm0LRsqN0tGS8hQdZpZ7WUX0+mDedV5G1/IqHj6XRn3JORO4cw7M1TI0niN3gnQ8Bb35JuczbnuKbib3ISQj+c8PqhcrGlsRHUPkUQYdPCUJDldrn7YU5pAGBlCMDpXDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZGh4Tbmk1Tmmc6HHLHAlwZ3r1WMwgKTxp+LuEU9QK8=;
 b=OHY3e1LsbrZ7gv6N9ps2NXpvuLk+WEefCY0/ybz/jd68mRXE0uE67bAu7rWK4xOOkwLPx651amtmV9DLPK+jXuKux4J6jLTovimaUb/ZaC1aHQvVlsIibFdFqZ1stzxXgZRohdVKqGnTP0NLUad04FI4XxmNoLDDIs4vo5AeLtDH9Yc3+Qr58kGLNGWaRca6xTL0rEBOM1KOgG4jj+A98EAlRl0qj9cLR40JLyS5MmmrsmEd12glKt7laGQ78qWL5roz79cfW+fSFdLfMq75WWd7mcV/p57JxR3930V55gU2Jl2TyYt839oa4tHoSZZR2ht+oZACuRH7ids+R2pxuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZGh4Tbmk1Tmmc6HHLHAlwZ3r1WMwgKTxp+LuEU9QK8=;
 b=JnqeXXlEkYp6tu1/W3TS2/JSq/K7gnjWaB2c9IpIg/3pdx1zV0+PxRwivu781Ho82be0ifuAWxnsmCDwmuWX1wVPlKXb+aqyGslF15iy6vgRvCz0ysOVsnal+gVlTpgyxWoGrlEb+p4tPP60Xs08WLK0ilIhRZexnsopbk+wdQ8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7174.namprd04.prod.outlook.com (2603:10b6:510:d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 07:58:52 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 07:58:52 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Topic: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Thread-Index: AQHZTXGx6nIjJMYC5EeQSEpL0Hi5Qq7pWikAgACWo4CAAM5PgIACqPoA
Date:   Mon, 6 Mar 2023 07:58:52 +0000
Message-ID: <f217e8a2-4fdc-0e7e-12a7-ad2215389de5@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
 <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
 <23ac3205-d92a-b32f-d0e3-29604cf859cd@opensource.wdc.com>
 <5b81a4b6-82b9-55a2-a75c-486886c96e9e@acm.org>
In-Reply-To: <5b81a4b6-82b9-55a2-a75c-486886c96e9e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7174:EE_
x-ms-office365-filtering-correlation-id: 1c0624ab-d89a-49b6-59bc-08db1e18a072
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZAAPgIQ9fDqEb9yk/Nvj1SrJc30mKlgTrcei0Ishtuk+DtWFYCF0eQtCniTQ7xgf01r9cv0gCuhDOoaWFh+VQ05zAG6du7DEWW8pt56PPxdcjkPvEzEy2x2NC8HaP5AFgV2wHeA0aTYKTNeEatBDWHz9Mz/UXhqcuB+uvi3F+auFPWgLFYGMjo9zJZatD+TsBId2vkZeGdIygK7JVkuiq9DaGUUdTspMHqWLZ5baJW1eNC/qfW3nKDepOFIgWcKqPOBtCttvktKrPxmowplHGwaYRddiwSTuSStytC6axTLAkJ9UMibpX5Mdet2BRStZWo8MBogPob6nYAUpQ3lTEmpSRi4GfAgEZmoLUmM9a5DqTWTYudldZC4Ga8/cuAXJcmIcoyYZ5EjsEBoyQUZKhc7J3L9yDpnxRRU5RxJqWbYgNElGChrTJKYp/ysAe8kI1OdbU943E7g5nwOIOmRz/9cdHSO+sBcIkZwwQWZ0uYxafWWIhEphAWkMWQU2h3oKps9tq0nzQRC7cQn2+aN+Xyh5t7miRJvbTp002Q4OjVvY47iXRV0ugb9KbsGiCBVOE6JiOYrdbeapL4QEVuRIDhXw3ViyMslyVRzEz3kcAg25iaBMxzTpX97jphvSU/H764r4cIWAxgbyYCNNXi0M5Yig8W4LsZRy5JdasCFHjf422hVj6rykJu1P23wob1ro+j+aFP9VMvSr7I3kVeInh55iAp5fk8pFMfXRmsnOj253zRPn2koDdSDnI/Om4hCzuyqGKnlo+FR7IpM4HKApeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199018)(6506007)(6512007)(53546011)(6486002)(36756003)(38070700005)(83380400001)(31696002)(86362001)(122000001)(82960400001)(38100700002)(186003)(2616005)(26005)(41300700001)(91956017)(66476007)(66946007)(76116006)(66556008)(66446008)(64756008)(8676002)(2906002)(31686004)(8936002)(4744005)(5660300002)(478600001)(71200400001)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K01STjhrRkxpSm8rR3ErRlJNZHhYUWIrNUdvVWlWS0p1T0ttSUZLWnVHOUFI?=
 =?utf-8?B?OWw5UzJGYVowUDBpQUJtdDg4RzRieTJqcEdTL2NCZ0xLd2VTUXpKRkdOQTBs?=
 =?utf-8?B?NjdlRk5hMUt4ZVRzcW8xOGx3WndRenVmenZqRi9IU0pIMkxLcFVxRjJSVWcz?=
 =?utf-8?B?Q3pLd1cyUG14U2pEYWpmbWIwYkVJZmV0OUVMeW0xeG1CeEVPd2VBRHdnUHow?=
 =?utf-8?B?bHFoSjgzaHZ0L1FwTjZ2Qjk3THIzbG5ZSjhOaE0vdnRPRytDQ0cvcEtrUHo5?=
 =?utf-8?B?Wms1OURJdDNaZmllRENHbTcrT29hNnVadWlkb3g3UnQ2SXRZalBHM0xXYjN1?=
 =?utf-8?B?UEVzb2lQTC9KR2hETzVTOTl1Rnphc2c2SU1UbExseWhqeGZiVy9aN0g5dmNy?=
 =?utf-8?B?SFZJYmh5bDBHQnZKK1Y2RVZDc1FwR212TzJBdGF4L0RGVXl3NURDMDkyN0VN?=
 =?utf-8?B?V1ljcUJnOVR2NU5tQ09sWitsazN3QVRIQWxMMmg1YW16OTEvQkkwSVY4eWk5?=
 =?utf-8?B?N0dYZVE1aEMzOEhVSkZWMTYrY3BpYTc2cEpTN1RzYkJqeHVSbEtGRTFBWmlj?=
 =?utf-8?B?QXJxSUdBMFJ1QXZkUmlkZkI4dC9UaFp4SlJ2VjR1WjN4VnE1R2FRUHRSckpa?=
 =?utf-8?B?N1hmU3JDM0lrOG5ScDFyWG9iMlJ2QkpNbko5TW1XNjlRTHdkNnlta085Q3di?=
 =?utf-8?B?d1Z5ZWFaZk1JbjkvcFhjYnEvMEhhUDZVVVBqT3FVMTdwOTFiNjB3T3o2SERE?=
 =?utf-8?B?bElnemVvQWw2ZWZkM21xYmQvb1FKMm1lbXRaNG1UaTljaWxnMkJJOGV5MkQr?=
 =?utf-8?B?RGVQL3FINFNrcWp5bjF6SzRtVjRPVlJkd0RRY00zYzBIQUErQ2RTMXJtdzNl?=
 =?utf-8?B?ZVNRY1BPTW5DOVFkYUVaSG1kdU1CVnNIRnZaMmdZNVpRUjQ2WmxlK2tDS2Uz?=
 =?utf-8?B?VTdMNVM4OHdyMHhRQ1FKK0xla0ZYWWRoTVVTcHluOGY2ZUFtenJJeFNmUm1W?=
 =?utf-8?B?SXN5SmdPWkt4b09hR2hMc3diR0gra1R2N3dkeXhoR2piM2pwWTlHSmxnYk5M?=
 =?utf-8?B?M3FkV1VnY3dHRU9qUTkvcC90S05zMWYyb2NjM2JWMG5EM205QU9vSlEyRHVu?=
 =?utf-8?B?Z0V3L25BTjhwdy81ckQ4TlZ4UmtERWM3dk84MHpNd0V5Z0V5c2R0Rm9WMlZJ?=
 =?utf-8?B?cS9kWXUrUkQ2eFZSWUtvWUpwbjdFNXphT3A5R0EwRG1YMEE1c3BhbmlFYmda?=
 =?utf-8?B?TEFlazBJeEw5cWZxU3Q2OHlhVVAvTlNBSEhCd3o0NFF1Rlp4NFpsVW9GZ0VM?=
 =?utf-8?B?aHpFK1AxNlo3MkJVUzl5RUJOaksrSTJOQnNJM0FmYmUxd2pMYWlHdlc5ZHh6?=
 =?utf-8?B?NTB5Y09ZOG5CYVdnc3hydi9MZ0I3UlpGU0FnMW00eHZNd3BJeTFqTXV3ZHJG?=
 =?utf-8?B?SWIxTHFLNVhFV3BwZDB6c2N0MnlCUFI1eHNyRTQ3OUdmY01OcVJJUlRLbFB5?=
 =?utf-8?B?R1VzZGw2WWZZcjlySW14MVBPZUNXSkhIZzZRRXNCMFIxSkdob1ZIRkpFM2ZX?=
 =?utf-8?B?SGNXOFJLQW5NanVzeml6WjZTckxudVV5UDZOUE5PRDg5NmxBb3lhdk4xZDFa?=
 =?utf-8?B?UFBDMlU3VmNEaWMwTklhU1JqWURMdGtIVkdKOXhQcUpKcG14L29tTHhSaCt5?=
 =?utf-8?B?ZXgxNlBpZWZkNlBkZSt3bGt4WWllWmgxYnNhSWlwTFdPUkZhUllRako0aTF0?=
 =?utf-8?B?dEErWTBqL04rTGRtWjY3KzdMOWNNWGowdHFEZjF5VFRwMU9MeDNrL1FMUlNG?=
 =?utf-8?B?SEJhMU0zZjEvZExhZ0FKaWExMW5wbGtTWGxjZlZ4VHhvUW9BN004U0JUT0ps?=
 =?utf-8?B?RjVZMHJMblpKN0NVY2ZhcHF6VTFzcTNZRHZ2USsxMUVlaWFlV3JPVzhobGxB?=
 =?utf-8?B?RDhIUjBMMWkzbzVscEVLZ0U0S3ZsaXcxVjNwVmFFZWsyKzlRU3phUHZOM0w1?=
 =?utf-8?B?dTlKVHptYWNaN0pHS3ZiTnZrNDdOMysyYXBiczljTXBpc3BSTVJjWWtYemMz?=
 =?utf-8?B?NXBtRHlHdjdoUHhmK1lWeHdUOFhib1ZsV2E0NkNYRmo3SkowZlFHdkZkbGht?=
 =?utf-8?B?aHFKTkk3d1grb0ptZXZWMWNjcXcyR1FPMmtDOHk2Uno4UEF5Y3NKRjVCYXk3?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A793876CDA44C49B4249EE20CDB9C82@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u/J1FWWpidf1Tk1efDlJSpMIHN9qTZV4Y2TGAAsIa47YLCIK0D5Q1PGw3f0UN4WgVw+F+1wCje6wwUQDbGGnkiykYXTTFp9MubIwLt0PLZEHEkCR8oNZtZjSfwd4X05w8wXu1Fg70THf6CuD4EtldKy6tKRxaK9sixPs96oOPfyfsQG4WIbKbTKuZlzA47HvqfKMbWfCBOms4MjfEmkIQo1OJVycPBRDhZ9xhx2Zr1Ph3bzPS0uy4O0EHSnmaJ6tnbTtWChHY6WQ4KlW5YhNpvXRxADrUBWWIR5MwyvnQnPUFE6Iky1jPTdSINc1fgdp+4iOezOrAjAncSsmTTg2mwpB6RwM83uLvSFuNivvr5VXoB93sr1vsO0UrJe3q53DwWTz0Lr3Xit5lJAlj3ETUe7aKkFBvbNkRlrZcm5ZMmNAE3WP8S6pQQsebgmECUDArZHSikoLEqDyHGwB+P0qWssO8BWqS2ppxjih2SceK4GlKOU5eFsQarqTuUxwuDVqdGjnro5tq3Iz9UyU08aXDAS9j+zEagQe5klPB5kNtD4kdQBff4CH6wWhztgvG1Hh+a8me2Gme3O6IWLSPoONN0JlW9IWF8jaS/Ri4W8obmMZOB4J8EU1Hm+kGGD0wqgA1sPu24yedHNQifP3AN+sn33gHcbrzBb+jPAtNHcED6v5LWMynFVm0A+SirQQqHkmc4MWcoaS8XMWwKM2OKPBLxahGESQx4ieCZW9KzqXH50S0X14Krn39Y32inVu7HU/Lw2zemLQpXojNbVOvyhDU1YMwztM6NU83hcd2kgH4RSL736f0Z9RhQbqgwlSRy/Y8sZyTSucJogb1mSTt1Nn6w==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0624ab-d89a-49b6-59bc-08db1e18a072
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 07:58:52.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yuFQWBNeBRbiKBeLBICsP8dV8mErCP56DTWaFCnH7l0JVvWCXKG1uKVMPSAgIjTcHxG84/WG/7yXH4nqj6dmdeaswBoYPvevRvswdin+T84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMDQuMDMuMjMgMTY6MjEsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4+IFN1cmUsIHRoZSBk
cml2ZSB3aWxsIGZhaWwgdGhpcyByZXF1ZXN0LCBzbyB0aGUgZW5kIHJlc3VsdCBpcyB0aGUgc2Ft
ZS4gQnV0IHdoYXQNCj4+IGlzIHRoZSBwb2ludCBvZiBpc3N1aW5nIHN1Y2ggdW5hbGlnbmVkIHJl
cXVlc3QgdGhhdCB3ZSBrbm93IHdpbGwgZmFpbCA/IFRoZQ0KPj4gZXJyb3IgbWVzc2FnZSBhbHNv
IG1ha2UgaXQgZWFzaWVyIHRvIGRlYnVnIGFzIGl0IGNsYXJpZmllcyB0aGF0IHRoaXMgaXMgbm90
IGENCj4+IHdyaXRlIHBvaW50ZXIgdmlvbGF0aW9uLiBTbyB3aGlsZSB0aGlzIGNoYW5nZSBpcyBu
b3QgY3JpdGljYWwsIGl0IGRvZXMgaGF2ZQ0KPj4gbWVyaXRzIGluIG15IG9waW5pb24uDQo+IA0K
PiBJIHRoaW5rIHRoYXQgdGhlcmUgYXJlIG90aGVyIHdheXMgdG8gZGVidWcgc29mdHdhcmUgdGhh
dCB0cmlnZ2VycyBhbiANCj4gdW5hbGlnbmVkIHdyaXRlLCBlLmcuIGZ0cmFjZS4NCg0KWWVhaCBi
dXQgaW4gb3JkZXIgdG8gZG8gdGhhdCwgeW91IGhhdmUgdG8gcmVzdGFydCB5b3VyIHdvcmtsb2Fk
ICh0aGF0IGNvdWxkIA0KcG90ZW50aWFsbHkgcnVuIGRheXMgdG8gdHJpZ2dlciksIHN0YXJ0IGZ0
cmFjZSwgeWFkYSB5YWRhLg0KDQpTbyBlaXRoZXIgdGhhdCBvciBoYXZlIGEgbWVzc2FnZSBpbiBk
bWVzZywgdGhhdCB5b3VyIGxvZyBjb2xsZWN0b3IgY2FuIA0KYWdncmVnYXRlIGFuZCBpcyBlYXN5
IHRvIHBhcnNlLg0KDQpJdCdzIG5vdCBzbyBtdWNoIGFib3V0IGR1cGxpY2F0aW9uLCBidXQgYWJv
dXQgdXNlciBmcmllbmRsaW5lc3MuDQoNCkpvaGFubmVzDQoNCg==
