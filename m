Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF106C2D0C3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 07:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914A92071E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 07:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chelsious.onmicrosoft.com header.i=@chelsious.onmicrosoft.com header.b="OhDgDr3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfL3HVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 02:21:40 -0500
Received: from mail-dm6nam12on2127.outbound.protection.outlook.com ([40.107.243.127]:43201
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727159AbfL3HVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Dec 2019 02:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcryAhjWBNzGrYsFGzjDhIU611X2jBqhGXux+8KpjM1Blr+WEW7VK8d0yXE+pLpK31qDTkeDwCOZW6cOhiU25+s84LN2Zo48hrseH5KabBEGezfLm2I1c0OHLJzFegLilkpGFtbqu6TENnGiZUskIvXdk0PrU45Mx9PQT94FhoEtBxwCLhNpM1dTEpJCZrApB9p+Lekbe3ZF8FKEVXb1Tg2qc8pi/1z2rVJCrjzBg4rHW7RbPexsgbm3/N1vw+WR7BVpQw5wMono5KbbbNrGBZYjZzNiEEb8NcU3KmCofQxE+7HD7j7A7e33JldI8ZNdKWKZecWavWm26aWRBr0w4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns/2Ye7WeRkI6rrVorvOdHLdMBHQRTYcldXd0YilvQc=;
 b=BEHTEZjnRCYrUP98RbRyP9QWeRWnFbq42H6yu6WFmjjlP1jyRrBfnQpTwCsFw2a4UQUTVQ+xmvczHMmHZtRmUOQI7Xq2+/USelItEtVFR87g1b2sntFXzYm6K+fMdtt7zCu+6Va+0IXlhzV9d9Hda3Pxlxm26wD7+cPlHZL5km6GZ5zuSVbusFn0nUZPPQPQismeAEEC9nU3Vvy3MxskE+3AGQoI9rsjQSfsz97pfrjYey7PLzUNn3JzSGBtjfgBGZ9J4bgg+ojxdUKp2w6p6P2QxdwUZyrf4w8yvC1LuxbRen+dFnR9Xcf9C89rAE8VFqX1d3BOLhRpAseSDVir1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=chelsio.com; dmarc=pass action=none header.from=chelsio.com;
 dkim=pass header.d=chelsio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=chelsious.onmicrosoft.com; s=selector2-chelsious-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns/2Ye7WeRkI6rrVorvOdHLdMBHQRTYcldXd0YilvQc=;
 b=OhDgDr3dAY/eN5q0cVDM3C0NZFpa51mwCVIZh7aKTHqESvX1QQiwCe2ZMb5rcPp4JMUTugEZe3AXhWvK2ASEHsKidNdHjGxNTLEKa3fhVQxP3xwXzokv/BSzDordrl74HgLNe4zdOQoAzXiulaITVgB1mhHfXNwZnv36+5qot34=
Received: from BYAPR12MB3080.namprd12.prod.outlook.com (20.178.55.15) by
 BYAPR12MB3494.namprd12.prod.outlook.com (20.178.196.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Mon, 30 Dec 2019 07:21:34 +0000
Received: from BYAPR12MB3080.namprd12.prod.outlook.com
 ([fe80::4881:cf01:2a7e:9da8]) by BYAPR12MB3080.namprd12.prod.outlook.com
 ([fe80::4881:cf01:2a7e:9da8%3]) with mapi id 15.20.2581.007; Mon, 30 Dec 2019
 07:21:34 +0000
From:   Rahul Kundu <rahul.kundu@chelsio.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     Potnuri Bharat Teja <bharat@chelsio.com>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>
Subject: Trace seen on target during iSER login
Thread-Topic: Trace seen on target during iSER login
Thread-Index: AdW+4Nv2D5BTjdawTFWO8/mBqdBBDw==
Date:   Mon, 30 Dec 2019 07:21:34 +0000
Message-ID: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rahul.kundu@chelsio.com; 
x-originating-ip: [182.74.59.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c305a99-9bfc-4016-c856-08d78cf8e6c6
x-ms-traffictypediagnostic: BYAPR12MB3494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3494342F69E4AF6DA1AF6739EF270@BYAPR12MB3494.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(26005)(186003)(64756008)(66556008)(66476007)(76116006)(44832011)(2906002)(107886003)(71200400001)(66946007)(4326008)(33656002)(66446008)(110136005)(45080400002)(508600001)(86362001)(54906003)(5660300002)(9686003)(8936002)(55016002)(52536014)(8676002)(6506007)(81156014)(7696005)(316002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3494;H:BYAPR12MB3080.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: chelsio.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DOitit4YsuA4Cdx3IBohEWwtJ6OF1v/M/KtyZ7R5HO0RUPC4K03gHCqES9v7y5l2st9bZp6IESHBsQUWuWwJjDi5dIdIe5b2ncEOb6ojd2Nwa2NGkH2JzbYS1j19oeklTQ3OITpM85yJTmasdMmforgyTNOTp1/s4ivshdyM3pB4WB2cNXmQlU8isvBSlWrWpIPZBwGBep14aoz8EZFaFp0S9y+cU7YZPW/3BXSgnvA6oFvLhQfiTygifgC26QAYGky/Fal3LX8hPWuNeystjJnngNfFOJDIFexUfn69lwN59t45HaFErqcPp+SMb0rci7qVsJbT+Uu0SaKB0L4HZR7hHu1jFHAc9S1bYqz03wHTo7qssAVj+kdryziqeI3iexbTcp4Kd08B+PRoky0UmkxKYaL6sHHaUCWfO6iT4tlNnfZQcPXNKkeyv1Rj5esH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: chelsio.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c305a99-9bfc-4016-c856-08d78cf8e6c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2019 07:21:34.5900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 065db76d-a7ae-4c60-b78a-501e8fc17095
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpIWH06QeiLahNEQpAJ56pvsD9yIyT3aJYvXJNS+SqBPLltLV7FiJUPPpXELlj04slUE0AbwJ5kWk6r2MM69Bfn1aONX3y7756ou0aIh47Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3494
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I am trying to setup and run iSER with tot linux kernel installed(5.5.0-rc3=
) on both target and initiator.
Followed below steps:
        1. Created 1 targets having ramdisk LUN of 1GB size.
        2. Did discovery and login from the Initiator

Observed that everything worked fine at initiator and successfully logins.
But, after login, below warning was seen at Target:

target dmesg
-------------------
[  237.850090] Rounding down aligned max_sectors from 4294967295 to 4294967=
288=20
[  244.517357] iwpm_register_pid_cb: Down level iwpmd/pid 3060.  Continuing=
...
[  324.876992] ------------[ cut here ]------------=20
[  324.877024] percpu_ref_kill_and_confirm called more than once on target_=
release_sess_cmd_refcnt [target_core_mod]!
[  324.877047] WARNING: CPU: 0 PID: 3167 at lib/percpu-refcount.c:346 percp=
u_ref_kill_and_confirm+0x7e/0xa0
[  324.877048] Modules linked in: target_core_user uio target_core_pscsi ta=
rget_core_file target_core_iblock rpcrdma ib_isert iscsi_target_mod ib_iser=
 libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transpor=
t_srp ib_ipoib rdma_ucm dm_mirror dm_region_hash ib_umad dm_log iw_cxgb4 ib=
_uverbs snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio intel_pow=
erclamp snd_hda_intel rdma_cm coretemp snd_intel_dspcfg iw_cm snd_hda_codec=
 ib_cm ib_core snd_hda_core kvm snd_hwdep snd_seq libcxgb snd_seq_device sn=
d_pcm irqbypass ipmi_si iTCO_wdt snd_timer iTCO_vendor_support gpio_ich ipm=
i_devintf pcspkr snd ipmi_msghandler sg ioatdma soundcore i2c_i801 lpc_ich =
i7core_edac acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_mul=
tipath dm_mod ip_tables ext4 mbcache jbd2 sr_mod cdrom sd_mod mgag200 drm_k=
ms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_vram_helper drm=
_ttm_helper ttm drm ata_generic pata_acpi cxgb4 igb ata_piix pata_jmicron f=
irewire_ohci libata=20
[  324.877096]  firewire_core dca crc32c_intel serio_raw i2c_algo_bit i2c_c=
ore ptp crc_itu_t pps_core=20
[  324.877104] CPU: 0 PID: 3167 Comm: iscsi_ttx Kdump: loaded Not tainted 5=
.5.0-rc3+ #45
[  324.877106] Hardware name: Supermicro X8DAH/X8DAH, BIOS 2.1        12/30=
/2011
[  324.877109] RIP: 0010:percpu_ref_kill_and_confirm+0x7e/0xa0
[  324.877114] Code: 00 80 3d bc 04 1e 01 00 75 c4 48 8b 53 10 48 c7 c6 80 =
fb 0a a4 48 c7 c7 78 ae 33 a4 31 c0 c6 05 9f 04 1e 01 01 e8 72 47 ca ff <0f=
> 0b 48 8b 53 08 eb 9c f0 48 83 2b 01 74 02 eb b3 48 89 df ff 53=20
[  324.877115] RSP: 0018:ffffa1780d14bdf0 EFLAGS: 00010086=20
[  324.877116] RAX: 0000000000000000 RBX: ffff947e1eb17430 RCX: 00000000000=
00000=20
[  324.877116] RDX: 0000000000000006 RSI: ffffffffa4e49c06 RDI: 00000000000=
00046=20
[  324.877117] RBP: 0000000000000246 R08: ffffffffa4e49ba0 R09: ffffffeb3fc=
d255c=20
[  324.877117] R10: 0000000000000c5f R11: 0000000000000373 R12: 00000000000=
00000=20
[  324.877118] R13: ffff947e10d12100 R14: ffffa1780d14be38 R15: ffffa1780d1=
4bc58=20
[  324.877119] FS:  0000000000000000(0000) GS:ffff94661fa00000(0000) knlGS:=
0000000000000000=20
[  324.877119] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
[  324.877120] CR2: 00007fe88152e140 CR3: 0000002e8b00a003 CR4: 00000000000=
206f0=20
[  324.877121] Call Trace:
[  324.877137]  iscsit_close_connection+0x272/0x8d0 [iscsi_target_mod]
[  324.877141]  ? __schedule+0x2d2/0x6c0
[  324.877146]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_ta=
rget_mod]
[  324.877151]  iscsi_target_tx_thread+0x153/0x1f0 [iscsi_target_mod]
[  324.877155]  ? remove_wait_queue+0x60/0x60
[  324.877159]  kthread+0xf5/0x130
[  324.877164]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[  324.877165]  ? kthread_bind+0x10/0x10
[  324.877168]  ret_from_fork+0x1f/0x30
[  324.877170] ---[ end trace bcc25f7aa321d702 ]---

The above error is seen from kernel 5.4.0-rc1 onwards.
Bisect points to the following commit:
---------------------------------------------------------------------------=
-------------------------------------------------
e9d3009cb936bd0faf0719f68d98ad8afb1e613b is the first bad commit commit e9d=
3009cb936bd0faf0719f68d98ad8afb1e613b
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Wed Nov 13 14:05:08 2019 -0800
    scsi: target: iscsi: Wait for all commands to finish before freeing a s=
ession
---------------------------------------------------------------------------=
-------------------------------------------------

iscsit_close_connection() already calls target_sess_cmd_list_set_waiting() =
and
target_wait_for_sess_cmds() functions through iscsit_wait_conn() function.

Below is the patch diff which removes redundant function calls added by the=
 above commit, but I am not sure whether this is the ideal fix:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 7251a87bb576..503a76e9cc62 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4234,8 +4234,6 @@ int iscsit_close_connection(
         * must wait until they have completed.
         */
        iscsit_check_conn_usage_count(conn);
-       target_sess_cmd_list_set_waiting(sess->se_sess);
-       target_wait_for_sess_cmds(sess->se_sess);

        ahash_request_free(conn->conn_tx_hash);
        if (conn->conn_rx_hash) {

---
Please kindly let me know your thoughts on this subject. Any help appreciat=
ed.

Thanks,
Rahul Kundu=
