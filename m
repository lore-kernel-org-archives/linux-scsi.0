Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999D1C43219
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343681AbiAaLcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:32:07 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3309 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378596AbiAaL2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628530; x=1675164530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=GGkjFoq3+H5XYskA0TQoJhvoS0gKjlnk1uJG3K9kuE0qCyMaK6LUCbyl
   mnRZuDqRe9tJMsAO/V1DONisp2uCZUZ5+DPk1IR/2gDKJkRRP2LLH39z+
   gLgkh2uvw9jKhTmIsgu6YM0zPMp9kowUynpqr497eSJoeJxOyDw1GFWJb
   MAHLJzjI3/d3I8J5KsimwyrsWcrjuvw458t6YaTM9uz/Qglm6oRFMyuCx
   XhMgA+pxTYge8InHZcWTe8BPU/SJ+A8Vj+k5utcVOni0sBpjJ1npU9LBk
   04tBU5exxB/uKJICUQae9bjYUwJyq7o/ulcrItIWu0SIj/g9sSE5Z7AId
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303682191"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:28:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlyhbDcGdzsmt5Nxca7gk2ETxorO7UJgDvNKjULAyE+RhzjLdhH0CiMCAqtLPuLHkOkhoNZqhDd9F57QDjA0CyDGm3ib5G9Gu1m7rH9gUiV2DoDiZY0Hw+hSSRqqTnBotHM0d44Uvpa99nfpkLSyeg1NMnn3LwXzbRExTj0HBxd1CtXLqjTSfeH4Pd5jpyZlK2/sM1MWP2d1bMGrkajD7MxDt3eB/MDfSEoD0GwQ5Ce4svjS9nM4ChhKpeayCCkYnMC5umVfY/DgNI/rhy+LcSULOFLp0n8J1mCcsLAwCgeLSAao61V8EhUNFbXzR28jKEKKctqztjaGkDZQ+so0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=KKUtkMxdu1Z+6JgRRmXAVDw2EAyoTjHCtmZGObQ1LyHgQN2rozYKZKXCT5x05FgW7qzz/U4koPCaf7zZMASwIxQB9A5CAcL6HUX4JKPsiIP85xH+hXfyCbQOBKjy2vto2mzdQCXTV2hvaJhyPvR5wupDN+IvaaJLWYqVDmGOONdOQcByTFmfVsjSTcWOl5wtDDRpd0/nd1HoSHpE3kP6smxjoDQuaj6XAxIAcnoHcwM7DP5Y2Ro5T6QRsRHEpTv1diA/tyTw1HkpR1e1uCSOvjNVT8XpkabWB/Xxl1MyPRqoFiuMhoCkQRS/Vs5FcyQWrNobSq8Z1GDY8zreMSzewg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=u30K7JLFmh2YNBZjj3C49yIj742x/lqjtzLoxp8WV/R5LHjxE4imPdMzk3dOwt8YJ5ooK4MEOvil7SG9juKgJDVYyU1BoqB+YJjS27EhP/E42K1pwnHk8R/IE4/sTjQYe2WSNP/utPKMjX+0UPRg0UZG0I5ZnPH3+Q7NFQS21wo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MWHPR04MB1185.namprd04.prod.outlook.com (2603:10b6:300:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 11:28:48 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:28:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: [PATCH 28/44] megasas: Stop using the SCSI pointer
Thread-Topic: [PATCH 28/44] megasas: Stop using the SCSI pointer
Thread-Index: AQHYFJWBbebdspLVm0i0vtAIYc9IDqx9AkGA
Date:   Mon, 31 Jan 2022 11:28:47 +0000
Message-ID: <9d4c9283599db672e029097a0f52bf933fcb5c73.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-29-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-29-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c071b52-086d-4cdf-fc48-08d9e4acd938
x-ms-traffictypediagnostic: MWHPR04MB1185:EE_
x-microsoft-antispam-prvs: <MWHPR04MB11855B1B258C60962067B2469B259@MWHPR04MB1185.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cXBW+BA4dzv7K4rQpajJNEj/HtR+41DydMGfOZ8WEN+t9K/0616SL8QPHTCoMcBVPoxWPeLdC+uCmzIi7iWD6ZvBF3qJU3r0OM040ZCvGfxOmvlWMe46KmNj4oaRTaMgnnIVQ2vxaX40JRh3F5wb5ehQ9Od7tEXxlwR8e8qE+dm5giID76PzX4ypEQYn9+gywz9yn4EvB+a+nwWd4Y7zmNqCivuDddvqE6uo+ZqQ/KDAWkcIbNDdL1SCSM9nKGaQCWOkglcyfYk5ELEd2ja/mlS84U647wiPuc9bWK2Z8oPsUI9toHPKMbyHoiNdlwk9VWTJTh752Wohp6vw+xqG2aQYvxzFWTJKPfJPcUqvHhNkRLGeI5LuLLWUQzcgkMShi8VV4pbU+8FYXohNUlsdEzCxAb55lprMSbgege1Zxlp2BF5/UMKs5eypMMtWv/sSuPAaPHkzp0chCS21TPh0Ux2JzVmIFDsjiO0IFnLUNhckVxYrpEel/ckpM43tVdPDd5O67u/lefOpCA/WXLUK4B/41fSJnZret4S89+spKk1bhXBx43JnVrVugeKeWN7UZMGsUUvo2bYo3kXn8UPFVFkYRwohd2pxSvMG6nxViCNp3nq8UtNOkjk5uUDUymhFRHSbpng7ryV2zvn9qZQgEHy0ogR6fUkE0XgIOhzn8gmqJ6pESGv20WbgPVmdkFafhFx5BG2wzxNvbXcn9WTGNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(558084003)(38100700002)(86362001)(38070700005)(122000001)(82960400001)(76116006)(64756008)(66476007)(8936002)(66946007)(66556008)(71200400001)(66446008)(8676002)(6512007)(4326008)(5660300002)(6506007)(508600001)(6486002)(110136005)(91956017)(54906003)(316002)(2906002)(2616005)(19618925003)(4270600006)(186003)(26005)(36756003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmdLaXczSzFPbXovRUZzb3dQRTFZS2hrcGwrWGthT3lnZ1FpeElxajJVU0xo?=
 =?utf-8?B?aG5NdTRYRzhCaFNDVzBtdHNMQkg2S0w0Yzg5L2dDMnBLaFVwWitXVFZFV3BJ?=
 =?utf-8?B?bkpOMHA1SGE2UE02b3ZoK0Q5bHdROEg4U3BuUzJEODhWc1A4NDZwRTVPa2ZQ?=
 =?utf-8?B?TUo1QnBXdHJrcy9reXdvN0pYRFJoTzF0N1d3OEpVeHZib2ZmRDVHL3NqZkhT?=
 =?utf-8?B?N0dvYkNPTUk4M2NOT2diWGp2U1VRQ3ZOQWxZQWNNT2tUNGZiYnRSTG5KQ3Nt?=
 =?utf-8?B?RUV5em9KN0tjV2doWXNZbUsveTZnWG1BbUtILzhOWkk3cEgyQWhzbkNyR3ZY?=
 =?utf-8?B?Um9NWTljNzVDMzEwRFJCVEFKRDd3MTNoNFEwMlhldmJHZEZxaXg1VnZDYUpx?=
 =?utf-8?B?dTI1OVkwZVorUERNcUwxM05rdkYxWm5UKzFGclBUcDEwMXJVT0RHZkRCMUEw?=
 =?utf-8?B?R2M1bE9EOGRET2lJNzMvS2N6V0pHelczSGt1aWxVZ3pSMlhydjFGZERQWS9a?=
 =?utf-8?B?TjVlc2QyemI2WDhQVjdnRFlMTXU3OVRTeU9TRXZsOHRlK0tKenI0emFsZFFw?=
 =?utf-8?B?OHRxWitNSGNRWFEyNTNVL3hSaEx4bzBhZXAvb3haWENpQWZCU1RrZUlRaTFm?=
 =?utf-8?B?bHo5QWpNRElBbVE4KytsRm5zdWg1QnFIMDNIODZ6aUQyMlAvYVQzSS9yMXN0?=
 =?utf-8?B?NTJkZFBBZnphM0hTamszclNaUHEyYjlDcWtoV0NVT20wdSt0VTVVVnA0Znph?=
 =?utf-8?B?T0lacWpQYTJqcEZab0h3WENUTmVDbVZNMUpTTUlNSStPQmdPNE4xYTNFWDlE?=
 =?utf-8?B?b3h5K1l1QzlBdC9QbHNMNGcvR3hhZHVzckpYM3IrNlRnK3prdWQ3ektILzFW?=
 =?utf-8?B?SjdCRXB4eGp1ZUZSbFpraGlRUndPS3k0SUxCMGkyY3lxWG5obXZ5V3Y4VGhM?=
 =?utf-8?B?R3JVMEpuY1FYY0VzdUhMN2IwK0xITW94VzF6L0dLcTU1QnE4b0RTNnlzeHRk?=
 =?utf-8?B?Ui93YXhWTmdsdkkreGptdlhETUpRWEF5VDBsRXRRVVRXYm80NjU5ZzRodzVB?=
 =?utf-8?B?S1dmRlVrY2FqeDhteGp3bTUrSTNabXRaSmR2eW0xbnpNVjI2aFI4OCt3NVY3?=
 =?utf-8?B?Ry9aUG1jbU9YY3FzSlcrNzhKaVFYK2t6Y082a3VsY2RJaEkvM3ZTOEE3Y2xS?=
 =?utf-8?B?T29QRFJXYVlyaXBURkJnaTFKSHRwdElGSDQ1RmJvT1lUaXNjNUlRcnJqaVVM?=
 =?utf-8?B?emlMbDg5blRzSndlWHRBdVdIeU91Qm5MWUpuZjM0U2Nob2g0WExRMFpkVUFs?=
 =?utf-8?B?elJxRG9YcFRaT2xHbDRiWmVIS0t0SGlraEFTQXRicWEweS9OM3FPRXNUVVB1?=
 =?utf-8?B?V1ViQlBmeGYxdi9VUXlpRU43dmJHU3R6ejdtYUZhRjJUbGdad2t5WTA5Y3VI?=
 =?utf-8?B?eVorWHNMUkkrTjk5bkpXbnNubi8zTGlaK1gyMVR2aytNa1hQWjg1blk4RkFJ?=
 =?utf-8?B?M1h4Y2VhUWM2NXpZSzhHdXFwdHExMkV1TW1jTzg5V29zbVgzdERtZ1B0Q1hj?=
 =?utf-8?B?Z3Y2ZytrbEs2R1dyZUJTYzBwa3Z2QkRESXFEY1ZoQUNYYmNIbE1nc0pnUGNV?=
 =?utf-8?B?MFhzVGNYMjNad1lrcCtaYlZtaGRsbGtsZ3QyNnBMUnhGZThQTXBZRkdjZ0FR?=
 =?utf-8?B?ZXJ3U3lPUGE5VmpXL2dMaXltN2hrdGFPMXVNeWlPejl1UUZlZTNrQlFUTEhi?=
 =?utf-8?B?eWlwaUZVODNDQU9NakEvL2JRdGxzR3dhSitIcWpQTGV2WkdBMmNNczVyQnZm?=
 =?utf-8?B?cWsyTFVYOGlHVHFiN05CY0c2Y3VqVG9EcHRNOFhCbUhRWXFlV2h3aDFyQzJv?=
 =?utf-8?B?ZkQrbW8wVllYVkxob25pcWNzR1pVcUlPUEVyamlWaUh4SmkzOGc1ZnZrUW1O?=
 =?utf-8?B?UlI5eTNmVzluQllESmxScmVFN2hRWU1ZNTF5clJtdTRxK2RWV2VMR1Z2RUNR?=
 =?utf-8?B?cnZ1K0M4MkwvbHVjYnFSR0FoMDNyMFpzbSt2RU5JTEJaTk1wcHY2OEJMbHVJ?=
 =?utf-8?B?Vkhwb3Y0cWd3YUpTOXJlQUhkbm9IVklEa2I5Z01rZHZvdDRGWlc1Sk42cGpT?=
 =?utf-8?B?SGtEejErbjVvYzJDQUtESkJrejhuU2tGOHFxWFVJWmJyWjJrVUM0bjVrOWlC?=
 =?utf-8?B?eUdwOXdDSzMwQzJ1ekNpQjAxR3hmTFRkRDRqOW1Mck95V0NSLzhLUXZMMTRU?=
 =?utf-8?Q?+K8swIFmkqtamUxbmtUkD9D+92V96tOLPHvkrB1U8Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1875BFC3A399FB42968C45D97ACF2003@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c071b52-086d-4cdf-fc48-08d9e4acd938
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:28:47.8128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRbzn+rtbkVncZ/R+vUWS9g6njvR5AsbPhdPvpNL48FXKZt2ac/lXBDdtHZYI6UO0tSeYofWjSg9NLeVlI1kldLsmv34ghD3sZZa+1SPlF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1185
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
