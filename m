Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C98C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 03:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB476023E
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 03:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbhH0DL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 23:11:59 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44608 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhH0DLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2021 23:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630033865; x=1661569865;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jwjbZ6dB5aKvfJFm0kLR4nQz0MwvBNAtrgPhHo9V6i8=;
  b=OQjJBmsHYyQETdqEPulaKJwB+o+g/kcS5SUFQ6DALa1rT5JtXx7GC/rs
   xVmWhI859/RIyRQxdF2kfyjFsggo6JltB8Mmp3q9Vu02X6m6QXwxdFGoq
   7HjG0itbm8YAPZi6LdpLeX76txheHABIwMgN5HK2xmPHBBFMfiwaaKECr
   HvhcdaU3YRObSg+WpCrAAoSUvhfbDCebjokZO5nx9BuAIGCuNt/1cOs/p
   GDYtBIX08X9TWqq7brAGvCnXDJnReykBpeybq6J+147vlM3DvUzt0rFDm
   SiDpuup/xh9/mXjLvfdzCHfrWg4RUA6TvuF8pNSDGYbJloNR/EzCc97/8
   A==;
X-IronPort-AV: E=Sophos;i="5.84,355,1620662400"; 
   d="scan'208";a="282335662"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 11:11:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6C//ggcReWk6Ym5s2/ICu3Lzux0eSvTR6GUFndfgTP731qXWaECY/Jdqrt9/f4icOmjde3n/TyS0P5Se/LHQpy2+RCYQ3slZPlEgKX+6WeDmQWeSvjC5wuyqT+KINPF2bAvuG7xwY/Ow9g53eQdtcNJJ49RKfs6eIcy7G4YG2DRU7OI03504C0VBHwXn+Jy8axsaWk3pY4PT1bgABIVkSkNOqwxr0PTADxbkVET5Q4zQPJu8DPqhgv+YBk03C1r00/9kow9mN6Uq3ysNkSAwRRBazgg3Rm/dHQPa2hUIyrsW/kRzJwZ84SCv8X+McXbsvVGqMELTlhGH42Ny5NibA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbM39UdmdsV8usyABT4UFAUiMYY8JQhtYTUR6Evheyo=;
 b=ApqZxe8KJ7yv1HJuhz5y5BWT+p2aBSvxTtlaroMdTe65JBxAt1flwrj7aarw5d2WKbZ+HSfSTHqZ7uM8FOCEuU7BFSRRq/rw4VLxyAIIsPK4/GvA5aiF7Q+0azbfjCEPMOd/yqSHNO+5ROnCSPRE1iJBhgeB8Xa3iSdV0SECgh1C5FTHmD4MkpbwDdkg4c2NsCNRte8TCnVUgPMWTU/Yy5PdarhFGLeYv/CH3no7cLvcrM7rFFN/1/2mXSOSrriDovfVg12NzHpKSIi+FG2he9GVdCJNtgr+38OxjpbKGm2Zh1aUAkyTTOyYffnh8gHNrTu9T8Xn2Pm5KEnU+lrvNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbM39UdmdsV8usyABT4UFAUiMYY8JQhtYTUR6Evheyo=;
 b=Kq4568ZDka3LU5NA5QiSUrveFGuZTmv/f0YtC+4WMMnAAng7tMYsX8c2JFfsvK57ZM+BPHa1iQ4EYRaxrCuN3qTCMCbtsEBZfQdoBTkEIHB54wUOcc1XXI5Hcp3ILyx1pKp2Xqxb5VQoWTV/w5D20Bk3Ob2BAYl2/XtCkgQS2qI=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0443.namprd04.prod.outlook.com (2603:10b6:3:a6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 03:11:03 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 03:11:03 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Fri, 27 Aug 2021 03:11:03 +0000
Message-ID: <DM6PR04MB70814B1BFAAB64FC947314C3E7C89@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq1ilzsannu.fsf@ca-mkp.ca.oracle.com>
 <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
 <yq11r6f8wkf.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 237ccf3c-dcb7-4fef-9999-08d969084dcf
x-ms-traffictypediagnostic: DM5PR04MB0443:
x-microsoft-antispam-prvs: <DM5PR04MB04436FF03912E1BE549417A6E7C89@DM5PR04MB0443.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ms6znZZtCgQe80zc6iKElFAwi6ALcCqnY9W41CAHDWNm/kPZ97Ca0lyjW55PqLD6jojt94gOElP4Mlu5F8RsfyM2VhRecUAMpkGV9CNAdms6T6d9SWR3120kQ24mK1UKjaK9td87nBtfklB7uYgTljYQjvGZMOAtwcndtPZJ6Xktq7I2L/cZNFOjoNSjwVefEDrJRxDgGJdWRgW1aRlvQ4Ao3ipxFq3mDY397Wn6+7VqRAip0OoQ4FlFIysDno/T8nbo7BTAJfdqP4aPZ2llYmxiu6J68ZlvxxD1jB8+fd05GqntK9aWGxPrbr9UliAD2u4y1P7R2eb1D+tQjCn1tXccqLQzMFp2FT4EoDV4qpoZY1pCiHDwZxKjOLkYlwLYupv2ZZ84G/k4QLoX1h5a92j1ibvOrVNCzI9wpCUDrn16gVN4HoBOOhyE4d0JkV0v8KmQD38MVNLZ/l2GGm1zzsP9uaHkJyljJ29d0qN1mQODgqN/XkntW2AqewajX6QiMQ6uSgMut3AOLKI/94FU7t+HqBZEWTQX2Qubn+APad6yAvprxL3IeQg8CQnpJE08Wo0u3NpHZzB8PUk7fPOSR5UuYKTulNjC9R1xVkJrAN5ufLsgl9WfB/TXQdWdjaGtkDQrpQ0arUQjiILlnrFdaNhizltavG1EYHSA+xvLr0smfd7im412XsQmY5+9+5w8rWLgvptP3NfpnXYckua2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(33656002)(52536014)(4326008)(6506007)(8936002)(71200400001)(316002)(2906002)(83380400001)(478600001)(86362001)(38100700002)(53546011)(6916009)(55016002)(91956017)(66946007)(8676002)(66476007)(66556008)(9686003)(76116006)(64756008)(186003)(38070700005)(66446008)(7696005)(5660300002)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LvL8LhwaWR7kqMJp/SAvq/6zHd+LdrsFDsrCIxUXa12FfBZbynAamX8Kj+Sg?=
 =?us-ascii?Q?3flmSfoMvDKIJLtil6J5Fozmg5VvGNQoJLigMlxNaAyBJuX5V2WyrLbLJ5WK?=
 =?us-ascii?Q?I7x0gC/khxRxG7OGi4aM/I6DMoRP37XMBi3V009pzbfu77CqoHNWO0fkWPo7?=
 =?us-ascii?Q?A0dlBcB6E9EEqjg9KDpVPTeHZF1FQqFb6VU4xsv1u9xCCh2YbqWkVJs31YYD?=
 =?us-ascii?Q?EeF7EYwC49uBarisEdfHG/27IwNckJKJUsEWiINnOgwa6SWUUCUVw9BXwnCe?=
 =?us-ascii?Q?8PdQh3EMmlHQjjzwde5mKFeBuwmb/wxOMqDzyes0jYUXpIdYGy9S6AfH1XHN?=
 =?us-ascii?Q?IndmRdjcBvpFn7BasAk2u1EYAHU5sje3MHT1oO7pXRCy4ctJWF4o1g1QaQp2?=
 =?us-ascii?Q?mxQR3u7PcTc0gb3b704uAlunL8NYCkgYtKap4/SH+fj4/X2U2GaT+8OiedUq?=
 =?us-ascii?Q?sT3pSKlxpj0QEk/jcR8hvfz53G1d1qE4IY6CLaSpoc2LV/LuQw1F7hp9sNQN?=
 =?us-ascii?Q?r+kK+EkwnmKXGposFbWoMQ2YguZbvlNXloVG7qQtLID4XwOECvLxWV4vPen1?=
 =?us-ascii?Q?EYmwdMi2kxcU2pVrRE6hMpl1Os+R643NxE95R5FX0YEl9BUg5F1g2ZOqDE08?=
 =?us-ascii?Q?+PGT7IWcRpNOLbeQCI2PyhDF+S3hjS00z7JXtGCy2I7ZWN/0oZCOKGg8RL0N?=
 =?us-ascii?Q?idQQkPvYVFajOfhHR0a1HGFraMImrbhKcB+ZTzcrc3pO4XNMuc1j0eE8NbZy?=
 =?us-ascii?Q?96AWKby1aMpPJpwSE+dFZRKLHSH+haGZIVdVF0rZdOy07h3VqvI8EAxLSi5K?=
 =?us-ascii?Q?YoDRi5+qC6i0uPcHgV9xuUmfb34biveGcaup2PS58hl4te+vA3iiS6vD89/+?=
 =?us-ascii?Q?N3lHUZIYMMLY+ksZGqsN/DckWfw6C5/6kkLwHOYAMfrN5AsNvgPFp3jWMHck?=
 =?us-ascii?Q?my3lVNsbhsWmnxSwlwLaBjFMQnJ4fxmrOK3OU4rv7+NBsQxpIbiKB0FlKDol?=
 =?us-ascii?Q?eCjvTKZ25uRcy2GfAVdlLpmbb7AY+I3c/KZ2f4mlfL2JIAk09xVtg1gUSc+T?=
 =?us-ascii?Q?1mDYcyHYySUIsEDHO0v3mkb0dHRbflD6eEbjzjmj5gghHrXBZEhutp8VpASY?=
 =?us-ascii?Q?pyvmcoHvo185pKO8RMBCNZiCYoI/dEUcVx020wqbjJH3FxUBNTxbC0E7BEE4?=
 =?us-ascii?Q?q14nEdPBKz2eQs/4ntpZa8XgskvQaiwxS+lNFTOIG3EMkDnFC1peFwvy/SKD?=
 =?us-ascii?Q?TzcYz0nnS2DMd0jN9nDWGJFCZF40mjBqJ2ZIxx1J7pDrH6aSZzoSxJ2wA302?=
 =?us-ascii?Q?sWgvmVF8WBXOkUmGS8OjtUlgHLkVSj6NlRKkijGE44zF13re3piSGgd7lyll?=
 =?us-ascii?Q?NB0UP8qmbcfC/Mu5EGpdnGwOgSo3j+X0wpo3Wr+vv6PlfAD6lw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237ccf3c-dcb7-4fef-9999-08d969084dcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 03:11:03.5323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5spk0IbyLB/9zDNoGn7zA1NunXFHwcHK7OT2/SRM0CcEXCXpvJ4Lr6F6fRe0Gya1LydmRuxuBL9iwSWdj5o0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0443
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/27 12:03, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> I like it, but a bit long-ish. Do you think shortening to access_range=
=0A=
>> would be acceptable ?=0A=
> =0A=
> But doesn't 'access_range' imply that there are ranges that you can't=0A=
> access? I think 'independent' is more important and 'access' is just a=0A=
> clarification.=0A=
> =0A=
>> Adding independent does make everything even more obvious, but names bec=
ome=0A=
>> rather long. Not an issue for the sysfs directory I think, but=0A=
> =0A=
> I do think it's important that the sysfs directory in particular is the=
=0A=
> full thing. It's a user-visible interface.=0A=
=0A=
Totally agree on that.=0A=
=0A=
> If the internal interfaces have a shorthand I guess that's OK.=0A=
> =0A=
>> struct blk_independent_access_range {=0A=
>> 	...=0A=
>> 	sector_t sector;=0A=
>> 	sector_t nr_sectors;=0A=
>> }=0A=
>>=0A=
>> is rather a long struct name.=0A=
> =0A=
> True, but presumably you'd do:=0A=
> =0A=
> 	struct blk_independent_access_range *iar;=0A=
> =0A=
> in a variable declaration and be done with it. So I don't think the type=
=0A=
> is a big deal. Where it becomes unwieldy is:=0A=
> =0A=
> 	blk_rq_independent_access_range_frobnicate();=0A=
=0A=
OK. Let me rework the patches with the full blk_independent_access_range ty=
pe=0A=
name to see what everything becomes.=0A=
=0A=
> =0A=
> Anyway. Running out of ideas. autonomous_range? sequestered_range? =0A=
=0A=
Arg. I prefer independent over autonomous. And "sequestered" is used in the=
=0A=
context of SCSI/ATA command duration limits so I would rather not use that.=
=0A=
I am out of ideas too. Let me try to see with "independent".=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
