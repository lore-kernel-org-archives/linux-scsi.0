Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC8DC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 16:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE64206C1
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 16:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgLGQmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:42:00 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:47131 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgLGQmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 11:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607359319; x=1638895319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MBqvglTWm0q16rWOSMW+009A8vkUAEYtGwR/RrxTOzQ=;
  b=lBwmDCZdQ0HcXIdwgrK/qnnMQ5k4nYwHdMfPCknKuAtFDwPtQQpJ+Nl8
   qWPfJFI1sy2j0BEzl5OVjCIHBycIAG8kkjCUgPyxIVcWBdTsA/VDPX8LR
   Cu2IGwXkjMUxtvumo24l4JSWmDB7JGtyDX6/IzoVlSSxlaxEPoM3Puht3
   gDGhjkI1Sr0h8Yol+jK9FU4aPN0UrZkTMW4it6VsR5eEQ+EFPHwcxfCLN
   PJVjSTIE5OB54v57bYZ2I+1tSFGCQrB93txAgVYGEpijXQZk+Cv1RMlnu
   DyI0XX7/HbayHH13A6cZmigj8Kwc4KmQ97gbkIx8gG+dcM6iTJ+0zdh3Z
   w==;
IronPort-SDR: 3pA6wnA0QtoVeJeppEcWL/im3P7+RJfVgxZYqp9sdCp0g4D4j1MquCkq67ckzhHNIqowDv5nRo
 3ipAAyk69GIWNNQAK3yTcsap4nmrupO1McuGOAocyrdDGw7dUaEaopxfYi7kfAgJ18O4UCv1Hd
 ei9Cb6VwPNL37zKRXad0r70OJqhIOLLR6wWhIPAhpTugCZkg7VXRNUZ7gDpYkddq9DsNP7yVo+
 ExTLxROiRpZeR77zpzJ09HDBlc/o4l8i+CohaBdZe0UdaICOaVh7SdTmT9+aMuJmohd63cUk/s
 ijo=
X-IronPort-AV: E=Sophos;i="5.78,400,1599494400"; 
   d="scan'208";a="159072170"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 00:40:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZ8Ktq5bAMZnwH17cdpjvHdyF3MkBk8B/r3ZfNabyoRVm8mm3xW/Yc52Ok7nihNuEAGyXqqHjolsr2xGDtb+pZ5gFwrzAIHANidPRyK4lYxBNuxByNEHns5VYgP0oHNvtk2wfdyJf1CZbVYFQBzmIPqPx6Y469gYxm7X+KW/+XCh/Q4B6UtFKJioExJKWwdPAfJM92Sj0lhsAHIB3mGTr0i4Dd3NdhsGRNLRtXoW1jK9IPSb7TpMyf0tXY787Dc1fv9imTMDBvh9rlPVmhpqsZb6VN6xNPvpqB+g6smj5zXiyWykmNYK5xQmKLUbn4dlVcMP3qwfE9S+YBXKaQNOlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4PM6fZTnNjPxmT2yzL/0G97ElsTDKRMNYfFLkgEe/4=;
 b=Ko4gK72hdJj0jzxloTV0l2p3vCq+Qsw2ctKvuICLN5N9zf+auaK1x3959KOL75ZJtTuHIqKyxPDCQwUtxFO4HkTslDqUI73U22IJuvysXNyV9s3QXGbIzHPBAoHf5srO/VkdvtWjuKEARSLFM4lXaXBxEqt1PFiMxxEMEA7HpNCbwpXhXjaD1cCv07vpU5WJ5LoVQapopSab20nNkb4Kugj2OQ+O5bAdm7Vvr5qWFwthXK/lJM9SxNsWYUnzosUWGDh2hwXzCHQiItBrKk/nxej8dwtDzQrIDTzuS1ODjcQAkKtnQDzZ5MAbDp44O+kewlJZV0lvQz7CDcDCgyLSFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4PM6fZTnNjPxmT2yzL/0G97ElsTDKRMNYfFLkgEe/4=;
 b=xQWdflvGMp4L7K3IqbvDIxztQkMv496CAX4Vy2KDg1vAvzWiraiKF9Q465IvZAHB/BiHnQvVp6d9ak/ZFQpLT7m9os+5Uwy8uaFxEOP1xJewNWzWT0rUw7xzZGzqwHvrziEYMDdkZADO/2zoeXm7x6tyEdnYPHqhnR2mmp7fyNs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6574.namprd04.prod.outlook.com (2603:10b6:5:208::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Mon, 7 Dec 2020 16:40:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 16:40:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Topic: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Thread-Index: AQHWy+7VP58/cpTtqkiyF4OIctzYqqnrRKJQgACBJQCAAA6aAA==
Date:   Mon, 7 Dec 2020 16:40:51 +0000
Message-ID: <DM6PR04MB6575CD229D3F6E1C1B30B11EFCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
        <20201206164226.6595-4-huobean@gmail.com>
        <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20201207103708.66897ef3@gandalf.local.home>
In-Reply-To: <20201207103708.66897ef3@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e05fb549-cf4c-44b2-ad63-08d89acedbff
x-ms-traffictypediagnostic: DM6PR04MB6574:
x-microsoft-antispam-prvs: <DM6PR04MB65741FF3C675AACC1F14F83DFCCE0@DM6PR04MB6574.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zlHs3xHwYNamiRakw4LuIc0DYvLWxiO7Ie9zBMG0vIp0bRdi4NqjOi+BfoyCLZKtXNN8ROZKrXNRyEID3uGalHrjGzoEHKgE3/dBrkrVEkYph6P++0/ENw1g8vOdtUKgphbsAsdH+9/OqZyNHX5Q4CqiL6m6PmDAfGa7u6qkWEsFmCAJuI+uy5/PzeZLWaUBFxksYKn3pBwBRcPtQRYleIyV1Up5mzFLeRMFtOLBQw3ZmAj9xJg3hbj9ZxKMH59YJgu+dxltsyd1Ebngk5agIFMl0qtRLCAfycQG9Io5UwXp2JdV2HNDlLXOBRrbQZ/cJf/4bQ2QYD7lYB9CEW17tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(66556008)(86362001)(52536014)(64756008)(66476007)(66946007)(66446008)(5660300002)(4326008)(316002)(9686003)(33656002)(6916009)(478600001)(26005)(186003)(7696005)(54906003)(6506007)(76116006)(8936002)(71200400001)(8676002)(7416002)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yqIZdl0guNWsLwmuIOCvB7PR9cmQgMHyZgcWfhK6kjRyZw+sy6YYWt+wH0XP?=
 =?us-ascii?Q?ZyIEvXQSP5xh14ZVBteY2e9g1IUN02dtcqbW/Mr+yiTMDpDUu0wH1UMrHiIA?=
 =?us-ascii?Q?BpFSNbzXikho/Vss5mCAvMdlZUTaSdMkIPascrxXMR3XASYlzxDVQIYWefng?=
 =?us-ascii?Q?OBFJE9DVoPNZ6W89cvacPgtWyl+vG77NW2A2FfGWqEezqg5Pd1zx5LaN8VFL?=
 =?us-ascii?Q?OEaamWOfzSPO+Z44tWVSzVQiLvHhFaFi5jYsEa3UtgIozMnfw6Z4pHBT+c6I?=
 =?us-ascii?Q?IIaEN6BMcnzEusJfDqzGQqInGyyFJW3TvElW5c/loTqZFKtgx0jpmMBNUCHV?=
 =?us-ascii?Q?b67SidKfFQikblz8Q/nWsv/m61wM/2fv7i+Yo398cf0Qho7rjsDWWVyMpyS/?=
 =?us-ascii?Q?pn10yQ52kHvAB1mm3lS+NsBcG1WR3aYiMw3TZZso/1fsbEogS2nagqNQDwas?=
 =?us-ascii?Q?DMXtZjvHIQ8KexVB30IYz3tClBBBVRHsgnEp7GPAWHSCvEDbc3yxQgmkGVCg?=
 =?us-ascii?Q?03oJGXkj+EoFk8/qZdUousDLhm7dfA2q1fNPk3sIVzi90+ykRimoVixd//Va?=
 =?us-ascii?Q?82SF4Wf+SNLVMLjgSAMCQHmTgDoo/oTHObKdUwBYkThS9dF+ocTQ7qa1zqZa?=
 =?us-ascii?Q?+nWXaAV8M4Fp2HBM2rOviTiB+Bb/9qnJ3tGbqR4QW2O2eFwH4Jl/JSnR1QIt?=
 =?us-ascii?Q?QX3EdXc8aSN6ml5mIeaY12+BPRa/1PzCrWo8wVN3aU1MbVMLFsG72rY2hbLk?=
 =?us-ascii?Q?AdO8Ruix8KBVzM0RTEL9euXXRq/W36PfCxtm9Mb4RJHkcgrqFkWiBq3LW0d9?=
 =?us-ascii?Q?4ONjDQo8KrwnC/PfzEp79FI6FyiMzk2fwRWnMq2nT0sKCELqRxIBsvS+znPw?=
 =?us-ascii?Q?Gfd1YJhMM2TrjTW5K0F0ppypaydZMiJxiWIUhyGJLaRHlvEm4NGwY5hMKyDQ?=
 =?us-ascii?Q?FZs8bGZy7ixiFBp32eY4FI4M3EqpaepxcL3+hUBhsjI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05fb549-cf4c-44b2-ad63-08d89acedbff
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 16:40:51.6418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ErkVLfSTGm2wCcjfkG+UGVym7ah8MZUxx1R28+/cokZCwXCLhsRtfWRy4wowxQjrxqLrnVymvkLFOTR+jFxdhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6574
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Mon, 7 Dec 2020 07:57:27 +0000
> Avri Altman <Avri.Altman@wdc.com> wrote:
>=20
> > >
> > >         TP_printk(
> > > -               "%s: %s: HDR:%s, CDB:%s",
> > > +               "%s: %s: HDR:%s, %s:%s",
> > >                 __get_str(str), __get_str(dev_name),
> > >                 __print_hex(__entry->hdr, sizeof(__entry->hdr)),
> > > +               __get_str(tsf_type),
> > This breaks what current parsers expects.
> > Why str is not enough to distinguish between the command?
>=20
> Hopefully it shouldn't. Reading from user space should use the
> libtraceevent library, that reads the format files and extracts the raw
> data to find the fields. As long as the field exists, it should not break
> user space parsers. If it does, please let me know, and I'll gladly help
> change the user space code to use libtraceevent :-)
Hi Steve,
Thanks. I wasn't aware of libtraceevent - is this a new thing?

We have a relatively sophisticated analysis platform that utilizes raw trac=
es,
Among which the upiu trace is the most important and informative.

This tool has evolved over the years, adding more and more parsers per need=
,
and the users are picking the appropriate parser per the trace they used.

We will surely be glad to adopt new tracing capabilities,
But we would prefer not to break anything.

Thanks,
Avri
