Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A46C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D606198A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC2Vru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 17:47:50 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62133 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhC2Vri (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 17:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617054458; x=1648590458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pbLiiCkCPGIvpwFnTr1H/Mr+qA6BR+0XbUvXodA6/OU=;
  b=FgQlLHFfeswDjiu73JfOZjfo4u8UnL3rTekphozeVpRXINThUn3yXnef
   rAwwvImGklMLNwDDmoDkLYBkkmnhSnx1VA9Tj4bWq2AzsdaLHu22wJNCM
   PVgZm2sqwvfO1B8c/axwrmYtvOMzkGZEtv2v1N5U5jshtgP7XUGSnpSVm
   Pk8A0/VkcD2NVsZf8L4HTNSEaYgYnDOFy8xCmkorOIqyezoDPdD+Wk9jt
   aJIAV6J6osytgoDCwnsFSXsVb/xViflZo6UFDVy5intRDZSMkWWU4HtEF
   +q9lMMGbhFM4G4MjIVcZIdEozJhWl2An4bWsVoCb77MnfpYjLXVVCRvr2
   Q==;
IronPort-SDR: RcQocCurWUm9i8j9tmeGUUdGxOMUPRwDKUPp3uxh5G9Rict+KwvCptVJwGcoOpS4+UO2MiOgOC
 e4ATwA66MORvPPp0LVUEt5i91oZ4eV9nLEJRF7QaBRIDtlu+2A5kEtcqkuSX25U4xhLDoVadqN
 CY7ACpeYhpArBRD1QPdQit02hzsNTnv2f04o/WksSTFZE7U8NoJu4UiQyeP0JoEaCYcdOjklBK
 HkDcyWuE/09Hws1gWSuQkKh/Wos+n1Flrm8ZTqKfdNPnaRZD7wdfetTXS78z3CSH/HSc5U36uu
 Y8U=
X-IronPort-AV: E=Sophos;i="5.81,288,1610434800"; 
   d="scan'208";a="120957600"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 14:47:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 14:47:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Mon, 29 Mar 2021 14:47:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkceOQaDAsTSS3Xdgzoot9za5zhurZ2lauNZwo+5mpDGbEUwD8LOa4corkVCXnAHMzlOyKj0qgsLHYzGPj+1LLnt1/xyivqqxRjJrJKtTF2GOoXHdSU5Ocw41w0Bq0/8e9n5XRX/xwVkNDZZu1D9B6zwNkxF96nZVa2MbD0IBCVDlti8RQvo5q01nYDiy6pdTN3gA7YnRLQYndeOUnLhNMNxKLPuy10mzcym43lTt/BjKtogyevc3XPiX3xeIW+UMQqfwEbC77mYyXg4EXDcFwwlItOcaPkRONBnxbRdG4FYUkXAribTOWr5Wrx/wckIEoEtgorb7pmbjACeKm6uPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slItLqY6rFSBzldpat/TLuDUyb1tw7bUwXqvCKkuklA=;
 b=l+vW2aCZ5eb7pYmrghHxim+Xp55w8VfwEAj6uGozmbVFLxJK1KfRjeq9guztK+zsQJmgk2JlJyS83uEGLqVr7UOAqgLW5bQDP2vFmrNrVEWdQgkAHnnvyMAX/gjAYRyeWkuU+qANvKCh0W1ziJaATAO/LMZ07BSJTp52Ibjaz8Aaw4uJ+VWsj9qStQN0DYcfJZB5tz0l9SuU4txkjCFbfPXy1W2yGiwCdY2KIkLzlxGGefLPINy8dtZGCsaqOCPgGi98EJOR5M/jWCiUgW5M9sVr4lAr5JV7YXW/HkQy9thB12QmgnUQ+V0Upelrs6g/fAY+KFIeb+CuRff5Vus8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slItLqY6rFSBzldpat/TLuDUyb1tw7bUwXqvCKkuklA=;
 b=DnI7misR88Rp3Cu+EQSi/9Kxrl41nBErW+wADznoJf/8Rgb3QpoFKLTgyVkoI2XyoMS3QuIN82xf2eBPGuq1JkdwYaDYWwOnUNafCr+hTWBmriEN0py2eUWFyQO//UO3+35bXTO+cJ+J6QyXZwpjgX6+3Dtkql+BjD2iUMD0N1I=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Mon, 29 Mar
 2021 21:47:34 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::a002:6253:12fe:2d2e%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 21:47:33 +0000
From:   <Don.Brace@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <james.bottomley@hansenpartnership.com>, <hch@lst.de>,
        <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Topic: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Index: AQHXCR61OvlQCM/6C0Sy4/3GbWz0Qqp3I2NggA/jniCAFLA+MA==
Date:   Mon, 29 Mar 2021 21:47:33 +0000
Message-ID: <SN6PR11MB28487199CA4563EBEEA9A97CE17E9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210222132405.91369-1-hare@suse.de>
 <SN6PR11MB28485909455144E17F9B46A3E1959@SN6PR11MB2848.namprd11.prod.outlook.com>
 <SN6PR11MB28482574D7952188C1F54085E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB28482574D7952188C1F54085E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a8e143f-dcab-4c79-e421-08d8f2fc42ac
x-ms-traffictypediagnostic: SA2PR11MB4972:
x-microsoft-antispam-prvs: <SA2PR11MB497249AEEAEBD55A183624E3E17E9@SA2PR11MB4972.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RvZ1Hi5A2WKBy1o8Z2ZzoLKrDhLekLVAwd3/JZj5s1Xt9oMqkTxPGnIdXZGiaY1YaGDxQeucwNAf5bHjIS6sC6ZCCHp+lNTz8HyvZhvj7qlCHjzyxqWox4gXrfMUVLSDTfojwGAB63sn67xkurIxjFg2u+0nMEmPXqzNibLSwxlQRJbf9Yj84ITvEjzZ+EW/yhuf812zIEvQza2DEnuKF9FP9uDW30XRz9OgHb2ExSN+vs2r8OA384kqVtKWNSvBZiaRY54zcsHLzKCwSVg1t9S68ML+/eCfs8/gBIf6F/yXClEx5Euv69BNpHbHs33tYtN9sxP0OObZm1HzVLtq51SQFxl9OFozvNIxNIFMdJPGxYl+jzIHDdc0HQ2hfOHsaM9mI9Qau7bOfNG5ChjdO+MkhhAYNzRDFp7EjcHDh+05fYVpWOe/ng2s3erI699ZLKIPjfKdyq6NbYXVQT8k5tMGGuij+Qn/VRA/iEFSTQm+R9y19HXi+TAKtWsU/l/kt2pSs3R3mnuCQJ/qhAUTf5iomYuxlVAK5HYsz5vbDjBLnEDojEKv5YBRqi0i/LJ8CZ8OWghN8Tk3mCUtoUm6Q5POWxe39Oyz/agMq703KEekCfacxP0NuhTbwuz12zsp0rQPL8UqzR6yWABBKc0V9Tf1vs2VSIPjVc1OpNg7xV81M3teeL8eu5Vmhrrc5pb8jBFw4XJ1RnnUMV1eCRJrTEPOyg2taNCQ9cm5EYlxi//FjP2Y0QeUKDDgzpOz1oP/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(66476007)(66556008)(76116006)(7696005)(26005)(6506007)(86362001)(83380400001)(53546011)(52536014)(4326008)(110136005)(8676002)(966005)(316002)(5660300002)(33656002)(71200400001)(2906002)(38100700001)(55016002)(54906003)(478600001)(8936002)(64756008)(9686003)(66446008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?j88a8nrgklITQquR+dgg5MjDiSXuMw8UfdFaBeIZvnAgupRB6zfMqPVwjVwU?=
 =?us-ascii?Q?joiIqDcbEyPUzNoQ4bP881UP5tLitymALu4KpfymP/ciVnZ58jQ41BwyOxHH?=
 =?us-ascii?Q?Dbnzepun7ySPqinUWfMKpyiTHS+K3TED8cToxi/TrSt/hkLZMnuD1MrM7iJi?=
 =?us-ascii?Q?/IoA7lc3qNHkfks4ViU5hZWfJJw2u70wulAcv6PSAer9zTptDIwtpKbpTxgR?=
 =?us-ascii?Q?0UPzOwDmRyGexdTsN6NYQo7ILp2mqwW7iJwezI0d7EHc28nCk+bgca5z/2+J?=
 =?us-ascii?Q?w14/hc+GCHpeJpQ7h/ro1+GyHhX9/wuap5j+9HgU0+IyJg92rOkhhammnGcj?=
 =?us-ascii?Q?71yaIuPu+X+I4PmMAa5KmOmKV44RGLdGmR4H9ScDwafMmUo+B+kLWJDlxJ4C?=
 =?us-ascii?Q?TbWy7Nvw/8h1SC/t3/2W4mAazZvfCgM9sF9ns6f88TQBo9SfmDo8W50hb5eh?=
 =?us-ascii?Q?ZHECcvfS/DR6gKKeT4+SW8v1TdeR6hkuaknSAHmuklAA6YHYSFYaqRPuj9HN?=
 =?us-ascii?Q?CxhV5TpDkeC5vA9z+bQZGT5JQy/dzA3S18LB0mFG+tJ8Fww8w6Ea8z1qrfe6?=
 =?us-ascii?Q?l0nfgHi4NEuz7CDoRw0RoE7iPnJlrBZ+/EkV/cuEzSzoQe0LKBo4ynQEHMrm?=
 =?us-ascii?Q?FxuoPClZvBwgbSacDR5GrGXG8Oy4z361bZy6tWy3mlskmOZJW5UCShOyeVGH?=
 =?us-ascii?Q?pMX93J7u7eHTl+im5LdlhZja4YQ4sdnuUQYh+zWBdKcJExCmtmIIvGw9n2Xd?=
 =?us-ascii?Q?i2fnHtus8FP2h6MQIC3Tz8zTQpFcu45THOoX8/sU5O6XzieGNpI76JPVDznq?=
 =?us-ascii?Q?lPNauCWhCmx9khMXrwOAuseH33YGpaSo4H+EUdl8jWm0CvwuG5vjhJOPVRi7?=
 =?us-ascii?Q?6UDmX090u5ZlRaTz17Np+Js78issnTcqp0qaYSyvYBYwz5MEZ/XRx3uVEQFb?=
 =?us-ascii?Q?0RvatmIRQ3MpwxyREnGjZte42W+Hslyo7RaP3zw6byE00HkYEFG44/eW4NDz?=
 =?us-ascii?Q?Q7fwbJl5z1BLdPmIGXTdb3TS3VIGtT/7Ih7W3kJt8S++Xv66VukYVJIFebhi?=
 =?us-ascii?Q?4VVOphpMpmAHDtJJU8Ox7o99To2A1ESWtl0tIpiK2xpUXEJ0utqGANbywcSw?=
 =?us-ascii?Q?E6xBmxk8BnA/c7e7K/1dELhyDWen8nsuDobnFps/w01w2wRdQu2ti6V5lOp/?=
 =?us-ascii?Q?m8AqhgxDhh+w1dCqJh0nG1mQ4NVqN5dY2bscaZsJ60gHDj7RVPaiKSmueN+o?=
 =?us-ascii?Q?06n/DMKytALB0PmppUUOcsiPZJutv9gUseUbLoqeykNpi4uwlkwcmCS0l1gf?=
 =?us-ascii?Q?yqk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8e143f-dcab-4c79-e421-08d8f2fc42ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 21:47:33.6083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ZU6nE/znZQYEZar/B9Dt8hwzUxrizT4kAZFs8EgNArW3hODnf2YB+a89MOsEyWQJJJV2UCehODSz7vWrvf2Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4972
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Don Brace - C33706=20
Sent: Tuesday, March 16, 2021 12:58 PM
To: Don Brace - C33706 <Don.Brace@microchip.com>; hare@suse.de; martin.pete=
rsen@oracle.com
Cc: james.bottomley@hansenpartnership.com; hch@lst.de; john.garry@huawei.co=
m; linux-scsi@vger.kernel.org
Subject: RE: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs


Hi all,

quite some drivers use internal commands for various purposes, most commonl=
y sending TMFs or querying the HBA status.
While these commands use the same submission mechanism than normal I/O comm=
ands, they will not be counted as outstanding commands, requiring those dri=
vers to implement their own mechanism to figure out outstanding commands.
The block layer already has the concept of 'reserved' tags for precisely th=
is purpose, namely non-I/O tags which live off a separate tag pool. That gu=
arantees that these commands can always be sent, and won't be influenced by=
 tag starvation from the I/O tag pool.
This patchset enables the use of reserved tags for the SCSI midlayer by all=
ocating a virtual LUN for the HBA itself which just serves as a resource to=
 allocate valid tags from.
This removes quite some hacks which were required for some drivers (eg. fni=
c or snic), and allows the use of tagset iterators within the drivers.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v7

Don: Cloned and kernel built. I'll have some test results by end of next we=
ek or so...
Thanks,
Don
--
2.29.2

Don:
03/16/2021
Have run a lot of heavy I/O tests. The driver/OS holds together until there=
 are reset operations. The resets do not complete because of 1 patch pendin=
g on Martin Peterson's 5.13/scsi-queue tree
f749d8b7a989 scsi: hpsa: Correct dev cmds outstanding for retried cmds and =
pending patch https://patchwork.kernel.org/project/linux-scsi/patch/1615403=
17205.18786.5821926127237311408.stgit@brunhilda/ hpsa: fix regression issue=
 for old controllers

My testing consisted of running 7 operations in parallel using a lot of HBA=
, LVs, and AIO LVs.
1. mkfs
2. mount
3. rsync to mounted volumes
4. fio to mounted file systems.
5. umount
6. fsck
7. fio to raw disks.

So far, so good, but I need to add in tests that exercise the reserved slot=
s. I'll start that soon after I complete my resulting logfile checks.

Thanks,
Don

03/29/2021
Don: After applying my patch=20
commit 6651ea81e097b369ececdc53d1e04bc40955d92a (HEAD -> reserved-tags.v7)
Author: Don Brace <don.brace@microchip.com>
Date:   Mon Feb 15 16:26:57 2021 -0600

    scsi: hpsa: Correct dev cmds outstanding for retried cmds

I re-ran my Heavy I/O scripts and testing held up.

For the hpsa driver:
Acked-by: Don Brace <don.brace@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>


