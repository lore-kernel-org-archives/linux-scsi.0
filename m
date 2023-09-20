Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACABCE79AF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 07:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjITHal (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 03:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjITHaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 03:30:39 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3CACE;
        Wed, 20 Sep 2023 00:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695195033; x=1726731033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JrHt2A6IKAO4eDmtbZNjBmMeZUlYV0+X0gZGhA/AdpY=;
  b=bCtmpCsHc3Ftfmud2iakpRJAhULqMuYTQwoCr21Ezelp1lZD39X284OZ
   QH2BgdD7GMkRdgZpvh1ZPk3/mXyUozKWSQribqI6dT1gRw4g2zwiur5f0
   6HJr4ivxGBdey8C54Uz9GSQMAIzWDclAGcQupeV8KG/LAQ7AsA5QzRVAF
   8FulAac4+VRVhINvtTW80tswjAjxQDl27+nnuCE3rouNV6oHZbmbQoSdo
   fAYW9hPU7a2KbHyqGdkQToylIch3fvXrhguiiCQHpasRlN2EdxOy2nFxK
   SlwhiFApNnYaPQv956UhNa9jvWZLoxKuZFq8wRM8wy+xHem+lvfZt520a
   A==;
X-CSE-ConnectionGUID: ciOb9SaOT5CXMUaxb/pa1w==
X-CSE-MsgGUID: iU8oSHXCQRWz0Rl3yQ3ksQ==
X-IronPort-AV: E=Sophos;i="6.02,161,1688400000"; 
   d="scan'208";a="244414732"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2023 15:30:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLq3k1GFo4dRTEwB0sGXHem9mNSoLxpgD4brvHWlFmnPEezwAWQCOwzrg41Yjqc9Y0TpqIQtirT0kgIUBdEFcmpKkDhHBxQ+f+g7Vmv4hR9dYlKI99mU62X4L5yT9v/Ai2ScipyoJrNrZAQMZFL5y+YBzSM2OQ7ZOuXIjRdg/+S0aO9CpvSNQZufK6QtMUA0hRLDd05Pj1heLOZ8v4j9bNTAMArpcb/HRHdn0GekcnH4u+xP1rMV1rQSTfV4X0Ik1J+MTnhQht9DsbbalYX96S4jyuAqBt3eEfEUjSLDQ0W6BjLhF5mhPysk0wzKWficAxyK1qOQAZuD1NdifHmNJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgGLzd1bsF1pP4hjLxH8cd9jI0vH+crmedwNPtow71k=;
 b=bUYULVl+Ziclg5DzpRWvI40X/UAAwIYZp3Z+hRZlQX4s3FoU3E2Yl4g9qu8P+QVcWsvOzj8Qxx8zGlf9ZF3fDYQ0fUUr2dgDJnKy3VldFjbWMDAntJcweOZG6vDLzRLRCrS0iI3hj/kqMm6GLPfHa1B1gNHhzD+qQXHmA4CpBAzMmF4yWo3EsKlSVa4DnklsOFQwWvfZJbpvPIe74he2zg1GHKpjCesrcrNjklIM/MCE2606caY45eDMejjng8rOd4UE3jl3hqXg17pfZdj2TVBL4m6WsQ9agtS0/5b+cprfRwCrnan/tdpoA4lcZPN9rK09yiINxcg37Hc0sh3d1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgGLzd1bsF1pP4hjLxH8cd9jI0vH+crmedwNPtow71k=;
 b=k/qoGNrqGVUo4Grorm8I2/fSpseSVejMQUvVj7HqnXx1EZktSIY4w54aT5U9Q9Ljz4vtJU3zOt9oaKsjsJL532avIFkoZgzqHemYR+J7S4UeYb+NQtUf3XKSNqICAdqaK5nbL9ddBF2lltXUGzDReOjeISrZvB65CyJPQiJnlto=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH7PR04MB8609.namprd04.prod.outlook.com (2603:10b6:510:240::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.15; Wed, 20 Sep
 2023 07:30:28 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Wed, 20 Sep 2023
 07:30:28 +0000
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
Thread-Index: AQHZ6vwiQHlkVB6riUOWXMTHHztL7LAiV2UAgAD4tgCAAAKSAA==
Date:   Wed, 20 Sep 2023 07:30:28 +0000
Message-ID: <ZQqfkisAiMowBWVD@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-2-dlemoal@kernel.org> <ZQmgNUCLV8rDXg5I@x1-carbon>
 <0c2c5b5b-85b5-89c6-5d62-c4d3a029fb2b@kernel.org>
 <ZQqdap5Q3ky6lV4p@x1-carbon>
In-Reply-To: <ZQqdap5Q3ky6lV4p@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH7PR04MB8609:EE_
x-ms-office365-filtering-correlation-id: 6f4e3b71-afd4-4561-48af-08dbb9ab769f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mjy3/5wUZbwEnRJad6afjuDRDkx+3sO/OOZ2zpxF39TBq+HQABsS+Iw0sVOCTjsDnSgdlKEgMebmqn3xqC1wTNhOmSZc3pmPm3ZB/yUcRbsm70tSPAL/ZPRrLwPyHq0W3mLf98ImgD2JnGmfa/jEMnEDhjF+SUxaWcStw5AlYvYEc5HS+MJhh0eH1XbazEePCo09sJj4cAaM+hsaDbM9Zc4tbmswz7UDNTTxkVsmrUnqnrvGDL+5tDOrpP0ZrV1NT6uDSxvBA/hSyHPlE/baOO/oWZkOAOoUS0P/DbC2U66gOTzNMn/lR9B1S3FYlL0+sVBC5yC3PIX06Gmg2qdnOV82sgaVctdZvhIXpW/VwcxkRfCj1jMxr9ZSTFH++fSxk7EfC7OI69gCHTK7LLv8jPXiJJxg95WrMWfUcbym/ClmKfZzFSTSftP/vxEfOC5l548a7eWoamp2Y/NgF7sH7UDh8eI3JYtW9TPT8z02PX4tWGocv3/39xphh1SHOPrRPri7Ps8/n3L5/DPfd+Ji+RhUAlBbWnltaIaZLNk0VGxFXjhXjmSdA/1P5MNhEZVTgC/lW1BGSCl5wRXpzfpyAex6mTctWghS6ISu3srTFduXCVmRy419UuHz5b3sipfb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(346002)(396003)(376002)(366004)(136003)(186009)(1800799009)(451199024)(33716001)(2906002)(7416002)(5660300002)(8936002)(8676002)(26005)(41300700001)(6916009)(316002)(76116006)(64756008)(54906003)(66946007)(66446008)(91956017)(66476007)(4326008)(478600001)(82960400001)(71200400001)(38070700005)(9686003)(6486002)(83380400001)(66556008)(6512007)(38100700002)(86362001)(6506007)(122000001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VCik9jmvBKt2amFZz33oHMi+QLO6zlnqP8Ifk0Issbcp/ymyjolrcw3CJPvq?=
 =?us-ascii?Q?/T8aetHAMHnMSy+cVTKS/ggUeZHuJj4DNCuA+iSjES3qOsHZG077aslF2SC+?=
 =?us-ascii?Q?BTK6emv4L07D9OlRVNVQGR9LrIVXGCnbj78BuwfAJR8DC42tCjGndrIPBMmy?=
 =?us-ascii?Q?Qi0PRH9M0LKhvjCy+AoJphT3QQz9/8UEBSXqThgs7yAHgO5PNE1AhM4hkrWL?=
 =?us-ascii?Q?a4DeCb87SGshQIfJoXEBwZrsmFPP+JkEeXCFUtCzV8zUqvgXqoTE1x3CYNR2?=
 =?us-ascii?Q?MQqOBAKFltN0YtklkhwVpoQUApfEODwBACF5qzkW3krQ+GGNuwsI1PBPu9kt?=
 =?us-ascii?Q?Oh181MZmgh9yCH5fnagXrXtxRGH0xGXwcncLI+gxu+FxRUH92MKGuf5rc5eD?=
 =?us-ascii?Q?sMG3U1JkI5xFGBQD3biQ91R6TT9KODztcYaWRaTUW3QF3l4o5qfeplaw2gF2?=
 =?us-ascii?Q?V4uYYrlPnVpJGO84Nrnp0MO4stSYrbDd5k1hpJ8wXMTU72pU/7sFySbH07MY?=
 =?us-ascii?Q?+D/Ro1B6zJemnjIUferPNll4PeK1iVufk5t1+/kKFVsqwwal4LGkbtMz7jX6?=
 =?us-ascii?Q?X9O2pjXoVW+ejYQ3hcGYpWbtD7uViLM7VaTfORaeT3NPjCkhkEi97O2oFnev?=
 =?us-ascii?Q?BfwhB27Vbo6BhrhmZycz9AkCbv4U+V8QmFrkLNWURdw1aeLwCCMps2anSJbG?=
 =?us-ascii?Q?dXBlD6WIresMh54eS5KyibwmfbJmV6LdP2+rxhm9oynapWiT3X4gf0UWtxG+?=
 =?us-ascii?Q?18knzeDNEHTtSg4wMMQZcNUqH0k758GKdBGBJAuEUJ6ep1nfq4kXWaBxrFkS?=
 =?us-ascii?Q?qDEzjNmV9Ie+ZmMHBEEWJnPdAQ2PcUk9sVzhOxL9CfSTvJE+UWjTDq6/UCH7?=
 =?us-ascii?Q?+secjSMLVOYOp1n1HbHS1tKar5tIBUdGCid5UFfAUun8U9ehPXnBXjnAFjYR?=
 =?us-ascii?Q?4wHdP8k7idrHj/NspFpK7JgHNYRL2UkGK0wPIDPQEHdO4zHF8d0qzllOPjVA?=
 =?us-ascii?Q?MwRpxpJ8QdaZgyxZxkONbEknd2ItvjuEnN7Cxa0BRIRL1d+Jaf0+1W+ZHbyE?=
 =?us-ascii?Q?IAHn3QUh0HWkdzLc4JhSRZHD0zNrSFs15Tl6JafDVgqrzLqGFMDiZt7eSb+W?=
 =?us-ascii?Q?ThFDuAnDetzdEoVNqe2wezxbR8nPDElQji9QDEgTnXdG6F5DzbBAK9bp6wY1?=
 =?us-ascii?Q?RZlUJ7dJgtpG1Ms1FcXX+6Mnei5ScDX17R+bhBBZgGVwrx3Tl+lgH+0R57LA?=
 =?us-ascii?Q?xxIuoUkLw9kZPQUbWr9016Tvc9R3S6aZI4SrdzrHSRxBfs47tvzK3OSX/zSI?=
 =?us-ascii?Q?RgeGnQ6L7gpa1zPAGHrYjeLN4N3klbEpCn//SLeZ14fpwDI3ddsHoRJ6P61e?=
 =?us-ascii?Q?FI12QeYjwd8/GySyMblkOhcgyMkAu+0FxmrXjKdacYOdhCtxDBlMw+sjOeG7?=
 =?us-ascii?Q?XCnquIDtlecbUFA/74K/Oi5rF5j8RDAKEpQ20GD4K4xnjtul19ICuc+KaHfT?=
 =?us-ascii?Q?ly0OrG1/eldVvdOGXNumnH/0aKO5YAoOQN3MLv2AlDRKU0YpVUBq+043ga55?=
 =?us-ascii?Q?0SU15DKj9aADQ0DR/WG7GpIuks5Z61UgsEhf3W0b47y10RpCOXxIcpT6a2g2?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF41909F4FBD5D459D79265ADA2A62C6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?B1BOE6kA6U6cBAWDF2pQTgE3ic83HWdfT4oDXbl5yfZz53vVbLGH3JW/4UYu?=
 =?us-ascii?Q?hIZCMQazteoP6MGG6E7vVLxWOR0IIFWdVCNltiLWCSzF+0uajuyGHuCNmgmz?=
 =?us-ascii?Q?her5/FNFERAOYbnaWhrWhLM7XJAGJpPBHpgU5e0t8IX6PwmkhMx58XHbl/fx?=
 =?us-ascii?Q?FJVY5b+EGPVeMNgxDEAoBs1uFyWNxv66VWKJ5F0JvQfVjiuTf12rhHWeSeLw?=
 =?us-ascii?Q?3kv4wT3WJBGLBBaEnZzSuUaDbCa+5QtjeUsptdkJ0UJgSqK9NTM10I8u8EYE?=
 =?us-ascii?Q?n+eMc6lqcbDU4/jeNQIyIOWl9b/en6fMEPA0nB8bI+GqOeHntS7V1scr07ZK?=
 =?us-ascii?Q?D7gkbLU3ZmTOTGnCHxQvuz2SkccQBu/1QKcHSByVpsceoznXuVAbhTx7Z3MQ?=
 =?us-ascii?Q?fJk8VRrpWkfZlnyjWq2C+M43TYCsTgNvfZSV3Vt1xL9ZgJNGUFdHI45AaEFQ?=
 =?us-ascii?Q?MmEdd3tQkNELiA/QAJ/m75miLKjRATlUH7pAhgN1D+JYyyrYARlY56CMns+0?=
 =?us-ascii?Q?hBE2cUuTMiQ3tRnpk+roCDZOedDdYLTjEeatFih9Q+zwOW4fDoNwAuPlJCnM?=
 =?us-ascii?Q?zpKm40CJuNCyqrr0BmxT23QuLzyJ2erE4Gprok1xspoqxBNsO3S9irm8lrmL?=
 =?us-ascii?Q?3pE8gYyvBie3L82V/D8YmBh2Jkgjmulvy2g6dyHO+LXjXlwMk4Wf3AVlyo2P?=
 =?us-ascii?Q?RTxGBqTEWk8uzymiuNInc7BFvDvstPSjcnjGNGrU7on1HtYsG2hqvlvfd883?=
 =?us-ascii?Q?b5PUyPbZjyaV6JMvrCPf6/+kt60IOMO40MJmqiBes3LotqZ1OccM1k6Tj2F4?=
 =?us-ascii?Q?iBjr6FRIGMSnqCiq8u3h04IYZLeQpanEAVdil1qAOG57tk+Y90pr/H4nKmgp?=
 =?us-ascii?Q?qLD/5FsAf3/No0L1c+moxbLVA4nwlg0rZmzvakpLYAHgqy/BRlDx8bAuF0Gq?=
 =?us-ascii?Q?CqEmzR65zXDK4/rS+UDdl02Orjel7FeMYxgX62qSmW+Z/k/1BwTb7Xredmlx?=
 =?us-ascii?Q?0C7H?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4e3b71-afd4-4561-48af-08dbb9ab769f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 07:30:28.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xkBkBB7kbDX5XWf0D3csIHDXOEqy+nmc9e6sHAw9zjTZcBbcc3x2knW0BATI62bSs/lrEbWBFY6RjdMbwn2zOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8609
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 20, 2023 at 09:21:14AM +0200, Niklas Cassel wrote:
> On Tue, Sep 19, 2023 at 09:31:04AM -0700, Damien Le Moal wrote:
> > On 2023/09/19 6:21, Niklas Cassel wrote:
> > > On Fri, Sep 15, 2023 at 05:14:45PM +0900, Damien Le Moal wrote:
> > >> The function ata_port_request_pm() checks the port flag
> > >> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is se=
t to
> > >> ensure that power management operations for a port are not sechedule=
d
> > >=20
> > > s/secheduled/scheduled/
> > >=20
> > >> simultaneously. However, this flag check is done without holding the
> > >> port lock.
> > >>
> > >> Fix this by taking the port lock on entry to the function and checki=
ng
> > >> the flag under this lock. The lock is released and re-taken if
> > >> ata_port_wait_eh() needs to be called.
> > >>
> > >> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
> > >> Cc: stable@vger.kernel.org
> > >> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> > >> Reviewed-by: Hannes Reinecke <hare@suse.de>
> > >> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> > >> ---
> > >>  drivers/ata/libata-core.c | 17 +++++++++--------
> > >>  1 file changed, 9 insertions(+), 8 deletions(-)
> > >>
> > >> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > >> index 74314311295f..c4898483d716 100644
> > >> --- a/drivers/ata/libata-core.c
> > >> +++ b/drivers/ata/libata-core.c
> > >> @@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_p=
ort *ap, pm_message_t mesg,
> > >>  	struct ata_link *link;
> > >>  	unsigned long flags;
> > >> =20
> > >> -	/* Previous resume operation might still be in
> > >> -	 * progress.  Wait for PM_PENDING to clear.
> > >> +	spin_lock_irqsave(ap->lock, flags);
> > >> +
> > >> +	/*
> > >> +	 * A previous PM operation might still be in progress. Wait for
> > >> +	 * ATA_PFLAG_PM_PENDING to clear.
> > >>  	 */
> > >>  	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
> > >> +		spin_unlock_irqrestore(ap->lock, flags);
> > >>  		ata_port_wait_eh(ap);
> > >> +		spin_lock_irqsave(ap->lock, flags);
> > >>  		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> > >>  	}
> > >> =20
> > >> -	/* request PM ops to EH */
> > >> -	spin_lock_irqsave(ap->lock, flags);
> > >> -
> > >> +	/* Request PM operation to EH */
> > >>  	ap->pm_mesg =3D mesg;
> > >>  	ap->pflags |=3D ATA_PFLAG_PM_PENDING;
> > >>  	ata_for_each_link(link, ap, HOST_FIRST) {
> > >> @@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_po=
rt *ap, pm_message_t mesg,
> > >> =20
> > >>  	spin_unlock_irqrestore(ap->lock, flags);
> > >> =20
> > >> -	if (!async) {
> > >> +	if (!async)
> > >>  		ata_port_wait_eh(ap);
> > >> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> > >=20
> > > Perhaps you should mention why this WARN_ON() is removed in the commi=
t
> > > message.
> > >=20
> > > I don't understand why you keep the WARN_ON() higher up in this funct=
ion,
> > > but remove this WARN_ON(). They seem to have equal worth to me.
> > > Perhaps just take and release the lock around the WARN_ON() here as w=
ell?
> >=20
> > Yes, they have the same worth =3D=3D not super useful... I kept the one=
 higher up as
> > it is OK because we hold the lock, but removed the second one as checki=
ng pflags
> > without the lock is just plain wrong. Thinking of it, the first WRN_ON(=
) is also
> > wrong I think because EH could be rescheduled right after wait_eh and b=
efore we
> > take the lock. In that case, the warn on would be a flase positive. I w=
ill
> > remove it as well.
>=20
> We are checking if ATA_PFLAG_PM_PENDING is set, if it is, we do
> ata_port_wait_eh(), which will wait until both ATA_PFLAG_EH_PENDING and
> ATA_PFLAG_EH_IN_PROGRESS is cleared.
>=20
> Note that ATA_PFLAG_PM_PENDING and ATA_PFLAG_EH_PENDING have very similar
> names... I really think we should rename ATA_PFLAG_PM_PENDING to somethin=
g
> like ATA_PFLAG_EH_PM_PENDING (the PM is performed by EH), in order to mak=
e
> it harder to mix them up.

Perhaps ATA_PFLAG_POWER_STATE_PENDING is a better name?

That way we make it even harder to mix them up, since my previous
suggestion ATA_PFLAG_EH_PM_PENDING, people might still miss the _PM_ part
when reading quickly and could still confuse it with ATA_PFLAG_EH_PENDING.


Kind regards,
Niklas=
