Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF74C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 15:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbjFGPAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 11:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbjFGPAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 11:00:48 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B83410D5;
        Wed,  7 Jun 2023 08:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686150046; x=1717686046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9ip5KMsFe9mvFwGjmpVLee9wZlqhxJJlzEQmzysbbZc=;
  b=HP2VLwbZlxVbarNw2z93sFz6yJGTyqK8iwjPKGHpZZT76Qd6qI0dsoFw
   xGc7rwGEJxq5dWVUDl/LrDtngW+aGpxlaNHMP4sinJZPWvPtQCszseXI1
   jvc4InaiEodsD08dF1qcnCU92uY4LqrcZS8p2AUTTdB58Q8l4ZC/7kt+R
   28kcyzvw+cS1DCWwuptDODjXVkIDSJKZWUEtY9KRZEQYtzU+bBG+ULVuq
   1fy/1ae2mg7paRyiwZ30w35DQiMm7+h2a80scz0Afu8/LKxm4tkJUmxHq
   gD8n7l5tGsBI+BdUoIS8Khwj/FoyQnu3SuFKQT884+btV5qCYDWiOgEr5
   A==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="232879370"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 23:00:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXlRQD0Gbj3aWKBivZCei3xovOLDHrOI2nbB1HyK+p8q9Ua/r3OoO5R+hi4U8eTtQk5mKSzv7p5GLcRNRWtE1FYx79OhFdos0Xqy8DtI6lcngW7Ebvl/ihY8oGFUWQeFQExZLl0MXlqkAJoSESTDpzzS6h2FGzq/i0nTCk9qPkvZclKx5WegGjLPk/uphReQMeTB81WaGuKFExDpIEw00eK/LBVXwOzPqEfJecsLK3qN6wtWtMH7GnKkrc9aSMeBkFWLXKYuQV/N+f2MA843P+HZ5LCCTw4dutMGlJag8D6iqDosb0+PcnpPRX5h3YTZCDGbPZjOmdfm6pgHZWg2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDifJrls5IoPSNpQ7CYwa8d4JFwBRdTOmYXsv/ItGQ0=;
 b=KB8g10Lq+vNV3TtL+kpRplKSz8wQyIqnlmG98O2vR8KA3PmybYMRbizkP/ewB9aFpBlvqh6x6JvNpKwk0WprEVVoG0ms+XhCEm9+CyDG09dSv8Ur3v0Ob27JwETqpNt6kyg7+6jRHh7zpODJpr99XqyM+mgjWBroHQhc/D4ps+zHg1cIgY23FxCQ3VF7jGIUOC3RKZISTkvHPJBN95Vde0ALr169yukJ1/I6Wb4+Z8QyyVbMubSfBF1wPFeV8p02WOyaemrQi2M0JeHhwNDX6SirCOEiw66jkWQaA6cRaIuBowIa+d/vOJubHNbHa6iVq8dkACt2GihKePNQXqA2DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDifJrls5IoPSNpQ7CYwa8d4JFwBRdTOmYXsv/ItGQ0=;
 b=xtCE5/Zi4+d/odcCTGUzNYXXUwxd2uRd+bNa53tzBu/oRfIqKaLuV4XZTkcQGWrUn5qYgayy1QNs77hOUZ5VQ22cI+6S/NpsllU59kc17bd7oHgynwrS1UjKtGNellsGnBTjWHRBQwzGWy4A1rJbhxhJBcVrIUxpYU+t1t84NpY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH3PR04MB8832.namprd04.prod.outlook.com (2603:10b6:610:177::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:00:28 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 15:00:28 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] block: improve ioprio value validity checks
Thread-Topic: [PATCH] block: improve ioprio value validity checks
Thread-Index: AQHZmVDJkVbA+TzTBEuV9kJAy3hRQw==
Date:   Wed, 7 Jun 2023 15:00:28 +0000
Message-ID: <ZICbiP6JUrESMJTj@x1-carbon>
References: <20230530061307.525644-1-dlemoal@kernel.org>
In-Reply-To: <20230530061307.525644-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH3PR04MB8832:EE_
x-ms-office365-filtering-correlation-id: 71a088d1-9d0d-42f6-dbd6-08db6767eea1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7jtJ95VWl/gFT1bTV7Prdps4psqpE7XSu5667BRIfFVrygv1IhhWvyxkGCqy99jslH1sZcQ4ltZyu2l9eYwFScXfrrcMSs/6DF/ersHWKTDxojHUMFeDmxXOaGB4sDWZUMl+lZ/EIAnF4oOvJ+OkUk71ELqAKyW8wNTslXZKeRNl6s/JhZngJfb5167tqN3z1xe4ozzeA1hdZk6TwR9xR6EHUanmkgK47OGJjqYK/K/A92EmIn4v43b8iBYl0S51L6JAF8ncqXoSHK3vXykSWAJVv+H6+i33qom7YE3rdusxAHhGUczHPWF8bTYIU4SpvpWzuSHqJ4gdB1wg149vBT2Wi7HIAvcFt53n5xluCk2ltbMQVm9WfQY37KIFej7DWJs/hmvhNZKnppMh0Y8wH4G/gfx1Go3twCTA38XtRZFT8ReeGQuTfJXxa1BZCj2rXFzKZF+LZskxFDR2QXc7GmnwfePsZztux2WJIIwpwjdFnrAUIcorg7dx/F3QemXluTWAgs6bfdC2UlFQ5HPj1mMeQpv+MDZUSgbBKcwmjkSeMSe2CFcXbnF3umq2RMk4fGKke3Mvzqp8OjPeaMjF9UboN/NHIwO5AD6FvCmnXJI1orH8UiAyFPxT077sAo0t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(54906003)(91956017)(478600001)(82960400001)(316002)(6916009)(8676002)(8936002)(41300700001)(66446008)(76116006)(64756008)(38100700002)(66946007)(4326008)(66476007)(122000001)(66556008)(186003)(6486002)(71200400001)(83380400001)(26005)(6512007)(6506007)(9686003)(33716001)(86362001)(5660300002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WDu7JSXrQ6+iLDnDWxp6F3Tlyk9rxQatKPzlVq5q738IgsViG9KQ6cHYPS/o?=
 =?us-ascii?Q?fzmJE6hq1ZC9I3ZzZu8zI8/76mSvCWbhLnxwrkrzoGU9C/kBm/KrsJxw5BRu?=
 =?us-ascii?Q?kLgmE1ABBYpk2Xc3+ZU5QRI8IC171GfDWGA71tAKKSiTsj27EK3b9sazR8Or?=
 =?us-ascii?Q?t2ZbQD0GjWRbeyZpyslUAevATkZvhGXSYIiKxai5ZvLQTvalMZBpRT45mlXM?=
 =?us-ascii?Q?7aw4Ey/oFXjtbAa0SLgKYNcm7nyNZgRwbY+2iz+YqnRSeBaJhn9xXRZMuG9t?=
 =?us-ascii?Q?YU9DvqCALeM+KfLtNObmn6mIAgZlTVKusavUYOiEGXp1xiS3euI+ee63rj5K?=
 =?us-ascii?Q?KNe2jREDULmOQWgZ7M81j97eMvWxW42SeBBw2iJrDHEbyM6eCdEzAqqtiRBj?=
 =?us-ascii?Q?L9og8gECRcj2+aSvC0EOuTzrsArUTOqKTuBrQHF8mFEkv//JK7o5bIJmizhw?=
 =?us-ascii?Q?omERGKK8jF/I4FLZlz5af8g737QD2wzsdh2Rzs2KcXEtyJxzvCVs7g//NHTh?=
 =?us-ascii?Q?B3wUD0KXqG5NwbhH8NuWXaY2IGoj64GhWabAsX9e2v71px7o5EDUVQ3XovGd?=
 =?us-ascii?Q?5dTc2LK4v2qr1Zc26UHlkEm9gnVFqeXVN2tXwEfL3dyMacer0lFE+9Fj0cSS?=
 =?us-ascii?Q?48D+/GM8sHScOVE/KVp3kvhr6uAeICAtsYG0XMTckwLl+WalcjP4Td0PzbEj?=
 =?us-ascii?Q?qmDYk1WUs/Z3rJuxNCnJAkkTUHcTqgGPo8BlUbTUsV9hyNSUaKRLnX47XUWx?=
 =?us-ascii?Q?rs/Xns5pkMzZJcNh9Aon+CJV4N+ySvPVFzsWzxwAn+IBcdf5NtX+Mkzs8Fj6?=
 =?us-ascii?Q?A1Ztt85Xczmo1+YTasti2iaeBoJIHY00P6CYv6YlLCe0zs1mn6TqFtzWvofW?=
 =?us-ascii?Q?DVFajrwxhG/HOuKrvlyJYcwOWostW30gKoMBAxXAtSQmdUaSrMMVf3Fd7qBt?=
 =?us-ascii?Q?DcRjQqs1Y4yB+eXzvT/7KnPh7N/lwjpeF3nkskrifjay0XENbO84i5lXJPm8?=
 =?us-ascii?Q?EGtDruAQIjtkk5knTx/h2nzJmBitNc2WKUOHXgtCBxjYItuaULZWZ35JtlKa?=
 =?us-ascii?Q?oXYZKdpjvpdRoWENlkT4dQPsgk3tzw8vx2MqGkXzUGXYiPg+Wid7bz+6d4rt?=
 =?us-ascii?Q?wWsGI6CRml5PN0ZZU3koke5lxnp1MDK52CP/m4Jrgl/a7rzjnR/NjZPzHNib?=
 =?us-ascii?Q?x2N7Y52cBFF2KBAmDP5sPPZIRRZtyMV+4CPsEh0Id/X6liEaNM8CQZEKpKWb?=
 =?us-ascii?Q?owbJBhiiH5NhBA/Ar9T3br9ggHRYZsEakkeZKtTWZ4mHQeorzU97UTYH1Q8B?=
 =?us-ascii?Q?xsv8vJMoE27eS8hHhCMvQDkXzX20UzYyxtpGjM5WOBg+wHz25j4XlKySeUHb?=
 =?us-ascii?Q?+f9pE3+4xLWTEw6vW9Sxzhb2aqG2gwDeYA55oqLC/xkL3bnXEdL1FC1/BWXk?=
 =?us-ascii?Q?wbYblBsCg4yDLOqAU19it22rGytr38BXzweZYyfpjBR+Z+WcnIA6jMO9CWRD?=
 =?us-ascii?Q?gEgkat0Pnpubt8fRZ7DFX5s8x90asocKfoeog1LPlJTyb0nFe/xprjWMkezl?=
 =?us-ascii?Q?3Zb5w1F9XnYGZQUh7Ffehstqll6pGNHZhVbPgHxxrbWVmlPbvhz2n9BgXiRc?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BCC5013040E1C47B9A73B9EFF179525@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Pb78ojPVe3Tltlb0B88ta5zkR1HpR33+/rx5z5KUYAkYKOIu5XtaTgnbQSg1OSZZe4UiZ5SeactV50hZWEiCTkBYInL7kHpLJ2KrWk3w3pc1OR7oZ8E5Q3nHY00KudEPqzVOXo1KTZJvVxLEBe/Qc3sl8yEQuuFZnMzdea4XdZ7IuCcG4Q/AVfaV7SvJvjaMT3665TJnOpfqCuE3KUAiS6wuwh1/rJwLeXwSRwlzo9tWXRwwLSgYdcjpiWd20aZh95VNVSPri2HzTJ+mnz9hRo2V5EhbZDMll0QxDidcDdOxpT3YZLfcCIVzMuUxlJ+X2FHr9RPb9N8xmnRU/N8IiacoKntEMo7A22s5J2vkz1oUkOoQaEZT49G6qVWBgIPw2q5DfihHTY0VYlfgAFmK5R0dD3M2webUIvjsglpqPzvju3K4VnAZKascq0P3eOmxyhy11tFw821t2dNYMOZqzPav1xuJGdEugyd+TM6v+ifC+iRuNhvhyrh0+GvPfCBSLzpjpzjAZtsvGCP1qSKF5t+hGERKt0pR/ypJlhIHoiX+mMUxu4BvHcEeyBb2DWlutJ17jG85sQ/NC46nizpCwV3IrLXNURoDVLL09vNPEtizw5wSSbAhEmCl0EODG3BZiNEI84vqe3KHyjSRusACm1HV+LeaQuO0ZdQozhRoUAaDCk/VUbt3f97JUWyG4mfWJ8EuDWLCit//B2giVqbDwS7ns792e/kAPaMd4teBqFDeW+lvON1Snfsv5DQ+lxx7SDwmA6rcaeDwWc04wRcxXlaiGTQgMN3gUjtA5nGphwybxAmt0qwfPrCBx2/RKgwUppSqAF67HrwLwEGi74wFapT1EKmHFqCQyz/Nw0rrJoWgzsn/UEdoyKMnI1qqHPqR7DeWFS9NVJM8VEcIvnicpA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a088d1-9d0d-42f6-dbd6-08db6767eea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 15:00:28.5581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJ4zBuQcOs4WLOECx66IZhXawtpggWC9ckAxy5P2c8QZD7U2qwvAr87z6FzltQ2CZq/RSfaZIjqw44X3EdZEsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8832
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

It seems a bit unfortunate that we need to "allocate" a priority class
just in order to detect values out of range, but considering that this
enables out of range checking for class, level, and hint, I think that
this it is worth it. (Especially since there wasn't any _reliable_ out
of range checking done before.)

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
