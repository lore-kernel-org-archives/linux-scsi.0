Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40086CE79AC
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 07:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjITHV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 03:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjITHV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 03:21:27 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1901CF;
        Wed, 20 Sep 2023 00:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695194479; x=1726730479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a1ZDPy4HWfyLpWr/oAu1qCfU/F4wI33S0AkeeBNrg2A=;
  b=kibMYU9zHWGexkP+YConRhbWC0ziJY502ZCs2QLhM52OTWMS9C45Vbxo
   3eN/yzeIpVgISXNGfhGBSAQV2KKITq6TdhVpCBw3PDFUHA/pPjm6YJ8In
   vPnC/UMguuASL+GdtuAXgpUUBVY7jtyvt29/B56u+/qrYbTPIJwmthsIu
   ONiaokYLZ0xlQHJeOIANVMi95jV8oWFd2PFmMu0zCaeLUO6wB/Yf585QJ
   mLEeOJD6afoStfCbu0LhYuhF9XLvdn3fYgK5thWQpKCBjrpUvRF50lDg5
   8KpJ1mj+Wy5PN0Z5bOWmgACI5lVOCSw/sxTebYYjMLh5PfZuMBXYaM7P8
   w==;
X-CSE-ConnectionGUID: RHEHTFnRSq2dLWs/TBemrw==
X-CSE-MsgGUID: LeQjdrFLTNKhUFBRJaeXxQ==
X-IronPort-AV: E=Sophos;i="6.02,161,1688400000"; 
   d="scan'208";a="242606242"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2023 15:21:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpObqsCEaahQ9s+/JoDTnBVann6ANXWWGy4/cEhyDbXOm1i/+5strjMC3KV5wH/P0sy31Odzz8kmm6DtriXE9gojDGIzlV7kBJhajL5mixnQ1WifvxnLXMRJNeoH1YZcp8Kb5fLoU0ZDoFeLFxQYq7grGvZWf8Qk4/y0d1Aa4ljElODGedQxyWVTVsOBkxElCWnn/YpqZWGQCPkyEl4gAfrn5L0Kn5HkPz2EavI6fHwsS8kVUJw/kebJfcfNvEre44FycNZf7E9tkmW7g0b1nHt+UtCFVD+1nkCsobQdE5Vaoi00k9PCMRsS1AMRw2VCFtkO6l1A/pDKPaMedy6TbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OODAkZ7Sx6ur9zGJizd3p5/IdenmO5h8TKV7c4x2REM=;
 b=N3+wK1BXQp3yH8JkJcfyrCeOohYDomQadg/EZR7o6OgRr4XnmxoK4z2qhuCVxAAvGtduRSdSlywX7Wdx/E966ZUP4Ol+XTArDske0KFabfRvJxlU6Kqm2yu8iAJh6vVQg8sqxhJw1HKs+sgekwagPuzgEVTwqe0Lu9WZHTlGXdp7dhNCzmoNBZNa7c/2eYmDw2WBqV4mkWbVzP5n/yFhbyDRaLYI4A4rGQxcb4UoE2V1EiPzn41mJxr/oiOmO6fNqbHrq93JMsrmKf1svkdrbqHDThvYa9E2cfvqxnWM+MuyY2Vmf8D+PODJ2RKGhPNsKe9l+Ghz67aHP9aYyi05Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OODAkZ7Sx6ur9zGJizd3p5/IdenmO5h8TKV7c4x2REM=;
 b=WHVEE8uP2Rp5Cl3sBbs9O1oXWIv93gn5dgcR6K8uaOUVZY9Y8mFzgK4r+f453ERX2vWaQSU0O4wiVMOC8YlCkdF7sBOMUfUEjMdy7zPFE7+Em3JLUppRRE4ZBy1in1BY4UJYdZtaD+5YtqVHtUGgTGiHI3C4xvzdgqwkUAMOetQ=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB6427.namprd04.prod.outlook.com (2603:10b6:5:1e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.15; Wed, 20 Sep
 2023 07:21:14 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Wed, 20 Sep 2023
 07:21:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v3 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
Thread-Topic: [PATCH v3 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
Thread-Index: AQHZ6vwiQHlkVB6riUOWXMTHHztL7LAiV2UAgAD4tgA=
Date:   Wed, 20 Sep 2023 07:21:14 +0000
Message-ID: <ZQqdap5Q3ky6lV4p@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-2-dlemoal@kernel.org> <ZQmgNUCLV8rDXg5I@x1-carbon>
 <0c2c5b5b-85b5-89c6-5d62-c4d3a029fb2b@kernel.org>
In-Reply-To: <0c2c5b5b-85b5-89c6-5d62-c4d3a029fb2b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB6427:EE_
x-ms-office365-filtering-correlation-id: d0fd6f00-65b6-4432-c8d5-08dbb9aa2c98
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5/dUxB5tYDZhmoN8ld+2PbJOndJzWqlrJsMc5xJJPnDCM56pnQuWP2rN5Kp1hgDCLDFskfNE8uOkrXRqIXg1ZYiGwfqVevI/uDazLYIc36NaP62tBEP2aP0Kvu1YNquYgPL55bmc0IFcaeoXJ0VFwzoWLoLctOYznXyLS1g/E+SXsXPxjf6FxdHjTNbIpZ1aRgccGIopcyUA9V/33z3/qpJ5wVK7NFI8mjPIfOpGvQCQBTJLqCGr1pPOCXRbYh+XhFII9XJ4hDjDQVtTf5G2KIAkUwmkrSLwBDDHo9hTiRdYpEHjvYPhSFD8EWk467+X/FwWqTx+BTPL0hqPFThmvGq1/eIrrx6HBhiLyHa+PMfOxQNTQFmBH9bmClbkcPKvU0nU8Uq7E1KSeTNJtlp3Fd/TzTxqaL2RLVPu2+8gHcAkSeovW7achHCpR1Ci7IlOHrjK5DAPgJ+oLXdNhQo5yad4qyrfFYn852kX8ZuQTqiw+2Oixzq0pXxM0F2fbYAMyDPikl7w2Bufo8xV6wMQfOp3TFOFABIzi8coNOvBINFQH6CECr33WmznhDRnnFlwOvduewVC3JQLpbV6iwbex9CV03hemd1CqfO6nEwbnXrvGzRbl5ucdNt0qpVdG+Ct
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(39860400002)(396003)(346002)(136003)(376002)(186009)(451199024)(1800799009)(41300700001)(8676002)(8936002)(4326008)(38070700005)(82960400001)(38100700002)(122000001)(54906003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(91956017)(6916009)(316002)(6512007)(9686003)(83380400001)(478600001)(5660300002)(26005)(53546011)(6486002)(71200400001)(6506007)(7416002)(2906002)(86362001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?90NvLBzzG7wW5reU268jPT/8wG95v065d282RiWrVSGix01kvBQ6Tc8tzPKN?=
 =?us-ascii?Q?h5W+EgoPpHm+R7VnB4+13tIbpexQIGHeYl11nOGnbPsMhqEBfUe1qW6MAUku?=
 =?us-ascii?Q?swny8ZTv2AkZLK1pQ/xrI5EWCEqT7ok/Rr8v/YxbYCOK//oVR668k2+Syf1f?=
 =?us-ascii?Q?Y79b+6OEI9skFb3hUP5gR+8xSl9ApXCJhsb8tWAbLJYJ76zpW5x0i+RUtJyD?=
 =?us-ascii?Q?iUs6GYUPZJ7jUEmFdn17uNUfIkQE8I3XfD6ITUGgGg/mYr5h6pPQxSqFm7Eh?=
 =?us-ascii?Q?xc/J8aWCYFLG8D8DNWoe/nGACSvbsl2lIf1l0/FSGOGdiD9Iwi7YQujWPOqJ?=
 =?us-ascii?Q?M3T/lBorZ/Yx65/SayHYmuQ/Jzg9bz66p9/LWbu6WqHdgAJWyBgyQzvt5wN8?=
 =?us-ascii?Q?e/BvL3SDN/way1TDm7wq6I7tOEpC+c2ZAJ+vOo2fgV9J6552y5Eg03QwaZYN?=
 =?us-ascii?Q?ALS7UEOTkPxfBRjWBqOVTkxUWAOhtVhIGont1xm7Rrhd2d0ZgvdpVPt3+jhe?=
 =?us-ascii?Q?cLFzwgbXvsRc8EJVN0+GKnq9w625wTYbS6hYZv1W/xeZOSoXnR7FS/syhKMp?=
 =?us-ascii?Q?0fkoYrnlMKJm4tZOe95sMCMDlaAEpban/viitdUCmIYPoUyFJ91MYOIzgzFT?=
 =?us-ascii?Q?mwTolFwGeLqGMgzfFFyaN+Pt8bGnQh66se51Ci7G7uI661SVDj1CDlgaDT3O?=
 =?us-ascii?Q?omYqo53GNA8RaeTrJ5z4WFw3emGQa7oG8Bwjb92q50LwoHmXi794XB7GtT1J?=
 =?us-ascii?Q?RRL2W8ekZdmdyBeIaGNYwskoMWQFHNBDDBgUJdydFtqmwFlxlx9WhSptANES?=
 =?us-ascii?Q?bDSLH7RdJdAxaaIUAXgtTLwSdr/5gS1tGhjYyP4Qz3s2rs7FgclQpW9VFUEf?=
 =?us-ascii?Q?HDU5H2uCdcQocN3YtEFk99krByLfckRZ1EdljZhs2ed5h2HSUwau8NNoAQWb?=
 =?us-ascii?Q?peW7O6XaEYSgIzZri61ZIQyMYq8W9GrC8qhvA8iaXQJ0NcGa0Z6wBWoT6nBc?=
 =?us-ascii?Q?mGz6wav2lS1idFCSsCE6koD8kQ9SyvRsyZVaLH5Zzjc6zpzCpa/xkSdrAhkf?=
 =?us-ascii?Q?1EEdbQhw1qvicQuC47TG1AIQEQHA6UISnSm/x4SPvELd/gRucagkmsf/rSNl?=
 =?us-ascii?Q?0CNWvpf2VCAGhfkH80PgGu/A+FcBikWhw+1lW86Dpb9DGkjC0ubHrYMtgHjx?=
 =?us-ascii?Q?1GO7L3cGIwU17gwbDXybfd5IoCYQQd9FKYcoEPS1t2beshWhrxJjUJBq8BmI?=
 =?us-ascii?Q?NDwnBhWseCNxWnw6hUVUoRCQI9Yni/4UjJdDZ3trhzRDFWbUJeQHkoB9INlQ?=
 =?us-ascii?Q?A2KgkK8MrfgBduOG5x+v0pdaApALfYmaG8HKnUvumNxQUbpH5MhcJbae9B8S?=
 =?us-ascii?Q?wfw+lOxKWNuXyyOzcUifZ1EiNy+B/yFts+BooOwsPURW+fkTKKt4Zu1VTBFN?=
 =?us-ascii?Q?pm5QBznGuayV1WV9+T0DI0XMs61r0BDY2isUp+k9GElj6gG1o0C0AVchAj5H?=
 =?us-ascii?Q?3qYUJcCdYzQt1SK2EhzLXFj4LRcY66IIb4tSw7gLITTMVtbCkqXg3DIQ9SeZ?=
 =?us-ascii?Q?JMUqtPD+A0BDRKnumRGz2BKemF60LXwMx6BiOscLnc5PCO4+YqpuR/Yy0Gpm?=
 =?us-ascii?Q?0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4EDE1CB14E4B784C92C805846BC873F3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9yXocQSTVVolsrUxl8xWAdAayPHm6Qsm5gYSXZuFN6NaibGaJOASXN1xYbeH?=
 =?us-ascii?Q?U4gY5YpDMgU5peNNn33OSviDxXBBH9NOuLXb9xgBOB/++M6Z1rLLXvIWQHBH?=
 =?us-ascii?Q?nG4KfSknqxIMo2CJShfPUt3Hc3MIOl3EJ2DdeCSUpyuLwFgy0d8f+p2lBU4Q?=
 =?us-ascii?Q?+AUYbX8m/idoS/vXpzrBrnclMczpDWbWh5DVZouxwQFiE2oO0nL4huVlbKI+?=
 =?us-ascii?Q?GL13qKkLHHdhjlFaFCJ/pb6ZPFGH6TGme+wKsSjbjqUt/WxMkPXt2Kj/1v3U?=
 =?us-ascii?Q?bBMgjphNkhfjxWGInIoUDN9q9HPLmN8eAcpOucWZuomPHrJRWHZRAMse/5RS?=
 =?us-ascii?Q?EmtvvjE+t0xDRLeLchprK58kEy2oApRCo/LJYL3gWZLCQxynoLlZijl9Rzla?=
 =?us-ascii?Q?GmUQQATBVzMSot/8aqFeQ7Ym7/M5zNzsEK0dskm+WHuOqeGBLgCcSAgfSB3k?=
 =?us-ascii?Q?1RfXs0I43kHkRYmovGl/7PvaO+RhG/jab0oREFIlfa0kowF5Zragi7blP0x3?=
 =?us-ascii?Q?cwq4+FJiUhRvGMdapuXDOMlqy5HSXj83Rq0smn10zVD9ObpQPSxNP/PTLWAz?=
 =?us-ascii?Q?Ybnw8deQxKa9HyjwniWPO+1Kui6vSJjtNR49BDvA+7DHDakM0Z7dr7BLkzSs?=
 =?us-ascii?Q?z9CB6mcLsnCEytbV6eHorF0gjsozIntMFuzzv9m6aPnp49XRledjGr3zDvGF?=
 =?us-ascii?Q?VWeXlYWHGVvDBZM/QU1nEXz0FbxKfVLGB+wBa1WEnK46aDimeXxP1Ir3klwl?=
 =?us-ascii?Q?F3e5jAN8tspeMYwDBx0+SCUvyjRH9GaTkgXm8VJLy941k+qJyJQg3Atz8527?=
 =?us-ascii?Q?OWm8nUFEzxOm/SYzs1wHsPGk3LpJQeLh1noVbIZlodGXSDpiuuKQ0eKDXCFl?=
 =?us-ascii?Q?xHY6iYnooF16vpi00LmVl8IBGlRED7d01y4Xcj61Nblatgi7Pu2Lz2/mb7qn?=
 =?us-ascii?Q?GxGNRhU1788Yy8D61AvBiXG5WsmCcZtVWAuaDpBUJit06qqIls59r0wcOJnJ?=
 =?us-ascii?Q?5A6b?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fd6f00-65b6-4432-c8d5-08dbb9aa2c98
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 07:21:14.6425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzOMK7iwIMK3a0mbldmkQKbI9+gZIPSbt64mTJ3C3Pekxn+ldcArFIxlKsjOE4ls0Gkt51RpjC6DVbDUgJJhHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6427
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2023 at 09:31:04AM -0700, Damien Le Moal wrote:
> On 2023/09/19 6:21, Niklas Cassel wrote:
> > On Fri, Sep 15, 2023 at 05:14:45PM +0900, Damien Le Moal wrote:
> >> The function ata_port_request_pm() checks the port flag
> >> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set =
to
> >> ensure that power management operations for a port are not secheduled
> >=20
> > s/secheduled/scheduled/
> >=20
> >> simultaneously. However, this flag check is done without holding the
> >> port lock.
> >>
> >> Fix this by taking the port lock on entry to the function and checking
> >> the flag under this lock. The lock is released and re-taken if
> >> ata_port_wait_eh() needs to be called.
> >>
> >> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> >> Reviewed-by: Hannes Reinecke <hare@suse.de>
> >> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> >> ---
> >>  drivers/ata/libata-core.c | 17 +++++++++--------
> >>  1 file changed, 9 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> >> index 74314311295f..c4898483d716 100644
> >> --- a/drivers/ata/libata-core.c
> >> +++ b/drivers/ata/libata-core.c
> >> @@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_por=
t *ap, pm_message_t mesg,
> >>  	struct ata_link *link;
> >>  	unsigned long flags;
> >> =20
> >> -	/* Previous resume operation might still be in
> >> -	 * progress.  Wait for PM_PENDING to clear.
> >> +	spin_lock_irqsave(ap->lock, flags);
> >> +
> >> +	/*
> >> +	 * A previous PM operation might still be in progress. Wait for
> >> +	 * ATA_PFLAG_PM_PENDING to clear.
> >>  	 */
> >>  	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
> >> +		spin_unlock_irqrestore(ap->lock, flags);
> >>  		ata_port_wait_eh(ap);
> >> +		spin_lock_irqsave(ap->lock, flags);
> >>  		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> >>  	}
> >> =20
> >> -	/* request PM ops to EH */
> >> -	spin_lock_irqsave(ap->lock, flags);
> >> -
> >> +	/* Request PM operation to EH */
> >>  	ap->pm_mesg =3D mesg;
> >>  	ap->pflags |=3D ATA_PFLAG_PM_PENDING;
> >>  	ata_for_each_link(link, ap, HOST_FIRST) {
> >> @@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_port=
 *ap, pm_message_t mesg,
> >> =20
> >>  	spin_unlock_irqrestore(ap->lock, flags);
> >> =20
> >> -	if (!async) {
> >> +	if (!async)
> >>  		ata_port_wait_eh(ap);
> >> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> >=20
> > Perhaps you should mention why this WARN_ON() is removed in the commit
> > message.
> >=20
> > I don't understand why you keep the WARN_ON() higher up in this functio=
n,
> > but remove this WARN_ON(). They seem to have equal worth to me.
> > Perhaps just take and release the lock around the WARN_ON() here as wel=
l?
>=20
> Yes, they have the same worth =3D=3D not super useful... I kept the one h=
igher up as
> it is OK because we hold the lock, but removed the second one as checking=
 pflags
> without the lock is just plain wrong. Thinking of it, the first WRN_ON() =
is also
> wrong I think because EH could be rescheduled right after wait_eh and bef=
ore we
> take the lock. In that case, the warn on would be a flase positive. I wil=
l
> remove it as well.

We are checking if ATA_PFLAG_PM_PENDING is set, if it is, we do
ata_port_wait_eh(), which will wait until both ATA_PFLAG_EH_PENDING and
ATA_PFLAG_EH_IN_PROGRESS is cleared.

Note that ATA_PFLAG_PM_PENDING and ATA_PFLAG_EH_PENDING have very similar
names... I really think we should rename ATA_PFLAG_PM_PENDING to something
like ATA_PFLAG_EH_PM_PENDING (the PM is performed by EH), in order to make
it harder to mix them up.

Since the only place that sets ATA_PFLAG_PM_PENDING is ata_port_request_pm(=
)
and since PM core holds the device lock (device_lock()), I don't think that
ATA_PFLAG_PM_PENDING can get set while inside ata_port_request_pm().
And since we wait for EH to complete, and since both
ata_eh_handle_port_suspend() and ata_eh_handle_port_resume() are called
unconditionally by EH, they will only return if ATA_PFLAG_PM_PENDING is not
set, and since these functions both clear ATA_PFLAG_PM_PENDING unconditiona=
lly,
I would agree with you, that these two WARN_ON() seem superfluous.

(Yes, EH could trigger again if we got an error IRQ before ata_port_request=
_pm()
takes the lock the second time, but that can only set ATA_PFLAG_EH_PENDING,
it can not set ATA_PFLAG_PM_PENDING.)


Kind regards,
Niklas=
