Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82C2C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B8823A79
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 13:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgLHNZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 08:25:51 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59473 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgLHNZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 08:25:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607434869; x=1638970869;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=91EJSzxq/YEfbAkcIdLSupxnoZVXuWbvJqJer5qsXXY=;
  b=NzboMq3SdNKas51roZ3AxP8CWsGZwSJI80B+pkhbSF8Z5l0vBx+0fZeY
   V5xV6fVXcUhaj9sCPWm45tkzhLG3jOeJ5HZG1YuclNGrAMD+UMEU0vyyx
   gx15V4NySTOHbkYW2JcvyUXSOgY+l4RQa+35Ra/bbyaMbrsmbFGF7XXnQ
   tkey8EugbEUid4gINIxxDdP7EpiAbZMXB4xswX/2WPCfB1ueDCRc+bNcJ
   WFowSXB+paiB+Zc4j2rjKEpXm/XP9qaxPz429ByYf0g0mJ0GeGsk/5n3n
   uDD4kqNk6NEKasp7nYbcahLlMrDrKDnpovcaE/ASjRjIHGJ8YCJf+ghUN
   A==;
IronPort-SDR: fb+bTgp3khtlTJU1k780w0Mgb/LQlDHmka4017BhxJFw++OKZJvthnX3hi35EvE37Ww4vCURIk
 ldJ+oghszShiUxAMnk/9gD1bTbir/laQpoFEeu+MJgmDH4fNY/OtH2NKrIjYQJDxX8YzQpJG/P
 u5ZnRV9fFWMc4s2BPPdDe0QHlLH6+F8DQaXCJ8es439dbikk9fEP1o9PGARNC1rrNsiUAmeDAv
 o50JQ1l/s+SWUON1XqsYT35E11+uhqdXxnFVgu8zbHngMxTQ3jakD8Ywk1l7Ud5dZXUIpBXh6E
 QLk=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="258402624"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 21:39:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONGkVEQyptpK40NvOLHTBfr2ixWPcd+UCzLlEbWIh1nR08tH9OBSeUpqkpV7bBuQVN8x4Kbya+IYTgNaaa1/Y/PxIDypD0WYYbHNgLvNO46Ltu+A8bhznttarB6v8+gCt5Z3s523t9U0+K5N+fHxAIlzUilFar97e5pzrw3ieJENLNcc1RW2aChIlLodN5irXEKRi6r5wzVgF2IX+5Lj8ZO/ypAiK97BWTynQIn3C6o0R8L20tu8EBCtzo8B1lf4r5JStleJDLVb1NHug+mHs5LOjMEsGd7Ug8ihYgn7TdS7m6lovSu2/0J4aX98QiiqS8x4l/o9bfU0t/dYdsN41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91EJSzxq/YEfbAkcIdLSupxnoZVXuWbvJqJer5qsXXY=;
 b=AWXIoty2HUcJtMQZEZPcIRcg8CABm5AP8RXwqHJglhMsFP3koB4RVo4hCBPJpsbJVm7+hc/bKAy42Cknl8sEWInS+jcG3KdgMEkztuBxBDdoNfiTmkz84YExT9YtZPD6fuV148CkxZY73vf+7NoxbPi5s/DYuAdmpwcKZFT1S5AKpsyGLjcjcGJL4/7ZLEoYbSenMMTDMiExR2kfCueCYiQ/fKLuBc+27CQyVKOQQwj1ZHPPFNKc2KdxiVKu5s4+uSjFMQOAQw1cDcWXKNPz/MZhntAOUZzslT51RLd9C52s3Wqvj1b5tnmsCdgmuJ3bDm3QZZ0IIftCQA9sSESLYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91EJSzxq/YEfbAkcIdLSupxnoZVXuWbvJqJer5qsXXY=;
 b=AViTZSTaiqwKfdC8oWiALX98Z8KmcL3uG0PbmZZ/JTfXtsRsRMjvKWiNrve136C7/Yg1u3tJhrwb3wNfz/ITZbzBcfa9KB50f8COGCXbN934g3F7LvehHGcBG8JC/XIQbPODHa5VQsZlxa/Rd7wVdMusjICvuzjFEZWK8TieeEc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3597.namprd04.prod.outlook.com
 (2603:10b6:803:45::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 13:24:40 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038; Tue, 8 Dec 2020
 13:24:40 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
CC:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date:   Tue, 8 Dec 2020 13:24:40 +0000
Message-ID: <SN4PR0401MB3598226CD4A32F65320A47379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <20201207192453.vc6clbdhz73hzs7l@mpHalley>
 <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201208122248.utv7pqthmmn6uwv6@mpHalley>
 <SN4PR0401MB35983464199FB173FB0C29479BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20201208131333.xoxincxcnh7iz33z@mpHalley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10798663-c440-4025-bf1f-08d89b7c9e17
x-ms-traffictypediagnostic: SN4PR0401MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB359773CB1B0034B8931C20259BCD0@SN4PR0401MB3597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c2PLqFM/Jm3mCxGb2iAJ7P19oC1TfnGtmHWbypWEN+5MAmxBp6MUaFBPZEWCiz83phD63b1ZEfDMFBl/GUuH4Yc/qP679K0sjaSstvrMoO++72CDWxYtyxx9pR5FUZdHBmWPes5q8Nsj+e/leZqleUMvh68xOjDc74HgGR7+CgJbYtF6E+kWcFr8OgxaOR2eJ7jAjh8uY+sQvrDkOZL/060Btx9kKdmTUedrr3W5gTiKPFB7YWh2NW9sreYsjB0eXehJjuZ12XmaUPyAcgcVXARyOuXx5EjTXClmK77hWA2zgvDceo0tEyy6vBETI4exDFnXfy6QYe3Lgxldvu+Jww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(4326008)(66476007)(91956017)(55016002)(7696005)(508600001)(64756008)(76116006)(9686003)(66556008)(5660300002)(8676002)(2906002)(8936002)(66946007)(86362001)(7416002)(6916009)(33656002)(52536014)(83380400001)(6506007)(66446008)(26005)(186003)(54906003)(71200400001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?JDlF4xjuWz48JgWAeT6R0gHSc7vBPMAYX1Iifak8svrQTF6ofyjwSm2wkI?=
 =?iso-8859-1?Q?Mz0cs2yYeB0KCe09bK820AXPs7Hy40YqUbdTgey+9J7je9JmqLHn8XszFb?=
 =?iso-8859-1?Q?/erzT/UwTxwzOAfOAY4vRXzfu7ISE/T+B4M0iZHy9beR7WSo/02VQBykNG?=
 =?iso-8859-1?Q?6KV3q20i6fLDg33m0/hAVxjgGpROd4+DF7y4/pbbfOByf5bdpilz7YQoRg?=
 =?iso-8859-1?Q?GP3V4duYTmePyrtmJVx3Si4NsFTAuM6M4o1TqMbWq8vlDYz0cshY62HDbc?=
 =?iso-8859-1?Q?f3IXmOgA7Fiq253lCmzw5Vvinfu1TWpXGP36Hb1jBXRD9aBZD6/MQDbM5Z?=
 =?iso-8859-1?Q?P4wmzjrItBGKyqtPWDWGGiSRZkVgJ1vSwvQE13xusCl2Qoo9pq9b+nz540?=
 =?iso-8859-1?Q?6JettY9PtPX82eF1ABNyDNAQ2+WEEyoqX9fnuQw4xg4gfGaS4rO3TpAD/K?=
 =?iso-8859-1?Q?z8gZO72Waj+Z4mQSXN4f9170MdAlvtfii5YvB3Qxc5V1nri/vkCKqxal6P?=
 =?iso-8859-1?Q?CcLafYQbKQ+qHw0ANyMBr/4KZooFeRd5UyxqYqxM0txlNnEOSwfNYVgD7t?=
 =?iso-8859-1?Q?5IbdWISg1yLsrkTvoUp1f3iXsLvrS7PvwFlQx/bnRao7iEybm2SejxV7jm?=
 =?iso-8859-1?Q?IbTKquTCV9gFV+fk6wKW8ZZI407u8uz1RHzd0qQafc398ehZyLQFaJPnk7?=
 =?iso-8859-1?Q?xs2uQkImVox93YhcqSycbRmsLh4iihZL+VXhAGvllaDyTHdcNkS4hJRC2v?=
 =?iso-8859-1?Q?qa7dWBqJm0s10o3Ui0YQucKhNfoOp30+p4r6j+dI+lYL/z2ibJrhWk5wNp?=
 =?iso-8859-1?Q?VcQTHMBKICQ3+bJVYWZ2nGOk4BOdbR1+HcSXCHugdSirTNHJPdRvyJiMNe?=
 =?iso-8859-1?Q?oWEf1B69VFcGGXb6Qtl/Gd43C1Bg49WUUpv2js2siRdi4U0lmI7NUOm2qX?=
 =?iso-8859-1?Q?o5mncb7KTsliZ2XElNAoHd9XtP1XDBLZLu97maJWfjxj8tWJJfVmq5MBUj?=
 =?iso-8859-1?Q?z9bYGqfeHbpMihUHPC8U7n0wiBfMeOhyUy8LSc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10798663-c440-4025-bf1f-08d89b7c9e17
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 13:24:40.2752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdRTaI6g/b3dVS9wANrGo3W7hTOb+JWw3Q4aOh4P33V5HBLvSx8iQjqjszszzV2ySMtCA/ZyEc4qJlvQIy9LCV13i3bMKVgmpTb/1WWbe+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3597
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2020 14:13, Javier Gonz=E1lez wrote:=0A=
> On 08.12.2020 12:37, Johannes Thumshirn wrote:=0A=
>> On 08/12/2020 13:22, Javier Gonz=E1lez wrote:=0A=
>>> Good idea. Are you thinking of a sysfs entry to select the backend?=0A=
>>=0A=
>> Not sure on this one, initially I thought of a sysfs file, but then=0A=
>> how would you do it. One "global" sysfs entry is probably a bad idea.=0A=
>> Having one per block device to select native vs emulation maybe? And=0A=
>> a good way to benchmark.=0A=
> =0A=
> I was thinking a per block device to target the use case where a certain=
=0A=
> implementation / workload is better one way or the other.=0A=
=0A=
Yes something along those lines.=0A=
=0A=
>>=0A=
>> The other idea would be a benchmark loop on boot like the raid library=
=0A=
>> does.=0A=
>>=0A=
>> Then on the other hand, there might be workloads that run faster with=0A=
>> the emulation and some that run faster with the hardware acceleration.=
=0A=
>>=0A=
>> I think these points are the reason the last attempts got stuck.=0A=
> =0A=
> Yes. I believe that any benchmark we run would be biased in a certain=0A=
> way. If we can move forward with a sysfs entry and default to legacy=0A=
> path, we would not alter current behavior and enable NVMe copy offload=0A=
> (for now) for those that want to use it. We can then build on top of it.=
=0A=
> =0A=
> Does this sound like a reasonable approach?=0A=
> =0A=
=0A=
Yes this sounds like a reasonable approach to me.=0A=
