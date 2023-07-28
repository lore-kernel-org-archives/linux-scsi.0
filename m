Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A77CC00528
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjG1MNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbjG1MM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:12:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29DD30F9;
        Fri, 28 Jul 2023 05:12:57 -0700 (PDT)
Message-ID: <20230728120930.281607646@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0qZzNXCX/ZoHr7seeBhbra6OnJEhbVbzB3A+CK/YtPY=;
        b=aQhl26Q+265Qq/fhYiRlN5fOjPIfdWfE4i/pA7Eu1rA4J3Wj/qwoAa3ee07MJ+9vwfl2Nk
        KycP3jgfVk5U60YwfcF03eQ7ADhePjr3FnYR1WEUYlelUPaTkAc1XpD6Z6/Q85hW/ElsZH
        Pr6xvewphzdNBOUaYVo+TbSw4tyDeDX/yJ43zcUsORDxN8y+zpRs1vmOH1IarLjai6sA1Y
        6hRD5x8yoHPXh8TjwZPAZHaoQmYFR3CsYB2SM1buBYU4ULsm6nhzycxI57q7jIG+i9ln7z
        LA8OE/3xN5DwJamyTxVX86Y9Ozt7k5ROgyghBsFuwm4lDirsy0uSx1kAvyGDWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0qZzNXCX/ZoHr7seeBhbra6OnJEhbVbzB3A+CK/YtPY=;
        b=D23S9P1Jgmvogv+U7+ey+IT9etYh6L1tpz90dqcqB5tNkgrHrxgR+LueL/5dsolZ4N8T1U
        WlujtX9edVEg1KAg==
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
Subject: [patch v2 11/38] x86/apic: Use BAD_APICID consistently;
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:12:56 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

APIC ID checks compare with BAD_APICID all over the place, but some
initializers and some code which fiddles with global data structure use
-1[U] instead. That simply cannot work at all.

Fix it up and use BAD_APICID consistenly all over the place.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 arch/x86/kernel/apic/apic.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -852,7 +852,7 @@ int acpi_unmap_cpu(int cpu)
 	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
 #endif
 
-	per_cpu(x86_cpu_to_apicid, cpu) = -1;
+	per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	set_cpu_present(cpu, false);
 	num_processors--;
 
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -70,7 +70,7 @@ unsigned int num_processors;
 unsigned disabled_cpus;
 
 /* Processor that is doing the boot up */
-unsigned int boot_cpu_physical_apicid __ro_after_init = -1U;
+unsigned int boot_cpu_physical_apicid __ro_after_init = BAD_APICID;
 EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 
 u8 boot_cpu_apic_version __ro_after_init;
@@ -2316,9 +2316,7 @@ static int nr_logical_cpuids = 1;
 /*
  * Used to store mapping between logical CPU IDs and APIC IDs.
  */
-int cpuid_to_apicid[] = {
-	[0 ... NR_CPUS - 1] = -1,
-};
+int cpuid_to_apicid[] = { [0 ... NR_CPUS - 1] = BAD_APICID, };
 
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {

