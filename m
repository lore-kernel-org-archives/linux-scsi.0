Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781B1C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 07:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C3961936
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 07:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELHcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 03:32:11 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25807 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhELHcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 03:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620804666; x=1652340666;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Zh5C7znLPw3xcuIyvIOI1sTeKSXZw1aiMywQJSA9OFA=;
  b=b0hUq0E17+y7wd64waEV9n7ely3tlQtSatRuBbriDfAqUq3kMsvfE0Sn
   NOn4KiXvAyjIE/PnwQUVGVLPNuAVxKqzaTBWA3bBP/vL/KTHCANOFuj3f
   PLHZU9LHOdnKIE2n8oo4l1KWoAWHxfq8M7YM2LimfaC47BxtqkhmSfVg+
   lLXhMEl8rnMaVFRnrI6rkIMugBQacvmJJOlj511x8E/TKNcRSsrnLl1O4
   1WxAnkqecHrIJbKERNDQAGFCEClTUwESn8zxh1VH604X03wmQtby9ZlmL
   LZQg/Fkhlet8L43N9DPlt3PkRRDjbNqj/HEvuUZnFVFPreoBsM3TNSX6W
   w==;
IronPort-SDR: lyJuZPLRt5GxyFWdqR9bvSGVcnwnr3ujS2xMNZR35ud0U+BngjXPQwgSZ3PCJps8f0JGQMKhsH
 NkWAnCTm9IgIrz6AUMY3UUhmIs7bT6qxk43AxXVIXZxPVFZWvPJz7gcCU/WCtV+9pTaNMq6j5L
 qEZ1+pmP9MPgYqRfvG1GY81W0nrCUsGFQ4Zov1ppvmOqiggR+LeFotmScOLtsaNQaVXCAVBDaM
 XVKhPkEnHFVvVtIwn5argGMlgsXoSyZ7r7lDLMxn0WWBAX+ZCG9noYAWR2RyjNfisdqj+AZNBR
 aP0=
X-IronPort-AV: E=Sophos;i="5.82,293,1613404800"; 
   d="scan'208";a="271843966"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 May 2021 15:31:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z47uzI9jP00V+bkbnjCBeJtwLypjf7Fy/m9jl39HvA6WPir6KZnTJXt4ff4r3KbLF5zUmoo3gDlEawyJOkZTSTe6gRdd6S23RRbz3UoTXo5bTYuXssU61mskx+BBWmxMs0Utwg6w0xCkApFJuWQZYRB//C11ifUvjTvTZfRNmqoE51jb84LDHL8eOy1EN4JKRqkep7TQRGTqjbQHxFRTXSfmXtNDDSI8TwmWZTi898y81LpcJuvejguEDVwEcnfWGgUeKIJfYJMJ1B95/ubiawWsAUuT52d/Dd45Vt1w/1bbbdqTmcXySHh2acWF2mMFcptje22XvNR4zxlYLbN1ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh5C7znLPw3xcuIyvIOI1sTeKSXZw1aiMywQJSA9OFA=;
 b=hzZ4Q2bIj+nt9jh3Qn/WXHf2D9gDAiUOP3YTZkrLfE/Q0jLQj00lj2901FWwBBSKAz8Ac9eqdId5V7576H5uBgjfI0C3ciF0kPNAgL6zlKKaZ0zP/gcVo6knP9lulhiNZwPEIe5SQxpg3ItiZB64SKOxHyRUzwQ7ZATO2RpVobNlMGmZrdSX66VocAld/HBLWTFGMR9/PzP0WSR6w/iwBLHIrH3mBtE7zLWJhGioaWhDz0nhCwhchrYSta11gyg6Yv3aZaApgx0DZFqJ9AtzRX5zT5uYugvkswZ/F+dh4ZTD82ItbtpIVtEKMxIZF8l+QB7/K59QRPjrQSLaENn86w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh5C7znLPw3xcuIyvIOI1sTeKSXZw1aiMywQJSA9OFA=;
 b=YOjUHjwECxeBOcqV02T7q6hyiwqI4f8iBBuePSFGpLCMiuekH/fXQC/sR4z9+J3/txDfJLmmW0PEfjf7rrkgmomnPpP1shFGX3R4CM5OSd3uSKfpEqGNwPi4TNc20YVBCQ8zTeQ0xDFwtPyF45qVPqbVS/0lBsboRUyAXgk1Cxc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7256.namprd04.prod.outlook.com (2603:10b6:510:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 07:31:00 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 07:30:59 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date:   Wed, 12 May 2021 07:30:59 +0000
Message-ID: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:152f:cc01:2079:86fb:b3fc:1190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d68beba-92db-471b-fc85-08d91517e3cd
x-ms-traffictypediagnostic: PH0PR04MB7256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB725661D975B16B6558016E029B529@PH0PR04MB7256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e0dsVs7Ja7xxFnkfyj8UANuku9WoxDwCoWvD+AZCIqlFRl0syHUXH9HcX+6HrAnmCH6U52bR4QZLRK2dWX/NBUlAkgtVeBKIE50gduFk1aGvIVcV7yZ+szQXae/5ebaR5eH6vvLOT1MLY3+9fGLVWJOHLpVYmybFfu/2Te2fcY/d7qnNaZ8yZepKD9FDm/sr8w+z5Ter7o06Tmr7D9cJp9lx1kmWVU7oafcj97Ffb4tgWAQA07HmQQpM1rnhxojdOyM4/gXK9dsG5tc+hYZeDfIbQzY85hyEAI0di1ZckJ1VRZMIShnk7aRfy/ASnsIStI+ikiBKltaRf2vxjsMvjSbk8LHX7Ag8/v/Oe+MDP0YvgRH3HSCjEU2tVceIn44RSfsD9JBpoBm7QDcEcVsqweXSm49zKwa2WExwuZvtA4jRg81OKcqUtUSQoln/4Ue5k2nLdaasq1egvn3yhnyvEMXEHH4RdiaO3SVA87x2FUoeYEsb7G02fRHNbVPgY+A0rxI6ms/fiWwn2SukfPYk1Yt9LfhiqGx54xx1lVnjMlUBlDKbUXOThxnovRGRW4LbmxwvRGsOJSxz/Lpq0DiWAF6TYb8dF8TlIrymTWdRstw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(86362001)(8936002)(7696005)(53546011)(6506007)(33656002)(38100700002)(83380400001)(122000001)(8676002)(71200400001)(7416002)(2906002)(52536014)(55016002)(9686003)(5660300002)(478600001)(54906003)(316002)(110136005)(66946007)(66446008)(66476007)(66556008)(64756008)(76116006)(91956017)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?H0NCOAO4x3gXiz5Kffc3II1BmoVmu7KwMq5oVbpwec1jy/D9JztAbbO43T1L?=
 =?us-ascii?Q?PxdQRtNpn5oTm+EjbQhi6df8eCJMtyc2DP+Iv6v0Hm/lCnsFukZGS0XdhIMK?=
 =?us-ascii?Q?K3YLh0eosSu7VF1w4mG45TyMhx5FNv6ZWp+7EEv9o8XqAUHCbZn1c0UQ3SRP?=
 =?us-ascii?Q?Oj941wnQCO4U5+liXANqCsrVciz3psGR69WSncGcgrZFYjobgJ6nYoeWY/2/?=
 =?us-ascii?Q?IShpNLWB39h9AzJDTslxMV33r1Wu4rd1+7t5EujvucMeqRtUljD4LQhfQ+ss?=
 =?us-ascii?Q?XmOzr129tc3SqnZD6ENlk5hkyPkS9LEgGjmyRea5tDOMwPjK6naMdvrxYWjo?=
 =?us-ascii?Q?USzIYNV072urfgwiJjQ44EdxJYUFluq86rDb5xXJ4bEFSpZ/Wm1YIiZmZ8ir?=
 =?us-ascii?Q?1UKOI9QbixhjDgvg9KHR5rTuzNaSybp2uokdcYUQmvghMFvQTTTXv/43BnC8?=
 =?us-ascii?Q?WVvjSF0Do5uCZGrEEw58IS4PE5SF8cKWA/Z9/ttcFS9EuTCGPxrV/YBTenv3?=
 =?us-ascii?Q?qzPW7jQfLsoBS41DjwVIt0xaoitJif/FdOFODa56QkvvZwQhUzf5HkN3e19b?=
 =?us-ascii?Q?9Et66I4x4Zry2OjBwWljEg21+aEBgFhRjMut38xL82p8hlhHmn5OnCWSF9Cz?=
 =?us-ascii?Q?vp1GizjVc+l2LkflT5f5y62MTIAQIzxM9s6UKR2/B7sBKY1r/ecxJEeZ5ba+?=
 =?us-ascii?Q?UFpSpQZCXsTuVQNfnq7rl3SmZ93YxfgZKniUZVpX9Fz9V7tRmXMF6EPXUQJT?=
 =?us-ascii?Q?lyAGXsN7DMYIorKCGJYHuoxYxbQhWg+j+YKbitxx0V6V0Qw1zZAfDk9Qj7EW?=
 =?us-ascii?Q?pQ2bwrPj7cKlb0t/aGhuPmz0horIc4HwxMEEJiwMnB6ytxnc0Dj20diF5Igs?=
 =?us-ascii?Q?FvfHBgRtBjDxrqSZn5lW7e+4Rv/NGjEvyKRj7z8BAfQ/8ZS77tx0fHpNg17m?=
 =?us-ascii?Q?HYeX3WRvtQeU6CpB72pLLd9/6VS/8lgylruhM75VxVKPfcsI35zE7IUKPYl+?=
 =?us-ascii?Q?vgJeJY0veiPhEQCyp5tKbOTcJ2QqH676W3L6RWvfxJsWYVoTBpJVOti0d1BW?=
 =?us-ascii?Q?fevi1I6DeyXagbyVlmKM9B81xjlVI6xVI4VknEMoOOz15rWgINfZF+rQB0Ai?=
 =?us-ascii?Q?V6GmNMrxB1OJDt5IYJ+n3SEtgH4b8bzjwbK27ufYxjQzXhBFL6xQamNzA2eb?=
 =?us-ascii?Q?1kzryMIXhX6+oE9u22HGDxNEqg7wEjiqBA2tHD1C8KdZ8FUZchvUxRhO+Aew?=
 =?us-ascii?Q?LaPaCnF5Vlzcxj194lmSZ1TwZezi0wL2gbdzjUgivcyI8oUpGxNYzNJejPIz?=
 =?us-ascii?Q?mGnzuU94rwgpIdjZuEoS3pIPdFJzenoxA3kKfa2xLBheN5fiqxzCvGjWZBEH?=
 =?us-ascii?Q?IAwN0pvcetCAiktEhqDoNuBt/nF+zJYkyExZTuYUIvMZSF2XOA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d68beba-92db-471b-fc85-08d91517e3cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 07:30:59.8252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3sCZyGWHLmUE2T3zyzy4pjcnFOYZdZuj8QMapJiN5LcnWc+ltdmjUz9gnThOBNGDahyy/gYmF3tjyDQ8+7Q2dnEnOhWZoO2iIDOtHlprzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7256
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/05/2021 02:15, Chaitanya Kulkarni wrote:=0A=
> Hi,=0A=
> =0A=
> * Background :-=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> Copy offload is a feature that allows file-systems or storage devices=0A=
> to be instructed to copy files/logical blocks without requiring=0A=
> involvement of the local CPU.=0A=
> =0A=
> With reference to the RISC-V summit keynote [1] single threaded=0A=
> performance is limiting due to Denard scaling and multi-threaded=0A=
> performance is slowing down due Moore's law limitations. With the rise=0A=
> of SNIA Computation Technical Storage Working Group (TWG) [2],=0A=
> offloading computations to the device or over the fabrics is becoming=0A=
> popular as there are several solutions available [2]. One of the common=
=0A=
> operation which is popular in the kernel and is not merged yet is Copy=0A=
> offload over the fabrics or on to the device.=0A=
> =0A=
> * Problem :-=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> The original work which is done by Martin is present here [3]. The=0A=
> latest work which is posted by Mikulas [4] is not merged yet. These two=
=0A=
> approaches are totally different from each other. Several storage=0A=
> vendors discourage mixing copy offload requests with regular READ/WRITE=
=0A=
> I/O. Also, the fact that the operation fails if a copy request ever=0A=
> needs to be split as it traverses the stack it has the unfortunate=0A=
> side-effect of preventing copy offload from working in pretty much=0A=
> every common deployment configuration out there.=0A=
> =0A=
> * Current state of the work :-=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> With [3] being hard to handle arbitrary DM/MD stacking without=0A=
> splitting the command in two, one for copying IN and one for copying=0A=
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable=
=0A=
> candidate. Also, with [4] there is an unresolved problem with the=0A=
> two-command approach about how to handle changes to the DM layout=0A=
> between an IN and OUT operations.=0A=
> =0A=
> * Why Linux Kernel Storage System needs Copy Offload support now ?=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> With the rise of the SNIA Computational Storage TWG and solutions [2],=0A=
> existing SCSI XCopy support in the protocol, recent advancement in the=0A=
> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer=0A=
> DMA support in the Linux Kernel mainly for NVMe devices [7] and=0A=
> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit=0A=
> from Copy offload operation.=0A=
> =0A=
> With this background we have significant number of use-cases which are=0A=
> strong candidates waiting for outstanding Linux Kernel Block Layer Copy=
=0A=
> Offload support, so that Linux Kernel Storage subsystem can to address=0A=
> previously mentioned problems [1] and allow efficient offloading of the=
=0A=
> data related operations. (Such as move/copy etc.)=0A=
> =0A=
> For reference following is the list of the use-cases/candidates waiting=
=0A=
> for Copy Offload support :-=0A=
> =0A=
> 1. SCSI-attached storage arrays.=0A=
> 2. Stacking drivers supporting XCopy DM/MD.=0A=
> 3. Computational Storage solutions.=0A=
> 7. File systems :- Local, NFS and Zonefs.=0A=
> 4. Block devices :- Distributed, local, and Zoned devices.=0A=
> 5. Peer to Peer DMA support solutions.=0A=
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.=0A=
> =0A=
> * What we will discuss in the proposed session ?=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> I'd like to propose a session to go over this topic to understand :-=0A=
> =0A=
> 1. What are the blockers for Copy Offload implementation ?=0A=
> 2. Discussion about having a file system interface.=0A=
> 3. Discussion about having right system call for user-space.=0A=
> 4. What is the right way to move this work forward ?=0A=
> 5. How can we help to contribute and move this work forward ?=0A=
> =0A=
> * Required Participants :-=0A=
> -----------------------------------------------------------------------=
=0A=
> =0A=
> I'd like to invite file system, block layer, and device drivers=0A=
> developers to:-=0A=
> =0A=
> 1. Share their opinion on the topic.=0A=
> 2. Share their experience and any other issues with [4].=0A=
> 3. Uncover additional details that are missing from this proposal.=0A=
> =0A=
> Required attendees :-=0A=
> =0A=
> Martin K. Petersen=0A=
> Jens Axboe=0A=
> Christoph Hellwig=0A=
> Bart Van Assche=0A=
> Zach Brown=0A=
> Roland Dreier=0A=
> Ric Wheeler=0A=
> Trond Myklebust=0A=
> Mike Snitzer=0A=
> Keith Busch=0A=
> Sagi Grimberg=0A=
> Hannes Reinecke=0A=
> Frederick Knight=0A=
> Mikulas Patocka=0A=
> Keith Busch=0A=
>=0A=
=0A=
I would like to participate in this discussion as well. A generic block lay=
er=0A=
copy API is extremely helpful for filesystem garbage collection and copy op=
erations=0A=
like copy_file_range().=0A=
