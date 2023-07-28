Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0483EC04A94
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbjG1MRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbjG1MQ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:16:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB0C4C3C;
        Fri, 28 Jul 2023 05:13:53 -0700 (PDT)
Message-ID: <20230728120931.725126693@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=dCJ675XRBN0nH/FVG6be5pN6/XKm3FLkxuXqtWJHHNE=;
        b=fVICMZBMeAB3LJx89czNoWL6pf/02XOmngVd1QmHmO03PyVsHJhQVG4ROl8TxW7toESKtk
        8rCcgi8b/nV4IZGR7TMnN0MVwdlEQq+M60OkMIHGjhbNQ8APBhjJFcS9bbUibc8VtTHVId
        /TeWcfYHuzr8zIrut1w9NuvOwuhLxnFjhWd8MNj5ZoU+IpFwXHym50B+EQmDriJdJQiyOi
        F6jQZPBV75O0i9rZ8xNjsqcZkVbYlBvYicVQAjIqNmyC+VlxT8SGIurCaNUWGremjgExEf
        vtvEptqjv05bo0gu8Ge9lv4jtA6WLYvqS4JF8v1JKnjXo9o+mNHx6Vkry9MW+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=dCJ675XRBN0nH/FVG6be5pN6/XKm3FLkxuXqtWJHHNE=;
        b=JRqEBwF7tvlV9Cp1QN4pPZV2BzwgbiRZ2sfwBEgY5aXWT2gA6p6elfdQVttsoMpJ0YwHeK
        9XUNsE++KH4SlwAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Huang Rui <ray.huang@amd.com>, Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>
Subject: [patch v2 37/38] x86/xen/smp_pv: Remove cpudata fiddling
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:13:28 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new topology CPUID parser installs already fake topology for XEN/PV,
which ends up with cpuinfo::max_cores = 1.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
---
V2: New patch
---
 arch/x86/xen/smp_pv.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -73,7 +73,6 @@ static void cpu_bringup(void)
 	}
 	cpu = smp_processor_id();
 	smp_store_cpu_info(cpu);
-	cpu_data(cpu).x86_max_cores = 1;
 	set_cpu_sibling_map(cpu);
 
 	speculative_store_bypass_ht_init();
@@ -223,8 +222,6 @@ static void __init xen_pv_smp_prepare_cp
 
 	smp_prepare_cpus_common();
 
-	cpu_data(0).x86_max_cores = 1;
-
 	speculative_store_bypass_ht_init();
 
 	xen_pmu_init(0);

