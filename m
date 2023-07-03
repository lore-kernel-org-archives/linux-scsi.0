Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CF9EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 07:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjGCHX5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 03:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjGCHX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 03:23:56 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A72D1;
        Mon,  3 Jul 2023 00:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688369035; x=1719905035;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=nxYhPD/qHHIPQNl+FxvB86cCNRcqThFRqRRMXqVw1693MEbhTstGmIlY
   VSn6POJRLlVmO7I9AMGW91LV51MPX6DFrY+f7OMWZb6c2ss58LwOLzEuK
   CPe400zIzkp3HPpFvYOJ963sRH2pXAJEhh/tNd54gMe8EN59KUojCxNn9
   CAjZ1mdZ7AXW8+5CHa+fmbbwVCLlGFWgbEd+7ubb0SKWBIbJFItywSGwf
   J+yZXb97YsLrgeLAOEsdJuXDSqZt7YXIn1tPWdBoj7KyEanf6KMCaoxxL
   2+3rq81U5toEYPJ3UKkiOjOiI4HpntPDB7v+jWcB3J4F+QiVgtLhkVqHL
   w==;
X-IronPort-AV: E=Sophos;i="6.01,177,1684771200"; 
   d="scan'208";a="241745300"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 15:23:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFnp8aPHWZuxf9Dys+8cBSPJAeLlL+9rAjqYSupjCs6TVTIhnz5nPjYh6czdgt3GJO9KWI+PEKc/CL4L8A5bQ7L2up5fUl0hMOBBZk6BznY4niiHuY54AysRydQ3RVBf9AizKyFbCOpzjaX7QlpUmNuznNFFB1R+gP4tvgL6+ufdUR+Cw2aQEfOo47BMN1w3JHpmN34ujv8CpRlwzbfAgjMqFg50ani7VCvWw6iHwbVtmTneSFkaQEigLJcuErruwajWjXQMh8L7pbD1lVjXqzljGqZFS+PhxYN5JdjsdgK1uUc7zohG9ENeVX3Dgez6J8H3TP1qVxHUiaj1NEEQCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=iZ1cyfdPqTrasbfutt0ukwXWUER5f1ElC7HyDoDMGIyRSaLM85HaNDpUB6FlY1y5a667SzXEH1t29uqIgxGD5UOK3BkMIDPiN5AsBMSAGR3dih7uA5OySHY5M12OyBGwapHeGNGuLf2BmBgDh2bZMmfBYA1fGaRKGTCxFVYR+rT4ajOvMOw+RqLOdd0v+0i/lR9gLexy5TjTo7E55vtUmEJWqbk3Gqsn7TB34OnY4msIi7yhYOaS1IKEl6w3CtXRrGr34tm7Osx3BFRgVuuOTGOLqUxCUJzS7Xb34DFqEZ1mb691v/1u5IzE/UghUtTvEAQhdORqGvoMC+0qdFFOKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=f4EI1jFGD8hxURu5jtpYvk4ffKZzGr+N4kiqH4+Ns9xKtOsYTxrJLkMd0z2vLoUcLdhxcta+/lpaHsfQupr6V5Uj2G4rFGaJ0zh2u6GgM+RDwXwkNCR7u2BouUxPIfIGj1mFzOJPITSk6JvtOkvWVMsQes0HKdwKJtKLYHZbn1c=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB7019.namprd04.prod.outlook.com (2603:10b6:5:246::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 07:23:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%6]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 07:23:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/5] nvme: zns: Set zone limits before revalidating
 zones
Thread-Topic: [PATCH v3 2/5] nvme: zns: Set zone limits before revalidating
 zones
Thread-Index: AQHZrVja7D45pm+fu0+3WT6JZN/DaK+no/KA
Date:   Mon, 3 Jul 2023 07:23:53 +0000
Message-ID: <3bf087c1-269c-1a53-fffe-79eabba1bcce@wdc.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
 <20230703024812.76778-3-dlemoal@kernel.org>
In-Reply-To: <20230703024812.76778-3-dlemoal@kernel.org>
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
x-ms-office365-filtering-correlation-id: 35b3989f-abbf-44da-6aae-08db7b96748e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vIIijuWqzC/r1MYK+pzuDSA6mac+6CFSlK1/PP2lxbbP7znKQb20k53P8Sx6CD7JqSz2PNnWjVe0iexzDTF5FRdcDfo80TJHmyqD1+N2bLaBLZtkFhrAJnJ25ygir3g/gJcKowiOdcaFPn1xg1V4hCu0o/AWkjtWEMpHZCYVrWH8CFwZDX/BPzFIv69d+qe6PBOVWLNzCsDpueypufO5XmQLKDbUO0QDbSOUHQ3rLC0K7g1vb8wrj5hhoxF80jjt5Go4QyyeNtt7Ass4H/8jKfe7lIXhVf8CXGYsPLDprzi3l+HnZPsxQx1v1ht2cl1qRWHTxWZmNkIoVSeJwCxGG/fGSNesituFgn3hZeaSzLgqJ++WrFuP0XqkSk+iFuYI4b8oz+BUrzEioUV6YawIyGKr2sHQdzNqBqE/LllJWyb8wkZEHhTM1CafHGIzgKrdjmLw7FDAo31yuhiX0s3h8SdDV7QF2k+2BWMlccdA1l2NlPS/FRZxP1Gc2t0OANv57WfOiHNOTG0yE5iF0tE0sG/CfKaJT4bvF/OXOvj29XgIXvcjuXEGdGiLKNoz3CrPRcK5N6UoQlUYPUkiikVAy2hv9+LO6YdNU87teAiU9BidIZBB+5K/IU7T0Azqtp22tEZXifRoYkSdTMRc0Vw92UhwcODcL/OFIUcOrkvNbC/MPSuOgiBAKoghVQLyKLVm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(31686004)(82960400001)(478600001)(71200400001)(6512007)(6506007)(31696002)(86362001)(2616005)(186003)(4270600006)(38100700002)(64756008)(66446008)(66556008)(66946007)(66476007)(110136005)(91956017)(6486002)(76116006)(316002)(122000001)(5660300002)(8676002)(8936002)(38070700005)(19618925003)(41300700001)(2906002)(558084003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YThJUXpySGc0WEo5M3kvRnF4RTkya3pTZlBpcDFZNzBWb0tCTkV1S1ZqM3RK?=
 =?utf-8?B?UFJMYTVrbFRub20xdHNjdkQ0ZmsvKzlXV0Via25xMUFhcTBSRnRrV1VoVzI1?=
 =?utf-8?B?dVNGWWU2WXZ5QWtsR25YOFJQNmNvTmRzUkQ5WjlXR1VxQjFodHp1bERVcUpp?=
 =?utf-8?B?bFduY1FNNVhlYndreUhaUlNlblZ3cFNPL0ZyaHNMVDBSK1QxdG9vM1lCWFJk?=
 =?utf-8?B?TFpMejh4bytHdXBGZHZSaWtOV01PbXV0Y0xnZkpuTEtmWld5dzluejNXZU9I?=
 =?utf-8?B?MDR6UGNOV2VLclA3VUtsTHIyOGFZNTUxUzNSRmVJbWNrOHJSUUZpczJlSkEx?=
 =?utf-8?B?M01lYzdDaXJEaUFNRzhjOGc4elF5K0I0QTdnenNTdFZxQVdhNktsRXVDZGhy?=
 =?utf-8?B?VVhQNjRxOVF0WDk5cTNPYUlnbE1rQVYvcE54QkxFZXd0VTFLVjlCVTRjS1JI?=
 =?utf-8?B?emdOb1VaQm5hVlB1WDdiZlRiMUFXQzdjMEVmL1JpOUJLR0pTME5EUGFLYk5j?=
 =?utf-8?B?V3RGQ1pYamdEZFdKdWlnY2VFdUV2YlFYNlB3TE1ERGFNbWp4dFZTWmJuaDZU?=
 =?utf-8?B?eWk2RG11bVVYNmVoQzVYRDdQZHhPeGJMTEgvZDNZTE9qTWl2dW1kVXBUblNn?=
 =?utf-8?B?QnMwcUR0czRGdHdjVHpzT3luTWpLbm9POU54SzQ1eFgyRVZybkE1ZlU3blVL?=
 =?utf-8?B?NXh3VmNmUXQzWCs0UnhHVlFqU0RuR2dFTzR6OTZhMXRwY2FhMTFGTVdGSnBz?=
 =?utf-8?B?R1U3Q1NNZ0hlRTlNenZOQUszNEQvUGNrMGxpNms2TDVzWW8vZkorSFNpeUo0?=
 =?utf-8?B?QUtMbkdrVmh2QXQ0a2IzckZyTHV4WmE2WlZpa3l5bHN4dUExcGJaeDE1WG9L?=
 =?utf-8?B?Um5ZQ0pJWXhiZXNqZVBDMHYxZVZzTmJ5OXNEMTk1VGM0OHV2NGFTcEowNkhB?=
 =?utf-8?B?MzRsNFhMay9zc1NxOGdHUkNsZmdSVlBzVzAzNnVtMy9rKzZDd1RVMnN5Y3Zs?=
 =?utf-8?B?RzFlMnYzbU5MMmhBZ1V1b3dyTE4yYlV5bXhBRlEzZXllK05Gb3pkS0xETjRq?=
 =?utf-8?B?OXBjcStnaDlJWnZ0elN1NWVJVTdyb3VPNEU1dUdzRXdkUEU1VzF5djBIdC8v?=
 =?utf-8?B?Z0pabGpQV3RlN2RWRmU1Z2FjZVdiMHd6bGt1ZitNeDRVamJ4Z05ZRk9SdWVQ?=
 =?utf-8?B?K3FYQU8rS2crTzM3NitEM1dZY0VKTDhuaFJhZWVxeDhFbGU3TjhMSUxNK0R3?=
 =?utf-8?B?QVo3OEFEZnowdjNlUFBHTjh5cFhNOFUwOWw2R1l3eW83MGxmOERYNUd1NU8r?=
 =?utf-8?B?RCsvMkFibG9ZMTNucFA1UWlhT1dFZnZxZnkzZDRieFZWbWY2OG5TYW50anpY?=
 =?utf-8?B?T0txNjF0aFo4VDRheVRKbnBaR2F3cEc2cEl4QzY0K3oweStaRTB4RCt1Ulhm?=
 =?utf-8?B?NGFGbTA1dDhieVRJdEpTRm5nTjJMM0NjT09wQkFQUkRRQytqL1B4dStCT01D?=
 =?utf-8?B?cUZwZXgzbnJrdGVMR2xOcTVNSEo0QjAzOVNMVVUyK1hrT3BXUHRBUmFUUVB4?=
 =?utf-8?B?a3BDQlVsYURqemhuTW5RdXdJeEdXbDZiQTluQjFybWhraUJScW8xVmlHU1JX?=
 =?utf-8?B?WWJqZjZWUGYvNXZnbFZBNWNtdmpJbDlydklSa1lkM0wyNXk4NXpPZ2ZDK1VK?=
 =?utf-8?B?TmFKU1hIbk9KV2t3V0RMdWR4eGVVOUNIaWJuNVdNVG5IL1RRZ3dCS3A4cGF2?=
 =?utf-8?B?Wmp0TmZzMCtXM1l4Y01HM0diY0lLUmlUVUl2NnRSQ2hodVpCQ0pnTUsyc2FH?=
 =?utf-8?B?YXdBbjNBRDRLQ0poaWJ6UlpHbUdPajVVazhKRkhPQjlLaWtMbE9IMUpCTFly?=
 =?utf-8?B?QUlzVlNHYU5lRUo1RVpwa1VTblNGeW1wSUsxeGNNV25NWjJxT3ZnbXViZTcx?=
 =?utf-8?B?TVFLb0U1RERiQUZha2d6UnJGVktnSHBRaHd2L2xXTytOS2pKTk11UWFCaEJj?=
 =?utf-8?B?cWZOL2lRanhqZzVBclhFU1VZcE1kbk5QWDcyZUhOVStNai9HWktMdHJMNE1Z?=
 =?utf-8?B?cUE2NWdBSHhjODNiYy9nSVRlWlVWcnJhOEIyQURTOW1tZy9kdlhSb2pzdUww?=
 =?utf-8?B?eDhRU3l6bTZ0VlhsOFlMd1RNcXVNanAzcXI4ZmNLeGF5SDdPczRmUTlCaUtt?=
 =?utf-8?B?L1NiLzNwUVBPNkhjamFpM29xVWU2eUZiSlpMZW9wUnRySU9POW53aXRNWElQ?=
 =?utf-8?B?M0dNWHY5TnpSZElWR2tOMVlYMzNBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F860B87C298F448956F975EE7F84444@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?anNhRHFKSGRoMnZ1UDMzRkhzOHEyM0hUUFd6NTdlT0ZPNEliRWpVa3BNZGlz?=
 =?utf-8?B?eUJ6YUZLcWpqMjFIRmdyREhwNVRJb282Zm1IbWhJNFN6eFhMVEhnVjdtcnZq?=
 =?utf-8?B?cnk4TVhmdE44a0Q4bklKMUNvakxlOTJMeS9UVEhGTHdQbFpORkRFa1czVlNk?=
 =?utf-8?B?VTMvU2E5TkkyeEFPTmVCUXFLS3ZDQTIrRmdxZyt0RTRvc3plUk9uN1J2TThj?=
 =?utf-8?B?V29CaHVwTlQxSEdoUWsrL2RhV0REd2RyNUpUOXNRVEM3VXBSeHgvczdMcW92?=
 =?utf-8?B?cnBpMVR0QVJJbmZLcDVQOUM2WWhDbzBxYVpQUitCWE1xK1pVWlZPWnU4clFK?=
 =?utf-8?B?NzZRbkx6cjN6MzVHdndTOE4wMkU3VDM0L2g4eWVKWVhiRGJQQ1BWaTJ5emlX?=
 =?utf-8?B?Zms3N0JDOUEzaFJiL2ZyNzFqL1BLWVU1cXJvemtlaktlaVdwb3hwanp5Zy9h?=
 =?utf-8?B?Z0M5TnE5VVFLMllqTXpQQ2drTG5OdUlnVnc5b2k3RGhjelZVYkhtUUdrT3gv?=
 =?utf-8?B?cm1EN1RaaTdBa3l2WVkyN0NEbWo4cTEyVVM1TFBHRVlreFV0ZkU5ZHhROUhL?=
 =?utf-8?B?L0prZEZPUWtVV1pxUXJHTS9vZkNsbXpFYnphdTJOdXBDMTlHMEpkc1FnMjht?=
 =?utf-8?B?cGl3WHlrTE15RDNMTWdXVk0yRmprVHVSTXJCdGpObUxZK0thN2JSdG1nblJT?=
 =?utf-8?B?MUF1YTNUTVBKVVNpaEtvSzY3VWF1cGdlb0pRK2k3K1dFYXZmNCtNYm9SQUZR?=
 =?utf-8?B?RmdmY2tiaHhYZEFzN0VlemsxVzRPbHhOTThpV0N4M1ZrYy9HS09aQmk5c2dH?=
 =?utf-8?B?V0RoQUxSZnFTK2I3YVkvcHN1Sm9hWGo3K1MrN0lqNXhybldhRllzZFZMZnA5?=
 =?utf-8?B?akN3azNzWFg5U01kWGRkTEt3QUpuMHZUWnRhOXNia0ZJYTduNFFiZ25SYjY2?=
 =?utf-8?B?Mi9tZVhSVjQ4empLa3ZZTVBuRWdtRHdiWXVPR1FnODg2YkZXUU9sYXVuSEp2?=
 =?utf-8?B?OTZzdTdBNlZWNlFvRjNNY1pveTNuOW5hTVRiRU5LcmlPejNOYkxaeWkxS1Va?=
 =?utf-8?B?WkxpQUNINFlqWWZlbi95d0krMmova0liY2FmdERZU1FvT04wMDIwNFVXR053?=
 =?utf-8?B?M0t1MXV5L3dNK3dVcjYyL0hOU1pUaTRRc2NGR2dhcFRERmtQaGpqcjRXZWRu?=
 =?utf-8?B?RFlXTjQ1cTZzY1EzQi9MblVPdllYS3lNRktreFNtbDlGVEhzL0tTd3ZCQXlX?=
 =?utf-8?Q?91FyHfvTiDsAmw6?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35b3989f-abbf-44da-6aae-08db7b96748e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 07:23:53.3572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n5btQN0Dn+ddJMvZZM25ruoY/J/RN5xmNQNsf1PT81XIozFC7Si0sjakcYt4cHTytn78ovQW1BS4guIPi99rutZ325WyV3AfuYsPRhCI6cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
