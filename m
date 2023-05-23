Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8722C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjEWJRR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjEWJRM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:17:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B5B94
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 02:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684833431; x=1716369431;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=O57qIW0773k6wMM8sbixOeqdGNsTPcLRmXf07KzeXNNN/GunkmrblKbt
   t/3T23pGPJpgMFxqiiWoTzbvk8NXAEkqw7mzjP/YQ2ctwITlxUz4tSjnP
   e23YMqUnbAtbdSyu4j2VOzOxcGUltTMkR6Vc/ZyFND9F2TaGy+3gbVosW
   hP3soKNdBSrCVynR4YqXvBJ2kVwOXhTFySjU6/Dx9/+fS8076ZEge0kKS
   hU9ms/gjqIeqMN1UFS4xBBhCgMjP2s/SL94+/089dwMl+ryrF701cZiiC
   XahZHAyvewmM7erCDzexRgSPgyFm+ZtzDhMnAJo0SipbF72bSFLpamRxj
   w==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="335896318"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:17:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0sdh6vYrxUkMHO3WOMduoWTCVzhqglTd5JHZ4GVlS/6VnVm3zHaYJzvbzK3RMoJymtESPQn+HZyZ/JXzRFCHf6qiS+bcUF8e54Cmtw9ucbAm/cDPgZtasdD5w5xebyvj3ns1wJ387nEr4wOFw6o54My1cJhVdjA0mIkLQc0JpRQihVAjyafzGJJ4C1DAnKIxbxchBAgxclZ2ZbV85yKY8+CPkE5m+0Xoc6awhBkEk6JoyDVRguzkw5kuhw6TKgHdy1ZbzeHLf5/0SQlbVCjg76pOQhNbmi1Hxc4E7WeajO5A7EMcGkLwMmVQyQL2CuMeAK0OHUvW6vHoIH1Yqk23A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=D09hsEsu5sov+ffVKZci+LSDd26whnBQW6tr/FnKsLY7GiBekLiyBFiVgm3O9cuPvPlqfpY6QZBO4/zatmpDqVyXcPJh1i3DZ1P7OrB3JPd/0+L+Nomquoes14dm7Y1LpyhoJXWq2SusjhFbOkivlENhkElEQRtdZ4ha5F3wbOYQXloJJ1FCoqy8BCB+LNApne6gMJf8h/zai72Y3vGsPcRn5nffVpCf7C3hUzFxPScUuQUSm1ytfbIn4y2/w8QWawm7F5o3fTVHnhTmlZa8oYDtgdNr5CeynlWNWso80gd/B1jxJabWFewQHgN+HoK8OyduEHNKm6T71/p5KbVzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=sSiEdY8rCozpjALedbfgl1ZxIHTYHw+93wSOht9hCxKncs+/s26s9EXFpMWeViLbLMuXYJYHA3NUE8PoS6RDx1EghzL26zpNdnszd54jjZ4vyHvxaT0+oEO+DflZ+/KSM6k7S65cbnHOW+ybhxqBhjcfC1hXmm56jrjUTOAN57U=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7399.namprd04.prod.outlook.com (2603:10b6:510:17::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:17:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:17:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
Thread-Topic: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
Thread-Index: AQHZjUsRZsdeuTzpRUOKL3MuxuzjNK9nlBqA
Date:   Tue, 23 May 2023 09:17:08 +0000
Message-ID: <2f168eec-55a9-5229-cd0b-6bfb63fb331e@wdc.com>
References: <20230523074701.293502-1-dlemoal@kernel.org>
In-Reply-To: <20230523074701.293502-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB7399:EE_
x-ms-office365-filtering-correlation-id: 2650a7b3-305a-4937-15cf-08db5b6e7b9f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OfvwrYRwC29KHVcchpYOErjguCEbtWEe8Erw8Z5Oj0W1/Eb810OkEyYos9sQ1A3ZQK/SqXXIVMhTo6GQ3ORZUHXKjGFfOfmi6v1uFEo7L0C2saKL3yFHesMki+i5zfx2PmZIBCAAn//mHLod/nsZb7MeH3BsotyVaoiSL1c6t7NiL13rwiBprvOyiJfKcXr5n2HpETS6Ybcw4iQuDpZ09zLiw9UPjpI7BZGE6qedLQ+zRDx63g2NZKY1/FoUOMY7oor7pgRLssUH9qSjNYuDU9h7w2Z8U7axLu0m2n9CXn2YFZeZb9fkxyeQoi9a5J84A3bTGAKHfR/ZxCn7iK4a0ACLhgoYOFzTfLvAhGJMsXpDwukSllEl+yJn7hwnIddKqts3ebHcYhVUoT2b+HoGrK8hCMVREQQ/5QSfkeYOWxEQURtyROA2YT2gKQSj6MhEt6BQiLV6uR4A/ZvmtVMNq2r6RU4BcTx7z5OjHTJzDlWfdSyombc24UvmFC3+Bn8pfkPw/z9XK4MrFO+sEZp8QU+S2Pf1qCR+HTDkkCu6QTPK+3c+MRsK1z0SLcW5Fe3yJ3x9V54amYxS46hQ1neJiwzIQCv7ZL/Pjjvt608oD+inIq/v2wtwtWM6LPOlKXczXvaUBuGdVQTA6YYqUG+OacGyzczPC055cWgQ9WXKigKb+oChKv/aV+95ippMIfrA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199021)(8936002)(8676002)(5660300002)(186003)(4270600006)(6506007)(6512007)(122000001)(31696002)(86362001)(2616005)(38100700002)(38070700005)(82960400001)(71200400001)(41300700001)(91956017)(64756008)(6486002)(558084003)(66446008)(66556008)(66946007)(66476007)(76116006)(316002)(36756003)(478600001)(110136005)(2906002)(31686004)(19618925003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlV2QS9hMUt5SHZpVzlaR0FnUzc0NGU2QlVVYWp4NWRFTFg1RTRVK1FMYzZu?=
 =?utf-8?B?VjBueXRiWURZbTI0eFZuYlh0SmhFSnhDUm9xbkF4dkZYc2daVC9UVFIzSXkv?=
 =?utf-8?B?QXpyN1A2YTU3WDJTcWpXSXZ0UkQ4WnVZaVNlamVJcEJoZUpobS9CZGVGSS9s?=
 =?utf-8?B?OVAyb2FaTTBrMUNvMUNEOVc0T1F3bDVubzlPdDNFNjQ2WmVpUElwVkEwcS9G?=
 =?utf-8?B?N3Z5UStFTHJnVE9FRERCVENFOWxhYjNEdTRkM0RtWVRZZis3b0QvcjBEbFJa?=
 =?utf-8?B?WDJGd1VPL0VTRmZZVFZGYnB3MXlkT1BPUUV1VldtbFQ0a2hMQmVDVmFxd0wy?=
 =?utf-8?B?b2Y4aVpwejJOdjEyMUMvUXowZmg5d1JLM2U0Kzl5dlYvNkR5WXF2NnJUb1VH?=
 =?utf-8?B?VlhwM0dmM1J3aG9RdXNZQ3ZaeXBlN0FIVmpJRzFIakpKdSs4UVJlbEFVQ3Va?=
 =?utf-8?B?R0t4bzI5aWk1MXRtN0xQTlJ0aXBDQkFBRGo5T2g0czhTRWxQaDhxeFYwQzBw?=
 =?utf-8?B?Tk16eXcxSlA1ZzNjNlZMUWZoUk1wQkNRWnBLRUJaVEdXYlRrSGdTMWFLeUZD?=
 =?utf-8?B?NEJCZkp2N3E1ZlhWNnNCWC9VRWRJK1UyZHgzWVl4dXBpWkFabm05MlFpVDdw?=
 =?utf-8?B?dmtJN2lvS0NUY2l1OUpndFJOZ0k5VjNMaDBEVkFnckZWMTNzbFhHKzcrK0w4?=
 =?utf-8?B?T3hVdnFpTEhDTUdEcUcvOVZDZGFodEpKMms1NW96QmRUeFpRM1B4U3F3QmJv?=
 =?utf-8?B?SWhZczhINjdUVzVRanNDaDJDRzF1NWVQOHJ3YStuTk8rWWNMRGdMbzRkV1Vr?=
 =?utf-8?B?Ymsxc1dMNFRac0hWNVVTQkhpdjJ3d0RFZ0xNdDVQS3M3SXg5OVcrdFRGb2gv?=
 =?utf-8?B?VWdYUXA1QUhQZTI3VC9ub2xvR2pnR055TFRuSStUQ1VCMmdBSUdpSks5THcz?=
 =?utf-8?B?WnNRTjJzOTFjQkVuOE92b3hiNjRvZ0l6emUyZCtIQStZU0VPakV4dC9yT212?=
 =?utf-8?B?NUszUHBhZEcxSXYzWVlVT0hsdTVwdS9ta1RqSjZ0MjdVajRJc2tLNncrTFQv?=
 =?utf-8?B?cFZEVmN5dTIrV0hMOU5xMS8vQ25YamFDb3BPOGlkSDdTT0dNN2dFRWl2NDk4?=
 =?utf-8?B?ejBlSXBaY25PTHVjZi90eExpOUFNUFhYZDBHRGlCQ2lPRkFYcjR2bXUyUEVG?=
 =?utf-8?B?bXdZbDkxNnN6MStxVWFzL0V1ek1HM2grb3N4akFDOU1ZQ3ZVbHhpUDk0a2Q3?=
 =?utf-8?B?a2J1ZG1JWDdtOVk1dFBNc0VaVG1DMmZRWkY3VjE1WW1kWGN2SDhCNUdtekNr?=
 =?utf-8?B?OWJzQmtaZ3dWRHZ4d3ZpdXA5cWRxaGF4bGhRNHBRbXdkWEs4SG5CSlhaMExO?=
 =?utf-8?B?dCsyVUFGNTBweWhkUkN5aFovNTRYbS82M3V6SndUQ29GNHFRUzFPdmRJVE5I?=
 =?utf-8?B?K1JwY2Q0Y1FXcTJCaEVmZVNuUkVoT2FxaE16U1ZGQXFoYVVpcDlQMk9QUUdW?=
 =?utf-8?B?bi8yL21sTHhBSVNxZXI5aWJiNjF6WHpUNVJpd3FCaG8yS3hIb0FoOHRQSHV0?=
 =?utf-8?B?enN2OXpjTDZmQmhhbXpOK2hNelZ6U2dYbGl3dW40VHJFbnljcFBMemZtbnlT?=
 =?utf-8?B?ZCt0bTBkenh2SUtnODBLSGlNU0RGUHJSZ0c1cnp2RnNmUmdqTkdFdFIxRkNm?=
 =?utf-8?B?Yk03dlUvbFYzZ3RqQzUvczBLOTB5Y2RybW5uWTVHTDJZejF2NDVqZXJFd21U?=
 =?utf-8?B?WHRpL0FaNHhsVGdvblY3eXpnUzhhS2dSaVcwSHZkSEtaWXE0Rjk4a1ZORSsy?=
 =?utf-8?B?ai9RYWZSdDdOZmlwTi9mL0Vkdmh6eFcxWVNVNlNEdjR5UnFGWjFsM0N1ZXpm?=
 =?utf-8?B?czJUZkk2b2o4cEpCZ1h3ZVhWRFdCVVY5Uy9qalU3MWxvSUVrbXB3eTVGTGhD?=
 =?utf-8?B?b1N6b3VmV0hDa2NvSDg1UU1uMTJDcnhUenBEQnlrNFg5QVlWZWRhVmJiejFn?=
 =?utf-8?B?TzBIb3l0VjJhcDVQRW9acVduTGVUODFhRWlkZkhzRzRxSy8zeFcwcXdHbzEv?=
 =?utf-8?B?OUpha0FONXdaNFpnbW4xVFc1UFFReFlJc0R1NVVmOUdIcnp3VjZ5UFo0dTND?=
 =?utf-8?B?MlM0N2RoRVhmOStXOUg3Wi9kaUlKV1p5TW11NTE2ZzRaa1ljQ3N6S2x2Yytp?=
 =?utf-8?B?ZXNWc0pZSVZPWVh5V1JLR2FDSFV2NEI3amhSR1pHR0lhRlJoTGV4d1B6bEZp?=
 =?utf-8?B?NU9VamhDZ281eE85T2RNK3BUcmpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3818D394D88D1F4BBA8F6AA492A50D16@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: z7ERWrf7Do3c9UPjiVxaoDCmtOmS46c7Ngio8jgydHEvQO3iN8lgtpR4/+EUB9AbmWrYOqzcCweBCr/fIq4Wwtig31THptcmTR7ESO987Qx4wDBh3sqSUrLDPsJzVo7gN/QVswzEaa8V2EAM3ejpLoccraYcsy9dvWCDif8gEvsE/qrMexS7qlv00DUTD8CuJucuQVAyM+ks8nsBfonyDPTE+Pw5K0p7t9EGD2eZZjljjz0JPMiz61qt4qHMN8zz+QFdR2Fzf+WWU6FeRr7rxbPFlUi7hPzX5/RLZcdheAsVjTEVVRosxG6Lxv80rigo0X02NkBP6cFlEK4KenBwpALhbPairxVxcPp9wobUzPHxGlVVe5yNfmsnDOC4bY2x0NT+mcOi+HQRWcwW6oob+IhXECdYmvz94IhLF1akOSUaiVg0CsaiE8/ilwqJIg0OimW3Wx1JWaHdFU0aUt+SeK+SbyEYfzj8Q8ncMdYJ2grShn4SQrs+pilndhWmw04NUOC7tfvV4r6nar3jALmQVuQ1XOvONeE1AA0zcYuIae9sw52ldwG3Y03O4Il2syrMKRbCEGc2hYjx77CTS0jM8Me2zPZDnM9z0L+/+J0s7dQXIzYrkF5BFITnb6NjxUjjF16s0R2+HAxdz+37WJeD9O43wFQSaFYIxMqA04cYiHEbWkKI1dGVjssbI8cqvmklXrwvuUsIgndVxZN9NPuUvyvvMHofjPVx9OxryijuuyPyr3FJorQe1poYfXSwbyvbsCwhTQkcUmaILANBBse+3Kim0tqKV01H793JoOzd7wIL2RdnochPy1nBIjCGC3TdfknrZqEosTn5C8kfCnH87A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2650a7b3-305a-4937-15cf-08db5b6e7b9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:17:08.1084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+T4HzUpxDoCth5L7q0UEq8hN1FTV+tmE1tEtotbV3aoJpie+dHHWU6r9vBKlNqfIJ3xsOzSd6YXt2nin1OSu9yDnUdxDTlE887AKiYS4HI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7399
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
