Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732FCCD5BC5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 14:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjISOAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjISOAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 10:00:24 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C279E;
        Tue, 19 Sep 2023 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695132017; x=1726668017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rHd+m4WUCR7+Kc0S6OzAd95HBpk7aMtuZ95ZfCPNHHE=;
  b=opepsZbhJXBIV80aNI2P52TujMYfZKAeGRWHiN7Uv6etisSVXDvHU9a8
   LmfDSDOu1xZX9+bBpL5p2O41c37dSj3l/7w8WBuWZUsyqIKGBeEZV9ZAr
   1x0MZM8z8KqBUDfIg6WepwnPsEh7Ka/1mmTsnn+1mR8akVcpyMms03xlt
   NUGcQ6peVb3OQ43QgT+ENEpMi+UwSjY/AJvHq4MQVVWL7Ty2TMmT49yf0
   DkIpVQFD26XVs5smLl52eTyUYLYt85FgzSAbVxOn+zpcfSrCrlVPtHWET
   AyDAR1xtDFNQvQ/rXdNip/svfKW9gzorp6tbXPGwov3s46LQWhNEL1O0t
   A==;
X-CSE-ConnectionGUID: wT3xbRDRQbiFnfhiOZA/1w==
X-CSE-MsgGUID: 0eaQqASSQKmAtIP4LPyX3g==
X-IronPort-AV: E=Sophos;i="6.02,159,1688400000"; 
   d="scan'208";a="242537643"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 22:00:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBtlCNo79a4Fmeab56lKhX9QYxDcgtnTCZN44IviK3OMlVsJs/eBr2gQ6fkGHC1DAKxUrVhqe7SJA0tRr1OvZEoc8TR2GKSyeuYJDPCADc5CpCbLIVZd9OBWzX8WgCoZFx3i/3R0inuhW/fDsMmz/AJFArc2d6I94KJ0l7gELeYAZ0MVz9m7DVMw3eRKqoEssMq+IzucsJg8jF2JxTIxcQqreVLmj+0X7ON2xN6Qdhs0DXyvKuaIYnnentkolc37YuUHpxiJjE0JEB/7sgyVP5HhVUZMV3Hh4831llPB5XAzXBnPKPRi6EYh70HUBKqKb1yAjkhWtXQJ9N7+HMOUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eX9ONOSaFQS/x+eZckx0pILcRkdsGtgAlSCX2uw4KbY=;
 b=UlnHj9E5Ky0fE+IDIU/iix2WqbDpWJxeTEHdnM0X2GBaeSwlG/8ODTPwyO4fWzZtXXfqjm/XrAiD+ANlUShwDrfZd0SbZckH5B/nT9EGKBcgCF/Tqjpp0X9ltI0cfZrFAYBHf8Ighqsx18WscAHSPhVs3yI7ftTR/D/Rl171tThhbl6Y3c26IcZw1nWt5y1kYGHIrhiNlPJBKORtoILS3vXFtsbO4GZ5jlBZuY+jMzn4viKWIk6M5wHk7/zR5wrQBGyFg8gePamSsuGV9nfkIly0CH8cQLYkn/Tvci3rg/krx3UURM3sUTvpkRsYCIxvjHQ5BG1rVoEXgPqLVB5e3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eX9ONOSaFQS/x+eZckx0pILcRkdsGtgAlSCX2uw4KbY=;
 b=QfV6bmyYn4P0lQZWE7n1AMv1tboqrzMd1TNf4loSKnT5Hku27UxT9BDDs4TYtgbKDt6kkA9Rs1A/YF3U2+IkgRtfXYdMWL75avkZYTvmQqnW+JfjLNsJ7On43GH9Zfau94X2BytiRT5pUhIiCeNl/n2677yI8Z2O/C9VWxiN+OA=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH0PR04MB8051.namprd04.prod.outlook.com (2603:10b6:610:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Tue, 19 Sep
 2023 14:00:09 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Tue, 19 Sep 2023
 14:00:09 +0000
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
Subject: Re: [PATCH v3 07/23] ata: libata-scsi: Fix delayed
 scsi_rescan_device() execution
Thread-Topic: [PATCH v3 07/23] ata: libata-scsi: Fix delayed
 scsi_rescan_device() execution
Thread-Index: AQHZ6wGZDHnz/3nHz0q1nNg1O1gk0A==
Date:   Tue, 19 Sep 2023 14:00:09 +0000
Message-ID: <ZQmpZfJgGPpxKonH@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-8-dlemoal@kernel.org>
In-Reply-To: <20230915081507.761711-8-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH0PR04MB8051:EE_
x-ms-office365-filtering-correlation-id: 89945a8d-7458-4bfe-0e05-08dbb918bc58
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jkqjuhe1zIaoyMgquzAeaZJvXYL5BKOwCd1PkofE1LsMqYzWl7Cppg2V8H+HFdC1FGzncTfMAEI9zIyAGt25Y1RGYs8N87JPca5wJn6SWciYI8FnqMpBpgWmKfSTmV5cdvlXV72QhOxC6PXmxs66+krMfGs9Uj97oOaGMp9vHS1n1n5syFu4CXgnClBeQC5XcoDhqnHlM+aMqk2bN7UY2y3LGPWpgFEFrhyJEMkFV3gw7606pZDKQgPXtvDMB1PKNQXRTkeA6XXzAqvCIkQDpAkStF2k0pm/sQp+mX77GHF/8U50/WdSxy93yIzsdKFeztqG8FrAswyd1HPfvZXngMM4XypIt+rzL6A6//cdZyjE8TI/Mw1R97dv5lQsZBUUYygAZcQA38tiKNKvq/UUF9DLAztRdm6nvSBeWyMnmc534NtoQqK4fpmLJ2BeQ81nstIYLpvUbxOedVdKmuexkLPOXXhtGGCjEo0bEL23+aZfjvMfZNuneayWi4yDsEozERNlAFPlR0iUQpusw2VCJacEHboEr4wVLnpC7hJOWUUiyiR/+WXxmJjnQklQdUc5DnD5RwaZHbftasq5bebtZ7DF21lGhp3WXClZO5/96QvpuY7L8CujC1VAdJ1x2Z11
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199024)(1800799009)(186009)(122000001)(82960400001)(38100700002)(38070700005)(33716001)(86362001)(6506007)(6486002)(478600001)(2906002)(5660300002)(66556008)(66476007)(64756008)(54906003)(66446008)(76116006)(66946007)(71200400001)(8936002)(8676002)(4326008)(6512007)(9686003)(26005)(83380400001)(41300700001)(91956017)(316002)(6916009)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mTU4wQCrYqdx6d8g53J+ESmN45mz05qOLtc1DLN2yrKHAgezdN9uVLiN0LGM?=
 =?us-ascii?Q?mv3Kd63OluFDaquYSyMM4hugUyx4sH3Qm7GreYGW+lUMtM7IDfJM5o6be/fg?=
 =?us-ascii?Q?Pe9/oavQR04BIcXdBUMUBk6G2sFPkgdQylayVgEcHY/1i31npMdPW+3S6QYe?=
 =?us-ascii?Q?FKgblb9at2CIGtnicOIKaXFiavpcXxZ5GGYeEvFQANFcF633DFLPdbDfTjof?=
 =?us-ascii?Q?+FGINeX2W9BM7mylPDSum2cYi484PscNrVd2mJvKIu6mLbSfXKFPb9WdKzOb?=
 =?us-ascii?Q?QPramCo10WVOmrCFscoqrPhlRW4TUgKwoI6bNAaHnydxRoytgow13H/6eq76?=
 =?us-ascii?Q?IdtXz/zvbEvkpjnnywpn97r9O7sb2o4Avkgj4AcxzaDM1NTMTjL2t8Ul2cNR?=
 =?us-ascii?Q?B8TwTwa5mBrwAfifKxVv4cEZ9zKqOiYa9mfzDlTjm85M8G+KC/e1mNXoCtP1?=
 =?us-ascii?Q?MKw1sZPdcf9UEh/hf2OGg5HYFCXI2VI7fL8FWpJ0hftk6xC3BJO3fB0C4Mpc?=
 =?us-ascii?Q?a5/j5EtmZx8upSyC+kHh3FIBJ3XEDnr3rHveZcjJiqN5iN3/OlcHYF9yb0J0?=
 =?us-ascii?Q?we96RpGeInQJUDfizkcy8mx4dIz01gSWospF41bKmYsxXhs9gqX7z13GHPmP?=
 =?us-ascii?Q?na8VMxhJMVb3+IOFHET8FaoxFW3zlDzRU/kIZoNLSmraUXOF5Va+VEPU/YFF?=
 =?us-ascii?Q?Equ4YtIW+bJrwlGODGcn6tIl2If7q+YgSUCPU3LBo7jvIojQz8aQuE1XYxfG?=
 =?us-ascii?Q?olsj3Bd2E5KFV/VKIczliJqB/RzWWDk5aVjc2Vgp7rRfPqvdEVhe1+pb/w04?=
 =?us-ascii?Q?YTTgZBvhm6MopTnacB79OxkaibipjbEE4dqfU8gQo183/qHblBB8O/bfgXaL?=
 =?us-ascii?Q?d2rH7sKJBMDBkQw7oZN2d5g2X3t5vZ9A5CwSRyk2jWxU5pQN5kESKAFnWwGd?=
 =?us-ascii?Q?nkp/oDnAbwmQZuDP0vf1UzrA8YhNBtijIkk+a/r18jMMM+1rSdYG01z+I2Wg?=
 =?us-ascii?Q?N5q9pC6rivZpYxQFtk1cBCYWEc3KV3BWFg+TP6YxjGYwaesm2hkz3gbXWFHc?=
 =?us-ascii?Q?+nPdTd8STmaVqEf2ZA69jJhymxkOoZAza/Unoc0gcE5u4asSxcOOzdUk+Okw?=
 =?us-ascii?Q?96F9feQH9gyaS8SvIbDDmfTV2CTeL4MfCsWibRvgyz46dYIUdnBasP3MW3hs?=
 =?us-ascii?Q?AP9sC1f1Ohlv11V4UYhkncu8Q8Crd4o6Z1pP76I7lETgMn6cGQOB6BME8vPY?=
 =?us-ascii?Q?1iZMbRsnErzkbb8HqIOuqI4Su9xjXaVzcT4Ydhq19TeELYonGHrWR1oBZDaY?=
 =?us-ascii?Q?D7DqekxYXp+0sroBBHPVwQLd1A4mOcIZ5H9RRBX5YH17QGQ/T2602sFMkqWy?=
 =?us-ascii?Q?byveqJ0ttT87399gtAIJ3ZpmNLrUoAA4Rzu7YxTE4gr9ZIC+AG/M7AR+Rk5u?=
 =?us-ascii?Q?bYSx/TWK2uk3tWhlrieEVrIogG6rx+1Weobpd8yQ6aSONC8+OpytzJKHh2ou?=
 =?us-ascii?Q?cfz3ZEldYTmb6aFwDIb2+dZIsXjmbnILPAyUDJoo8A4kJcOvodwEFhOXcpCv?=
 =?us-ascii?Q?kxFgPkSgq7OcrG5ebfq+bVuCgvXJu8AC5C8kSdWH+4PvjIPrvidMuy9uQA59?=
 =?us-ascii?Q?hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E28495F6A696D40B424D92F70A18A86@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?vLf9jF4Y6TBbd2B/6qgWwk3ccaCpK6CRu0OkC28U/tgu3flcy/2dnhzRbSFG?=
 =?us-ascii?Q?JhcVzOElj09VEZmF37/DtuQKKTi2LV8XQ/jvIrUcmG2Bw6GZy0fM8if1cfJC?=
 =?us-ascii?Q?5jSO/LfoNSkF1KUA5ZgifSVG7x63IshhUXVtNkB+XxtiDb5APFw+wPin0rL1?=
 =?us-ascii?Q?nR5rY+w0tkaXrnfg+G8oX2BsleHQ4CsNE1q6dO9R8YwCOEi8aicXEKGMGYIj?=
 =?us-ascii?Q?0GAv3MrSuseOQMvUabwY3LinA9vBhdTcVlN0IpozQqvemglbArZHCTdtt9jA?=
 =?us-ascii?Q?eUOzrjybZADAkPJfWVirmZzcZg1UTFZqFnU6it9mNM/oXFRo/2SKxgukokJX?=
 =?us-ascii?Q?SS5Hp0ri4A3QSzFh1dAMhhSga/svRaTyfime//G6oW7tYAardzZRv5SRPVs6?=
 =?us-ascii?Q?XXijmvD1weJza2KPU39WElZ678Kvd04m8II+KM2ZhICXAJgEMeWk2152eeFe?=
 =?us-ascii?Q?m+V75BuTkEOrL/d9vF5gzpQToQD2AB8EmhVifej6Gt5Bn/FXdXEDdq8n2nc+?=
 =?us-ascii?Q?bufu6q14BTVCIqS28pbYVd0otf8dTPp5R4yUvwLY5msmYLxnE1ZTLLRMQki2?=
 =?us-ascii?Q?f0w4DB4dGCbUGR4tV0GOohm9/ufmr6AMCEf9W8YkXjRc1Gh054CtNR0WRR59?=
 =?us-ascii?Q?/3teM6DMfUzmW5jtk1fy2Ih/FO7rsPwVKApjnd0l5M7lZkUt9yljQh+vaPLP?=
 =?us-ascii?Q?BNzcTvNY4q9/ujrJSQPIWZjMv0+I6dMIxGPeizYHpfwbPyHLFsZlKJgEOKSz?=
 =?us-ascii?Q?Z3r3gUZyx9eHo2i0SCkkMm5Kisl4oGSNjtXRAZ1WA2vOlpQMQWHoMaN3qtQS?=
 =?us-ascii?Q?ybdquAXl+5N7fmv0FVVgZDuMXxqpGePVvtx5uIAYJAfZt5sXefwdGQoZrZ99?=
 =?us-ascii?Q?112zphq8+Hlfdkp2Ws8PZPQEsDTGWr23J4ZR+EzcPC54All8jXVM59BzXhUv?=
 =?us-ascii?Q?f/qM8MjaiPVKRUjUxhctxr3fY7dIz+FvTgapsCF4OPZuH4ZcmPfu1MBayytc?=
 =?us-ascii?Q?0zzG?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89945a8d-7458-4bfe-0e05-08dbb918bc58
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 14:00:09.3163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Jc3PPeK13tz1kLs797kqWD/RKVO4cVRV+hwpdJF5alGuLr0gU9GnOT6RKSE8olXZIi5+MVZvOXBNhFII9CPug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 05:14:51PM +0900, Damien Le Moal wrote:
> Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
> device resume") modified ata_scsi_dev_rescan() to check the scsi device
> "is_suspended" power field to ensure that the scsi device associated
> with an ATA device is fully resumed when scsi_rescan_device() is
> executed. However, this fix is problematic as:
> 1) It relies on a PM internal field that should not be used without PM
>    device locking protection.
> 2) The check for is_suspended and the call to scsi_rescan_device() are
>    not atomic and a suspend PM event may be triggered between them,
>    casuing scsi_rescan_device() to be called on a suspended device and
>    in that function blocking while holding the scsi device lock. This
>    would deadlock a following resume operation.
> These problems can trigger PM deadlocks on resume, especially with
> resume operations triggered quickly after or during suspend operations.
> E.g., a simple bash script like:
>=20
> for (( i=3D0; i<10; i++ )); do
> 	echo "+2 > /sys/class/rtc/rtc0/wakealarm
> 	echo mem > /sys/power/state
> done
>=20
> that triggers a resume 2 seconds after starting suspending a system can
> quickly lead to a PM deadlock preventing the system from correctly
> resuming.
>=20
> Fix this by replacing the check on is_suspended with a check on the
> return value given by scsi_rescan_device() as that function will fail if
> called against a suspended device. Also make sure rescan tasks already
> scheduled are first cancelled before suspending an ata port.
>=20
> Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after de=
vice resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-core.c | 16 ++++++++++++++++
>  drivers/ata/libata-scsi.c | 33 +++++++++++++++------------------
>  2 files changed, 31 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 0cf0caf77907..0479493e54bd 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5172,11 +5172,27 @@ static const unsigned int ata_port_suspend_ehi =
=3D ATA_EHI_QUIET
> =20
>  static void ata_port_suspend(struct ata_port *ap, pm_message_t mesg)
>  {
> +	/*
> +	 * We are about to suspend the port, so we do not care about
> +	 * scsi_rescan_device() calls scheduled by previous resume operations.
> +	 * The next resume will schedule the rescan again. So cancel any rescan
> +	 * that is not done yet.
> +	 */
> +	cancel_delayed_work_sync(&ap->scsi_rescan_task);
> +
>  	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, false);
>  }
> =20
>  static void ata_port_suspend_async(struct ata_port *ap, pm_message_t mes=
g)
>  {
> +	/*
> +	 * We are about to suspend the port, so we do not care about
> +	 * scsi_rescan_device() calls scheduled by previous resume operations.
> +	 * The next resume will schedule the rescan again. So cancel any rescan
> +	 * that is not done yet.
> +	 */
> +	cancel_delayed_work_sync(&ap->scsi_rescan_task);
> +
>  	ata_port_request_pm(ap, mesg, 0, ata_port_suspend_ehi, true);
>  }
> =20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index ac2d332b4963..6297f8c16a13 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4760,7 +4760,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>  	struct ata_link *link;
>  	struct ata_device *dev;
>  	unsigned long flags;
> -	bool delay_rescan =3D false;
> +	int ret =3D 0;
> =20
>  	mutex_lock(&ap->scsi_scan_mutex);
>  	spin_lock_irqsave(ap->lock, flags);
> @@ -4769,37 +4769,34 @@ void ata_scsi_dev_rescan(struct work_struct *work=
)
>  		ata_for_each_dev(dev, link, ENABLED) {
>  			struct scsi_device *sdev =3D dev->sdev;
> =20
> +			/*
> +			 * If the port was suspended before this was scheduled,
> +			 * bail out.
> +			 */
> +			if (ap->pflags & ATA_PFLAG_SUSPENDED)
> +				goto unlock;
> +
>  			if (!sdev)
>  				continue;
>  			if (scsi_device_get(sdev))
>  				continue;
> =20
> -			/*
> -			 * If the rescan work was scheduled because of a resume
> -			 * event, the port is already fully resumed, but the
> -			 * SCSI device may not yet be fully resumed. In such
> -			 * case, executing scsi_rescan_device() may cause a
> -			 * deadlock with the PM code on device_lock(). Prevent
> -			 * this by giving up and retrying rescan after a short
> -			 * delay.
> -			 */
> -			delay_rescan =3D sdev->sdev_gendev.power.is_suspended;
> -			if (delay_rescan) {
> -				scsi_device_put(sdev);
> -				break;
> -			}
> -
>  			spin_unlock_irqrestore(ap->lock, flags);
> -			scsi_rescan_device(sdev);
> +			ret =3D scsi_rescan_device(sdev);
>  			scsi_device_put(sdev);
>  			spin_lock_irqsave(ap->lock, flags);
> +
> +			if (ret)
> +				goto unlock;
>  		}
>  	}
> =20
> +unlock:
>  	spin_unlock_irqrestore(ap->lock, flags);
>  	mutex_unlock(&ap->scsi_scan_mutex);
> =20
> -	if (delay_rescan)
> +	/* Reschedule with a delay if scsi_rescan_device() returned an error */
> +	if (ret)
>  		schedule_delayed_work(&ap->scsi_rescan_task,
>  				      msecs_to_jiffies(5));
>  }
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
