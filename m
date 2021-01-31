Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556D2C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1C464E25
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhAaHV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:21:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45143 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaHU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612077658; x=1643613658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dlpymSYBp1cCYfRT29OMg0VgLeZNRh8U4pkBwF/Fk9w=;
  b=a2eIwFK7zqhbLhBreYJ71sMQrCWtM369M+pnZDVkWlovYMlEezrLDp2B
   kpO3k2903Z9x/EjN0r3u29mSq4G6W9JrxtUG1zWxqicLKaCHXxXU3ZrmP
   G2QxnsgUYKoz2XXymuoXxN1MmrpPLvfoanNuDL1vC+oBzjavbJ43Voimm
   mpZGx1H/YB43xPxrZuKEahonOS3wDs5NYIJMoSPvF5v/DpOxgJjR+eoRt
   L3sdqKqGdrZm1KreV3wAwHzDNiEgCE6GXFx/X81mYYcXTtve5LRx1JAJY
   60CzaYYFffTZ6lwapJHwp52dJ7Mq5JRZW6ODB6rQ3Lrf+fOiHe7bk9nYk
   g==;
IronPort-SDR: Jq8Ov5V8vJQnwWZAKQmHYds4UvIPwFYMkxXsePE7INj4GBXkZ2uSQZW4796yUGPG4kkBWE0MQ0
 ZHocXCVYoDXPALE85NO+B59mJmkGMr8sXuZ/p5Hx4tmOs9wrOPTqRmvNwS/RQg2HMVEp8bEP0X
 HO1AAe3PozJBXauGJKSyvhUE7wlZZ+xYayPuIebHkfDWK+dDPZsREX6Qo1boRNuKS9kRL/81+Q
 3Q4mjk4Ek6VzZA5sdXkusvgJoq/n0YURwUFAOwy8GoOfB7Q1KDGbL2hqfai9hBi9Ygoq6wF2M/
 ZkE=
X-IronPort-AV: E=Sophos;i="5.79,389,1602572400"; 
   d="scan'208";a="107916283"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2021 00:19:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 31 Jan 2021 00:19:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Sun, 31 Jan 2021 00:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckPA2Kup4Ap/CyyYA6cgE4E6xOUvr+AzDx4967S3GnN2TY/Ws9bqqayJabBNQqcZ+oYXwbNZc2lQUNxjbcTqrAK8N7DddiNNsJ+3DMMI2ONgI2uzWJVvjsVTZYyyT8OZNejwagKbd5QbtDs7os8ObyW7S+Jh/EjZ389g+wlWTQswYmErLQniouJFRfRsNXJvykDQrdsJrrOY5e5wij3iNeWlVtbC5Psd7AuuG2MSkFuawsApO/R7247x8j69CUVF/0nFAucBDw9tWHfdO9fTAYJ3Ci3Q6K0vMy9MDzbOl8tHWkE+LGrD/nARbJbs0z2EJz7uNndQWefAJiUNx2Aumw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnJnVHREgwnIbAgX0goPITWDELCQyZFDRcmQ7makJSg=;
 b=MnNklo0BW55D8CeYZbY7nYgZctVmU5cJ8tCJN74syz0FacuLE+J4HHiSfkN6r96d5adyL+7iJAHcvI9brO1QYFccgAm0XLG7OnLJhVdVWRYLqhtL5KFmDF+yXgvwZWa7xe83GLs3W9j3CdW26Aipi3M52Tbi1+q1wjxSxq8i9bSqxg/S8lpzF1uAhRbKV2ccaCmhZNlgn26t4NmUFSceNEPtWNhRzu7ONHpc5QdDvy93f6MGtBuEftJjSXlsThzhMVGw947bpp/jVvC5vdnwrFm6MB8DET/SLQ8IONT8PGz59dKTYufh7mc3bHWPCNSQN2/gccgK/wzFkoFpIGr73g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnJnVHREgwnIbAgX0goPITWDELCQyZFDRcmQ7makJSg=;
 b=edgZrb3bK4bsgdkYF7f5N5NCkfTj/guQ5HiLg792VxVPPH+9P9HyLeAojvh61ZSkj0K07Pm70itEq3+N6vJkQYC1HWyD96NjgkTlRa0Dr5EHs6sxsi71Bilet8Ab0FoxJqDIXKGo4Nk9H77MSf+2Ke7D2EVfYyUuxylwir9ykL0=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB2957.namprd11.prod.outlook.com (2603:10b6:805:cd::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Sun, 31 Jan
 2021 07:19:06 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::d909:f55f:7b75:8b77]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::d909:f55f:7b75:8b77%7]) with mapi id 15.20.3805.019; Sun, 31 Jan 2021
 07:19:06 +0000
From:   <Viswas.G@microchip.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <akshatzen@google.com>,
        <Ruksar.devadi@microchip.com>, <radha@google.com>,
        <bjashnani@google.com>, <vishakhavc@google.com>,
        <jinpu.wang@cloud.ionos.com>, <Ashokkumar.N@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>
Subject: RE: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
Thread-Topic: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
Thread-Index: AQHW41TyfiU+voXir0O8wZUugFRMoapBeYsQ
Date:   Sun, 31 Jan 2021 07:19:06 +0000
Message-ID: <SN6PR11MB34882CBBF9CF1C6EA2C50EB29DB79@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
In-Reply-To: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [103.153.104.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15792212-e621-429f-0fbf-08d8c5b87ea7
x-ms-traffictypediagnostic: SN6PR11MB2957:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2957D0A5709666350A8AB7329DB79@SN6PR11MB2957.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggLxE08WHsMeuRA39Ev/9AtbIX2vGwr90QKVkx0wJENumGPQFvdDyASnOphVZFJlqZeWgfPaZ0xLrBhaVg0977WcGtpp757pqgZb7C4w9wi5+6uiJu5x56RqntZazYMGimFhvD4u0OwHVvrc+lte71gXjawEdipMM0hRtpjM9UWneKF1j0AZq8hmQwh3ieVVG1kePgH5Xn0lsRN5su8GBTJ3f62ixs7I/KXWmtJvuZqADHoC/5u9VvaGFny0Ej9nMYi6z7b8CYNACrUWFM2fTGWTJzKriIoRlvzBe84ZEpEt5+1eZtyVD56MQG+lJsh/W+E3HtAqmrL6z/ZH77DA0cT1jhC81m5t79y7H4khaxrQKIQJ+tFS99frQwlFt4CZP+SySSLmKDTYN3WgAFP7LRxvJSbgkntVoMgetxUU/8lQ+k54V8yq8cAU1xDvAHuQJXiMbINjTPqHIQREvSxZ6CvXjmr/+vDyerWLHYhkmvuwfaMigXGAxFsIqV8Ta7pZcY17k0d849bTh7f0bPN37iUtw5o5NBBgA4qEfpvdvM8jR/DHU2sIphAi8SGqoqIAD9lRA2YDdBWpCLKJVKR4OEK4uKC4247iF3VTour2rk2fm9p7BEJjVkEyHr8auSIGeatNh3OqEq0xr008Vifi5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39850400004)(53546011)(6506007)(33656002)(26005)(52536014)(30864003)(7416002)(8936002)(5660300002)(186003)(966005)(9686003)(55016002)(83380400001)(6636002)(66476007)(64756008)(66446008)(66556008)(4326008)(76116006)(45080400002)(478600001)(66946007)(921005)(8676002)(2906002)(54906003)(86362001)(316002)(71200400001)(110136005)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?R9TFEd8vCS79oEseiNUsiJBaKNL9NqYvhypDy507CFCnNkSrthmFNWMCd7VP?=
 =?us-ascii?Q?G4k3eKLnxxUMa6QlR2+0ZD+bbvRgPUwyelPnOsFpBqJUYrs/ZZpxlUMvgDnb?=
 =?us-ascii?Q?Fr5F/5rAHvizZg8AkOHI0eOEfbeE60ZEOtkXbbNpLMsk7Y2Mw3hNbvOWGtNr?=
 =?us-ascii?Q?3aVGQ59ipDdI/9JFV6WGpcn+8t/0Wjy1Q3jAN7paUWoTbv3K3j3piqfZfOjd?=
 =?us-ascii?Q?d2OUIPVmJHK3nxnnSiH7xkMXzKykiyw68Ff/azqNVEPuvDCYqfK7racAwC0q?=
 =?us-ascii?Q?etO+K7W0PrvUYsV9i2WmTWEg1VxbHcMFPwg+Qk71Y+A9gmRlXFcRl0xHVhk5?=
 =?us-ascii?Q?afHyD0w3uvdnuft1juMxkwPwNYaw25P/oq7MGT8rLWZxno/OQIM36tVJnfTz?=
 =?us-ascii?Q?7FQvl9MZXX8+PQKH/fcsXbDFUbovxO/iqIhT8mLMtZS+0JfzzGe6sRIlpOkR?=
 =?us-ascii?Q?xI+fAjmLCi5IP6Z+2hC2dEKcwHVKh4kzCKmJycZfSoJU2Tp+cVT7iwQ1u5Vx?=
 =?us-ascii?Q?hXUBbjOE9U8x1WpHOhn5rDw2l//s113DC+dqMTJN++1+yEa4SOhKNJyME+qb?=
 =?us-ascii?Q?BwW/ZxGVMwejOpTRK3jtIVH5Xu2EcYI3c5Gdf1BGpmkCsTxeV2C41C9lYa3v?=
 =?us-ascii?Q?Ul1mxJ+uvDC5U5Wioxx7sYSfMU6XXtdO7fIM8nYng81IRqZjrBMIIZ5JJ/KA?=
 =?us-ascii?Q?FHIaiyTflgQQW4Gd28WjdVEkSMAxurY2XrcaWOnOl84D7F05zAaDYxjcrrD5?=
 =?us-ascii?Q?D1GowEpq6wUP6qDtQ3B5glkUx/OOWOu/We6OE9dTQAttSTDq6IjsVOTeTk+q?=
 =?us-ascii?Q?WoFlKmrpZLn0ye5oDUORju4JEQn9syz2Vz8VTJIW9XfegopwKi/tHeBHbEjC?=
 =?us-ascii?Q?2fl6emJDn2FnYpdRa5covrmZ9gYxeSB9P+eVaQKdDqQbostYpJjMwr6Gmmck?=
 =?us-ascii?Q?N2HMnW2buH/WWUvquJubqsvfXV4I0iDIdw4AgfBFwroUYuIa8/TJtBMxawSA?=
 =?us-ascii?Q?CJ5AT27pqMdDBLcoMshCtfWhaEZm8+XejP+rCwinUWdOIerXuIT0W/2YZF0u?=
 =?us-ascii?Q?NYMY/1P3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15792212-e621-429f-0fbf-08d8c5b87ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:19:06.1477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cuKSsyG4uMDlmqWyRv+pNePukNo3EFt10TRvlBMt+700FLzRUZ6JMuh02niPK9CAu5ZoLhCytW26rE/jarqvtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2957
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Johns.=20

We could see a kernel crash while testing this patch.

[  246.724632] scsi host10: pm80xx
[  248.005258] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[  248.168973] BUG: kernel NULL pointer dereference, address: 0000000000000=
110
[  248.175926] #PF: supervisor read access in kernel mode
[  248.181065] #PF: error_code(0x0000) - not-present page
[  248.186196] PGD 0 P4D 0
[  248.188736] Oops: 0000 [#1] SMP PTI
[  248.192230] CPU: 10 PID: 77 Comm: kworker/u26:2 Kdump: loaded Tainted: G=
 S         OE     5.11.0-rc3 #2
[  248.201614] Hardware name: Supermicro Super Server/X10DRi-LN4+, BIOS 3.1=
 06/08/2018
[  248.209258] Workqueue: events_unbound async_run_entry_fn
[  248.214571] RIP: 0010:pm80xx_chip_sata_req+0x7f/0x5e0 [pm80xx]
[  248.220413] Code: c1 7c c1 e9 03 4d 8b ac 24 80 01 00 00 48 c7 44 24 14 =
00 00 00 00 89 04 24 31 c0 48 c7 84 24 88 00 00 00 00 00 00 00 f3 48 ab <48=
> 8b ba 10 01 00 00 e8 35 35 c6 ef c1 e8 10 89 44 24 04 0f b6 43
[  248.239157] RSP: 0018:ffffb98d834979f0 EFLAGS: 00010046
[  248.244384] RAX: 0000000000000000 RBX: ffff9523c321c000 RCX: 00000000000=
00000
[  248.251516] RDX: 0000000000000000 RSI: ffff952450720048 RDI: ffffb98d834=
97a80
[  248.258641] RBP: ffff9523c7420000 R08: 0000000000000100 R09: 00000000000=
00001
[  248.265764] R10: 0000000000000001 R11: ffff9523c9e40000 R12: ffff9523ca1=
c3600
[  248.272887] R13: ffff9523c9e40000 R14: ffffb98d83497a04 R15: ffff9524507=
20048
[  248.280013] FS:  0000000000000000(0000) GS:ffff9527afd00000(0000) knlGS:=
0000000000000000
[  248.288090] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  248.293826] CR2: 0000000000000110 CR3: 000000029ac10001 CR4: 00000000001=
706e0
[  248.300952] Call Trace:
[  248.303402]  pm8001_task_exec.isra.9+0x2a4/0x460 [pm80xx]
[  248.308805]  sas_ata_qc_issue+0x187/0x220 [libsas]
[  248.313607]  ata_qc_issue+0x107/0x1e0 [libata]
[  248.318069]  ata_exec_internal_sg+0x2c8/0x580 [libata]
[  248.323217]  ata_exec_internal+0x5f/0x90 [libata]
[  248.327931]  ata_dev_read_id+0x306/0x480 [libata]
[  248.332647]  ata_eh_recover+0x7ea/0x12a0 [libata]
[  248.337369]  ? vprintk_emit+0x114/0x220
[  248.341208]  ? sas_ata_sched_eh+0x60/0x60 [libsas]
[  248.346002]  ? sas_ata_prereset+0x50/0x50 [libsas]
[  248.350795]  ? printk+0x58/0x6f
[  248.353941]  ? sas_ata_sched_eh+0x60/0x60 [libsas]
[  248.358733]  ? sas_ata_prereset+0x50/0x50 [libsas]
[  248.363525]  ata_do_eh+0x40/0xb0 [libata]
[  248.367556]  ata_scsi_port_error_handler+0x354/0x770 [libata]
[  248.373318]  async_sas_ata_eh+0x44/0x7b [libsas]
[  248.377938]  async_run_entry_fn+0x39/0x160
[  248.382040]  process_one_work+0x1cb/0x360
[  248.386050]  worker_thread+0x30/0x370
[  248.389706]  ? processe_work+0x360/0x360
[  248.393884]  kthread+0x116/0x130
[  248.397116]  ? kthread_park+0x80/0x80
[  248.400773]  ret_from_fork+0x22/0x30
[  248.404355] Modules linked in: pm80xx(OE) libsas scsi_transport_sas xt_C=
HECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft=
_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf=
_tables nfnetlink tun bridge stp llc rfkill sunrpc vfat fat intel_rapl_msr =
intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kv=
m_intel kvm irqbypass joydev crct10dif_pclmul crc32_pclmul ghash_clmulni_in=
tel ipmi_ssif iTCO_wdt iTCO_vendor_support mei_me rapl i2c_i801 intel_cstat=
e mei acpi_ipmi lpc_ich intel_uncore pcspkr ipmi_si i2c_smbus ipmi_devintf =
ipmi_msghandler acpi_power_meter acpi_pad ioatdma ip_tables xfs libcrc32c s=
r_mod sd_mod cdrom t10_pi sg ast drm_vram_helper drm_kms_helper syscopyarea=
 igb sysfillrect sysimgblt fb_sys_fops drm_ttm_helper ttm ahci libahci dca =
drm crc32c_intel libata i2c_algo_bit wmi dm_mirror dm_region_hash dm_log dm=
_mod fuse
[  248.483431] CR2: 0000000000000110
[    0.000000] Linux version 5.11.0-rc3 (root@localhost.localdomain) (gcc (=
GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), GNU ld version 2.30-79.el8) #2 SMP M=
on Jan 25 23:56:12 IST 2021
[    0.000000] Command line: elfcorehr=3D0x45000000 BOOT_IMAGE=3D(hd14,gpt2=
)/vmlinuz-5.11.0-rc3 ro resume=3D/dev/mapper/rhel-swap rhgb console=3DttyS1=
,115200 loglevel=3D7 irqpoll nr_cpus=3D1 reset_devices cgroup_disable=3Dmem=
ory mce=3Doff numa=3Doff udev.children-max=3D2 panic=3D10 rootflags=3Dnofai=
l acpi_no_memhotplug transparent_hugepage=3Dnever nokaslr novmcoredd hest_d=
isable disable_cpu_apicid=3D0


> -----Original Message-----
> From: John Garry <john.garry@huawei.com>
> Sent: Tuesday, January 5, 2021 4:47 PM
> To: jejb@linux.ibm.com; martin.petersen@oracle.com;
> akshatzen@google.com; Viswas G - I30667 <Viswas.G@microchip.com>;
> Ruksar Devadi - I52327 <Ruksar.devadi@microchip.com>;
> radha@google.com; bjashnani@google.com; vishakhavc@google.com;
> jinpu.wang@cloud.ionos.com; Ashokkumar N - X53535
> <Ashokkumar.N@microchip.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; hare@suse.d=
e;
> kashyap.desai@broadcom.com; ming.lei@redhat.com; John Garry
> <john.garry@huawei.com>
> Subject: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> In commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported
> queues"), support for 80xx chip was improved by enabling multiple HW
> queues.
>=20
> In this, like other SCSI MQ HBA drivers, the HW queues were not exposed t=
o
> upper layer, and instead the driver managed the queues internally.
>=20
> However, this management duplicates blk-mq code. In addition, the HW
> queue management is sub-optimal for a system where the number of CPUs
> exceeds the HW queues - this is because queues are selected in a round-
> robin fashion, when it would be better to make adjacent CPUs submit on th=
e
> same queue. And finally, the affinity of the completion queue interrupts =
is
> not set to mirror the cpu<->HQ queue mapping, which is suboptimal.
>=20
> As such, for when MSIX is supported, expose HW queues to upper layer. Fla=
g
> PCI_IRQ_AFFINITY is set for allocating the MSIX vectors to automatically
> assign affinity for the completion queue interrupts.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
>=20
> ---
> I sent as an RFC/RFT as I have no HW to test. In addition, since HW queue
> #0 is used always for internal commands (like in send_task_abort()), if a=
ll
> CPUs associated with HW queue #0 are offlined, the interrupt for that que=
ue
> will be shutdown, and no CPUs would be available to service any internal
> commands completion. To solve that, we need [0] merged first and switch
> over to use the new API. But we can still test performance in the meantim=
e.
>=20
> I assume someone else is making the change to use the request tag for IO
> tag management.
>=20
> [0] https://lore.kernel.org/linux-scsi/47ba045e-a490-198b-1744-
> 529f97192d3b@suse.de/
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_init.c
> b/drivers/scsi/pm8001/pm8001_init.c
> index ee2de177d0d0..73479803a23e 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -81,6 +81,15 @@ LIST_HEAD(hba_list);
>=20
>  struct workqueue_struct *pm8001_wq;
>=20
> +static int pm8001_map_queues(struct Scsi_Host *shost) {
> +       struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;
> +       struct blk_mq_queue_map *qmap =3D
> +&shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +
> +       return blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 0); }
> +
>  /*
>   * The main structure which LLDD must register for scsi core.
>   */
> @@ -106,6 +115,7 @@ static struct scsi_host_template pm8001_sht =3D {
> #ifdef CONFIG_COMPAT
>         .compat_ioctl           =3D sas_ioctl,
>  #endif
> +       .map_queues                     =3D pm8001_map_queues,
>         .shost_attrs            =3D pm8001_host_attrs,
>         .track_queue_depth      =3D 1,
>  };
> @@ -923,9 +933,8 @@ static int pm8001_configure_phy_settings(struct
> pm8001_hba_info *pm8001_ha)  static u32 pm8001_setup_msix(struct
> pm8001_hba_info *pm8001_ha)  {
>         u32 number_of_intr;
> -       int rc, cpu_online_count;
> +       int rc;
>         unsigned int allocated_irq_vectors;
> -
>         /* SPCv controllers supports 64 msi-x */
>         if (pm8001_ha->chip_id =3D=3D chip_8001) {
>                 number_of_intr =3D 1;
> @@ -933,16 +942,15 @@ static u32 pm8001_setup_msix(struct
> pm8001_hba_info *pm8001_ha)
>                 number_of_intr =3D PM8001_MAX_MSIX_VEC;
>         }
>=20
> -       cpu_online_count =3D num_online_cpus();
> -       number_of_intr =3D min_t(int, cpu_online_count, number_of_intr);
> -       rc =3D pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
> -                       number_of_intr, PCI_IRQ_MSIX);
> +       /* Use default affinity descriptor, which spreads *all* vectors *=
/
> +       rc =3D pci_alloc_irq_vectors(pm8001_ha->pdev, 1,
> +                       number_of_intr, PCI_IRQ_MSIX |
> + PCI_IRQ_AFFINITY);
>         allocated_irq_vectors =3D rc;
>         if (rc < 0)
>                 return rc;
>=20
>         /* Assigns the number of interrupts */
> -       number_of_intr =3D min_t(int, allocated_irq_vectors, number_of_in=
tr);
> +       number_of_intr =3D allocated_irq_vectors;
>         pm8001_ha->number_of_intr =3D number_of_intr;
>=20
>         /* Maximum queue number updating in HBA structure */ @@ -1113,6
> +1121,16 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>         if (rc)
>                 goto err_out_enable;
>=20
> +       if (pm8001_ha->number_of_intr > 1) {
> +               shost->nr_hw_queues =3D pm8001_ha->number_of_intr;
> +               /*
> +                * For now, ensure we're not sent too many commands by se=
tting
> +                * host_tagset. This is also required if we start using r=
equest
> +                * tag.
> +                */
> +               shost->host_tagset =3D 1;
> +       }
> +
>         rc =3D scsi_add_host(shost, &pdev->dev);
>         if (rc)
>                 goto err_out_ha_free;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h
> b/drivers/scsi/pm8001/pm8001_sas.h
> index f2c8cbad3853..74bc6fed693e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -55,6 +55,8 @@
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/sas_ata.h>
>  #include <linux/atomic.h>
> +#include <linux/blk-mq.h>
> +#include <linux/blk-mq-pci.h>
>  #include "pm8001_defs.h"
>=20
>  #define DRV_NAME               "pm80xx"
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
> b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6772b0924dac..31d65ce91e7d 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4299,12 +4299,13 @@ static int pm80xx_chip_ssp_io_req(struct
> pm8001_hba_info *pm8001_ha,
>         struct domain_device *dev =3D task->dev;
>         struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
>         struct ssp_ini_io_start_req ssp_cmd;
> +       struct scsi_cmnd *scmd =3D task->uldd_task;
>         u32 tag =3D ccb->ccb_tag;
>         int ret;
>         u64 phys_addr, start_addr, end_addr;
>         u32 end_addr_high, end_addr_low;
>         struct inbound_queue_table *circularQ;
> -       u32 q_index, cpu_id;
> +       u32 blk_tag, q_index;
>         u32 opc =3D OPC_INB_SSPINIIOSTART;
>         memset(&ssp_cmd, 0, sizeof(ssp_cmd));
>         memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8); @@ -4323,8
> +4324,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info
> *pm8001_ha,
>         ssp_cmd.ssp_iu.efb_prio_attr |=3D (task->ssp_task.task_attr & 7);
>         memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
>                        task->ssp_task.cmd->cmd_len);
> -       cpu_id =3D smp_processor_id();
> -       q_index =3D (u32) (cpu_id) % (pm8001_ha->max_q_num);
> +       blk_tag =3D blk_mq_unique_tag(scmd->request);
> +       q_index =3D blk_mq_unique_tag_to_hwq(blk_tag);
>         circularQ =3D &pm8001_ha->inbnd_q_tbl[q_index];
>=20
>         /* Check if encryption is set */ @@ -4446,9 +4447,11 @@ static in=
t
> pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         struct sas_task *task =3D ccb->task;
>         struct domain_device *dev =3D task->dev;
>         struct pm8001_device *pm8001_ha_dev =3D dev->lldd_dev;
> +       struct ata_queued_cmd *qc =3D task->uldd_task;
> +       struct scsi_cmnd *scmd =3D qc->scsicmd;
>         u32 tag =3D ccb->ccb_tag;
>         int ret;
> -       u32 q_index, cpu_id;
> +       u32 q_index, blk_tag;
>         struct sata_start_req sata_cmd;
>         u32 hdr_tag, ncg_tag =3D 0;
>         u64 phys_addr, start_addr, end_addr; @@ -4459,8 +4462,9 @@ static=
 int
> pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>         unsigned long flags;
>         u32 opc =3D OPC_INB_SATA_HOST_OPSTART;
>         memset(&sata_cmd, 0, sizeof(sata_cmd));
> -       cpu_id =3D smp_processor_id();
> -       q_index =3D (u32) (cpu_id) % (pm8001_ha->max_q_num);
> +
> +       blk_tag =3D blk_mq_unique_tag(scmd->request);

Here the scsi command is NULL.

  if(scmd) {
                blk_tag =3D blk_mq_unique_tag(scmd->request);
                q_index =3D blk_mq_unique_tag_to_hwq(blk_tag);
        } else {
                q_index =3D 0;
  }

With this change, we have started our testing. We will update you the resul=
t soon.

> +       q_index =3D blk_mq_unique_tag_to_hwq(blk_tag);
>         circularQ =3D &pm8001_ha->inbnd_q_tbl[q_index];
>=20
>         if (task->data_dir =3D=3D DMA_NONE) {
> --
> 2.26.2

