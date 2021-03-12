Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95BFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 04:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782BC64F8D
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 04:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhCLEiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 23:38:52 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43152 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhCLEib (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 23:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615523910; x=1647059910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SjF/caavncbCBIwdOvfTOJNh/zN8+Q4T1GslbBV364s=;
  b=B4DVJuod9opIKwLZcimD7MKtNEF2DGl9tcLYubMSm1KNz08sNHKj1Cal
   pQA5NNM0mmcg+BLPVvbNNp1rNDc6deXs1VXvbsUG2GzYLqv3MyDYz7Jh+
   74HbQEJA5GJIIbSkgHi+5QGdKmy4Fb2Mi5n0PUKxRR0iGjdYh4zqjcSYY
   Yc44EV2aLmq2FBfHNhx4nughTEV1nrIdSPRy5HwvexZqDIp1MExo3I/IR
   VvaFD0EV+C7hzZb5/7F+5lbXI0/ZsIsohu+Q0tuHNr1Ht9zaIiMMUGE8d
   GFEtbcUqgFgHWtKpD8hCn4jxy2Uw/Qq+nHu8FNgIRGw0Q3U8S2R8HyZiG
   Q==;
IronPort-SDR: btT6irRPYTu2nCGQ6P/IkJRlf1MxfnSP2LKNN6S403i0IWmHVDZi2b2yv8Kgb/gr3STdQ6IV7C
 Z6pf6foo/J84jLGA3Ac3pajsR6yS/gsfBNWcJ0DFg2E45pNop8CvWx5OWS83AkD39pkh3IoQui
 M6F7KhUrSMNBlc3sogCB7yLtPUhdA8OGi2aK301HkvmziQOAj1OME9w/TjFW/5/u9ztRoOgUgQ
 uAxsKLnEj6BQ21q1rotWCfui8GhXC2eFwfMqDuYIr8hBGF7sJESpG4/FMDsofPpU6/dopa4iHv
 zBM=
X-IronPort-AV: E=Sophos;i="5.81,242,1610380800"; 
   d="scan'208";a="161969698"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 12:38:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab0SDpWyTESnwkaJthHkix/Gg2WPYXaJYd5kWpFYkZM23/ZX0IzaQEpRGB2eyBrZu6aHlcgFbXnlGFJTZfzsvPMJpOYuyObjaVjEJ4PIKHLsNSnQr1V60kaY4yaZUW8D5eat+l+nDge2T04Em2yEWSl90VUOxSeF4jZut8KeHxwpZ1LPqMSaZDXq1sgrH/9iWgmLdpePUi7ehkRVXmzrlxq4sYy4uUbLo3bBjz2u9TbKmokw49jeb2Z6IyC2PfXBcID0/cBXXHm/8eDiC3JELfIMaDZxZUTRcJBmA3ttXwyDXAv8C8r3QNukeXWWvjdDEW2oOcM8IywlQq+WvFderw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjF/caavncbCBIwdOvfTOJNh/zN8+Q4T1GslbBV364s=;
 b=DFm7OkoYgpMuBPEso6jj4eD+QkBxVLyVqBSaUP+W6xHkMKsSxje2/h/t4LFG/VTjC0gMNAiiPPGyMu/bN8BipbR/pgDhLjpsuSmvcdffSHnEUJcmDnjecqUg8vj3Cx8yPtdGb03bmZlq9p9PCrboGuuQLjjtCDv0fKVxy7CTMyVHF//fkidSAhPuEtOXPK13C3LaeUDfWNeOzWEjDwQJpYda9ohVV/RtIlXkmXptSxLaVksfQkWaG1+11JJLkwKfWrRLp5WIWMdyDrQUbwJbOYLUlVjHUTMCiJ1k6V/qZArTilx9/PAbR08q9BJXt3pNbkZ0Dzr+9SmEbQ/V8P6W0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjF/caavncbCBIwdOvfTOJNh/zN8+Q4T1GslbBV364s=;
 b=bmGA1kOoFY9+zay0PZOR5snUp4myFxr25L8tYhS3VdDONuRzJSDCaRq6F+D5ox2Rz+3j9xrRjZ/IFT8ssPvJWO+P3Elm91rCbXLqlawR6TvRq7PaRUK0xZ9fHdDqfG+gUtGtdHsG8s/wZTQARpSSJf0OQ4jGSXOLTSEkvJucPNo=
Received: from BYAPR04MB3800.namprd04.prod.outlook.com (2603:10b6:a02:ad::20)
 by SJ0PR04MB7376.namprd04.prod.outlook.com (2603:10b6:a03:295::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 04:38:29 +0000
Received: from BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972]) by BYAPR04MB3800.namprd04.prod.outlook.com
 ([fe80::61ad:9cbe:7867:6972%7]) with mapi id 15.20.3890.041; Fri, 12 Mar 2021
 04:38:29 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Q2LbIxWjkkW7HLcT3Xe81Kp/x/IA
Date:   Fri, 12 Mar 2021 04:38:29 +0000
Message-ID: <20210312043828.kl2olk2d7awfsi7j@shindev.dhcp.fujisawa.hgst.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
 <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
 <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
In-Reply-To: <PH0PR04MB7416FFA8BC2332DB647FA12E9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: da0ad525-51aa-4845-9955-08d8e510af3b
x-ms-traffictypediagnostic: SJ0PR04MB7376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB737605045482FBA5152E6E75ED6F9@SJ0PR04MB7376.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ngqSPElB1Qh51uuZFRg38gMugonwExy4X1ylNGi/gHHR9g6LLyBsjxDPYXLrxJI7I+fRweytpFKzQzkzi3ICr6DrpH/nz1NAJagnMi0eptL9EgYzrsyKd0H/RIyZISe5PpRRj/obqFtUtJcngOOIaFagGzqwNtaZDYwuYNaveejO55QVLTCpZ1FR7zEztkCjxvhqoEqxPmmqcNdrhN3LSHYuYQVQ1y8TmD5GD86plI6IYXnv+TWh7AWOOqLwNk22JlmRL1nZB5h+Nw6AFLD36Cr08ihS6lTsZ/0YP0yvUtZmZPjrpkcXXxanwTuXjGkDjF0Y6CgqfKUJTVPcIsr5WJ2wKYHIjBZp7bKbHcf90UMwsN+kVBs2yQY6j4HV00wXspSEGQmKEXhXTp//aTqsioERq4jq4DWZVEjiuIYhI6oMvAXrHn3RDY+cZgo8NJBAnNyBzRNFSrPjqO7XPHwDpULk2W1A+ouHTeAoLayHSXv57zUSIj9LH5sIeu90rRqGGe+3xNedP/VztekZZFb5JJcwEY0Wz3xa2cILfrM3LSHhYNxOnYVNS3TmHQyncwD5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB3800.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(83380400001)(53546011)(6506007)(6486002)(66446008)(64756008)(6862004)(4326008)(5660300002)(8936002)(26005)(6512007)(9686003)(54906003)(6636002)(86362001)(71200400001)(478600001)(2906002)(66946007)(91956017)(186003)(76116006)(8676002)(66476007)(66556008)(1076003)(316002)(44832011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OnE/Hq4CYgi445WZ/WJJbMa6frL5pgOEHj253qmS0WwskaO6+FsQ/v9gAw0O?=
 =?us-ascii?Q?7Pu3X4ygK1RA09cCEkteMuTO0AIpqt0KOwwdcFGuYA8kqVobnAQr7C44IY1j?=
 =?us-ascii?Q?yhdG8zDPdaqqr5yDuSH7io695hGkf7WDi5AT5h19lHKeYHXyvQGL9+KG0RUS?=
 =?us-ascii?Q?gMpvyHmsQLC++nE9vl8DdwbVwaLPwkgZNhN8qqhliBEmo+nmG304zeCqcbEu?=
 =?us-ascii?Q?YAqRmbbeSu6rxFqr9h4joGOWWvR0NUAlVDpfKWirqcgTU33fosJx1vaEnC+r?=
 =?us-ascii?Q?EVR5BjabXnPrBGrJ5Lk7zIyUeOotc9Zk+OAPPKOIHefbidkELgLX7VZ94Ylo?=
 =?us-ascii?Q?osJRvPxr1qp0mg1woAlkjX9WBiMB2eGnHFb3+E7fbe3t0/2YYZ9bJrReFyVc?=
 =?us-ascii?Q?7uHG50rEJvCHtYZGzM2otHT6hhsPFJtqjP0h9kN+Ma2u5Cn+JmyzTc28Z5/5?=
 =?us-ascii?Q?j+qb3pYYQd+otxG1PkNuc9LMH3TpruCL55nU3PYj6lJHuiJt5Vq0jOdwxVEn?=
 =?us-ascii?Q?fWiK391mhuiAIt1C75d+4rxjyNYTvCe+8w/35aRueGlfLUy4l1LMFcX+uob0?=
 =?us-ascii?Q?wbjVw+z/re+6ZNO95zj0jYHqmHWPWUr4aLT2wEAQzrwKY5YFH7J+WjGVF40G?=
 =?us-ascii?Q?Nq+AOpk0hhfaNDIorB4GLBFgfEw37MJmLcQmyr04rzShxPFXtxKtwLojBohp?=
 =?us-ascii?Q?JoAzrTNP+hoSz+aD55rPio057BHDwzNwO0J1zWswccMhKzdht/y13Oq4XLCW?=
 =?us-ascii?Q?Dht63FIPT9KlbdvNrbf2gDZa73iF24/vqhT7raC3qgR2SUvb5JB9LgdG9TpG?=
 =?us-ascii?Q?cWFrQ/evABWLH3lMXDxbO7vNqIzS9ud+KEYn73acnUuYNhkuoqS+ApZjv4Vr?=
 =?us-ascii?Q?d5MnBZjyTonEe8g+mhgBpp1EcmTyJepWK0Zo0ivNU9Gk3Es5qU6zqkJhJ84D?=
 =?us-ascii?Q?Uyl0izHHxkrsmstGCo5ZEgKkpvvVQfASPYvVXGJ4qSdE+kx1jbyAln+gs3qV?=
 =?us-ascii?Q?r9apDh6mn7mnr2ftp5dLuGKqNZuort1fgEnfWsAXh10DNfOuWUSLbIupinYc?=
 =?us-ascii?Q?iDc/WwqkAZQUqMTQ7H8FpJSN6xXVx9NoggEDZ6BLcyhHid9nsFlNamIkLnB8?=
 =?us-ascii?Q?eWm55l7gNb+f4Sp/hYu1nRSH9LDPUkI6nZUWnrsZPt2eDm3DryIsKA1rCt0e?=
 =?us-ascii?Q?WxmY0LH3RyIAtbU9PQ0m6rB7cev92jlo9JnoLU/aW2HojtxX5aM9xOV2OWmY?=
 =?us-ascii?Q?vEau9LCXgUvfKIqSDpwVKb101+SK08PG7HsjvZlzP7CSezmgPHp6aEUs9y3l?=
 =?us-ascii?Q?VeQh+jVRrPk93cwoo72bQ9iah0/AMR7zZfanKYXqDLQejQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C9F2CF2CA9A2734E9ED33C166EC476B8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB3800.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da0ad525-51aa-4845-9955-08d8e510af3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 04:38:29.3802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4JCOLmr042WtwxZ84sL+9Wr9j5EfGBOQvB2MhO6hT9CoR0F7kanuDG0sHXV+/JhU+xalP4KbSNnaCs2Y3ml5u3S+Wk9jA+gfHu2hh3H3dek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7376
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mar 11, 2021 / 15:54, Johannes Thumshirn wrote:
> On 11/03/2021 16:48, Bart Van Assche wrote:
> > On 3/11/21 7:18 AM, Johannes Thumshirn wrote:
> >> On 11/03/2021 16:13, Bart Van Assche wrote:
> >>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:
> >>>> Recent changes [ ... ]
> >>>
> >>> Please add Fixes: and/or Cc: stable tags as appropriate.
> >>
> >> I couldn't pin down the offending commit and I can't reproduce it loca=
lly
> >> as well, so I opted out of this. But it must be something between v5.1=
1 and v5.12-rc2.
> >=20
> > That's weird. Did Shinichiro use a HBA? Could this be the result of a
> > behavior change in the HBA driver?
>=20
> Yes I've looked at the commits in mpt3sas, but can't really pinpoint the=
=20
> offending commit TBH. 664f0dce2058 ("scsi: mpt3sas: Add support for share=
d=20
> host tagset for CPU hotplug") is the only one that /looks/ as if it could
> be causing it, but I don't know mpt3sas well enough.
>=20
> FWIW added Sreekanth

The WARNING was found in kernel v5.12-rc2 test with a SAS SMR drive and HBA
Broadcom 9400. It can be recreated by running blktests block/004 on the dri=
ve
(after reboot). It is also recreated with SATA SMR drive with the HBA, but =
not
observed with SATA drives connected to AHCI.

I reverted the commit 664f0dce2058, then the WARNING disappeared. I suppose
it indicates that the commit changed HBA driver behavior.

--=20
Best Regards,
Shin'ichiro Kawasaki=
