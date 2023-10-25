Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB000C25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 18:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjJYSuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 14:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjJYSuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 14:50:23 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F1E111;
        Wed, 25 Oct 2023 11:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698259821; x=1729795821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fegb4NdKSH7wHG5n2xmwxL5AfQrCarZZ/TIAYDs/57I=;
  b=dj+hjg8PsoefK01u2wBPuhkQmdDBAGzDF4CQ6x22U/Yx5hHtpXQ40+FV
   4C3SQJfDQmTUNQ+yjwLtXCFKpP5zjD66v1fmQET9JAqXTEbM+ivDSdKb8
   D/ycOq73RiL6tG+xTQscBJMG+R9ZfiUjWYTaCt6r+uBS2oICZCnRNtWum
   yEI1NjPz26CcIFVgmgN/COPTQOH3RG9f3g1wonT95yhQuQxWzDoWCxcaO
   AQfG/Oe+ma4WLJzlZf0qWo65C7OR8k8Nz55dKgSI+dYsqxZVnH72YT3IO
   pilqxAJz3AkGK6pvTAI3n3g4vFKczyJYXgg17VcM7bpXJdfv6q+GIdzYn
   w==;
X-CSE-ConnectionGUID: W0Rf9ATNRD20pWZGepTzsg==
X-CSE-MsgGUID: YbL7qlhoS7Way27TIGL/tw==
X-IronPort-AV: E=Sophos;i="6.03,250,1694707200"; 
   d="scan'208";a="664112"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 26 Oct 2023 02:50:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nj/6Z+iaJ37vIpT2m7u1zRny78ZStWBYtDEoyhEozVihNKH2W3bm+LyHeuqfaL+hlBQewBsRnuuWxhgi2uWK2PNj0Dkj3dJ9V1qaP9aHBd/DflPe4f6ofCSjs2ZM08Ou9VQsP1PSs+xVk3AVxXjuJioDCtEc0ns6W2BFF7Mw4f9fy1v0k19FCJ2SbfFoTAy1pJrkHZNoERVTAoVYCaPqqQyDdGPJu+jj7HGt6JJvFqNCZRuQuAKi+UOnW/VjvcjQjVZTmUpMm8Lqo0OU2lu1GZnZH3OytZDDQaUdYoYcftF7PDbfP0XqAoNiJaygW94p+VC/sdg81E5+Fst9y3t9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fegb4NdKSH7wHG5n2xmwxL5AfQrCarZZ/TIAYDs/57I=;
 b=nBdHPbeOXU1YQylUjaJ5raandVJPEuCCyWEIHfP30Mwk1U7vtwzVU1j8fzKX6Ju1ubvCU/MzuOkp93CTIr59T1bJSztk7QaUW7esh+k+HVJpAYfS9YClmvWS5bXORqV424axFOhiA8mGRGoZOFVhD9leuL6KTzaIlab98IeqqjJYHCNcr5D0aPBUIcRLS/9TYoyAygnwvLixwVK4Fg4BRxS5usKI6dBcG4Ejh9YSZiO9vUd/dLP7wBTz9kyqyJeUFpPPQnoPuoRvBSW5u4LFB0txiJvJk5ajpwHJXmbbI2sA+hfpORfW1vf1MAObOPFOMFV6n31aG2BFqnlYIMOgYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fegb4NdKSH7wHG5n2xmwxL5AfQrCarZZ/TIAYDs/57I=;
 b=Jb/57UjGsm8v06TCl5jROQ/OCJqEwJwriCA1YFmUb3Y4oFlpTJSpfWJG2FJUn7YWgRmnmhpcdlOVab7tIxHfpTEgA3DMTtu4q9qjS48uE4Ylz3BS1PAPyIdXYRfLE9lrRNsqEzRYYc3+q5ZhuXOhZhxORZf48067X8+Ro216sRo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB8392.namprd04.prod.outlook.com (2603:10b6:a03:3d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 18:50:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::83bc:d5e1:c29:88dd]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::83bc:d5e1:c29:88dd%5]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 18:50:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v4 0/3] Support disabling fair tag sharing
Thread-Topic: [PATCH v4 0/3] Support disabling fair tag sharing
Thread-Index: AQHaBpkEoi8WdNul1EunhvNPcqOEpbBZuV4AgAEfejA=
Date:   Wed, 25 Oct 2023 18:50:17 +0000
Message-ID: <DM6PR04MB65750819B84D422BD238D2CDFCDEA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora>
In-Reply-To: <ZThwdPaeAFmhp58L@fedora>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB8392:EE_
x-ms-office365-filtering-correlation-id: ed925832-919c-415a-e091-08dbd58b3b56
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 73b2lMQnSZUWgz8FZO7zzLVk28FoULRPEg7XIDfjg+QKt/znPPd+KKQhadTH/WStPcRpAFtdCcJ3l8KgAdeusAky6nnK7on7os+UpLu1difYqOGyC3FB7g8tijZQS6HJsW0BBT4S5IrLH8ktauCon2i4/aabbw/d5V/QZbFkcEjB/eTwXcNpkBNrLr4MU3uRQ8Wb8bw8+hiLIl+K+xZBoRB5Q+Cid7cC00fcBu/Cvwg/HYqRphYfbTvzmx8Qt6Y3d7cVHaKl51rg7hquBHA3SFvI3G0gywLu1T9IuuK//BqcUuh8yAIYMJmc8LuhIViTzZoZeau4XrTrQrY8tt9MNuGEAmc1Y3nE/DssEVzGtqspwo1hNKcu0lsWxxqgMbwvfJp693I6v3UtiSrA8fy/kYliRiGgbeAvkB/0bVplRZvvbPuqR05H3y4jPT+INP/53Y2Lk9w8qM7GA0G4SrLhNEOXaRZevCF1OPmzyEtEG1nXyHgOOToqnDqT5M5GRVWu2czopSb+78C0FBvUDiLvTbDkurSyt8MahEpeCdt/kwfzFXuxI/H1B2YVr3wEBu3oJOqEXSoSIADYvK0MQBtaUzhApByVVVmPrioXKOCl7pE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(376002)(39860400002)(396003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(478600001)(86362001)(2906002)(110136005)(66476007)(122000001)(54906003)(64756008)(66446008)(66556008)(66946007)(76116006)(38100700002)(82960400001)(71200400001)(6506007)(316002)(55016003)(966005)(9686003)(83380400001)(53546011)(7696005)(4326008)(8676002)(52536014)(5660300002)(41300700001)(33656002)(8936002)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yIbd4/e/pdo0dbqCruE+87N3mEU+lXXAiEN6xuClfMgFAyu2Nos2hC5ce87v?=
 =?us-ascii?Q?SyJJonlsLbiMdl9ZQg3y2RnRYiVLrkZoXC6wqDYqsO9SQK6kpZ/C3303vvpg?=
 =?us-ascii?Q?IQKVZPtOhjSQS05E8Upsriun8wPre+fSbhjJVIlleqpoatXsZeCEFJw/VE+f?=
 =?us-ascii?Q?In02wQqnQ9vbBWFAMuH1zpsWZSDGSXJh3LAV05+NaMSOIy1MFza8+coB/jmc?=
 =?us-ascii?Q?0CANtnePIz8G3CutvlWTT47qYRfwK7kjipEPvoRuZTv3prc4gtJusvnIcqYl?=
 =?us-ascii?Q?iz1tGxrwcAx2i6PSGeVD98BMhU1g0vpP90X36Qh0OTLeEMeT30E2NikFanfc?=
 =?us-ascii?Q?rUH6TZYEmFxnR5YvhD67UDqPBDNSAFkbxm/FNOUKtiGfW2g83FNix6Yb1XUN?=
 =?us-ascii?Q?BwfmSlJ/pIV9619W3dMkN4OiHb2UjNiUAR7wZC2vUAPlmB1mEoPtScVOuw0g?=
 =?us-ascii?Q?eCQ6adoER2gd9BQRgXThiLO8wNMXcov/jUnDoz77gZly6nOaBxs8od3ZR4VZ?=
 =?us-ascii?Q?CTkdZcwSfS4aSeBT26rtr/BGa8N8q/ereKqFr97z+LxuAmEY5qHSddDFKxHe?=
 =?us-ascii?Q?kwrBMekxjhWKmA0+0n+cHhh3SPZd8eUP6NyNPXpy+kIYn6aesbmimWzpwOm6?=
 =?us-ascii?Q?IT1JeuO7TCqEV7/7xfik4bmI9G65LaZVfYnxmXKDWIqh3pqJki7rQKLEY4ps?=
 =?us-ascii?Q?FJljIp8O9kqbwXoBr2tnGK76dPRQKuw9lFp27WzdRTtmVdOtGHtCqVHO/sFh?=
 =?us-ascii?Q?K1ahipf7/a31NuW6mFCUqEHEeb+fRzbCPKHd23gtQYbTd8LXxKbYtChUz/wL?=
 =?us-ascii?Q?M5vRweHMVC4Gxr/Rmn6W2CnPG6QgQCrcevpXlbzAmW/uLsD2o2KtlNDLZQaO?=
 =?us-ascii?Q?XscX+O6KQvj6qQsk/rJxy2vz/bs3ihcpJujwfEt9u+fc9XH8LTJWkxCii2Yn?=
 =?us-ascii?Q?MR2HV2ebVlkxjcfDHs6ikOvPbTGJmLWXWiKzrc+XDVdR90gNH9H/KVRqa6yh?=
 =?us-ascii?Q?wLzwIgIepJSWOIRUXXM8QmvGimSdMku9nJT+DH2kDPiX1z1+NwFTC65R78OS?=
 =?us-ascii?Q?eKseTO4F74jQ4lMxziV16VwcZGJpNTnkxeU2x5oyrgksY7/ECGNx77jje7BT?=
 =?us-ascii?Q?Oqq57BErQA3Tc875/p5TewG4fvV4fl5qDnjXlWLMwPIkgfLu6DMPXdGfeFqr?=
 =?us-ascii?Q?Zz94lrfiRlvcqpv/6/XYJyf0ztwKBVrzMyJreI6JfMFCdntloYM66OaWCN1k?=
 =?us-ascii?Q?QVxPQmYsT5uxblNTKa5HFh6NQDkxy4or6hqNF2n3U+StGSxOxR/xLILZQRND?=
 =?us-ascii?Q?ah7avfX9q0gqFYt2EMlj7NBr8JxpucW9PQzMFteLX/0UWWMbqZEFYdsIMw45?=
 =?us-ascii?Q?k/pU19InOpN25vLvgQUBpXaIoERq+tbCKvu93nlkgD+mt1d9uZRhRqPi43sM?=
 =?us-ascii?Q?3nMhEcYugNeWG5g+KLo9Ca0cWZ0d4zRNJoe7Ey4pM9JiTEKB4Gw9xUroEUq2?=
 =?us-ascii?Q?0a13s4/yelA8poG2+4OAupXLPnien3XiR5QYkRjqqYI+A5CH+MCobOJT7MYi?=
 =?us-ascii?Q?gI3x7VKZwU1KqRRjwhLinZIOTs+0WHn1kDpJyFHT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0JeBZJXjvxlwJLyuyU9Jv3cdxNDQWweX0neKbkV80cbAzKIyWq61zvewnZMw3mX5rVFHWx9iHlIf9belAX1IL4ESYMRTG7fbnMkNPoRyyfWSSd8BGBrYtUgoaDLL5Xr8PEHBNqM/Wcen8hRfdF23bx4r+yf927mlJ9sRDVUM9Dn37iWGAcvCdbtW1mihCIjnYT6zS/AMhBINU9lOPOrN9rDHlPl/w8pgF2z1Yjqn1K2A8SMWyA0gS5sGIMVEl6NcDdhFTOiMx/zO4hhya3vWKch9WCoygjgmz/6nF/azf10DSvVbg/qrq4uLJnMxO62W2xzp/QzcmX0SwAyF6X0G4BWkWhtVccHVcaSd1tbKUus2i4BBzvT+qvXBy4/G21r1DM4mNrhFa7gP7Dg3vT4FHqGrrX41eT7BLd0z4DxyMq5eJeAZbJQtBf/OjXplb5MQ63gGrtuyvDFmAgWwNRczJBlsHPsD7qV8lfOmriTVK3cFmeW7WJKIM4bT6T6/d3TTjnVicmvSHO5Ui9K8fBin4Bq2LMWK0oUFnsMpKf0TGbqJM2DVseaKSKGXWTdqC+cutJzlEx8wfUbniEPZwOMSAZ00MHGDZK7L8+qrWPzBePJm9bcFti9KDe6T5a8FLP8utlLiF1zpL5+ERM/cFdw4BQWEE1DZ1CIaX0HMH5Rk7gjiGAL7Mwuzf/jJqyRIDsxLDErn+DR6v5qf3Zo0EBbZJhtO+4gVI1oclS/AfMhwR9xKVfHt2TLRk2JuDlJNx0q2fWXG5sJLUnQbyx+T/o2f9sfmXKRPqvZWk5Vm7k5gyYkEHDhOOUiOQeX59l39sCvhRSC6IXW1FWAyK1jawUre5pWabgEIcmlfZUeHRzFdUiWJqLSr9tjkP2F+9GvtV90YzvIs/vReHCfWgxouI8qqyw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed925832-919c-415a-e091-08dbd58b3b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 18:50:17.5747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gxc9zl2aotAtmJecuFXMns+X5QTf0hu1+E+RWhM75IpEheqpQuad1MABDl/VBrowJhxIgG9Z28oEeaczl/jS1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8392
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
> On Tue, Oct 24, 2023 at 09:41:50AM -0700, Bart Van Assche wrote:
> > On 10/23/23 19:28, Ming Lei wrote:
> > > On Mon, Oct 23, 2023 at 01:36:32PM -0700, Bart Van Assche wrote:
> > > > Performance of UFS devices is reduced significantly by the fair
> > > > tag sharing algorithm. This is because UFS devices have multiple
> > > > logical units and a limited queue depth (32 for UFS 3.1 devices)
> > > > and also because it takes time to give tags back after activity on
> > > > a request queue has stopped. This patch series addresses this
> > > > issue by introducing a flag that allows block drivers to disable fa=
ir
> sharing.
> > > >
> > > > Please consider this patch series for the next merge window.
> > >
> > > In previous post[1], you mentioned that the issue is caused by
> > > non-IO queue of WLUN, but in this version, looks there isn't such sto=
ry
> any more.
> > >
> > > IMO, it isn't reasonable to account non-IO LUN for tag fairness, so
> > > solution could be to not take non-IO queue into account for fair tag
> > > sharing. But disabling fair tag sharing for this whole tagset could
> > > be too over-kill.
> > >
> > > And if you mean normal IO LUNs, can you share more details about the
> > > performance drop? such as the test case, how many IO LUNs, and how
> > > to observe performance drop, cause it isn't simple any more since
> > > multiple LUN's perf has to be considered.
> > >
> > > [1]
> > > https://lore.kernel.org/linux-block/20231018180056.2151711-1-bvanass
> > > che@acm.org/
> >
> > Hi Ming,
> >
> > Submitting I/O to a WLUN is only one example of a use case that
> > activates the fair sharing algorithm for UFS devices. Another use case
> > is simultaneous activity for multiple data LUNs. Conventional UFS
> > devices typically have four data LUNs and zoned UFS devices typically
> > have five data LUNs. From an Android device with a zoned UFS
> > device:
> >
> > $ adb shell ls /sys/class/scsi_device
> > 0:0:0:0
> > 0:0:0:1
> > 0:0:0:2
> > 0:0:0:3
> > 0:0:0:4
> > 0:0:0:49456
> > 0:0:0:49476
> > 0:0:0:49488
> >
> > The first five are data logical units. The last three are WLUNs.
> >
> > For a block size of 4 KiB, I see 144 K IOPS for queue depth 31 and
> > 107 K IOPS for queue depth 15 (queue depth is reduced from 31 to 15 if
> > I/O is being submitted to two LUNs simultaneously). In other words,
> > disabling fair sharing results in up to 35% higher IOPS for small
> > reads and in case two logical units are active simultaneously. I think
> > that's a very significant performance difference.
This issue is known for a long time now.
Whenever we needed to provide performance measures,
We used to disable that mechanism, hacking the kernel locally - one way or =
the other.
I know that my peers are doing this as well.

>=20
> Yeah, performance does drop when queue depth is cut to half if queue dept=
h
> is low enough.
>=20
> However, it isn't enough to just test perf over one LUN, what is the perf
> effect when running IOs over the 2 or 5 data LUNs concurrently?
>=20
> SATA should have similar issue too, and I think the improvement may be
> more generic to bypass fair tag sharing in case of low queue depth (such =
as <
> 32) if turns out the fair tag sharing doesn't work well in case low queue
> depth.
>=20
> Also the 'fairness' could be enhanced dynamically by scsi LUN's queue dep=
th,
> which can be adjusted dynamically.
As far our concern as a ufs device manufacturers & users,=20
We find the current proposal a clean and elegant solution we like to adopt.
Further, more sophisticated scheme can be adopted on top of disabling tag s=
haring.

Thanks,
Avri

>=20
>=20
> Thanks,
> Ming

