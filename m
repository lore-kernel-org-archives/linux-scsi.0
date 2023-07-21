Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7E7C001DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 13:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjGUNTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjGUNTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 09:19:44 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC58230D4;
        Fri, 21 Jul 2023 06:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689945557; x=1721481557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EOzrcnO2vPri3HEDAMGQSINg6vjRmPT0DaK5KlUjNnI=;
  b=P55tsNDk4sVUWrLULxtfmosGzW2Eew0LrVUTQtNbnTsyWACaqx8627Wv
   WWGVFJ5BYBCJCPurpPI1QTTHHWXEnEtirAE3LhdTdCKTHVNAFt/5OEZvu
   yCbtbTKn6w9vybkuzh+IEB6lwvR5K4XLc19jCMA5gYs5BKtpNs5xUbDSV
   aCypvkkO6ZronAtekf13VCQpf3T5MTZGd8nrXsqwEpynjfxH+5g6fhyN/
   2kAla4AOzlrIlXS+6yl4qbXtaONptiTtYSY6zzFekrEtk9iaH8fhgXS4z
   fzIicZpKrouSKiCmKAWEuXCVdrgGvDo70XjWTM5WzZ44AlJqc3HbNXz82
   w==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="350683228"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 21:19:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl+QrRYcwaBCsTS574jTBtryo71kGrd1n1Q1ODq8HX2NshKvis7ZUf5NwEe2XNs8ohNDS70TouBosCVCC2ZiHd9mCeGzNLH7MgpfLwc3yFV054daZJ0Nj7yxc4w1x6HHBWTJaIJYUCwALfrG+A/OlXfbDJrpz2L16Qed5kIIgGk4ttxoI+xm3X5jNHKGKUtGVyJ+yqhwwdnVnxfIN4bTSlDCKgjV1gk7IYsyQj9TkPuEqsf9CTtDCnS0Zq0hUYzqYAFwpKrsBrxjqB/VtSBC8EipkUu9ZakVwzzxPZrSw1WdUOypcKfpCW9bx4rgOXF2vmZ7eYvfO4fwo4y7pO1IeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0OLJ5P8yRF8yqtrUMTnBJvkTnag6OXaZu64YqlWers=;
 b=g7gUJZx8DZjjDUiq6zpKYJ+H+NJWBJunue4J3og9S3BeydD1DMl4lYv+HtfsZtCdB8mmkysVQIqtv4sWRU74B3bbiDHXVeuGX5aKPdmJ64zWr0MYFYgraYx6VZqRqKJItHuyQpQJTDExUfviLewqvRSlklEqq6CLwCDRGheUezWAntJHIPmEd9Wj0rm8ox0HzPkYnItHZbCSae5jIL8Q8Z5+h5I/7S9iIZWrUydb0UKLdtpKUcVFrffporpf83onAp1Dss8nJxAPagCGCOmcDi1VQl2ozSV47GKqoXlfbjBq5KKrZD2ByTKaykFM96dv3+LS5uJpB5h5shj/3p8UAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0OLJ5P8yRF8yqtrUMTnBJvkTnag6OXaZu64YqlWers=;
 b=OX0qjL3c7+bJvzxgBXa4z7SIBii3pHoouBrknWyENfFoQvPZ1yAKZe1NRwT6mU59uXLL8AFFelyCnx9f2YtykPchrWQPanK10/mQuHr02wr+/mJ3ceILUOcoRtZBwf7cqmIDfPA8jNcVO6Rby8RILp0zoGqefIsPs/7KArxw2+U=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH0PR04MB8035.namprd04.prod.outlook.com (2603:10b6:610:fb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 13:19:15 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 13:19:15 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     John Garry <john.g.garry@oracle.com>
CC:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/8] ata: remove reference to non-existing
 error_handler()
Thread-Topic: [PATCH v2 1/8] ata: remove reference to non-existing
 error_handler()
Thread-Index: AQHZuqOdaKUJUUYHCUG+psiQd71w8a/CWEEAgAHeWgA=
Date:   Fri, 21 Jul 2023 13:19:14 +0000
Message-ID: <ZLqF0oCkMygLK+3O@x1-carbon>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-2-nks@flawful.org>
 <917fcfe7-8306-0d23-253d-cb43353520be@oracle.com>
In-Reply-To: <917fcfe7-8306-0d23-253d-cb43353520be@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH0PR04MB8035:EE_
x-ms-office365-filtering-correlation-id: 6c09f569-90bd-4fb9-dc9a-08db89ed14ae
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dxUWgnKZJ4nEjvf7+x064YsaW/FTIv3JFhgA2LlOneIHaenqJfqkNfBCHrtZTWAj2C6uyoB37vrVf3k1+hh1ZPHPpyf2PwE55+LOH6pW8ceswplTbunlEN1+ILvyEn3YlWEhxbiYy0pJ79/6sXtdvUDwQk6UvZTIyMyXuAGKvVp0QJpEMh9uEC19AyHIhjS0d+ZzOckG1o3BL46oomj/3h5OEIQTIQF9QIsGAclAn80AxsvwJALx8KUvwu4lQhvcU4LLDc+nEwoW6/sxgaj/9y3Fmz7q2VM3st90EE6XLRRXa5Nmq0Hfk727J6eTlQiR8oiOWgIDm8tAc6w3l6zlN+5+tMQxCgQaxzi02El7tfkc46X2yo3WZkWH8ko09EWTCN1Wt7t4GW8fl2TI8RDhnMk2/Jdu18sW0rkgyUb+8TAbzYarmOD2FGsoabuBHRhYiH2rJ3DCy+hr/j4PuAbVO86rad7cJ6elIHQpG3zG/g+udtJRhCD5OIMexAPFILV459tCGCeL3JFzUL/9Bzhme/FNDYGROM3xX5anBHkfOzduDNoNTvCaRDNMEGCh+NgfACObGx97bG84KJ1OFjsK6LroOTsWAJHLJh+a+v2mghccnirVEqCoumrokghi8ONYKa5u8ItBP7FPSNgzL+6mQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(6486002)(6512007)(82960400001)(71200400001)(478600001)(86362001)(26005)(6506007)(9686003)(53546011)(33716001)(5660300002)(38070700005)(4326008)(6916009)(41300700001)(8936002)(8676002)(316002)(2906002)(54906003)(122000001)(38100700002)(91956017)(64756008)(66446008)(66556008)(66476007)(66946007)(76116006)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CB96eReHbhQ5GptTwLWY1+HiHQI0MCHANZM42DwydPnD4x2nUB5gevT19grN?=
 =?us-ascii?Q?EUqMrpM+dg+0klOrLdYDG/ncQAwgrZAStTyI8jHy16/wgs2jDTDOeI+O3PXH?=
 =?us-ascii?Q?kwpgo2v2p+NFJhdfg62152FNGcpZoKyrKKjYvUcVmBEoQQN8ZkreF3rpPaRg?=
 =?us-ascii?Q?hPjjYmC2o0Re+7iAkjV+zxOcygclHoPorQ+0Vm+bU9wDqWT+09w2q8qIObr7?=
 =?us-ascii?Q?w7dUxsUNO68ydIoEt4PS15utrK7uSzCc//VEIaMiTFO3w6swQzIxth78W9xX?=
 =?us-ascii?Q?9JHn+KcjxU5UFgVmPkpRU/6bwBfW6V6uLPjy/4U1V3ksEzhnb4ZsHBa5bl9d?=
 =?us-ascii?Q?SiSA4W2SE5zCswz7TUCOknya45oAMAJUr2ECJwuMVYiFjZMudxq9DMuS3E0i?=
 =?us-ascii?Q?J08x2WeKSlzlej123YHCCjbKuqYCo0ec3WZmrqCR5cZIUJMtbUas/HCIka0w?=
 =?us-ascii?Q?XRbkI42U6vDaMWzk2m62JpjGT06hIDS0SPdpJBr+T8vHr4q94Hn1OOWMVf09?=
 =?us-ascii?Q?YXwn0z4ylzdy+mBr5831Xbdy0U0Ui79ICWwsiTnX5JL1wGUBPsHSuYDSoMNt?=
 =?us-ascii?Q?+3bIpYMaKBICdyhp6tUGT8gdZ+IEGOCgMwlENX0k7zEjNjESOg7Vwn7bsgir?=
 =?us-ascii?Q?UdUBLK0QgD1UA13hJXaJwIlQJYzeLtwo9isfflP2pJhOabJfzDOtB1nHg+OA?=
 =?us-ascii?Q?2UJtjUjQiBz7XPrXY/2G+YmeSEi7LCnU/c6Y4Dq8xiTWxl8yPdgjxTcSBPK6?=
 =?us-ascii?Q?B550B1AkncSLYmfruVaxtu7/KznTweedenfXjcLwvuUdzeeDfOBj/ppKYlwg?=
 =?us-ascii?Q?LgkFE2VNTK0HR5x39p8Yk9lTJ2XL6sOgHCt30GU0WdgJopEkFwGO+ewW/0ze?=
 =?us-ascii?Q?8sqW4yM4/gHm0/Yt/hbitL+6OKe8xLM2Tt0sWji9nKKNan/g6LuXqWzTwQrk?=
 =?us-ascii?Q?mdtZzJw6mJft2eTphAW0nN7XhM4mkPlgvsLfNiFRawjLriaVv5qZI43MU+Ya?=
 =?us-ascii?Q?aUuuaa4c25953QJJ5HA2dF7N/IQBZ9jufRhzEMR8fXVBwPJybc34u0pSPx/8?=
 =?us-ascii?Q?fEmHYyadAVak8iHqcfOVECP1saSZRcgQb7wVd2obEpNhsDUV+A5f28teVAGM?=
 =?us-ascii?Q?0HQsbfFKUp7QImZi6ZuQ3mFXm0f5e1G3kgdwjpx+SMJ8ui4hnUtOF+KQB7YE?=
 =?us-ascii?Q?6sHkuhVKkde/LID7okqSYvTohalYO+861p2wGKOIYhRjwXhaiRFQpB6p5jkZ?=
 =?us-ascii?Q?GP3VuJ7MrgzJtHTfkqv8OMW8iBJELMbeSdaya6o5v0AqkZyqyIcMZs4GDL0s?=
 =?us-ascii?Q?jwBjQAOBWGHhAyUaSb6x9V98HMFGkWxJcACSslK+9p2ZtG7wvg2x+0WINTk1?=
 =?us-ascii?Q?lh3DY4JdxnG1/V9OdWTPgIMHbuXmGgSnHBF2BHoYfzXZ0nJsB+BPU28R8iGN?=
 =?us-ascii?Q?3DqfV0xmJNF3Un7Icuf66X8RnDEKWsL0jMJtupy/1EJGR43GO1WfZD47TNNh?=
 =?us-ascii?Q?nxx2Vujv9svC0op/DJ9h2EGKRqotRD6rD+JjwQLXz+bEB7uOLPCwN3tBp7ql?=
 =?us-ascii?Q?G/0ZSrq+rPJEqLpTZn8+M1RAINIGLPNpjvtj+OanJTA+/Qr9hB5tWVVdFT5J?=
 =?us-ascii?Q?Lw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87E954784D96C040B4EDBC22FD2ACBF4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qpguU4yTeO2NgfskiFgQ/lwC3190BjDCcs1zqghEAbFmLWtJ6aJ8PEvFpR6dguPr90YDpr6nkc9cLuBpfm/S0tje6OZapG4hTu9sF47M9ypshwDrIvbxIOTg294WYWCCSTwrcPNcBpXISymZMH09Ww0TF+2/1dc3frM/UzDjZdY4liUI1SRy10ftfCik6KpETIzBFeEWU6nyJp2YWQPGu9zo+h5MuFVWuqd4i28APKZrEMseLhYrLOpjT81cRxQEzwX4edjaqTzr23LQin9pZmyloQNO1B00XykaV/jtOGG5F+93AoklRD/I/Z+vTFKvsdZ4gcvc+JnHKEi6EhrsH8Nrkk/mpazDbRqQJq2tEJX6thK06a48H+2HulpuIhJZDpe4Sl3dXD4fwTag++3V8pyW1e5fdPSqwl8T2T/4CG993UbownDoAd4L6sIZJR5hN9WR18RAiz5N9D5A8xl96O0Q7QOyC4mntjOLUTeghKIEJTgIAO5rfB/w71FbiwMcTawmNO1dsVzXcZL76rgwFVtXWmKlRQp3ZAdQUFXWddl/734GY87a+LcoxGiXJuFjXt78QbG5flnb5RqQQhx5UIPW3nQJeoj95BujyLU6YSdyXtBa6R2CVcu4upZlyMNjzJQynQ31Kq+GzrYF5M0Yi50yMWg2qhrLWQ2z641NJt8yb7j+ct3iGh2BHuIjzeffnOJ0HU9LKP6g4Lrgobj/JFknIfuIxW4g4iHnhS4QWslr+Wodxx7Whr5hwPDGEeL+lCOJS6CkFajVElkJM006dxhGXAx2S27gVla4/giNLHWg5LT/dAynTAuYzGgw1HF69tge/3SJ+/+xXNybprsEqhZ2HA1D7X6z37SHgT14p3SSsDg5LVGPIpYJghM43Oeb+kzkbjUoZeyQK7dbdODZmTo8L7/XISOedBmM3HzGgmc=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c09f569-90bd-4fb9-dc9a-08db89ed14ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 13:19:14.9803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v79ELU42DQsddLjYAbH5X3O7/F9ghSWZy6CQUxZ85uzMcyNR7g69daj9vG4uUxLTabfnMSe1KqHITYyagJw3XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 20, 2023 at 09:47:08AM +0100, John Garry wrote:
> On 20/07/2023 01:42, Niklas Cassel wrote:
> > From: Hannes Reinecke <hare@suse.de>
> >=20
> > With commit 65a15d6560df ("scsi: ipr: Remove SATA support") all
> > libata drivers now have the error_handler() callback provided,
> > so we can stop checking for non-existing error_handler callback.
> >=20
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > [niklas: fixed review comments, rebased, solved conflicts during rebase=
,
> > fixed bug that unconditionally dumped all QCs, removed the now unused
> > function ata_dump_status(), removed the now unreachable failure paths i=
n
> > atapi_qc_complete(), removed the non-EH function to request ATAPI sense=
]
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Hello John,

thank you for your review!

>=20
> ata_qc_from_tag() still has a ap->ops->error_handler check, right?

Correct, I will remove the check from ata_qc_from_tag() as well.


>=20
> > ---
> >   drivers/ata/libata-core.c | 209 +++++++++++++++----------------------=
-
> >   drivers/ata/libata-eh.c   | 150 ++++++++++++---------------
> >   drivers/ata/libata-sata.c |   7 +-
> >   drivers/ata/libata-scsi.c | 142 ++------------------------
> >   drivers/ata/libata-sff.c  |  30 ++----
> >   5 files changed, 166 insertions(+), 372 deletions(-)
> >=20
> ...
>=20
>=20
> >   	/*
> > -	 * For new EH, all qcs are finished in one of three ways -
> > +	 * For EH, all qcs are finished in one of three ways -
> >   	 * normal completion, error completion, and SCSI timeout.
> >   	 * Both completions can race against SCSI timeout.  When normal
> >   	 * completion wins, the qc never reaches EH.  When error
> > @@ -659,94 +656,89 @@ EXPORT_SYMBOL(ata_scsi_cmd_error_handler);
> >   void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_p=
ort *ap)
> >   {
> >   	unsigned long flags;
> > +	struct ata_link *link;
> >   	/* invoke error handler */
>=20
> Is this comment only really relevant when we may not previously invoked t=
he
> error handler?

I'm not sure what you mean. I will simply drop this comment.

Further down in this same function, we have:

/* invoke EH, skip if unloading or suspended */
       if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)))
               ap->ops->error_handler(ap);

So a comment at the start of the function as well feels redundant.


>=20
> > -	if (ap->ops->error_handler) {
> > -		struct ata_link *link;
> > -		/* acquire EH ownership */
> > -		ata_eh_acquire(ap);
> > +	/* acquire EH ownership */
> > +	ata_eh_acquire(ap);
> >    repeat:
> > -		/* kill fast drain timer */
> > -		del_timer_sync(&ap->fastdrain_timer);
> > +	/* kill fast drain timer */
> > +	del_timer_sync(&ap->fastdrain_timer);
> > -		/* process port resume request */
> > -		ata_eh_handle_port_resume(ap);
> > +	/* process port resume request */
> > +	ata_eh_handle_port_resume(ap);
> > -		/* fetch & clear EH info */
> > -		spin_lock_irqsave(ap->lock, flags);
> > +	/* fetch & clear EH info */
> > +	spin_lock_irqsave(ap->lock, flags);
>=20
> ...
>=20
> >    *	ata_to_sense_error - convert ATA error to SCSI error
> >    *	@id: ATA device number
> > @@ -904,7 +863,6 @@ static void ata_gen_passthru_sense(struct ata_queue=
d_cmd *qc)
> >   	struct ata_taskfile *tf =3D &qc->result_tf;
> >   	unsigned char *sb =3D cmd->sense_buffer;
> >   	unsigned char *desc =3D sb + 8;
> > -	int verbose =3D qc->ap->ops->error_handler =3D=3D NULL;
> >   	u8 sense_key, asc, ascq;
> >   	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
> > @@ -916,7 +874,7 @@ static void ata_gen_passthru_sense(struct ata_queue=
d_cmd *qc)
> >   	if (qc->err_mask ||
> >   	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
> >   		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
> > -				   &sense_key, &asc, &ascq, verbose);
> > +				   &sense_key, &asc, &ascq, false);
> >   		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
> >   	} else {
> >   		/*
> > @@ -999,7 +957,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd=
 *qc)
> >   	struct scsi_cmnd *cmd =3D qc->scsicmd;
> >   	struct ata_taskfile *tf =3D &qc->result_tf;
> >   	unsigned char *sb =3D cmd->sense_buffer;
> > -	int verbose =3D qc->ap->ops->error_handler =3D=3D NULL;
> >   	u64 block;
> >   	u8 sense_key, asc, ascq;
> > @@ -1017,7 +974,7 @@ static void ata_gen_ata_sense(struct ata_queued_cm=
d *qc)
> >   	if (qc->err_mask ||
> >   	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
> >   		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
> > -				   &sense_key, &asc, &ascq, verbose);
> > +				   &sense_key, &asc, &ascq, false);
>=20
> Please check this - AFAICS, we only ever pass false for @verbose arg now =
(so
> it would not be needed, and ata_to_sense_error() may be simplified)

You are correct, I will remove the parameter.


Kind regards,
Niklas

>=20
> >   		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
> >   	} else {
> >   		/* Could not decode error */
> > @@ -1179,9 +1136,6 @@ void ata_scsi_slave_destroy(struct scsi_device *s=
dev)
> >   	unsigned long flags;
> >   	struct ata_device *dev;
> > -	if (!ap->ops->error_handler)
> =
