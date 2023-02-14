Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729A6C636CC
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBNA0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBNA0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:26:36 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA728449E
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676334393; x=1707870393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2zbKp115kjifXmkMM3tukwUkppBmoJeb0QXXJtW9tdQ=;
  b=SzMGSRK1vf47inJYoK253vhCQ2hFOgPrY9oUuSMVNM82xgLmOnvyOQOF
   ExH9j6PpghJdLXrTejcYwGj2LPafO+y8UBE5OEVHyxDq1tdrHTPVmfb/u
   xNPuZPvTjYvAf7tIxrk5SeJbndtpe7bwwn3LgsimMF/0BsOf3x6kHVf/7
   219yi0czWCJ8QqKJeXsq3L3AoenIk7/pUHdam0sJnTZqfhrYk8Dso0CQT
   U2iwxv0Ss0wF5T2wqjtjKXlRYASGZQzc3ofv+zGPwWHpBKt90zNiyxblO
   aPryfEPw9WTku3WtllW8s27T97cs9A0gGJaS7h0k4K1vBr8WD293/aRLu
   A==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="223016388"
Received: from mail-dm3nam02lp2048.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.48])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:26:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxkMABqwVg4SVs4kFodEOuOQITPPmlYIjPliGNmfvU4Wkz2i5XY4LtI2O8YpM0c2ehoGepaxAthIsMPF9ojHt6lw/vE7nf8FH5/zptb6tABS56O53KlbX56cNnzGkriJSAd7vFy6OGNEH2RA3DwpwQ5oitllBdnee+lfc0iJtuinfm+5BPXT+TxMLBTgwS+ABFqPgVjthlBonDAc3IN9GmgsnhmP/ff66PWqtCG0Fvf6mjkyO1134Ai6LURZs1oJeZO23iFJOwDkLKFRbjjZ8aK9//4n5zUV/p+AXvX3vbXlocWt0N0LLD5qNOybklBonwulvopSLLDuPQdoSM+Z7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zbKp115kjifXmkMM3tukwUkppBmoJeb0QXXJtW9tdQ=;
 b=WdRCiIvpKehOhd++y5Qe5uHA9sBGQZFgVr5XE5qp5VZ+OtHRDr7spX132mlvkvzAqpR5PEjPjVyEw/68F6xEBn0r8S4wN24xcCxZL0YR8H1pTopG4VEKMPKr0Unv2fMtY14YX5zyxvIX4t3K+5OpEAXdc5ZKqfYcrJfcIIwsGgkF0GhWeyB2gOtmB2eoJuz6Q9Y9V5hjYZ7k8tM2bZVL+lqhjpcqPgd/wQU36eu0Lw82p4I0JohmV43KndzvldMnKdf+zoXU46qif+mN78SjqtqNWPJQ+OdgzA4RlPcwOhGmDXsQDCTuoGJZXih52Mo+m0zXXQZEtriQiqM6QyR43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zbKp115kjifXmkMM3tukwUkppBmoJeb0QXXJtW9tdQ=;
 b=nZAQM9Uf2FptSQWcEOEC5M5cf1Pj2ye1t0fgnK80K3chhtfh/9t85y8PR+nV1U4kRdVu6R56mMc45r9igR+J6mIk8c6qHST1mTQarhaiUYtSyBLUWO4Eis1xm6S81kmUe2EzNGzkKXq26x36R1bBHG3WsRXrk3jYkmNFNskv0Z8=
Received: from BN0PR04MB8048.namprd04.prod.outlook.com (2603:10b6:408:15f::17)
 by SN7PR04MB8569.namprd04.prod.outlook.com (2603:10b6:806:32f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 00:26:29 +0000
Received: from BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::3564:3ac5:8178:34b7]) by BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::3564:3ac5:8178:34b7%8]) with mapi id 15.20.6086.019; Tue, 14 Feb 2023
 00:26:29 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v4 2/5] scsi: mpi3mr: fix alltgt_info copy size
Thread-Topic: [PATCH v4 2/5] scsi: mpi3mr: fix alltgt_info copy size
Thread-Index: AQHZMhmI8sGFuf9Hhk2tcfqTM8lE9a7G+i+AgAa3kgA=
Date:   Tue, 14 Feb 2023 00:26:29 +0000
Message-ID: <20230214002628.vyegu7ejbqatzfud@shindev>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
 <20230127063500.1278068-3-shinichiro.kawasaki@wdc.com>
 <CAFdVvOzbM2oate4RbHMt7ePsziQMmozmA4a4zBAYha9b0AEArA@mail.gmail.com>
In-Reply-To: <CAFdVvOzbM2oate4RbHMt7ePsziQMmozmA4a4zBAYha9b0AEArA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR04MB8048:EE_|SN7PR04MB8569:EE_
x-ms-office365-filtering-correlation-id: e4a4d79c-a15f-47b6-9274-08db0e221de3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X4AkI3yltJZZK999BoDmgYAk0j2owr88auzQfdrfgUp+kLAChzc/Ef2Y6++YZ496Nf/wyTw4EWqxP+FNiCEEEfFnKPHV7KWAjBghXimfxNpZMoeIYPZ15qt9kYqP1qy8sH7+ImyGvzxINXO4YBQIMQNs+W0/hvbuqbvF2zJKuEZv/MW1CWzjjCFCXPX5l/JIJNYAGVsOGttRdDEqz1AemcOYc9KbsZ30BnPJqGLv78ya7HqNQi2rj+V+EOjY22ohybYwXlYGrasqrTGPvefYe+Uy8PVUBYZgEkTidyk3DWcSTLdLAdp/jHNjZ9Z7zPWieNvvmDBKi/os6qlZSuGUm/fkhsgSwom23+KHzTnxk44dTAJy2ZodQqtX5343KoKYsxssXB+91zikqSUj/q9KVIRfLq0Syc2hrTpogm6yY1hXH6+WrG15tEL1GMIsyFg3lv17H2hBUYFckNLWiSJosetj9gMDliXLrzrb1eBsrpSmW65Bh+FICtszOrGJo1btvS+777U02ZTMr3djsmPRA/LS7YPXxtnRPA5f8fTdAeudfy80yUSUVb7Hhw2/H7Xs6g2e07wfBYc+AOaIOGnux2VgBNT6roSKJjprY5OsyOWy+opQ6U402Nu4X4cFZmBoX+OCI3/HzzJQnWHvi/EH//Yof9NWLSTWsJkw9Ra96UTgiAAskYgyELnnkGQA5y0d6jU1L8ygcPUhT0UkamSYvc9+/4UIKnAiMg6D3Rm78Bg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR04MB8048.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199018)(1076003)(6506007)(478600001)(6512007)(9686003)(6486002)(91956017)(6916009)(64756008)(8936002)(66946007)(76116006)(66476007)(186003)(66446008)(53546011)(66556008)(4326008)(8676002)(41300700001)(316002)(71200400001)(54906003)(82960400001)(86362001)(122000001)(38100700002)(26005)(38070700005)(83380400001)(33716001)(5660300002)(4744005)(44832011)(2906002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JbwSXF6w3GjDI1E9xZBKyoSzSqp89WXipKw4vy/rhtr1oQwVrYLdr/NQcsrF?=
 =?us-ascii?Q?D50QR/kQCQNU1Pf6crvS9E0nhyzS8ucJA5Vw0mW+DuuVkFDLqi9Ix9jYe25+?=
 =?us-ascii?Q?zwFMl5+9MOfITZ3/zipitFT3Qb3/EyUXhdN2AtbnKlKtVqWROK83bXFRkTpQ?=
 =?us-ascii?Q?UmahBfZgVnuDEsguOunSkgPBiCpzj9gRD+fIl45M2XT3V20wx9UK9gclhiw3?=
 =?us-ascii?Q?NH8vQIG8zzjuK7oYDaS9Gp1RqNYydVB1LGY1wl87wk4Pa+6gSCFdXaPIwp20?=
 =?us-ascii?Q?/eg3t62fcfFVxhldU5YAtr0LYhigjMG0D3iqS57e1qD6f5G9QxPM9/DnAshG?=
 =?us-ascii?Q?NljIcK5tKbNUHQ656kS4kZ77n49a6HmJXl5BzmQIm2ywg29N8SBzUpxiAxOZ?=
 =?us-ascii?Q?lKnR8jt8N8R/iikKtVDOcK0iI3sDmBbFIJETYkY0cCUYzQGtqRIXZ2D8kPjq?=
 =?us-ascii?Q?P8uSIMdiVibp7aRMx2oKpUyAIPCcUsk1T4CwsT4oxajsElwnCwLeV8Ru1m0D?=
 =?us-ascii?Q?DSkuAJwio+Wl8IyClnGiMNZohy/P4guJCdqnnSCgTEpqf2WZKE9IT4XixwtX?=
 =?us-ascii?Q?bLivhHlOZ/VlplHN6YSN+Lo+wU0eV3xDWdUQXLSTTkwKNZWlZQQkiqJrCyTL?=
 =?us-ascii?Q?Jbuvg/BDpOrCuFJ/zbzopKrHVQzRP6ZVBPP3F88Q+fAIEPX0G1cOmTY32DX+?=
 =?us-ascii?Q?tb2P+9Q3WISiuPyvc+0OBApxpxhcrzSzfppcj3V8nuFmIiZwEy+0B1etpKbq?=
 =?us-ascii?Q?wkn1QIB1fgWW1XqCzFo4vpDY+9ZFnxEH4c9QIFH8/Wh9/dIab+oZvFnDkg4E?=
 =?us-ascii?Q?qj5HLZQYW3Rky9SnT+RDHXxzH1B1ATTlTlvndv31rLsUqZXnxaaeM49ScZrC?=
 =?us-ascii?Q?ElmVJJzdMFdy+/gjhh/s7fBz4h5XenJXEbHyEU7yWFQk831j/PURmjht1VkF?=
 =?us-ascii?Q?owODbD1sUXkxyEoMzuQYl7f0CymoYX7wOBRuC4EvE22L69zyp23ZMxzZk3c7?=
 =?us-ascii?Q?W2Wvr2La8p/wBhBXmkkle+yyiElBqZhLIHKYyCfWd3TM1xhjdPL5wJtwVw9z?=
 =?us-ascii?Q?wJ/e9LETqnqU59lw2zuRcLCzdw4qR597nYNaOTNNcJAJ7ab6FMxNB2wxfz3j?=
 =?us-ascii?Q?leBEQ5RX5v8En0g6DsXKvzimkZW2rIHXwKtnRmroSWL61ziXQu7xhtb6RuXP?=
 =?us-ascii?Q?BuU101mjl0eOQkQT9MNhv5aHk5xj3CZIMZ6kMB3MQtnnZOjLMqtJ00KiC7i0?=
 =?us-ascii?Q?Gb7308D9byWrR7cgWoOkKMyONz/ntm9WJxCXwal4nj203dnlvjsQeu6kOhDi?=
 =?us-ascii?Q?1hTiK1eVhqa+cq6XjiCLy0Af9JMTcW/AELZBWi70LMlRVS6pewlrI0kSsANZ?=
 =?us-ascii?Q?WRWTwI8McJ2lHkSlcaN71Q4KFw527aBmfjlOnScI5owW5sX3abdnqhhYgXim?=
 =?us-ascii?Q?xeyMUZ1ozJeSIw+j4f7ej2YVt+MXRZeMyzVSnp2iXG3hZljV5XedLhnXNpQ9?=
 =?us-ascii?Q?VI5Cfpn2M6FubHgGDImXXHZQJohQ3/TUO6ru777YkTBFLTWlRZIScx8QT0a3?=
 =?us-ascii?Q?OcYgPc42QsoMVNA2riDvvzT8qMUKIQ4p/j4hLIQVKVk/p4jOMBLWToMBj1mw?=
 =?us-ascii?Q?XkjiS2l/+zKWeQgHyMWuptk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A225129D7525F44D891B963731D606CD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ic2AH+RYKGjtz/mG4XLhQ8QSR+SHe3CHXmhvhHOyJOBTBnFN/3gJwk+WD0PoDHP2OGpGa4jjSQCRgtiYjqHn6Inf4oemCevZD/aZQ6+Wz2dQTtTWV/BlIp/EFyamcGUuQ4xHNq6GYSu9HVYRD8/9K7Ttp5bbJE9xm7YDcoPLMPnKk1D6wq+JBHK1VSISVXp0YuCiKlo+SROIupNJcPIT0kFgqjC27/5feTa9jgPB1rWqxVp1DW5h7zoULsbg/igFzS88SzcAXadSPqCpqSv1BPFITy/gpW4x/zU4kpWnufv8fX8xzpQFJaLShcbMblMQnq0inV8VJgqG1NAdUAHNrDib3wY6/+8jZVWcupQucUrK0rYtajf2fSz6fSi6sUAEo1zK8DKcMsJg7P9xRucbhI4OKyv3ICftFHft49qdxyF6Fylt5BduGcP/nCDrYlK9tT1yiuXazE1BnVO6i/4RYv9kcQ/rGi7rDJGKkC1jDQ5CaBhrP5hY3g9EKQSN12lTxM605fVDEYqe9phAf+HoUVOennnb+LVBJT/ncEPNbmHok9WGkY5s2qJFXIynkHgMD4NC3KlDR9Jt4d6GGsIi68eD1cY+JLV5qeVFpasCYL/XBur4+UqSMXI6xRrAEZ8unH4s73W6VktKuwZLOAuWTsN/HBriXq/JbwE/TCUmVMIHP00QPlKSEHuydoLNInvV/+51NqsGt+b3TM8c3eRBmCUgHmhMFMRdq1scLCpIKGv6nZMLzzcpNjmGcoPyN39UyoQnw+PZ+/TDdxT/CYRQX+D6Q+FjsRIUL5QGxsmcabWNoSAeKMxq5Rs5T4HLKniQHf6LQKgSKSrZh+JeqmkUj5HVFpgLToXrMuSReAYKDZ0=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR04MB8048.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a4d79c-a15f-47b6-9274-08db0e221de3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 00:26:29.6031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78AItIS2sJGdXU1WHzCQqumj/kR4ulaYdBlLNSiOukpVB5HWR3XjC9ksjo+XDU3y8GMJfqh1FQk/aXWTniFQRFGPsix2fhF+M8Nzez8Msn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8569
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Feb 09, 2023 / 10:51, Sathya Prakash Veerichetty wrote:
> On Thu, Jan 26, 2023 at 11:35 PM Shin'ichiro Kawasaki
> <shinichiro.kawasaki@wdc.com> wrote:
> >
> > The function mpi3mr_get_all_tgt_info calculates min_entrylen which hold=
s
> > the valid entry length in alltgt_info. However, it does not refer
> > min_entrylen when it calls sg_copy_from_buffer to copy the valid entrie=
s
> > from alltgt_info to job->request_payload. Instead, it specifies the
> > payload length which is larger than the alltgt_info size, then it cause=
s
> > "BUG: KASAN: slab-out-of-bounds". Fix the BUG by specifying the correct
> > length referring the calculated min_entrylen.
>=20
> >>both this and the first patch could have been merged. We will do some m=
ore cleanup on this function and provide a new patch, we can hold 1 and 2 f=
or now.

I see. I will squash the first patch and the second patch in v5 series.

--=20
Shin'ichiro Kawasaki=
