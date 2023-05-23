Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBB6C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 10:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbjEWKfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 06:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbjEWKf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 06:35:27 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E320FE;
        Tue, 23 May 2023 03:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684838126; x=1716374126;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B2O8dVjKTIPTrJA55fK7+c7+R68Zb1hAWCOfH9mlXow=;
  b=UC895Ut4qna9AALAXh0RL/I0uEwVznuPrkMRPzEI7lIm6SCOdRkXnoem
   BFCv6u37XgsRe7Rt7X7uPso1GSNLtCxAnDhhm8V923tyKHxPXfxMHOzf1
   D2KXL+Z6SNp0XwH40VZXSEauH6xHsFyphAMxR+jGYFxmFAb/8G2VjPxT5
   GATvh2BrT5Tz1LQ3urMTdnyc0P3y8TpcEn3Q6VibtQf8W9qe6IQ192RVu
   eQ5crGAfY6ugEwbFUUjl/gZOeeaDtu3CgE0+6+1ppGvTnSOsYIbrC0e0U
   ExUWAqjX0ZlF5Jk/tDW3O682wzrRIzl2RzdS2ZsEN1d+f9cDibyogY78M
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,186,1681142400"; 
   d="scan'208";a="231358537"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 18:35:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jx2fUBkbBol4NfojrH68x39fghVPfJydFbSaktjV6Sqxt4fiamLzYM4Dta/x0wA0RDAJi7A5ca7rahRrNBt4mMVjqZ223Axx9V6sFr//YeoZQcea6HvQoBj0Wbeaj6AX/8wmvmYqK9u6txXHSYPBSo/8zwPQpWsVsOw8skg9UvBr4sMwXCaLAFAYhGEJ+r+T7RNR4KSTPS/snu73OxFfftqNMLz59xwVtRboHbZwxfaH0+uBjwlJxS1jQuxMa1cVQJImB7///ClCVFyKqcXOpx5q5/oMsmozvRaGGYcjnvhX46X+59u7pcZG2vOhGlHS9e2FjXrNkR6XyQYMHExGog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2O8dVjKTIPTrJA55fK7+c7+R68Zb1hAWCOfH9mlXow=;
 b=h+Dvl1tmQRyvkad2MVzg2anwMdn0bKumV8DZODiOBjyowFBhnO3D6JTKhqtpN3c3atrja/z6GqBiYne8XAc2lS/bsOvtBO4sx5D8xvLaqs8w+7SNJ07ULsY4s8ABhLfGoc7oD1CR+FCkOwXZ+35wVtqV6CSqhaencpw6PJxurRH6T9sfjaTIFG7/dyLfqhQf5Xi4O6JVBNVLt1Id00lQe++R1WvY1Qh+0jde61auJPqCQx3CaSc3Z7WRawtXhCUpY5iZVDY+MtE8zrt4WeRCwO6FgZWE/Z6vkMduEY3wPwmiV+zcuJZXeulQg0NOckRQUJMVlGzH8bhBbeVDmNTvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2O8dVjKTIPTrJA55fK7+c7+R68Zb1hAWCOfH9mlXow=;
 b=xdA0rB2nNhjrth0WsUNOuI+1lYISGN+ATBqA/AmkAXNzNztquL2ga8yyPziBle4RWKfUnJIuSsk0qet/BHJ/XMhTy8AjKvExTvKmmET00ym7X7G6dG9wNAsLnHceGvmpRak1DpgqijsuaGEZaq9qZF/XEdrTTensEiBmYKxYHWA=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6963.namprd04.prod.outlook.com (2603:10b6:a03:228::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 10:35:20 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 10:35:20 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Thread-Topic: [PATCH v7 00/19] Add Command Duration Limits support
Thread-Index: AQHZg6YjwmqGT0LeSEm4gLZ3+3m4lq9m5R3RgADNTwCAAANQgIAAB4GA
Date:   Tue, 23 May 2023 10:35:19 +0000
Message-ID: <ZGyW54tCwesk7IXu@x1-carbon>
References: <20230511011356.227789-1-nks@flawful.org>
 <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com> <ZGyN1KkCXsTo8ZwG@x1-carbon>
 <09f5d62b-1bd4-3a25-e178-2225f1c7b603@kernel.org>
In-Reply-To: <09f5d62b-1bd4-3a25-e178-2225f1c7b603@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6963:EE_
x-ms-office365-filtering-correlation-id: 99906d6e-e7e6-42e1-8b49-08db5b79681a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mIZCiGD/oKIdUFS78iW5hEse43uXZDYQmLTOpqwIjzVq+wWjj+HuPMsHKfck8XXfz2CDrfyhxU/a8cU9+LmrrJ0CDulB82e8e5KG/dFeggBrjYFzXaSW/tamFzzmnHcqk4MdLmyTAmH7s7+Hw7eeauXAekvYZ/9KiyKeDlb3wOngCFVP/IPfbrun1GPnkhOZM6y0Muomfy/ckVRBdTKa1Z7CPAv52UoH1Jyqd32EBtX9QafCRdZ3GO39eMeWWKrwwtNSCJE3oPdwvbHray5grDdnFiBHQswmnEHeemE7TaVUTz2w+ZEHCmyiF4ife6o7I0bU01/OmDjPediQMfFR/zm8UadVqpy9dxbgasBU4gV3VF92IQSbYHbDPjccuo68cEh+zR4JS7QOVhej8JHM1OnXSebb8RU05jMVPwMr+JxWF+XUcT5KThgnY1fkBZInmN+gw2gxw4CzRhf47PaQ3FVlKD8X/hppiWtFhwdkwkDyHFUyIIiqn+Nu9OLF1jNQBGzDiFB2W8gge09xurNOGg5W92yb69WGcSsUh2GQUwyD9gNgLaPdpbyP6Xy6PwvVL8MUf3r9PI3vvmB0Year3ad6sbEJzyy0Zeb4v7tYTrY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199021)(71200400001)(41300700001)(66446008)(91956017)(64756008)(76116006)(66946007)(66556008)(66476007)(2906002)(186003)(478600001)(26005)(6486002)(316002)(4326008)(966005)(6916009)(5660300002)(54906003)(6512007)(7416002)(8936002)(8676002)(9686003)(53546011)(6506007)(83380400001)(86362001)(38070700005)(122000001)(82960400001)(33716001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?89WZCK0Wl73t/SY6+gjVzconc3BWD4TkbIUlYagQzCc1rEezyhpQ3k77Adis?=
 =?us-ascii?Q?BQeAA+0pRewaHSjLM8myKYw44hRChRPjFjQW2hyFaeH6zdknUQZlVJtHkLYZ?=
 =?us-ascii?Q?YwOIAJRy+S/SNr2GVNiyoyAwrkm7ckyVHz7TlQboMWExKncvz65UIQT7QLoC?=
 =?us-ascii?Q?88U06xOHmOJqqrbsaTdgXoPsJ1l6QORrNqJlQd9W4he43UJF4PlD6Z6pxOaa?=
 =?us-ascii?Q?k+FlmKcgghKmnMh92OVeuSFccgDQttjzry/2SdJPyeq4FJb0CD3iEffVKIa4?=
 =?us-ascii?Q?rSihYl03LADZV8DDwQ8LXfXJbgkrFmOtlgNnRsTo6EKRt+5rdNtxIEnNRpvW?=
 =?us-ascii?Q?kt4zzCxqWpkPYyDJDeHFuYhv1iO3EHaZYo9lMl9Ne8k7aPg4hiswpEWCPZvq?=
 =?us-ascii?Q?3B3ekV/eYsIY0VzmqXUokbSx2u5gVWrqBHBxv7zmVfXupKT24rtRBeTzhA5L?=
 =?us-ascii?Q?zyVHXU1mGMa/3t/LuCZJypD0HUBJv1uVR10ETtvHthwHOyNMM4UyDrRbLZhd?=
 =?us-ascii?Q?voTS/WJfQHq0+Q2XRI/1As0uuo+8aoBOZxwca93iJ6dBn+VbRSWfdWFuLMc/?=
 =?us-ascii?Q?W5vZApTSDDqUvX/tv14O69wWmwdsSUm+epupWVN+ykJFIj8Wg4eFgLOaEzYt?=
 =?us-ascii?Q?xf3+zH0jtpIyNzeDCYYzjEsugt0qrf27RRBUk5gwnM6WwVTO3c+jnA4ahsfJ?=
 =?us-ascii?Q?czkznn9mMOWjFOrn1BRv2PQUtPt/3sr3LOC2pkPJdaifhJW+UPd9dk2HoomI?=
 =?us-ascii?Q?VVZzETUwliINGOEuz8MB3FAkkRgX7I1Mjxts3G0TvRJZXf1PWxC9dIAbOadY?=
 =?us-ascii?Q?+ZmMiKS+TJ3vuRaY5eE4pBnGuCimMKlJrDHnZq71kjpnR2jQM5G8PvBiayOn?=
 =?us-ascii?Q?sleMW0BXHRplO2N3dfDv4wv4I3TC9F3pQXCPB/r3kZm5HZ08AE9UrYc3iB3z?=
 =?us-ascii?Q?hA9rsKhnSbDzI9YRLab5sEOmVvF4Xg5WgD8jrx+UQ+pDYnmGRA3FvdXkbovA?=
 =?us-ascii?Q?8wnF8SarglJvS8nhbvh4dOSqJz0ue7mo+kVgv+F4xGdmq8lo+DrQmHGgJtm9?=
 =?us-ascii?Q?TuEF3TTVD5vxerXNy3d2NUEbD1hiTtZlPZNRhyE+SeYR+CPKOS2AD5GW63+p?=
 =?us-ascii?Q?O98A2Uw7xYiKvNNVgZmVKRfiDB93/SPme4ziDLMfbGFIRgquEOZz07Ma4Vr3?=
 =?us-ascii?Q?PdK19KJLIqzlzX+11tUeBvSBgIHWJx/XHJw1p4H/cVelBN+dO0AbupXJ3y2n?=
 =?us-ascii?Q?l3ZwRmQ61kINTyYycf7xotFQ0sMqXkETmL2mj2s8b8kFNY66tWB5zfiOSrRv?=
 =?us-ascii?Q?2X/kViuSUw+vMaalbQ1vLf1/k4j+ajwxTE6wKlSB5ZNckcbrYaJTOzs/+CHN?=
 =?us-ascii?Q?mcioeonPJ027A9GituqlXDXSnpqmrhY6QfPQmDpm6+WRkcAOya1Fpm6g11nh?=
 =?us-ascii?Q?1r5SZaCxNwazYOeUarw8fBd6SoNQd6Ei+fKeeozV9Mhpnyx7b2Z80h4/PztG?=
 =?us-ascii?Q?Biyax6VwElqNuD2AlWBgvyeVti/rXVRkYWQrkZpM2dCdwp41IyALXN2jSwUq?=
 =?us-ascii?Q?2PhVDqw3sFdMLL7KOv4bx76HAEqIX5QH99aGlltEcrAbnFO3VIdfxYBAKt+o?=
 =?us-ascii?Q?wQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD716DA568F5D14CB6DB8815BEA41641@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?V4jn3B11du7kSaj94FaEXCm8MlYzY1NGqKN+5x5Zf2TEyWH5YJmFKvHU4Qyl?=
 =?us-ascii?Q?xbwM1SmoLkANyFWsclserXRI33irBtlrmFyzzYtKjnZWdAgYr8J0gIyKequ9?=
 =?us-ascii?Q?TgDA24YMrwtldIFREcUm8bLFnyesj2GAWh9Mx/d9+q40x9h92LARUVFpkaRi?=
 =?us-ascii?Q?pLxIC9o2eWGL1BC+RCD6LfKLdXe3HJJV/ifcuN+bY0ntXNJUwGdFPOI7qVf1?=
 =?us-ascii?Q?nnZcJrdMMUO5S90Ppgma9O7lnS7mfRLUTY8MPijHfW2RANoPEdJU0q+9CCXt?=
 =?us-ascii?Q?Vx9Px4AaEtTa7gayhS/yUVr2PzgeZASei6G4HIbhxH51CFpyt10H4PuBYhYm?=
 =?us-ascii?Q?jRRkC9WiOXdW4iTT8ANAJDsaKuYOIIMWUTNz91o/zx0L+zPVkn9DrM0OoCu0?=
 =?us-ascii?Q?l37z//tZQmBnGBQGg7WmRufe7h3qKqCcN5ojh4T4wT0tbBHJ8AysmGNUVuWH?=
 =?us-ascii?Q?Dz/PYwdj3ZjICRjdBaGmStxQcde4KnrcQYIDZ9TW61GHlYgmCMfgEo0cakZf?=
 =?us-ascii?Q?OM4C42h8G8HaAGjIYlLOXumLN/glP8A872Ol8FgvSklwFXr+A3+OFDXRmkyg?=
 =?us-ascii?Q?WhYGFbxZYFu+K0W/f6vawitX/AdXx7YrGfH8qDgf3H6sEmGW+YSxR7pJ42SC?=
 =?us-ascii?Q?+Y/brG9W0Um+PcTFNgGgiF6d2El9W0eMazxMnUZiJcT4VQFj7h5oF6P/CQaZ?=
 =?us-ascii?Q?SebyRa+POoZbGQZQ8D0boFPou2ps0XcNQ8pQMypDzf9b+X27VL6YJPF2QOlt?=
 =?us-ascii?Q?oVkbZrJv/NO1kS3YzURw8F2l5GQFkgFtKtbLcVV3q0jNS63vL7oAqyM3MCg/?=
 =?us-ascii?Q?AvNHJWnNuTWMHIH7zgmVU0nHF4Tuw/JXMCh5alpnbbswvZ2CkqsHAgxmRZzZ?=
 =?us-ascii?Q?LrMdsL8BhYprImS9ShtiTvz+N6xUI8GMyU0ktgkYWZ5rsbyh60eBOiPdrU7o?=
 =?us-ascii?Q?ADVcfpp40NBXqtZP3klWeQKCfxcqZxrBnETjWUH3/oAGr/j5oummrqSJKtPE?=
 =?us-ascii?Q?IkqP?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99906d6e-e7e6-42e1-8b49-08db5b79681a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 10:35:19.8699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PSmByupuTw7EanuSXiHO0IHd181XwYmDmWn6Fv83sJw3ozZeQl9HxPDxlZ35GR2QcR6eyvjOA+khywBI3YCNdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6963
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 07:08:27PM +0900, Damien Le Moal wrote:
> On 5/23/23 18:56, Niklas Cassel wrote:
> > On Mon, May 22, 2023 at 05:41:19PM -0400, Martin K. Petersen wrote:
> >>
> >> Niklas,
> >>
> >>> This series adds support for Command Duration Limits.
> >>
> >> Applied to 6.5/scsi-staging, thanks!
> >=20
> > Thank you Martin!
> >=20
> >=20
> > Damien, Martin,
> > considering that the libata changes depend on the scsi changes,
> > and considering that further libata EH cleanups are planned for
> > 6.5 now when the IPR driver is gone, I think that the best move
> > is to follow the advice of:
> > https://docs.kernel.org/maintainer/rebasing-and-merging.html#merging-fr=
om-sibling-or-upstream-trees
>=20
> Hannes cleanup of EH will create a conflict with the scsi tree but can go=
 in
> through the ata tree independently so I was not planning on doing a rebas=
e,
> especially not on the scsi tree. I will notify Stephen about the conflict=
 send
> him a resolution to apply and carry for linux-next. When the 6.5 merge wi=
ndow
> open, I will wait for the James to send the scsi PR and send my PR to Lin=
us
> after that with the conflict resolution, as usual.

I wasn't suggesting that you do a rebase on the scsi tree, I was
suggesting for a topic branch to be merged through both trees.

But I was just thinking how to make it as easy as possible to
handle additional libata patches that should go on top of the
CDL series (without creating conflicts for Stephen and Linus).

>=20
> So far, I do not see any big issue with that.

If you think that the conflicts will be trivial, feel free to
ignore my suggestion :)


Kind regards,
Niklas=
