Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D811C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 16:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjBVQLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 11:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBVQLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 11:11:43 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6661738EA3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 08:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677082301; x=1708618301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i+Wlg+V6YP8eb3nu6evLakfajmvp2udH6B5bj6VDMxc=;
  b=VCw/HcvfpMi5vQKzxs+GfTc14ZtewLnSoB6x0RRDdhhMV5rmPzHyIiMd
   D5XuTb5mtxHJ/+31kCbAqFgaMwf17FImLNyh1f1WpVGTbFTm8tGmUi5rV
   ZoMxii48oMDu4I5VEBiAkcbJpcuaZuOScmpFclhmBLJgxcO18AGOQ5EGN
   8aDGZn7o4d1/FAZ1NGKb1++3v++fqM9UYYC8eLjtFGNHuUK67DAEl2VRN
   BgxihRPy4VBR3jDq3pr5MMQkXGcFCHsTwj6UTZkXviKuOfRZZ/4i9E5+d
   u1Qw6VCA0TpZ3v6whXoAbGQWAQprgPuFyFlpzrizb/AMrjYi+yclTaZoE
   g==;
X-IronPort-AV: E=Sophos;i="5.97,319,1669046400"; 
   d="scan'208";a="223706588"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2023 00:11:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGQ4Jdt5SPBD8RZdBT3+n97iHl+RRdjrrOSj1n3frauY/uqFml2uYf8CYQdYsnXW2f4K29E6COO4tm5AUzBkfnhBefOr1i9wAz+mnkEp7bdbe2Uet+uUg8+PQPGxXhN854NKk+TbDoP1O1/667JlCBcv1opLhpYwH6ZYEmYo6VOexZcVWERJhbGvL9IsNCvdmgdyLMR/b4xOEAQ7wKzljCpNR4yk952v0StYhqB7M+jBGi4deZt6vXHpmrkR8BqmOcyHHjJfagntvqsLjraxP+KQIz7i6QSDdHRFkfV3ouZW3e5DVxgbEpikfbNBg0O84/WCQYtei7MMxoxZ18LDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oA1a+UVv9+ZuJicQor1j0cNJjzaLqI5E+GnoJTbmud0=;
 b=Hr+B9j2LloCDTyzTFdR8JfQIC71Q/pPpQjUbK2Esf7aDhTJiy6j+MjvgNzIhzgwfqTRyh6dVEW0+oGlHHDmB9aSpZLYXOBgAYJpeqVMiBqDZQpzc9otHSsNQpAcVyiu4VIKZQfNfhv3DvP1IIlnjOGCDgMfgNYGr5l0uUY8zs5ELy4/mq+C9NENr71tBcQbrSOn4FGlUAMsd6VZFKSbFhXXiArFKallrLK+IUu7VEEK82mmCn+RTo1bPgmPG8vmzbO4WyREYljMLGIikZa2Gc3Be/v2EqxVTtwdyt8U2H51lDnspRU+xSfoDRA2pW3ULu1Abz4o3KxoFYUj2C8bfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oA1a+UVv9+ZuJicQor1j0cNJjzaLqI5E+GnoJTbmud0=;
 b=g6McZ8rZ16RcBZ+GK6wHumyN3TdIdgh0dWWOcjtQcxo5D2lOgbEoB6ABpmmM+bf4632grKsmTJW7DxzPWOXDSYjWAVH6L73N51e5lbRF03lkSJ+aSeWwHYO/ammgW0Fpw2m69Vrjj97tCnaf1axSMVh5upqPp5eWBc+iu+3uEI4=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM5PR04MB0252.namprd04.prod.outlook.com (2603:10b6:3:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 16:11:38 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6111.018; Wed, 22 Feb 2023
 16:11:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Shreya Jeurkar <sjeurkar@marvell.com>,
        Jeetendra Sonar <jsonar@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Topic: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
Thread-Index: AQHZRthXbjSHHViHOkyaNmpMwA9lcw==
Date:   Wed, 22 Feb 2023 16:11:38 +0000
Message-ID: <Y/Y+uDrA2qmXcwnP@x1-carbon>
References: <20230221095708.29094-1-njavali@marvell.com>
 <20230221173521.GA13772@lst.de>
 <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM5PR04MB0252:EE_
x-ms-office365-filtering-correlation-id: 20e9a1cc-b875-4a9f-f1b7-08db14ef7a23
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtlKH4TWDXE8gMfxAyRtEEGy5Au0MyBotPscqnuTjTNN3jBwzat+0xXSAx90/WkaTwE8dYMf/VFphPzn+t3UCR84ple9b+wosR4WPZW/OVwB8Qh1J/8D+9hFVIKdpEH7li4If2gTzi7Y6fU7S+AvFqIyB61ycHAFyxvMwHTVl662L1K6i7HxisE/Zx244gaRlBdKNStrBz6OQEoITQLhyq9H/392xszWmXbtxB9G5h31jcZL4D4nFw84efHvtt6tyTW+UVdu52gbDdj4dM71AlJzLbpfFuzxBYo50S+n7XKPjv+UVtSM1j0TpRiohGtTXVo5k0OgExAjySBddr2avVrr28jtsh32+xb0mx9KGtLqfYMO5CJ7XtP5SZ8Zstssu4WMiD0HG8G7G3MBxEYrBKwh7tn+rg9dY7bOrtsv136H+VhLJOMYigwaeeZqkN/SKByDlMS6bo51/UpEx2CmOA/69clt4Z0B2HocEbaJ3BR+Kl3r3Pn0VJJ7nn72GFDLZSqWaWRulKL0jZ4nirLCGzv52cDTPsBmSAjIW8yDompSNeVcFhYSNaoTeDSEqJl1xrEjfzK/dihzHcyDlyRLLBCUjGwclHeujWeuP+/lR6KfEbsOPuml0WshO1O2NQt9LU1HUh00QujfwK5yfJWNy9Pu5dDBbEi5t7mpdm182/exqb1AbaOGMvIV4BdoEJHE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199018)(83380400001)(5660300002)(8936002)(38100700002)(38070700005)(71200400001)(66946007)(86362001)(966005)(122000001)(76116006)(478600001)(54906003)(8676002)(66446008)(66556008)(41300700001)(4326008)(91956017)(6916009)(316002)(33716001)(64756008)(82960400001)(66476007)(6512007)(53546011)(9686003)(186003)(6486002)(6506007)(26005)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KuhvHicwKQZOa91Rliid3P2ZDZryrARy7dtaaS3uBN2AjzGAtxjMQDlYFB+3?=
 =?us-ascii?Q?lwsz0oXyrE5o3L/uqWr+unFnGKO4dYi1DsgVJrE5MSvmkRqeJaX+/QM0Y022?=
 =?us-ascii?Q?U8eA8yijWafZ9fs7OTx87kwkZRtrP6aPgLSdDMiJs5yNmWUYU98UL+iR1Enh?=
 =?us-ascii?Q?rXTRSiqL2NrcJ0lELJP+AxiznQ1wISPEnEdzRQlgQzqqbnnzCFAwyBY6HbfD?=
 =?us-ascii?Q?Vzxui5W7W03lQA4ONY0vaFc5X8vHh5+qZjOItZmF+csZIIqD3ieGPovMEvOL?=
 =?us-ascii?Q?DP4mIPxv+jyzN3iPhpekKacGrM2skfQrsUiivFuf6HXIEdfFj81a57HkIha1?=
 =?us-ascii?Q?jlEmEB+Asb0sQetfIceJxxicp0ojKlhy861gtIx+e4Exnm8FE0OoHVSLVV4u?=
 =?us-ascii?Q?CIJsI/mTsGPTV1Stel4RsRB+K4BmiMYXeFWAl7hbfmIIo+0PZxvy63NXsyI9?=
 =?us-ascii?Q?wsk/W4nkpcqQa3WWXm49JAyFwykBGcieEjinXXnE6NdWOOZezpnNPReRvy1C?=
 =?us-ascii?Q?MUcL4mj7EYR13hPpiBnJf0QH/Ho7/Vb+S8jDpJqD7g74j5ki6xMH7gj29bRH?=
 =?us-ascii?Q?VrUwPkPoaEZ/Egi+JwhvwR3D2CvHXpv/f19DIbxppLzNyFqEtPL4yeGXrPUa?=
 =?us-ascii?Q?0DVlwREYTMZ3b3dkf8nRHO4fzyIVOQcrPPtLEQgzRgvRwj+vEJRdLJuNZ8sJ?=
 =?us-ascii?Q?3br1giK/U6L9qoCGG2LjjIhWkBuAILktn7i8laDV3bUvTJOIEdogryJgJgRr?=
 =?us-ascii?Q?WTBYDzm1spinsTDHSpzGHxpnCsU6/rq+gnFyduRkupIg000w6AEC+tv8P5Y/?=
 =?us-ascii?Q?0bU9UoEq9Lyr0H18FHq/8ym5Omd9yASYj+Bs3w9cA/a4ipBFK9/B1CytMPvE?=
 =?us-ascii?Q?UEYrJHGqcFvvU8TWl12KBvTGqaZoljUmPreas5ASCeyNNR6SIa8p9PqWZh8I?=
 =?us-ascii?Q?XwMQ8CcEnrdWcTRsyxo+R7wp4WnlW98OOWEy4pDffZWlBZbVTInCCRFLYTXh?=
 =?us-ascii?Q?/+HQLnzUz6TEV63alwXd7DwrrT/8IosKLMHJsRxcDnJRb280mrM4Tedf0LH9?=
 =?us-ascii?Q?x3bpygnbqErd/Ty1/ulhKk3YOvzZwq1x32yxz6ikQxOpg1Db8tXUY84jl8mT?=
 =?us-ascii?Q?76EYZ+uSe84wfkqntpvqW1EEnk2dqopHjyi07mKUY1KW/ng4Op3D5Md60LjR?=
 =?us-ascii?Q?C7q5IdF5C4ChM+lQZ6sun1xUp6aIvKK48Rds7PgCJyChLu95Xre/8PvbhK/C?=
 =?us-ascii?Q?DVg8veQfDbk1Qu3RicyB/pBv9nBeqnSeE9ya4/Kn0VDPa797E8yDahSDIXPP?=
 =?us-ascii?Q?LGlp41DaXxTa3liJErAQYK6rTqDRiUi8BgHUz9u+WqTape7DCZByzI/0yAjd?=
 =?us-ascii?Q?cNPUbYO6roTte0MQNl9XVxPmrjaq85Ob+ECL653RXpVfBpbsOB0hJYWeqRvb?=
 =?us-ascii?Q?GwpFzeAQZjKsoXSsLKyUUaEI6zOPhsTh0MVMYRqm2O4+LilnHMwB/B0st90H?=
 =?us-ascii?Q?PwRry+74OAOnXr9bgpq0NS+TCkHKDhDNOfOMHOnQKbYZXU/1OaMsilelO1sq?=
 =?us-ascii?Q?NQeOR9n/HvBMy7GZnV3felpfbUZ4wUm+gtePmKriA7CG74WMrMu+dN1txcqh?=
 =?us-ascii?Q?3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4251971963648147BC021F448C2B57CB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BtJ2dG3o6j2bcKxOL5yCLnxmpVp+1AiVFbeD5XvXOwZzn84rClsyAF5TPQr3sct2XRyofctQicm5jv+UsuKVn2301y8JHodoH0Ze7nThGwjolARNAlTc1qBUugLE+4uJ1nSHaC819lJJWIL+k1pNRxKWr/aOSjWLoGAd/WVuCp9GLFMLNivFM1RsYisENrbDT3yOSpz8UoHs8OZsAG6FNszWQ5VrVNAL7wj4rhp57aC8cNWnO2IlQaVR9ntM+j4KtqIMbCc8Dtf5+yYUK9PVoNSleRTFsCc2c0IoBVaCrTarx/1ShWw7gIPUSLqozpWux7RhY8jeE9N+empDqe5tkRT8fQkgio3oAOWzEiBNnV2UftDNPX8IjKz5bFEuRkJDFue6F57ntLvmsfnVXrJ8avATK2+w2AE/X9TSDtpkkk/weQAOr3dJLTFKg+8m6/53YimGh+Frxpow6G8CGj6pNDr5sD2U18VUsboEOcXUFUGr3DZgYdNJso2mZw2h5brReV/ye6Vca5XuGExML86zWmbMTXu0pQQ5tMzQrQKfDlYKKZLJ3PTSYkku5dSR6SaMPoifRZj501zF9NnpGTPosJf8LHskjO9gexPyMv8ANbxECNcok5YPCFCe/PEiTj683wz8Dj4djglSpZQSrRpBn0MSYfMMJ31QSfKVoeOZ4T2BA7XSZBuWXS4KnwwoXl5oovVytWmDIJ5EaQqHT2BNanpJJY24zdc4CuafZJcpD4PO0bxiLSaerx62T3sFwNpOZrRqUcCtRaxquu3ziuDI6tzWku29W6SHK8QGpNZY7IZNua9i6yFHhTEE/oOJKz+6LQxaeBKdKMFh0CHMNPHcdVSwQntdNqYCeeGHV6XOhQQrFMfgX6idEDJ6eErTuNgQsRyQxoPDThTMzQaCzsaJzvRxKbCAKP+xMsoPiZk7r3g=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e9a1cc-b875-4a9f-f1b7-08db14ef7a23
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 16:11:38.1659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dmyneiPekgfrJkgvomqXTge8XA0m9RLa2rJtNDAi5xU2vacT+m5NW367Os2p6VWQ4+A2Rq1R0zN8zwfMSuxWLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0252
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2023 at 05:59:54AM +0000, Nilesh Javali wrote:
> Christoph,
>=20
> Thanks for pointing to the commit.
> I do not see this commit in Martin's tree 6.3/scsi-staging or 6.3/scsi-qu=
eue branches.
>=20
> Martin,
>=20
> The 6.3/scsi-staging or 6.3/scsi-queue branches are still at 6.2.0-rc1.
> That could be the reason we hit the NVMe discovery NULL pointer dereferen=
ce issue.
> Any plans to pull the below commit to 6.3/scsi-staging or 6.3/scsi-queue =
branches.
> Or am I missing something here.

Hello Nilesh,

What you are missing is that NVMe is not SCSI :)

Consult the MAINTAINER file to see the correct (git) tree to climb:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAI=
NTAINERS?h=3Dv6.2#n14922

While SCSI sends pull requests straight to Linus,
NVMe sends pull requests first to Jens, who then sends it to Linus.


Kind regards,
Niklas

>=20
> Thanks,
> Nilesh
>=20
> > -----Original Message-----
> > From: Christoph Hellwig <hch@lst.de>
> > Sent: Tuesday, February 21, 2023 11:05 PM
> > To: Nilesh Javali <njavali@marvell.com>
> > Cc: linux-nvme@lists.infradead.org; martin.petersen@oracle.com; linux-
> > scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> > Upstream@marvell.com>; Bikash Hazarika <bhazarika@marvell.com>; Anil
> > Gurumurthy <agurumurthy@marvell.com>; Shreyas Deodhar
> > <sdeodhar@marvell.com>; Christoph Hellwig <hch@lst.de>
> > Subject: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
> >=20
> > External Email
> >=20
> > ----------------------------------------------------------------------
> > On Tue, Feb 21, 2023 at 01:57:08AM -0800, Nilesh Javali wrote:
> > > CPU: 61 PID: 6064 Comm: nvme Kdump: loaded Not tainted 6.2.0-rc1 #3
> >=20
> > Well, that's a reall old -rc.
> >=20
> > This should be fixed by:
> >=20
> > commit 98e3528012cd571c48bbae7c7c0f868823254b6c
> > Author: Ross Lagerwall <ross.lagerwall@citrix.com>
> > Date:   Fri Jan 20 17:43:54 2023 +0000
> >=20
> >     nvme-fc: fix initialization order
> =
