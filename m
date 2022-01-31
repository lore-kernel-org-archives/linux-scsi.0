Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0EBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 10:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348428AbiAaKJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:09:06 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1354 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiAaKJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 05:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643623745; x=1675159745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=XT1VXLsnRqARvXjRgTyJI6YrtMo0pdWcVhBSQdWl5p6lY188CGlunanz
   h1n+V1p+S/NUhUcywn5zBH5/jg7+Srthzf22d8UBemEDGiNUSFfwUrSFM
   olQAM3xJwDubKSTTgGJzzgrdIJ8gXUjEPdvgWFJGY849jYxjl1nqnRqfS
   I4aR+ASRY+L1Xk2wrac8jG0ubASU1orgKuq4jbNGQLAtzpWhkwFne7y1C
   VPD6rupYuLmVxGqguG94GlziUjTHk1neefz9us7wfbbw0slTjeALN4lD/
   BHc3rYaqFyUtFSIVp3exOaR4Wh+e/szMVElz5k1UqaFZEhPYHKQ2UOXfb
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303677007"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 18:09:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/Tk2/hqWhduUAD+/Qvt/BSPKkin/8v2YoITlvFETi40lfFItpVI/HIxFOpLi2oVp7UZACrxMXNz0T+T5gUv2CBIt9QVreQeWFaAsdduSL38N1NHendgcD00EDDLx9pODHlIBZmqlhB3WQJHaDD1pob2khBXJFsYJB8VMP8ocqnzz8oDPs7jqXdBi+7npcyxNAzZJ/pBEWrLKiagORWRQSU9xQIV+o2ne6dWxVOq2AyYF5nPcnScRLXlZcl4I68fmC+2KwB+GKUIG/ptf81fVPCIhS7T+ODazG9HTO+9jlAFk21jPcRG21Qu5X/ez750nZ2par0AsixcqJ6JrKOnMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=TUyKEnsGkKam0Bp/iaxS6dgcrUOlq1cZGQTNWHNE6jQ6GKJdfyXfpxF3A8q/6Y+85OvXzIH8Wxo37Oh7j1BdrYdVKPCVghdvd1eWFkoHxO7RWz3wa60OWv3/MfGcvQaCduRq2EpgTIFxn1wwU46G+kXteCgbpgzkKlQXdDIDFZKeOy5RtJj9H6ROz/AkE75gMNrV0VWelU8D2h90usNkvbH49mhmEIUvad9C748xSqn6Giyq7Sd2nZYrK92PWAw6DlB5FI5rXuni1ja3VRx/Z1pVVHagh3ye7qWZHxeBvccErGU+0J6/D6869A2DYxH86b79dGVl8oA83ss9XGc9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=cb9JNZ3oattobcn0zeqHeXbVkRs7H7oqys/eXRfNDocolp5D3xM5luPM9RGpKYSHjAjWTAh64Ijd8v76mN5dqs6t4sZ+QB31dsroG1mylh9a4gAzLkS0uNrdH10NAmpeGJK/0M1YMwia2oPAOMBQk4jB6EPqk5wa3ws9XnDEZjk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY1PR04MB2250.namprd04.prod.outlook.com (2a01:111:e400:c617::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 10:09:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 10:09:03 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Thread-Topic: [PATCH 06/44] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
Thread-Index: AQHYFJVSgmGICrWBcE2mEV+amVBXGax86/qA
Date:   Mon, 31 Jan 2022 10:09:03 +0000
Message-ID: <8d49e9b600233b1e40b1b733d6be4fb699f1d2ad.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-7-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66b190e6-d596-44e5-81ab-08d9e4a1b5ad
x-ms-traffictypediagnostic: CY1PR04MB2250:EE_
x-microsoft-antispam-prvs: <CY1PR04MB225010E93AA35022A3A1CF119B259@CY1PR04MB2250.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Khhk3tx4XpbnGJ5S5oA6s4eQY4h7OtedKGomHujN1HZgTvP4XHnjE/Qqy4td93eg8XPbQMuKjcu9BODxifdLIraqtPI9XABRtyf5ZoH+8W663RPBH3Jb4hRc9P+tpDmawiFhQY9u7mt9an08wxurqGPxACjmfoVg3fJPluRBJAu3s300dfTJzT6ukTn0IQy8n59CyaFW69/8rcHGsq/cr2j4y8AKjwFX00jLBS5QVH/B2MCeQzmQdbqYz7hcCD4XmLwHcapGgN2271ngK2sTuCnp57NP0t2XT4KNGzI0YPAQTSf6WYtFPoUHRVQZBuniNPG1JXlb+BDsdLmCeVfxNCBCAndg/FhjeiDL6QK9oVfSYIq5OhdlP15TRsEATjjR2pkukk78WWaqkhQoXNvhYYgZGM/459bCcOo7WTSveQ5RX36nKp0W05xnM47qaVMX8j0MQqKSX5FXECFNm3sluCG2RrkrZBb4DhuLqMevtGELsducX63JssB7lCw0Wb9DgBfzKfkREYDdJfZ90pSd+pNeGnuAj1TyACCDuGxoEMblIrKJsFY5CeBT0eLnG6/5caiKJX3HhwKYKh8n/TstvjfUMMleij3UV2L3IroOrNWUCoWBcXN/+cZoa1wNiBr0odUVcJ9QT/Ho4vzfvXymfnqq2/JXVQdSsmuS61VQcFB2Y2mrgDoDK/AQmfnavb0TZ9k1PfPw0bQ+4inPpif+3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(71200400001)(4270600006)(38070700005)(82960400001)(26005)(186003)(8676002)(4326008)(36756003)(8936002)(316002)(110136005)(54906003)(76116006)(38100700002)(91956017)(66556008)(66946007)(64756008)(66446008)(66476007)(6506007)(6512007)(508600001)(5660300002)(2906002)(558084003)(6486002)(19618925003)(122000001)(86362001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MC9sUStiZVVReEkzQzZQRjB5V0NnaklzVFlYdnRIQjVtKytNdGRnYmVvSGFq?=
 =?utf-8?B?K0VDUyt3OXFWbk90OXNzbkVSSkRLTFBIbkxiME5XTjY5R21LTUdPUDFNMzdy?=
 =?utf-8?B?NmE5NVNsTk5pMk1UeHJBdmY1SC95Ymc3ejF4Q0VMbmFOdm0zdGRlcjl4dUky?=
 =?utf-8?B?c3dRYXRaL1JBTHJjSEdUczlDVElTZDFoaG5ib2hSd05sRFVEdkdTRE52Z0FW?=
 =?utf-8?B?NlNEcGZMU0hMMGc2ZzV3U2Mrbm03TEc4dU1WcjNsenNYWkhBY0lWUks4T3Fl?=
 =?utf-8?B?SGVObmZReUpkQlZ6cTZNQmY5cFFVUGxEYjZoMU1LTU84aFBJU0pwVVR0ajFQ?=
 =?utf-8?B?LzFINzl1cU16Zzg3bVFaa3RteHZiSm1iTWlVdGFHQStzbDI3bWRsU21ZV1FQ?=
 =?utf-8?B?VUkyKzg2TjQ0VldzYlVCVnNnS2UzZmVYVjVhd2tNaHptMXVGUFRqTDV0L3J2?=
 =?utf-8?B?TnJ4UHBlRktMVWgvb0xoUVdSSTZtV0lEaVp1VjYrbDZEUUNaWkZCNmlJVmgr?=
 =?utf-8?B?aERlamdtd0xIdTdRdjFzZWlGcVRydUgrb2t0KytPUGpMSEgrL1NZQ1cwMzRZ?=
 =?utf-8?B?Qm12OU1ROFhidHBVaHdRSFRMZWx2eHBHckJLbnRCZEduVkhVOG1hU3Q3WFhJ?=
 =?utf-8?B?TTJKTEtFVDlycjcremVKVEpYOW9vUUJVeHVmM045WUUvckpEeUQwOXRkbWtP?=
 =?utf-8?B?T2p6M3R5bXpSNFUxSjAxSTlEdEdOU3A5M3RqVUgwMTZ6MU8vNnVtQnN3NkRs?=
 =?utf-8?B?OXVaSml4K3JmdjVBc1d3MmErUFFwcGhvK3JrY0Y5MGJ1bjMvRHNqYU5nV3A3?=
 =?utf-8?B?eDVuSWxFZ2VzbUFneGV5QlRNWkFZTnpLVHRtd0VaZkxPeXhSekVkSTJobFN6?=
 =?utf-8?B?cUpHUmZndmN1WVQ5L1BBOThTY2pTdE52VWxLK1VCOTRybUVvcXhrTi82bnh6?=
 =?utf-8?B?TVZabGROUnBaUzZUR3ZEcVJINE44YTJ6YVg2aTdncnVsK0RQQS9UTFR0ZkRR?=
 =?utf-8?B?a3M4VUxMY0pGMndEVzBFaUQ5Zk13emRtRCt1MGoxd1RGNEpXLzVXWGVONTRI?=
 =?utf-8?B?WGhBREh5bXZSZnYzOEM5UFVTSGp5NUxSNldvMUdlUHErbFNFMDI3QjdzM1Nh?=
 =?utf-8?B?TTMvclp5dnU2dFlEbWY4djdFOHVPL2FFSWVpbHN1RUhUbDFHMG5kd28yNFFa?=
 =?utf-8?B?L0ltTkJMeEJvcDBYQ0dyNHhtYW83anlrdUd6U2VMUlFTamVobXhZM2s5djE1?=
 =?utf-8?B?VlJnU3BvMFExYU9wTENJSmp6SDE3NVZieERQcnp5OUNRUzlzK3B6MHZWaWRR?=
 =?utf-8?B?VlRhdE9uM3R5MUpDOGVWbjROTHFlYXJoUzlBWm8xL1JXaXE5aDM5SlFJbk4z?=
 =?utf-8?B?MFpybmhBVm1ESS9GcUpCRTBpWXdOTDl1M3BIUm5Tc3ppVFMyWllCSEZvdzhX?=
 =?utf-8?B?MFc2aU5oVTVVdndXN3ozZDI1ZnBrRU9RYnBLK0xkeVdDUGNHUEJVUnRqaE9C?=
 =?utf-8?B?OHNsN2ZOVEVYcEQrRmNZQ0ZPbDRmOVlJRHpOeTVOVXYyTlhScC9MMXlDR1NO?=
 =?utf-8?B?Tlczb3d6cCtuM2k5dmw4em9VQXAvSGhyT1FOLzJmbElpU0c5UkZoVlp4Z3VX?=
 =?utf-8?B?c2hDZkMrM1pkYkJnTGZabitReGF0Ulk4dm1lSHZRckh0a2tNeG45ZE1nRXNs?=
 =?utf-8?B?M3V6cXFDVjhjc2g2UTl3dnJnNmFUZ1Y2VzVBeVlCUm1YWFF0VDhLT1d1QzBR?=
 =?utf-8?B?UmhGTlF5SHlYb2liYzB1cG9qQ0w4ZmRNaklDb2NrbGx6SS85SXBRYnNXQzRK?=
 =?utf-8?B?NHpVMlJvaUI0QTBIR0tHQ3ZVVHpreTdHRk9oSHRuNitkR2tGejh3K0t0bFNJ?=
 =?utf-8?B?MGQzUGpXTmxiVkljRzFCMndXbmJvaUZJUFp6NzYxZWk2VkFwUTFzTzViamY3?=
 =?utf-8?B?RmYxczkwRS9SMFV0cDRWQVdTMkdQNTRrellsUS85cnY1OVIzOGYzWGh2djJF?=
 =?utf-8?B?QjdFd0N0UmYwcUF2MTluRE4yV2JURG53RkJ0eUREV3NFako1YS9za1UwejMx?=
 =?utf-8?B?OWx4SjJYeWROaHZaM0hQSERYTFVKcGlrM2c2MmpRclRWcVRNTHZtVHVGQTRO?=
 =?utf-8?B?UExDN0dYaDRFSXR2UExRV1RFQitMc3k0cllkcUN0VG5LOGFUYmUxSk1VYk1X?=
 =?utf-8?B?MzNTenhUamxLd2hvREd6eGY1MDg5cVIxV1lJK1Rsck5kTDRReWsvaVJLN1E4?=
 =?utf-8?Q?riBjN5U0NLXrhB1017G/T9bcu5NTM5GalY77LnlTFM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49178C1F7F6B0D43B87115E444A77827@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b190e6-d596-44e5-81ab-08d9e4a1b5ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:09:03.7300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nzd/Dm5GQJJq+CrvHh/hTUE6rNgY/qy57elcilIF5pWhdo5DEPKBqqlAzeqUVwbgVVxWNpeBIGH9tRA3ckdzeYTzRw0c2Plst8GfVer8ON0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB2250
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
