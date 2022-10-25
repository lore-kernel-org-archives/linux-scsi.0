Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE43C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 12:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiJYMwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiJYMv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 08:51:57 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 05:49:03 PDT
Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDCF18F929
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1666702143; x=1698238143;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=tvARzfp71ZAdMIZJHeOjZUoy8ZHz2flPjPJ8kBo870k=;
  b=tZ0Lsqsvr+ysmeTbvrcOpxNj3EGavTplzbj14g66A1DQV+exFsAfzIGY
   LU/0oM1nkMc81gLxeYng+Mr6Zz8RkeLyb3A+0he1GL+lXWgetFl0fO/Ra
   H9qPTHU5a0g+cwcsrpgn8r/wgwl9v/GvntSdWlAfFpc5M9UxoNNRwuv7i
   Tu/HoF0acmYSU4Sf2YJQXYipc0dHZ0wjmtGLmQucGiF/Xi0DctMugFp2q
   bto4ThFdzL/Tqdnr6c/qgMKCTnXLINBrbwisHcV+QF4SdxfQCE2kAhJ+w
   drRBDW0itNRDW4VTW43XAiGEMD1jHeGkv/8IIuRWswtUFoxLQZ5KfaUnF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="68487501"
X-IronPort-AV: E=Sophos;i="5.95,212,1661785200"; 
   d="scan'208";a="68487501"
Received: from mail-fr2deu01lp2171.outbound.protection.outlook.com (HELO DEU01-FR2-obe.outbound.protection.outlook.com) ([104.47.11.171])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 21:47:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/vfnO3i1SG2zSWBYQo3QrzU/bYehdpNQDp+AnZfYRzbsLCMnAgRd6MBSlx+ELL6JhdLfdFwY2OdM+l8DRzCy3o/j32UCOvhBeHxb3q+Wae8uVqwX5cnQ3zMYl9HP7AhNedrDqsPH5VAD3IOaHO4g99NbRD2Vqck+WAQB8FOztJJ3PGPoOvRaCcYPUV0b27nInYYNxLIIuwFQvMxjUD0NqX7h4obq+ddaixNamT+Rv74LJE+EwkucX0X7+8AE8/zvU6S/ghD93T6rkNBiGyyd1CkzJXv3XQhb/WvctMxnA0jQPeB/IZBxuuAoDOlHeOtUgeIsWbMjeibhauPmLk1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnEBAv/yGSKJ9WhrrsPkzt0Uvx7FLtOEf4/+fhKu1ps=;
 b=iggWzKIujzKxqnTTmWOUvdv/WpJVAkK4SiTfgG5yxx3qqAzYqRasr7AkHpMCyaeVImOutAaEhmjo2Ei5fz/k+oAQ5M7DZohf4iDZhpt+aWiyXWij/opMxCf64kNya9GVN7Qx8JakGfYzyUbKvQTb0AxtVXkQcPfXe2dNa6ghQMCbAFi430ZscL+C/djexCnJhbDv3JMxlL1pxKf/vMKxtyxISvvQsklQ0TW6H8lySfFB126bZXu60DUoTMBqXabwhF2o1L0LZdGnTKPeRqRyVE77h2n4rfNvb+MeVCiXScgolju43s74VYjiPcuKKc3v4fuRU/4j9PANekL5uZhkGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:29::6) by
 FR2P281MB3118.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:61::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Tue, 25 Oct 2022 12:47:17 +0000
Received: from FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
 ([fe80::57f2:6845:67a5:c492]) by FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
 ([fe80::57f2:6845:67a5:c492%6]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 12:47:17 +0000
From:   "Dietmar Hahn (Fujitsu)" <dietmar.hahn@fujitsu.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [BUG] lpfc: kernel NULL pointer dereference
Thread-Topic: [BUG] lpfc: kernel NULL pointer dereference
Thread-Index: Adjob4K7Zd/FVp3IS5i8J6dm3vreCQ==
Date:   Tue, 25 Oct 2022 12:47:16 +0000
Message-ID: <FR0P281MB21234EA6C74C286904E682CB94319@FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=2e575510-1e3d-4360-9f5c-cc359c5b7383;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED???;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2022-10-25T12:39:19Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR0P281MB2123:EE_|FR2P281MB3118:EE_
x-ms-office365-filtering-correlation-id: 032a8b41-0fe9-4efd-23c1-08dab6870c5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U+nvt8x3DxlF32cGP62/RDqUsyOEiBcoksn6gPshP8KiCLis2M1Z+NuIZr8xR6TKhWdeqo/uwgJKny1JQAvxxtz9c1gEwZ/q7fYH9m07TjvdbaDGCeTE9VpxlNImqL8Lzf6i30qd9rea03RTSHgYjmRb88S4fG4+b1b/MUFRTIWka+opFpI5H75YeCyKZZHMsbzDAjmcR/CeiwZN8/fvj+Q7hwo8V8ECGEm78TTdD1/SIPxHH0aZLHW3F9v5Pne5GCjio/apnmCHyIVHS6lvSFaJD9wzIznHhushxw2Kf5T9GNw+X/sCpqrOVJFTvtvVkc1oHrf4lhJww5JThSnqquuklfxZtMVXtYVmUsyvQGzGQ8Qa/+JhHxx1Be09dkwg10HFiJ6DgYT9Y9DEYONVs6u9H3i/c59ZjzHUAX9wXY9Z64SLWMGye2o7rVSzmOJZGCVKmSKp493KM8gITafKTofrQx1337ba2Ltz1HTdkYyspuAeMAJ7kKEtKwjyNHaYRUx+KH7l7QSxamrRuzd8aSejA7UmpQxuy1+5Buu+9wDJJNg4avK9LuUyzvhB2AQAbqZr8SSffkL/ZEEogzMOBfYd86/iYRuNYMMHrfNbqaJQcMaL01reDuK4sVUc3O9MiqhEdvB2/LkJMtpmIF6/mY9qTjbUosK+EMCzKI+3oN2sEzZFKIu8YZ8xTL5ole6oM4fCtPdEOqr1WNCLPAH7CHp7Nu3cIgpeMclK/DPmp5veEEg9ioilF8Id7eFC9k5BvQU6Vy9Nh4dJOw46du018w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199015)(55016003)(5660300002)(33656002)(83380400001)(7696005)(6506007)(38100700002)(26005)(2906002)(122000001)(86362001)(82960400001)(9686003)(38070700005)(71200400001)(478600001)(186003)(66476007)(66556008)(66446008)(8676002)(4326008)(64756008)(66946007)(76116006)(110136005)(8936002)(52536014)(41300700001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?X8692CCtENDAf8SN5iXJOksGA9CsDbtni1+eN64oXJubXtlQmepzWTUJRr?=
 =?iso-8859-1?Q?pD1taf+m1eZyao7Rc9109wnYGNzPyVBm++r/wabPJkfzui6RKB6lwS2BUw?=
 =?iso-8859-1?Q?fUfCojdUkEbMWRl/Ep83ev1qZskFtODbG0W6gULUcvu5849D7i6emM0us4?=
 =?iso-8859-1?Q?lPKEDVqnyJNr6nZp/FIBQr3nZn6IWFxVyQySkwPTGb34j+bXANLgY+gm6R?=
 =?iso-8859-1?Q?8wfH4rODDxTzDfWWXGi6sAwiOdZ47nJiM+LRNSk7AyWKx+CsamjJ3WrWmw?=
 =?iso-8859-1?Q?wLqEujlPqfgF3V7Bf29cXKYp+FKsjHe7+s9d3mIdyxj1NJC3wSHETKW559?=
 =?iso-8859-1?Q?OkxOEUtFFilQjlFV2FI+z4Mrchd0PhoB+kfwGseF9ortCj4HwakrmSAW7D?=
 =?iso-8859-1?Q?p+Ar6M8xM7PU+peowygAyW1bZAm+x10JRzrdmu641+zS6mc4BotbHFSCJE?=
 =?iso-8859-1?Q?Yk+CvIbEcs3MzwquBgIuOdv2y0Y0GnvZMcrC/Xhnhd02RPm22cU/5OF9zi?=
 =?iso-8859-1?Q?hMNw4rlwI0/oCJ7gFFBT9ieJ6Jtaiy4aPWxZMwtVV9cN+nfBKhYmGVOS2O?=
 =?iso-8859-1?Q?Ebuu7booSzZJxT7f7f29A2av+GQIdbv4lEHZsOIBPt1V3KNCa4CDvECva6?=
 =?iso-8859-1?Q?OzdPl8SBVN74yCXUMvk9v/haDAQbWv1dirUxuI5SXNkveoBqLo0M1zkC9i?=
 =?iso-8859-1?Q?zfVaftbklC+tyHzZnQFxcR+jBrPxCSQpdtcHXO2y41mtwzC2ucSi1KibAU?=
 =?iso-8859-1?Q?fDDrRTodnxq/biiKq3gTo4+0/WPZ+5l05LTKANBhM6Ig0tRbZpt8IZZrcJ?=
 =?iso-8859-1?Q?8cbFzAp+OfPRLuD7xpvJm5Vy6Cdm580EhakmtERBHVR31uYCLLA2JBzJue?=
 =?iso-8859-1?Q?yUBj2snHdVnu86D5y4xEE2DlYKLevJQ2LGpYOQyNuxzxesCZJK+mnqt3Nl?=
 =?iso-8859-1?Q?woa+d4riO0uAiol3K+HMT6VMJfJjd/HWgdpzTofl/zDZNiUA2qn17sCyOo?=
 =?iso-8859-1?Q?1a4d6tbyGyYJpOL9ubUr/4h8EGs+h6RSbmDOLlCMs1SQ00pLLqFbVx8w40?=
 =?iso-8859-1?Q?gpfGrMxXhiXAuK5bGX75hMzLuEcVCOkpoc3T1h2OJIHOnA7CO9btgfPfgq?=
 =?iso-8859-1?Q?RjJ2qZxMPgxMbGETveIW8ZCflOj9vxEUlN67YdlB0kQiziaHfbZEFRDYjD?=
 =?iso-8859-1?Q?5Jv9pVJSJUrfjHQYwGXH6SZM2ZGLk1ab2rAf8Y4EDF14uW3b9k547prULu?=
 =?iso-8859-1?Q?9EwIGLGKBFas83aPXZc3R8kDZsPjAOeXfauonLEvN3VZlXJpZ4YdAfZVdP?=
 =?iso-8859-1?Q?jbU/J2s1vxknFtub7LJ3rHsXyFQE3eb3bseZr2AjdmQDW196fVb1nh4ocS?=
 =?iso-8859-1?Q?HCas+qJwEbxQbOT6xaK+sDS4z94EGQwLuIx0FV0gu7A5HgVx+kR7bEQNHW?=
 =?iso-8859-1?Q?c8cjg4OiS4hXUStCeC8ojFNeNBs8E4+k42jnfpzqHJxgbH8iDCyXRDJ5BC?=
 =?iso-8859-1?Q?4DT6Nuwe9S+X3PeReDDjY1UORsdkwnvqlU4hevj76fkwb4BI/9N9ycGSmu?=
 =?iso-8859-1?Q?IsmouYgS9rTfYd4XPFpYI3urV93DisB2URLmy+WYyWsxXwGzPBMxxAghWJ?=
 =?iso-8859-1?Q?0gqX4TH54sR7ThKoSQJthPWwXYakajZtvCiiqXstonuf+f/+KjqYWnjQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 032a8b41-0fe9-4efd-23c1-08dab6870c5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 12:47:16.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ev3bGaO4/oN7R00I0vkPIwRmtgSuZX32i4r2uZpV7hWGnRQjVZW5tLKyXyhPdDwYJwkGwMuIWnLX3y1OHQjBEJGwpIpgQFOzk2TVZqErLRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB3118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

we have almost every day system crashes because of a slightly defective per=
iphery.

[21004.663296] lpfc 0000:65:00.1: 7:(0):2858 FLOGI failure Status:x3/x31420=
002 TMO:x14 Data x11140820 x0
[21011.733417]  rport-18:0-1: blocked FC remote port time out: removing rpo=
rt
[21011.733424] **** lpfc_rport_invalid: Null vport on ndlp xffff8e25e1a4a00=
0, DID xfffffe rport xffff8e061354b000 SID xffffffff
[21011.733432] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[21011.733438] #PF: supervisor read access in kernel mode
[21011.733441] #PF: error_code(0x0000) - not-present page
[21011.733444] PGD 0 P4D 0=20
[21011.733448] Oops: 0000 [#1] PREEMPT SMP NOPTI
[21011.733453] CPU: 47 PID: 1303 Comm: kworker/47:4 Kdump: loaded Not taint=
ed 5.14.21-150400.24.21-default #1 SLE15-SP4 7550826c4c7e8c258239e300508e0c=
8b2a69bad2
[21011.733460] Hardware name: FUJITSU SE SERVER SU320 M1/D3892-A1, BIOS V1.=
0.0.0 R1.13.0 for D3892-A1x            11/25/2021
[21011.733463] Workqueue: fc_wq_18 fc_rport_final_delete [scsi_transport_fc=
]
[21011.733475] RIP: 0010:lpfc_dev_loss_tmo_callbk+0x50/0x4d0 [lpfc]
[21011.733497] Code: 00 00 00 0f b7 8b ac 00 00 00 48 c7 c2 68 82 93 c0 44 =
8b 83 98 00 00 00 44 8b 8b 94 00 00 00 48 89 fd be 80 00 00 00 4c 89 e7 <4d=
> 8b 2c 24 e8 c7 8e 04 00 4c 8b 83 f8 00 00 00 41 8b 90 e0 02 00
[21011.733502] RSP: 0018:ffff9ecb604bbe38 EFLAGS: 00010286
[21011.733505] RAX: ffff8e061354b510 RBX: ffff8e25e1a4a000 RCX: 00000000000=
0ffff
[21011.733508] RDX: ffffffffc0938268 RSI: 0000000000000080 RDI: 00000000000=
00000
[21011.733511] RBP: ffff8e061354b000 R08: 0000000000fffffe R09: 00000000000=
00000
[21011.733513] R10: ffff9ecb4c923d80 R11: ffff9ecb604bbc80 R12: 00000000000=
00000
[21011.733515] R13: ffff8e061354b000 R14: ffff8e4505b21000 R15: ffff8e45039=
44e40
[21011.733518] FS:  0000000000000000(0000) GS:ffff8e647fdc0000(0000) knlGS:=
0000000000000000
[21011.733521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[21011.733523] CR2: 0000000000000000 CR3: 0000002a97010001 CR4: 00000000007=
706e0
[21011.733526] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[21011.733528] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[21011.733530] PKRU: 55555554
[21011.733532] Call Trace:
[21011.733537]  <TASK>
[21011.733541]  fc_rport_final_delete+0xec/0x1c0 [scsi_transport_fc 3bc651e=
7b65441f21e0602fb7ca4ac10797e0b7e]
[21011.733550]  process_one_work+0x264/0x440
[21011.733566]  worker_thread+0x2d/0x3d0
[21011.733571]  ? process_one_work+0x440/0x440
[21011.733574]  kthread+0x154/0x180
[21011.733580]  ? set_kthread_struct+0x50/0x50
[21011.733584]  ret_from_fork+0x1f/0x30
[21011.733591]  </TASK>

It's a kernel 5.14.21-150400.24.21-default from SuSE but with
lpfc_version.h: #define LPFC_DRIVER_VERSION "14.2.0.6"

The cause is that struct fc_rport *rport->dd_data->pnode->vport =3D=3D 0x0.

In fc_rport_final_delete():
 -> lpfc_terminate_rport_io(rport)
    -> lpfc_rport_invalid()
       -> if (!ndlp->vport) {
                pr_err("**** %s: Null vport on ndlp ...

But later in lpfc_dev_loss_tmo_callbk():
   vport =3D ndlp->vport;
   phba  =3D vport->phba;  -> Panic!

Not being familiar with the code, I'm not sure if a simple check would do t=
he trick:

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbad=
isc.c
index d38ebd7281b9..5c5684909d24 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -160,6 +160,9 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
        if (!ndlp)
                return;
=20
+       if (!ndlp->vport)
+               return;
+
        vport =3D ndlp->vport;
        phba  =3D vport->phba;
=20
Thanks.
Dietmar.

