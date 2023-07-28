Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDBEC00528
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbjG1MOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbjG1MNg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:13:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ACC4227;
        Fri, 28 Jul 2023 05:13:13 -0700 (PDT)
Message-ID: <20230728120930.952069383@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=8j9Csrsczl1+89ZENZFtTchVmi22SuFWjwFyU4WiA04=;
        b=QZDQKCS1kBmU9oozZ6D3561g0CmzwmjmKcw6lBDyhApig1kDACMGecuP9Tpl2DWmwh0Pfy
        nb3w3uQZSIXmh95Y30fd8NEwAK89sFSkqy2LbjTym2AZHONtgT9oEFZXOL4at4EWDK0CQx
        cgx7ImQFZ2HmNKvHmOeqvrBWyyW2w3PDBZqXH45R2JXrWJlCZXxaFuOr5Z+fYF1xj6U/ZH
        GskExaoSLYyFKInF59nUZulwPyaIT8DzWZnT/M+7aUeW3Z0DBVLiCr0KNjJPhZNticF1UY
        XPPOTqiPG2Rg6+lwiZ7ingSaRENhrKySJRauqFfhwmnQntAxQVAu+QWpovfSIg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=8j9Csrsczl1+89ZENZFtTchVmi22SuFWjwFyU4WiA04=;
        b=hqEf29XziUG9U3h6D9xcYDVRXgCSya5ClMe/wlyPDnsszrWwssYrmFugeH81LPjs0XD3AG
        ojdF7lwnhsWnMxDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Huang Rui <ray.huang@amd.com>, Juergen Gross <jgross@suse.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>
Subject: [patch v2 23/38] x86/cpu: Use common topology code for Centaur and
 Zhaoxin
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:13:11 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Centaur and Zhaoxin CPUs use only the legacy SMP detection. Remove the
invocations from their 32bit path and exempt them from the call 64bit.

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/centaur.c         |    4 ----
 arch/x86/kernel/cpu/topology_common.c |   11 ++++++++---
 arch/x86/kernel/cpu/zhaoxin.c         |    4 ----
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -128,10 +128,6 @@ static void init_centaur(struct cpuinfo_
 #endif
 	early_init_centaur(c);
 	init_intel_cacheinfo(c);
-	detect_num_cpu_cores(c);
-#ifdef CONFIG_X86_32
-	detect_ht(c);
-#endif
 
 	if (c->cpuid_level > 9) {
 		unsigned int eax = cpuid_eax(10);
--- a/arch/x86/kernel/cpu/topology_common.c
+++ b/arch/x86/kernel/cpu/topology_common.c
@@ -42,7 +42,7 @@ static unsigned int parse_num_cores(stru
 	return eax.ncores + 1;
 }
 
-static void __maybe_unused parse_legacy(struct topo_scan *tscan)
+static void parse_legacy(struct topo_scan *tscan)
 {
 	unsigned int cores, core_shift, smt_shift = 0;
 	struct cpuinfo_x86 *c = tscan->c;
@@ -64,10 +64,8 @@ bool topo_is_converted(struct cpuinfo_x8
 	/* Temporary until everything is converted over. */
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-	case X86_VENDOR_CENTAUR:
 	case X86_VENDOR_INTEL:
 	case X86_VENDOR_HYGON:
-	case X86_VENDOR_ZHAOXIN:
 		return false;
 	default:
 		/* Let all UP systems use the below */
@@ -125,6 +123,13 @@ static void parse_topology(struct topo_s
 		return;
 
 	tscan->ebx1_nproc_shift = get_count_order(ebx.nproc);
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_CENTAUR:
+	case X86_VENDOR_ZHAOXIN:
+		parse_legacy(tscan);
+		break;
+	}
 }
 
 static void topo_set_ids(struct topo_scan *tscan)
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -71,10 +71,6 @@ static void init_zhaoxin(struct cpuinfo_
 {
 	early_init_zhaoxin(c);
 	init_intel_cacheinfo(c);
-	detect_num_cpu_cores(c);
-#ifdef CONFIG_X86_32
-	detect_ht(c);
-#endif
 
 	if (c->cpuid_level > 9) {
 		unsigned int eax = cpuid_eax(10);

