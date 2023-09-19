Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30DFCD5BBA
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 13:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjISNVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 09:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjISNVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 09:21:13 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B09F3;
        Tue, 19 Sep 2023 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695129665; x=1726665665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kxKhmp5eg6AavVJx9LAD78mQuOFPe2XvQ+lV8krlnug=;
  b=kV5oc3vz11UvtsuwM6W/a672UeoLNeIFJdjtXLwnHDO48ci2jgqFPhla
   5zM7N4AnfeVJuE7LvYSqc+NuOdhvn180sbtlNNsWPe0VHYzn6QCvBaa9w
   VHeCFZiWIW/lA45uj36GZldpZjNZxhwQDAet4loz9U2+hDTMSLK7V6R9Y
   z3fjLMC+0L+F6HilIQvC91P8jJ5oseKo3yRkQllwKRY6fYbvU6uxwnhkH
   gs2hZFEFyzY1kMu/DD7PPdLURq8caT9mBRi8MNyumAhVrejAflXcS4sJG
   wwnPERA8JhqTiyp9G+AhmYUAOaKme4u/HRGSlDSB0oc+SCNCHEgR7IVCF
   Q==;
X-CSE-ConnectionGUID: xvPxQP2rRB2xCg+U4oqlvg==
X-CSE-MsgGUID: akHbxWvNQbqOq+czXJcKuQ==
X-IronPort-AV: E=Sophos;i="6.02,159,1688400000"; 
   d="scan'208";a="349635288"
Received: from mail-sn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 21:21:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4VSUnW3XoTB3aNLaGSxQit3LEJgNgqXweMdLSU70gvf15MWMHlTXx5WJoCTg3qq26l4Fb12F0BG+7f25VElvX0ThtPEY/OTWWOmDs397mU6Jv1B2rhQibtVPAr0hJ5VhsO/Kr2rJGdqj9ISOcdNit7QvuDIrK1OIH4iAvHhuzDgfP4vN5QdbWvn7hM7aieB81cNvhPFb1ikq2bPS1M/fnLx+zDp/y/pdtMzxdY0hLbaooJoDmZQnKvqAlkPyRePLd4wZ0NsH8Oni3Od/d1HNopNelrn7hdRaPe6zpaZOT24M3jENWi0UdSffXVQYNZfPt6l5nbqLdf579S+M0ApLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JNaX3EaETZ0KrNDEjOzOhnL7FTZ/L9kBnnuCM9kr5s=;
 b=a1TP/9DKbCe/fYbNgpsR0FvEDqH4vCGhtQ7giHTF2UZhH+iH/FiBGpMosjEPK6eGkp01cT/QCFyKRXDMFs/31miqMqdeall23tca2n3qQv5aZy0JDO4q3sgljjdXmqwnNUcYt5bXJ2UVmHJ4Smcso6KT7hXCpNUScKpTBs4v72/53qFGTmxeXg/LIik1c/GlnOM6+0BDxlLSsuYlblmV5N6SobKCwYcyLSlzMtK/wZLbdmKALuaeahTPVVCQsfSZx+J+2xKN/tvE279I0FhwfNPSie2URhEsPMkTeiTZBfSvsmSgngr3TmUlLlAhm2Uz6JpYmNgsaIjhFnegWOTcfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JNaX3EaETZ0KrNDEjOzOhnL7FTZ/L9kBnnuCM9kr5s=;
 b=pmOj9JplEKNIMJtXddBEfmXYSXFsyfv++n99Kj1fsQkrXpldRKUH8gWdsKl1eb91veonmy2mHpp0VKkwkB8QAri+ShIWKMyzX/IzE+TSJStL82s/6FaigmoykqPFve8XoYqopC+yjphLIHKhz4pxv4OtMVEGhYT60+gExoUYH7Y=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7779.namprd04.prod.outlook.com (2603:10b6:303:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Tue, 19 Sep
 2023 13:21:01 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Tue, 19 Sep 2023
 13:21:01 +0000
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
Thread-Index: AQHZ6vwiQHlkVB6riUOWXMTHHztL7A==
Date:   Tue, 19 Sep 2023 13:21:01 +0000
Message-ID: <ZQmgNUCLV8rDXg5I@x1-carbon>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-2-dlemoal@kernel.org>
In-Reply-To: <20230915081507.761711-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7779:EE_
x-ms-office365-filtering-correlation-id: fc3f4b6c-9150-4790-7cce-08dbb91344fc
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +JSDG+oPh3jfCoW448UBYbKb3IudELV0om1LVZ8I74vB5u9dJy7nl4NtRZ20hmiqsK77QDRN9Y7OVR6OHU2b+y5scMQILF7BtUEbV+7Pk+9txooLcQskYGWJy5vd4xRlVDkQr7K1Iz5ukYsqPmvsUqXomhayt11ehW/iobu+oA0zRhU84cjbgsQCN0/HFaxAvizZtrjgyA7UxvW9vEANRvlpv/l6/xNgbLWV8ERAc34J9ft/0YkfHmKiumgRc4v+xQ1LyNTiBc6Z4dlx4ALbIPBWbCDWW9FTzBUMiKlYJf22Rqpyilil7CqTTOfkx60YnVICuZU/Owrzlw0o6qQe+crbB5PlkOXBMHFbaDr9BN+Nwqqh9AkWG1fm/rCn+0ADxC6rT7W4o+J7uqkcvUVDAPwIYRInuUI8FpIR41Ek2XGuG6mLiUaVcG3GhO27u/rZr8BVbMhEYzBC1MeThJJ1HIwfQtMLKErHgiRQWEv0ckGUT7lziPEbFWUWzH+gf7SBX0HZkgIH9i/N4NP9Rk62Mm2+Qz0x08sJ9HR24DZ19xwOKgtEqrFTcVqwMkQzIAPF1itHFYgCmvpnPmQZNBGutHlMMqK8aPjL8up7yByTlRELvyTS9jtsl0bizKo7sMIZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199024)(1800799009)(186009)(83380400001)(71200400001)(478600001)(86362001)(26005)(2906002)(7416002)(6486002)(6506007)(9686003)(6512007)(82960400001)(8676002)(76116006)(6916009)(316002)(66946007)(66556008)(41300700001)(64756008)(66476007)(66446008)(54906003)(33716001)(4326008)(122000001)(91956017)(5660300002)(38100700002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1oSABmqbDgCuGZg9DlSD+BuvZAZtZy5ilm4tXHopmsqEcjhOWVZpjp9+0oCy?=
 =?us-ascii?Q?tUnkurnk5J4be4JFnAYSLN3ZM86BYdwZgcOB7JnsWAoTL9TFtrOjEzOU4I3c?=
 =?us-ascii?Q?SdMjOL+mHUop5j5eIJP31W1Cl1OAxSb7WcJCM9SUwcXhSX3Mf2YfQtyHRACX?=
 =?us-ascii?Q?gLYKRuRZZCHmnvhzdXRIvKKTD3AV7qWLxca8UFYltWtbVbnQRuCrs7A46gp8?=
 =?us-ascii?Q?ZY54qoaf42dSarpav84ZNRVPmYJCyCCLNFCZrWwDngGgwYelsSW0ToZ3Ko1A?=
 =?us-ascii?Q?6qNd3iFNd2KpQNGxt7YT0H7P9l8gcL5QUItgZj0WIzgWUwOTNREykoHqFoOV?=
 =?us-ascii?Q?Eg/wikXXXo8RctMnRADnLoJE8auO/On2UC7DMbdR7QGlld5Q1X7CR/X64Wbj?=
 =?us-ascii?Q?m8syvbPwLpIWa99plqk2gGvvtqZ/rhzGUHLxAHyeHJziySitoLWduyh5tY/R?=
 =?us-ascii?Q?IHPOBLG6rsiYrzzH5CsiZ6GlOjzR8lbZktT8XeV8YH0TqK3pIGA2fmSmzWVB?=
 =?us-ascii?Q?7DpfGv9MROnCPkLK8+4kk1ukKVthjvCAd8nwyxttK2oNsWZLVqBFz2fJoVL8?=
 =?us-ascii?Q?ax4muYKEe/o1+8MlFK6uW2SHHf87t6l8ln2C6Spk2lxzwOQ6FADIJtUxXU4Z?=
 =?us-ascii?Q?PwOkaAqgrpj+U8f/Pl8h3ERVApYdCymGBM8RkMM7aKEQwmNOD8ayAU7784uU?=
 =?us-ascii?Q?eIsptoVoPY7FVcZLbs+wcJSCp1Um9nzQBk3k27v55fY9/dIBHa6kG5lnvrUL?=
 =?us-ascii?Q?HudBsxkmUSE+VPImN8g/zM4lKVg8L3BqTWeFIWvnTKTZqa1GejZvzSR8lrRh?=
 =?us-ascii?Q?5KE9ql5qj1x9wKOij4Mm9uOplR7XiSMgQ6uGCvUmY6qHt7dAWLC4r4+6J/wM?=
 =?us-ascii?Q?e4LulZ4y+zJKoeQHAVH80Db+z08P/LZKsAtJdT5mmNXjyhs2bp2z1RypbDj7?=
 =?us-ascii?Q?FjsxxuCdsjaXewNRp2YXxoZP+ZkubMagWvRxxEjVIV+ti37bMw/BIeC6xXsn?=
 =?us-ascii?Q?30XvqBJDiFbHPjAfph5R+UrJ4pHjFHC1saFavW5tF179EDs3eJxAYggOSvJr?=
 =?us-ascii?Q?htADkFztola52Fc74SHQabDXU9hxYJd7sy2XkWZPOU6tbPe7BA4YmM5QDPcf?=
 =?us-ascii?Q?KYVTSjmRLndZUoLpBwvgLsOyR96pCdmcqPcGhZ84bIGgADVj28uBg+ogxv8l?=
 =?us-ascii?Q?Qo0RHnqDh4kWfHoGVJCTtpiT7O1AUr1PP+10rZAV62Ku6tzVV77FQoZHILnP?=
 =?us-ascii?Q?JS8EvFyXocF1mymnVVYJoLRXvVmt5eFVDywo5ktzxEbu3EELJEXheQGA9/S+?=
 =?us-ascii?Q?wN2BBjnFZ2r2HIYPut7djdLwOJaeyG98VoajyTeeRxeITIf6xGwN59GqhQus?=
 =?us-ascii?Q?xnU3ptTWinQfYQXdPIRz+fIGaQ6COL2asYj5rvEMg0YCkDNe6UoHo85feBor?=
 =?us-ascii?Q?q/YU+CjEQOzdAEo2ejORD4nnrJeKQ12CI9CD6x20DyxMOyJJaInczZLq8hGP?=
 =?us-ascii?Q?I0VH+ev3eEUm3KzXplWHUw5fnRO1/GSLpT7ZBbgmxd99VngPaLXkwoCycg16?=
 =?us-ascii?Q?2BPoJT4ZSKdHmtwDugLB01etUM4SX3Yiy58JrmbJI7JD17NGRY/DWdeYef5H?=
 =?us-ascii?Q?cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3245F856D41484AB49135409A8B1F70@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?qorpwQuPIMyo0J308RqagH9qwXOtE+1nu8Yv6SWYklejYdonb04j0hGSJtwD?=
 =?us-ascii?Q?Z3zjiQuKNIaqv2XHjkHhq32pSthJuz09a1ZMd1VNmdkVZjPZQD30Ume4zhny?=
 =?us-ascii?Q?Q9Tawo1XK/covlSZchoqOA7jk2Dx0bn/gvmBh98+CAnv1e5T8KzhLTNmSEuD?=
 =?us-ascii?Q?ylsqRZDeNJyqsRtUoaKjwYinsn3GSweRrNlAvP5sstMkCENLjHqElxpIZ4e6?=
 =?us-ascii?Q?1AoGCte7oDZJ2F40mONlinXkUnrUmi3KmiD0X8t+XeVg5criXVdtINV0gkxt?=
 =?us-ascii?Q?4B+AuVYBjG1cnlMxmxc8EM2Fa8qw8VMWNBsE/plM9Ip9/giufLTZPvTwaaqE?=
 =?us-ascii?Q?N08CoOprqTFMMa/PwL28J1geh2mnD9rPf2Gd2JsoLqvqKqIWRouCVBsjjGL4?=
 =?us-ascii?Q?tFoMEQg6OudA6gqvAs7b9YqWNlKFgAaw4zco1KLiPXtMwDDGQDoUkCzt/LJ+?=
 =?us-ascii?Q?nYF34DY7sGpKzZsUSlV2nBshHog7UqSvZNKwhGgzmxzsozVr+cyLcTUPF/Oh?=
 =?us-ascii?Q?akzPROd1YKVy6FaC9OLIaV0AR/ZtK27njvymhm6yIWgwXAetwnnq1jc9xVUa?=
 =?us-ascii?Q?lAQPN+F7BM1YmMn5VkWnYn9lE3g9I+Ocr9eyLuR4m9RF0x7Cm/Kbfu97xZH5?=
 =?us-ascii?Q?NHKzHNkPnFv1ElzesUuihAzDNyq0rHkGvDrsXkAjoJ3+4jp4+cns/Vb75Xmb?=
 =?us-ascii?Q?eq+LL2qjXKurMrRyP1pxIyk9EZqwS8OIBwpau7mcGS8z6K6M1E3CsVtpdpve?=
 =?us-ascii?Q?aiYKIBt6WQx2JXgMeHfM7Z9BJjeZiUJvt60w/qedPl0pyNqJ6O3YC7fTcW1T?=
 =?us-ascii?Q?SZQAJ5ncYjVPp7Hl2EspEorbcWxzKvdyhNPsvi43A2TTk0PLAL5gZixPMwG7?=
 =?us-ascii?Q?ImztLKZTyDUInJu6CL8EBDmKr+fybi/OXkn3UXQ4Nh5cO/AcuOfONAZkiQQE?=
 =?us-ascii?Q?sO21olUz8ZBw1Me8cez3wR3M6BVilAHqbS+cHPcXtHPv1GBQeakcwTwLLisw?=
 =?us-ascii?Q?TdFk?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3f4b6c-9150-4790-7cce-08dbb91344fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 13:21:01.5707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GREYldyLcwJv3DQeBpOJFJGB3gK6acm++Fy/rWdPHpcdt4DszBENBo0ToQzNPyNkTaciPQTIjmYRUADdEVJIbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7779
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 05:14:45PM +0900, Damien Le Moal wrote:
> The function ata_port_request_pm() checks the port flag
> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
> ensure that power management operations for a port are not secheduled

s/secheduled/scheduled/

> simultaneously. However, this flag check is done without holding the
> port lock.
>=20
> Fix this by taking the port lock on entry to the function and checking
> the flag under this lock. The lock is released and re-taken if
> ata_port_wait_eh() needs to be called.
>=20
> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> ---
>  drivers/ata/libata-core.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 74314311295f..c4898483d716 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_port *=
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
> +		spin_lock_irqsave(ap->lock, flags);
>  		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
>  	}
> =20
> -	/* request PM ops to EH */
> -	spin_lock_irqsave(ap->lock, flags);
> -
> +	/* Request PM operation to EH */
>  	ap->pm_mesg =3D mesg;
>  	ap->pflags |=3D ATA_PFLAG_PM_PENDING;
>  	ata_for_each_link(link, ap, HOST_FIRST) {
> @@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_port *a=
p, pm_message_t mesg,
> =20
>  	spin_unlock_irqrestore(ap->lock, flags);
> =20
> -	if (!async) {
> +	if (!async)
>  		ata_port_wait_eh(ap);
> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);

Perhaps you should mention why this WARN_ON() is removed in the commit
message.

I don't understand why you keep the WARN_ON() higher up in this function,
but remove this WARN_ON(). They seem to have equal worth to me.
Perhaps just take and release the lock around the WARN_ON() here as well?=
