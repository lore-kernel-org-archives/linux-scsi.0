Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726DCC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 06:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3604C61287
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 06:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhEMGMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 02:12:15 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27007 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhEMGML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 02:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620886262; x=1652422262;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=H/5aaXKs1rqkHdAMd+mtYbf+7jLlIes5/VTKqJ5yGo4=;
  b=d0wlMqNeQbis31WMaeDi3K2qTbWVuFDPTFZ/KlUjOz0VjzBBU+d1983c
   Z0Tr/V4YKgw66EurRlR9gAn0Ev7IZBenb10I+ni40UBKt5YAd0O0BiKOw
   PnnyaBKuqkE2HtptFTzZfZLtWm3/bZBeX6PQb/uGiwlrYCi0DCzXtqckW
   VqWjeiWZkbbNZcBhH/HFg6P/+oZEpnCJuKnMMAAqxX4ipdC4fXQf15xDm
   yNRePNnUvdCAAREPLeP68N85hptF/X/RPW86VLz/bld9qxhmrXcEdm3s6
   Hw8GT4gKpIpfRXwvDpzHFA3fd7g9aeCutjXtCIvbaqWupHryoPk9DbiSe
   g==;
IronPort-SDR: Hy87sfDWInPPbBGf1efm+CTWAy+R9RPvYSh464KFKJwxylAgTmWNITJyjcQ9o/73SDqQF/du0E
 TKvDx2nNrdtzPdLYSFaGoIROwiuY2ZCvhpxEg0kwaoXJ0UCoBH7toEDSVxCjE6uidWh5YFaEBk
 aKYpbr1pzpXOjNfhbvT8i0+yLJkpC39MxWnznqahdkmyCqHFDn3TQVK27z635OSJX6jo2xA1Ck
 J4RDkdlpZQlglxrvP9v7G7wrchkEx7MvDZzUfcRtCDwnH2akIi/3c5vqkuJimKSU+HdXNZesIX
 Ra8=
X-IronPort-AV: E=Sophos;i="5.82,296,1613404800"; 
   d="scan'208";a="167326336"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2021 14:11:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCby8hQGeQYRU9DYJ8eJ3Z6jXVSVMjl0hsEIL3nShBd08b395l5cKR3eD1fvOLFd87vMtOoqMJCCtBfYYppk1hQ1c1SVF6plvs/D2I9cfznNbYqYkBGTbN6U+eQoolJK0IX2n9F0G7UJvH+3hBL8HddXNkcxYvf+Iy1bKyuKPiqgCL28zVdgD+sKreAgWL2LAfHW1nABwYhhUTZChpD8BOL7WtBLiG6VpX/bezp87TSaH7zWbJrvuAWyjt6yd50WnzybD7t5SZgWbV5+MPKO/F1SUdvXx6iIy7KRJDTLd36pakXaeGQAQDbJ53Mo9YB7SNtCc6Wz829hZB655cOlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JuSl8yl6zKH0Fp+4/eV7FLAY6WjCKCKBuv6RucAtMI=;
 b=fDYeR6tD6pizNzlcGMZCkqgWVID6s4WVPOhBddbar24WcO6d1nHbyoxDUbAjAmVsdtlZRuTrt1sKjtRJp48QaqT9kfRGqZSoR7Pv8BTcz/65XRVbGvAXng7za4NWU1Lpgz7KMr9ywBFDbTUCYHzAyQm+Q0ZyQnDkqy+ku4LFwl8gcWsLRtsMyijxfmaSrG4h2TIRrw4yqU83YAH+AFJqdKEDSBOOXIuv9NCH1U5DiVpFFrirTLy5w0CQGAj475Tcp74uFhu2yhubnXpDMiplERQze5CRJ6K+RyuK2SK3qtQ//+5firN2kjGaeEVHF19on0bxw2tlqe3Zcw2JBWPEZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JuSl8yl6zKH0Fp+4/eV7FLAY6WjCKCKBuv6RucAtMI=;
 b=O5HJdtpCQKRvzdyWrS5XhndeIcyJhgEEFXjzTBKYO2mYrsok2fW41sKlOyhvewbhfKTfIr1D2a+7/g0D2ljaEg+6JYfomKUwKPe2XtLSN2CROIueWTqk+0f2QgRISVSbVUw3qEILFT4HMzLrAqsTxQTA3DooorLFfPS15MZkvQk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5242.namprd04.prod.outlook.com (2603:10b6:5:104::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 06:10:58 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 06:10:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
Thread-Topic: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
Thread-Index: AQHXR3kgi8EHa43bd0iJGbipmimK0w==
Date:   Thu, 13 May 2021 06:10:58 +0000
Message-ID: <DM6PR04MB708144BAEC4BE9C5EB052866E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210512200849.9002-1-bvanassche@acm.org>
 <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
 <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
 <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
 <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
 <0c2d87fde65e40f34914e7555d3971f7b2c8f28b.camel@linux.ibm.com>
 <DM6PR04MB708186DD35EB12B26BC9CE60E7519@DM6PR04MB7081.namprd04.prod.outlook.com>
 <e7f37452622d4203f7246747b858f94a5e53b664.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dbc:763e:6fbc:5b5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f6b7cfe-9e90-429b-59e7-08d915d5e02d
x-ms-traffictypediagnostic: DM6PR04MB5242:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB524284B9AF0AFFEC3773A9B9E7519@DM6PR04MB5242.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pgY35T2CiImGQurSy02VcSxUfspArYhxX7LFFHuPuzy8HFFxcM/Vs9RL9U5k/Iwd+GBetma/mrnNTLCuc6v5y5MstgZZ37E7okYavabrkbjWWlgxYUCQ16ZiROdXcat8k4iUw/PraSWEtTQJFHwDpsw1Bheo/6fRb0AVKGE2N0kZQRpXcQnYss6l93f3MrGciOg1o3P4y6sByP2mAy5z8ui1UshKOHUuWxkw5aoFfFg7kXUBFhlXXFX1HPbXhhVippUpCgMtj79xYUGhoNXu291nEFxk26RBlMSN6VJ1J0h5AbTyktArcIbpyCGPz1S/FqUqeHJziNTPQ5dDomZjSWE3tdwDMyC8mQoQhivmRwmQ5xLDiZ1oeqnSluAKDlK0Xwp8zPJRCm9Tme39f34XhH2/5Rpbuk21r0gDZ+k7ds6kZrZxzpiLQkMgBWFNKm1qqLg+U6HJMi0GpYzVlENd8F0f/qcG57DIznyyCyycYM5vwyNd7rz9HA2tYNcJhAZR6bh/L+1KDyN/tYUvQhnaSoUYEQDBY/Tv+w/nrxfsR2IoIiEbZljgZX4uc7+PcQAnC7OslXWAyNY9y6ZQpxs7r7ck1/NKBJgJOTevoSsiMeo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(5660300002)(76116006)(33656002)(66946007)(91956017)(53546011)(316002)(52536014)(2906002)(7696005)(110136005)(186003)(8936002)(122000001)(6506007)(83380400001)(9686003)(71200400001)(478600001)(66476007)(8676002)(66446008)(64756008)(38100700002)(55016002)(4326008)(66556008)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ufWp+0MhfScR+3qHK3pNtIevyg9756qBQ5bAL7/1iwnyL3p5xqzvl3LqRjEf?=
 =?us-ascii?Q?731Q5mmiShPeLVxVyNbLCMKcICkjgn6u5EsPWdUWYQFtROyRPbaDUYfmHAWp?=
 =?us-ascii?Q?s0d9d4/xo4Y6VjjvUsk1FZWT9egBBIQ2jQWduw5/y4yqmdd9WK6C2LZJIHbS?=
 =?us-ascii?Q?WQUtJPNZgN8++QuOThanTQ9sIWnvetR73cdC9fqLFqxUErf8Wltlwcc8Gedp?=
 =?us-ascii?Q?KbXXWRmdItjdwz+4/OL3dM0l2NWAs6xTpCqzNOpsQUe0y1eWHX9ZxBLidsDw?=
 =?us-ascii?Q?QoDxeg0LmADATmhmCKNidocy2V28XjPcQ+goFMkBDFdE2NXOpMv+W2zhMNVB?=
 =?us-ascii?Q?fr6WdvEt8sNbVkPbQljuqs3p7bBmy+PjsKwCQJ9CdsMbsltj5DTxHSd7tnuw?=
 =?us-ascii?Q?wtj6F/XgXPtt4A+KeCHhRkmKTkJ5+CG9hJldTn9BSDBfiUREx/LBmSCOK0WE?=
 =?us-ascii?Q?vu0TKjck2eOotsU3zHh7bxNTd+i4ZUkZN8GMTLEeqHMoetbLbfNizXHkfafJ?=
 =?us-ascii?Q?fJinxT6ChsXhB+EDoLZHoyOy9QQqvJtqFhVs2oASODzgTjX7tzmTz5LMcL/j?=
 =?us-ascii?Q?3cRDqpmfEiJrphAsnQVyyUGhCb7nm9TI43wBTpiiZlIO4b1PQsbFGcA41u7Z?=
 =?us-ascii?Q?oCqusAIfpv1TECpmimPDUwkr8l6w7QZWVq/6HakPetKcvA52oOtxHedeIr0+?=
 =?us-ascii?Q?RgDw5KoUO15vJ2NAj749nC1yGcmGQKEHaYRB55Vsiqd9oblOJHKXGqOwLCFZ?=
 =?us-ascii?Q?D4Dl54N8JgA+42Lvr4fZeprJXRS4ZVwnK3tSppFDiEgPZRcqrrtcWE1vf95V?=
 =?us-ascii?Q?jmhA1HZZFivaBAUxQlGZTTRK6fyAP140IyCXsd+CqT38Jc93T1OhLmPJSvIn?=
 =?us-ascii?Q?3hN98quOs0vs1+GDmzzHDsAUUb/r/IGSntnyl8fSGje2LArfe/7aSeUlRV4H?=
 =?us-ascii?Q?9SYUlTFuXweYbtggOA14S0JDxtXTG0/rXNi7cJRcH8ZygF7RbcT9HckUNK5H?=
 =?us-ascii?Q?tfu+vWBOa69fx9NVOazuPLFo5TXS173XpK7FD5TT3A0ysP6iHnYe6Zq02brp?=
 =?us-ascii?Q?+y8ZEF5qxZYzldHECW6I/uMUHGeRTsT51iakuO9638NrpTrPwbNqbQ5il3NI?=
 =?us-ascii?Q?7MZ4jDz2uj8oUoDghhYTyRc2TNPUcRz9CxAZvL6DK/Eb4m4Or4EiPUfmc4XF?=
 =?us-ascii?Q?G3Ctp/fYCABdMzw7EPg94BCOwAYT38XW0NGMzZt3bVXtBB1d1pW25LN6HwAX?=
 =?us-ascii?Q?DVAjRnLhSvt9tT3bgotFTaLuUa6Hvld+HTtzHPf57WlErU1y7wi22KRLE3qu?=
 =?us-ascii?Q?SWOuB6VUEebjlmk560AYn/F9mAjCvs+lNjpiXKhbwiJOl/16ZNiBidrw7K46?=
 =?us-ascii?Q?xQamP6PglUfbK7ncBL+3tcPwrGRQ3XekTiBMpeBrXDDXGLGaVA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6b7cfe-9e90-429b-59e7-08d915d5e02d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 06:10:58.1572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qxs4y7XPgWKLXI2tL0fzBBOGNWssEk5ka+SjFMbYZ6dIW/sx2BN/mUdofo8WQrb+qQocnzcDwZHp1aQltNIYtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5242
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/13 14:42, James Bottomley wrote:=0A=
> On Thu, 2021-05-13 at 02:18 +0000, Damien Le Moal wrote:=0A=
>> On 2021/05/13 9:14, James Bottomley wrote:=0A=
>>> On Wed, 2021-05-12 at 17:00 -0700, Bart Van Assche wrote:=0A=
>>>> On 5/12/21 4:23 PM, James Bottomley wrote:=0A=
>>>>> No, we support physical sector sizes up to 4k.  The logical=0A=
>>>>> block size internal to the kernel and the block layer is always=0A=
>>>>> 512.  I can see the utility in using consistent naming to the=0A=
>>>>> block layer, but I can't see that logical block address is=0A=
>>>>> confusing ... especially now manufacturers seem all to have=0A=
>>>>> aligned on 512 for the logical block size even when it's=0A=
>>>>> usually 4k physical.=0A=
>>>>=0A=
>>>> Are we talking about the same? Just below the code that I=0A=
>>>> included in my previous email there is the following line:=0A=
>>>>=0A=
>>>> 	blk_queue_logical_block_size(sdp->request_queue, sector_size);=0A=
>>>>=0A=
>>>> where sector_size is the logical block size reported by the READ =0A=
>>>> CAPACITY command and has a value between 512 and 4096.=0A=
>>>=0A=
>>> That was for devices from before the industry standardised, which=0A=
>>> are getting harder and harder to find (In fact I'm thinking of=0A=
>>> making a NFT out of my last 4k logical/physical disk).  But it=0A=
>>> didn't alter the fact that the kernel internal block size is 512.=0A=
>>=0A=
>> struct bio and struct request use 512B sector_t unit addressing. So=0A=
>> does the entire block layer, file systems device mapper etc. SAll=0A=
>> users of block devices use this unit. Yes, that is fixed to 512B,=0A=
>> regardless of the characteristics of the target device. But to avoid=0A=
>> confusion, we never refer to this as the "logical block size" or=0A=
>> "block size". We use the term "sector" and reserve the term "block"=0A=
>> for the device layer.=0A=
> =0A=
> Doing a git grep -iw lba in block will refute this.  I think the=0A=
> partition code still uses it because it's what most standards still=0A=
> say.=0A=
> =0A=
>> The logical block size (the unit used for command addressing) may or=0A=
>> may not be 512B (it may or may not be equal to the block layer sector=0A=
>> size). These days, most HDDs are 512e, that is, 512B logical block=0A=
>> size and 4K physical block size. Lots of SSDs are still 512/512.=0A=
>> 4K/4K HDDs and SSDs are gaining ground and spreading.=0A=
>>=0A=
>> I agree with Bart's cleanup patches. They correct a non-standard use=0A=
>> of the term LBA to refer to a value using the block layer sector=0A=
>> unit.  Bart suggested scsi_get_pos() as the new function name to=0A=
>> solve the confusion. I think that using scsi_get_sector() as a name=0A=
>> would be even clearer about the unit of the values being handled.=0A=
> =0A=
> To be clear, I think that using _pos everywhere is at least consistent,=
=0A=
> even if I think it's not very logical, so I'm happy on that basis.  I'm=
=0A=
> just not happy with the attempt to characterise LBA as confusing since=0A=
> it's been the terminology forever and still permeates at least the=0A=
> partition code in block and predates the logical/physical addition to=0A=
> the SCSI standards.  Just say that for consistency we'd like to use=0A=
> _pos everywhere ... or if you want to use _sector, that's OK, but then=0A=
> update block as well.=0A=
=0A=
Very good point. The block layer (despite its name), should refer to "secto=
r"=0A=
and not to logical blocks to be consistent. That said, the partition table =
code=0A=
is probably an exception since the values in there really are LBAs and not =
512B=0A=
block layer sectors. The code though should make it clear which unit is bei=
ng=0A=
used. Will have a look to see if some cleanup is needed.=0A=
=0A=
Thanks !=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
