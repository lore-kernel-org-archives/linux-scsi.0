Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4880CD5BBB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 13:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjISNVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 09:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjISNV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 09:21:29 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B9DF4;
        Tue, 19 Sep 2023 06:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695129681; x=1726665681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/PhIj9O6FDOBMVzjSsxppD5bikwB875oVdOUlDKNWIE=;
  b=Gl0qWgf45dXyIFYjVqXh4iItSKUijyB8dBZmWYiJ3Kqtl7fhT+S8fBz9
   dgBC7W7TL2VuMGEj78JOU4GUFubNmJy+beJBWCHySiin6g13E093hdqFd
   1wbbF88+l5IyTc5GRRXJC4J5+ao5zo0rtJHmwscHboZHjgr5/VAKbAfKo
   05OFNUsxVvUzUTU8GgvJLm5rVelM/bas39I9nfaBSNEmWK1TJXS7NoZKE
   5iHyYg+IXYUpE5RIzWSNrRrYQdODyqvu7ojPCbXqEZd1qugvfs9hTwCxY
   jjLLUjaHIUENuhqq8HyFgMrjBt5dZ9tO3zISd/4KQI8cj1NuUy00d0gxp
   Q==;
X-CSE-ConnectionGUID: 6bNaHup7SYex1rVKC72M9Q==
X-CSE-MsgGUID: 6+mnrW9iShSsFMzciR0zXw==
X-IronPort-AV: E=Sophos;i="6.02,159,1688400000"; 
   d="scan'208";a="356416898"
Received: from mail-sn1nam02lp2047.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.47])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 21:21:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/9GtqXjDbDs0yAgb5Z3g53yc4EZqybPEJkavOaFamvK/RssVlBn0wlfhHU7ngmTWIzCiUMMHmvJAJTAR2SCZaDLIXMDmSp3sdI166H+exYc4g4ULSwtZ+IvaQ8TqhXi1a6n2cBEHmDCKsjBNwIAnZOp/Kz+H/qecciGPEJgqMzGD/ULrcWr4LbaTYoFM08qJ0rBTZxIPzo4LmkuHWjIvZHcuuzo6H/KBGTxAkMCgxC/YXo3t2y/FMz2djJwx6lcJDOwHZGj1Mikg5A44YMUKql7Z/Qpt8nejIvm764ibUHGrnDNAfUD8fSYDBbBguuFXtvraPKtyUohyjWZ34YBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWHe/9gmUIKMPW6LQeRazKM04qsUjTOyk4qp6ZQZX10=;
 b=Sg7np7Uhcb9Mep8PHRstx5/oBLzbZQN/AHuMBLBleYrhRUwQFHf0xdbXlVMKQyTM53M9JJvt/STXLslPSbz1aZDh3nwWy9ZIIWVNLOHll0nswxvnOE09BKs+7ArqJPxV7JwQBziMXSdyXpHM5FB+byKhqZbYvK4nhnGYaxfW1kKflc9Tq1g1rhC0Yej6gxd2c+0WvVcKko1i4I/TTWOP07tU8OgCzbLMnmYMVOGFx2X0afTe6wRXtzQ3BLUyzxOAkYKEk1FU1d/2ap6rMGylM+PxeTq2tZSD0U05lcj+2XF/mvf3K2QZqSv2YU+K3Jd1wpv89thk0ZJszdqOBVcusg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWHe/9gmUIKMPW6LQeRazKM04qsUjTOyk4qp6ZQZX10=;
 b=p+UQ4ggt+xJGW/m/5i6M4lAfipEDdh7qJDtWtS13xQLpile6P9sSnEQn25rRh6UYk8xoPGF1Pa7ULpgIsNfs1SzUKPE9UN+QN9Lf5Yl8M0a38a0qInrfh2rkmXwgJGBg+df1di9Vz4u8yT6bX6sQFbNwvMnYwX4hjmqBTUNpA70=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Tue, 19 Sep
 2023 13:21:17 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Tue, 19 Sep 2023
 13:21:17 +0000
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
Subject: Re: [PATCH v3 02/23] ata: libata-core: Fix port and device removal
Thread-Topic: [PATCH v3 02/23] ata: libata-core: Fix port and device removal
Thread-Index: AQHZ6vwrHmh5RObK00qsdvgp8QKk5A==
Date:   Tue, 19 Sep 2023 13:21:17 +0000
Message-ID: <ZQmgSgm+Kovh+27q@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-3-dlemoal@kernel.org>
In-Reply-To: <20230915081507.761711-3-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7779:EE_
x-ms-office365-filtering-correlation-id: 951653ed-39b8-45b6-c0d7-08dbb9134e7e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EFXJIFqFg7RlR9i8hI88IYOjAQQ+ob+K6mRv8d9YvDwkrKwCMSuWLuTGbawL/Q3Sn4t38Qjw32gX9jkVcIYbMMWA8u3wDhKjLKOq71Bg/5dTMmkCeSzvaqrqg7mr/CgM/aYb5VlCD4o/Qz8fvXnFWg4AQLugPHk/IR26nBU1O4RjMoDiPNkpBU4A2D0oaNKtdn1WesET9iavrKWh3bua2uFpGVR9qNskS9iyLVWxsTEodVrl1QrjoIldhNvR9WQRSCszXm0oQ/4CAtAeRycPRcmMSBz+pn2rGDCQ4l+ytb4EDZxLUlxdAFl4quJFtPHXE27YAKNYHwZJ1zDIs4R3eqNfQL908fCCMH39ClPNZ6K1fmVEVrgJR/Zp046mKaDo5gaGJP7nsaa/sZyGuiSYYiCoJ4NCAV7VEXC2FvpMisVpauzJ/03HIH542WKHqulQRMM6q/aohLPn5opbVVR44Vmj17S05ooBdJ3pc+SvOFkZ5kMD14tX/xxs7+K0JuoOoj+Ko4VM8d9cbTgNMZJk5co45W96qnK50iITnMuKKqFXKkp7ReK5gOUT/PPpOayilmi3orrlezPrIeif9Pl9WTakMvxcRFcLD+Zc/GXkhsUsq7KyJFvgX+O4sJfnANKZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199024)(1800799009)(186009)(83380400001)(71200400001)(478600001)(86362001)(26005)(2906002)(7416002)(6486002)(6506007)(9686003)(6512007)(82960400001)(8676002)(76116006)(6916009)(316002)(66946007)(66556008)(41300700001)(64756008)(66476007)(66446008)(54906003)(33716001)(4326008)(122000001)(91956017)(5660300002)(38100700002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z+dFeOAJVsuv9EZLhSzPvTTgdmJ87PPpctWgxGIhIrdImkF87NoOmvIVUKjO?=
 =?us-ascii?Q?j77kW2FjaHA+2ctLClqIIgpItbbgv6jrcd4geq7uAiNY3+cHxz3svxr7EvjQ?=
 =?us-ascii?Q?RGnngzytLjNOK3fg+jWTKXt1Qi6vhQi/J1QCwJbBPvxFvZ471gLqaPZUV2VA?=
 =?us-ascii?Q?FbxLk+XQik9wtD01f0lXpfoaEUGOGeC+2MU4wdHAnRugCOeo+JcZTHqXpHLN?=
 =?us-ascii?Q?v3dXqrnvytbQotKR9dyq5vxfb0Fd5pqXe4FLo0MN7KZxW0FfMA5uU2hFTqEW?=
 =?us-ascii?Q?kv7jtt7Eo37zcRvT+p39TC1xs39bVJzOTLgMaqS1c0Qn6Gi3RGPO9zZXuqJb?=
 =?us-ascii?Q?F+ztf9cPwDUmveyxM5LKQ1msvl55nVvg8XRqPIdTbb7NxXkIeM0JdFXNlPok?=
 =?us-ascii?Q?eLzMSVpG5g7UiHPJ4OTK2xLiOhdC2e3tEVhY3DHnFgRuB787eonluz3MRvyY?=
 =?us-ascii?Q?notIJ4MwrrtPn1o1N6xRv2Ro+HYnI/z1iuD9TAngSZ/q2WHlxrA7vsludm2c?=
 =?us-ascii?Q?y6+Qcs4/wU4ZyJgqnlUsEq0EwTzSteHo1S3tbcutniKT7g+OJFF0fiXfRDKx?=
 =?us-ascii?Q?WGxCKohx6KekOfameAsi0QRhg6ubtP1H22NVX6ux2E6WF6vnq3LzVfA5XACc?=
 =?us-ascii?Q?drWPBuKcLenjBxpG7uTj8cR5DZN5f2IZ2RRSFc+vhOGHP9mlhPANubvTbEJg?=
 =?us-ascii?Q?YhRaytZ/L+HB1tGYtK8iIXEwZsRfvZunug9qLtcOlgt+cWOG7McPf5stM6Xw?=
 =?us-ascii?Q?E0Ps28I1eLb1MGuVrMy14Kvs1H8d/2JqezbupsQ29goFyI3QC14AnqhvqEaq?=
 =?us-ascii?Q?/PAbfAs2jr6JQ/KjHFO5ejcY4jLxxXfyz5shxJxbpuJzTgaH1PAr/HGNn4oD?=
 =?us-ascii?Q?+Dg7ZxCj09f4UsF60X/B76vkQLOXsCKbbs+1ObmL8dUpfvag/2zzv7PhBEcJ?=
 =?us-ascii?Q?k5pAx3EWIUU2BbZLEYEh3x4LujuTrErVmj2yCX6aduMrXNBKCrSvA1EQrTQx?=
 =?us-ascii?Q?C1DCgsP6/V2Se/TvawHHxT7Qc4x9I9nC1ydLckkyoSgrf/pVXQ5GyMxk2We4?=
 =?us-ascii?Q?oT50yc3rmBMbXeV0zKR14i9B059uXeAJ/Zc1HQVllANCxHOj6mZ/G2olVbKj?=
 =?us-ascii?Q?DVv5oiqgn3QVGIjfoFPD3yimmu6Po1sj+ljqzBi29rAktbGnTejF+lG4CqH/?=
 =?us-ascii?Q?zJMZ9YgnOFUUn5++g07OHz9lbEFBBx3iVDtbSHuaJZg/bN5zB79/Q7s6FYzm?=
 =?us-ascii?Q?Og4y6icD4GYmEwIUXaTA5Qq2/1nnQqXeiV4ORYLXwKGNBnika/lnYKgVDWlp?=
 =?us-ascii?Q?q6qqrr4WVEV1Q0Oir0ayOcJIXOAYaldK/RJF+u2dm5bFd0y4nH3Bhe0SsDzx?=
 =?us-ascii?Q?N3htSQtzj8rPwVh3qu/CxvhFHKLT1sJXlOQ8rAv4dPAHOAbuCkGFgzwqUPzo?=
 =?us-ascii?Q?HC5nxZp38R7pTJHsqdon0TelqP9ZPpLyFv479FiYnL+br6RYJSKA82zCTM1n?=
 =?us-ascii?Q?OBNoc2+kMfar2/IhgXyKYXrQqyPye/rFcz6wailwNw5SeGzKM8F7UcvmKeIU?=
 =?us-ascii?Q?gzSfYqqgk4QvX+mB0Hd+A3wYkY3pyWZe4+YwEGTK0HNFEe1Mgn+wJCKDQG1A?=
 =?us-ascii?Q?uQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <417E61CFF812B2449B5F64A25D0292C7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?YwawrPBWXJsXebpbYqQj9DZpVI/nlDk/a3apz8YqPHO+9zFdbhvKv2XppPg2?=
 =?us-ascii?Q?cw9mrdwHb1w3jYs4XEuaW07vKifVVHh/nzEzNIgLvNHau8gBcsg4HZUtJJfa?=
 =?us-ascii?Q?1uJx9dprRX692ko0VSZlhG8my4fJvyMnxmNmuUnhGPPMlpLA+OBKGIOJKv1z?=
 =?us-ascii?Q?nVD7Qbuoen9jnKJHuAOZBbjS0TjrAsyckns9fift6uoKMKGCMIBOrST0KwMG?=
 =?us-ascii?Q?muS6vD7wTKMKMH/kqOuXy2W6XaYnWceh/hMDKCHLpsrTzfUN4klBiLHntD+M?=
 =?us-ascii?Q?Q65wsWigm1+Lf4xHnBqqVxj9GoaevPjEegnAOdq2FRx8mzg1gSu0KSzAvl1K?=
 =?us-ascii?Q?paPEdaWULPaHP/C78Ro0k8mgswdRt6zPBlhBtZEG+l6XJ6R1EaP61StCd2Ct?=
 =?us-ascii?Q?h+ZeCnUznWUTRowZMLH09qdaXz5GBZ6NyVc+9g9FU52U1exMEn76aVj3cQl1?=
 =?us-ascii?Q?+eMfjnlE5xbCuQ7bwwSv/4B7Ey1CZNGHfKAm+kLE0b47eHCVd1oLKT/OrbPt?=
 =?us-ascii?Q?yeNKSYayq9JJxqXrX0RLNrYXpdFfBAun56ChCaob+EbrKlwc1u45g5Xnfp/c?=
 =?us-ascii?Q?QV+hoymKU3x6cAUdHfiTffobWqAOKXoWkF7a99xOOa2asaT4JLWVRrC7kuZo?=
 =?us-ascii?Q?UcvMtl7hfZzA+pHv2HwEIkG1KIMxoN5U5aIja4n28PrLp8oighSrpBe7IdF5?=
 =?us-ascii?Q?Y5z6RK5WZ/QcrT/suDrS2+XQs2ak+VF+98OZbtC0IjbvG5ilHAYNDXRcrzfC?=
 =?us-ascii?Q?dWiGSudx9Uy8d8TsT2breoDBfsImQvPzrS9xP2UxOsNm4O9pCZxaVmcYaOp3?=
 =?us-ascii?Q?jVoWip/Zly5NjpY5ZfJS8LvzpTMOpi4itP73+1hQBPBqZ39K7R/QeBj5YH35?=
 =?us-ascii?Q?1BwRt9CRnMsyuPbK4wkXCqXT30crQALKmKkZofZJouceoPzlzF9ViTskUSaI?=
 =?us-ascii?Q?BYNilrIgIcPNGVgiLsbOf1ybVc5CGTuxJtPg5lGxHWFj5YzSgfZCs/wcnD1S?=
 =?us-ascii?Q?0O5U?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 951653ed-39b8-45b6-c0d7-08dbb9134e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 13:21:17.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jRslQKtiThS6bKKm+8Llo8TMAVV90gc4qP6Zx1yIodkQVW5SjJzAt3nPB7F0humoG4gRI4JbNXk8oo/E/0okQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 05:14:46PM +0900, Damien Le Moal wrote:
> Whenever an ATA adapter driver is removed (e.g. rmmod),
> ata_port_detach() is called repeatedly for all the adapter ports to
> remove (unload) the devices attached to the port and delete the port
> device itself. Removing of devices is done using libata EH with the
> ATA_PFLAG_UNLOADING port flag set. This causes libata EH to execute
> ata_eh_unload() which disables all devices attached to the port.
>=20
> ata_port_detach() finishes by calling scsi_remove_host() to remove the
> scsi host associated with the port. This function will trigger the
> removal of all scsi devices attached to the host and in the case of
> disks, calls to sd_shutdown() which will flush the device write cache
> and stop the device. However, given that the devices were already
> disabled by ata_eh_unload(), the synchronize write cache command and
> start stop unit commands fail. E.g. running "rmmod ahci" with first
> removing sd_mod results in error messages like:
>=20
> ata13.00: disable device
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=3DDID_BA=
D_TARGET driverbyte=3DDRIVER_OK
> sd 0:0:0:0: [sda] Stopping disk
> sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=3DDID_BAD_TARG=
ET driverbyte=3DDRIVER_OK
>=20
> Fix this by removing all scsi devices of the ata devices connected to
> the port before scheduling libata EH to disable the ATA devices.
>=20
> Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index c4898483d716..693cb3cd70cd 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5952,11 +5952,30 @@ static void ata_port_detach(struct ata_port *ap)
>  	struct ata_link *link;
>  	struct ata_device *dev;
> =20
> -	/* tell EH we're leaving & flush EH */
> +	/* Wait for any ongoing EH */
> +	ata_port_wait_eh(ap);
> +
> +	mutex_lock(&ap->scsi_scan_mutex);
>  	spin_lock_irqsave(ap->lock, flags);
> +
> +	/* Remove scsi devices */
> +	ata_for_each_link(link, ap, HOST_FIRST) {
> +		ata_for_each_dev(dev, link, ALL) {
> +			if (dev->sdev) {
> +				spin_unlock_irqrestore(ap->lock, flags);
> +				scsi_remove_device(dev->sdev);
> +				spin_lock_irqsave(ap->lock, flags);
> +				dev->sdev =3D NULL;
> +			}
> +		}
> +	}
> +
> +	/* Tell EH to disable all devices */
>  	ap->pflags |=3D ATA_PFLAG_UNLOADING;
>  	ata_port_schedule_eh(ap);
> +
>  	spin_unlock_irqrestore(ap->lock, flags);
> +	mutex_unlock(&ap->scsi_scan_mutex);
> =20
>  	/* wait till EH commits suicide */
>  	ata_port_wait_eh(ap);
> --=20
> 2.41.0
>=20

Looks good:
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>

Could you perhaps also fix the WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
in this very same function.

The pflag is checked without holding the lock.


Kind regards,
Niklas=
