Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A643AC7EE29
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjFHKzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 06:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbjFHKyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 06:54:55 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCC42134;
        Thu,  8 Jun 2023 03:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686221694; x=1717757694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H6BTX3SWNufOIbClYC/fdfRWpM8BAUjNDZmj0ZiEQGU=;
  b=TwL7cS/yJEKUXB0PmI5HhsosyDpP9Nn8KVCle1gCRnIYEbgkZrfUUP/J
   RiurZf+06NlpRFkkXB3mtBpSTyN7Je/th0o+RQCe1iQjvGtdFhTI/KxRS
   JQnr+lSjBV2YsCY6C5Xgenm3DI9rmnpBBMsEI8sehf+Qt2617cXV59MLr
   64+J79hwAs3961A3I1wUDfmpm1JdX40aLs7QNVJngy77MM+Mn7sjIVUKp
   vZSCwBB//cwoenoBVoLoOmTipKwsYrULeS81Vebgwx9JgnUpVyBnYxGF6
   P72exZtWUt6P7+QOdaSnG5LTcjBn4JkP8+m5Jp5gyfZJ4CJ5cZKgESFeA
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="238129601"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 18:54:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXmKbiVIl5+SeiWd/fB8MvyFEgV7YAMxEe2FdZw6hipct7EaEAp6rNLe3wnUMNQhsMs6ln5CGYHK7Tmi48MNLUjBX9HaSUWBOV+sN85HeUbFnAbZno6yjUlH/dntQJ7xUe5Riz2KFqvx4iM2wu9Kj02byjl/kFo+9OuPMVWcxrqT6Hoiish7P4+oQWGnRsGHvh79nO5QWsFbmFb8wIy4d2pTC2DhA7FSJMhJPBa2/+PPMJx3bZjLuN9YNa1j63T4hpoICzKb00bDhGjUFJ431OfcXTwBVABgIsiSG1uVYrnHkQib9wU4B0oHndfM6raN2LVGBakJdJD9goO26JtUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAt7SzP3pJCasIuCQ4vwS4mkUzS+ZYeLTdtBcxhFT0w=;
 b=MvfKLILJozClagj2jQR1uZn/zMETpqBNZ5ShBrUn5qGF+8dtOBpPq7h5TyiOzT9w5GtemGiz5z40GDtT9e9Oq9aQ7EKQhmzksSfcY54pxFPtCMgkozxoR8/9iZ/pv9jZPRZ4UPPdS1X2G6ZCVqa5dV5/lt1EWwFKsfLENbZbufkMwuC5r+WUrDNptqca4QHbWnp6hVqmXdBRCyF+/806MKa+6c1QiDUMuHC+9FE3uErRZ1WdWVbQKCEkNfk+xVoAqL2jiVK0UTQyQCpoH3nmR/fxzrTIgMQLtsACPq7zWgx1J8DsEhnbEIfOsM/2iK8mtpL83toDIO3Q8N5QsjIMew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAt7SzP3pJCasIuCQ4vwS4mkUzS+ZYeLTdtBcxhFT0w=;
 b=flpP/AWt1/wkmVr9pBZSqsU5znCG8zFx5Ft4CJslKOwCNbPUqv5CpJq3JRgGW/qTNuJWDJhzmuu9DdwpYt2ZBP34eZbuCNQ9VEGrsXhfSVv5OndMN28CVHH0Mms8pu0XLAb3E7NrAqfUEou6fXRRPqBLJcgdqBW7B8mp4AgaRvY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DS0PR04MB8665.namprd04.prod.outlook.com (2603:10b6:8:116::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:54:51 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.039; Thu, 8 Jun 2023
 10:54:51 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH RESEND] block: improve ioprio value validity checks
Thread-Topic: [PATCH RESEND] block: improve ioprio value validity checks
Thread-Index: AQHZme9wLrxPZ3rcFUC9Oi6MuPRErq+Au2wA
Date:   Thu, 8 Jun 2023 10:54:51 +0000
Message-ID: <ZIGzejsez+ex9vMW@x1-carbon>
References: <20230608095556.124001-1-dlemoal@kernel.org>
In-Reply-To: <20230608095556.124001-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DS0PR04MB8665:EE_
x-ms-office365-filtering-correlation-id: f439df18-f779-4299-d85e-08db680ec8fb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FKD5Y/OLFYqz2cJWO3SbR/T1rWFtPH/JlcMAu10EaYOx9pVGH8i+innTbVXWH4/aesQ/fMji7fNM6aRqboDAj+n4KPs/BHG9bGG97H9Sn+iwpLSCYe7ri2fMHYF2mSAEwOAnC0+RQkS9noCnEgDPn2qtys9RWQX24SSp3tkk+2knS3IsQFadcV5VtgGlXOo6/Ol1KwcUBUbTU14O4HoPy56r6VTUErXZ1KPtFfK9F9OWVypscxkuHv8Ij4olzqV9hxceLkIFTLAIqX3spn6UlAQf5PXEsF0QBZPxwa+EDxalGtVEjueo+z9ZRrvkKehj/IS7x4dumWn4THcypMH8UAeGKHr4fOgkVyRrHrMme28H33Klr/JPN/iHS7wll1RcwB24KQL7KEp2haC/Nqeco4VeqRbVG6FoLr9O2nRYbmYxCZhahK4f4donAjOvz9q6igpBXoc5hGZVBuc/jWm7CgTG3+uxlYOuvKJmNHC/kWIYXa/uMaoh9Xz5smhDQ0MAyKvA1YQtwG9q36O8JDpL2/h+4NZbXqI9RfYNQ7NiFgGvRmVWGCp3kOgB5IHFZFWaI3wvtLPOf3UYsVf0p43tE8cebyWKO19ZSGATS2aLpz2Z1HWlCUvKCJ/ntJKI6fH804kFMZtaeAAUjtjegdhgHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199021)(66946007)(66556008)(66446008)(64756008)(66476007)(76116006)(478600001)(54906003)(91956017)(8676002)(8936002)(5660300002)(71200400001)(6916009)(4326008)(316002)(41300700001)(6486002)(38100700002)(82960400001)(122000001)(9686003)(6512007)(38070700005)(26005)(186003)(6506007)(83380400001)(86362001)(33716001)(2906002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WTlLZJIAqqXIhr2H9JjzvvTn6pIS6nY8ZArSwEDcBnoaTRTHEW1eZo3pLbFn?=
 =?us-ascii?Q?3G3FmvGmL3PDFdO53XrMXLAkaNfS3s7dfjc1jd28ib9zdmm1Ub8AezO2xDCX?=
 =?us-ascii?Q?dM5FMm+o0/FtWSYwMYwgpq8U3YRb0SBUi7fU/5gTmHvEvLb4E+oFrTgixyLA?=
 =?us-ascii?Q?juzIRVUxsD18E3bqMqx/OP9fG5MY7TuTyuZc1UCQsAAbe7pMUojYtr9e2wry?=
 =?us-ascii?Q?vs3NmNu6xUms08Hg2WktwY95R+2XpU/tCDtygp4dS1AeK8QGUJ/2II9z6CoH?=
 =?us-ascii?Q?XaNdQIO0122xizAfHhH8az59sVXpxNB9OD6nBkZwCBTP2MexU1SxNA/mW2cL?=
 =?us-ascii?Q?gJGL1akqYhTenf6ucSupO0dgnwsfBvVIEVaumkV50V11ylyfkf8liPsQrQr/?=
 =?us-ascii?Q?vWjD6mcU1ZdQEr0mrvHO3U3BsZO442zDXExSYKBalI9gsiOn9GJSL5CB/YfM?=
 =?us-ascii?Q?byPn+JzdJAzSrEkoxDxjptfu/aW0EvX2NrwkPE/2UG+CY9GQmCluYWdbDcn/?=
 =?us-ascii?Q?2DRM1swzVnkVxAj4lEDVfDrkZMv/NMt9d5BpeF83JSlCVMhtmkrUjSY7mKrf?=
 =?us-ascii?Q?+tVffnhBkS1pQ/MgbapbnuhbTKmGVydUVWRsLuzNcM0KIRHr06o++8qx8qfq?=
 =?us-ascii?Q?fQ/jTg5H8ZoWLmzzeBi6R8tzZvGeynz1B9Gv1AZZ4Ce6v3FweiBlq9mL7ZuI?=
 =?us-ascii?Q?WYZ7Bdkb+DUhZ9TmvOOciPc4g0plkefVRNGo1N3WnqSVy5WhOHbYKlsPpd6q?=
 =?us-ascii?Q?vlgbNY2rMfJX4PDoMa7NsEDy7XBJGWp8gtB7TcQLPky+rAVXsSSzlxJ765fv?=
 =?us-ascii?Q?0rVlaDy1w1vJYBzh7P+7UmIvv6HIJGnnovSbNQ9YoeE9viWF3MYq/qrh6QMI?=
 =?us-ascii?Q?sRjkl3iAVGZebrlkPNFjobxkJ48Ac0m0MKBdeCGecmi8YqQ4TK+6t57kMiQ+?=
 =?us-ascii?Q?p4mx9Pgfzwk0rnbNwaxv+EEvbC5PQwLa8Os56QflogVHmiefjse2tcMIQlKo?=
 =?us-ascii?Q?fLYhW+lNggaHuwdLrMcebwMBi1kW2Co9LqL3B/xCDxQYKK8UsJq03b/39Up8?=
 =?us-ascii?Q?cAG5FxPK35xpRs7v++xC9saUqVsQjlELhEK267AYr3pFh5eOTmiylaZQsqRh?=
 =?us-ascii?Q?CzPamlIaQ+NXg899z36Wuz2c3waLDsUabTjbRTP+DsDvc2MATkw4oF2EWs1h?=
 =?us-ascii?Q?nvSBdXwkxuZvl833ozijPgQNOFTw+mQIyCMyvcd8wE/lvudBQUCuUpnfmP05?=
 =?us-ascii?Q?Rq2ibyNpJpEbKx5ZVu8HdeUy94QN5mdDHpUlPAmSH6cARuKIkUxIZ29i5Uh2?=
 =?us-ascii?Q?L6nZmY+9/b6lStM13ZwZhRE1ED5XJ6O/QKZd5+ngGj4M0IBP79YncAoex2+t?=
 =?us-ascii?Q?E1rEdFlqOOlMccjMz+SnA6G5rFviIvAEgSrpJxRjza9wbmXCSkX9pvrkVmO6?=
 =?us-ascii?Q?uLm/x8DORHt9Jq1ncXk5lrrf53LTPMwzCk3OwgDKQAHgscVKL3v5mZanvhJc?=
 =?us-ascii?Q?/W9gTPR4Ty/ZV/OGI/5FgM4A7y9GeoL4I4JOj9rsADssS0ta96raB+A3lIYv?=
 =?us-ascii?Q?ivDuHXLpVRTcju0LYVBVyoO1auqG2j6dCX1N41/T+ybSkMdi+ZalitppkJbn?=
 =?us-ascii?Q?Hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0DBF036B65215F49AE6DDFBE8283A0EA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hepbXz/JIdNRuxt4yJKxG4yzOjqlOS56V2UtETPPYgwZRbp5ncUlC8+FN4b+ZGvKrAtboBvvpTMRBOWpuR+Mtn6e2ot5C1XU4789GOirwm+Rw/FwzmOBWCRKFoO2KCYwhKLH+mY1oSpOHuIykxgQyYs3c3aIxu59gT4/Sjer8fwYcQY6FTuHHeNwXZCyKwoZsuOtsVuPYHRHPy9/SVle3Z3hn1wTKKmY/mnY/LDLH7q0cSwx9sX792JRvbemLr4LGUP1E75jtwkoFbQYQsxYF96QcRbuYeTfgUX/drnYZOGrRqS1GDtTuxN5ihEkuW0Wi5DTf0f7Od2ebB+YsWhH0UZWNTr0xfjhi63Em6yOztEmtzPf++0vnO/5KUugYHfcKUjGeIYjkKam5Yr+YA2sphPHDWAnuIGiEkISGdORzp3hdfHPqCAjdwIqBiE7vr8MKc07eSV4QbJe+ffIicCs9jz7xlMVZwccxhcaXaP4Z59frYIylRx4SiCzKgD7mt7a08FwEfCo0Bk0X3K2LAd3GaKJIralmWhvAORyUraDabjENy8YEIIUR0sONiHJPlF//lv5hWXx3EpvyPVqDjB3EZ0K2dS/tCqo4OiuNPhEy7f2aVgQnmQvQD0IPm4vAKyjbhqHuz9h0bLKV2681db0VymkoFTwZyVXzcpNmiMpJoPJydp52JWE304t7QY60kqqRFzT07wBQmr0FzaBoFS2823kEpEeYd9bRQGhAoj+NmP4y5MHKwyiZoOoHmIa0cqaxz+Ub/oqOGUy6u5mpFu8azPo30st/L6W6W/oq2OK9xHoC7+9GaVqqbuX+kFabiFcHsDGhk8hSx/vrDtG3VB1VkKMzQhYPdw0ChesxXCu6JD2XfjsVw6HZjn9zokNoqP4ys3tqeo+Y90INdz88IhtJA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f439df18-f779-4299-d85e-08db680ec8fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 10:54:51.3263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yt8an0QvxlWJW6OmNC555zCtyAtkBZCo3AsXv5Nd1QpfkNvDmhI5sfVcD+rQ/8XXrvzwtDu45iOaKOPs7TGPuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8665
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 08, 2023 at 06:55:56PM +0900, Damien Le Moal wrote:
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

I already gave my R-b tag on the original message,
but since my tag is not here, I'm giving it again:

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
