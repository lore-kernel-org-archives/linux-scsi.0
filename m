Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4A0C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 12:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbjG1MRH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235946AbjG1MQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 08:16:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC4F35A8;
        Fri, 28 Jul 2023 05:13:31 -0700 (PDT)
Message-ID: <20230728120931.616473086@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690546406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=NtDDi1Qa1O0ardBTEkM6u4SIs1c9Ae4E5SceZDfIb58=;
        b=r87HcYXC5VxwN7lbT21rEN+fOrq6p9RZR9jq9xgY23KLboCkbYvRaOvyeLpMjDRMfD5ZF6
        1anYC5E3KWrOuiG3eaZqMl6ijI5DTMNkaUSvM9cspDeBbhpNWeRJDUKwSIUTCa8CIjHt1C
        OU1tOSBC8Wxfh5mPJv9Nvb2oTf6t4pRvPAIhDZcXlTvQkOyKYeVKJp0V4+/JtKHi7DBovV
        ZbtLiJ2pSom2S9SHRShsPvHnWZLOeQsJMV8eNhjHZ0t024HZYlM3ElU2MLSsO9eVjsVWhU
        3+L2abxm9S7ZYYGzSlvHs5tyPzMQwt4fmRPfLW/la5lgYYXKKbi8JkTOVJ4Y9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690546406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=NtDDi1Qa1O0ardBTEkM6u4SIs1c9Ae4E5SceZDfIb58=;
        b=1fikPVLwoXhP6UJ3Yl4j8y9VSSWMxgdqWAWyyU2l/Hw2ZGVO0gDKpk1EbZrXil9Xkd9Brn
        GWJdyJyW7BwL2rBA==
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
Subject: [patch v2 35/38] x86/cpu: Remove x86_coreid_bits
References: <20230728105650.565799744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 14:13:26 +0200 (CEST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No more users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/processor.h |    2 --
 arch/x86/kernel/cpu/common.c     |    1 -
 2 files changed, 3 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -119,8 +119,6 @@ struct cpuinfo_x86 {
 #endif
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
-	/* CPUID returned core id bits: */
-	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
 	__u32			extended_cpuid_level;
 	/* Maximum supported CPUID level, -1=no CPUID: */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1712,7 +1712,6 @@ static void identify_cpu(struct cpuinfo_
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
-	c->x86_coreid_bits = 0;
 #ifdef CONFIG_X86_64
 	c->x86_clflush_size = 64;
 	c->x86_phys_bits = 36;

