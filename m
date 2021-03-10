Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735B6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 22:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E5F64FCD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhCJWpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:45:43 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27059 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbhCJWpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 17:45:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615416333; x=1646952333;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Fz4sLBQarSo34eGbq9rYcfpjKa9Ky2Jwi1ysZz6sXqo=;
  b=ANqYhKA7aHQKpvDKXJADxuhzO34IyAg/oPzjRiBYDh6ScofCs1Zgu5EP
   GRS+sCvfVjduuLQonoOOFRgZFdDqUxVkZsZMUcQcNOo8X6E/tlC8L6hU4
   pcIt81Ufoab8Cbj0LmkJn+IcPVGy+FylKnmQtpNaDb5dhC8rlvumVe/ck
   N//TJayYDACX+SbPsDzJVAhqoG0Ij4g7GRmDZAAQbVD1++NKwDEyxjj7v
   mtrVFaznKUOaJCSnH37LIcny+Qb6kx3PhLpGVuFh3d3jpti9gqFT44hpx
   zWputQ1InHGjy5lTSkQO+thYnGRVLcbEDQYuxcvxBvbPtuTOagxLJH4jD
   w==;
IronPort-SDR: 6Aj5mosg/ZKo06NchMInavyXG7AYl1ngfq30umZTqBlaDPutgctwCE7aaIU7GXcjYNiLhhBpE+
 OHDp6xXC61C6+6PgZ6DD601Y0rLtYrtJHKyK+qXv1rWB1APeOxhB8TRx3xaf876y5JJlkPdsDq
 ewqYyeeJDkctVLkGGzo4zB/YkH6QGKwzyqsNshYOULZjYH4Sham8gg6ev9YhtCja//UDhao4nT
 uC2gXUEXTYL7+s6E6c2A+LuHIJ8xAmstRWqk3eka27w97E7p/iNtrEFWM89BkpuL1LZrgfgLC5
 ros=
X-IronPort-AV: E=Sophos;i="5.81,238,1610380800"; 
   d="scan'208";a="161851082"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 06:45:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7rYtTki1eiAMWIt6XfDS0zFecQbBgTiTjh0cztOjJ3Sqe9+hlw9MGTvQCat4GcndfMuGXx0DFj2hOlcUbeFrU6fe9U3tx47guCNBL/6dd6ab5l4CXkprJDKcY5Pw3+X+A+L/bTFZpuvHTVQXsHMDEaPIfn8O1go5eL6swnJmC6gRJlDt7Hqq5J50oBdDUY5OKgZ62Oksnfkxo4BfzyqKiaQ3rYoMv2M1DyR8AgnECh7xfCJm3AD6I/fjj/7CaVGa+EAghnmF22OX7qVkHwsukNATlPwCOwS9tZQQMHz0kB4yItXlFf8J59INiuK7eiUvEoJtE/LoeEcIOwtwnSi8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeGgLzCE6QCE1CUX7dvMTOKsHKFFCvm0ls+2BZoXILQ=;
 b=H5WWV8Z0/4oGK/tpFc6lo8ZSxkAJS0iRwRaaT6ZrWPRQA8omcJY/t387FFjBRpUwm1un+3fTDj0z4jybdFUgnwPoq7FPoVRtFpLDmTw0JCT0k4qvpQ9r0QZU0UuHrPftVCnnwrBofXh3VGmLnxjdx82vmaEEhPfDrDwzJOh/mzycRmtrby4SJHKMz2+XYpNYo1wHdq1CM8JpYfMZQm5jtvvFDxQ4REQeWu/zUaApzYQCAJKFScLQEj0xrH2xAKAwMGNN6E05SLGTJRfSbpN5FzRuHSHtq2mSaNy7eIe/ImUdLUzB5YL23OdBgHY2bGs2gK/e3peCMbwHqrY4347xzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeGgLzCE6QCE1CUX7dvMTOKsHKFFCvm0ls+2BZoXILQ=;
 b=MRDCSLJC56ozzCbnN1VMWA5ay03a5PE27i1sfJl9oiruuG/Ga0bumFIQyNEAiPfp/CZG/lNo1jGrJEeXE7pRAJ9aloJYq8v/ai0phULM+2TXGG673bLVfHXOiMNASXQC06QUdGbkcDaFrEaGhjmU9vD3t/xjB7H5Cz5z29+t3gY=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4916.namprd04.prod.outlook.com (2603:10b6:208:58::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 10 Mar
 2021 22:45:31 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3912.026; Wed, 10 Mar 2021
 22:45:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ927MRhl54FUuu2AgpdB7HQw==
Date:   Wed, 10 Mar 2021 22:45:31 +0000
Message-ID: <BL0PR04MB651472FBB9FBD637C6701991E7919@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:c1a6:aaec:6201:ec23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98cc9b4b-8932-4c22-8e90-08d8e41635f8
x-ms-traffictypediagnostic: BL0PR04MB4916:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB491618C298B7325D5F8C4397E7919@BL0PR04MB4916.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sg977YhmS3eMnjVW4GPe49a2l1nY7PlPACq13ORyCa2irYeskuyDfyvIH+JmR0+sjZwzZFMIm5UFx9fqchnk4qsZc1q7Opo+Xn6qXAB0ecFBcX4jtXCePAUovPyr5B3Gv6OEgz4R09/3MF3q7Sjnp6VhVfjLSfhrz18fZ9Ox/cmYmUXmGD6TLMgMuzm+2M04rIS1Ap0l9WnkuKhp4w8wauCafAeL3SNqh3UoUemyWzzIG093lEsezNVBjVQuzUKeTirRpnU6f9Tu8mU1FhumXqJXNg8hYi3dqUeadO6FmaPyeltvyqve7ZOLJDX7H7NRHM5ZgOK1m9ZhpXiYfEFpholsgPXU0+r8cHPUpacuwPwe4iGzX0hLeBDmKL2YK8xiUgjwTCZPF+dYShPuSjrG3JxrnVsm+XS8hP7gmEfEBtonC25K3I+PPkTgVKSqNkaDIfHmuuO4cyb3+ewLPULYct9XZEG++xan9Z5vxm+SxgBxTzwp9r5RoR1TWHFNNSzo3wY4856NlmHcpb1eJ/pK8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(6506007)(66556008)(33656002)(66446008)(64756008)(66476007)(53546011)(2906002)(91956017)(4326008)(76116006)(66946007)(9686003)(110136005)(55016002)(86362001)(52536014)(8936002)(5660300002)(54906003)(15650500001)(83380400001)(8676002)(478600001)(71200400001)(186003)(316002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nFNRszuegAlj+dRgHkYrKf0190nOGTVGYJGutRjsLSUrBgAg4SkxT5phNxBn?=
 =?us-ascii?Q?zGCrPbQkFz7MfBCs2JM8cP5723sODPJiV4BFtz4EfITmxaBVNuWt3R01SFro?=
 =?us-ascii?Q?sT5YyS9Xu/kbY6gOSVK/vvopmVSVbSfVYmu1uxiTyHO1yEs74NcuL3GZnVL2?=
 =?us-ascii?Q?jPDqjtdRXySvV+b8p5cCxKnkJJ1Lk0lHYJURReLsfgbE8VUzgHvfd0AC7xrD?=
 =?us-ascii?Q?GZSgQ2/66pJ78FwJbX8d+qpXmTrssBvUqpSm9hpwUoNVXV8Pq06L1x+a+F47?=
 =?us-ascii?Q?Nbq4c0WJw+jqKq13YubbGtFD3ngJcUnCURso83wwT67rlSsduoygaFowrm7n?=
 =?us-ascii?Q?rE1MNeZB64xDcH17Uxgv1R4XLmg+4ft6FYTPiqnMf7hCNOvVfSlipxWz5PGJ?=
 =?us-ascii?Q?zVnNRyCS+Qe+QDdjTQYQCQQCRrI0dk30o1CoysOBae8D2xcje4DNJa+q4CYp?=
 =?us-ascii?Q?iR8vKuD1RgioOkc20GwKDfRgDWTj5KNOlmEspc9N5wh7uVUKsVb4j4P9OySy?=
 =?us-ascii?Q?p5+7hBD/AUzRqKBq1vTNEliy46pLwDnW1j44+ro+sYOKO0lfe2Tru4C7Z3g1?=
 =?us-ascii?Q?jGUqurG8evFuMlTcJWzhRhmQKXzX8B0pPzdkM1rjdJxMylH4qe3ur0c/hlM8?=
 =?us-ascii?Q?UH6wxW0JU3yewr/Bbm2VCrzD23vvQaMsTvkaR94bB2U1LTezebOCvDQ28Dc2?=
 =?us-ascii?Q?6H/V4suklxCDlw91HgZvbjr7fBnT/j4EJX29PnvDwrQrv0E+kL6xMCleFW7B?=
 =?us-ascii?Q?kGkKbkstPgAMiz+a9hGX1kqHaUfYTP3gHOfTEOpgs1jGkemyjHVqXPCq+K0c?=
 =?us-ascii?Q?cADYCDd8rb+I8AHDd3ZWHQA8rKbVoHlj3ky0kD3g4P4ifhPHKOff2ju4yg6Y?=
 =?us-ascii?Q?MBaq0tDdOTfdMbLnanfdK23v7Olf2Iq1nN15UtzHZ/j44TN2e+6gw2Ypjhcm?=
 =?us-ascii?Q?b/UGnlhLnRrmk7Ngk3uYJpkhWrAfbYDcy9Eq8gDQF3D2XQk9iw4R6ejdZDCt?=
 =?us-ascii?Q?Z6Tl5FwLv3z011V9UKltDJ3d+/EwoEkWDwLClEZWgQQGBvx9Y8oFD34gZgZj?=
 =?us-ascii?Q?qIVx//ozpBnAM5kxfby83qYHWpO1txKn9QO3pXuF5DuW/gag/0GWixhLT6CV?=
 =?us-ascii?Q?oHKH3aeyZOkSa8lxo66fXbZGAF5sGVPEnH32y9cj0yv0Zxp4BeczSaJ2wdpf?=
 =?us-ascii?Q?4KN4GnVxvS9J89CX1yCpNQhS3qqYGHiLjtbu8UL0cBR/eEs32YfrM5QKNnbb?=
 =?us-ascii?Q?AcxNpSqDVWq2kabvfd7DATXmDXpJmjorMzp+g0S5hWj1ZcLuf96XNpIKEAlU?=
 =?us-ascii?Q?de4lWJRTgsR+N2OGB7Z/fc5WEWlzdcPrhhI+ozIIMALbjtwfoyNiXK7w7QjR?=
 =?us-ascii?Q?UppSNEfbmTcp9Q4S9ZFrEd1q5bi4Y/Darp7PZolkC9/5G9wAGQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cc9b4b-8932-4c22-8e90-08d8e41635f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 22:45:31.7715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: er7fcbKmfGIBsB/6Yi4rrvIKIZ8pJrJm07w0uQWe2qgr7SOfS6xj4mXb+D7vEroUQQIUACbQnexDOwqS5N/kRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4916
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/10 18:48, Johannes Thumshirn wrote:=0A=
> Recent changes changed the completion of SCSI commands from Soft-IRQ=0A=
> context to IRQ context. This triggers the following warning, when we're=
=0A=
> completing writes to zoned block devices that go through the zone append=
=0A=
> emulation:=0A=
> =0A=
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2=0A=
>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015=0A=
>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50=0A=
>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006=0A=
>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013=0A=
>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd=0A=
>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0=0A=
>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200=0A=
>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218=0A=
>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:000000000000=
0000=0A=
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0=0A=
>  Call Trace:=0A=
>   <IRQ>=0A=
>   _raw_spin_lock_bh+0x18/0x40=0A=
>   sd_zbc_complete+0x43d/0x1150=0A=
>   sd_done+0x631/0x1040=0A=
>   ? mark_lock+0xe4/0x2fd0=0A=
>   ? provisioning_mode_store+0x3f0/0x3f0=0A=
>   scsi_finish_command+0x31b/0x5c0=0A=
>   _scsih_io_done+0x960/0x29e0 [mpt3sas]=0A=
>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]=0A=
>   ? __lock_acquire+0x166b/0x58b0=0A=
>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]=0A=
>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]=0A=
>   ? lock_is_held_type+0x98/0x110=0A=
>   ? find_held_lock+0x2c/0x110=0A=
>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]=0A=
>   _base_interrupt+0x8d/0xd0 [mpt3sas]=0A=
>   ? rcu_read_lock_sched_held+0x3f/0x70=0A=
>   __handle_irq_event_percpu+0x24d/0x600=0A=
>   handle_irq_event+0xef/0x240=0A=
>   ? handle_irq_event_percpu+0x110/0x110=0A=
>   handle_edge_irq+0x1f6/0xb60=0A=
>   __common_interrupt+0x75/0x160=0A=
>   common_interrupt+0x7b/0xa0=0A=
>   </IRQ>=0A=
>   asm_common_interrupt+0x1e/0x40=0A=
> =0A=
> Don't use spin_lock_bh() to protect the update of the write pointer offse=
t=0A=
> cache, but use spin_lock_irqsave() for it.=0A=
> =0A=
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>=0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 19 +++++++++++--------=0A=
>  1 file changed, 11 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index ee558675eab4..994f1b8e3504 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -280,27 +280,28 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zo=
ne *zone, unsigned int idx,=0A=
>  static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)=0A=
>  {=0A=
>  	struct scsi_disk *sdkp;=0A=
> +	unsigned long flags;=0A=
>  	unsigned int zno;=0A=
>  	int ret;=0A=
>  =0A=
>  	sdkp =3D container_of(work, struct scsi_disk, zone_wp_offset_work);=0A=
>  =0A=
> -	spin_lock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);=0A=
>  	for (zno =3D 0; zno < sdkp->nr_zones; zno++) {=0A=
>  		if (sdkp->zones_wp_offset[zno] !=3D SD_ZBC_UPDATING_WP_OFST)=0A=
>  			continue;=0A=
>  =0A=
> -		spin_unlock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);=0A=
>  		ret =3D sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,=0A=
>  					     SD_BUF_SIZE,=0A=
>  					     zno * sdkp->zone_blocks, true);=0A=
> -		spin_lock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);=0A=
>  		if (!ret)=0A=
>  			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,=0A=
>  					    zno, sd_zbc_update_wp_offset_cb,=0A=
>  					    sdkp);=0A=
>  	}=0A=
> -	spin_unlock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);=0A=
>  =0A=
>  	scsi_device_put(sdkp->device);=0A=
>  }=0A=
> @@ -324,6 +325,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,=0A=
>  	struct request *rq =3D cmd->request;=0A=
>  	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);=0A=
>  	unsigned int wp_offset, zno =3D blk_rq_zone_no(rq);=0A=
> +	unsigned long flags;=0A=
>  	blk_status_t ret;=0A=
>  =0A=
>  	ret =3D sd_zbc_cmnd_checks(cmd);=0A=
> @@ -337,7 +339,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,=0A=
>  	if (!blk_req_zone_write_trylock(rq))=0A=
>  		return BLK_STS_ZONE_RESOURCE;=0A=
>  =0A=
> -	spin_lock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);=0A=
>  	wp_offset =3D sdkp->zones_wp_offset[zno];=0A=
>  	switch (wp_offset) {=0A=
>  	case SD_ZBC_INVALID_WP_OFST:=0A=
> @@ -366,7 +368,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_c=
mnd *cmd, sector_t *lba,=0A=
>  =0A=
>  		*lba +=3D wp_offset;=0A=
>  	}=0A=
> -	spin_unlock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);=0A=
>  	if (ret)=0A=
>  		blk_req_zone_write_unlock(rq);=0A=
>  	return ret;=0A=
> @@ -445,6 +447,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi=
_cmnd *cmd,=0A=
>  	struct scsi_disk *sdkp =3D scsi_disk(rq->rq_disk);=0A=
>  	unsigned int zno =3D blk_rq_zone_no(rq);=0A=
>  	enum req_opf op =3D req_op(rq);=0A=
> +	unsigned long flags;=0A=
>  =0A=
>  	/*=0A=
>  	 * If we got an error for a command that needs updating the write=0A=
> @@ -452,7 +455,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi=
_cmnd *cmd,=0A=
>  	 * invalid to force an update from disk the next time a zone append=0A=
>  	 * command is issued.=0A=
>  	 */=0A=
> -	spin_lock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);=0A=
>  =0A=
>  	if (result && op !=3D REQ_OP_ZONE_RESET_ALL) {=0A=
>  		if (op =3D=3D REQ_OP_ZONE_APPEND) {=0A=
> @@ -496,7 +499,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi=
_cmnd *cmd,=0A=
>  	}=0A=
>  =0A=
>  unlock_wp_offset:=0A=
> -	spin_unlock_bh(&sdkp->zones_wp_offset_lock);=0A=
> +	spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);=0A=
>  =0A=
>  	return good_bytes;=0A=
>  }=0A=
> =0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
