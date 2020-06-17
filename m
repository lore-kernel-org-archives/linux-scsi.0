Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CB0C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 18:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CBE206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 18:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="jIlPqCad";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="YrkV8arW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgFQSuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 14:50:13 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:38588 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 14:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ewfhDKKfirLitYkJROxTzREvtN9Z3svV6HuKAzBz5NY=; b=jIlPqCadnZCOcMUWh4u/CTqQhi
        EH0zl9OabqyC2bInmjRLrgQeKll0B4holKyNI6PoZF/dKbGFCaPi9xZ0xPLrDrBq6e+mTsURhmr5W
        oqF3P4SWjtR/gPIFLL3ngSwx1b4+qlI7mKc2yhuGAxtjghSlSTkoLQvPyASIWNx4R1d11oFW9/dhH
        re24nrAetgrW/cnLYMM+1g7MpBLEANkMP6czip6lQdijIq63XbbFk3Jr+mdyT45qzhW/kXKwwPlFY
        V0VagrpCTnPh6QT4dCmY9hmCEI+oie0PwndbSq1nBfzilu5kIQCiqGJnxdEwMnH75JfMe2aNg/VWX
        bws7YBMw==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jld8L-0007kd-Mh; Wed, 17 Jun 2020 19:50:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To; bh=ewfhDKKfirLitYkJROxTzREvtN9Z3svV6HuKAzBz5NY=;
         b=YrkV8arWRnPaoaVVWFFpJUon2CJzTo8EWW/5dNaLDNQog1Xr3/zWJP73sh0mAQjflWg8nvtTbJ
        9aqvhKCWTZfULTv4vmF0MkCVNm9uG3/++jeZ6Rta9XoOrGZHM2+uuAbNjdEHIPc0m0v60K6WBwz0t
        ypKLgn6FXhc2WZ9tGsNkoC2P0ADW0ZWvJ+JIjciy2DDv9apHvXgPv+N5AZBcPs9I4NfYEQcRMXHRh
        Gc6baFVOhXM6DVamcGu86jsXlN+hb0krRiuWc7AWUrb+wXQ1idjAcwmdjj9YWs58cxtujdesJb2RN
        usdgu3CJHBFrxORGy3KItUp1y9WP/XP4qRMcA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jld8I-0005LZ-1O; Wed, 17 Jun 2020 19:49:58 +0100
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
From:   Simon Arlott <simon@octiron.net>
Subject: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Wed, 17 Jun 2020 19:49:57 +0100
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
every reboot, which is undesirable behaviour. These events are recorded
in the SMART attributes.

Avoiding a stop of the disk on a reboot is appropriate for HDDs because
they're likely to continue to be powered (and should not be told to spin
down only to spin up again) but the default behaviour for SSDs should
be changed to stop them before the reboot.

Add a "stop_before_reboot" module parameter that can be used to control
the shutdown behaviour of disks before a reboot. The default will be
to stop non-rotational disks (SSDs) only, but it can be configured to
stop all disks if it is known that power will be lost completely on a
reboot.

  sd_mod.stop_before_reboot=<integer>
    0 = never
    1 = non-rotational disks only (default)
    2 = all disks

The behaviour on shutdown is unchanged: all disks are unconditionally
stopped.

The disk I/O will be mostly quiescent at reboot time (and there is a
sync first) but this should be added to stable kernels to protect all
SSDs from unexpected power loss during a reboot by default. There is
the potential for an unexpected power loss to corrupt data depending
on the SSD model/firmware.

Cc: stable@vger.kernel.org
Signed-off-by: Simon Arlott <simon@octiron.net>
---
 Documentation/scsi/scsi-parameters.rst |  7 +++++++
 drivers/scsi/sd.c                      | 22 +++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/scsi-parameters.rst
index 9aba897c97ac..fd64d0d43861 100644
--- a/Documentation/scsi/scsi-parameters.rst
+++ b/Documentation/scsi/scsi-parameters.rst
@@ -101,6 +101,13 @@ parameters may be changed at runtime by the command
 			allowing boot to proceed.  none ignores them, expecting
 			user space to do the scan.
 
+	sd_mod.stop_before_reboot=
+			[SCSI] configure stop action for disks before a reboot
+			Format: <integer>
+			0 = never
+			1 = non-rotational disks only (default)
+			2 = all disks
+
 	sim710=		[SCSI,HW]
 			See header of drivers/scsi/sim710.c.
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..1cd652e037ab 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -98,6 +98,12 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
+static unsigned int stop_before_reboot = 1;
+
+module_param(stop_before_reboot, uint, 0644);
+MODULE_PARM_DESC(stop_before_reboot,
+		 "stop disks before reboot (1=non-rotational, 2=all)");
+
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
@@ -3576,9 +3582,19 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp, NULL);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
-		sd_start_stop_device(sdkp, 0);
+	if (sdkp->device->manage_start_stop) {
+		bool stop_disk = (system_state != SYSTEM_RESTART);
+
+		if (stop_before_reboot > 1) { /* stop all disks */
+			stop_disk = true;
+		} else if (stop_before_reboot) { /* non-rotational only */
+			stop_disk |= blk_queue_nonrot(sdkp->disk->queue);
+		}
+
+		if (stop_disk) {
+			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+			sd_start_stop_device(sdkp, 0);
+		}
 	}
 }
 
-- 
2.17.1

-- 
Simon Arlott
