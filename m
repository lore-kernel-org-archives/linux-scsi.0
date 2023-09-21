Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8498CD493A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 01:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjIUBjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIUBjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 21:39:20 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C299A9;
        Wed, 20 Sep 2023 18:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695260354; x=1726796354;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=i9iKKKQCEQhuBUtjKLkBXIXpo7lfIIsJOXTY3lpbsd4=;
  b=d+GRjxd80J6Rxp+0Lw3+iaY6q3ioO7kma7w7bdJDkdmQTdXrrV2uHBjz
   GrAHWA3hg0fVqJNRys6DesGYRzat2j9uKnYCm0MhwdkHjVGDaDOA8vhGo
   Fmq1aJCrrNFvzkAzAd0/4ZE+hrS0ENIamQl0APGgQK803+gPUWVOw7roX
   fRvprIvg+S9n0cfkSvgq0qbE4jBjwUDV9HODGXtJ80NUSDnGUvaETsoMl
   WKN9XydBqlKvDfyKugoY1KYVADqkywjPdf7liX8KfNoMMwF+ef4BCw+9U
   ncUFH7wVeHPxMjbeXX61uTIvRLNjJHVsUwso/b6OfsCWSej7bBKO46jTo
   w==;
X-CSE-ConnectionGUID: c9MWX62zQViFJePXH06UgA==
X-CSE-MsgGUID: z/k7kiFgQeOUi3NL3j/uKQ==
X-IronPort-AV: E=Sophos;i="6.03,162,1694707200"; 
   d="scan'208";a="244492411"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2023 09:39:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EItPa06DY9+Vdg2W1WoiM4Q/b+wg1/ih8bubOSwbV2ZXsndZVMncvKs3MtathE9Sw0PSzCDJViSKVBUvjg39W8v71UhkHOpr41Gg+EXufmC32jaIcb7EWTkJlk0h89ELiZL1+Riemr45w/c79tMhBB8FOe6npgJueIwnyoVgrowSwwQ5kjey4W8rYXDrItCnlydSgeMxBOMNBcaXTRlFiCbbeCtvWjonTo23nNSPWsNqyAdB5dtQcraTcCE9BhHF6OK40K/sUrl509RnuRUCkHXST0JQ6FZ18fqGG607fbyypExnDcX3dLkvPR3E5EUNSoOK9KmKsX70qS7rfNUfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9iKKKQCEQhuBUtjKLkBXIXpo7lfIIsJOXTY3lpbsd4=;
 b=VCaRMFqV/8rffb5DRuXKzpSzPb4wSVRaCmwT8tDT5VBV9c4EiFtN5xhi5SnZDiif9Q1Zu1Orn2XZGP9lrERi2Vwf0exurxvKzA6VgG6VnT2Z1DSrh839GQroUqRp+LqZwTxrbe/clQk+lBIbnoDHpp3I8dPjyAntBvqx2jL8MQF8P7Tz4FMfYj9kf8jPSIRz1GglHJoLOoPKUG4qhSkwHX3vR4zoEd92DHss9F0KeAXO0Ls9UxjHou1w8ke2BDEKQLTDsecXsOLOqUeJjGHZVTUUrPNaEWdVIgnKjve4eE/+zp+ffB4RyG2gM5XikTmKqL4BNAGni1I/4N1boSMo8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9iKKKQCEQhuBUtjKLkBXIXpo7lfIIsJOXTY3lpbsd4=;
 b=NGbOUPhjWVu2mVWKAENkM+m+bbpFJGaMYCkuD2eJlDHSNfn0eMbzV+VgWIJ8YyWs/pf1/2ciUAN8Pz0hQFFJRpW0GdLccfAUcr241PqqzpUXGF0xOeUQSSAV11eYCiylfyFWiJ7r7HtNXupPUI3qfcjhkbJdk1JxrCQ5kV0SLY8=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SN4PR04MB8318.namprd04.prod.outlook.com (2603:10b6:806:1e9::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.16; Thu, 21 Sep 2023 01:39:11 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 01:39:11 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests: changing rdma default driver from rdma_rxe to siw
Thread-Topic: blktests: changing rdma default driver from rdma_rxe to siw
Thread-Index: AQHZ5iyRs4TPZzRoFkGPI1v+IqhuaLAkjGkA
Date:   Thu, 21 Sep 2023 01:39:11 +0000
Message-ID: <5jyeganqme2flc2ql5jgnxpstqjpb6j3c2jom74g53bzjk2akr@xyqi4l264jhj>
References: <jcdxryo6o2qbj65m4haw23smz4dvm6a7j75uho2l3u3qmnsgif@ix7hy47uqhw2>
In-Reply-To: <jcdxryo6o2qbj65m4haw23smz4dvm6a7j75uho2l3u3qmnsgif@ix7hy47uqhw2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SN4PR04MB8318:EE_
x-ms-office365-filtering-correlation-id: d67a40e7-ad01-483f-c1ca-08dbba438e4d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lUnbrqtz0wMmBUcNAu7QAwO217PtgxaG0bo/vrBUPu9RVad6NEWGn2GvWHpqSJq9W5ORl5sMgYTIuiQgcyiutcdeJhi4n8HBY9OP23wd+f066CqSlQ0LjSTuiOn2xgtIVHk4xNvO8OCXpaPeWSvLnuG9TyiTQI8ovnwU16JplTnd0cRCrXTygl7xVKcGE0tPwoXqVGQ8Ne8rJPHcCfml9bCR+PpBLqpkc9khcGsZCmxplGKfpj+UHnl5F5O81QTEkgc84yMYLH9dZmpJVpJHIHATBjTGxzAJEBybhfM9dKJShEvzHrted+if9VDMDosYsQXFKKrgZxv2Cc5qUIq8V7AztKYQ7xfiEfY5K7cXEjCdUaRCONUJlUejvuU6yItqcT5jJk9ScmN3nHnHAzmAl3XA2TdEIpEuNwNCHea2al5xi1tVkRGZ30UB7smb3wkr9b3wmQygnK7QC4IPSr1iAn9IDI5FwtmY7eJJcWSVbwZc9zGRwUaZA87Gacaouau2/CeYoFPXkCa9YMTqnM76LAF5UsIrViam6K9o/N6sjolQsVhwWGwoQnmGBEC9tjDa8mOU3iH0dlGqZQAD8I4RF9LLsiPkCtTYXpWAxvI88uEPsOZyb1pNmVIOlWPBmOt2Rqh6s7dhQoqHq7m0H6VOIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(136003)(39860400002)(376002)(346002)(1800799009)(186009)(451199024)(66476007)(5660300002)(41300700001)(8936002)(8676002)(76116006)(44832011)(91956017)(66446008)(66556008)(66946007)(64756008)(110136005)(82960400001)(316002)(122000001)(33716001)(83380400001)(38100700002)(38070700005)(2906002)(26005)(966005)(478600001)(71200400001)(6512007)(6486002)(6506007)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pOUymNqmjDpP0jbrEv9raejccZ91iaD+WANYeuBAFlKvjxx+O3dxnNGgZlJ/?=
 =?us-ascii?Q?GRNbZhV8a2i4HeI7+SHDcoHjavzP/cdtvsgtxOCcBzEAHr4m7lB0bhzZEm+D?=
 =?us-ascii?Q?TAC2hlEuobGyYYMBYZ90TW+2XEA7mDOmle0Sx/IiA3Kbt/vPWd2ekYyuTYhY?=
 =?us-ascii?Q?hN455S27hOyHQa5gIU3KY27q/+U8wT4whQhDbdg2ALshIo83maP1scYkpS3v?=
 =?us-ascii?Q?IFbg1p9pjHZ1yAEZMT255pz7CptKtWwQ07dtVLCAh/IibUf+b3dxscYFdXXI?=
 =?us-ascii?Q?GQs4En+PkhA4X3pHHcDDa6v2ElpWkm6zIO0tym167ZJ1TN/CorxfSeZp/ls7?=
 =?us-ascii?Q?bXMc/AbOghi6vBO01fYQWH2f5yrppSBTl2MhUxIpMvMdNO9kpSGP7SMkx3fX?=
 =?us-ascii?Q?IqWkNZhKLH5wdlGxIelGyGNmji5zw/SmO82cxQIuSORCh5BiMUOLV5Wmf8T5?=
 =?us-ascii?Q?9kturOaTstIAs5KTfTFifsrpbMr58qu0IlbjOvzV5VPp9Z96xu4zBLVvKGpY?=
 =?us-ascii?Q?H966PNe+N7zDi/kbTyy0sUr36OeQhNCySUjLzZXU5wkrdkkT5HcPVrR1IdjJ?=
 =?us-ascii?Q?SX6noKqxrMQaucXUcolf8u1pWwhkUbraI77STm0W2/AYDVNRZ5gTItkVrrXb?=
 =?us-ascii?Q?HxtfhFdkzOl1JA38QvIv1X6FnnP4AwaETcME7Hlg9DbiVA+sjh/VwAA/qChe?=
 =?us-ascii?Q?B2CNGQhgfmX67lc4Y5nS0I8gqOpp1t0zafHg+L/H3EFOxasUF1jxHSZ24mI/?=
 =?us-ascii?Q?zVwL6mzAZrj8XbOyZh4wIVuE7FzOWJL9idHEPhQflCz9X+PcrWpctv2tzVYb?=
 =?us-ascii?Q?xAS2mzjUzu5TuJGe2SWTm2lkhWToQ79foVzY7NHR7J92z+lUnJVk6l7UOsKL?=
 =?us-ascii?Q?Hro7KCm39D6aop0JESnVQ/yfBBfMz9j+db+nPFKTaqyg0E9CPa3+46dIS6nl?=
 =?us-ascii?Q?cbIXZ/ixaMEHOBDwlrTYXAJIlIwpAIRyYKwCtfPjFmcMYpwK04cByL0eio3x?=
 =?us-ascii?Q?aeD/OgUPDPxgQIpdehdQLEjpo0Wq76SOD6Sq/zQmWysMoAJttHtbymHRQQPG?=
 =?us-ascii?Q?PlqDvvZHnzHoq7R+7PFV77VoFHDpYnp7ohs2BpP4Zxo1kIHh3hJIQReeo4ko?=
 =?us-ascii?Q?q3Hl6V6c4TIgNLcYPamqPvIfojveo0pMVp3gaRh2Dsid886kq2yz8zajNapU?=
 =?us-ascii?Q?KGB0TA+Zuaw0lvZ71D0jKGQCBINjPg4RYiZ0GvN193Xb5v0UJukBKbTf6jPk?=
 =?us-ascii?Q?On51Ef8TPN0/sF9J6+QnW2CeUzywQhJlCOJUrpSBwyynJH2trfWJoQqZHMYC?=
 =?us-ascii?Q?bdcSs4xhvffUHO9ZWTL7VFegF4ckfr5liSZPp+R8poFQA9cS736+JL5sBeIB?=
 =?us-ascii?Q?PhRowOaaPmy7uLIPNYgtXjv7AUVQGKFNvL9GxaaTIIWmtDBBy5vmz+blr/d/?=
 =?us-ascii?Q?fMzp3sAKQXl+k9biGbfNecbu33VrfzaabsJlMaYfmZUu+oiZZD2YfRQtnGba?=
 =?us-ascii?Q?U65xNv5YIIrS1ViGOmPN+SK+nosIJoM2i1gSryJaUjUAfcLxDhh6Vnjs+woc?=
 =?us-ascii?Q?Gs8gtGIGwcem/q+QRWUEE15CFvTFHKwaKUzik2YxcK95CPNC2TnM5ZHu4WmK?=
 =?us-ascii?Q?PdKTeA2pMsG5WDAE9tJovw0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C7D9092C8E89A40B237EB3F0AF498D9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ILj93+LW+I9zsWnYb+XXWkD/T8vzYMTi3/u3EF19PFpR26mDaOi4Ls+SAynRQkQKU6Vo/bFyTMjqiJFCD0u0sKxzSXjF1K+hX576tdph/DKojr+h2ap1awf4e5bH2JjuijxYgZPmbIexRdCUa1NJpH6C+Eu/AkVPM0VLWC2Xbg6sGqhLHUWxzhV8lojlnKaj+0rLzh04sn1myxH4qPjS1RDy5OJR+iVMlxqsc2a9Q0VgcdJ7gRPXqb0B0B9jaEjVRJo7//A7UCik7HcKLvASUGfHuGr502S/tftVPrBoreUiPb1ZH39NjzKhkY4lntN4iJqeTMkeYXdJTbhlCSyKKQM5WFg+g/Tyd8tzyTX86tQ9pPQ+9of/wRYkGG+euBaCscrmHhVIllFAjq+U2dG1OFjlg928QHTfFG/eJMfyTZoOrM/ATJ3BckNcj9Zui242V3FJtqF47pspbEyF4SuC3cC6XcB8qzxjZXs4LMdGlpOzW8SP2KUv0PfIkSUIkyoQXSBOSZdRg/M0JiFgbLJX1t8aoXewcTfLLtuQbbIsPLhmm1oyi6zAvyMlvi+OT2LBfZ2LFNottGkFCPF1auLB45PJbbuliWSqxkVDnsokwIQ6Vk86uYhSaA7/phC+h8jfc6xucD4f8sWazUInzmhVkWG7igRy8ZJVpFYrq5b1KKch18y2LomsQ51dOKjxPb8Bo6Wgo59MpbAvNTF2e3jmtIh9FXFzdJmnTSYhidYRZggK7hjpUvI8VzZeLs0y2h/P8vNfZpm3/gxFRfH/ejNO8sBBn+wwsVfFTlMPibDzKU7FM915TOe2BenNyjl68WwrunrDNsSfTCaOyFnt3Nbv9g==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67a40e7-ad01-483f-c1ca-08dbba438e4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 01:39:11.5701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7yLuYOr4J9/4t8jzqIZPoB1I8vZydXeWINQ2JGl9h5TOJv1h+j/GXzc/yXkZr/L08SMrlc1nF0eTVPthW7jyDfto052L4291vtWUueO+18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sep 13, 2023 / 10:25, Shinichiro Kawasaki wrote:
> Hello blktests users,
>=20
> When you run blktests test "nvme" group with nvme_trtype=3Drdma, or "srp"=
 (scsi
> rdma protocol) test group, rdma_rxe is used as the default driver for rdm=
a
> transport. Recently, some test case failures were observed with the rdma_=
rxe
> driver [1], and it is being suggested to change the default driver from
> rdma_rxe to siw, which is more stable.
>=20
> A new GitHub pull request is created for this change and now under review=
 [2].
> If you don't care the rdma transport driver choice, this change will not =
affect
> your test runs of "nvme" and "srp" groups. If you care the driver choice,=
 please
> be aware of the suggested change. After the change, the config option "us=
e_siw"
> will be obsolete and "use_rxe" config option will be introduced.
>=20
> [1] https://lore.kernel.org/linux-rdma/8be8f611-e413-9584-7c2e-2c1abf4147=
be@acm.org/
> [2] https://github.com/osandov/blktests/pull/125

FYI, the change has been merged. The default rdma transport driver is siw. =
Now
"use_rxe" config option is available, and "use_siw" config option is obsole=
te.
