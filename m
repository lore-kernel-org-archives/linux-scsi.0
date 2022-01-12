Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63839C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jan 2022 16:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240486AbiALQ7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jan 2022 11:59:43 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:45873 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbiALQ7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jan 2022 11:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1642006778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5TTW9nCDGJ1gexOa4Yv14tE6WLu29ADVt0jAtv5m2M=;
        b=IEJXG0xNmwCG1DrgjJHZiYNS0chELoVGAq0mRTMyN2LSUigKgorDTcRc9l23AGXtY/7cug
        jRRoL1trgEO3njW1fI8LPLgUCMNbaqqLNDJAcfk8CUrZqguZNQzUH6DGIJ0X2eFdNFHfp7
        mrfETitbrhZDFZNGLmOlfcRuvE7pqu8=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2050.outbound.protection.outlook.com [104.47.5.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-15-TtOH8HnYPiWzE_Xf06G76A-1; Wed, 12 Jan 2022 17:59:37 +0100
X-MC-Unique: TtOH8HnYPiWzE_Xf06G76A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mY0Sw9Of9/tKi6cF7/H8HMRX49HSWTNIrM1pJmItHQbSljTpl/BP7zN8AE3PiXN72OLh1dZLHCXZV4otUsRjFxzZ+JxuGFbR5hHSgSQHdZp7Stb9kFeCprd1dCGfy36enTtsTq2w8enBHP4EVU9ksJaMSrYtIVJrysfsx2Q9m0y9lzuAT9mgtNT8w9/GoWcCWv7cgoEPa/kFBcXHXypImVKj26m0icKEdtI2ZWcJ2ovF4DhigecYvjM3SJh9njE1g5W3/53OVh7eEZgv45dSQv55GJ1ZQDkFmS9R5KlZW/J5RZjXozmSEoYWNiTqiy22prEjYmy3lvgfs1kvlxdBCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5TTW9nCDGJ1gexOa4Yv14tE6WLu29ADVt0jAtv5m2M=;
 b=l/sABZIvQJK7FJIONkfYSy6pgcLQHYt2kSpsIdmm9dd6eHods2KomE8fDuC6uVyR0/qHHuaqXNoLSsSrMd6P9P5xwE7vaLN5ZW3osWN4Lpw58VBVh7Dx9+j+HVemHpbnl07NTEXPMH2VgKbhgx55o/yuacatUPyQzJn9mTggAguITKD44T08jGria1O998oF5tj2w+J1Va9AJPxl8dec1/BqClMRK+pawrPL8x2vidI+vUomyazFzHF//wqdgrsR59Pgge4cKcKiqwDALc5gtz5chRa7iAzAXKLyueXTTIQI+dP07Z5+23msylWYROSBpycDz0Ulb9dWDrbtMBtzaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DBBPR04MB7849.eurprd04.prod.outlook.com (2603:10a6:10:1eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 16:59:34 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 16:59:34 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Thread-Topic: mpt3sas fails to allocate budget_map and detects no devices
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuaxVTzgAgADIjEOAAAtYeYAADnJggAVlwACABA+AgA==
Date:   Wed, 12 Jan 2022 16:59:34 +0000
Message-ID: <419311a6df021b0ba7b7e710caeb7e649ce8eeb1.camel@suse.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
         <YdZcABq/pxMMh3X0@T590>
         <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
         <YdcEJngPYrZk691Q@T590>
         <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
         <YdcNrSJJGllQzWOB@T590>
         <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
         <YdcZwVUFGUPgkbLn@T590> <Ydug9nWg4loEVkJw@T590>
In-Reply-To: <Ydug9nWg4loEVkJw@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33f12ee1-11b5-4f91-316f-08d9d5ece8f4
x-ms-traffictypediagnostic: DBBPR04MB7849:EE_
x-microsoft-antispam-prvs: <DBBPR04MB7849F177FCBB9BBEE2BA0689FC529@DBBPR04MB7849.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 63HBSWKnAtl8ahMcVrrDAbyJhYl8Vg7QN/a/2etRxTFJzK6MomgkrS5RPrTb/x3bEsRGXER4mTzVr6XgoRXdo8ksGMIfZ9Epez4J8s5POTaATnp3Bd+KeydHXtmmCPwpFHxajwh+4r6qXRxuGVO46M8+VykBt+VWAuQszFAZPatQUO2B/BinvZAjKR7lvvlI/uDfnZA0bNMUDA39JLWt7Dv+tLARZQsVFulnoSmEclQ1DlfhY1PPBKdNK0rWkMCoYtrxYHMwXx0JjnXzOZsnE87czv0clR2HK7dcm8JuUUMOWy1BgTEoXAv1Er1TGHXzS6EH7Ec42cKrqVn9q9UsWX3Qa9c99HCzRuXb9vIuPuexd9SZjwjisAi5qZsn5EIcR3GiLEfcyaCFNfoEXV3b3haPC94OBEGhlbNZJZOHZJtjtl6Y98LgI7u6WzEx1l9yW45sNa2jQTHBwRK/5JzWbq7XzvL0jU7wpmGeyn2MGusDTxJcs7zUCvo3nChwuEsjqbMLTex1MMh/yeYWK8a8V743OIyvunMr8Vc8x77vOx2hnyAujcgX0rT8NTdsavLM0Q8SHGOAmu++ICSANGlegvNHCEqe80c0iPZyoFVu3zRjtbqXwrJgHFTbImM51MHhZ/mwT3x+u7gqnV9bVSWVfjSh6OMbg4c8YPdQppOn5Q0oZ8pO//SEKWxP4o3uRSvPsBewyKTR8xVWt566HYf3bmWnrUtVB4KpUYiigM6X/RJk07BG+DrY0v2pbgfyH5bPmscvh1doyTtj2Irux5yibw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(83380400001)(91956017)(76116006)(2906002)(44832011)(6512007)(66946007)(36756003)(71200400001)(86362001)(8936002)(8676002)(4326008)(6916009)(508600001)(66556008)(6486002)(38100700002)(66446008)(53546011)(64756008)(38070700005)(26005)(66476007)(186003)(6506007)(122000001)(54906003)(316002)(5660300002)(42413004)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?WDVLzk7/AD2gRpC8fjNyvUh4bmuNaNxycUqM8FZ4ZDUwzxqosu4MmWY6l?=
 =?iso-8859-15?Q?26nUKMN/KF0AVEl3X/MZ+sXPtnwLrdd8xSAvdFzIlj8K7j+lhj9lfkgvd?=
 =?iso-8859-15?Q?ErSXXkHUzFWq2W9jLjis5f69J5JXVuUaSjPQg6mzbGGFrV6MaqkUFQt+4?=
 =?iso-8859-15?Q?JdojcTDrBe3Y2U0BiUruxOb7liyKAwfh2yZeG+Nq14iA5EY9RF4GbDaK3?=
 =?iso-8859-15?Q?i8wB+LV/RBf6hTBAB5PkIV68v1Yj3HxkF5cn6Gig4LShIgC6rpL8FrQFj?=
 =?iso-8859-15?Q?rfL9MjK4wgzKghZJ6v9koNmZ95EF2zYdJTiGCd/k+iYypCefnXngkPRxz?=
 =?iso-8859-15?Q?PsIVfTbi88HdEXjQ9nQ0oOCVPHfpkmMrQqVtWuKZy4kjKm4FO7Nl0TcaW?=
 =?iso-8859-15?Q?moasUCkvWlzLY+dQfnWZ+nnrRwmxD80vasSRkK5xCgOeyaopfKiboJil3?=
 =?iso-8859-15?Q?Ymsz4uPJLfVrhPZrfTi4NJG29rdERvqfJ9NiqkWVkV5lerzBL47tq+Dz1?=
 =?iso-8859-15?Q?M5X4Vs52a/Nd8Zty2+sjjQHVT7rgnxLrqXd3Ih3rHOT+Qv/nSBgHuwYXP?=
 =?iso-8859-15?Q?HkiZRgPWqY9yRoWLvJ4o9Cek2o5izGS44IWLOnTImymZ5MwJykSxclsV+?=
 =?iso-8859-15?Q?wcd7a5FRsUbkNESM7c9YjQzvHAQRyolDBWIxEnkkvno2K/4Gx7yx4jrhy?=
 =?iso-8859-15?Q?hhGqxU6OBtyetW35+tQ8jbo3EJa2fhha64LPawOUn2X54ywDd2vKpsmpo?=
 =?iso-8859-15?Q?31EYbidm/QqI57pz/ILm0JvdbLdAzJUaKRtVE2k8e7w21piL65fGdfvo0?=
 =?iso-8859-15?Q?Q2t1vwYzZIhrxvRzeQ00UEc1zMM8RFmMRnfv67yO/LrkIe0WACb+v657Y?=
 =?iso-8859-15?Q?sZvcBfFRQyGR1nnn+05rPa7dnYj2M3zrkjNx46CLeI3RBhQVMb0vnj8eF?=
 =?iso-8859-15?Q?9d4Un6GTDEL8vF8tCYOAV63AxmMar3sq1cVzWWXC2Rdqs1N+x9Z+3jvQ5?=
 =?iso-8859-15?Q?WF9+QvRNtKiI9/Er5rd0OV020RKsepiSYvGG9OxquACzAKUUePAlGWgp5?=
 =?iso-8859-15?Q?x2C7c+dYUJEAHkf2ZLkN8e3/fuMas/k7A7rspyzUszacISkB5j3+p0Ai4?=
 =?iso-8859-15?Q?C+JQHZ5xhfcAeX1z+BnCy1dQWK8WXTvJeN6td+RyGu6l9GQEE5KvzHkri?=
 =?iso-8859-15?Q?L3kiac3RqdWg7jZJNsaSnBfbED6NZU+YVlL8kDvPwHFcOlMDCcE64mpEl?=
 =?iso-8859-15?Q?Gs5nB9xML7uc2zckaPr73Dwv+PJRXRKLsnOJ9gjPwln6mEpqllsxfkU/q?=
 =?iso-8859-15?Q?btN6yJ3UucUi5Z6h08ssETwbMXnFO2tAfIBCqmLxfxJXQMrdyy8Dv5Vjj?=
 =?iso-8859-15?Q?7mv7mTNuX/Zh1DsvB9/rsUqrxgiSNEBmor1yqdLO2K3fU0KuHZa/MHber?=
 =?iso-8859-15?Q?BZsjqCcsJnHRB8ALGKifxYOz7hjwe6+IzpvrQwA2rcdj+cvewxU4p+BNe?=
 =?iso-8859-15?Q?XSkQsb94UMMtCDZGgN+BJt2bfIx/7+P3QcieJxbfeZPjHxOcZBhkXbEmR?=
 =?iso-8859-15?Q?tQFdUSmRqWjAIMQi9JLpxlcVNPeRSaPgcwkNCY/Il4dcIPrdJANS5YYb4?=
 =?iso-8859-15?Q?ZEryYAIjHiUcapwMdUNBiSe1UyKtWIhA04TtIRMLMJmWUdKr+x7PnCXKU?=
 =?iso-8859-15?Q?mTL6cT7oTTGhjzNM+IqnytMBP13o9Ck+jE2X0CNRR9ARv+0=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <926FC80774594C4D9D354EF89F87CF58@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f12ee1-11b5-4f91-316f-08d9d5ece8f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 16:59:34.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1c26iecSWdDL8nxQLfh6IilbR0fV0iS5q97f534YF74XTBz148LxXfqwWGADMKqxx7dQ5WAgvlPLblpTHKg9Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7849
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-01-10 at 10:59 +0800, Ming Lei wrote:
>=20
> Hello Martin Wilck,
>=20
> Can you test the following change and report back the result?
>=20
> From 480a61a85e9669d3487ebee8db3d387df79279fc Mon Sep 17 00:00:00
> 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Mon, 10 Jan 2022 10:26:59 +0800
> Subject: [PATCH] scsi: core: reallocate scsi device's budget map if
> default
> =A0queue depth is changed
>=20
> Martin reported that sdev->queue_depth can often be changed in
> ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
> or ->can_queue won't be used at default actually, if we they are used
> to allocate sdev->budget_map, huge memory may be consumed just
> because
> of bad ->cmd_per_lun.
>=20
> Fix the issue by reallocating sdev->budget_map after -
> >slave_configure()
> returns, at that time, queue_depth should be much more reasonable.
>=20
> Reported-by: Martin Wilck <martin.wilck@suse.com>
> Suggested-by: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

This looks good. I added a few pr_infos, and for the strange mpt3sas
devices I reported, I get this:

# first allocation with depth=3D7 (cmds_per_lun)
Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 7 0->0=20
   (these numbers are: depth old_shift->new_shift)
Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: map_nr =3D =
1024

# after slave_alloc() with depth 254
Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 254 0->5
Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: map_nr =3D =
32

So the depth changed from 7 to 254, the shift from 0 to 5, and the memory s=
ize of the
sbitmap was reduced by a factor of 32. Nice!

Tested-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>


> ---
> =A0drivers/scsi/scsi_scan.c | 56 ++++++++++++++++++++++++++++++++++++--
> --
> =A01 file changed, 51 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 23e1c0acdeae..9593c9111611 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -214,6 +214,48 @@ static void scsi_unlock_floptical(struct
> scsi_device *sdev,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
SCSI_TIMEOUT, 3, NULL);
> =A0}
> =A0
> +static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned int depth)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int new_shift =3D sbitmap_calculate_shift(depth);
> +=A0=A0=A0=A0=A0=A0=A0bool need_alloc =3D !sdev->budget_map.map;
> +=A0=A0=A0=A0=A0=A0=A0bool need_free =3D false;
> +=A0=A0=A0=A0=A0=A0=A0int ret;
> +=A0=A0=A0=A0=A0=A0=A0struct sbitmap sb_back;
> +
> +=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0 * realloc if new shift is calculated, which is cau=
sed by
> setting
> +=A0=A0=A0=A0=A0=A0=A0 * up one new default queue depth after calling -
> >slave_configure
> +=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0if (!need_alloc && new_shift !=3D sdev->budget_map.=
shift)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0need_alloc =3D need_free =
=3D true;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!need_alloc)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0 * Request queue has to be freezed for reallocating=
 budget
> map,
> +=A0=A0=A0=A0=A0=A0=A0 * and here disk isn't added yet, so freezing is pr=
etty fast
> +=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0if (need_free) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_freeze_queue(sdev->r=
equest_queue);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sb_back =3D sdev->budget_ma=
p;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0ret =3D sbitmap_init_node(&sdev->budget_map,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0scsi_device_max_queue_depth(sdev),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0new_shift, GFP_KERNEL,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0sdev->request_queue->node, false,
> true);
> +=A0=A0=A0=A0=A0=A0=A0if (need_free) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sde=
v->budget_map =3D sb_back;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sbi=
tmap_free(&sb_back);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_unfreeze_queue(sdev-=
>request_queue);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +}
> +
> =A0/**
> =A0 * scsi_alloc_sdev - allocate and setup a scsi_Device
> =A0 * @starget: which target to allocate a &scsi_device for
> @@ -306,11 +348,7 @@ static struct scsi_device
> *scsi_alloc_sdev(struct scsi_target *starget,
> =A0=A0=A0=A0=A0=A0=A0=A0 * default device queue depth to figure out sbitm=
ap shift
> =A0=A0=A0=A0=A0=A0=A0=A0 * since we use this queue depth most of times.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0if (sbitmap_init_node(&sdev->budget_map,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0scsi_device_max_queue_depth(sdev),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0sbitmap_calculate_shift(depth),
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0GFP_KERNEL, sdev->request_queue-
> >node,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0false, true)) {
> +=A0=A0=A0=A0=A0=A0=A0if (scsi_realloc_sdev_budget_map(sdev, depth)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0put_device(&starget->dev)=
;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0kfree(sdev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> @@ -1017,6 +1055,14 @@ static int scsi_add_lun(struct scsi_device
> *sdev, unsigned char *inq_result,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn SCSI_SCAN_NO_RESPONSE;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * queue_depth is often cha=
nged in ->slave_configure,
> so
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * setup budget map again f=
or getting better memory
> uses
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * since memory consumption=
 of the map depends on
> queue
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * depth heavily
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_realloc_sdev_budget_ma=
p(sdev, sdev-
> >queue_depth);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (sdev->scsi_level >=3D SCSI_3)
> --=20
> 2.31.1
>=20
>=20
>=20

