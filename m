Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C9FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF154207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="M1xWjH+B";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="meOaDfxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390487AbgE1NqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 09:46:07 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:23614 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390399AbgE1NqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 09:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590673564; x=1622209564;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w8OqObFIzSkoPS3t0mPyPa/5hxqBB0MSbSSc5PB1SIk=;
  b=M1xWjH+BDEyFQ6SatYKLoY3QfPkL7iFVDM+hKEUtK06sJbZ3Gpr1gEXk
   rE3c154aEstEzVtR8kzD6Q/XmmTEvuHF79uT3Ohl8GFeQsE1Au7kvH1JW
   hNSeTGuA41a2KGkB57k/qonz6siJ+Nx77XdTBMyF4T/lPwASM6o5oSOAO
   9ZSUw16V98ne6dmHaQGf5WCWaTuJtBrVuz7A+x10UrNlebSI2SiYlpMIL
   IrZMz0gU7mj1J5Yt/VOu3wOzaZ3nkItEYgeiF77cw9bCdOwEbkNgSJ8SG
   e/+LHrStBFw4uwSWUHQQW9O9bDhqZDwn7Q0863M2ob9LxiLC0x5hsMOkJ
   Q==;
IronPort-SDR: MyzODQS7EGMXiAssSo64dyNo4MKf4vSfRPQXqW0Nu3WPI454JSmusQM/YgB3sErHyaC0rk0qY1
 I/qtWAGEzuufvl9tFjkrbB33nojmvBQZ7o/92smJOEOPRkIJbpmos1P0e9g3oNuHxVF3Fdk0W+
 GcsPUSCytbhcBH/LkBF37JutKdv2863v3VoruK/yyWHAFZ5Lk5R0b+1lldR7Duooyv5TjMjgvh
 aH010PmMpzE0aU4H5i7hITGBSStbe7RQvniigZzGPJOvZMHZ39JhaaiKFp0/e6rtWN1AcG6B+A
 +jw=
X-IronPort-AV: E=Sophos;i="5.73,444,1583218800"; 
   d="scan'208";a="78134463"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 May 2020 06:46:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 May 2020 06:46:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 28 May 2020 06:46:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8lrmwD946VPapRudP2YtptwYLH+1cAsfUIHTtcPnnwCPAsgMmrdJjkOHXLnOHCUmUmvJpfuSXAQuaaFqC+Xtdax9xcb3P7qWQBlluINcqZxS+zgjD4JE33s8gSKXl+/8VrrevH+VYW7+O+fY6sqNtr8NfkMJ81NhQrWsF2uACiVWKBWMbF7EuGXaUhnMUAHvFzmzAZhdSAkD9RrwpSC2JtjqrjB1zxcLwkcfCWaeFer2SdSeylqQ2wLstafsXz0yLrD+Yog/2rLkohC/60p+W6I6JuUcdzvB7W+T59jVHiqc4gVdsy5mPktkGb6T9Sq7ypj+zB7CNIR/4xDVqylbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiSpXlQe6jiQY4JBT2aRnonkGHdH8La9ewaETQdyBTw=;
 b=UDmMyqaKyiHHrEZUAgGOjOHYrJLHOPe5QDlfL6pGnwsfFoKf6foEMjg9Jt7SWWTUsSTGAFnZfrWNuMs3jcj8Ky9WQYQ8+objnwX6X9xrvqATyHscKfWaw47Oowvb80CR6JFxmdlP8TJJU08XM/VduYp8es67D63hBsPk4SS+3M4fsu+TufA6KcGUvgNXWZK/JYdQi6G6zHlLanfB5yUsZ0FNhQdKNEkl4MQE+zYiqvxkx+7KEhVbPs6N2xu6wEP4nwimf4V/qgPYApgOjgZJKG/u7Ce15axhHkB8ELHhGelKLfONWx1Lsc2kY2EgHD9NVPcV+zzq28tYG/RwNqtygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiSpXlQe6jiQY4JBT2aRnonkGHdH8La9ewaETQdyBTw=;
 b=meOaDfxx9EwDXIs7yzP1DRdukdzsgG0SeQz03j7w68pPrvKvOkfw/zr1M6t4X3/IFm+JXHWK0E5vyQGCzCQFFZvpLxAOtaof3NLLpnZdYfXmmC2NQSPku3shTCpM+78v7dSRRr45S7dDa+3C4ScaxuApfmCXBgQVVd8NYAaHs6A=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3246.namprd11.prod.outlook.com (2603:10b6:805:c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Thu, 28 May
 2020 13:46:02 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 13:46:02 +0000
From:   <Don.Brace@microchip.com>
To:     <cai@lca.pw>, <don.brace@microsemi.com>
CC:     <martin.petersen@oracle.com>, <scott.teel@microsemi.com>,
        <kevin.barnett@microsemi.com>, <esc.storagedev@microsemi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
Thread-Topic: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7
Thread-Index: AQHWM3BY96yTrwyUV0WbU/zWsYVO+Ki6ezQAgAHs8AA=
Date:   Thu, 28 May 2020 13:46:02 +0000
Message-ID: <SN6PR11MB2848B54B5E6152AA4A7BC261E18E0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20200526151416.GB991@lca.pw> <20200526151926.GC991@lca.pw>
In-Reply-To: <20200526151926.GC991@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lca.pw; dkim=none (message not signed)
 header.d=none;lca.pw; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.211.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2151be55-1d39-4ba5-f18a-08d8030d7615
x-ms-traffictypediagnostic: SN6PR11MB3246:
x-microsoft-antispam-prvs: <SN6PR11MB32466A2335E931B9217FB00DE18E0@SN6PR11MB3246.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:57;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PFx6bDEmZ538warg3d4HM57oqEOevSxD0ELFnhiguucln1bPZ0Yn5FHwaQC0pHLlzjSn/AgWyeUJuyzm3aQ+clpu8oPU+dPrPH1d0vyJkuYhViOkAMCbn2NPxpTbwr+tE2o2UjuCL8RbtCZOqgJZaKUkgsfMH7o/pFLwhDdpIiDgPqTuWxDYiSEVmbeE2iqtOHI3CqTUyKo7dW7BD8jarc0bF3gkMuen3iCNF9PwSU82PaeKBEBbxiY/LMAl1mtA9ZjWJ6uQhibPyKFvR4nm2Hnnb7JPkcX3JYnP93KhlSQG63wYuFqDcQoDqKhin7tbihpGqMwc0YE09p55d3byXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(33656002)(6506007)(66476007)(64756008)(66446008)(66556008)(53546011)(26005)(83380400001)(7696005)(2906002)(186003)(5660300002)(8676002)(54906003)(316002)(55016002)(8936002)(110136005)(86362001)(4326008)(478600001)(76116006)(66946007)(52536014)(71200400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vFVpj/wK8De7OSPWbQsEcLi2ptFjYSD/w3aeVRRpd3ZpIRPgn7s5loAT+BuyWAzoglGHCyalv39OSD07VooHcD8CW7papqooxKeleSOiYjLpXOFeocgB6DSJ0XFw5nZHhubKEqEwaIMYfLUvHMfQjeruVmLiCvO04ZKYucOsI4autSMBxSK2ukK+MSoVt/JTDUofGNpMqGHNjbS657g7UfXnRCgZi37heWV0P9aoBKiFHvg5iXH/use24qXFe7/U03lPikHojJJBmjVacbZ9eooqb1gVCF+oRfmyVuLqR28qPtct3S04D8lGthPUQwMMo6W+lI9o1+of8ouGiHVVLsriJPtPbkQ7hAnbl6lDNccIhsiveIafKVqnQE0ExPek10z0zYJZQ6/nCBQnwUImddLH+WOSYx+4QPuxdtgzWlKxMenXSOKTqje7rzMaHUcBOK5xVm3BqwjunsTvoxUUzEl36siaIa/ULTZPl3Kw+Rs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2151be55-1d39-4ba5-f18a-08d8030d7615
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 13:46:02.1933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUctHKi+sP+FU/EIOVrhpKIW+POypdaqMaAa/tBt5BprvBa3KrJhFUzuhnq9Dyo3J/EqeBH9U9We1oq6LXBJgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3246
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Working on this.
Can you send your configuration?
ssacli controller all show config detail

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Qian Cai
Sent: Tuesday, May 26, 2020 10:19 AM
To: Don Brace <don.brace@microsemi.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>; Scott Teel <scott.teel=
@microsemi.com>; Kevin Barnett <kevin.barnett@microsemi.com>; esc.storagede=
v@microsemi.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: UBSAN: array-index-out-of-bounds in drivers/scsi/hpsa.c:4421:7

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Sorry, adding a missing subject line.

On Tue, May 26, 2020 at 11:14:16AM -0400, Qian Cai wrote:
> The commit 64ce60cab246 ("hpsa: correct skipping masked peripherals")=20
> trigger an UBSAN warning below.
>
> When i =3D=3D 0 in hpsa_update_scsi_devices(),
>
> for (i =3D 0; i < nphysicals + nlogicals + 1; i++) { ...
>         int phys_dev_index =3D i - (raid_ctlr_position =3D=3D 0);
>
> It ends up calling LUN[-1].
>
> &physdev_list->LUN[phys_dev_index]
>
> Should there by a test of underflow to set phys_dev_index =3D=3D 0 in thi=
s case?
>
> [  118.395557][   T13] hpsa can't handle SMP requests
> [  118.444870][   T13] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  118.486725][   T13] UBSAN: array-index-out-of-bounds in drivers/scsi/h=
psa.c:4421:7
> [  118.521606][   T13] index -1 is out of range for type 'struct ext_repo=
rt_lun_entry [1024]'
> [  118.559481][   T13] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 5.7.0=
-rc6-next-20200522+ #3
> [  118.598179][   T13] Hardware name: HP ProLiant BL660c Gen9, BIOS I38 1=
0/17/2018
> [  118.632882][   T13] Workqueue: events work_for_cpu_fn
> [  118.656492][   T13] Call Trace:
> [  118.670899][   T13]  dump_stack+0x10b/0x17f
> [  118.690216][   T13]  __ubsan_handle_out_of_bounds+0xd2/0x110
> [  118.712593][  T378] bnx2x 0000:41:00.1: 63.008 Gb/s available PCIe ban=
dwidth (8.0 GT/s PCIe x8 link)
> [  118.716249][   T13]  hpsa_update_scsi_devices+0x28e3/0x2cc0 [hpsa]
> [  118.786774][   T13]  hpsa_scan_start+0x228/0x260 [hpsa]
> [  118.810663][   T13]  ? _raw_spin_unlock_irqrestore+0x6a/0x80
> [  118.836529][   T13]  do_scsi_scan_host+0x8a/0x110
> [  118.858104][   T13]  scsi_scan_host+0x222/0x280
> [  118.879287][   T13]  ? hpsa_scsi_do_inquiry+0xcd/0xe0 [hpsa]
> [  118.907707][   T13]  hpsa_init_one+0x1b79/0x27c0 [hpsa]
> [  118.934818][   T13]  ? hpsa_find_device_by_sas_rphy+0xd0/0xd0 [hpsa]
> [  118.964279][   T13]  local_pci_probe+0x82/0xe0
> [  118.985405][   T13]  ? pci_name+0x70/0x70
> [  119.004244][   T13]  work_for_cpu_fn+0x3a/0x60
> [  119.024672][   T13]  process_one_work+0x49f/0x8f0
> [  119.046431][   T13]  process_scheduled_works+0x72/0xa0
> [  119.069906][   T13]  worker_thread+0x463/0x5b0
> [  119.090347][   T13]  kthread+0x21d/0x240
> [  119.108531][   T13]  ? pr_cont_work+0xa0/0xa0
> [  119.128450][   T13]  ? __write_once_size+0x30/0x30
> [  119.150405][   T13]  ret_from_fork+0x27/0x40
