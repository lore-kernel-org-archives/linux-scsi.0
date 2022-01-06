Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E37C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 10:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbiAFK0H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 05:26:07 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57989 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237129AbiAFK0G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 05:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641464764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkGif3GccdOynTpapN9ffgRQTgriNewogN0Wk+IPE2I=;
        b=hmi3pgEGQV0vs3q0AJIHBEIwWE+OYcZBdHvAgSSLJJeG6UBTzohMMpPWf5AD5alXAwXpMP
        KucGGkXy6lJl0l948ZevuxZu5SW3upF44gZqqveMWiOB09Uk85abF/C/clfA+I2xzuud9a
        Ep2DnoqtvCa02S9xo7bWZJAO6oNx7J8=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-13-sjMr18tdOuKnxu4_IpdjwA-1; Thu, 06 Jan 2022 11:26:03 +0100
X-MC-Unique: sjMr18tdOuKnxu4_IpdjwA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUWP7aeULCrHDY2VX83ELYyFX6aHOVRhAUAwV431taHaKRGzecnABMQCiXwPyf3k9lk0g8TTgucEz4Dvb+NxZBFmwyhBwQaKUm++tsuOMvFdf7jpV1i5uc16xtUW9Bsk5xlR/WUpGQailYSGt1fNuWW1Di0QxV3lu74pGWiA6WLSP+zCXtpqdFIpCYsDa4dxvJRLmOfu1BFuHfTH/IEsBwLNv9XpioHXnv11TAHROfEqH4xthqwZNlajFaPslAfVy/IrViM/T1jR2q/L+gHO/LfBl0IT/4fFvhbWPI27RvT7K5tjOzq+FC6OEBPyH4KuPwsFUvkRUWT/HF8Nx1l6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkGif3GccdOynTpapN9ffgRQTgriNewogN0Wk+IPE2I=;
 b=mF5KzxQl31M+pHN+VYJv1Vgt3n3PY4kxgmHvLU+2BrIM+3fYX3QkULQ7WmHXB2T82g4BChUR81tKMxGQf7/mZrqDpNOfKIKkzOoB+jeKBBs7/pClMaLfJtAOLWjrIh4UGc8VPXzmIrgEVgPnzAwsA6VDtGXg7Q5waZlbE4Ocj1gpR6KE64EkOYirRXuQxGL41gEVEn93O527uB6H/y20nVV4LI4S9IoRQ1HcVbj7qy6/4UV0AW3zTdlGlkbVfQ7R3JuKF7iy+XdM9FgaVSo9O11ZxN9cBRZmwSPcepSuZckJQ3uEf3lrPSMW4XxXUtjC8nPZtCu/O5eBx7ueihp7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DBBPR04MB6268.eurprd04.prod.outlook.com (2603:10a6:10:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 10:26:01 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 10:26:01 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Thread-Topic: mpt3sas fails to allocate budget_map and detects no devices
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuaxVTzgAgAB7pAA=
Date:   Thu, 6 Jan 2022 10:26:01 +0000
Message-ID: <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
         <YdZcABq/pxMMh3X0@T590>
In-Reply-To: <YdZcABq/pxMMh3X0@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e32bf945-0d23-40c1-0564-08d9d0feeffb
x-ms-traffictypediagnostic: DBBPR04MB6268:EE_
x-microsoft-antispam-prvs: <DBBPR04MB6268E1961BC1C397A779DC95FC4C9@DBBPR04MB6268.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L7RgT3l7jdSr/xwFqDv5PDsVsdy28LxPS9rRt97vniB7g7xsQUN9tCZiaT8z5LnHVqRy9p7L/Qm9ztLeCsGOq8cTc0rLi4vCySlrcFScGXaQO7VSjJSJwH5SE1xUncG+7TjzENhl1dmxVpgv1QJB6wNVbLHC3+ADyHsWfBC7CGapbtQXCuwh9N1RmzShfuNq+erASL0uNesVHtQ3Auuh2OUHrgg4re4kYOXCiK85r1l0blQswPCJ4YhrPO0EHTMer50jm2QIRxfhvKAIorrG3Yb9Su9ntm2i7pavvItFtueU/om02KOUZhLpaMOginT6dwtDByuBAL8GHO4nk0z08cHx7D5hcrUIFbcQaquJZB2lzKXgVg13hISpQjKdZKzJvzthJVV2tCfvOicvM/ZfFUANB70I7sBqL/PrcWnXq6JihRztqjhoEkKQMbXcTBUNUaBh5fhC+2m8iSUuWju4XsGka1POccY3QP8ptgumJROanrgu9xQrKehb76HDQ4cCKVHdEyl+hneRNqI8PdFP2av0T0A6Lg2mD93JETL0OVzDk54EiKt2DCSlzqJUVb9U6Bh2LSBv6/14Q8e51c2DDML4v+VWCVVEPm3O4SmBBxQzyl8HkEhSqXdD4E7JxCn3IJZwEfA7jcFzISHp157UoAm4Q1R2IP64/FXf9gAEsGGC3NPjJg3sw97o1k+/Ti0ZSAtnFrfkz90COzDICkCjF5OXUjjC0Wmp0BI2ziR+vZWfei0Uu0+e8+P8AYDceQSmNm8cxqjGdzbosvFotZEtjEftcyhNyoiYuY+2utwCWJDkIBAEESSzKp82iq+UXwZA9v+930+U+Cwpi17gc4vR+HeHSrhDKRIU91SXNDgTYIg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(2906002)(186003)(6506007)(44832011)(8676002)(54906003)(110136005)(64756008)(83380400001)(508600001)(38100700002)(26005)(122000001)(36756003)(316002)(2616005)(6486002)(91956017)(38070700005)(76116006)(86362001)(5660300002)(66476007)(66946007)(71200400001)(66556008)(66446008)(966005)(6512007)(42413004)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?QgMCj9ZRIbRbO5u4AMlV+92ObT4mHeeRXlyUtws4slS/69mrFZowaHNuN?=
 =?iso-8859-15?Q?rc312YU2KgW6m1NQvE6smGZX8wVkRwo7Uw5rSR/6AC8ZSS4J2rY8JSbQL?=
 =?iso-8859-15?Q?IsNKJjYlorVWtvLMU7EXQ9+b0wEuCx+0akNNOlPpR4dhqLE4iQRIhsvFH?=
 =?iso-8859-15?Q?nc8bqavWVGSNPnHxQW2hMDbVp9HSCxDk+Dq4Qz1zfuK2gUiSEKSFG8duK?=
 =?iso-8859-15?Q?yAtFkCtjo5PPU7o30QAQEGp4XLg2fKDNtcbVWceM3LdNC0ezv/pHbK3jT?=
 =?iso-8859-15?Q?2v4esDTKBP8LcUPxrvqmZk2lAyyzF0asMgG9uYPpo82xsfXK80oqHAyFM?=
 =?iso-8859-15?Q?MdjYU4ZWiZJh61ZydHLK7dASaHqLktY2PrVuI7GT1yrfV0lSY5I+4T6GK?=
 =?iso-8859-15?Q?bgnUNA1lpfyqL8MT43KHk6yWqtzozoZgcY5SuIHcRk2em9KffoSDQdHcs?=
 =?iso-8859-15?Q?PRXDIf00sYilRIj6scO1BzXT/GFPjYwo+iSu3ehqgTp2NjDxKjmgXJ/ch?=
 =?iso-8859-15?Q?v6lzQFHKKrnmZGSpJhDYpca+B4kKgOF1RWYU3RabMPtzzPKvgwdePZv/2?=
 =?iso-8859-15?Q?g2SyRMIqAbBp6SCrpZQb84QySUoUXv4IxiIKIctVGAVm5A9RC8FwZRaAj?=
 =?iso-8859-15?Q?5yACTkYdBlP5AlhKjtx7r30ZG7DSwSx07aXLDcw6S/IwBWsZuaP3nfpQG?=
 =?iso-8859-15?Q?p5YjyzxWZWeNuBzGhqsaYEMY1Kf3KyDR3oj6SupzRtM6goqhzihR9o44Q?=
 =?iso-8859-15?Q?BuHD7SYo/wAJu5v0Uf8QAJVxZoJ/vqE4TrZGD62DsiDNBsHT3hCTrIKOp?=
 =?iso-8859-15?Q?CyAiGy/39bDbLyb6845V+7oil+lalaKcAa+4tpBcB5lSHLvB+0qiEwSX0?=
 =?iso-8859-15?Q?r2W51fnODL2/KOXQytlFYJbWMCxjdw05cC2lX8ojQEdpjvfd4pUg88rNf?=
 =?iso-8859-15?Q?KxN6yfgYvzAGUuX58eZVAH+TQSj38cs69npUhjS2s4P+k0Ia7KTRlnHW7?=
 =?iso-8859-15?Q?3GhMLYBzdlxt6ICpPqE7oM3a+X1XGhAWGELaujb3CMVAEgfH2zdI16Pl3?=
 =?iso-8859-15?Q?Y6R04HXTpcEbkbX6PDQky+jZKfDiGJYaXBQC2HT8SP00Nzn+aUYi3FLjx?=
 =?iso-8859-15?Q?KoqBMw3TbOCaMYHJ8x/aC6CvDGHBuhYN5uDClMK/jqsYoJJF55NaDpHk9?=
 =?iso-8859-15?Q?z6W3yhpKVRROrUMrKWc8SmiJxirGjETJG2kHYUHpwHSrH+0XmGpjSxwkc?=
 =?iso-8859-15?Q?MQXSWxYAI1hwCquzTikeJYDKMRnLe5KZm678IcFId6sZBupPCazvqYvgz?=
 =?iso-8859-15?Q?iAlyx2uyTfD1f/ashPEDmV15unuBHvCWyqFJZqAfZy9dROWMk2hJY8qO4?=
 =?iso-8859-15?Q?GrxLyw1CLcQytKk+rJjzRfs/S4/HpVbWKXloSX0Q3OSivgAlrOQqoGrAI?=
 =?iso-8859-15?Q?cdYQTvPQjGVCXbB/WkVE57ZBOJrrTSnzldKXjFxBonnTXSJp1rIxqxupL?=
 =?iso-8859-15?Q?vIPisqWd9PUi/VjMY1EvWA4m8JEzUlxMHbS5OjsW0hTgLJjoT2TPi+RlL?=
 =?iso-8859-15?Q?lcbSXrEn6VfplqDS4b/qDs7SLfDowgjWMDhX67beRCBg+xk5P7sKkk0UJ?=
 =?iso-8859-15?Q?2KX+xdSpHmVBalFD7I2YjZ6d5YI+Kr7wYLGG6dSL7LwCUV0yzYf2Y5oOa?=
 =?iso-8859-15?Q?/WSVmJD6s0OG3+wYGKWsNUhAwkOqznyRYZIY20hEo/8+2Z4=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <F70DF88630FEF7408BBDAD90A098A2CC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32bf945-0d23-40c1-0564-08d9d0feeffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 10:26:01.5072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JaHz5GJ9yssFFkYzlYGUAgYn+oqLhjMZ3k01dnpXMaQn1+/qzghtrlu8DG9mf4+MOivfeD/NoWn5radll3Z1rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6268
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-01-06 at 11:03 +0800, Ming Lei wrote:
> On Wed, Jan 05, 2022 at 06:00:41PM +0000, Martin Wilck wrote:
> > Hello Ming, Sreekanth,
> >=20
> > I'm observing a problem where mpt3sas fails to allocate the
> > budget_map
> > for any SCSI device, because attempted allocation is larger than
> > the
> > maximum possible. The issue is caused by the logic used in
> > 020b0f0a3192
> > ("scsi: core: Replace sdev->device_busy with sbitmap")=20
> > to calculate the bitmap size. This is observed with 5.16-rc8.
> >=20
> > The controller at hand has properties can_queue=3D29865 and
> > cmd_per_lun=3D7. The way these parameters are used in
> > scsi_alloc_sdev()->
>=20
> That two parameter looks bad, can_queue is too big, however
> cmd_per_lun
> is so small.

Right. @Sreekanth, can you comment on that?

> > sbitmap_init_node(), this results in an sbitmap with 29865 maps,
> > where
> > only a single bit is used per map. On x86_64, this results in an
> > attempt to allocate 29865 * 192 =3D=A0 5734080 bytes for the sbitmap,
> > which
> > is larger than=A0 PAGE_SIZE * (1 << (MAX_ORDER - 1)), and fails.
>=20
> Bart has posted one patch for fixing the issue:
>=20
> https://lore.kernel.org/linux-scsi/20211203231950.193369-2-bvanassche@acm=
.org/
>=20
> but it isn't merged yet.

Thanks a lot for pointing that out. I had a faint remembrance of it but
failed to locate it yesterday.

This fixes the allocation failure, but not the fact that for
cmd_per_lun =3D 7 (hard-coded in mpt3sas) only a single bit per sbitmap
is used and the resulting relation between allocated and used memory is
ridiculous. We'd still allocate 200kiB or 48 contiguous pages, out of
which no more than 2048 bits / 256 bytes would be used (*); iow at
least 99.87% of the allocated memory would be wasted. In the default
case (queue depth left unchanged), we'd use only 2 bytes, and waste
99.9989%.

When calculating the sbitmap shift, would you agree that it makes sense
to start with the desired number of separate cache lines, as my
proposed patch did? The core sbitmap code assumes that 4-8 separate
cache lines are a reasonable value for moderate (4 <=3D d <=3D 512) bitmap
depth. I believe we should aim for that in the SCSI code, too.
Admittedly, the backside of that is that in the default case (queue
depth unchaged), only a single cache line would be used in the mpt3sas
scenario.

Alternatively, we could inhibit increasing the device queue depth above
a certain multiple of cmd_per_lun, and size the sbitmap by that limit.
My gut feeling says that if cmd_per_lun =3D=3D 7, it makes sense to use a
limit of 32. That way the bitmap would fit into 2 pages; we'd still
waste a lot, but it wouldn't matter much in absolute numbers.=A0
Thus we could forbid increasing the queue depth to more than the power
of 2 above 4*cmd_per_lun. Does this make sense?

Regards
Martin

(*) this calculation ignores the use of sb->map[i].depth. Taking it
into account wouldn't change much.

