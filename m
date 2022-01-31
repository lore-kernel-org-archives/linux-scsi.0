Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CD1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 09:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244400AbiAaJ6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 04:58:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40420 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242276AbiAaJ6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 04:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643623119; x=1675159119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=fphX6COqAs9L0pkWLsnNcdrLviDaHre9gfTCtv4aJCYCs9enNYcOnLec
   WGJtFsZkRqUrBQ8WRhNasSEC86+p7e7iq/eeNad7LKEd10SIZfeNp6CZk
   G8lF9F5QS3+i1V1X49OiNB5lft14xmfeMqDcG5Ph7LMAlIR8s7xRRoewM
   F6ZOHOipfjDCJoE2MSt2oA/wXUo9KoeZu/7yez95AmgPKKZxqvux7rg1c
   zVruk6i9MwbOoq2/4b+lSYr6j2LfQ4fxaQuVaoulGOBpne4WE7JXF0a5h
   91M+SYxt/je1Xd7Ssu0zrPjWop1VDks0ciR+knNoh9SdH/cY+zRUTD0ar
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="295875365"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 17:58:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYFGtsko7sJpe2fi24Y+OgupxV1N9EYvusl5deeR86DzFQVmy+e9i/K39yeHHJ0squoX9e9rdKkzCtSNoCYxupQOqTusWEZYatigiQV0SUR/19HwuMrnQ78Mt1ZTyhTxCTLvVloWFhy2TUhMuDjb48chH9joMiJQCupxdVQULIuvC4kv5CT+qItRGOhKYbFd2/3N+Rv+NBlyp0kZsaHix1o5TlfTQxwq1JS9cHjPctvnJ8mgrOZPPY7P+4u3O0qVA6xQYoTNCNXpvqOcUHcd+62RuzWi6J7HHCatbAtqm+0FA9LCKh6pxjFRv6pBJHSTzmcOf4UYQKMxS58048E+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=aFF3+qI/WVjjHwtbGFlmhtB5Sd5XdaxYHyDEfMe6uxl0ND1ruDz0Q+RSyHkDlv/hh7caHRTe/KzDciLg4Gz9z60yKQoR9golMSI8zEeLGzv5GjPzT99rm6yykmlKK37ZiqP0EON06UCOeYh4vRR43cTa1mbekw5ybDNmC7t/4F0ZhTH2KhdfsOHL8E+frSAc/ttK5eGcMho+UIFr2eLQ2vXxEp6JgHY6/cVSnZsUWP5C4mghN90SbJ57LBAInFrGmSxz0Yz1t84aoBGNVA++kShGEi+zvQYawlp/VSZ0aHj+MaAOgQe3Sw9ZailUlQTLCRoIRe1ilHDTF93StIkEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=RT0iTdOVKdqg2620mmfDxYlW58eNDb4GU2BgU7jQaA5V6hGrcUOEZz3b6r44KmAUJNqlrqJGZ+3GfzZCPBpKzQqmRmMD9/yDeKNJYVDUSSc1MherrYcbUof+u55pEkwkGtek0Zi5r7GbwljUN6rbyVIGrbr11FRPlPOiLM3ppjE=
Received: from SA0PR04MB7418.namprd04.prod.outlook.com (2603:10b6:806:e7::18)
 by DM6PR04MB4762.namprd04.prod.outlook.com (2603:10b6:5:1f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 09:58:37 +0000
Received: from SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340]) by SA0PR04MB7418.namprd04.prod.outlook.com
 ([fe80::8481:6d4c:ab5a:4340%7]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 09:58:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "hare@suse.com" <hare@suse.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "fthain@linux-m68k.org" <fthain@linux-m68k.org>,
        "schmitzmic@gmail.com" <schmitzmic@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@rainbow-software.org" <linux@rainbow-software.org>,
        "fthain@telegraphics.com.au" <fthain@telegraphics.com.au>
Subject: Re: [PATCH 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
Thread-Topic: [PATCH 04/44] NCR5380: Remove the NCR5380_CMD_SIZE macro
Thread-Index: AQHYFJVPiEHBjH0PGEioiF7KK8bFz6x86Q8A
Date:   Mon, 31 Jan 2022 09:58:37 +0000
Message-ID: <b2eff5b8e786ca1d3601d39e9cdf5d30e8397d32.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-5-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5eccb257-eb52-4ecf-9571-08d9e4a04039
x-ms-traffictypediagnostic: DM6PR04MB4762:EE_
x-microsoft-antispam-prvs: <DM6PR04MB4762E4FBD4F8DAC0F6DD49E89B259@DM6PR04MB4762.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qu8wG79x21ayZgMiOkp23WXEpIGYhdLwF50DtP22ud5MfcTfbtEJAyvpbJ9dlOM+Je2xbkBGUNZsJlNP0hDMz83hIa8HY1DXltldT2N8XdgxZLPc8soWqvh2J+k6oVw7oLKK3L/nCt/wMFLnkIrwsiNKWpl8ISDcG/kHB/EdMOsZ5oRQuyqVVQ4qiIhFG1uwnCQ6anDZ0t5rnDrvmzhj1FhlzlUE7OdbieEWHiuS5QJfWBrDLCldMTxkv1CMfByZXFt8FcL1F5yMTruo2OrmwB9seSXZgyRDLL/ZgHfw9UNu4feoormt4k4dGPgT3U1muYmwz7wpAwRImMHVejM2IfJ0SIMq/lCf/1L+S9+HceYvQrFHUMcnGeS98c+H3JXiQY7yFR9yFD+o6CYp7eAgLMz9cWj0T++SK2nB3xYiuiPVA1geecjAX4sh8CfH8ogzdFeuL3u9cfPziotwvEbXBbHef5Egl5mX/c4V9euoH25TwIrpqeVFq1NCRcWLcqxG5mlpeCBXL+5K5y+tXRw/UD2u4Vk/XInMrIa7zeIDUQ7lbzuZbxSpRXaDb3ViAYr2EbX1UL1gHO0NvtNbAMSkdGP4rNCQx4s0t/1+8blqRtdtyo/XPU09WHW5ulvfpla8N1NBcdI4qLTaB8rfmdNRvME47KFtQKkLjg35+nlSLuiKahGk/XdBB+Mq5mU58WsR02seGoNbHali925E7lzicA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7418.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(66946007)(76116006)(110136005)(66446008)(4326008)(5660300002)(91956017)(64756008)(8676002)(8936002)(54906003)(558084003)(38100700002)(316002)(38070700005)(26005)(2616005)(186003)(4270600006)(71200400001)(122000001)(2906002)(6506007)(6512007)(6486002)(508600001)(86362001)(19618925003)(7416002)(36756003)(82960400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2lrbVhXdkIveWI5ZmF6REl3WEJLTEFtd0pQTjJIMDY4dVkvQnhKVUtZWnBC?=
 =?utf-8?B?VnI4cTRZWHV6OHhiRXJBM3NURDY0ZytJYmx2QkkzdVkwZmdZa3RpZUJUVUJt?=
 =?utf-8?B?NWJYUEJ6WERuaVFXeHRiRmFjVXRxcEdpREVKajJWZFZHV21vTHR0Wm1nb2VM?=
 =?utf-8?B?aG1Pdnh4aUh3UWlCOEFQdGVCRFNqMFRyd3c5Qk9CRGJUZVp4SHdUUkdQa0pD?=
 =?utf-8?B?YUdIVUprRmh1S0J0MHVkWTNUejN3dUpKTCtpcEc2blhnQlZFdE9JNUZoY1Bp?=
 =?utf-8?B?WWNLU09sYjhXN0pjSUlyTlY3U0VhdUlRVWY3NFRYM1Z3bHpIYWRjZm1yZmZU?=
 =?utf-8?B?NEFHUWNxWEtObGdNQ0I0U2drMGlyTy9wbGlzRVIrWStmVjIxZWxZVVZKYjhD?=
 =?utf-8?B?bmRwVCtvQTNPTCtpVW43cmZ1cHZlTHFHWjJwWm5VTDJ0RUVHbWlmZWxNUm5C?=
 =?utf-8?B?N0gzM0RmQ0doMkdxOXJvb091NzRHSFVjV3pPVTFqbHJCdTNkbW9UN1o1Z0E0?=
 =?utf-8?B?TXJ1QkFHRjZ1Rkw5cW1BSHFBYUlYRlVGclRDbEZEQ2lPNkdvMnNFL2JDNkty?=
 =?utf-8?B?Zmc4eUVhVGV1REtESk50QnFFU0tTRFRhZ1huRDRiUk1BOTZPelM5Q2dGbEFW?=
 =?utf-8?B?cnpDQ0FhTk44eE84VDVZNnBxQ1F3MmxSOTJhbjgxQnB1dEtxQWhnWW4rbnho?=
 =?utf-8?B?M2RCYzJuNndTYWtTVkhzUnRYalVXL0RpT0lmTFRHMFo1S2s3SGxnb1pmcGI4?=
 =?utf-8?B?eXh2VFo0N3lNVTIydVBwMzQzNGVMTWRLWG1nam1BczdPdlRTekdybW5LeHpQ?=
 =?utf-8?B?aTRaYnV5d25JT0dwYXZXbUZ6UXgzZjhPeE92OUV5YnVtUEsvanRsVFpHczdQ?=
 =?utf-8?B?RHRBaHV5Uy9yYjNGSFUxYUFDUHM4Ly85VnRoWGFoamYrZVloSkNCQnJuZ3Ix?=
 =?utf-8?B?VXVGU2dFVFR4RVJLQ282S1JzMmNSMDEzWkVnUHZlUnRGcExhR3FxZEQ1aTdw?=
 =?utf-8?B?UzBFVUlIb3k2OUdqS1psY0RraTRtWGpaVU1CWVZjY0FEdVVtUVY1OWNLdU52?=
 =?utf-8?B?NUo4K2VvclRmaFMwSVhreEdMbld6aFh5MVNMdkpLbDNMQVZJaHkyQnZYMEdr?=
 =?utf-8?B?VFJtTzRaYWVhaThxWXpUWHJXaXJyeDUrUnAxNXVBczMvYlp3UFdDNXc5Z2J1?=
 =?utf-8?B?Rlg2QS8xVkZ2T29UN1VtZ080VVRNNVZYOFoxbzFBakFzOWZLdFJ0eUVocWRl?=
 =?utf-8?B?SGpnZnRHRVYyNmRkekh4bWM3ci9abWNzSld4TlYwUFZ0eVFuL05jTUM2Tmgr?=
 =?utf-8?B?bUxrQWQxZEp4RnRFTmdWWW1BTDUxUkFzeUtjai96WjNrT2xyUC90Q1VBUHg1?=
 =?utf-8?B?Rlc3NDNsa0kwbXlJMUdQaHNneWlzNm5WM25JcjQvenJkUEFNQndFcUFGM2Vz?=
 =?utf-8?B?V2JXRTlFOStpVGpDNnhTeVBiVjhQV2g3cmxhUkNGMXdxbDNyZlV1YWRMc0VB?=
 =?utf-8?B?bXFaWDlJcjluZTc4NC9SdWxyb1JuWmtNOFVHQWNwcTM1UENlQW9EMUVQK2FR?=
 =?utf-8?B?eXFuVXh1RXk4aFNPNURWa1VUbWlLbUszZ0k2UHRqKzUzMHo0dk1obmFEK25s?=
 =?utf-8?B?MDlaMi9LSTFXY3ZUTmx4ckpla3NXUmIxb1pPU2dVVFV2alcxbU5DTk1sMHhE?=
 =?utf-8?B?cE9DaHRSdVpsQWxkR3hkeEFuSDQ2Uk5VVHJTK2d6bU9yKzN5U1lTOUNWc0hp?=
 =?utf-8?B?RDFiNXR0M2l0V2RJQTlzeTdtZUxRYmtJUCtDK3p6MmZlakRkUy9XcXNZdWVR?=
 =?utf-8?B?S1kyVHp3emJzTXprQWVmajFNSnJOWmtmSTFtbThUWDF2KyswSXpxRGQ3VWxj?=
 =?utf-8?B?b08xRG1vK1EreG1TbG52cHpicm0yU0hoNUw0SUxaNVRMRlRPMGdwM1Z2YWlG?=
 =?utf-8?B?UDdncldFWmJYTFhLZ0tkRzhxdXRsdFQrbG9XTG96VlpXZXBvU2I1ZWYyMERh?=
 =?utf-8?B?ZlVNT2d0NVh4azVvZmRJWkJJblh3MUVZSzg2d3lveUt1aEdReGgvS2s1MmNI?=
 =?utf-8?B?TTdLd1VmZC9XWkx4VVNmcE1iaDVYeU1KYnRIT1kwdkppZzZyYmIzQlVmUmYw?=
 =?utf-8?B?b0piNlZFQ2hpV0Ewd2w4OGN1dTZza2dhamJTTnJiUWY3Ukx3VGQ0bmRSQWRG?=
 =?utf-8?B?ajhwVW41SjRoMnRVVHZkanBDY0ZMZlBHVUR5MmRsZG1ZRkNWU3pwazFEbERn?=
 =?utf-8?Q?qfEwiP936iFjGPgAZLG+ekYRlwddaQXR5WdDiNxzBU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ABECD2DCF1EEB4E97720A10878A8D99@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7418.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eccb257-eb52-4ecf-9571-08d9e4a04039
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 09:58:37.1645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WolLgG7KVw1A3fM65K3dtb3snFuOV+eWunYpmq7C/4ecTDje/SAmcNKzT58eiIJe3igGfwd2UQUjvXmZGWY57VPRDgeXokKYNNs2Mgzf12c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4762
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
