Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A854C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 12:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345437AbiFJMZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 08:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbiFJMZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 08:25:25 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2293E0CB;
        Fri, 10 Jun 2022 05:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654863923; x=1686399923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/yXGXZZOYZg4S5y2csvu/7rqVLHDt+vybshK5dHShnE=;
  b=AwA7zCxxunKhCpHcWKIx+7rZE5+l/lMejF5YpI5FNte3m0pxaIGO/aPu
   qOj69TwhxQNKez2tckB0y7IUZyxXHDVEdwet/6zMrE2iG1hO23QfSN6QH
   9EuCYf1DGjs+wI550JRG7nofoMKB5f7oKPCaKol2LcgU0Dd/bppN4/V6b
   q7SvDFwusKNIv1P9iCeDxbmX0iysprymN5PCF8VsZQMJT1+J0XyYloNFp
   aYCzz8/u91V33Pb7qWe3gg8Yy8aMj1N0TL/datCNNShmeVYE1nuwhWYok
   A3LLNx5RpxchyEKFYf2nIc/0G88Xqh+Jued8Alj9XHAweuHCzinlWmvFn
   g==;
X-IronPort-AV: E=Sophos;i="5.91,290,1647273600"; 
   d="scan'208";a="203572437"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2022 20:25:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFWzXuv/EvMAj2W2r0JurwKGR+ZI58Ly1p8h26snW0cGgwMOJ5hteL69yoE1bm3n4gj7975C0Cwv6PM3toWoQFiA/j5Yu363bZBYkQDZ1DrC6vwQ/Y/dMXS3zVUetM7Iod+3TwRXYVJFLoGVMRgpnFifrDs1ei4LSFcSSlA4FUp8Yhs+idyK5K+egXti2356SmdJCewTWFVEh+1TdtVd5bdwLufVHQzzqrnuQWHDP0678ArYe+VgwKXOKteZYJ/IRXom29WbkbOL73FYxT471eNyL4ywWGPflCmjoZbclalVtyRJt7+O/UJFesinFv5YFi3ez42irwY+lE6hjZBWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCHJ+bAQen825XaAm/THVmSkrT20iQ47Ydf0pK6Gmbo=;
 b=GuSy4w/wF8L0kqxhVyHoCT1tFpNIoJCm6BwKVJw9q12mmFSOn8iKEZijJZO59JBO6lVjTb568PcX7C99MKsk+30Wx7DvN6KQE4CjcV8hIG3V60WbhewnVDcVR37CKhpm0Hi9K/gLhN037G7qICA+2DGp4A+uVRl7a+Zl3F5jad9Tf6Fyn6wGSpe8fE0D7TLKbP1ZmXtA8fHgcgMkQrkJYP1qa9U1GLK53fA7XOo0qFAXQOI4b5JiZaxq6O2uH8KHMM4kRaVMFzbxFmW7TLk4+cPpL0L7lf8o8f0PTHQW2sRJQBQRpkaB4fYU6KKdLdbtb4EO4t79WZj+WTmR1TM5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCHJ+bAQen825XaAm/THVmSkrT20iQ47Ydf0pK6Gmbo=;
 b=N2SirbJwC2DBrGH6ZleHCdrn6unxUPq0W/Njno4acC08UY9p0rPLzXX4/uElgIKpDhzJNtPFApruvs214o+GWWfrphRapmoWMaImuvIHVemnwYTPT3ab3jGgu1P7hmrJgouXlfbql9gQ4HIjg7DNayG42u/vI8RM2F/aBDYF4Aw=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BYAPR04MB4229.namprd04.prod.outlook.com (2603:10b6:a02:f5::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.18; Fri, 10 Jun 2022 12:25:18 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 12:25:18 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v5.19-rc1
Thread-Topic: blktests failures with v5.19-rc1
Thread-Index: AQHYfFwe8PMwMXtEZEqIJFDj8WJWFa1IXnmAgAACxQCAADBSgA==
Date:   Fri, 10 Jun 2022 12:25:17 +0000
Message-ID: <20220610122517.6pt5y63hcosk5mes@shindev>
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
 <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
 <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com>
In-Reply-To: <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 860a6094-9f3d-429c-c11f-08da4adc4796
x-ms-traffictypediagnostic: BYAPR04MB4229:EE_
x-microsoft-antispam-prvs: <BYAPR04MB422991F70059CDC5123790ECEDA69@BYAPR04MB4229.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mpeRq7ceQcsxB5WE6xrUrjBee232IDgXWo3iUIcex63IpXaut5nlhdng1LER478Xl30TpzvQQn0g8B/yGBQnv93nTdP9sn7ZlNFMX/2qi3lX0gUVuLdSosPWucY4vnFsI9wv+QfS08Zl/R3ssIey7geML/Yn2I41s3GVZ8c6LgI5KZR6OUBngEHHwc8uNQ37ds842fvm7JNRMYXjz5rt+uho7EqF6S0vB8vK86zyfRvSLRFpTywW2rLRaFRHMCNbJ3ObJyVYYuxAquQGgH6oQGkk8Tq0tvXeu6b7dZyIaLbxPbqRt5zpS3odBGMX7rTbxLXSlO/kYlPEtODe7N8ezFSYkcUxiHdX81j2GIKqLt6bjSxNpuslxqtZPksP18IADukX8XPHT+6NT5ZMgN4bsDBoogjSgyI2LrrFmjr3lk6JC9T8k5tTzpAHKYhGqJWr6/oQVZMQZafSQtUD7qjQMNmTj0UwylcFRdWB9nJO+gStKhgmpVo0aKHYOQ47Z7X5pXCxHfiDLN+LGl8rFSNtmeiLLRxeZZgukML5+nc44DanV2YcwWPslyMFdaiiKNkjzZ0VnFcS7JK51kIpM2vr6zZuKTiIuXQ27moTe5KwH1cz/z1zaeq8Rivy6bb2FJDBS+vyVVLBj1/NFd5hPkiojI11HdvL4NgayprTWRKRqq5AFSW5owT/r0kWtib73Ydnl4QpOjn4or9AkkXpwdsq9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38100700002)(186003)(8936002)(91956017)(83380400001)(54906003)(6916009)(38070700005)(66946007)(44832011)(66446008)(66476007)(8676002)(76116006)(66556008)(64756008)(4326008)(5660300002)(508600001)(6486002)(71200400001)(122000001)(6506007)(82960400001)(26005)(2906002)(86362001)(33716001)(1076003)(6512007)(9686003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J6vFHEVV2t+FHMvdRT4PSO1TCXI2qeHvX9G7QrVjHNGo8aQNIM5BahukXB98?=
 =?us-ascii?Q?AZlFpjOL2R+mMOmxZnkkLurqs7eGPe1SsytmFO7JUfRCTJGoJFjKLKwb9otS?=
 =?us-ascii?Q?B+NXzWb9A+Or5A31QHAeNLATabmhNwI+epG8RzsaqfNyZBOhdE80AkAdW/VL?=
 =?us-ascii?Q?lXH0mkkfcIATvfyKDe1HrtoB15WlV+Y0IqDlYpczWWTwFW9p7C7w9+QJTJhd?=
 =?us-ascii?Q?IMwGkQLrfT7F78EDAGtyu0h7PykmFOcgTXRGGGyXmMufEMT6x6uCPGEmRxvy?=
 =?us-ascii?Q?NAbNu1a+H4gBozdAlcjZAoUHet8d2ejQtEKqFXoFU+4s6kknR+r7eU1h5mJf?=
 =?us-ascii?Q?J9N7P8HRoVpNNRUeWmZpTISd33+8RXnJU1p7XUcYN029W1kmXAQBcgodMNyI?=
 =?us-ascii?Q?nNgS0X//8i01E/fe0yQm8doBDhnBjJGbE3nFkHOF8ue+BegBIhvY8/XIi2oG?=
 =?us-ascii?Q?Ke5RxWClxAC1kLZcmELIKq8+dt2u1/WrnMKf5zykYPF74dVs70d2YWcJvSB2?=
 =?us-ascii?Q?v33Ie1su8/AYKOsuWBSrGWGCdkD1TJbtL54aSKg4498qGMtWKgtkDvaqVAWx?=
 =?us-ascii?Q?BDGpEwGL6Ge2Sx5v37J6/KRoXG+QHLBdYGY4PxyPRiBfEY+KCrCyJAyHlEhc?=
 =?us-ascii?Q?4vacRlaItm3vp/vojkV6DeW6SLDSEbds1BC2dSN1MD83MABZxBfGhLFxe594?=
 =?us-ascii?Q?c540zbO0WnSaqO2an5beO88poq2Yp/zkELTJGnFOIf1drBbSp5Gr8rSbo/ib?=
 =?us-ascii?Q?ONnLtEi34duXEjRfB7YAP1OA6M5AiYmOdMlFq3IbmTT3Tj3lYgoLywBhY37k?=
 =?us-ascii?Q?GB7QdCRM/lACAdWOUiDJpqIfGubm3oYH9WYzTW7q37tGwsDcHRu6ZbwYaKOb?=
 =?us-ascii?Q?a2wQKK2UcpIQJldLvb6FQc2lVBjx3NQeeMGYR7+d/lOSGT/xLpupjXuKAEMF?=
 =?us-ascii?Q?WZt3drLnVIMv0YcyfedmgFJZBE37CxgHZVC1GJ+o66ueaqohV28Ph317ucG/?=
 =?us-ascii?Q?dgg3/AN+T6Ez9t29Tpn3uILPF9s0wvyAa1ic+c+KZj3MZNEgsR8sj81arcXD?=
 =?us-ascii?Q?kbIEoJt82kajrHEImVvvVNde8R0VhofZAjqgrTY9XazUwfrccQMn7Q5NZlt/?=
 =?us-ascii?Q?FKoO3LGBJq491BVZodiGMq9+M6Ggzr80kBG6cb0a4cOihdgNEZu4nOfJtojM?=
 =?us-ascii?Q?NSUvVixC5kqqyrVrWZVcGHLuywj8L2wEKR/hDgrDAY0KPlcFCFD9jetoEFJ6?=
 =?us-ascii?Q?rYtHtC7NhhFFyTCvy6T8woYHcROc85WDGSNNuOHBl3eOMct34ULduOiWlCDa?=
 =?us-ascii?Q?MIASaNZxEaJGXW5WYnzeRVprWn9kmDDItK/cBJDgAPopXsir+g2++LhrBkDi?=
 =?us-ascii?Q?fcXLCYcAQYblK80y6np36Ie9A8tuIsnmn8CeyJV4iNGc9D/3VFLQwaoQVz60?=
 =?us-ascii?Q?D5D/7Ma3IbpbLKD8qcDbU9p3erbhtsAUJlCVVzNfSHHC8wjeeuTTKmske8wy?=
 =?us-ascii?Q?0UV8IMsAJsirNVogu9XhWPjN2TrI9eXfI1sQln4JeJXKv212YeHPyg3n/Ii4?=
 =?us-ascii?Q?9f7QTQGgr4pxq+sAhD2zLJu1EspJ/AWxqsNFlUywfUTStzZZU5ARS4IqNQPq?=
 =?us-ascii?Q?0cHd1Ydd/glScXSYybB/FdeMPI57WIBP1wFAkjWutq3s5H/11PlGKBYc7Llp?=
 =?us-ascii?Q?gJCstPhH9F4tqBcSccv4pcTeb+BRyrVD6nQ8yPVbtRTHgvn7/VQaLJV9/tx/?=
 =?us-ascii?Q?d9+TRQcDX61xNjwkXP9ZvLiiXxtNKepejxCXBrD+SXpDQRsOjaqp?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D1CE167B8B6C44E84A7360103E1F630@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860a6094-9f3d-429c-c11f-08da4adc4796
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 12:25:18.0357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1WDgT+fRRk3hfEwwZm9nkWfk1v5aTxaFsvjzWG3a20l6vqs1JsKpEP7YTf4mz0wXjyRkhxQjV6WuzJ2wI0OKUqTv95Rrt+RDbcId97u/VjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4229
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Jun 10, 2022 / 09:32, Chaitanya Kulkarni wrote:
> Shinichiro,
>=20
> >=20
> >> #6: nvme/032: Failed at the first run after system reboot.
> >>                 Used QEMU NVME device as TEST_DEV.
> >>
>=20
> ofcourse we need to fix this issue but can you also
> try it with the real H/W ?

Hi Chaitanya, thank you for looking into the failures. I have just run the =
test
case nvme/032 with real NVME device and observed the exactly same symptom a=
s
QEMU NVME device.

FYI, here I quote the kernel WARNING with the real HW.

[  170.567809] run blktests nvme/032 at 2022-06-10 21:19:03
[  175.771062] nvme nvme0: 8/0/0 default/read/poll queues

[  176.017635] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  176.017637] WARNING: possible circular locking dependency detected
[  176.017639] 5.19.0-rc1+ #1 Not tainted
[  176.017643] ------------------------------------------------------
[  176.017645] check/1147 is trying to acquire lock:
[  176.017651] ffff888107010cb8 (kn->active#256){++++}-{0:0}, at: kernfs_re=
move_by_name_ns+0x90/0xe0
[  176.017683]=20
               but task is already holding lock:
[  176.017685] ffffffff859bbcc8 (pci_rescan_remove_lock){+.+.}-{3:3}, at: p=
ci_stop_and_remove_bus_device_locked+0xe/0x30
[  176.017701]=20
               which lock already depends on the new lock.

[  176.017702]=20
               the existing dependency chain (in reverse order) is:
[  176.017704]=20
               -> #1 (pci_rescan_remove_lock){+.+.}-{3:3}:
[  176.017712]        __mutex_lock+0x14c/0x12b0
[  176.017720]        dev_rescan_store+0x93/0xd0
[  176.017727]        kernfs_fop_write_iter+0x351/0x520
[  176.017732]        new_sync_write+0x2cd/0x500
[  176.017737]        vfs_write+0x62c/0x980
[  176.017742]        ksys_write+0xe7/0x1a0
[  176.017746]        do_syscall_64+0x3a/0x80
[  176.017755]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  176.017762]=20
               -> #0 (kn->active#256){++++}-{0:0}:
[  176.017770]        __lock_acquire+0x2874/0x5510
[  176.017778]        lock_acquire+0x194/0x4f0
[  176.017782]        __kernfs_remove+0x6f2/0x910
[  176.017786]        kernfs_remove_by_name_ns+0x90/0xe0
[  176.017791]        remove_files+0x8c/0x1a0
[  176.017797]        sysfs_remove_group+0x77/0x150
[  176.017802]        sysfs_remove_groups+0x4f/0x90
[  176.017807]        device_remove_attrs+0x19e/0x240
[  176.017812]        device_del+0x492/0xb60
[  176.017816]        pci_remove_bus_device+0x12c/0x350
[  176.017821]        pci_stop_and_remove_bus_device_locked+0x1e/0x30
[  176.017826]        remove_store+0xab/0xc0
[  176.017831]        kernfs_fop_write_iter+0x351/0x520
[  176.017836]        new_sync_write+0x2cd/0x500
[  176.017839]        vfs_write+0x62c/0x980
[  176.017844]        ksys_write+0xe7/0x1a0
[  176.017848]        do_syscall_64+0x3a/0x80
[  176.017854]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  176.017861]=20
               other info that might help us debug this:

[  176.017862]  Possible unsafe locking scenario:

[  176.017864]        CPU0                    CPU1
[  176.017865]        ----                    ----
[  176.017866]   lock(pci_rescan_remove_lock);
[  176.017870]                                lock(kn->active#256);
[  176.017875]                                lock(pci_rescan_remove_lock);
[  176.017879]   lock(kn->active#256);
[  176.017883]=20
                *** DEADLOCK ***

[  176.017884] 3 locks held by check/1147:
[  176.017888]  #0: ffff888119ad8460 (sb_writers#3){.+.+}-{0:0}, at: ksys_w=
rite+0xe7/0x1a0
[  176.017902]  #1: ffff8881241b1888 (&of->mutex){+.+.}-{3:3}, at: kernfs_f=
op_write_iter+0x215/0x520
[  176.017914]  #2: ffffffff859bbcc8 (pci_rescan_remove_lock){+.+.}-{3:3}, =
at: pci_stop_and_remove_bus_device_locked+0xe/0x30
[  176.017927]=20
               stack backtrace:
[  176.017929] CPU: 7 PID: 1147 Comm: check Not tainted 5.19.0-rc1+ #1
[  176.017935] Hardware name: Supermicro Super Server/X10SRL-F, BIOS 3.2 11=
/22/2019
[  176.017938] Call Trace:
[  176.017941]  <TASK>
[  176.017945]  dump_stack_lvl+0x5b/0x73
[  176.017953]  check_noncircular+0x23e/0x2e0
[  176.017959]  ? lock_chain_count+0x20/0x20
[  176.017966]  ? print_circular_bug+0x1e0/0x1e0
[  176.017973]  ? mark_lock+0xee/0x1600
[  176.017983]  ? lockdep_lock+0xb8/0x1a0
[  176.017989]  ? call_rcu_zapped+0xb0/0xb0
[  176.017997]  __lock_acquire+0x2874/0x5510
[  176.018012]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[  176.018023]  lock_acquire+0x194/0x4f0
[  176.018029]  ? kernfs_remove_by_name_ns+0x90/0xe0
[  176.018037]  ? lock_downgrade+0x6b0/0x6b0
[  176.018048]  ? up_write+0x14d/0x460
[  176.018055]  __kernfs_remove+0x6f2/0x910
[  176.018060]  ? kernfs_remove_by_name_ns+0x90/0xe0
[  176.018071]  ? kernfs_next_descendant_post+0x280/0x280
[  176.018078]  ? lock_is_held_type+0xe3/0x140
[  176.018085]  ? kernfs_name_hash+0x16/0xc0
[  176.018092]  ? kernfs_find_ns+0x1e3/0x320
[  176.018100]  kernfs_remove_by_name_ns+0x90/0xe0
[  176.018107]  remove_files+0x8c/0x1a0
[  176.018115]  sysfs_remove_group+0x77/0x150
[  176.018123]  sysfs_remove_groups+0x4f/0x90
[  176.018131]  device_remove_attrs+0x19e/0x240
[  176.018137]  ? device_remove_file+0x20/0x20
[  176.018146]  device_del+0x492/0xb60
[  176.018154]  ? __device_link_del+0x350/0x350
[  176.018159]  ? kfree+0xc5/0x340
[  176.018171]  pci_remove_bus_device+0x12c/0x350
[  176.018179]  pci_stop_and_remove_bus_device_locked+0x1e/0x30
[  176.018186]  remove_store+0xab/0xc0
[  176.018192]  ? subordinate_bus_number_show+0xa0/0xa0
[  176.018199]  ? sysfs_kf_write+0x3d/0x170
[  176.018207]  kernfs_fop_write_iter+0x351/0x520
[  176.018216]  new_sync_write+0x2cd/0x500
[  176.018223]  ? new_sync_read+0x500/0x500
[  176.018230]  ? perf_callchain_user+0x810/0xa90
[  176.018238]  ? lock_downgrade+0x6b0/0x6b0
[  176.018244]  ? inode_security+0x54/0xf0
[  176.018254]  ? lock_is_held_type+0xe3/0x140
[  176.018264]  vfs_write+0x62c/0x980
[  176.018273]  ksys_write+0xe7/0x1a0
[  176.018279]  ? __ia32_sys_read+0xa0/0xa0
[  176.018285]  ? syscall_enter_from_user_mode+0x20/0x70
[  176.018294]  do_syscall_64+0x3a/0x80
[  176.018303]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  176.018310] RIP: 0033:0x7fd59a901c17
[  176.018317] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f =
00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  176.018322] RSP: 002b:00007fffe29bbe98 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[  176.018328] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd59a9=
01c17
[  176.018333] RDX: 0000000000000002 RSI: 0000555e68a93c20 RDI: 00000000000=
00001
[  176.018336] RBP: 0000555e68a93c20 R08: 0000000000000000 R09: 00000000000=
00073
[  176.018339] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00002
[  176.018342] R13: 00007fd59a9f8780 R14: 0000000000000002 R15: 00007fd59a9=
f39e0
[  176.018356]  </TASK>
[  176.057966] pci 0000:04:00.0: [15b7:5002] type 00 class 0x010802
[  176.058006] pci 0000:04:00.0: reg 0x10: [mem 0xfb600000-0xfb603fff 64bit=
]
[  176.058059] pci 0000:04:00.0: reg 0x20: [mem 0xfb604000-0xfb6040ff 64bit=
]
[  176.060129] pci 0000:04:00.0: BAR 0: assigned [mem 0xfb600000-0xfb603fff=
 64bit]
[  176.060152] pci 0000:04:00.0: BAR 4: assigned [mem 0xfb604000-0xfb6040ff=
 64bit]
[  176.061638] nvme nvme0: pci function 0000:04:00.0
[  176.074114] nvme nvme0: 8/0/0 default/read/poll queues

--=20
Shin'ichiro Kawasaki=
