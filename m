Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDB3C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 06:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ECA022CED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 06:15:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="AjoQvCpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfH2GPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 02:15:04 -0400
Received: from mail-eopbgr680099.outbound.protection.outlook.com ([40.107.68.99]:22242
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfH2GPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 02:15:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFKOrXWfZJXP0tMmuXe8cDC5HeaA2FZUrCnopk8o38cRFYIPlY23+CD0y+dmzTP36qnclxx1lZt47S1dikouxP4IbJYaBqlQohQcluPv7SiU6SMkv0NGL7HVUhqOHBH689YB9A7CpnLcfHxYspz8I03R4pjNwUIv+8+eRpwcbF7F/8Mo8srsuhKO2Kln7Lroj4IFiJFDl26g9zb8v8ul2Z7TtJnaQYoLExltX65VdDwLOk5wbYCBua6QXGCxR+rkXEJZjDtro5OWzH4xWdCbdql/RDvw0DImrVkB4YpUSqP+o9Lc744LmcDYReVRqCxnCSdPvvXneJUcdyFT1o3aSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AExnPL+azX8+sawlR0EfQJFLUUzrOICI6c+wTcQxkh4=;
 b=YDfGE+3F4cZrRzs+towSVyjz19QhtW5Q3TWhcmm4iayCphOr7akWPK6N01oFR3aUNLAQrQuQeqTp5y8/eVVCP0/E+ip754222AhXgYROe7JByaIboh/YrWrhTv1aRa3vvbVoAXEP4nKg/83JKcbj5owL/Mdvhgf/KbeCLECsoiVr3pkxsIyYCx5XQI33JxlWdsQ8cHBqbsuuvnPXWLWSSenLjZA53DR+PfzkH+0B4uhHcDB3IDircOc9aD/iug/32L00+FULBseIj0kp2OuQpxk2K3uSEdCeRRBhBNMF0hZ0fK9HghRZZPN+QUvkBFOWGEn+7td33jdyXJuX60JE9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AExnPL+azX8+sawlR0EfQJFLUUzrOICI6c+wTcQxkh4=;
 b=AjoQvCpwFOYA6ki+qidTwOQkJxZlEnFRasv5uQym2OZRHbMamOEN3gIWbNbdjVpmpb05y5EEOh0Zif1JBz1eePe9GLQs8NhSl22zOmM5Tf/hGBhYkTVSHg1U8zcXGedhikVDkcefivj6u2vpbiFQsRKRKyy8J5SngP4TryBaUpM=
Received: from DM5PR21MB0748.namprd21.prod.outlook.com (10.173.172.14) by
 DM5PR21MB0635.namprd21.prod.outlook.com (10.175.111.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.1; Thu, 29 Aug 2019 06:15:00 +0000
Received: from DM5PR21MB0748.namprd21.prod.outlook.com
 ([fe80::14b7:b5be:82b8:43c6]) by DM5PR21MB0748.namprd21.prod.outlook.com
 ([fe80::14b7:b5be:82b8:43c6%11]) with mapi id 15.20.2220.012; Thu, 29 Aug
 2019 06:15:00 +0000
From:   Long Li <longli@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Topic: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Thread-Index: AQHVXLUAoNqN0R8TLUadmsLcmKb6xacRp58A
Date:   Thu, 29 Aug 2019 06:15:00 +0000
Message-ID: <DM5PR21MB0748278B86FB5103AF6E8A37CEA20@DM5PR21MB0748.namprd21.prod.outlook.com>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
In-Reply-To: <20190827085344.30799-2-ming.lei@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:b:ede2:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e48b3bae-4b66-41d2-9576-08d72c48395a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR21MB0635;
x-ms-traffictypediagnostic: DM5PR21MB0635:
x-microsoft-antispam-prvs: <DM5PR21MB0635DF87F7001C49E4B56AA0CEA20@DM5PR21MB0635.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(189003)(199004)(8990500004)(6506007)(256004)(14444005)(11346002)(2906002)(71190400001)(53936002)(66946007)(486006)(76116006)(5660300002)(64756008)(66446008)(66556008)(74316002)(81156014)(66476007)(52536014)(6246003)(476003)(6436002)(6116002)(76176011)(22452003)(25786009)(86362001)(4326008)(478600001)(14454004)(55016002)(446003)(71200400001)(10290500003)(33656002)(8936002)(54906003)(110136005)(7736002)(46003)(9686003)(316002)(102836004)(305945005)(7416002)(186003)(8676002)(7696005)(10090500001)(81166006)(99286004)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0635;H:DM5PR21MB0748.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dmqZeN/nD0UbgsLdN9oyoPsMfo1e7sIQeKGE8a6nDfmWDM9p6KVs7e9XZ+hxljXNX5u0/g4T18w0O4Oi8o4FweBRHd5OBgB/76C1OiVPm8Tn1FN16KEkbo+VGu3ZYSgJcYkkXRSB9E/T6+2tx/Q62F0KLqL54aulnlU/YRNiMaJzDONgoln5qYPobfYmsqVK8CqilqFlxdApEnbl6g7n5ec0D7s+Rl6tjlKORL1E9U+u9Ell6qKZbYXmb3eb9S8tRIcRZ3Ep5GhwHvFBBhHdcYBCqF4WUK5Cn+UUUqcQXBFmuQXcjAkC1yhbcwE68KE6reyP6H7kp4c9S7QQlW4VgoHmdu0ikwn6Jfol5IcoKm4T42lLJiRhpQFkKpwK+iVSXUs7q882BI9+VCVRpkCu20Jwc9bgexAyqYwNxHuuETc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48b3bae-4b66-41d2-9576-08d72c48395a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 06:15:00.4411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k50u2C0fHA1ik0YxM7nywaZWyYQ21cwFwKZXWyXqcnfP9eysFV6kQd5YYDDM0RvteGqgPG0wriqRbaQooLPFvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0635
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>For some high performance IO devices, interrupt may come very frequently=
,
>>>meantime IO request completion may take a bit time. Especially on some
>>>devices(SCSI or NVMe), IO requests can be submitted concurrently from
>>>multiple CPU cores, however IO completion is only done on one of these
>>>submission CPU cores.
>>>
>>>Then IRQ flood can be easily triggered, and CPU lockup.
>>>
>>>Implement one simple generic CPU IRQ flood detection mechanism. This
>>>mechanism uses the CPU average interrupt interval to evaluate if IRQ flo=
od
>>>is triggered. The Exponential Weighted Moving Average(EWMA) is used to
>>>compute CPU average interrupt interval.
>>>
>>>Cc: Long Li <longli@microsoft.com>
>>>Cc: Ingo Molnar <mingo@redhat.com>,
>>>Cc: Peter Zijlstra <peterz@infradead.org>
>>>Cc: Keith Busch <keith.busch@intel.com>
>>>Cc: Jens Axboe <axboe@fb.com>
>>>Cc: Christoph Hellwig <hch@lst.de>
>>>Cc: Sagi Grimberg <sagi@grimberg.me>
>>>Cc: John Garry <john.garry@huawei.com>
>>>Cc: Thomas Gleixner <tglx@linutronix.de>
>>>Cc: Hannes Reinecke <hare@suse.com>
>>>Cc: linux-nvme@lists.infradead.org
>>>Cc: linux-scsi@vger.kernel.org
>>>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>---
>>> drivers/base/cpu.c      | 25 ++++++++++++++++++++++
>>> include/linux/hardirq.h |  2 ++
>>> kernel/softirq.c        | 46
>>>+++++++++++++++++++++++++++++++++++++++++
>>> 3 files changed, 73 insertions(+)
>>>
>>>diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c index
>>>cc37511de866..7277d1aa0906 100644
>>>--- a/drivers/base/cpu.c
>>>+++ b/drivers/base/cpu.c
>>>@@ -20,6 +20,7 @@
>>> #include <linux/tick.h>
>>> #include <linux/pm_qos.h>
>>> #include <linux/sched/isolation.h>
>>>+#include <linux/hardirq.h>
>>>
>>> #include "base.h"
>>>
>>>@@ -183,10 +184,33 @@ static struct attribute_group
>>>crash_note_cpu_attr_group =3D {  };  #endif
>>>
>>>+static ssize_t show_irq_interval(struct device *dev,
>>>+				 struct device_attribute *attr, char *buf) {
>>>+	struct cpu *cpu =3D container_of(dev, struct cpu, dev);
>>>+	ssize_t rc;
>>>+	int cpunum;
>>>+
>>>+	cpunum =3D cpu->dev.id;
>>>+
>>>+	rc =3D sprintf(buf, "%llu\n", irq_get_avg_interval(cpunum));
>>>+	return rc;
>>>+}
>>>+
>>>+static DEVICE_ATTR(irq_interval, 0400, show_irq_interval, NULL); static
>>>+struct attribute *irq_interval_cpu_attrs[] =3D {
>>>+	&dev_attr_irq_interval.attr,
>>>+	NULL
>>>+};
>>>+static struct attribute_group irq_interval_cpu_attr_group =3D {
>>>+	.attrs =3D irq_interval_cpu_attrs,
>>>+};
>>>+
>>> static const struct attribute_group *common_cpu_attr_groups[] =3D {  #i=
fdef
>>>CONFIG_KEXEC
>>> 	&crash_note_cpu_attr_group,
>>> #endif
>>>+	&irq_interval_cpu_attr_group,
>>> 	NULL
>>> };
>>>
>>>@@ -194,6 +218,7 @@ static const struct attribute_group
>>>*hotplugable_cpu_attr_groups[] =3D {  #ifdef CONFIG_KEXEC
>>> 	&crash_note_cpu_attr_group,
>>> #endif
>>>+	&irq_interval_cpu_attr_group,
>>> 	NULL
>>> };
>>>
>>>diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h index
>>>da0af631ded5..fd394060ddb3 100644
>>>--- a/include/linux/hardirq.h
>>>+++ b/include/linux/hardirq.h
>>>@@ -8,6 +8,8 @@
>>> #include <linux/vtime.h>
>>> #include <asm/hardirq.h>
>>>
>>>+extern u64 irq_get_avg_interval(int cpu); extern bool
>>>+irq_flood_detected(void);
>>>
>>> extern void synchronize_irq(unsigned int irq);  extern bool
>>>synchronize_hardirq(unsigned int irq); diff --git a/kernel/softirq.c
>>>b/kernel/softirq.c index 0427a86743a4..96e01669a2e0 100644
>>>--- a/kernel/softirq.c
>>>+++ b/kernel/softirq.c
>>>@@ -25,6 +25,7 @@
>>> #include <linux/smpboot.h>
>>> #include <linux/tick.h>
>>> #include <linux/irq.h>
>>>+#include <linux/sched/clock.h>
>>>
>>> #define CREATE_TRACE_POINTS
>>> #include <trace/events/irq.h>
>>>@@ -52,6 +53,12 @@ DEFINE_PER_CPU_ALIGNED(irq_cpustat_t, irq_stat);
>>>EXPORT_PER_CPU_SYMBOL(irq_stat);  #endif
>>>
>>>+struct irq_interval {
>>>+	u64                     last_irq_end;
>>>+	u64                     avg;
>>>+};
>>>+DEFINE_PER_CPU(struct irq_interval, avg_irq_interval);
>>>+
>>> static struct softirq_action softirq_vec[NR_SOFTIRQS]
>>>__cacheline_aligned_in_smp;
>>>
>>> DEFINE_PER_CPU(struct task_struct *, ksoftirqd); @@ -339,6 +346,41 @@
>>>asmlinkage __visible void do_softirq(void)
>>> 	local_irq_restore(flags);
>>> }
>>>
>>>+/*
>>>+ * Update average irq interval with the Exponential Weighted Moving
>>>+ * Average(EWMA)
>>>+ */
>>>+static void irq_update_interval(void)
>>>+{
>>>+#define IRQ_INTERVAL_EWMA_WEIGHT	128
>>>+#define IRQ_INTERVAL_EWMA_PREV_FACTOR	127
>>>+#define IRQ_INTERVAL_EWMA_CURR_FACTOR
>>>	(IRQ_INTERVAL_EWMA_WEIGHT - \
>>>+		IRQ_INTERVAL_EWMA_PREV_FACTOR)
>>>+
>>>+	int cpu =3D raw_smp_processor_id();
>>>+	struct irq_interval *inter =3D per_cpu_ptr(&avg_irq_interval, cpu);
>>>+	u64 delta =3D sched_clock_cpu(cpu) - inter->last_irq_end;
>>>+
>>>+	inter->avg =3D (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +

inter->avg will start with 0? maybe use a bigger value like IRQ_FLOOD_THRES=
HOLD_NS

>>>+		delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
>>>+		IRQ_INTERVAL_EWMA_WEIGHT;
>>>+}
>>>+
>>>+u64 irq_get_avg_interval(int cpu)
>>>+{
>>>+	return per_cpu_ptr(&avg_irq_interval, cpu)->avg; }
>>>+
>>>+/*
>>>+ * If the average CPU irq interval is less than 8us, we think interrupt
>>>+ * flood is detected on this CPU
>>>+ */
>>>+bool irq_flood_detected(void)
>>>+{
>>>+#define  IRQ_FLOOD_THRESHOLD_NS	8000
>>>+	return raw_cpu_ptr(&avg_irq_interval)->avg <=3D
>>>IRQ_FLOOD_THRESHOLD_NS;
>>>+}
>>>+
>>> /*
>>>  * Enter an interrupt context.
>>>  */
>>>@@ -356,6 +398,7 @@ void irq_enter(void)
>>> 	}
>>>
>>> 	__irq_enter();
>>>+	irq_update_interval();
>>> }
>>>
>>> static inline void invoke_softirq(void) @@ -402,6 +445,8 @@ static inli=
ne
>>>void tick_irq_exit(void)
>>>  */
>>> void irq_exit(void)
>>> {
>>>+	struct irq_interval *inter =3D raw_cpu_ptr(&avg_irq_interval);
>>>+
>>> #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
>>> 	local_irq_disable();
>>> #else
>>>@@ -413,6 +458,7 @@ void irq_exit(void)
>>> 		invoke_softirq();
>>>
>>> 	tick_irq_exit();
>>>+	inter->last_irq_end =3D sched_clock_cpu(smp_processor_id());
>>> 	rcu_irq_exit();
>>> 	trace_hardirq_exit(); /* must be last! */  }
>>>--
>>>2.20.1

