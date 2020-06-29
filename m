Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EC7C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16FB206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="uDTAUHYk";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="ZyQuEkue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbgF2U6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:58:51 -0400
Received: from papylos.uuid.uk ([185.34.62.16]:45246 "EHLO papylos.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390034AbgF2U6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 16:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QZn0IrZuxQfhjmsYI3ZeDKt3ibvyYsk7PKBiuKuD+U4=; b=uDTAUHYkNjHnJ24CM7NMVSNC0C
        IwKlQO/dwRi3ap5GdN8NFpakYQ4/eMsrVyAJqwieACJAVclDPCjT2d5HKui3IjeRjMdy8XeyaSJdT
        JHcMZumnHCrYPhSK2khvipzGWr0Q0OsT82fZr5mID8waRFNptL0id5RGl+vYHtVVkCqEF+ccT5Mvf
        rzsaKftg+d2TXBNK5Xi7E4uxw577i3SUV4MteIZMoF5rWZPKztTov/19DEZmn5pWtLZ3cfNyXTHJc
        3NdriU96lyz6RyQNmkfQZGaJTWfOj6Jn0wuzpP1M+1SmwZAT8fD5ASUUJhADo0mT33/GLTo68W8uy
        jQiPfKFA==;
Received: by papylos.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jq0qx-00016p-EZ; Mon, 29 Jun 2020 21:58:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=QZn0IrZuxQfhjmsYI3ZeDKt3ibvyYsk7PKBiuKuD+U4=; b=ZyQuEkuePidvKc2wCdQgtzokgj
        +3rqSqIfCS7FFwSiIKjKYLpTPjds3nJzx4CkLa1TX7DKjSafDp9kvXwazGP19M10UPl29khV+C2us
        DDVR/5aA5hKRSqBDChMfW19mFBzR8O4/jDNQm/E3COM26WL7iPmTFVkrhq4H0AqRGIu/vNTgsjzWr
        mbd5k9fXT2X3ee9OkzQ+s1Uf5Wek+8a244z+vH9VmNibQRKRlYw2wqSNDZZMtLKu4qTe32vmCuzCM
        HHzuFFC78kskYxYH4K4xDTfF4jBnNSsf6Z1AuUPhEvauoYjzbI9Tc9EDIEuF3Mkt4Ckph/7KyXYeD
        OkxcZWRw==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jq0qr-0008H5-5u; Mon, 29 Jun 2020 21:58:08 +0100
Subject: [PATCH 2/2] x86/reboot/quirks: Add ASRock Z170 Extreme4
From:   Simon Arlott <simon@octiron.net>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Message-ID: <a7c26ca1-0201-7526-8b69-484868725ee3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Mon, 29 Jun 2020 21:58:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a PCI mode reboot is performed on the ASRock Z170 Extreme4, a power
cycle will occur. Automatically set the reboot quirk for this to prepare
for the power off (i.e. stop all disks).

This will only take effect if PCI mode is manually used. It'll be too late
in the reboot process to prepare for power off if the other reboot methods
fail.

It is necessary to re-order the processing of DMI checks because this quirk
must apply even if a reboot= command line parameter is used as that's the
only way to specify a PCI mode reboot.

Signed-off-by: Simon Arlott <simon@octiron.net>
---
Previous patches to make scsi/sd stop before a reboot:
https://lore.kernel.org/lkml/499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe/
https://lore.kernel.org/lkml/e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe/

 arch/x86/kernel/reboot.c | 51 ++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0ec7ced727fe..a82d5db1c8ca 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -147,6 +147,13 @@ STACK_FRAME_NON_STANDARD(machine_real_restart);
  */
 static int __init set_pci_reboot(const struct dmi_system_id *d)
 {
+	/*
+	 * Only apply the DMI-based change if reboot_type hasn't been
+	 * overridden on the command line.
+	 */
+	if (!reboot_default)
+		return 0;
+
 	if (reboot_type != BOOT_CF9_FORCE) {
 		reboot_type = BOOT_CF9_FORCE;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
@@ -157,6 +164,13 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 
 static int __init set_kbd_reboot(const struct dmi_system_id *d)
 {
+	/*
+	 * Only apply the DMI-based change if reboot_type hasn't been
+	 * overridden on the command line.
+	 */
+	if (!reboot_default)
+		return 0;
+
 	if (reboot_type != BOOT_KBD) {
 		reboot_type = BOOT_KBD;
 		pr_info("%s series board detected. Selecting %s-method for reboot.\n",
@@ -165,6 +179,21 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init set_pci_power_cycle_reboot(const struct dmi_system_id *d)
+{
+	/*
+	 * This has to be applied even if reboot_type has been set on the
+	 * command line because that's the only way to enable PCI mode.
+	 */
+
+	if (reboot_type == BOOT_CF9_FORCE) {
+		reboot_quirks |= REBOOT_QUIRK_POWER_CYCLE;
+		pr_info("%s series board detected. Assume that a PCI reboot includes a power cycle.\n",
+			d->ident);
+	}
+	return 0;
+}
+
 /*
  * This is a single dmi_table handling all reboot quirks.
  */
@@ -247,6 +276,14 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_BOARD_NAME, "Q1900DC-ITX"),
 		},
 	},
+	{	/* PCI reboots cause a power cycle */
+		.callback = set_pci_power_cycle_reboot,
+		.ident = "ASRock Z170 Extreme4",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASRock"),
+			DMI_MATCH(DMI_BOARD_NAME, "Z170 Extreme4"),
+		},
+	},
 
 	/* ASUS */
 	{	/* Handle problems with rebooting on ASUS P4S800 */
@@ -494,13 +531,6 @@ static int __init reboot_init(void)
 {
 	int rv;
 
-	/*
-	 * Only do the DMI check if reboot_type hasn't been overridden
-	 * on the command line
-	 */
-	if (!reboot_default)
-		return 0;
-
 	/*
 	 * The DMI quirks table takes precedence. If no quirks entry
 	 * matches and the ACPI Hardware Reduced bit is set and EFI
@@ -508,6 +538,13 @@ static int __init reboot_init(void)
 	 */
 	rv = dmi_check_system(reboot_dmi_table);
 
+	/*
+	 * Only force EFI reboot if reboot_type hasn't been overridden
+	 * on the command line.
+	 */
+	if (!reboot_default)
+		return 0;
+
 	if (!rv && efi_reboot_required() && !efi_runtime_disabled())
 		reboot_type = BOOT_EFI;
 
-- 
2.17.1

-- 
Simon Arlott
