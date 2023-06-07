Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29439C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 17:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjFGRgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjFGRgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 13:36:53 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974AF18F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686159411; x=1717695411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o8toetBXAZ/oOljDBCkIbpb9Sm8+6RRi3nGp7ECOWpc=;
  b=Ex4H6AooIwkpsB7pNLgjvqTfY/5v7muXXqz9yKd7bNLfizB6Frw1ZBFx
   bUpdGVleMPS81sO5RVFyB71daUuhC+evSS05aMkrtDWXvqmzDTjuuziOs
   gSfH51r3x4eqzYETJ5n6Qfl2wLmpSf0Sccs8A8RhfKTu1x0vE+zVWiQSp
   xODundqgSVVgeKsVaORvlQ8BUBnaGEP6KEZSBKwz5aSY/ujUEi+UGKmp4
   cagSpt7h5CxAllVYxkzQ+nSifdHNcncLwmTa/zPRKIrOxIyKLpM6Xi+nG
   I2tOosg9VTfCjM4lCqUlpabuE+Ehr00bOhs8NNpoA8DtGSN5kCBC7JAsT
   A==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="337566878"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 01:36:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M43mYkxrpk8vN4Htz1hHP61lfG0tkj9zpZJm6TCiptCa3/CIuaQnN8ADgaYdk9WzKVYCgXm4k9hISE0NuPf0CR5kn0Ob+dFUkERwsVKAGF+xMWUDZ/xRR0CyN8zzfhDt78ebuibVShi/SMvuTFseqDawqcpjj7V+NQ3fdNPilgPtOgQdGFkwlCA7CTS5wUY01Hx1fv44swK0vnmK/ZEVctWy/Nn6sVEnZspTIMbdJe4wydCScFJMXX9OMp/px8p8RlRMcaLzYK269PU6mJVLOfbZIMLfC1xVH1lAlmy7p2p7mJFTqqqQ/tgyseFIPSyNU8lX59yW4SlLsA/oIHPXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8toetBXAZ/oOljDBCkIbpb9Sm8+6RRi3nGp7ECOWpc=;
 b=NmnRw3mxMD01Iv8UOfhF6Q4maE/SjBEZRB9GK8/OmveEtL6v78Sr8nXolF+rZdo8N8Hlh72DmuTZELP9+nfFEK3DEhhyzM/lU2nEKA3QcLA/N0hy9Fs8RdQCusIV4sqTU+gcu8tkuvW8G0t6siwK9cWJO2yc+5xQ5Fuwa2IwTmiRjgKS7nBknjTz3qkR/xJ1HV3yHK8kRgLeJCHk5Y1dSfILDgQm4U8dpflvFFBOcCRFl6GaOpCKTRh140uJyoNYbjFF7Gj6aVBF5TmHyY6S/9btLY3RK8SVnG2Op+enKtVSZMb6tBRF3kgEbboLYfMFrnrP3Zh1aQ47Xao4d4VH4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8toetBXAZ/oOljDBCkIbpb9Sm8+6RRi3nGp7ECOWpc=;
 b=0Ms6OwzAKKBC09fmJ9mH6uJU0zTDnXKfX7YwTNGUyjw+xexgoQksZmqVylJltWRSB+wZ6bfcm8ZQHP1WofnfX/N3Jf1lAGZP0Cwy51GURweZS9+N0cqEV8QuOqPpR9SfXBjH/GVMUnCx07fvkTm0tgH+U8+ubBOAq0VhMjVhtGQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6333.namprd04.prod.outlook.com (2603:10b6:208:1a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Wed, 7 Jun
 2023 17:36:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ede1:ce1f:d515:7650]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ede1:ce1f:d515:7650%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 17:36:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: RE: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
Thread-Topic: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
Thread-Index: AQHZmWQocYD4PurmbEGYgc2nVuT0K69/mlDQ
Date:   Wed, 7 Jun 2023 17:36:46 +0000
Message-ID: <DM6PR04MB657529D4E0907200617211A9FC53A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230531224050.25554-1-bvanassche@acm.org>
 <85b7a110-542d-d1d4-ce5f-59114c0e85b7@acm.org>
In-Reply-To: <85b7a110-542d-d1d4-ce5f-59114c0e85b7@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6333:EE_
x-ms-office365-filtering-correlation-id: 4b0de534-8a30-4ca1-85d9-08db677dc428
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jvmb7HeJleJuGzoYMUZhmPrSIVVwkep9i9EL6ARGvAoaPFVa1MPPPZ9KvuK6LOu7Vvhtog/Ia4oGw3sacF3moVPVrZixKv++c49yt5ezhz75TKcN/4PHlyPtOdi3/xhDhnIMkcfhzbgwcORd4WaJZ4qNMnVvJYwL97pIF8B8H0hQiz4dIAB0CCK40Yl6D0wm6PX/67D/lzmVBITFrADd76m7qqi8vEbIwNrzQ0ASsDHwAxgcJe/2R8qMO/oRYK4ZC4qFl2ROw68cIvnDGPQUMnFQ8br1ys7J98xmYgFVcM1FngfQQ8BgQuUnjBVwixrsl0UdBCdCzF+HUlFXDUIpW6E1P9GTbDxyy8l6DOYWSyk0azMBcP+aTHSK0N1xx0BUrmyJcO8wtIV8QAlHb+keOmVLxv7dnEaOsfOcJsBmXHh7iBcifBogOIYOYexQkkh/R42EdyJkNsf/2cWV+R2MlSo0BDeer8BNceBzu9cTIZOpAjDg/u/o0eW3DnMUwqJrYYDuFKAHkyZtiTyi+dwmTDzTkrqrcdw0c+HIY+pYeXCwLmZ13eWlUQMknTGrMEZvivZ38OEbVeiRSuKtUophAmJPu3WOGu/iPcG72sojEqnyZee0qb5xH8ENA8OpStlp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(71200400001)(7696005)(4744005)(82960400001)(2906002)(76116006)(66946007)(66476007)(66556008)(66446008)(64756008)(122000001)(54906003)(110136005)(38100700002)(38070700005)(52536014)(5660300002)(7416002)(8936002)(86362001)(8676002)(41300700001)(4326008)(316002)(33656002)(55016003)(478600001)(53546011)(26005)(9686003)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGFIRVllaU8rdlNHNmZpNkdXc0xkbWdzcFUwLzJpL1ZGYVNPcEJNWXc3bUdO?=
 =?utf-8?B?VzhkQTB3OEUvNzczMXNKKyt1V1d4NnhlbTk2Szc4NVRRVnVSbjlGQnBUb1R3?=
 =?utf-8?B?YmpVT00wdUhkaU9DVVF1Wmo1STNmSVVZWHVmMjNwaE1DMWFYc2FxRk11dG04?=
 =?utf-8?B?OWNXY01WcGxOVkpabjFCSnhRbXRRMzZta0Z5QXl5Y3dIS0N0amdBaktTVWpM?=
 =?utf-8?B?RW0zOGtmaXJMbXRBZElDc2poUVl6a0ovN1J4dXE2WEhpaVJlYVZyRUlTVFFV?=
 =?utf-8?B?SFdWeVdDN3RvRFpUSTNKaXVBdzQyazloQ25VUWJLUDNXMGhidks1UWlyL3h6?=
 =?utf-8?B?cGJhSFV4L28vK0YxSms0SHg2MTllNk5WUE1BZmpDU2pPNDVQUEN6TUM1ZXd3?=
 =?utf-8?B?bFNqSUxaQUtOMnFYU2VNRlNqcVN2ZW9hU3YzZ2NUYTU3cHNneHZSRDB4VDdT?=
 =?utf-8?B?TTIwQk5jRGNiSEl4OWhUNTFiUGQyQnk2SzcxZGUyekhEZXlDV1JNMGxMa1Jy?=
 =?utf-8?B?SGJHT3dnVW5vRnkza245bERTcHNZZ1ptbU9KMFU2R2ZoS0pzL0xZcVFVTEJU?=
 =?utf-8?B?cklTcm9UR1Uydi9jM3VrM0d2bEhtbnZKK05VNmtITERRTHZwcWtBMlAyZlFi?=
 =?utf-8?B?WEQvcCtUcWNJb0VtV0M3ZGt2ZzdtOU16MHFwc2ZxWDdXL2g3dFh3UTFGclBD?=
 =?utf-8?B?RzFpekhvSUg4ak05dEVpblpJVDZhdy9teDlWL3ptVXlJcjM1RlR5OGhSZk9Y?=
 =?utf-8?B?ckdXNDJCNS9LTlNsMzdkM2xmbmhvVEdaOEVLUVArejJ0enAxVWxGY2R6TTJF?=
 =?utf-8?B?Q3J5aXpzS29BSWVGd0wvZVZudWJvdHVnNUVnZ3ZGSjNqbU1ab2RKb1dhLzI5?=
 =?utf-8?B?Mm1HR3ZrNnUvNmMrZExqWlpwTmZXT1JWMWIxeHVtRmU3T3VsSFdHQ1RHYVh0?=
 =?utf-8?B?b0l6Q3NyUTlQWm01bDludkRNZ3ZrVmFBdHpGODR3WWlZdUxXRXdtYkhnbnll?=
 =?utf-8?B?ckpERThLdE1EdEwvQUZldHdIMFMvQ0MrVEpnZ00wSHFXelBTMEVPdzlXejBL?=
 =?utf-8?B?K0hTWXlvdEhMWlIxczNXNXZUN05hK1JZTUNwbkFqRTdvdkxzR2paSzdGZG1p?=
 =?utf-8?B?WkpTazVzVkhzbk9XMzdsZnk2aTJVVGplV2lSeTBNRmE2dnB3a3o2TEYyS0JP?=
 =?utf-8?B?a3NXYzBSRkRmWXdram9yaXhVWU5vZXVPcjBSWVpXSHcrWVMvSG90aGt5TmI5?=
 =?utf-8?B?aUltZGtIcTNkR2FHOEZCY3NLRVNFNnVuRlNqQVFoRjVBYmxEZS8wN05EaVNE?=
 =?utf-8?B?M1BTRVgvMDJuM2ZYeXJja1VhTW5GSW9ieGZyUzdsaGxJU1dkNXM3QkNSL2Zp?=
 =?utf-8?B?UU9meFRQM0RpbHpHY1k1d3hzNlRGMy9IVHU3ZjdsSUhWY1NvdCsveEFvTFgw?=
 =?utf-8?B?eFd3M3Q3a05JTjF6WGViNE0zK1Zyci9vaEwwZDRLbURMU21xTXpRZGpPMzYr?=
 =?utf-8?B?Y3phUWF4UlRnQ1RTZG5abEd5TzdmM3ZnT1lyc0RELzU2VmtvbGduZmxJNW5m?=
 =?utf-8?B?TDIwdXVBZXNyOE9QejB4bHlIKzdhZWpUV1lUYXFvRzZrTHRrVng5c1htbTFZ?=
 =?utf-8?B?a2xoZGg2dnlJbkNpTEswbkdBK3M0a0hRQXhPWG4wT1JLTWpob0x6dHhvd3dN?=
 =?utf-8?B?aUpkbEk3OHZBUXhsRmQ0WVNyeXZMOUNoWVhjZGptZXZuV2JuZldub1B2WmdI?=
 =?utf-8?B?ZkNzazQ4VmoxbVRwOWpCeDk2dHlaS245WUltZE44cG83MXoxOWl1Z0pTczdM?=
 =?utf-8?B?N2lSMUVHZ002R1lUa1RJSUwrT282SDhDSHMrOE1UWkJTNUl6V2ZBMkFyeHMy?=
 =?utf-8?B?YW5zcXZFRnlnbFRhVkFYUTk2Mm0zdlRidTlMNGtCdFlWQms2dHM4TXNUWG5y?=
 =?utf-8?B?cFIzcXdGVUhwWXFMY3g1dkwyaUd2MUEvVXVIWmg0Z0IrY1FGM2RhS1FLcmVn?=
 =?utf-8?B?TWp6WVJKZHNQWHJJenhCaGswSVhCNnVFK2lBV0JXSU5HdTd4MlA4OXNTRURJ?=
 =?utf-8?B?NlltRkMzSFpxS1NNVUJMUFNxMytSbXlnV3ptemxWb3duQVFvVTRTMDNWdVp0?=
 =?utf-8?Q?nJ3qT7e/8sWzZgOo4nhLpjn5a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MWlYYUhtRlJJN255ZG9IbkxBR0Z3VE9yTU1adG1xRVF4ZW1NWnZndU95SU1D?=
 =?utf-8?B?VUtqdUJyNWowRjhlWHhGRVhuN1kvTFFuN1YzaWo3UWc0dzl0NzlMWVdIUzhn?=
 =?utf-8?B?dlpaMkprRnFFaVFOQURJSFIxK0dhL3YvNmJZYjNoNmlRRWpuU3NjcWtZQ3Q1?=
 =?utf-8?B?Tms1V0dsclpqODRHREZ4TThXTG5RdWtGWlR4cGF1SmttNTNubFY2MDdwTzF0?=
 =?utf-8?B?SlhpdXJ0cWxIQ3E0V3ZwZDRjd1ZoQ2RjbEFRc3B1MjJtVFV0bWtYSHdYSUZh?=
 =?utf-8?B?aktEd1hlK0MvUTVqNk5yUndqZUJSSVNocEpWcUY4WUtsUXhkRFhvWGxmYVJF?=
 =?utf-8?B?RnVYZ1pUZURybVpQU0FvUXVpVUNITHJPVDdaUCszczFCTXJhSVhqblpCTVph?=
 =?utf-8?B?cjFhSUQrbVI1bHRVQnZveGI5Smdpa1FqT2E5WXg4dk54blRLY1lZV1BpWU43?=
 =?utf-8?B?aHJWRHJtc3cxUE9Jend4dkVEV080bGlBcm1wRHVjMXlVZ0hNcTBqbEtLWTBI?=
 =?utf-8?B?bVBpZGZacitObm1pa1F5WGU0dE5xTmRHejRZd0wwVFowMzRCb25oeUhCRmdN?=
 =?utf-8?B?MzBSSjJVMndDUWNwT1RKUjV0cTF1KzlXUnU3aDdXL3F3WFR2UXhQeFFWYUJx?=
 =?utf-8?B?ODZ5MTlZUnZVTHh5RjhpdUswTFhJMlpyZllPbFlLVmtMZC9ubjFoWnFTWGw1?=
 =?utf-8?B?TTdQNUMxTEZkQVRhYkczWlJTN1Y1UDVaLy9iYktqYTNtOEdGVkV3ckdOMElQ?=
 =?utf-8?B?U3NvUU12NzVXUkpxTkxmOXdDczJucllnTFIreTc4QzduK3dlM0YwRUcxRE4z?=
 =?utf-8?B?eEFhZndERG5YZkUxbXpIVVBHb1k1STN2TTdVRFM5bFRIY3AwUkpmbDFWdFhz?=
 =?utf-8?B?L3RKWkxFSGNud0NRYlB0eThhZ1VKZERNTHZLTFc2RTE3WFZZUERFam00L050?=
 =?utf-8?B?OGl5OWZQZmw1cDlKK1VLMkdHbEUzOHd2K2w0dkRWeWE4Y1pqczJIcUh2NVQx?=
 =?utf-8?B?cGl4aXcyeU9PR2ZONEVvak9tN2RzZjgzQUxrV1dNQ0R6ZUhoN1pUeVNtdWhM?=
 =?utf-8?B?bzJLeVpRMlgwNHgxMjRmUEl0Vno2WDlkRWFVOFVZT0kzRVcyR2Uzd3EwVmJj?=
 =?utf-8?B?blZUMG9nRklDMnpEUHlpcGp3ZUw5RE1WTTBLejM4MGU2TFpaYmZwN2FNVVNJ?=
 =?utf-8?B?NFFwZGF5VkJLNWdRREdEbmJ2VlhRcjJIaW4vS0RSU09RTVlUd3VSelU2N0RU?=
 =?utf-8?B?cmoxdTZJa3pqTXo3djdrMnF0RDdzRUZqRDdjRXdUZDFpcVlJT2tCMkk4Njcy?=
 =?utf-8?B?QXI4QkVWeHJPSmlrNWJTK1Ixc1J3SmVEd1hOUkFIaVRiR2dSRTA1NXUzQjU1?=
 =?utf-8?Q?VOY29Dj7CWuVbrWsOXdeTZq3/1MLtXtw=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0de534-8a30-4ca1-85d9-08db677dc428
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 17:36:46.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GUv0QVi7yMF9fARHRpuIVelUCBUQN9hQSRLI0wn12bS/C0JPEhCOCowuGA+/f9zWqbZP4byN6TF7qr/QwM3wjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6333
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiA1LzMxLzIzIDE1OjQwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gdWZzaGNk
X2FkZF9jb21tYW5kX3RyYWNlKCkgdHJhY2VzIFNDU0kgY29tbWFuZHMuIFJlbW92ZSBhDQo+ID4g
dWZzaGNkX2FkZF9jb21tYW5kX3RyYWNlKCkgY2FsbCBmcm9tIGEgY29kZSBwYXRoIHRoYXQgaXMg
bm90IHJlbGF0ZWQgdG8NCj4gPiBTQ1NJIGNvbW1hbmRzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQpSZXZpZXdlZC1ieTogQXZy
aSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQoNCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMgfCAxIC0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9u
KC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCAwODU2ZjAxYjc2MWQuLjFmN2E0ZWMy
MTFmZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysr
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC01NDAwLDcgKzU0MDAsNiBAQCB2
b2lkIHVmc2hjZF9jb21wbF9vbmVfY3FlKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IGludCB0YXNr
X3RhZywNCj4gPiAgICAgICAgICAgICAgICAgIGxyYnAtPmNvbW1hbmRfdHlwZSA9PSBVVFBfQ01E
X1RZUEVfVUZTX1NUT1JBR0UpIHsNCj4gPiAgICAgICAgICAgICAgIGlmIChoYmEtPmRldl9jbWQu
Y29tcGxldGUpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgaGJhLT5kZXZfY21kLmNxZSA9
IGNxZTsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgdWZzaGNkX2FkZF9jb21tYW5kX3RyYWNl
KGhiYSwgdGFza190YWcsIFVGU19ERVZfQ09NUCk7DQo+ID4gICAgICAgICAgICAgICAgICAgICAg
IGNvbXBsZXRlKGhiYS0+ZGV2X2NtZC5jb21wbGV0ZSk7DQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgIHVmc2hjZF9jbGtfc2NhbGluZ191cGRhdGVfYnVzeShoYmEpOw0KPiA+ICAgICAgICAgICAg
ICAgfQ0KPiANCj4gQ2FuIGFueW9uZSBwbGVhc2UgaGVscCB3aXRoIHJldmlld2luZyB0aGlzIHBh
dGNoPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
