Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A36DC04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 20:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiG1UKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 16:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiG1UKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 16:10:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA3F6565
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 13:10:12 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SIAt24014250
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 13:10:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=/+gmY0OLDN4IrjiRU06aEBnIZU1xs8PZUXS9tYmbdog=;
 b=HpiRtZBM/DksH71zR46WVDpeFxPZlWowrtRVdWaxpW/TZRKZcipcMLpDhQ89B/ZF2xh1
 lFONXRCPdSyLgOAPGg7vOgb/b/4B9WZ84AlKo6FzYAAcVmLSQnJgRNCuOjtJSwtdlD3Z
 nsZIcICbNSkB+iMfGwi3U0WS73jAzu6TOfQ= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hks0putff-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 13:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q83NhK/bw6mE+0mp1Dy2zn4oM/C1ZVhr9RXsWWOjMsqIS4BGqSJoNlSkmPCrpEHThM7hcycX9ENGlZnUhUV20Y+ItuaK2VbIeWgKv/mD3tJ3zKof3jJ8pLiHisTmLokMYdpVe+yFO6xys+TA9qsG62Ym8npk1jwzTIlMB/p7RKlgDttfStfcVxOReHuItLqvHjGHToasjSOjXlpMFkiY6fad60b9aR8FP89PJpPfjuuxcZlU/4GccFThktp+QylkSLc+vZ6yWvXTRLerivqmvZtBxwj7wwXMnYn6bwG4SaBWfJ2BhLoFs88JtJVXlFgHBgvnRe7/DU9lDGNdREAlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+gmY0OLDN4IrjiRU06aEBnIZU1xs8PZUXS9tYmbdog=;
 b=KcavnollopiHcbfikGbFYjt5JOwldk2/0XgUC9j/L/1m3GPddadrO4E2zI5JJbpIxS4tDdgzFhAMdhVJVSxbww2iyxT6kqyET5CakhvVAAZZLKXPdf47jHl9PTG+yLU4axLiN7m+bqSjLQvbjhoseBUc2R2+NYHf+Dy1FDCOsUsRyvbbwYi07xOqzD4PxAXocYm6PE0FIwLlpvMzVPeBi+obGB6l6OqUxqSZDqnhW100z6VWLATHSGvrAMQ+llGpVyH8P0//ff7CTd8/ENuQHC1UXnCH+fFhwH/Bw7CZcGslE0vx3NTUUJJ3wQtB/OcEQAPJXoWCYkLB3PKkXmshzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO6PR15MB4145.namprd15.prod.outlook.com (2603:10b6:5:34a::13)
 by BN6PR15MB1201.namprd15.prod.outlook.com (2603:10b6:404:ef::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 20:10:08 +0000
Received: from CO6PR15MB4145.namprd15.prod.outlook.com
 ([fe80::6c58:8ba0:d255:9cd0]) by CO6PR15MB4145.namprd15.prod.outlook.com
 ([fe80::6c58:8ba0:d255:9cd0%8]) with mapi id 15.20.5482.010; Thu, 28 Jul 2022
 20:10:08 +0000
From:   Michal Grzedzicki <mge@fb.com>
To:     John Garry <john.garry@huawei.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [BUG] pm80xx crashing during SATA discovery
Thread-Topic: [BUG] pm80xx crashing during SATA discovery
Thread-Index: AQHYoqcaYOyAlL21a0OcWQIBQZLooq2UJBOAgAASrQA=
Date:   Thu, 28 Jul 2022 20:10:08 +0000
Message-ID: <E4CD9F54-21CA-4A0F-8835-2C3AA999DF48@fb.com>
References: <658BED74-1C07-44E8-B1FA-2FBB5E3F5DF2@fb.com>
 <64826481-8b07-d81c-2482-ce7edc5b377a@huawei.com>
In-Reply-To: <64826481-8b07-d81c-2482-ce7edc5b377a@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a77f196-2d73-439f-7098-08da70d52b7e
x-ms-traffictypediagnostic: BN6PR15MB1201:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R37kZZK/ZDWjECINfLC+cDbD9UridHTjdyN/bgqqbBeo7o6WATIw2ZCGl0zC1w6pXBsiR4smgts2I5o3DLYNWVFWWg0WkvCTYhZZxPEts8pT/x4n15y30KomzqWn9OQHDeKNNLKfGENpGUSpytrCCzO9ut1yJlzInwcJTqrWd+RH9DFVlK1jwgocM6Ek/6bDdTtpZ/eI8/1qUpUaUY5sfMWPek/C45gS3MgVk17PwbAmBQ0lp9iffGR6KoHBpBGW/xybjr0TK7O4ntqRclPm+k1TVsveW+Uc2lX020A273ssEuiVYXVZ93ks3UJQ7YKoeiQ/yoQF/OSXLZfn5d3Ob6IpcS5vLKSj1z55fK/P2uf8qnPmdlUUKqU5bywCIBNSe9e0k1F0UqYdn5R9Uf1PfQ3B1HGjrKuBdoZaXUjjPs1jXI7Lgy0Enhzm22bUsTuv5tfYRud6ruenVjsIud4joPiJjuKR1LmsHYuo9LyhmQRcOwU9CW8epUdvY1cm0VknbMfOHfjW4y/eDT7XXvtt0mmzfoVBY+ubwhHljDXCTsWpWJYnfMXad3G3wT3czmpfWBVWKm0e+KwPegtVcQTwm5B6CpSp537pv0ru1lZ+mjtErW+YN7sPO/LsTHk+Jol6rQhMlr1XRkmeD9YkshKMZaeJKaxvEbyQC73sTO74QzfobanzlM68cCNi3E/NF9z1SO2avflpySvIg7UHjPMllNn5TraYU1gqk0bkMsEiBdwRcMqNeTXA7CDeH/hINAtlzmNpPGpdpjDYwNmKTZ8cpU+O78q5WNQHEyRjf6j3u+2Otzk2TK15Udlh85IYbVEa2B52+YYnRb+Pbj/ompU48U4AtU+UjVLlQv+d8dEur1ynzuc29QxbcHiXMeOFcyfd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR15MB4145.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(122000001)(36756003)(33656002)(38070700005)(38100700002)(2616005)(186003)(6512007)(83380400001)(86362001)(41300700001)(45080400002)(478600001)(6486002)(6506007)(66946007)(6916009)(91956017)(54906003)(76116006)(53546011)(316002)(64756008)(71200400001)(66476007)(4326008)(5660300002)(66446008)(8676002)(8936002)(30864003)(66556008)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kkhvsb04VaIZ15yAqSQM2v95f5CC6PAgkWPfilRxJPFbALdVSgNIZfcybqHZ?=
 =?us-ascii?Q?qd1tPlIYKHcAdCD/+8DxiwsUCnE36+N7A9iYLXbQOkDY2uhS4wEluPOs4BkR?=
 =?us-ascii?Q?OjRGXSbXFCiIl89KE3T4vuUo8MixC6ojzCF2acbsFNP9w0GXQW7Q1Bae5do4?=
 =?us-ascii?Q?Set5wxbfXOoR2R7SPrRioNgGhXyakS91ZbD3wpoE/V16sq2j0ukXpkimvCQW?=
 =?us-ascii?Q?LurWKVLAC1O/7Dq34/Lm6K/EhNpT8nDOBwl+koTFFO13/KmCZeCJl4YP9qr3?=
 =?us-ascii?Q?UB4NyMWUr1lU6wu1lh5+8Oat5U+Bc+zoMfXiJQYoxH+kOiXrYzycmrGku6lX?=
 =?us-ascii?Q?onW1UedfJnEsAWArS6oaTongdVOqw9oRxcHT+Z0vsuCD6O8jlkLWDdCGV1UO?=
 =?us-ascii?Q?SiBdWJn+f9EcdJ9XouuLs00hZgcz7m8LE7oo3JjfiwV0596h7Il2+m2Wbxc3?=
 =?us-ascii?Q?RHvH3zBXblzFKcpCUoi0FhF+aG22AuRWbedYsjl2uZ8jOBReWIEgb7DWFciV?=
 =?us-ascii?Q?Wc2JoXhNHef8u+OgRvxLt1ycS7zXZFVXSIS0sQbExp/edLjqoe+q8ZtFg+dA?=
 =?us-ascii?Q?pFVfkLUF6UGIYkx3VG4bBanqXpFDNFa5CPzF9O5p8wvCLGlKvnDIhgCI8Vx9?=
 =?us-ascii?Q?smSzQ8/zrUEMF/IiVoZBU4lOyI8Xu3aEiPA7SXeTjJYAc3uDbMDL19+rXMOi?=
 =?us-ascii?Q?KV/QiB+uhd23j8zca/48GVx0VnhoU6nS2aFgg7tb1KiU/5CGIq9PrPJT4Ym5?=
 =?us-ascii?Q?5i6spx8ZLTdbvqmx4XS1kkfJEev+X+ZH2lgChkAzXQnM6z4fZeJIv2/72Q0o?=
 =?us-ascii?Q?l80n6kjpwPDyMcBF7mC+WeGLztA1xXi/ygMcWd9OT+AcabMIvyDSgV5NSe1R?=
 =?us-ascii?Q?BN6LhRT/OQZ0eOhkLkVk2P0W01Vl2eJHNHeEV2xXCjgIXJcBFnDE6QNXNr7a?=
 =?us-ascii?Q?8OXOjR6R7Fq/LS9nTdwkOcCHwfwnQLNL4zyRUfoOEMafvjKU15zNOEn5s1E3?=
 =?us-ascii?Q?GC6W9/i3zTEBOjDOzwPykdmwx3fbH1SCEHySe6qa106BKgkNLKjxrahISgBc?=
 =?us-ascii?Q?CDmmyF9FBWK490ldXIFy5lnwtsXK2eGXdxDUSurOR6usf8VigRd2UiKHs4Ak?=
 =?us-ascii?Q?mziAjuEs2egTAv9/D3ctdUC8FZdvVon1fXNGdggi0DMUp+I7LqOOUrQ7uhry?=
 =?us-ascii?Q?doRRh+TRdkdaJ4dMr6CxkTy5mkiYv09evprc3JxD07PoECiZWsuQBGegv98o?=
 =?us-ascii?Q?AmSeJZKmijiHAImh3gC8eQM0jaoc3lXBPBVFe6zBxZEdLKerGwJ0U8KvOLUn?=
 =?us-ascii?Q?RSYY3BxKL92OXxIcW2+Dt+2O8Pf/nIDZHS6FLvriYdl4se5Xp8gtc/SS6OrS?=
 =?us-ascii?Q?ylnffUdlGjUC8jRPGX8kStSQer06iMiYi5AhOZ5SI/3lAK8P45S3P+nbGldq?=
 =?us-ascii?Q?uqKcq7qk3TglxDULI9bMsv8l384yy4TEYZxGE5OynZqEWwTBDSvkucRT/8VA?=
 =?us-ascii?Q?Br6wpGa0iTroN0aVtQXo/MR3Nt2fmFIWjfnk/cqyNLMYaN4fUQNxAcLzYTti?=
 =?us-ascii?Q?JrS13KBdT9xvCyuvzHegS1ZBa3Y4coU9w+n5IZIlvLPSlRzSLcsDQGbX6O3s?=
 =?us-ascii?Q?Xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C1BADC8024B20244A4797BD1C55A54AE@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR15MB4145.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a77f196-2d73-439f-7098-08da70d52b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 20:10:08.5929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fOj4AufSBU1g6yhMmUlB3hE8BEiR4L7S1YKJ1uaWoIE47IxKhqHf4QyAUYTsODCm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1201
X-Proofpoint-GUID: eOMJX5r91o1LYw5lV3pk_MuxZwOFv5KE
X-Proofpoint-ORIG-GUID: eOMJX5r91o1LYw5lV3pk_MuxZwOFv5KE
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 28 Jul 2022, at 20:03, John Garry <john.garry@huawei.com> wrote:
> 
>> Hi,
>> I'm having trouble getting the pm80xx driver to discover SATA drives.
>> Enclosure has both SAS and SATA drives and the controller is Adaptec Device 8074 (rev 06) on x86_64 machine.
>> Without ATA support in libsas, SAS drives alone are working correctly on 5.18.
>> After enabling ATA support the driver started crashing.
>> With scsi_mod.scan=sync and high loglevel for pm80xx I was able to perform a couple
>> of commands before the kernel crashed.
> 
> Has this worked ok for any other recent kernel version? It seems that 5.18 and 5.19-rcX are broken for you, but it would be good to know if your setup ever worked without issue. Damien (cc'ed) and I have been making changes to this driver and libsas recently but don't experience these sorts of problems.
This is a new environmen, It did not work before. So far I tested 4.11 and 5.18 and 5.19 with similar crashes around spinlock in mpi_sata_completion

> 
>> Applying "libsas and drivers: NCQ error handling" (https://patchwork.kernel.org/project/linux-scsi/list/?series=662216)
>> series of patches prevents the driver from crashing but all operations are timing out.
> 
> That could be related to patch 1/6, where I think that you might experience a use-after-free (which that patch attempts to fix). Turning KASAN on should help detect (without my patch).


vanilla 5.19-rc8 with KASAN enabled and scsi_mod.scan=sync , you ware right there is a use after free there

[   72.174677] ata8.00: qc timeout (cmd 0x27)
[   72.174692] ata14.00: qc timeout (cmd 0x27)
[   72.184006] ata14.00: failed to read native max address (err_mask=0x4)
[   72.184011] ata14.00: HPA support seems broken, skipping HPA handling
[   72.188588] ==================================================================
[   72.188591] BUG: KASAN: use-after-free in mpi_sata_completion+0x2470/0x2d20 [pm80xx]
[   72.203067] Read of size 8 at addr ffff8884336c4f00 by task ksoftirqd/0/14
[   72.219769]
[   72.219772] CPU: 0 PID: 14 Comm: ksoftirqd/0 Not tainted 5.19.0-rc8 #1
[   72.227483] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   72.227545] ata8.00: failed to read native max address (err_mask=0x4)
[   72.227549] ata8.00: HPA support seems broken, skipping HPA handling
[   72.227552] ata8.00: revalidation failed (errno=-5)
[   72.229110] Call Trace:
[   72.229113]  <TASK>
[   72.276458]  dump_stack_lvl+0x33/0x42
[   72.280555]  print_report.cold.12+0xf5/0x67c
[   72.285331]  ? mpi_sata_completion+0x2470/0x2d20 [pm80xx]
[   72.291412]  kasan_report+0xa5/0x120
[   72.295411]  ? mpi_sata_completion+0x2470/0x2d20 [pm80xx]
[   72.301490]  mpi_sata_completion+0x2470/0x2d20 [pm80xx]
[   72.307368]  ? ttwu_do_wakeup+0x21/0x560
[   72.311753]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
[   72.317927]  ? _raw_spin_unlock_irqrestore+0x46/0x70
[   72.323475]  ? _raw_spin_unlock+0x39/0x60
[   72.327955]  ? _raw_spin_lock_irqsave+0x8d/0xe0
[   72.333018]  ? _raw_read_lock_bh+0x40/0x40
[   72.337597]  ? sched_clock_cpu+0x69/0x2a0
[   72.342079]  process_oq+0xe56/0x5bc0 [pm80xx]
[   72.346988]  ? psi_task_switch+0x3e8/0x4a0
[   72.351567]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
[   72.357636]  ? put_prev_entity+0x4d/0x210
[   72.362118]  ? psi_task_change+0x1f0/0x1f0
[   72.366696]  ? __wake_up_common_lock+0x130/0x130
[   72.371856]  ? __switch_to_asm+0x42/0x70
[   72.376241]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
[   72.381447]  tasklet_action_common.isra.19+0x1ed/0x340
[   72.387192]  __do_softirq+0x199/0x575
[   72.391286]  ? tasklet_kill+0x1b0/0x1b0
[   72.395571]  run_ksoftirqd+0x26/0x30
[   72.399564]  smpboot_thread_fn+0x420/0x6c0
[   72.404143]  ? sort_range+0x20/0x20
[   72.408040]  kthread+0x265/0x300
[   72.411647]  ? kthread_complete_and_exit+0x20/0x20
[   72.416999]  ret_from_fork+0x1f/0x30
[   72.420997]  </TASK>
[   72.423437]
[   72.425100] Allocated by task 198:
[   72.428898]  kasan_save_stack+0x1c/0x40
[   72.433184]  __kasan_slab_alloc+0x6d/0x90
[   72.437663]  kmem_cache_alloc+0x134/0x460
[   72.442144]  sas_alloc_task+0x1d/0xa0 [libsas]
[   72.447127]  sas_ata_qc_issue+0x1a8/0xba0 [libsas]
[   72.452496]  ata_qc_issue+0x498/0xbb0
[   72.456588]  ata_exec_internal_sg+0xafb/0x17f0
[   72.461550]  ata_read_native_max_address+0x1b3/0x480
[   72.467097]  ata_dev_configure+0x1ba7/0x5180
[   72.471867]  ata_eh_recover+0x15b5/0x3030
[   72.476346]  ata_do_eh+0x40/0xb0
[   72.479952]  ata_scsi_port_error_handler+0x47d/0xb90
[   72.485496]  async_sas_ata_eh+0xcf/0x112 [libsas]
[   72.490768]  async_run_entry_fn+0x93/0x510
[   72.495344]  process_one_work+0x889/0x14c0
[   72.499919]  worker_thread+0x84/0x11f0
[   72.504107]  kthread+0x265/0x300
[   72.507712]  ret_from_fork+0x1f/0x30
[   72.511705]
[   72.513367] Freed by task 198:
[   72.516776]  kasan_save_stack+0x1c/0x40
[   72.521060]  kasan_set_track+0x21/0x30
[   72.525247]  kasan_set_free_info+0x20/0x30
[   72.529822]  __kasan_slab_free+0x101/0x170
[   72.534398]  kmem_cache_free+0xa1/0x4b0
[   72.538682]  ata_exec_internal_sg+0xc72/0x17f0
[   72.543646]  ata_read_native_max_address+0x1b3/0x480
[   72.549192]  ata_dev_configure+0x1ba7/0x5180
[   72.553961]  ata_eh_recover+0x15b5/0x3030
[   72.558440]  ata_do_eh+0x40/0xb0
[   72.562045]  ata_scsi_port_error_handler+0x47d/0xb90
[   72.567590]  async_sas_ata_eh+0xcf/0x112 [libsas]
[   72.572861]  async_run_entry_fn+0x93/0x510
[   72.577436]  process_one_work+0x889/0x14c0
[   72.582012]  worker_thread+0x84/0x11f0
[   72.586199]  kthread+0x265/0x300
[   72.589803]  ret_from_fork+0x1f/0x30
[   72.593798]
[   72.595461] The buggy address belongs to the object at ffff8884336c4f00
[   72.595461]  which belongs to the cache sas_task of size 264
[   72.609152] The buggy address is located 0 bytes inside of
[   72.609152]  264-byte region [ffff8884336c4f00, ffff8884336c5008)
[   72.622067]
[   72.623729] The buggy address belongs to the physical page:
[   72.629950] page:000000001e6555bf refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4336c4
[   72.640445] head:000000001e6555bf order:1 compound_mapcount:0 compound_pincount:0
[   72.648801] flags: 0xbfff80000010200(slab|head|node=0|zone=2|lastcpupid=0x7fff)
[   72.656971] raw: 0bfff80000010200 0000000000000000 dead000000000122 ffff888106682dc0
[   72.665620] raw: 0000000000000000 0000000000150015 00000001ffffffff 0000000000000000
[   72.674265] page dumped because: kasan: bad access detected
[   72.680486]
[   72.682149] Memory state around the buggy address:
[   72.687499]  ffff8884336c4e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   72.695565]  ffff8884336c4e80: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   72.703630] >ffff8884336c4f00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   72.711694]                    ^
[   72.715297]  ffff8884336c4f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   72.723352]  ffff8884336c5000: fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   72.731407] ==================================================================
[   72.739460] Disabling lock debugging due to kernel taint
[   79.854640] ata8.00: qc timeout (cmd 0xec)
[   79.867706] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
[   79.883327] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
[   79.898953] sas: Internal abort: task to dev 500e004abbbbbb02 response: 0x5 status 0x0
[   79.907810] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   79.914618] ata8.00: revalidation failed (errno=-5)
[   81.902636] ata9.00: qc timeout (cmd 0x2f)
[   81.907295] ata9.00: Read log 0x00 page 0x00 failed, Emask 0x4
[   81.913829] ata9.00: failed to set xfermode (err_mask=0x40)
[   89.582637] ata9.00: qc timeout (cmd 0xec)
[   89.582637] ata14.00: qc timeout (cmd 0x2f)
[   89.591934] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
[   89.602140] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
[   89.602153] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
[   89.619835] sas: Internal abort: task to dev 500e004abbbbbb05 response: 0x5 status 0x0
[   89.619859] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   89.635491] ata9.00: revalidation failed (errno=-5)
[   89.635516] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
[   89.650912] sas: Internal abort: task to dev 500e004abbbbbb0f response: 0x5 status 0x0
[   89.659791] ata14.00: Read log 0x13 page 0x00 failed, Emask 0x4
[   89.666407] ata14.00: Read log 0x00 page 0x00 failed, Emask 0x40
[   89.673120] ata14.00: NCQ Send/Recv Log not supported
[   89.678770] ata14.00: Read log 0x00 page 0x00 failed, Emask 0x40
[   89.685498] ata14.00: failed to set xfermode (err_mask=0x40)
[   89.691823] ata14.00: limiting speed to UDMA/133:PIO3
[   91.323501] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
[   91.323504] Modules linked in: pm80xx(+) libsas scsi_transport_sas loop tg3 virtio_rng virtio_net net_failover failover
[   91.323526] CPU: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G    B             5.19.0-rc8 #1
[   91.323535] RIP: 0010:kasan_report+0x1b/0x120
[   91.323542] Code: aa 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 41 56 41 55 41 54 55 53 48 83 ec 38 9c 41 5d 0f 01 ca 65 48 8b 04 25 00 ec 02 00 <8b> 80 20 0b 00 00 85 c0 0f 85 92 00 00 00 48 8b9
[   91.323547] RSP: 0018:ffffc9000012f980 EFLAGS: 00000082
[   91.323552] RAX: ffff8881003dec00 RBX: ffff8884336c4f08 RCX: ffffffff812b798b
[   91.323556] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8884336c4f08
[   91.323560] RBP: 0000000000000003 R08: fffffffffffffffb R09: ffffed10866d89e1
[   91.323563] R10: 0000000000000003 R11: ffffed10866d89e1 R12: 1ffff92000025f3f
[   91.323566] R13: 0000000000000082 R14: ffff8884336c4f6c R15: ffff8884336c4f70
[   91.323570] FS:  0000000000000000(0000) GS:ffff88838b000000(0000) knlGS:0000000000000000
[   91.323575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.323578] CR2: 000000c0002a9ff8 CR3: 0000000432ed2006 CR4: 00000000003706f0
[   91.323582] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   91.323585] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   91.323589] Call Trace:
[   91.323591]  <TASK>
[   91.323596]  queued_spin_lock_slowpath+0x8fb/0xa50
[   91.323604]  ? osq_unlock+0x1f0/0x1f0
[   91.323610]  ? irq_work_claim+0x16/0x70
[   91.323617]  ? irq_work_queue+0xd/0x50
[   91.323623]  ? __wake_up_klogd.part.32+0x79/0xb0
[   91.323629]  ? vprintk_emit+0xf7/0x2b0
[   91.323633]  ? print_report.cold.12+0x66c/0x67c
[   91.323642]  _raw_spin_lock_irqsave+0xd9/0xe0
[   91.323649]  ? _raw_read_lock_bh+0x40/0x40
[   91.323658]  mpi_sata_completion+0x389/0x2d20 [pm80xx]
[   91.323717]  ? ttwu_do_wakeup+0x21/0x560
[   91.323723]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
[   91.323773]  ? _raw_spin_unlock+0x39/0x60
[   91.323780]  ? _raw_spin_lock_irqsave+0x8d/0xe0
[   91.323786]  ? _raw_read_lock_bh+0x40/0x40
[   91.323793]  ? sched_clock_cpu+0x69/0x2a0
[   91.323799]  process_oq+0xe56/0x5bc0 [pm80xx]
[   91.323854]  ? psi_task_switch+0x3e8/0x4a0
[   91.323861]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
[   91.323911]  ? put_prev_entity+0x4d/0x210
[   91.323918]  ? psi_task_change+0x1f0/0x1f0
[   91.323924]  ? __wake_up_common_lock+0x130/0x130
[   91.323930]  ? __switch_to_asm+0x42/0x70
[   91.323937]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
[   91.323988]  tasklet_action_common.isra.19+0x1ed/0x340
[   91.323996]  __do_softirq+0x199/0x575
[   91.324002]  ? tasklet_kill+0x1b0/0x1b0
[   91.324008]  run_ksoftirqd+0x26/0x30
[   91.324013]  smpboot_thread_fn+0x420/0x6c0
[   91.324020]  ? sort_range+0x20/0x20
[   91.324027]  kthread+0x265/0x300
[   91.324031]  ? kthread_complete_and_exit+0x20/0x20
[   91.324037]  ret_from_fork+0x1f/0x30
[   91.324046]  </TASK>
[   91.324049] Kernel panic - not syncing: Hard LOCKUP
[   91.324052] CPU: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G    B             5.19.0-rc8 #1
[   91.324058] Hardware name: EMC InfinityES6/110-365-300J-00, BIOS 33.15 08/17/2017
[   91.324060] Call Trace:
[   91.324062]  <NMI>
[   91.324064]  dump_stack_lvl+0x33/0x42
[   91.324072]  panic+0x1d4/0x3f7
[   91.324078]  ? panic_print_sys_info+0x75/0x75
[   91.324085]  ? nmi_panic+0x27/0x60
[   91.324093]  nmi_panic.cold.7+0x14/0x14
[   91.324098]  watchdog_overflow_callback.cold.3+0xcf/0x103
[   91.324104]  __perf_event_overflow+0x11c/0x370
[   91.324113]  handle_pmi_common+0x49a/0x6d0
[   91.324122]  ? intel_pmu_save_and_restart+0xe0/0xe0
[   91.324130]  ? __native_set_fixmap+0x24/0x30
[   91.324138]  ? memcpy_fromio+0x26/0x110
[   91.324147]  ? ghes_copy_tofrom_phys+0x90/0x160
[   91.324158]  intel_pmu_handle_irq+0x269/0xbe0
[   91.324167]  perf_event_nmi_handler+0x37/0x50
[   91.324174]  nmi_handle+0xa5/0x260
[   91.324183]  default_do_nmi+0x72/0x170
[   91.324191]  exc_nmi+0x117/0x140
[   91.324197]  end_repeat_nmi+0x16/0x31
[   91.324202] RIP: 0010:kasan_report+0x1b/0x120
[   91.324207] Code: aa 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 41 56 41 55 41 54 55 53 48 83 ec 38 9c 41 5d 0f 01 ca 65 48 8b 04 25 00 ec 02 00 <8b> 80 20 0b 00 00 85 c0 0f 85 92 00 00 00 48 8b9
[   91.324212] RSP: 0018:ffffc9000012f980 EFLAGS: 00000082
[   91.324216] RAX: ffff8881003dec00 RBX: ffff8884336c4f08 RCX: ffffffff812b798b
[   91.324220] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8884336c4f08
[   91.324224] RBP: 0000000000000003 R08: fffffffffffffffb R09: ffffed10866d89e1
[   91.324227] R10: 0000000000000003 R11: ffffed10866d89e1 R12: 1ffff92000025f3f
[   91.324230] R13: 0000000000000082 R14: ffff8884336c4f6c R15: ffff8884336c4f70
[   91.324236]  ? queued_spin_lock_slowpath+0x8fb/0xa50
[   91.324244]  ? kasan_report+0x1b/0x120
[   91.324250]  ? kasan_report+0x1b/0x120
[   91.324255]  </NMI>
[   91.324257]  <TASK>
[   91.324261]  queued_spin_lock_slowpath+0x8fb/0xa50
[   91.324267]  ? osq_unlock+0x1f0/0x1f0
[   91.324273]  ? irq_work_claim+0x16/0x70
[   91.324279]  ? irq_work_queue+0xd/0x50
[   91.324284]  ? __wake_up_klogd.part.32+0x79/0xb0
[   91.324289]  ? vprintk_emit+0xf7/0x2b0
[   91.324294]  ? print_report.cold.12+0x66c/0x67c
[   91.324302]  _raw_spin_lock_irqsave+0xd9/0xe0
[   91.324309]  ? _raw_read_lock_bh+0x40/0x40
[   91.324317]  mpi_sata_completion+0x389/0x2d20 [pm80xx]
[   91.324371]  ? ttwu_do_wakeup+0x21/0x560
[   91.324376]  ? pm80xx_chip_sata_req+0x1e50/0x1e50 [pm80xx]
[   91.324427]  ? _raw_spin_unlock+0x39/0x60
[   91.324433]  ? _raw_spin_lock_irqsave+0x8d/0xe0
[   91.324440]  ? _raw_read_lock_bh+0x40/0x40
[   91.324446]  ? sched_clock_cpu+0x69/0x2a0
[   91.324452]  process_oq+0xe56/0x5bc0 [pm80xx]
[   91.324507]  ? psi_task_switch+0x3e8/0x4a0
[   91.324514]  ? mpi_sata_completion+0x2d20/0x2d20 [pm80xx]
[   91.324565]  ? put_prev_entity+0x4d/0x210
[   91.324571]  ? psi_task_change+0x1f0/0x1f0
[   91.324578]  ? __wake_up_common_lock+0x130/0x130
[   91.324583]  ? __switch_to_asm+0x42/0x70
[   91.324590]  pm80xx_chip_isr+0x63/0x160 [pm80xx]
[   91.324644]  tasklet_action_common.isra.19+0x1ed/0x340
[   91.324651]  __do_softirq+0x199/0x575
[   91.324658]  ? tasklet_kill+0x1b0/0x1b0
[   91.324663]  run_ksoftirqd+0x26/0x30
[   91.324668]  smpboot_thread_fn+0x420/0x6c0
[   91.324676]  ? sort_range+0x20/0x20
[   91.324682]  kthread+0x265/0x300
[   91.324686]  ? kthread_complete_and_exit+0x20/0x20
[   91.324692]  ret_from_fork+0x1f/0x30
[   91.324701]  </TASK>
[   91.324708] Kernel Offset: disabled

Thanks,
Michal
