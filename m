Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C330C04FEA
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 18:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjITSzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjITSzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 14:55:01 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD4DAF;
        Wed, 20 Sep 2023 11:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695236095; x=1726772095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2aEywyxPXDmb4oi5IdbWF4f5bbg3UzyXUF0vOGkXu0E=;
  b=C9GIEDqA8TrlSGQYi9/6puxAPlSlyUG8w3eF5WyuGsgbCChwe+hrKYwW
   wKFR0tClLlo+g5FpiRiN+pgBudhZ/k3g/nD3nr0XGVCsSYf2bH5+2bX+5
   73bfe45XuEAt2RjTQ40iN6rhVISTTz8eVWW6e8A/qxGOk6oOWkpjZlIte
   RUGyf7wleMONTtX2xCBMUseCHCT7pA/Q8W4u9kHPyov7epYZbBh7qfZ2Q
   xIAlFCoJsH3RZIcKbKOp4D1GmwJucLp/Xy2ApfXz63QzQs+CcoOV4Uf31
   ljG3cyoTRWQehKYSH/CRyaw/ZaS/MQlm9GGWb24o6ZM3+ubAy/ah7wBIq
   Q==;
X-CSE-ConnectionGUID: OYTPgfwNSWGGIM4cn15g2w==
X-CSE-MsgGUID: Wa5yItQgR7yIk3ppPbTOcw==
X-IronPort-AV: E=Sophos;i="6.03,162,1694707200"; 
   d="scan'208";a="248963496"
Received: from mail-dm6nam04lp2046.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2023 02:54:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7c6xmiCyGCtip9frKtUdRbV9uuB89y1pDU6Bk8NQE6X2kRHqB0FLUeqtEbzDKhIidrImwg9+FxFgQbhZloA2IOqvo19Hexe8N268Ifquu8ECgBSAdCw3Y+9N49/PmEjqN0hUgrvKnz1Ct2L0ia30ggwEWFduspqM/vgXRbHLCSshfYuPNgNvnQMDhAblQmfJBThAghWu0ayAkYAZxKPZsmRsj8DUDZXygHOsfhE8SUU96lOJZ4IoaSRWSzIgQPBVW5als+0UjA5NKRG1F4PDO9cYGTi7TU1ICGoNBrRKKTsbjnIMD/kUcTemqvAUPd67hqfN0jfv0NsT9bwTTanvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crZxh5l7UJMNm13Cn+HEt9Jo6mCQfLjwJEIcM9ZC/7k=;
 b=H8DPmCO9pB3M2Yx4cNsOvXx4KBn7c2MLmfoT2hO7MZTSGuwHcfXzGoBRvrM4QJEqF/6m3wzUmNElisU+d1Qiav0pta/dKDeyZL/WCEPTLATUETIhvr4e/E4h+qIxgK6EOQ6uqEs7AJTMZaUojD2eWzNHmva9ZNAC6w5+WWG9veTicoJYgRkg0ZlHYdINd3D1bpBQuhM7B45GPakjP3MGLmSsTBzZ1WNcv39kqXWhKIycL0/DdN4G+FsXloGdR/JlOpeLRYBobbMOIsm5Zl4lM3NAw4B0JobVY6oS5++t58lFVPqY831f/LeX/N6WvVj3jaP3pS2318Y4ZWV8JjljGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crZxh5l7UJMNm13Cn+HEt9Jo6mCQfLjwJEIcM9ZC/7k=;
 b=km2bOtJjehLfY4dLFYaqFjgnRsLzv8BYoyOKe8xMUEJA2y8xW4/5cwWm3rv7j8TVeZuPQojGGFuAbxyGU8r9WddBv/3A/5ANTMmj5ayTf618CW37mxe6LTdANtEs7azWmd91avt/aHdcpMrcuPF090jeb7PMGaOJctdbjGQR5m8=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6916.namprd04.prod.outlook.com (2603:10b6:a03:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.18; Wed, 20 Sep
 2023 18:54:51 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Wed, 20 Sep 2023
 18:54:51 +0000
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
Subject: Re: [PATCH v4 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
Thread-Topic: [PATCH v4 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
Thread-Index: AQHZ6/PvGAMp2//vXk+BvjIpGc1dfQ==
Date:   Wed, 20 Sep 2023 18:54:51 +0000
Message-ID: <ZQs/9rJzs2ksasb7@x1-carbon>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-2-dlemoal@kernel.org>
In-Reply-To: <20230920135439.929695-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6916:EE_
x-ms-office365-filtering-correlation-id: 01095114-010d-4350-4360-08dbba0b1236
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjTcRfG2/mVlyuYJIATvAf25Gh4lQlHY0yy3OWDR3miazAcDln5xLYB02PXbwi804iKGFHOBbr+q8BfnsocDLRF93EkN7mEEGXaH0/Eqvfy9c/B57FAvlUx0LrxoLVhYaQoHlSsps8KOK7v70sIULmBHfbuyXB1pMQ+ABx87IIIR6VIC6lgJlQM37qSz/3l8cpspWXvAEnYi+KCIvQn1+ciYfLOvL7Hj2w2qmTpP9kmqO9OJug727jMyhlbFPFYwOFxFETRBvS/znjK3PDD3E2w5rkprhvMK+Ba3ZgAS4fCMnDbxQ3nyC7lhM8s4AyeC3ZrnzFtuOHyAUD/KHDxeJ/wwXj1/5J4PlK29ebUgB9qCXeI1Wg1gtYYfJObVmmKpTxGUoHkf46SraMYhijV+Mt1Y0vgEfNPU0KXDxNJ1ShtXkmSj88rDCoU5FZUTA+2Rc8KGz4GYAMDevkK0kRYOUt3rmqsycAbKMVshZCzEu2TN3EE8CbMG+mxOm7u/YZh4TA4L6Yrrmw2fOeUEN9BztXdzHZ1svVq/dDXpiqSQ5gxjStfAsyGJzI82a2ZoDg1cGAy5iuyszaVbhjdZBD/agaxmKIS2J4J7NVC4aa5+AtjLCeJiwtCKfNVKQETlDtWd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(376002)(346002)(136003)(39860400002)(1800799009)(186009)(451199024)(6506007)(6486002)(71200400001)(6512007)(9686003)(83380400001)(478600001)(8936002)(2906002)(26005)(33716001)(8676002)(54906003)(7416002)(316002)(76116006)(64756008)(66476007)(6916009)(66946007)(66446008)(5660300002)(91956017)(41300700001)(4326008)(66556008)(82960400001)(86362001)(122000001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IaQCnd/4QIE+yXqKbGbqQte7GFNP93t3riNqmhpv5nuVig+up619/vbKHCVA?=
 =?us-ascii?Q?yxF3WlPlNZ2C+JrOteoDi7IASDmRCGXTxNqeQo+sZtMyhYBPuqdWFsd555io?=
 =?us-ascii?Q?jxy5U9U2ApVXKnOnEwKOIXX60aD2vPpkrYikEv1Dv7faS7PRZA/V3dkvNb13?=
 =?us-ascii?Q?har5vLIw8f9x+BR/JZAHo5lB4wbo7mDgq83PzYZqODdguSOkFMcYhWK7N7nd?=
 =?us-ascii?Q?jnTqX4f76Akkk0Lq2Ki6lZr3V6BXOp38KgtI6qhOYgOVxY2cY+SzVFGnWZYI?=
 =?us-ascii?Q?v3liHYsS65T3wfwMVVK+08bAIkgsfPG7etggvreHOy21kV/ai5QrNK+PgEW+?=
 =?us-ascii?Q?OMylYXTlDKkzHx695EyUTK8bhY3IKYGT+XLL5HmZ8VcyFDBGJxJTz7upvkA8?=
 =?us-ascii?Q?LZgpIcsWnwdZl1ITv7JW72v8Azi/ThbMsevtv1s0xPvG+0js7/hd8cr5Wusv?=
 =?us-ascii?Q?TrM5qiJDaiPRmke75haCABibw7nQ8icjS8WYot5hPCWPKcN0ah7GiMNsL1nr?=
 =?us-ascii?Q?XbErUUNRPW/9Vg2e7/raZSMW4OJYeGoE10ufpjqeVdf2sUwDfrwzn7mLG93m?=
 =?us-ascii?Q?KvIdYe0D70zbGmEdKBc2ZCYXfoBP9UX1QRnwq01L/MNKzVOhZZSuBonJ+0dR?=
 =?us-ascii?Q?aVIUUTIqUK5vP5jehnz7qDlE6IEAKHWKa1uzme/bx82MCG6E8Fel5b1IXKU5?=
 =?us-ascii?Q?knIAkaT0MfT3rrFVC8hDYxgt5Ha2YuS/nlH0dgCLWJGniAGD65bH5grfU3bs?=
 =?us-ascii?Q?GiR3D/T48s5QjSIyCmPVGZ9N+RHxn/s5smIb6z1ibk8tXRHyLG/jNNb5wNv6?=
 =?us-ascii?Q?qwJWOgVk+rgXDlIjitwdDTavb+rjI9qTeV5LhqQxSKCKXYbCNK0fIz69O4AM?=
 =?us-ascii?Q?XK0mjvInH0Dgc6fFX2bIVQq30gLvHkP/azmUmU0LuVqrldkZU2zShA1GQ0IU?=
 =?us-ascii?Q?3XgGWuRoc5e9vEk5ouIN/5LFKzWVr5mBAa6YWe4JgXrTivcqXhz9fSIEvvG5?=
 =?us-ascii?Q?/lpX8ORwTWhTeWAa8ohJCWUQqruH6ca7kLRNWh7TvnTchmps9BSG2GOp0XFY?=
 =?us-ascii?Q?F6QXgMCBNjqAGcTNEZ9d2dqX+KHHFboDzqsfAEe1FQIWUzTcQlfP8zm/7mpK?=
 =?us-ascii?Q?K7Ee/P+N9T9JIMJloZ5UWGtApprHW0E6W0kxzvklB8p2O/SM9+TWjBJ1+Wwc?=
 =?us-ascii?Q?czI6K5f1ics0KEEjtHH2Dg0+cyR6+1TD64AXVReIJSfD5Rh2O0tlx5xRZ6ak?=
 =?us-ascii?Q?fMriR9QMapoS320PCz8ZGJqL/XVdaNbAgIV+agDrRTXRz/0XagS6OxKLTEwY?=
 =?us-ascii?Q?On6l0SxvZWK38DRAznX3OqzZSygzRLkf+s/UaYqUzlOs1jIkZgq3hDvtG04T?=
 =?us-ascii?Q?3nv2coQ7f1hBA6mlnqdMiP1m1qd940e2ERzGCXKOseNq7lLIlNoapmbHRlNp?=
 =?us-ascii?Q?Ot4qHoxCetyG4v5Oiqa993PEjPLa/sB9MIFCjC2G58nRUi/J5AfGuUw/hIEk?=
 =?us-ascii?Q?PiU6d0Chw3ppV99/9JrQo8ikg/2MkwZTSDI3Ytp6Wu1DnsCVm4Tki9+3AzKw?=
 =?us-ascii?Q?qp3mbb97voEoRKfpZxYHYSm9kN698Tb8+8GWyRMuGGZMhZrUCW8dKtnSwsnh?=
 =?us-ascii?Q?1Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <013FA4BA8DF00041839490173A8F0DBC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?kmktB+7/VGZ49sWGKF38b0P3qCs/PbOk6sJTlSF1Ii9X3uO7pXd/ELNGwtgx?=
 =?us-ascii?Q?WBTQgJjKhX0iXUDAG5xa8QSTbNfjrr5KR5+1daCfb491YlJIE07fb9IHKace?=
 =?us-ascii?Q?laz1aLUNhwHE//UP1BCJVbBj2mU6MdP7UUPagXhVPPAJeyqAuQSLtXK2/vNH?=
 =?us-ascii?Q?BhBwIcVYy8eRdo/WTScSXJ1O7VFDVEzFJz8Bbmf7/yJys2CKM2gDof52j8+V?=
 =?us-ascii?Q?RygSCILe+9lYW8Th6tT/FG1RYX+LIbmBJ3ShSknz2USoiVQCtP8DgdBU1Ye1?=
 =?us-ascii?Q?II0ZgVRX31sUbunX1r6g2ib9rx1d9wYR69pPF5PNexy06olsF66KAG690cw7?=
 =?us-ascii?Q?L8JgUVfHoUvqoIkMIVDGsUgxHdwCQupPLyy2hebFjGlivMJkYCu+JA9WPEl3?=
 =?us-ascii?Q?optun1+UFaYDlsNw7l7457mQ3eW6of7WkkG5q1GMqXnCLOT/8R3HB7A7ksnU?=
 =?us-ascii?Q?L8l+JPx9kf3gtaBUZmo7FRWZ5GnyQqvVeO6EbDifKi0OwysCaG4mSDKAvFtW?=
 =?us-ascii?Q?Nr63h52qCr6p4/RQmZwsWuk4OW+MaE4dSE36l8Xa4KCPOyjQiwTtBRhz/jFq?=
 =?us-ascii?Q?LffSCL0nRGtVTlKNSUg54tgzv5rJRB+yrE67E5YWE6fmXPuUADzJra2Kis6H?=
 =?us-ascii?Q?bF94TMnXKzv+a+bhuK97MdGo7FzblsMAK+dKUqwKNNLuGW2ZLRGsUp0fQscq?=
 =?us-ascii?Q?5Fext9iLtLuVSjWBn35cjLLTzSayN/7JCWrq2PgfwEgjUuKKuk3S7S9T4U6y?=
 =?us-ascii?Q?LEsyKsXzuQIwcl7hoNaGbhJKkPirq3dCcorMBGsOQg2VCNvaem7NmTGduf52?=
 =?us-ascii?Q?1bOzj57fo3DP8Rauu4XIWQbMGHSgKGhBQBBX7bI9DQ1UnplkxuJtQwgWaAdr?=
 =?us-ascii?Q?rtyNrnF611s63A5OW4108srjlaEg2TFys/K6LQsGse/YFqFLYa4GNVTfMABm?=
 =?us-ascii?Q?qrlwoTa1QRRK+ayUchlaBPsAZIXd93iWr56+gXkIwkP+bJj3nGnnOUNfH+gE?=
 =?us-ascii?Q?aq8v?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01095114-010d-4350-4360-08dbba0b1236
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 18:54:51.5966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHE3gpmGrKweWwAD7wwHGrVMxsd7HfpetpWtLeHZSy7Sc88RdJF/DiDfQhvwwv4WhaIBneUN9+hkFIKayz9PnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6916
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 20, 2023 at 10:54:17PM +0900, Damien Le Moal wrote:
> The function ata_port_request_pm() checks the port flag
> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
> ensure that power management operations for a port are not scheduled
> simultaneously. However, this flag check is done without holding the
> port lock.
>=20
> Fix this by taking the port lock on entry to the function and checking
> the flag under this lock. The lock is released and re-taken if
> ata_port_wait_eh() needs to be called. The two WARN_ON() macros checking
> that the ATA_PFLAG_PM_PENDING flag was cleared are removed as the first
> call is racy and the second one done without holding the port lock.
>=20
> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  drivers/ata/libata-core.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 0072e0f9ad39..732f3d0b4fd9 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5037,17 +5037,19 @@ static void ata_port_request_pm(struct ata_port *=
ap, pm_message_t mesg,
>  	struct ata_link *link;
>  	unsigned long flags;
> =20
> -	/* Previous resume operation might still be in
> -	 * progress.  Wait for PM_PENDING to clear.
> +	spin_lock_irqsave(ap->lock, flags);
> +
> +	/*
> +	 * A previous PM operation might still be in progress. Wait for
> +	 * ATA_PFLAG_PM_PENDING to clear.
>  	 */
>  	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
> +		spin_unlock_irqrestore(ap->lock, flags);
>  		ata_port_wait_eh(ap);
> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> +		spin_lock_irqsave(ap->lock, flags);
>  	}
> =20
> -	/* request PM ops to EH */
> -	spin_lock_irqsave(ap->lock, flags);
> -
> +	/* Request PM operation to EH */
>  	ap->pm_mesg =3D mesg;
>  	ap->pflags |=3D ATA_PFLAG_PM_PENDING;
>  	ata_for_each_link(link, ap, HOST_FIRST) {
> @@ -5059,10 +5061,8 @@ static void ata_port_request_pm(struct ata_port *a=
p, pm_message_t mesg,
> =20
>  	spin_unlock_irqrestore(ap->lock, flags);
> =20
> -	if (!async) {
> +	if (!async)
>  		ata_port_wait_eh(ap);
> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> -	}
>  }
> =20
>  /*
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
