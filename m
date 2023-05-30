Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3248C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 09:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjE3JJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 05:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjE3JJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 05:09:21 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD3134;
        Tue, 30 May 2023 02:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685437740; x=1716973740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9gIlzgNuMntLMHKXrcWQCvZb7+dVjvWiWQlZ/bQ19Ro=;
  b=rR66a1Ww5fLGeLK6VfxdNm1uvXkD/d8y1JSLp+DAFEA4TUfzfK57TX6a
   t1r/R3ge7ovsYgbGcGEHvlwKr1b7MV5qpgzRAsjBnKkiZm61AVnugSZ7F
   A23ppQppXOrNn2htFNBORINVuTGWyioiRxi10GQGYmug52b4QdbBp+3en
   Z06RaGH88NfFnioeuO/KLpyiT2TdkNJOHiocoP+QuYj/e31YmOO7i0ffd
   u+AsxaZgwFaJvnFi1edpohTp+XHFqTiCdTbqH/1hgNooXzFpYH1uaSx7v
   bmbuH+T7KDwN+Mo7OzzdalxLtCxnNjockAHKTvOUXrxlUcZQ5G8km4Q59
   A==;
X-IronPort-AV: E=Sophos;i="6.00,203,1681142400"; 
   d="scan'208";a="344065581"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2023 17:08:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/7NHrqsJQIhtDLGlPP3obrDg9GFNXQTJpbFiYDU+5jHak0KwZ5SrPogGsgA1BM6kwiGnm/WVjfZIw9seCo7nZgP/EEB+osKv7TSAybdZE5uxVf390Etn3XeAjkEuCG/LBh4tAlPloeH3OtlStgT/AtKUs92f6t2Zx538zF0sIneMlx87B278el6B3o6ibcFu6PI1FD9lw+lcsWPg+YVtudwv+yperv//5LXaMdRbe+9uK0RJWNKTttUyA61Hf2bYFexywWBqdBvuO7DV8NxfO57aDsef4BgaDJGQQkflIFa02MkClxP0Uu/l39rVYANzXVGMbzlyBqwiY/OQZZ99Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BikC5VGl7o9NEf7LaW+N9d98VGAJ1SptqHxMGj94EHQ=;
 b=J9XS1XtuWA17sLSeusB5yEuE44Gh7C2PCiLLOpuXP7qJJ7lJ7XfTkZ5B9Mk6/MhOzqx2R75cj4zST8x7Na2i9LEbWQ/O3ksnD/RqNF+kGj/JGf6yfAUImP+HyAuxv1Av4Rm3ep/Q61mPyYqmvhEVUq77A5IPc0Ivj3uCh7wq637tMp8KQuETnMsz/86+Zak42wjkQLGnFCadCBZ2+KmbH4IYE53mPSmWcLn9XzKfKcLcdeXR1uAoJJm7Ks7ZtYOXJjHUoscwvnGltEoqdlH72PbrZkKju6P/EQ9oS/Svpv5cniKdoWwyq8/0r4h6qu/v4sGu5u7PRpgKT5gVjj9dyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BikC5VGl7o9NEf7LaW+N9d98VGAJ1SptqHxMGj94EHQ=;
 b=cGffh1yDMygTYThvKLL7pGoypO07wLvQXIuVNMQ9foxpd+89oAE7VpYzLwdKI7bQhLf2KJG4jQRghCb5gX/kXnd2zpZ0aA7Si7/KZIUX1kfGHySasw58hi2P+1UIydyMyqOkFR/sJPcUfUWFdQ7GdWY88h0vrFbU9xgnTdozy9Q=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7213.namprd04.prod.outlook.com (2603:10b6:a03:291::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:08:56 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 09:08:56 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] block: improve ioprio value validity checks
Thread-Topic: [PATCH] block: improve ioprio value validity checks
Thread-Index: AQHZktZckVbA+TzTBEuV9kJAy3hRQw==
Date:   Tue, 30 May 2023 09:08:56 +0000
Message-ID: <ZHW9IQvePaG0yxY8@x1-carbon>
References: <20230530061307.525644-1-dlemoal@kernel.org>
In-Reply-To: <20230530061307.525644-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7213:EE_
x-ms-office365-filtering-correlation-id: a3bbb498-60c6-4c82-dd04-08db60ed7f4c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HC2buzpWcktPRFMuxXRGytsiMa+SAkIesBaXuQPVCmvKHyBM3gmd/E3Km3fKVZWYamelqQEVxj4uW3EFEf0w2z2mWvhNsg0s4Z69ggiPJPVfLPIRToAZXPMEaaaQ2O5NrSW+OidsgxpP8+Dl8HYkKwzrKs3eXcNrPeESF3FwZAFpGqv89cir4JUGgO3JqvEqJjNmy7KCaYe6bJPUxd67b5yj9Z9R5iOXqssnvkiFVzw1qBd911kE/Tvf5WWnVq28JWkKOQ4zHiHIbZAhZBPWVjlDu/093tqA61k97XTzqHM3yaJGN4kXqb8xUYBDlcSl4c3GN1FQJy/aYytILkHjSmZHRHQ9PAAV9M9eitXNEBlDLh0SsuT+ZhnjqTdNrjGiTBgy65ecYA7gp/vbQIBk5tkG3BWbiCAUBKGECAxXGMyXk0akdL/SOjF+rk41TR5y3aFiStRsVhGk/uE2L2ToEoyNVGgMNWiskXxerU4N9Jt5DY4t7tyYkZiqmnVvrgg4S9qsPbj2xVTzUdzeHbnE6JCsufqayaaaj6q/vws2RYJwfl3v2+d4x/2CSHXC9upoqTNA/RfttycHlF2AbNK9mQepa/6F8pwVlxcUf3fQ8H8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199021)(2906002)(186003)(9686003)(6512007)(6506007)(5660300002)(122000001)(8676002)(82960400001)(8936002)(38100700002)(54906003)(83380400001)(26005)(966005)(33716001)(6486002)(86362001)(38070700005)(41300700001)(71200400001)(316002)(4326008)(76116006)(66946007)(91956017)(64756008)(66446008)(66476007)(66556008)(6916009)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bajp89SzCZqtL9Tj2YkL5XRrj/nF+H5Vr7i0XUrVfhtEY/Q/apfuzYXcMizB?=
 =?us-ascii?Q?wIrF8uU165/DltMWbUzIrF79wtQ1HwcEDRUUcZwsYjDo6eriV4S2ZuS7nCCO?=
 =?us-ascii?Q?pjTdPDjRjVgKlET6RFRlHF59TAO6/Aq1HTGHECl4bO/a3AKHBStPWjql9GiS?=
 =?us-ascii?Q?/BBhZalDicNlirP1W08G8Dq9+HNs2QxmdwxpHTQh2QRdYwO+1xFDgD/VO7T1?=
 =?us-ascii?Q?Lzqj87/JMEBv8qhtmSKAPsLPz8UWKuN6SpexG+ddXaisMCgHFHc06cS2Dfaq?=
 =?us-ascii?Q?B+HICHNwdxhljIGSRyFUYt1Xcfj1XHqG8xZ+gLPYZfuVaVEFKkbtYwT3imjs?=
 =?us-ascii?Q?+iaGSD88dpgV4bc0ff6Xs6FmZsMpezj4/sLfgW8sZBWvIJoxwW056LT0QPs4?=
 =?us-ascii?Q?AThPD1quKnsahLGlEQPQyFioXMS9Z92YPqvn80tRQqfaQE8jXlIbJH2/jWt/?=
 =?us-ascii?Q?TawyrWkbNxVekl0pvv7X0m7guYFRvd339/l2Q9U8ZhDKHa8MoX7u1tMODUi9?=
 =?us-ascii?Q?enSSds795QSSGa1BpWdVMLQAdA5FZW9Hh3FWofuJeFpYAIjFWYAeon6R8pYh?=
 =?us-ascii?Q?JxUFCnGUpVnOqBQGfWLu/coBeP7wartIZgIqwgQK1UZN9NfQn9Lx0tRhu0JM?=
 =?us-ascii?Q?vuh6lXPt54yVYE0yf0MEZ4l65Ru/Woa85UePrNkz5zqloZkleVJNdpwdy8H7?=
 =?us-ascii?Q?j1cwLqKq4uPutHbdS1si2Wrfayes5OraLCGi+9fnnw+8Y4V8LTkc7bzWgeu/?=
 =?us-ascii?Q?Evo5wL8j/pyfITJLhJYuNQofgE29JGdCsHftu+8dTW3ZPc1hglDjijIcvex4?=
 =?us-ascii?Q?Yhok2KZZ8k/gDgHm5TWgTho9t81HWrGJZ9q+H5WwN3u7MoBTQUfd4oHaDFQ4?=
 =?us-ascii?Q?QeWBopNtrFjhyoYgj4fnYQZ37r4YXRL8hVPmwjdJXVVYbgc7MK3oS9pDg0MN?=
 =?us-ascii?Q?OLTHkA12s14qVl3SKlm1k659VyJIx8s9YR6Z2NtCuXF93Jggviz+OGevmOks?=
 =?us-ascii?Q?tTaKjSfz+dotYq2mNWre/5sEsQrEHExoxJ0ufFj6y10RDzjZ/VDZBI8Ub9Di?=
 =?us-ascii?Q?ve91uq6Tj0HYu0gWLesXIJdja/vSWO15FcEHY7vchyM3SDaDZcjnqG+rxEV3?=
 =?us-ascii?Q?bOfztI5vv2sJfQhRP5tr0KvtrzpLxNmkYqn6uXAyIaQV+jSqG6Ouy/oy2Odn?=
 =?us-ascii?Q?ItOUsOyPsGDfdDbdPhGwAZDayfPgGlR/6W3tZB57m9c+JDrOf3VMDXaD/Ny/?=
 =?us-ascii?Q?gmnAhJ0ZWj47tjoJFnkyB+NZQxQzC+oKQRJ0qOMK3HiLl18+NZ0+TeZmJR8n?=
 =?us-ascii?Q?WcNly5jSqOkBsOxa/qSm7qGSymb9u8lRG9qNeo03eMN/EGla2uKNUoofOPMb?=
 =?us-ascii?Q?en5nEYI9tOvKrGNsLLfRaiMtinzVlsP02Y0dHFhm9jKaI22SMRPHBVwr2ypn?=
 =?us-ascii?Q?kpdJ2aALA1f9Kw8lLOTojIxByng6Vf9AXP0wKUOTkWM7coHKyswDLYn4VMMg?=
 =?us-ascii?Q?7+N6cdyN/F+QwKne8ggQcdBWZgRwhveCMOTsPrqTUVPrH4PhB/Sw0S57NvyR?=
 =?us-ascii?Q?MUvP2obm12DfdUOt0J46XWnB0h3jyLd14EvtXJNEcmYi9CqiiQ1MUMyVjrEW?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <963644280437984A9874A5DDCD3DB969@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: et0lOhKLfunaS1lvVz8ndNRHYxe1LSnjZxeAOW8yE3ne8dZoiojMPKWOp7NOWlg987UwwY2cQ5wm2shkIyOfHORHBFReQ5XV5LDVfKgFQ/5WA+4RAqRrSxYIkvdCj7dkxyIckrCuVBTdtr0KSc5EsUnk5Y1LCnQ5hq3yE+xgebCC+F/Z1h60TgGE+Yohvus2s0QXk16lBk8KVYZWMAecxfF7/XrZU/WZZ3yyno1kRCojsTe3/yXwxqHnJClUi0dGxe1ZTMQQ3/ULeN9BtsyECVPkUafCbEJMtXX0QdtGm0tW3rBHWPGuNvfE2RL0ZsnVsdVcZkYJGorZKFk5nhSpqqVYQQGjRrCYehyMKTzGMC4oec5k1nriIQVE2NI2TDk7mKPQXnpczPCqkXmf+fHlWB91wt8ipY5dUYqmNpkGgpVQq9+P7H28Qs3+ZpKupuDciBLiSIN6ExHQZAt8GfVa1ByDB9DTuqA/VS7SGlEbGWWKAQ6W3ymgit/8EDoSnMHa0zin3ooiKGQ0H50l+7ORS6thPZMGSkXjlJ2ujwQsluWTv2BpvJ9ts3/gPv+YPgaG1Se1PV+jVA4m++f8u3rib4J5LE2oMun0Ygzg4zCmF4zekOHf8qGR7dD3ppww6zSrvlpLo6zCVKbtKc4p/i4j47KJr2gzHYzblLkCU0KI3B++B8bI6YxDBkoHqZnfpnjHW7cDodxkoNS42zhlrP+qTKbg5ncDeXN6cyflQB1TKot2S6jKwmSRTHWVh4T1Wc8TozCZz2Auyscru72on6C0tBXpQ74w0QxlM5VzHKKPRKoVzJCIpZc/OB30PY7jwJh2a1ky7udYl5GbT8g4uWQ8l3GTtikK7Hie36FilYa8oxzmn1VRR2NsSrksDYbTmL1AcuO91K81zsbc5nSh7srgug==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bbb498-60c6-4c82-dd04-08db60ed7f4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 09:08:56.2040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J3yZRAjAPzBlprl2Z3cBByg0eRL1x8IWjSs4LEaKOBMbhVw6ytqiyVwi1xnDi5kL365E/sNfdP5KxluTkARaSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7213
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 03:13:07PM +0900, Damien Le Moal wrote:
> The introduction of the macro IOPRIO_PRIO_LEVEL() in commit
> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
> results in an iopriority level to always be masked using the macro
> IOPRIO_LEVEL_MASK, and thus to the kernel always seeing an acceptable
> value for an I/O priority level when checked in ioprio_check_cap().
> Before this patch, this function would return an error for some (but not
> all) invalid values for a level valid range of [0..7].
>=20
> Restore and improve the detection of invalid priority levels by
> introducing the inline function ioprio_value() to check an ioprio class,
> level and hint value before combining these fields into a single value
> to be used with ioprio_set() or AIOs. If an invalid value for the class,
> level or hint of an ioprio is detected, ioprio_value() returns an ioprio
> using the class IOPRIO_CLASS_INVALID, indicating an invalid value and
> causing ioprio_check_cap() to return -EINVAL.
>=20
> Fixes: 6c913257226a ("scsi: block: Introduce ioprio hints")
> Fixes: eca2040972b4 ("scsi: block: ioprio: Clean up interface definition"=
)
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/ioprio.c              |  1 +
>  include/uapi/linux/ioprio.h | 47 +++++++++++++++++++++++--------------
>  2 files changed, 31 insertions(+), 17 deletions(-)
>=20
> diff --git a/block/ioprio.c b/block/ioprio.c
> index f0d9e818abc5..b5a942519a79 100644
> --- a/block/ioprio.c
> +++ b/block/ioprio.c
> @@ -58,6 +58,7 @@ int ioprio_check_cap(int ioprio)
>  			if (level)
>  				return -EINVAL;
>  			break;
> +		case IOPRIO_CLASS_INVALID:
>  		default:
>  			return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
> index 607c7617b9d2..7310449c0178 100644
> --- a/include/uapi/linux/ioprio.h
> +++ b/include/uapi/linux/ioprio.h
> @@ -6,15 +6,13 @@
>   * Gives us 8 prio classes with 13-bits of data for each class
>   */
>  #define IOPRIO_CLASS_SHIFT	13
> -#define IOPRIO_CLASS_MASK	0x07
> +#define IOPRIO_NR_CLASSES	8
> +#define IOPRIO_CLASS_MASK	(IOPRIO_NR_CLASSES - 1)
>  #define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
> =20
>  #define IOPRIO_PRIO_CLASS(ioprio)	\
>  	(((ioprio) >> IOPRIO_CLASS_SHIFT) & IOPRIO_CLASS_MASK)
>  #define IOPRIO_PRIO_DATA(ioprio)	((ioprio) & IOPRIO_PRIO_MASK)
> -#define IOPRIO_PRIO_VALUE(class, data)	\
> -	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
> -	 ((data) & IOPRIO_PRIO_MASK))
> =20
>  /*
>   * These are the io priority classes as implemented by the BFQ and mq-de=
adline
> @@ -25,10 +23,13 @@
>   * served when no one else is using the disk.
>   */
>  enum {
> -	IOPRIO_CLASS_NONE,
> -	IOPRIO_CLASS_RT,
> -	IOPRIO_CLASS_BE,
> -	IOPRIO_CLASS_IDLE,
> +	IOPRIO_CLASS_NONE	=3D 0,
> +	IOPRIO_CLASS_RT		=3D 1,
> +	IOPRIO_CLASS_BE		=3D 2,
> +	IOPRIO_CLASS_IDLE	=3D 3,
> +
> +	/* Special class to indicate an invalid ioprio value */
> +	IOPRIO_CLASS_INVALID	=3D 7,
>  };
> =20
>  /*
> @@ -73,15 +74,6 @@ enum {
>  #define IOPRIO_PRIO_HINT(ioprio)	\
>  	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_HINT_MASK)
> =20
> -/*
> - * Alternate macro for IOPRIO_PRIO_VALUE() to define an IO priority with
> - * a class, level and hint.
> - */
> -#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)		 \
> -	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
> -	 (((hint) & IOPRIO_HINT_MASK) << IOPRIO_HINT_SHIFT) |	 \
> -	 ((level) & IOPRIO_LEVEL_MASK))
> -
>  /*
>   * IO hints.
>   */
> @@ -107,4 +99,25 @@ enum {
>  	IOPRIO_HINT_DEV_DURATION_LIMIT_7 =3D 7,
>  };
> =20
> +#define IOPRIO_BAD_VALUE(val, max) ((val) < 0 || (val) >=3D (max))
> +
> +/*
> + * Return an I/O priority value based on a class, a level and a hint.
> + */
> +static __always_inline __u16 ioprio_value(int class, int level, int hint=
)
> +{
> +	if (IOPRIO_BAD_VALUE(class, IOPRIO_NR_CLASSES) ||
> +	    IOPRIO_BAD_VALUE(level, IOPRIO_NR_LEVELS) ||
> +	    IOPRIO_BAD_VALUE(hint, IOPRIO_NR_HINTS))
> +		return IOPRIO_CLASS_INVALID << IOPRIO_CLASS_SHIFT;
> +
> +	return (class << IOPRIO_CLASS_SHIFT) |
> +		(hint << IOPRIO_HINT_SHIFT) | level;
> +}
> +
> +#define IOPRIO_PRIO_VALUE(class, level)			\
> +	ioprio_value(class, level, IOPRIO_HINT_NONE)
> +#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)	\
> +	ioprio_value(class, level, hint)
> +
>  #endif /* _UAPI_LINUX_IOPRIO_H */
> --=20
> 2.40.1
>=20

Some additional context:

We noticed that the LTP test case:
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sysc=
alls/ioprio/ioprio_set03.c

Started failing since this commit in linux-next:
eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")

The test case expects that a syscall that sets ioprio with a class of 8
should fail.

Before this commit in linux next, the 16 bit ioprio was defined like this:
3 bits class | 13 bits level

However, ioprio_check_cap() rejected any priority levels in the range
8-8191, which meant that the only bits that could actually be used to
store an ioprio were:
3 bits class | 10 bits unused | 3 bits level

The 10 unused bits were defined to store an ioprio hint in commit:
6c913257226a ("scsi: block: Introduce ioprio hints"), so it is now:
3 bits class | 10 bits hint | 3 bits level


This meant that the LTP test trying to set a ioprio level of 8,
will no longer fail. It will now set a level of 0, and a hint of value 1.

The fix that Damien suggested, which adds multiple boundary checks in the
IOPRIO_PRIO_VALUE() macro will fix any user space program that uses the uap=
i
header. However, some applications, like the LTP test case, do not use the
uapi header, but defines the macros inside their own header.


Note that even before commit:
eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")

The exact same problem existed, ioprio_check_cap() would not give an
error if a user space program sent in a level that was higher than
what could be represented by the bits used to define the level,
e.g. a user space program using IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 8192)
would not have the syscall return error, even though the level was higher
than 7. (And the effective level would be 0.)


The question is if we want to dedicate a priority class to be able to detec=
t,
in runtime, a user trying to set a level higher than 7.
(It will however only work if the user space program uses the uapi header.)

One option could be to do nothing. The previous check wasn't able to detect
invalid levels higher than what can be represented by the level field, so
this behavior is kept, it is just that the level field itself has shrunk.

The LTP test case needs to be updated anyway, since it copies the ioprio
macros instead of including the uapi header.


Kind regards,
Niklas=
