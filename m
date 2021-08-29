Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980C0C4320E
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F926600D4
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Aug 2021 22:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhH2Wvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Aug 2021 18:51:48 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58031 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhH2Wvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Aug 2021 18:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630277454; x=1661813454;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9ThEJZrH48tcOKJNlSLifLtNkzQgyliztdzyhjhPeDU=;
  b=i7297CivlL9o1oRcDNefs11cPeERQ/7RUb9q5Xwxg9AUXMHQmXD+fKhV
   sN66FQzLtjXg3amfMHBj9LUvnOhb83CFog8i9Epn10hvKxVMS2Wecvqru
   JxnVpBZklx3Kb1SY2EjP/oOT8tpx2pSQxUv7cyWIWH5vxG/FUDTtpkIBZ
   EX6n0GDf0qs6CRVqpuKZjF0+ji3pEQrESNRUUe7X6p+qW+q/KcDbP0IY/
   Fi1zFSg0uADbMQdM6mvccLEkmtGZw0ljsn528SN2ocZHYLmyg906djAE7
   qBMBgWqVk9q6e9QKH7XAUzqmNcaQIsLsS3bNVddxMObGmue10j9lwGJzk
   w==;
X-IronPort-AV: E=Sophos;i="5.84,362,1620662400"; 
   d="scan'208";a="179269283"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 Aug 2021 06:50:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpDHhrkRsCRFhu8MKlTdyeL35AkYBvyDWEDuTBPTzftXKSzzeDfeghDGBt+U8xn8IDw77+muu+QsWTXt7YflJEfXKYURWSJ7JRArC0I4wj/zwij+lzjFsabyLe8nSgt6YpW2BMuJ5kjXzAyKWPh++wYgtzEJfdm86+0ux+4WaRjDyyyF5d4yuG1CDWRsxOr6rQ//7tG0bTIn5j/X1WcgO3yzaStsl9XNYg00nfy2fYElqmDOFimY+UVHR/M24AinpE+kxYy4k+i0peJhMnQBxJyDJFF2i//VEcZW9UVHMVmaBzAf5fmRDIedHhFls92IouBsxIhrfCy9+0h00jE88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ThEJZrH48tcOKJNlSLifLtNkzQgyliztdzyhjhPeDU=;
 b=dSXKgHzqv/dLNssGkNswh2SyTvPz5Q8GayBBTI05LunaRCdC1eklKzHYP4stj7n/NP2fXVLNstksc11ow/983wI5VqQWG/Rn0Ayu90jwAS90JxQQZaugCHZl7MBNKaKQz+l5nqMDxWw4HpP2gQxZrv/pl+ovPcxrHjSa3ppQCiLYOl8kRPDgpYci7b9E8YpldeFeMCMN2LaQDicxv4+lQHuXP08P8KE5AxesZ5Nd+hmU2P4RccT3+H+Dxfll4JdrXPeI84PnXspfa3YLK0Fh4kMW224xxAxOLQYijKRYCk1XcWq+LNMG4Z2aKGJ0i5g94dGUh7Lpo3N2vmjuEKfrvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ThEJZrH48tcOKJNlSLifLtNkzQgyliztdzyhjhPeDU=;
 b=hHP2EWNdnkcY7OMJNqZN4OvowYY34j27b7dIf1G7j7NWP7PtgYVm0RgduunMaNt9Bz3dCYdLfIR1xqpnmmbGDhIolb6Y8uO5ZwmRecdmy6yEIr22ISj4K7i8SUofp9feMg3sdR3DUoLqg8kQGhrOPrVEs2l42HwZJ5GQYE3e4Lk=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Sun, 29 Aug
 2021 22:50:49 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%6]) with mapi id 15.20.4457.024; Sun, 29 Aug 2021
 22:50:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Phillip Susi <phill@thesusis.net>,
        Tim Walker <tim.t.walker@seagate.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v6 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXmxim3oZIy1vm80ixsAdRU+BqXw==
Date:   Sun, 29 Aug 2021 22:50:49 +0000
Message-ID: <DM6PR04MB708184344F53156F284DEE8AE7CA9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
 <874kbbugtw.fsf@vps.thesusis.net>
 <63D90989-AFAF-410B-AD11-EDF71CEEE666@seagate.com>
 <87ilzqu6to.fsf@vps.thesusis.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: thesusis.net; dkim=none (message not signed)
 header.d=none;thesusis.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c99771b3-ff0f-451b-1d03-08d96b3f7284
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-microsoft-antispam-prvs: <DM6PR04MB68283A374495F71B7C62676FE7CA9@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ADIsLjaZiyxY2AIqaT2SABUBoeSXlfN6Znj2FyZjDhlRzbvYspWG5JM8I7oIheYQCN9d8ubJlF5U4F2MA1sJEc7jX+PXNao/r03jo6BSoeOJ0QmsSnmMfe+EvDtrQBw+cG8D4RxEGIswlTNhP4/4Z84y8o83ztMIxyyJltJIEas8r+yhbrMibRbiC9UH+IX9ToIqr3qdQ8vgBf0ZHDobjEkIJynF+wyPgmstqyDkYawMzxu9dnuG81h9b3HQuMwgBCO5AR4+1nWbvuYOSxWR1p9GWsqvlge+yCVLbrXTBkIerc5CgJy6jeeALJHYDKul+bfM+MHJoNYYnKYXqMq8NCOP+lnTfUIB+J6n+ptD6bq3nCgTYcT1C/IcmhmtSSjZYCT2B0pgMBMdW2Kt0ieVGu8K2NO2rwZRD2GeZerm53Hw0igvfzxwBdQ54wh8qhRHtBH+eN7Vdd4J/CKLli0SkR79xoVH/dFHuJ1AUnEVVSpUIiJYDzDf39C7yY17j4/mj1+n6dExcKx8r+PtQVFw0lcrMRDMlY7DoaoHPL5o/soVo5viYpuplmiHD+asX7XAMQjIjaRRKCZPhc1i0jy/ThWV3okSwSK/6N3gjjhhmVnfepAm+oepNeRd2bL91/8UkJPbqQfYCGR60u1xSSadzW6yVIm05/ux6oQbKgyrLQejv3SWdVrPEtk18kX0+gQrwgNk5dRc0o6OXesvUgVdbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(9686003)(55016002)(478600001)(71200400001)(8676002)(86362001)(110136005)(91956017)(54906003)(33656002)(122000001)(38100700002)(38070700005)(66476007)(53546011)(7696005)(64756008)(66446008)(83380400001)(2906002)(66946007)(52536014)(4326008)(66556008)(186003)(5660300002)(316002)(6506007)(76116006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NK39THPDtTC4dTmv2WMwkrcRij7ENehQiDNpHVf1Kl0HvGjDXwYRArFBTPA8?=
 =?us-ascii?Q?AvxMkE7w7nf7HZ8prMBIMMaw1exIRiphOeIhOro9o+b6CwdBEO2xdwyGZUcB?=
 =?us-ascii?Q?rvpUbQsp9Narl0nML5jkAl6zPBxb68oI4+oqROxy7a/qwvIGAq8RWLd51dxd?=
 =?us-ascii?Q?nzCdg3ppfhAhloKViQiCt2VAAetzwIBClXDQ4AN5kguCFW1P2Lzf6BEkAJgl?=
 =?us-ascii?Q?w8PSF0EW5Vc+lgJpZkaWSU/hNFNYxb1pRXRbjMVH9DHjPjwEq8/2vGB26Etp?=
 =?us-ascii?Q?dpqrDQf0YLgGer3PCDrvhQFhhvBxQ6dFv1hPLgf9UlsYhUPidrATNw3/6r0N?=
 =?us-ascii?Q?M+2uXF9WAHvPmklx/WHFlFtGNXEPZLVd79ux/zF9VUdF1zq1j2R1Hn1tMqoL?=
 =?us-ascii?Q?k2EIJbwxAYRK3pBUxkbahzG9RdhPo3Eh7My5p98/VdysAX5OrdO6M3/gURwD?=
 =?us-ascii?Q?eckQuJ4XpLqysnYPIvwpMeeCvvo78Y5dyvpSBfPOwEgLYXKuoYbIOw305ple?=
 =?us-ascii?Q?mtPwTc7ud1HBAnGMQ03W584ym3Avrh/tVBuJ2KRrQAJFG3yTVTkhwvcuPIli?=
 =?us-ascii?Q?HQ3bkwYZNzl3EytLjfur6/q2Ar0fSHIBWuNdDVTYyPH9Q21wf8cuGH7gEdDM?=
 =?us-ascii?Q?NXsRpFMpRmeaGqzgZeKOT2tJn52AjnyRThAtZkPwxGEc9LzZjK5JNA9vgyDN?=
 =?us-ascii?Q?8CohDlHDBW/zd9/vOwj6F9pEBsU1VUqf48vvb7mH4OWNdYV5Rs0zUBa8+dAV?=
 =?us-ascii?Q?Kcgyevk4sHX7EROYkl/E5gB1sqkD7l4NwQpjIXJgYDKgSmtFRrITFCaYGPNY?=
 =?us-ascii?Q?lje2nmKF+ZN4hOwmNJwTJFcFehcG6p5fBw0FsOKTCPr068zm/AU0yMkWsvJL?=
 =?us-ascii?Q?rXwbzaq6xLBVR0nS8P2ErM3caI4QUSBX9a1kDr2xzyq9vqtfr/2Otom/hQfX?=
 =?us-ascii?Q?EGTrpC4ir1I+vEf7kSw1QU2Z2v9o1pNmlpfHdcp9Q89SE/AgzQvW+c05XRxb?=
 =?us-ascii?Q?IwBQJhNoGc27NUkjV7zsZSy/l5sbckdBGoskMwgbTPtgXlThMmi0jtfZgaQb?=
 =?us-ascii?Q?IGtLPqJXHIBo1rZVTzqbFpji47qo/eJptihp488sImfyvOQrZqkzHMIEXnDK?=
 =?us-ascii?Q?2YoYjyUik3sP2lEtdYw54WCRKLsMWs9rS+loMgnNzvx6h/+uY1DtWVMUuWHd?=
 =?us-ascii?Q?d5lvh7aiJlTIXL1ckeZ1IdJA28BWS61v/U6soRTbO9e2OkqAxI8lyMrHf8re?=
 =?us-ascii?Q?8FEVWt6bHbjtQZF/7tAI8pLgtD0ARLUfOPa+Z/K6fkgETZErwUzdOoFyoA4O?=
 =?us-ascii?Q?CnfOLr/1DW9BpM5/s9L2O8UQnzOD8p9+0e/uSwxDLRjcEr2HEgI8cY0vpjes?=
 =?us-ascii?Q?jDIwcgS2f45LjDf/Tn7QcCLyfxhx0FLCXk1NbtnKOGMjnnJj/g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99771b3-ff0f-451b-1d03-08d96b3f7284
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 22:50:49.7391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y9WHFggCD2nUZ9qen0/mER3aKqwVrst6tJ3+MYvxtgkLU1N9byoYbX8CSp1roCkcqvTggRN6dp8t3tHRn+ZoaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/28 2:38, Phillip Susi wrote:=0A=
> =0A=
> Tim Walker <tim.t.walker@seagate.com> writes:=0A=
> =0A=
>> The IO Scheduler is a useful place to implement per-actuator load=0A=
>> management, but with the LBA-to-actuator mapping available to user=0A=
>> space (via sysfs) it could also be done at the user level. Or pretty=0A=
>> much anywhere else where we have knowledge and control of the various=0A=
>> streams.=0A=
> =0A=
> I suppose there may be some things user space could do with the=0A=
> information, but mainly doesn't it have to be done in the IO scheduler?=
=0A=
=0A=
Correct, if the user does not use a file system then optimizations will dep=
end=0A=
on the user application and the IO scheduler.=0A=
=0A=
> As it stands now, it is going to try to avoid seeking between the two=0A=
> regions even though the drive can service a contiguous stream from both=
=0A=
> just fine, right?=0A=
=0A=
Correct. But any IO scheduler optimization will kick-in only and only if th=
e=0A=
user is accessing the drive at a queue depth beyond the drive max QD, 32 fo=
r=0A=
SATA. If the drive is exercised at a QD less than its maximum, the schedule=
r=0A=
does not hold on to requests (at least mq-deadline does not, not sure about=
=0A=
bfq). So even with only this patch set (no optimizations at the kernel leve=
l),=0A=
the user can still make things work as expected, that is, get multiple stre=
ams=0A=
of IOs to execute in parallel.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
