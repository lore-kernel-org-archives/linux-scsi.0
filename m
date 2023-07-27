Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253F8C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 08:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjG0I6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjG0I6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 04:58:14 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C2B16C12
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 01:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690447091; x=1721983091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PsN1d+n/gE1qj4g5PsHrl1WhzpjEZCu6FsspEf2lNTs=;
  b=ByDhmnt0QfQ+X8eWwmzU3At+eEkpZ25zokVGehheqfg+JhRIvsQLM0PV
   qtqcwsEmbMrMHdpIIsuFI3V739xW8JWB8TzyMx8MRhJJWTS8fk1rYnNvQ
   KutmKLC5PwgTlIQ22JLRVHlfxtPuLO+KqH16kqJYU0+aYLHadyePWaZY0
   pcy8RjGbIFuDz82mBxr5d+wjlpZ6x3jMs+gxaDxqEoOLh9/kRZnVAr0Fp
   x986iWXjhNmfRmJ+c1qUU9/CwTlaZTv86usobCeV+8Egomaa0yDOStDfB
   qsE8vWuDmlFJKKKvGctNfHuV9m9k0+5FghgDc5sMxbnLa9AEjiobyOV+B
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,234,1684771200"; 
   d="scan'208";a="243860314"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2023 16:37:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knNmdtwOpKN885tsMMPoC+3wHZNx16+FCKhluJQNWCrLPJVw0yB0QBYNGeaXWzo5Ktylhc6yYpLho7CsocTaDlENdgsQeGNjlLhCNNbpoVwkqPjXhBlZJWcYYxD4XmCYpZlBmcRBO9IkBuNhPmhGAjer5CjJ6xI8nPafJu1giK4JSb7oDV8A5PUHgGzEcZPGD6wyjN6RiuBV4VKFnarMavymiVLXgrAApTp2j65rkKNF5sIf/vaFnZwV/KjW70REku2zWNaMQKMut54SwRhZR/t96iciB5SkVtyj39moFPiPdLi2qsAQqgHdCzK9dAsZb4H0Xk0IQH6RzQH+zMaJyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsN1d+n/gE1qj4g5PsHrl1WhzpjEZCu6FsspEf2lNTs=;
 b=cjYJmOIfbhkdI9NzZFEVaIpGV+HYIYC/lC/g9o6TPq24I5efPQRvKa6voBftvrzRajyWUnbo8RZL3VmEXSXLiyAL4TgxFKXVnc/WRAFNRtLH6AvTrJ9rk9nACY/u+LQ5Y0h26BjAlLl4x9s3F1egoCorM59cnTuz5VEqBYeHVYtMHoiGDtxXBnScWHoED4OkNvTNuZI7eb3mV9/+WuHJ25tUYw8VTk6Rm4gSMwIQ8PAWbyyIdeBsGZUV+j9qqGAmslTXIl6cFfZp61PUM8EW7pipZ7MoFg4Zf1sXtzdgxR0X2V6haTSrZVg9S4IqHhe1tnWSFMgP1W/EN2PK8b4Rrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsN1d+n/gE1qj4g5PsHrl1WhzpjEZCu6FsspEf2lNTs=;
 b=ictnW6IH9+qQFI1JDFNZ+M7Fim3rdPQ9WdaPVx7hMI3TJr8fSLvriWgM/YM0+atIn5OQMKB5Se5pqza7Hov5kaBFT4+Tkb0BG2LEFI68j2BqVMD8IjDRubgPU0Jdl29d3YECS+9RIHOlRcHEM9n2bRWuSmD7vWUsKqOEyT4WIM4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL3PR04MB7932.namprd04.prod.outlook.com (2603:10b6:208:33b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.29; Thu, 27 Jul 2023 08:37:14 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 08:37:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 12/12] scsi: ufs: Simplify response header parsing
Thread-Topic: [PATCH 12/12] scsi: ufs: Simplify response header parsing
Thread-Index: AQHZvm2YMR/crizeA0iWLRty6J89Ya/NS5fA
Date:   Thu, 27 Jul 2023 08:37:14 +0000
Message-ID: <DM6PR04MB657583428E0DE64160EDB314FC01A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-13-bvanassche@acm.org>
In-Reply-To: <20230724202024.3379114-13-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL3PR04MB7932:EE_
x-ms-office365-filtering-correlation-id: 2fe5e2db-7758-4521-8921-08db8e7cad99
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h3LHv+1D++IgauwJK0K7GSz4TJOcmAVal790zL30IPiDFAN6GPUSPvIEjMC1lXCG7aFYOEB7KBCkIRutpcvXbe+KgJ7S41ToUDoCaUovmEbM3wWHmovu4oamtLhIIc0kT8UThHNQ1R9xRdepQMgrt898E56GzHq9NOFBELSAxNdT1W8sYcOM5+z4AGYDXwLOJUSBhS0NL+my6wasXCawAzJwvDBUvJmjtXltjisldRtKNhlu5LhmpJlDU4OaaVf+oyI0SDIS2TOxbS/VuzB52+czolBiFRzbmz485Vat9mPh8E9FJPro55ehSvf21w2pb7EmSJ151IpmB9FBzN4bCe/cKFDKcZOVjSdevLQGJqeJ7ApHWHbcGgnd5vg95wL8caWIq0eVhC4MA57RtmJln3nv2VCAkkWDbB+SvbkX5cl9KJPRsaJRxcgF+GO2p+e326rx02LaSIkqzeDtDrAFZ5S2RF4uuyDHBUJUZJYbp5kAPhy0VBqng2eTSiFjo0E6XLyQqdPGd61NXwDrwIqT6IQuhvd2YrsIPyTVNFA32QlfhJEpct9jy3cuHt08nU6LP1mFWYsvnIYcmTEhoJbCvMLVq+zH8w2FdhIhbIZljgdKkd+Mqrxn6HJ+M//1x9dkN+RrurDms6f3Srz8try3HOK+46qbGj/GW+Bs1rjhoY0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199021)(64756008)(38070700005)(66476007)(9686003)(66946007)(66446008)(41300700001)(66556008)(4326008)(71200400001)(7696005)(316002)(55016003)(38100700002)(2906002)(76116006)(82960400001)(478600001)(122000001)(4744005)(110136005)(54906003)(52536014)(83380400001)(186003)(5660300002)(8676002)(8936002)(7416002)(6506007)(26005)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BYu1OMwfoMt2MJTUpbmr4q1eec9nZzm7I39qSCAf97XDXRZdL7kNZWqnVZFM?=
 =?us-ascii?Q?rrXnhRTPaTL43Zs3pb7eDXc2jqHgP9GtfJf+jPnfOPJWdkPMbLfDoQMSZllN?=
 =?us-ascii?Q?U36f6kliRJ2FWhH16/jqyEJtFqFw3Cn+T2ACx7aAPlJgSZ7X/ZS7TMumprSb?=
 =?us-ascii?Q?Ep23hWGWAk+abPDeW4NtxEl0u0pSBjmAON9gh8mfN/2fOSX9l4nMXTcAQkSa?=
 =?us-ascii?Q?2lIq/8/1C+2Yc/HywBCO4tFQomLqe9Yywj5U5RdQ/1xuFrKv6hJIiwjqDVnf?=
 =?us-ascii?Q?Kx1v1p9QpLC2aULchrbJW4QGrXa7dE6XOrFtut+0HSstaEKWXYCYnf2L+2pg?=
 =?us-ascii?Q?gfd/NxTWsORivkXwAd9TPeJP6LuHmudTv9sQzGlzjHFaxr8ls/dYDTljBxxH?=
 =?us-ascii?Q?4YoWBbvBzmQ3snHpeVc158feaN4Wd7wQThHPFQGVDkM+J1FBBc76Vr8pW8ws?=
 =?us-ascii?Q?Z1UB+1mlANNFi2U8ctz93x4bqOQSya5WwR2haW0sfAVoezIatw7N+265+j4U?=
 =?us-ascii?Q?1aPtWYwQTGdEmQ7V3Jx6TXH2NNMb+BbtgiFNXRsOy0ZXDAEkjGbLBlMMr1Yo?=
 =?us-ascii?Q?CcVXofpf/guvgVnSZ0pIscY+fAXAxxIKPOMN1pc2Kd7cH8k6Tcl8I6z8Wly4?=
 =?us-ascii?Q?Uw8mJhL45QspAiSBcGo/FeBQ0routSKimh7C9Ga3sbO821JoXlVS94/dTdpr?=
 =?us-ascii?Q?2aiWnnnTm4bo0SUY5l/YuqFgHsPquv4m1EqJjQN6/O5WZMZ3GNOqmWvIY6jf?=
 =?us-ascii?Q?DrmbgD2KmVZoNVeyelNG311GfGHaK/cNUzyZDHe59RkjLLlzmd4PaS9k9c5O?=
 =?us-ascii?Q?EmegveTEaz021FFkDBJVdbl5hPbcP857q0ZydIPlnccRdJuk/iaXF29FpzKS?=
 =?us-ascii?Q?U9jMq0ueX5IsA+SO8PLa1Bnp3uEO0K9SEsCJgtF27aCC0+MnaWzYRckBAX9z?=
 =?us-ascii?Q?lpL55n/xI01JgIt70WBNFA5YP+zXd+1WiVYmR9EssC6qoTeFpABYLD1YzU6f?=
 =?us-ascii?Q?0SYWtSAbZ1eTNCW/pR8oV7W7xh0EXTWyVXRM1Elygmc13eG4PwATCmssEs7r?=
 =?us-ascii?Q?ELzgqQYcgFVamVpSmJfhdQnwuifchszG1RTPEE9qpjPolXAeroU1WhwF40Ik?=
 =?us-ascii?Q?Z+lwnVM4iJMD4/jkfekQcUkV5Aq3nV+t29musVCFdPYYo1W3F32laefzrII2?=
 =?us-ascii?Q?bLtfguVQNDdz+ZoS3HtLbzaboDz8fEpI5XwaLSismtVIjOGyAL0VvKEbybF1?=
 =?us-ascii?Q?jIu2nKcjqvGEamU0YVvrXfTlAZTbpApvsOQIDL3cR8CSq+C6KLOM6COU+OaZ?=
 =?us-ascii?Q?InV1ilFPSOX7gm9qKX2SAsbzW5A1T50Xs+suM0pHX6crLoOWZgqAuLA7mmKj?=
 =?us-ascii?Q?FMlL7Fa7RdtUecRg2NGU+B2rlxBbf+qoWccMcClxVNW9bjTh6Df16ez2M/1g?=
 =?us-ascii?Q?YaQBAXGNJvL8cIru8Uq3X7y4S26RoR5VKE4v9TMFJRxD5a06yGB4fymazaOs?=
 =?us-ascii?Q?c6wE6bSSS+ejiW0X5TMYHyU+6hKEGibFhWZh/5Wtf8XQbU8p8ZsyPdDaJ5De?=
 =?us-ascii?Q?VhJRO8VxGnUw2AcNLh9O2z4oCV60jgsrJCvVfolH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?S50I3tqXDgsdvBKMAo5y1B4yrRAnUVhBQBAYojBfta5OcYUchPManJFLXYjd?=
 =?us-ascii?Q?UVqa1QDZB5keOA2gokn2oZPSWzqR6JnqMDkvBJ3bwC3x75nsGaP+J8ogWDw6?=
 =?us-ascii?Q?ZjOGOgFdSagRLbdMDDLEgZbxm6jMXCDdtBUKfcTY8ISut6Gnlco+Q0Q0xgW6?=
 =?us-ascii?Q?RlU8K9enjwXAXj1jEsZWXbwMBP2iaT/x2Rprs03rFpOpW5K/441FHpUobK8l?=
 =?us-ascii?Q?lL+XI3Hix+5l5hHamkzeLgZmLTl24UuWtlQ3/9/O6+KFTHd0TMoRmr5ZShu1?=
 =?us-ascii?Q?3UzTKGN5kzlEDtumfal1TN4+F74sEZwf2LrBDTlwOJD1WzK5R6sOdfa/1mEB?=
 =?us-ascii?Q?qvKWVvATg6YrUQkN+uH1AE3yjDdlsd6cDqAw0XE1C89ooMyzCC48B136+ITh?=
 =?us-ascii?Q?Ru1FE8RAYSk9lTweVvgnGmudcNnqkFdVvdamvhWMAExs6tkHjOZPB2WXQ33O?=
 =?us-ascii?Q?JU6w10YMbRZmOf4NL5Et6NFjGlpw3ZP4DyHx6G1vd51Echp4zahVFresYsNH?=
 =?us-ascii?Q?k0QhMzoLnYy0ikjwL22OJs9MUzQp7E4S2hg/ZvqORffu94+1obj+sjy4CqT5?=
 =?us-ascii?Q?YnzXvaGKMg7QZ8k0FzCrZ7LE7kytNAOFtk2L9SyavrhNBGJ6PuoU7rXtmFDV?=
 =?us-ascii?Q?f2IrkZFrxgjLjwADtz9/rv3rffMStzpdKdeiFp3hw/x3VEWlDWUbc8p4Z9cr?=
 =?us-ascii?Q?goSmmYzxGEow9q+fwAsH8i06xacve7gD3aC4YV/vKDKcyj6EAHZwb738jQf7?=
 =?us-ascii?Q?XkXiO+K5ub3yOW9uQH0ZpvProo2fxi2Tb7DDEVGUScqqdsEoxOKoxtivzj+/?=
 =?us-ascii?Q?21V+4KLLLzeLP3BKw6EUkNRu9EWM9oPTy2uQTZP3VcBHQbIIo+7Dir+uzY4J?=
 =?us-ascii?Q?4A0h4LNIXpdqiKJhfrBnIhLkMNrh4LHNpSQ3JRbSu50DyU/y+XJkP+suEzny?=
 =?us-ascii?Q?7aIQDxD2/NOwkJuuKx2mbfEQPUbrCewx8W3WlubK/RANQ1J7i7ve7vtYyzMA?=
 =?us-ascii?Q?hx51oxIOpJgj7nTGlTeRqAkRpKsBcLOOJhYJI/nzg8gDMJmHo/zE/puwtfNn?=
 =?us-ascii?Q?6zKKoKvj/8qcP6TNkGgbfCmfcRjfOwksdn88X0PZYvlKanIwyQY=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe5e2db-7758-4521-8921-08db8e7cad99
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2023 08:37:14.2300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /c7vdJuhm6m2NqTc5NsbbA8Bdy6z9akIPDymimrjs3xWiIs8F4hgs5Q4BlyJwFYw9LWDk/zCi36bKN0y4+DYqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB7932
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Make the code that parses UTP transfer request headers easier to read by
> using u8 instead of __be32 where appropriate.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Not sure, but there seems to be few more places where you can utilize the n=
ew struct,
e.g. in any other place that uses header.dword_x.
and in QUERY_OSF_SIZE as well.

Otherwise.
Reviewed-by: Avri Altman <avri.altman@wdc.com>

