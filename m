Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A081CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3002073E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="UiVw7iCX";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="e9ofXEjO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbgF2U5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:57:39 -0400
Received: from chalk.uuid.uk ([51.68.227.198]:52730 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgF2U5g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 16:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:Cc:From:To:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+rLOlLyhvnP0f8oiGdEmdKJzbVAQvAR2f04vwtNycPY=; b=UiVw7iCXk5sZQYWfvPvaRktzpg
        f8FxSZLDsWaht/5ia9EPIFFj+/H+RyzbEd49rLwwgYgVsca2khq8wupvfcmiDODVw3vmnkTklFLU0
        dKodZuxzUKp+i9KNE6DiYBzO3fFHJr41VIl1SMZ6DzImbMnscvJsBqvsBYp26YGlm97Ljo65hbGur
        7cG04inkYugNldNfBuFVswsSTMPM5v49O4ScLpkqbPpAFxoUYqUb1gfGxE3OYEGR6kL1xBj9TFxz/
        BM8lspwxtb/qYIBMQE5QjaMZeROuw3vYewsOltABvOjXiBLtDwtwN13aR/k7hqw271gyOpdUeHx22
        J7P91tjA==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jq0pl-0000O4-5c; Mon, 29 Jun 2020 21:57:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:Cc:From:To;
        bh=+rLOlLyhvnP0f8oiGdEmdKJzbVAQvAR2f04vwtNycPY=; b=e9ofXEjOwK1Md4paqP/5no9yI9
        qdPejM1TrHUE0fQXeQkd76Q6S96ZdVfVHGLStwp23xjop+6PNG1vp013Csw1BWeoudxy6KGlfmAN+
        994tI2azKqNG9iy1XnS/JiuIjQRnu75sLufWqgVWyD//lPP19aleHUf1v5HPDVvI/yc/qgQTZBax2
        b6kk6Ci9EE0AOXUTuOiGIVJH6mBAEJ2CxxJSsaRwN+z3zGfxaBANpF4q6yYXbXrh8EmNpeCTm8Evk
        X51UsQZHj8x4h6PYC7dpePuXgtQGp8H8FCj2QlElOOTTfB3TiW9Zcr6ZxekwZTa5/JTcOS61l/ICC
        5n1og10A==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jq0pe-0008G2-10; Mon, 29 Jun 2020 21:56:55 +0100
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
From:   Simon Arlott <simon@octiron.net>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 1/2] reboot: add a "power cycle" quirk to prepare for a power
 off on reboot
Message-ID: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Mon, 29 Jun 2020 21:56:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I need to use "reboot=p" on my desktop because one of the PCIe devices
does not appear after a warm boot. This results in a very cold boot
because the BIOS turns the PSU off and on.

The scsi sd shutdown process does not send a stop command to disks
before the reboot happens (stop commands are only sent for a shutdown).

The result is that all of my SSDs experience a sudden power loss on
every reboot, which is undesirable behaviour because it could cause data
to be corrupted. These events are recorded in the SMART attributes.

Add a "power cycle" quirk to the reboot options to prepare all devices for
a power off by setting the system_state to SYSTEM_POWER_OFF instead of
SYSTEM_RESTART while still performing a restart as requested.

This uses the letter "C" for the parameter because of numerous uses of
"reboot=pci" that would otherwise trigger this behaviour if "c" was used.

Signed-off-by: Simon Arlott <simon@octiron.net>
---
Previous patches to make scsi/sd stop before a reboot:
https://lore.kernel.org/lkml/499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe/
https://lore.kernel.org/lkml/e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe/

 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++--
 include/linux/reboot.h                          |  4 ++++
 kernel/reboot.c                                 | 15 ++++++++++++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bee3b83d6f84..91359fd4fbcc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4422,9 +4422,10 @@
 	reboot=		[KNL]
 			Format (x86 or x86_64):
 				[w[arm] | c[old] | h[ard] | s[oft] | g[pio]] \
-				[[,]s[mp]#### \
+				[[,]s[mp]####] \
 				[[,]b[ios] | a[cpi] | k[bd] | t[riple] | e[fi] | p[ci]] \
-				[[,]f[orce]
+				[[,]f[orce]] \
+				[[,]C]
 			Where reboot_mode is one of warm (soft) or cold (hard) or gpio
 					(prefix with 'panic_' to set mode for panic
 					reboot only),
@@ -4432,6 +4433,9 @@
 			      reboot_force is either force or not specified,
 			      reboot_cpu is s[mp]#### with #### being the processor
 					to be used for rebooting.
+			Quirks:
+				C = Rebooting includes a power cycle, prepare
+				    for a power off instead of a restart.
 
 	refscale.holdoff= [KNL]
 			Set test-start holdoff period.  The purpose of
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 3734cd8f38a8..b49559ba825a 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -39,6 +39,10 @@ extern int reboot_default;
 extern int reboot_cpu;
 extern int reboot_force;
 
+#define REBOOT_QUIRK_POWER_CYCLE                BIT(0)
+
+extern int reboot_quirks;
+
 
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 491f1347bf43..5605c2894f2b 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -45,6 +45,7 @@ int reboot_default = 1;
 int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
+int reboot_quirks;
 
 /*
  * If set, this is used for preparing the system to power off.
@@ -71,7 +72,15 @@ EXPORT_SYMBOL_GPL(emergency_restart);
 void kernel_restart_prepare(char *cmd)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
-	system_state = SYSTEM_RESTART;
+	if (reboot_quirks & REBOOT_QUIRK_POWER_CYCLE) {
+		/*
+		 * The reboot will include a power cycle, so prepare all
+		 * devices for a power off.
+		 */
+		system_state = SYSTEM_POWER_OFF;
+	} else {
+		system_state = SYSTEM_RESTART;
+	}
 	usermodehelper_disable();
 	device_shutdown();
 }
@@ -583,6 +592,10 @@ static int __init reboot_setup(char *str)
 		case 'f':
 			reboot_force = 1;
 			break;
+
+		case 'C':
+			reboot_quirks |= REBOOT_QUIRK_POWER_CYCLE;
+			break;
 		}
 
 		str = strchr(str, ',');
-- 
2.17.1

-- 
Simon Arlott
