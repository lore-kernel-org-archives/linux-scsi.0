Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CEEC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 09:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiK1JCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 04:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiK1JCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 04:02:45 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF52D101C
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 01:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669626163; x=1701162163;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UhKkddgpSq3HYQIj9FSP65LJahdc/MS6DGvcc42BpJc=;
  b=Xx5X9vdz58JIrUvFdpQhligkLmf52HlyKUC/TirZr+ChSINlrLDVwJ9V
   ZJhF7UQdFuRFPtqAJ2DR4mpgdV6E3eXT3hIjG8InMhY6JXo+OGRgsORor
   xwxAxkx/ZgzNhX9VynZ/6gUKuSbZjJu2TVAfNvd4yz6phK8enrtdiF4m1
   VoElOpueC6vUkJF8gMJ0h3ZlYBe5KmbOTzelRne8NtHSHNvC+T+RzKsHx
   cuIyc6B3AdTtF7YzVJWJRGlPpdzJUqiXd6BmmFOBMZ/0SuFcR6QW18rml
   x8zmJ+rtKILGwhuzMduRkwDlQaqRVoCcMP0HFW3dQAPq9XNoYgrCsEtwO
   g==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665417600"; 
   d="scan'208";a="329435477"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 28 Nov 2022 17:02:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZX+l7lxM2DGxrBtveRf1Sa/fQL7hQmBxKJ5Lxn8DNwYmajEF6JoEUbhwh+bjdoud64ib4uPrj9wNrFtOil8tXGraWyBe2g5qV6bAjiGCTXHpJXDKNPvznQQUAJFqQxm4wde6JbkkN7glQaOtRp26/Ow6zK0Saz6w+Fr0ErukU+L9OHZLGvuqxeQ59iHNazGjsFhMTMgv/AuXD2iTyAYq48e9L5B+MOUWcC9cbPt9FWBf1V9L4QObrYaI30i9h7Pa0SfbSNaFVwfXqE4t6MGZa5bVJq8HBg439XmeHlZGQhRFWRUZ0c3lzowTtU+mC2iM4K3E/gSF9NK+KDsow3VI3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhKkddgpSq3HYQIj9FSP65LJahdc/MS6DGvcc42BpJc=;
 b=QLwdb9SN51xrBX70J6qIipaaH33RycPNfVOGaAk20N+ovIMVJgIACurPdjdMFGmheEU1rCrlVOgdVr2aiEZDrqTs5de8E5MKteNcw3eaJitC+l9on2cqRdlzON+YZGmgC7NwoBamgJAD4QWKBNEgYxUxWs0yTxWsSbQyhtobak2DCbin68FJSA31xtMcCkCQc2/EG/uRWfgVnKEKHP+YND16MGjludhZhBJS2xMIwlNuCzioNZevfkzm21n+uqxxOPRoB77mBPqUV8uEycOexbXKHtNlwD9efiXpmY6yhZ+ExsmJhWmfKpOAMAwQgHV0WvuKFJ1Tyojrs0bb5ZKh3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhKkddgpSq3HYQIj9FSP65LJahdc/MS6DGvcc42BpJc=;
 b=qta3KyIenw6TxcTpfFXwqf+5eM9YAry5RksIPKZw3EHZTc5szAUTHxcJuX5sycDlbF+yuXP8P3QtzOGrd0yQlZkKQ2eKzYoHSet1U1MneXQ18gcaM0TKvyABflkP3cLg2g1C1v7d7jI3UXb06f3QQf4cT+/hgctG6QZrGdNjTMg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6304.namprd04.prod.outlook.com (2603:10b6:208:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:02:40 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::f4cd:7c80:5642:bf1a%7]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 09:02:39 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     kernel test robot <lkp@intel.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHY+CDXCOC0I4eZpUuWZjylU2pizK4/dVyAgATqrICADCqsdYAABJMAgAOOdACAAAJYgA==
Date:   Mon, 28 Nov 2022 09:02:39 +0000
Message-ID: <6fa7aadc-6881-5246-09bb-6f796e03f287@wdc.com>
References: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
 <202211151344.VGP4HoGU-lkp@intel.com>
 <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com>
 <yq1h6ymo3wp.fsf@ca-mkp.ca.oracle.com>
 <969cf476-d732-9566-63e4-01fb23fa74fe@opensource.wdc.com>
 <185d6f59-fd60-1332-29fc-456b9606e77c@wdc.com>
In-Reply-To: <185d6f59-fd60-1332-29fc-456b9606e77c@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MN2PR04MB6304:EE_
x-ms-office365-filtering-correlation-id: c6758419-6778-4b7a-614c-08dad11f4d66
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hibUpeFjn6R0yax1sDprsxWFeleB+9on+0XEOAcUgufvh4LEWmfQ2o2o52exN50kijKCWGFWT4xs91wG2fYvrm9fRcu/6vTZ/pMl1Ohjm3fjDtp1U2GaBBl1e7rzD9SgAc7kkpH7d3poe8mpRilo6cBYFWOmWXwH9/POPAgLk1soByfXSvkVUg5XgGpJjUyq6m7okenZBVysAGDqwG84hYNFsRREw9PbddbwcsMFO776CcgEcPgEVHXhGa1GeMkZmsWs8VW8H4kGD+z+99XSUPNDH+YEcPKBhUWdUJqUeH+xbMP0jN7XviFoXKbWTyw5k9v2PUXcjSlMqLflQUJGCDSIb8MrkNGC1U174+BAUHUzG5Cx4evRLAEUNNalDVGhGlbTRx5T1s6U2oTQnmAMnt99eWKaiF8QuC+M6TdzgWulbLK8l2RBCqpgDhNjjgSqJbYV6/PqMJR9rCCe1lAWDbJByhs+wwbxCP4gzqjeTyQ/kFwaa8gEY8vXW/r5t31a8t1/fm4Nh3TgJV8ezriyeATiKEd5QgttsDmqlVTU1L8FumB/t6FS52Ttx0JAhv0PtVz5bJ6JCkM2rzdWJmyPDDPQ7UjvSwYDGIv4p0+Wtz+EGhe/yCgoY9qU503HbsKT+3/dSbB6cjGdCHh/wpbiNlpol328CrbqT8gr8FNMYS+G8qrRmxr3MnQcegTkrfASxJLYaL7+nEsQIYKM9zinRA9iWgh8tBAkZ0X0UrNppyuh/9n/aX1mES1w2njcv4tlf3ubERD8y6SY+AsioQqZhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(71200400001)(316002)(110136005)(54906003)(8676002)(4326008)(8936002)(64756008)(76116006)(41300700001)(36756003)(66476007)(91956017)(66446008)(5660300002)(66946007)(66556008)(38100700002)(82960400001)(38070700005)(122000001)(6486002)(478600001)(86362001)(6512007)(6506007)(186003)(53546011)(2616005)(31696002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE5KV1JPL01ROS8zTHJkaTBUSW1YdFN2Wk04bDJLRVJleWFKZXNwL0t1Ully?=
 =?utf-8?B?QzI0MkR1VXBsQjFvcFZialhvK0RWY0gvMS9UZjVSYi9VcHZ0WkZqUWttb0VJ?=
 =?utf-8?B?V0EzVmw3a3E1Sy9lQ005cVZKOGllQmthWGIycjJwUFgyZWNiaEpWVWE0eTRm?=
 =?utf-8?B?azRhYW1wODRXS2RpSEZxbUtoU3dyL1o4TFFSRWtqYmM3dERwTlZ0MlBHQUJT?=
 =?utf-8?B?UGx6dnBpaEZRQ1Q3UnFqbElDMlg5UFkyaXhWa0Y3VnhTY1hYY21oVkUwZThI?=
 =?utf-8?B?NkpuNXpJWXJ6WWtNeEJSU1Bac0d5ZmV0cUJZaEE1WHphZ0dYUDZ5TjNTek9T?=
 =?utf-8?B?Tk1yQWdTVE5tQmVPMERhdHFzTjMzK0JGaXdPaUZDTkdCMFl1MTZPaFNld0k5?=
 =?utf-8?B?NElPbWlNd0NJRlkydE13MWxCWmNoU2FheGdsaERraHlXWkx1S3p6ZVFtZzhL?=
 =?utf-8?B?eTQwZ2RLVnBWcTFuWktpUEYwTWttcCtSNWl0Rlk1Mm14VE00WEI5TWVoNHlZ?=
 =?utf-8?B?UWlJTGZCbGU4c0hnT1FUZnh2WmlxQ1hNT0dVUEJidlFLdmZiQThMNWg2MzUr?=
 =?utf-8?B?WmdRMGxvUkp5alQ0czNlaFhKT2ZjVTVsWlY3cTVyL1QvdE9iZHlUbTBnUXdt?=
 =?utf-8?B?Qjl3S212Vll4dDdsWVYrNnRqWDA2TXdxSi94MW9zR2JuWjVtRjlnS09kUjdK?=
 =?utf-8?B?TXhvUWVmL2lDOEVCTVNwc1BPL1gyNVVzTWIwa3pLVmhzY0tmNEVXRzJrSUd2?=
 =?utf-8?B?RU5VMGRrOW5GVitJUjRUc3NTZjhRUUVHa2xEV204ZTZyTlF0ZzgwNmpTQnM1?=
 =?utf-8?B?OTR4Nm5XVUpTakl0ZGdwZjhNRGxhM1NDWWJGNTU0cVV3K3hPWXRhMVVrU3J3?=
 =?utf-8?B?Q09SLzJaMGxNRnNOS3ZBc0J5U2xnMkl3bWs2WExLYWkzbnhVRjBmQ1FDbEFF?=
 =?utf-8?B?NEQveUdtQnJ4MW5WdWp5Y3BJZy8ybktLVlFEQ2g2WmZtS0NnaFZQbDFEcktO?=
 =?utf-8?B?ZVdiT1MyYURzeTgwdVpUSUoxSHQ5Y1I2RGJzRklFOXRzcTkyWUtqK2ZaRXA1?=
 =?utf-8?B?SG5CeFU3ci9GaWp1WmlKTjkxVlNOR3JZQjVYeThZRUhEUTJWSkJadGVDa2Fz?=
 =?utf-8?B?YnVFMHl1RUF0V3g4dmtnbmF3L3RRbTZPVDFGRlV3NDhwV1Z4b0FMdDVtRlJ2?=
 =?utf-8?B?K1lmTUU0eDFmYUtKdHNnQWNBZVdXQndTd2cyb0hMZlRybFhxMFhtMUJTNlkr?=
 =?utf-8?B?S3dacTBjSy90MUUvcWUvaXY5bTBMbjlnODgzZS9EcWM0a1hweGxyNjFEajNL?=
 =?utf-8?B?dnRLeHU0MkVOekE1eEpxdFlhRThTRnp2L0RTUE9aTVNzd1YzTEI3bnB0MjYz?=
 =?utf-8?B?ZFBmR05wQi9ieUZ4YXpmTGNFbFhxeStyZlhzM2s2SEhKUzRBWTFGR25HUXZH?=
 =?utf-8?B?L2NGak5wT3pOTHJURUwrNzMzMWMya3dOQUx1MG1DclhPSWZJVkkrdlhONHhk?=
 =?utf-8?B?Zm53R2RQVHlqODMzUUY4NWhFbDlhcUdqMnFncTU2ZytreitzWGU0TWphMzRt?=
 =?utf-8?B?K2ZhYjVzL3FFZUk0Y2Y1NXl6LzZSU2FiUFNJUHpSbU5YRkNHRkVRblBzUWxr?=
 =?utf-8?B?NEdUZkdOZ0pEU2FPb2hqdFVSekFXK0ZEdTJjZW9BL2RKTHE2RlpYQTJCZk9z?=
 =?utf-8?B?MXQ2dlplU1oyaTVaVjF4OFhKWDJzTXNCaytlWGp4UFV4eHJRRlFxNHdhN3Fx?=
 =?utf-8?B?akx3Unh6enlTNnF5Y0xURTU2ekxPRjcwcUZJT3JGc0YzSVhTWUd5OHp4ME9o?=
 =?utf-8?B?ampzZitjUytub0haYXJKNktiQWlOWnloZ25SVkZmM0Q5UXVpU09xYnV1ZVow?=
 =?utf-8?B?Vk0xYXlFSGdWRDNyRjU5VFoxSG9wb3MzcWIzVEdKVlM3eXMxQTZheEFTMjlJ?=
 =?utf-8?B?NXRtaklhdmFlL0NaeTRFT0V5T25wN0VuSUdWTSt5MWhWa0svRHlOdDBWbktj?=
 =?utf-8?B?cWZUYURlc1FXdUVvSVlyWnZPdU5FU2hpbENkUXFlNDFrOStlK2s5ajRZaXFE?=
 =?utf-8?B?MXZuWFNoOHA2Y2pCN2xhOTNJY2Y3SThtZVh6NkkzVGUrNXF2THRybzJWRjcz?=
 =?utf-8?B?NzlMQncwQ1hXbnVHSUNraThQSHp1VE9odWRYdFRCWDA4aUVDd1pyOHpGSGlh?=
 =?utf-8?B?SjZHVkVTdkFhcU9GVDh6MVZHR0psSk0rVUlUMlpnODBRNHlmd1RKZ2pRRDJG?=
 =?utf-8?Q?+s9aNn0GWEbtOTcR0jJYEPWpF8qB+53au/x5ZP/1AE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4786E79087CF00428BF1FEA4F69F3019@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ebuEmp1Z79WksBILgzrL5ou2GpKUJ5WeZSNpKXzzFxJbAIwjYyysG/9Zi69mPCMtFUYWZzs0n+Eo0PFCL7CZ3LcAPpvj+h7Wjz5ns47W57LxMpBu75zg3x1bokuhJim+FaHjXPukNKqXmc82+62M6tGP2GIi9lQFz0/as/+3xO/1fJtx1JvvYKdiTHNXLfOE4kcDchu12u8VIObrN9lBmRh1KKO4MZIQE2xD5H5ooJaRDwLP/iCNLE0RhJknAIx3naXn+0TINFI424beqEP7ByFMo+N4Tb7sSvFVgc5gWbWDvt9hRXKLsmWLr+Ms2ArnX/880bjhMi2f6MYAl3rJezGWL2p5EDfS8a3bfASp8VzMx5oKRFRLSzChdMUdb9VGPQ5xYMB+R6M5fwmsKP78Gtz+30g7JacIT12uDxANwhHs8qse1p+7evkuEN/7A/iS9ZBbtrL6evOq1AJZDzCAxLbHBBMNJRhvcN/ylh4N1fLknpj1MfJZaoSyrNwDyFSmHXeNoWfJXplwVLDI0xwEjmgTIDLeEm4+ktBK5n+IvSJ1XCGYbk76NTT01GmuIhkM/mBCTfubW370ohVjdgm7nhmD2V3mqa3syhFFoXEcM820ERDlMHztgbh1UbiT6kwr0pKHuZp1E2JsF+VBTZh6xcF+hMiofYF8bjXxOCKe6sBklm7OF6ViMM85QQyGCdb40aq0kdCxUndw1miQ5lmcYAi2pKDPBxVQSJIVxe0GxT9iYhKXhMcSJRwxWSaX9MhDil2eRdsOigEhnrd5/Dre15h/5+/W534d6u7TdP1eaCQhLG8XKXgI9qLFBjJawDHn8qjZ2Io1zx2IbU0S7Lpr6Akuk44Y30/8gQpKccY6Sczck8qyx+H0orLw7lHsf3JiTcuAnwygGYEOahL2KVLMtg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6758419-6778-4b7a-614c-08dad11f4d66
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:02:39.8780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJgZDOVpKvIrZ6TSoeC3cY23zrkz42Sj5F9Po36h2mo/BulaCk8kC05yK3DYB4b+bV4BICFoObzjPuW4IpEUSsvATciOy9pVt/BA24/THL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6304
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMjguMTEuMjIgMDk6NTQsIEpvaGFubmVzIFRodW1zaGlybiB3cm90ZToNCj4+DQo+PiBUaGlz
IGlzIG1pc3Npbmc6DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYWNl
LmMgYi9kcml2ZXJzL3Njc2kvc2NzaV90cmFjZS5jDQo+PiBpbmRleCA0MWE5NTAwNzU5MTMuLjIy
NGIzOGMwZmIwZiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYWNlLmMNCj4+
ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX3RyYWNlLmMNCj4+IEBAIC0zODksMyArMzg5LDQgQEAg
c2NzaV90cmFjZV9wYXJzZV9jZGIoc3RydWN0IHRyYWNlX3NlcSAqcCwgdW5zaWduZWQNCj4+IGNo
YXIgKmNkYiwgaW50IGxlbikNCj4+ICAgICAgICAgICAgICAgICByZXR1cm4gc2NzaV90cmFjZV9t
aXNjKHAsIGNkYiwgbGVuKTsNCj4+ICAgICAgICAgfQ0KPj4gIH0NCj4+ICtFWFBPUlRfU1lNQk9M
KHNjc2lfdHJhY2VfcGFyc2VfY2RiKTsNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2Rf
emJjLmMgYi9kcml2ZXJzL3Njc2kvc2RfemJjLmMNCj4+IGluZGV4IDk1NmQxOTgyYzUxYi4uZTdh
MGUxYWNlNmQwIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9zY3NpL3NkX3piYy5jDQo+PiArKysg
Yi9kcml2ZXJzL3Njc2kvc2RfemJjLmMNCj4+IEBAIC0xOCw2ICsxOCw3IEBADQo+PiAgI2luY2x1
ZGUgPHNjc2kvc2NzaS5oPg0KPj4gICNpbmNsdWRlIDxzY3NpL3Njc2lfY21uZC5oPg0KPj4NCj4+
ICsjZGVmaW5lIENSRUFURV9UUkFDRV9QT0lOVFMNCj4+ICAjaW5jbHVkZSA8dHJhY2UvZXZlbnRz
L3Njc2kuaD4NCj4+DQo+PiAgI2luY2x1ZGUgInNkLmgiDQo+Pg0KPj4gV2l0aCB0aGF0LCBpdCBj
b21waWxlcyBmaW5lLg0KPj4NCj4gDQo+IFRoYW5rcywgYnV0IGZvciBtZSBpdCBkb2Vzbid0IHdo
ZW4gSSBoYXZlIHNjc2lfbW9kIGJ1aWx0aW4sDQo+IG9ubHkgYXMgYSBtb2R1bGUgOigNCj4gSWYg
SSByZW1vdmUgdGhlIENSRUFURV9UUkFDRV9QT0lOVFMgaHVuayBpdCBjb21waWxlcyBhZ2FpbiBh
cw0KPiBidWlsdGluIGJ1dCBicmVha3MgYXMgbW9kdWxlIDooDQo+IA0KPiANCg0KVGhpcyBpcyB3
b3JraW5nIGZvciBtZSwgYnV0IGhhdmluZyB0byB1c2UgI2lmIElTX01PRFVMRSgpIGZlZWxzDQpr
aW5kYSBoYWNraXNoLg0KDQpNYXJ0aW4geW91ciBjYWxsOg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Njc2lfdHJhY2UuYyBiL2RyaXZlcnMvc2NzaS9zY3NpX3RyYWNlLmMNCmluZGV4IDQx
YTk1MDA3NTkxMy4uMjI0YjM4YzBmYjBmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lf
dHJhY2UuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfdHJhY2UuYw0KQEAgLTM4OSwzICszODks
NCBAQCBzY3NpX3RyYWNlX3BhcnNlX2NkYihzdHJ1Y3QgdHJhY2Vfc2VxICpwLCB1bnNpZ25lZCBj
aGFyICpjZGIsIGludCBsZW4pDQogICAgICAgICAgICAgICAgcmV0dXJuIHNjc2lfdHJhY2VfbWlz
YyhwLCBjZGIsIGxlbik7DQogICAgICAgIH0NCiB9DQorRVhQT1JUX1NZTUJPTChzY3NpX3RyYWNl
X3BhcnNlX2NkYik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkX3piYy5jIGIvZHJpdmVy
cy9zY3NpL3NkX3piYy5jDQppbmRleCA5NTZkMTk4MmM1MWIuLmQ4NDU3OGRmMjdjOCAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvc2NzaS9zZF96YmMuYw0KKysrIGIvZHJpdmVycy9zY3NpL3NkX3piYy5j
DQpAQCAtMTgsNyArMTgsMTAgQEANCiAjaW5jbHVkZSA8c2NzaS9zY3NpLmg+DQogI2luY2x1ZGUg
PHNjc2kvc2NzaV9jbW5kLmg+DQogDQorI2lmIElTX01PRFVMRShDT05GSUdfQkxLX0RFVl9TRCkN
CisjZGVmaW5lIENSRUFURV9UUkFDRV9QT0lOVFMNCiAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL3Nj
c2kuaD4NCisjZW5kaWYNCiANCiAjaW5jbHVkZSAic2QuaCINCiANCg0K
