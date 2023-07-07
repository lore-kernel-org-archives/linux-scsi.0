Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140A5EB64DA
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jul 2023 19:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjGGTRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jul 2023 15:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjGGTRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2023 15:17:07 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62DF124
        for <linux-scsi@vger.kernel.org>; Fri,  7 Jul 2023 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688757426; x=1720293426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G48GMDY0lhzCHh3oJsqQ9821qEpVU9XDi4lw6HJ/O9g=;
  b=PsUd5gyzogIhah9TsU6BKm3bUCjRqV2jGngxiYuNuy86xlp6ejPcqK4J
   oN6Rl3X8hG+B3SxCxKOvrh+/OOraT0WXin4L7Z4VjRZWbgRWYg19OdqH3
   XMguwddY5vZ0i9JrcU7/wHZdjfQiLzWxs75TOu5/DP64HIZmWqGgIQ8qG
   Tn67qt9MlZabr+rX694LOfLeI5F9U8jiQ7sqP+osn1eKBuq0FK/IzlckB
   tKT4u9DyWuacBwwX/TJzGQpWjNqirGNEys+6KTdX9Q+ilPplktyzKmot4
   eQvoAb4AlM6ZvsFRSmj879U409xIT9tb4ELPHpJIlFtIMgiNxmFtWhD7L
   w==;
X-IronPort-AV: E=Sophos;i="6.01,189,1684771200"; 
   d="scan'208";a="342530274"
Received: from mail-dm3nam02lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2023 03:17:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmRZfMsz3HD/QB9uGOykVO4NKO1cVjIh+EDSVWAazSAoPeKj7v9ipBhWPWvBEFE6NUe/o0uzvtaAmU3cHJ4Ei1s9A2hIItmjv04BOSzmCPwSmv8eFGLFpgLjfeTIkXUwr3ypW1FZLgaolU1nFof94opuUpt9y2ffBp1i2alCtuc197paSklNqGis5LzG8DwHlGTbeT/TX0zsXvrKld7f5+/eJ28U+V3zsjdSirjpmtmzBxxNBNDBxNWei25vWmC7ENJrKKAiWXKMHSonDnZyGSIb8Hne+FwgiaJfxly12sdB073OJpxfLve7vL8rMpMd+mLv7Z5nqQK91FurWKWGPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G48GMDY0lhzCHh3oJsqQ9821qEpVU9XDi4lw6HJ/O9g=;
 b=e6ZO7deZEVMNrW8k/Q9vkGpSDRXlwav+2QrkKxlJgX2Ke/RYc5MMSzJOpVdaGqRFa282I8ltZZ1lFNQR6IBmMBYASRajrHm8et5jK7uPCfeqCHN1ZeuHiqFxt7dLKWb6TOidce7bL/yDRciZIKigNsFCef8/9uolESi1SVsTHUFjlMQfbpZ/ng5mWbxchlj0tBiLZmTGPmqnG5Nj2kg53z03Rmus8yuK/kN9ZxTJG7uGajoTkI32AIjEF6iz0ct2p1/05UbrCLTDgv53gLspgTJvaA+h0WLnPR8Wy5mDB0m8XJs1kanu0RTgtOlaSt+WoRrpguu+hKEgIMnhf4LlVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G48GMDY0lhzCHh3oJsqQ9821qEpVU9XDi4lw6HJ/O9g=;
 b=tWcHMYj14yCkB33uNxBn2/Cy9/PZ3kHmBzErW4Bc/x7ee92GXXwVDF7rqnUeNbk/9ipwMf17ojHPA9qENxagW3BWHrk+Vbm6B0JxyVBnrKGH2ocYb5QEAYdbvTucJCBo5q07IhKM+Ou1P2/nl+TPzjmfmyyXLoaUsSlLi8fU2bM=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by MN2PR04MB7008.namprd04.prod.outlook.com (2603:10b6:208:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Fri, 7 Jul
 2023 19:17:01 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::eff9:f29e:d0ff:4ba2]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::eff9:f29e:d0ff:4ba2%4]) with mapi id 15.20.6565.019; Fri, 7 Jul 2023
 19:17:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Markus Fuchs <mklntf@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
Thread-Topic: [PATCH] scsi: ufs: Convert UPIU_HEADER_DWORD() into a function
Thread-Index: AQHZsFP3U2Pbba1r60m8nLm6seMy9K+urlQw
Date:   Fri, 7 Jul 2023 19:17:01 +0000
Message-ID: <BL0PR04MB6564375F5C59491820D9916CFC2DA@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20230706215054.4113469-1-bvanassche@acm.org>
In-Reply-To: <20230706215054.4113469-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|MN2PR04MB7008:EE_
x-ms-office365-filtering-correlation-id: b299094e-e462-4620-53db-08db7f1ebdd5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H4nSibn1XXCK8IyG+EGwokb7+drgHM9NZT1s0/Pv/ssDH33tch2oQy9nSO4H3MVYlQwsWzw83OWux7raR0pxxRmBkULVw7gwcqSmO2T5W/JPFhR0TGexsePGJ4R5laKxRZECllcckOArFKsQMTmLakZH5NkReazRxfGO+tJg7i2eAgL4fDD+he+h9xd2acLCtxuvzcNS66Zj4Z0k2O6+5tAa28xr+CNTmzzZ8ZrtqjIJobIk1xnmiYXe1We2GXFWDlAkKlN5cBaBSLiwEm7en1doS/Sq8UeJM1GdIDTvoW1ALA2dKN7TYkNO9Ch/nlmhSAZKO5gS2mKZfmT8ivC1cO3vnWC6YbhZS5SJVXKXxf+Urynu82tIka6YBma8iKcJMFlleGz7yDj9SS+fFCyi1jtUHOfBeANF0Pd8bc4mL+PU0aWkGKM6zUWz6Hh/aPzP5BnMbzSv+Km8aXnPJOZDS9NXXrOHoFDKF4b9KEJ45kU1Bmv8wTrdafKGiwGJ/AydANEos+KqCjUbQSpQdPlu9MMwp87kOKdkvIgbw2hWG/29cLqa2H585QpDyaKg32j2vYuKIXJ+S73PSJIWwnOnETI65Wf4otOkbdLyiT3ToYqnvKFmApB7kdkmtoSR+3AC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199021)(2906002)(8936002)(8676002)(41300700001)(7696005)(6506007)(38100700002)(478600001)(82960400001)(71200400001)(186003)(26005)(9686003)(55016003)(122000001)(54906003)(86362001)(110136005)(38070700005)(66946007)(4326008)(76116006)(316002)(33656002)(558084003)(66476007)(64756008)(66446008)(66556008)(52536014)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3UZcYVzp5+5S1owNUYdkuYlxrIrMHzubeJA7CANfGFP7/WZFjjRxI/n2Q2S+?=
 =?us-ascii?Q?ttTSm+OfqSE9VMLvyfmpr/JhZqHHkd8JvJA/ANZ3bE7/dAio38r3QhAnhlPz?=
 =?us-ascii?Q?j34gaU5Ls+jg5d6MYVGd6sr8Qz+8boevT21sS/P0yqh57Uta/2x7cpNwxUO3?=
 =?us-ascii?Q?DEJPzfQIcYoC2bjCs0HcFt65VS9g0twrf1/spWRqjD4c5Y0jhkFM/kCIMYXH?=
 =?us-ascii?Q?eQcEbOJpWfi+X/0ycyWC+UzJ3vvunvecU5WjQaW0ulg5UI7yGQStWfqJbYef?=
 =?us-ascii?Q?VTi/oS4rWOJ+PNAR/FdZ/vtLJ+LRSnfFaqJu6xlNlsb+p4IPjtZAIHo/69uJ?=
 =?us-ascii?Q?3Sm8YQUjAMH4edE+jKR5YBW8A9K2Gyn7uXmtI2E72P9phZNfLaSaHKxeShR+?=
 =?us-ascii?Q?kpiUBsBstFPquAZjrRmb1H7nO1hyG3MtpJmaIrQo75bbQk8hf8/R2TbKvQ43?=
 =?us-ascii?Q?rZf24EEhRLUMKwsbHBqM9xNh5I5dpeOuAfHr1NRAb7RScfATiQPhkKZNzmiK?=
 =?us-ascii?Q?Gjkgw3kn2H77uT5HvO8L/VJq72POIxJ1bnUI4MdzsMcXRFTqPxsyMGXMLo2r?=
 =?us-ascii?Q?gVfN37pcJC8L9wYCtip6XLFNQT98fz1N3efTdCkMhaaF1fDABMt+tz5Y74DZ?=
 =?us-ascii?Q?gJRygorKYsw4gvz+KvRI7SrOZW/e1DnWW6FKOy6djde/fUxKGrYr/6eSZXeL?=
 =?us-ascii?Q?oW53241Kgp5+HOPmME+ktpUcc42FIwLuwJoevIeIP/jcaxHWgp6y3QymV+l2?=
 =?us-ascii?Q?cpmZ6HwMZKBBm0qe6YSTk+R8Tjd9Pa7aSCIBgB9oifAov2vLMTsnBioKmaDy?=
 =?us-ascii?Q?1Nw0RWBXagDWNVemmZflv04pfKkOY0EhoTLdGQCD+Bc0UgSdH63e4X9UQdp0?=
 =?us-ascii?Q?oASLPgYySNfybPwWPGB9jGlXeugpS8W3aOYC4NOKG9TuZf/UbmPopL4bG57s?=
 =?us-ascii?Q?+D8j/PqZSZDVtk/+YXXMoPet8TXJyupji0d9ub8SlUoQt9JI7eNmOH+T1qqz?=
 =?us-ascii?Q?OSse/L2Jv1U2yOlOyNsQZ1FR/yl4L5yfFQK0mp32GKQyo0pPgpDYmHhYQsfD?=
 =?us-ascii?Q?CNmy3RBUX0dVkDYjV1nyEVo1DGiIoquxKeY5mON3WrPy6q2RhQ+9mQXeS1dJ?=
 =?us-ascii?Q?20qEG06gfg1BqXc9dbBFKf1PqAwvGO/yWFHoTm+B7bjU+QOBgn5PMrwy8+Ue?=
 =?us-ascii?Q?0B2aYOUidHesfDtD2DyIFwgbTf+T6wcGiZ996ewUh04+uYgfJGYy/LWBLwie?=
 =?us-ascii?Q?3ZoplzFtc/p510kTNrhw3AYs/IGmWyRLterOaN62cVxbrDkTpnTfqdgbdrvi?=
 =?us-ascii?Q?g5GiE7X37csEKlRGBkx0Om0XNQKC4BMGkGbgJsuVVQJUOpFTGhKknFwIOVsP?=
 =?us-ascii?Q?WCbpvC6imLqVUqntBS9vPj48/enTU7AgrB0OK/kkLmdGzI/XRctBgOqgCEFD?=
 =?us-ascii?Q?XIxLKCuLFHfAqyq+krm9e2MXQBXKnTQ7BX24mu9ZrfCtJV33z52ka4VcskRz?=
 =?us-ascii?Q?nLAjJr4pIbstwC+UeSD3NB2oipwh9HCW9wORv+4ZJfaDaCcw90Jl9W5Mzs3e?=
 =?us-ascii?Q?I5n/bJCfB7abvLkeBF8xDJzr7tfiFz2Z+zh8Lz8a?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?KApIuyty2iQ92SH6dfdJbjmVTxytBAVpXC4mjhdQsNATEGv2tKxUz922jCPw?=
 =?us-ascii?Q?99/kd/plekpznV9b0m8RlEMR7pHKpdNT0wtNcqjGLQpy1yzwT4MM9MPCdRJ9?=
 =?us-ascii?Q?Pd4i7Bu5KHIiu1tIC6cZDdYu8Yib7yDhIAkH2FmOL2/rPJPtT8wGymWeikPq?=
 =?us-ascii?Q?HNCRMAgeSZZ6UyeLkFo8fax+D5m56W7GITBl4NqQGL8u+0zThPcOycKymPGr?=
 =?us-ascii?Q?R93uy/mLyaYO9zmTn8T109ZzkldjMTKr/1qVyPyku/O7x2Iui7Qn9E2/DH6d?=
 =?us-ascii?Q?67l4O853JUYIGtsiMPtZoKG+BIAA/Dxma6AaJ4EHC/jAqaM6+Zfw1E+Bgyjm?=
 =?us-ascii?Q?QD3mAuIRm02QmK9Q3l+drlgagoeNB4J6aRt6w+1sfg3fd9lkgQCwWw80jcxP?=
 =?us-ascii?Q?4JQ3qH7+mzf8t+yU/+3LcYGOk2JOwLMPMXXgaYEMrHgKRfMPjrFdSDiGjE2e?=
 =?us-ascii?Q?775/YYwr9rDP98bXkaqQsQXeGqSflpA4ddCoPWJULkK3UR4bruXNQ7zicouY?=
 =?us-ascii?Q?VEkHS78jzsMORYHph1Hbv0WBzUXdO0PSDSB+Jxd1A3qFBRpy64BN4U2Kerc3?=
 =?us-ascii?Q?unUCKX3QDVyE8w7VtUqZjavlw9rXm8WV3KGL8VwubYJnoWiSJRG+9vojgpww?=
 =?us-ascii?Q?YKkU6iN6CQ+N2Vl76/Mwm9Xt7GaA296KX3QdkdS+iBkB3EB0D76J3qinW3Ok?=
 =?us-ascii?Q?DQStCmnpPEzRd1EsQ/18BhQqljd+5U1CSEk9tixcciZDjtwswu3I7qph9HOC?=
 =?us-ascii?Q?+PtiV7fpAMEj4lGHhQZiVk6GHC4vrJS80tuLx/TiozRKGOSNYISlpqndJfRv?=
 =?us-ascii?Q?5UPJEv/yLAlJHfSkmQAQQfvNydYi72CD+0x4UgtYLcbpmrVnTxj7fWPMxYgC?=
 =?us-ascii?Q?Lt4u0MoO7LdUa0kGgFtEwJmaGGHOHnHvWwOi4MUf3bqvH045KzA47qsCANvI?=
 =?us-ascii?Q?gbiBU9H3IitjHN9l2A2I6JjZwxm8FD0xzxGC0vYhNWZW4oFX5C8KkNYjoVTB?=
 =?us-ascii?Q?dIj7x52P3AGF6sqJZya0mSPSBcJhDjm+YjDqt6JiNSbrsmml5cpEEjyQd8Ah?=
 =?us-ascii?Q?qZbmtcWef2tXcE3lhyDn0NfD7KBlWJazl5xnv3p5W0aqHf289Ns=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b299094e-e462-4620-53db-08db7f1ebdd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2023 19:17:01.3551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OTTPAHXm2SDKRGxMN6B90DR5PkzxNfx5hox9RcYUfdl6HVG7ClFRHfulbD+04NtchgwYSOs8PnCWt5dyE1BYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7008
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> This change reduces the number of parentheses that are required in the
> definition of this function and also when using this function.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
