Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9E6C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FC021775
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="cMOFFlWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK1Lp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:45:27 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:26973 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1Lp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:45:26 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Balsundar.P@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="Balsundar.P@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Balsundar.P@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Balsundar.P@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: LF1Tk0tVAyfsCKYF/PYPQHjnWUlUzwmnskeLXxygeZlBtSkOxzM2DRbQ01VWuGz/Ozgtf/cVxP
 cXopC5jvfFpQnZStyM3kDBnCDsYTlm5JCwyeAX49RvyGVR3dgPbI9ZtmPnPlmH2cGwes5Tx4sZ
 BqUKpcObvibaRRA0hGQr/pTIlXktRxEP1CNcURLu4w13ErQVLt341F6nCJMI7HpCJfaOCqT26m
 C+DxfaUxCo1jvXvu2cqJTsp3Qqcvtk2YBGpIZDKJnN+fmImUYbhoZM854iHDW61eCNPeG8pGdh
 2rU=
X-IronPort-AV: E=Sophos;i="5.69,253,1571727600"; 
   d="scan'208";a="55992277"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2019 04:45:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 28 Nov 2019 04:45:17 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 28 Nov 2019 04:45:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI4lX1xeb2j4rXpQ0iqUCcL47FTCUFieG2AnodJ0no2ieaE7qn893hiHBat8nhUI5/Pl3Cwn2ffzS8GMrVx/4FPY4TpBI9MOpkOuCf/e4zxM3NyrbtWZwHMv2Co/LxTm6hpS8nwVU1PrgpR8ChRSLgH5lEL7QVUYMh9SZtdBElmjltlIWNqSKvbK77UH1PzBGtdlfOuwXoutn380kpmPF79rWbLY66qJvGMebCDUQaT0KJESvGD60QtMqYurJdCtg0J8Rh7/pYH63dNP3TShnXM5+ES5wJsrn5vnbbElYLqID+1LnjHpts9X6GLoAc+Mzf2tS45pBPoUktLvCePrKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvJSHnmsTHGiCOdUoUOFpIgjPoc2PnW9Z4sJHK1tb/I=;
 b=ImuSp0ggcAOOg6BvSRLagnZhvf/3ZWfSu/45gg531R7c7jd2KqubVuKnYckNx6+r2fPpqWpCv8HBkaUCFOSkN83anmAXxuBNu7wFOkU9dOuDqFNSXiBQYy+nIOnnczH4WPz81DQwkDNXRwuVv5KX6lnOHW3RztsH5yOP+KI/UXJc7vFMSfUWzjWj/M0vR4q0C/88U+NETTH2KGv/EbE6US+KTD3LZry1NqKS0l1jREU5AB0RVFoNl5ncrFF5THF4iXTWyuaCX3UJm3BK01WIODpAzneyF6dR2WfLMhRZx8ie5QOLRaIoCwS+GVO1+qAVfZv+XGGK00eb9dGMOFB/zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvJSHnmsTHGiCOdUoUOFpIgjPoc2PnW9Z4sJHK1tb/I=;
 b=cMOFFlWcFgKuYhAxDs44tS/p7Cbcf40YnnRbomVK6u/qeZ5JeEiI4ijVnuRkYWvS/1LkDgS1fNwegU/GGgK+Cx/1gIdlyX/DQfXnfA+9qwywQ/mjTsGQYrg/wFiqTOAyIINKIB+WX6hpzxqbvPRYYrXfuz4ukMx/ExUECUkmT7s=
Received: from MN2PR11MB3821.namprd11.prod.outlook.com (20.178.253.216) by
 MN2PR11MB4013.namprd11.prod.outlook.com (10.255.181.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 28 Nov 2019 11:45:16 +0000
Received: from MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19]) by MN2PR11MB3821.namprd11.prod.outlook.com
 ([fe80::3c41:2c6c:c65a:6f19%7]) with mapi id 15.20.2474.023; Thu, 28 Nov 2019
 11:45:16 +0000
From:   <Balsundar.P@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, <balsundar.p@microsemi.com>,
        <aacraid@microsemi.com>
Subject: RE: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to
 complete
Thread-Topic: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O
 to complete
Thread-Index: AQHVn43E4UMeXCqcZkONCjITSdrIN6eggyng
Date:   Thu, 28 Nov 2019 11:45:16 +0000
Message-ID: <MN2PR11MB38219640907865F47666CB83F3470@MN2PR11MB3821.namprd11.prod.outlook.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-9-hare@suse.de>
In-Reply-To: <20191120103114.24723-9-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [121.244.27.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e69e10d-f341-4562-d350-08d773f86feb
x-ms-traffictypediagnostic: MN2PR11MB4013:
x-microsoft-antispam-prvs: <MN2PR11MB4013431FCCF433F7A43B9A9DF3470@MN2PR11MB4013.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0235CBE7D0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(376002)(346002)(39860400002)(13464003)(189003)(199004)(55016002)(53546011)(305945005)(74316002)(9686003)(7736002)(33656002)(6506007)(3846002)(6116002)(8936002)(6436002)(102836004)(4326008)(5660300002)(2906002)(14454004)(66066001)(76176011)(229853002)(52536014)(54906003)(110136005)(316002)(71190400001)(71200400001)(11346002)(86362001)(446003)(186003)(25786009)(256004)(5024004)(14444005)(8676002)(66946007)(99286004)(64756008)(81166006)(81156014)(66476007)(76116006)(26005)(66556008)(7696005)(478600001)(6246003)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4013;H:MN2PR11MB3821.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n3Vr+gfp+Wtit+5OtGmDlBbW2ZF7/nxv18mlFCsnLoBRJmGhrquYSqyXVRYRvwGMlctmXHNI0athF9Rw+NtB/LYuUu/eMZEYWYRiAOEIKn6AGEh1a7kL6ntZwPxfvFgbQHssK+wUHUfOYUnZu5okBK3kK9CX66Dm7tWgyIMnFuM75wmcQupJkwaEef187JRZyicXJqWN7AOzvPN9ZdGx8OvUQ8FeV+JqTIVnPPo4SQJKGK+o7dave/DhfZNJQbJIgdsVHoZSLKjhbbgvdXTK3QAaw8Am2t2n3T0WUA5sjYI7p9zYhW7AIazSK+aevE2GOnwfCmjomWEDWQva7Mb8C+ADUBUOKLBr0o+Z6F3iMErLfieg+TvkhjzTKBW+mXTL6eNHjSnZVT2IQhh4OAxz8OIiNglo65dWpeSsUJxrevx5K2bJorkuEkdW1BkdpU86
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e69e10d-f341-4562-d350-08d773f86feb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2019 11:45:16.1974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FNC5zEzhEFvj2VPnTePjWZNiIt1T9clt0H8bJCtgQaKhBdy9QzjNtjTlKzZrW9EwtNUlcJLr4lkAAFc9viDDmtEc3kjRQ6Nhq2Mz1eopH4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NAK

After applying this patch, while IOs were running on physical drive,=20
issued controller reset from management utility.
Observed below call trace. It is from scsi_device_quiesce().

Nov 27 19:24:21 ubuntu kernel: [ 1330.799311] INFO: task arcconf:2386 block=
ed for more than 120 seconds.
Nov 27 19:24:21 ubuntu kernel: [ 1330.799841]       Not tainted 5.4.0-rc1+ =
#2
Nov 27 19:24:21 ubuntu kernel: [ 1330.800235] "echo 0 > /proc/sys/kernel/hu=
ng_task_timeout_secs" disables this message.
Nov 27 19:24:21 ubuntu kernel: [ 1330.800678] arcconf         D    0  2386 =
  2173 0x00004000
Nov 27 19:24:21 ubuntu kernel: [ 1330.800682] Call Trace:
Nov 27 19:24:21 ubuntu kernel: [ 1330.800699]  __schedule+0x291/0x6f0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800703]  schedule+0x33/0xa0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800710]  blk_mq_freeze_queue_wait+0x4=
b/0xb0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800717]  ? wait_woken+0x80/0x80
Nov 27 19:24:21 ubuntu kernel: [ 1330.800721]  blk_mq_freeze_queue+0x1a/0x2=
0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800727]  scsi_device_quiesce+0x5d/0xb=
0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800730]  scsi_host_quiesce+0x41/0x60
Nov 27 19:24:21 ubuntu kernel: [ 1330.800742]  aac_send_shutdown+0x7c/0x180=
 [aacraid]
Nov 27 19:24:21 ubuntu kernel: [ 1330.800749]  aac_reset_adapter+0x29f/0x76=
0 [aacraid]
Nov 27 19:24:21 ubuntu kernel: [ 1330.800757]  ? security_capable+0x3f/0x60
Nov 27 19:24:21 ubuntu kernel: [ 1330.800762]  aac_store_reset_adapter+0x41=
/0x60 [aacraid]
Nov 27 19:24:21 ubuntu kernel: [ 1330.800770]  dev_attr_store+0x17/0x30
Nov 27 19:24:21 ubuntu kernel: [ 1330.800777]  sysfs_kf_write+0x3c/0x50
Nov 27 19:24:21 ubuntu kernel: [ 1330.800779]  kernfs_fop_write+0x125/0x1a0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800785]  __vfs_write+0x1b/0x40
Nov 27 19:24:21 ubuntu kernel: [ 1330.800789]  vfs_write+0xb1/0x1a0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800792]  ksys_write+0xa7/0xe0
Nov 27 19:24:21 ubuntu kernel: [ 1330.800795]  __x64_sys_write+0x1a/0x20
Nov 27 19:24:21 ubuntu kernel: [ 1330.800802]  do_syscall_64+0x57/0x190
Nov 27 19:24:21 ubuntu kernel: [ 1330.800806]  entry_SYSCALL_64_after_hwfra=
me+0x44/0xa9
Nov 27 19:24:21 ubuntu kernel: [ 1330.800810] RIP: 0033:0x7f67cfb7c2b7
Nov 27 19:24:21 ubuntu kernel: [ 1330.800819] Code: Bad RIP value.
Nov 27 19:24:21 ubuntu kernel: [ 1330.800821] RSP: 002b:00007ffeb23ca8c0 EF=
LAGS: 00000293 ORIG_RAX: 0000000000000001
Nov 27 19:24:21 ubuntu kernel: [ 1330.800823] RAX: ffffffffffffffda RBX: 00=
00000000000006 RCX: 00007f67cfb7c2b7
Nov 27 19:24:21 ubuntu kernel: [ 1330.800825] RDX: 0000000000000002 RSI: 00=
007ffeb23ca8f0 RDI: 0000000000000006
Nov 27 19:24:21 ubuntu kernel: [ 1330.800826] RBP: 00007ffeb23ca8f0 R08: 00=
00000000000000 R09: 0000000000000000
Nov 27 19:24:21 ubuntu kernel: [ 1330.800828] R10: 0000000000000000 R11: 00=
00000000000293 R12: 0000000000000002
Nov 27 19:24:21 ubuntu kernel: [ 1330.800829] R13: 00007ffeb23cad20 R14: 00=
007ffeb23cadf0 R15: 00007ffeb23cac60

-----Original Message-----
From: Hannes Reinecke <hare@suse.de>=20
Sent: Wednesday, November 20, 2019 16:01
To: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>; James Bottomley <james.bottomley@hansen=
partnership.com>; linux-scsi@vger.kernel.org; Hannes Reinecke <hare@suse.de=
>; Balsundar P <balsundar.p@microsemi.com>; Adaptec OEM Raid Solutions <aac=
raid@microsemi.com>
Subject: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to =
complete

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

Instead of waiting for all I/O to complete by monitoring the request tags w=
e can as well call scsi_host_quiesce() and drop the hand-crafted helpers.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/commini=
t.c index f75878d773cf..a01dca86eb37 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,38 +272,6 @@ static void aac_queue_init(struct aac_dev * dev, struc=
t aac_queue * q, u32 *mem,
        q->entries =3D qsize;
 }

-static void aac_wait_for_io_completion(struct aac_dev *aac) -{
-       unsigned long flagv =3D 0;
-       int i =3D 0;
-
-       for (i =3D 60; i; --i) {
-               struct scsi_device *dev;
-               struct scsi_cmnd *command;
-               int active =3D 0;
-
-               __shost_for_each_device(dev, aac->scsi_host_ptr) {
-                       spin_lock_irqsave(&dev->list_lock, flagv);
-                       list_for_each_entry(command, &dev->cmd_list, list) =
{
-                               if (command->SCp.phase =3D=3D AAC_OWNER_FIR=
MWARE) {
-                                       active++;
-                                       break;
-                               }
-                       }
-                       spin_unlock_irqrestore(&dev->list_lock, flagv);
-                       if (active)
-                               break;
-
-               }
-               /*
-                * We can exit If all the commands are complete
-                */
-               if (active =3D=3D 0)
-                       break;
-               ssleep(1);
-       }
-}
-
 /**
  *     aac_send_shutdown               -       shutdown an adapter
  *     @dev: Adapter to shutdown
@@ -326,7 +294,7 @@ int aac_send_shutdown(struct aac_dev * dev)
                mutex_unlock(&dev->ioctl_mutex);
        }

-       aac_wait_for_io_completion(dev);
+       scsi_host_quiesce(dev->scsi_host_ptr);

        fibctx =3D aac_fib_alloc(dev);
        if (!fibctx)
@@ -352,6 +320,7 @@ int aac_send_shutdown(struct aac_dev * dev)
        if (aac_is_src(dev) &&
             dev->msi_enabled)
                aac_set_intx_mode(dev);
+       scsi_host_resume(dev->scsi_host_ptr);
        return status;
 }

--
2.16.4

