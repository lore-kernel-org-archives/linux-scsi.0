Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B13C04FE0
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbjG1MNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbjG1MMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:12:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32681269E;
        Fri, 28 Jul 2023 05:12:54 -0700 (PDT)
Message-ID: <20230728120930.111031350@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=t8GxhNF6HGOaqAPuRwkda5YYxZL4VSRyQt8u47FAxec=;
        b=IOXoiWw+rOTs13GC6sSM/dyeIKF5LXtjixTLgtq62v7HiRGIsOqObtivsD+0nuwNHz3oX4
        PtQwaF43W87MMuaAnlaDrGJaut5iJzivv0Z/12NAQNTinOBxKREE/SwxQEev35ACWDu+3f
        ZfQTHUEIfQKodJG0iyhaYlYmKLvNQEEYor2tb376hAy32piCmFraxKQ1N3EJG9vCNnX4c7
        Mo5gYN7OQL6TG0p1Q7ac1gnaZrDLK/nUYjW0sKyuTaFEI8MGJrfBb3Td3V6ev9Xf28aKlE
        c/+aSATN5IGRwg6W1NMVolraSzR1Fjpe6gFEOm3whqQuurOpbKRf7CWPPX2VrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=t8GxhNF6HGOaqAPuRwkda5YYxZL4VSRyQt8u47FAxec=;
        b=snq8KALad7v+S/vb1OXyySj9T7QIYG3Rub8YXGB69qbicSWOiMfWL4dO6s4YWrhGO9kNnd
        mtRPiKcVTOqZ2XAg==
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
Subject: [patch v2 08/38] x86/cpu: Remove pointless evaluation of
 x86_coreid_bits
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:12:52 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cpuinfo_x86::x86_coreid_bits is only used by the AMD numa topology code. No
point in evaluating it on non AMD systems.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/intel.c   |   13 -------------
 arch/x86/kernel/cpu/zhaoxin.c |   14 --------------
 2 files changed, 27 deletions(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -488,19 +488,6 @@ static void early_init_intel(struct cpui
 		setup_clear_cpu_cap(X86_FEATURE_PGE);
 	}
 
-	if (c->cpuid_level >= 0x00000001) {
-		u32 eax, ebx, ecx, edx;
-
-		cpuid(0x00000001, &eax, &ebx, &ecx, &edx);
-		/*
-		 * If HTT (EDX[28]) is set EBX[16:23] contain the number of
-		 * apicids which are reserved per package. Store the resulting
-		 * shift value for the package management code.
-		 */
-		if (edx & (1U << 28))
-			c->x86_coreid_bits = get_count_order((ebx >> 16) & 0xff);
-	}
-
 	check_memory_type_self_snoop_errata(c);
 
 	/*
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -65,20 +65,6 @@ static void early_init_zhaoxin(struct cp
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 	}
-
-	if (c->cpuid_level >= 0x00000001) {
-		u32 eax, ebx, ecx, edx;
-
-		cpuid(0x00000001, &eax, &ebx, &ecx, &edx);
-		/*
-		 * If HTT (EDX[28]) is set EBX[16:23] contain the number of
-		 * apicids which are reserved per package. Store the resulting
-		 * shift value for the package management code.
-		 */
-		if (edx & (1U << 28))
-			c->x86_coreid_bits = get_count_order((ebx >> 16) & 0xff);
-	}
-
 }
 
 static void init_zhaoxin(struct cpuinfo_x86 *c)

