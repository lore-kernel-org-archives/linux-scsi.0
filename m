Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605D6C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43AFC20760
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="P4a9ROh3";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="J239Wtw/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgF1SdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 14:33:04 -0400
Received: from chalk.uuid.uk ([51.68.227.198]:40200 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgF1SdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 14:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UPP6gukaexX7wrM9u2+d3aN4JoGVQpabllHG+ax6iC4=; b=P4a9ROh3EPZ966cceO9uIr/ws4
        cDjT6wFy2mZK16+McYwR6V2meWKZnRos4gDdqFtHHK1NgieFeWY7AcIjwBuuJ+yvQ1cIu6PL6HpxQ
        8ccl7drgd1QlDxQ6LTsNBZOO+AWUbKkJUafMCzlgUh6GfyhejyX+Ro+vIjaU6O5PH8zo4zGXd3hVT
        yTJLgsDhAEiEb6BmRLO7Hhcmnc5wt++BZfK0C4CX7RFJKRnZM6ueidsTGEEk0xwUw+2gMlwu12Spk
        GfTktW4C0vFrx/Pfy19GAD33MAxwYrdOhgPAoKVW1ezoC1HGXqKqnMqlGWDqSeRSWrwFIBDKiT055
        N2DtURQw==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jpc6n-0000Az-GF; Sun, 28 Jun 2020 19:32:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Cc:To:Subject:From;
        bh=UPP6gukaexX7wrM9u2+d3aN4JoGVQpabllHG+ax6iC4=; b=J239Wtw/GzbBYC7vjs9SccvUos
        55kndDxz5eavZKN9YFL/4IP/RN9xYySYmti/9USnJV3w11a22cDcApC7BsHV6Mmr9lC3j2i1CuiQ8
        m9wSZGf04FS+0NZjwkqFTL40sWMFOBLdFbeh+wZe7ujZfTUdEkk91/mvQQA2oSSyZEwAq3a1A9uhB
        vFzy8a2JSc6PLU+8zYrR1DiCva7SOUrAzyx6HNHN4aeSmy2mh5+JABmTvI4A5hKmIgqu+0y+7auS3
        TQdx8RHQeotalH8cuT+e7XUJw/v0LTEaThVprjb3KLBItucosPEmPkt4iv7xQh9wq+BKq7vyBOKqt
        28bISPSw==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jpc6l-0007Oy-Kv; Sun, 28 Jun 2020 19:32:52 +0100
From:   Simon Arlott <simon@octiron.net>
Subject: [PATCH (v2)] scsi: sd: add parameter to stop disks before reboot
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Message-ID: <e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sun, 28 Jun 2020 19:32:51 +0100
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

Add a "stop_before_reboot" module parameter that can be used to control
the shutdown behaviour of disks before a reboot. The default will be
the existing behaviour (disks are not stopped).

  sd_mod.stop_before_reboot=<integer>
    0 = disabled (default)
    1 = enabled

The behaviour on shutdown is unchanged: all disks are unconditionally
stopped.

Signed-off-by: Simon Arlott <simon@octiron.net>
---
 Documentation/scsi/scsi-parameters.rst |  5 +++++
 drivers/scsi/sd.c                      | 14 +++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/scsi-parameters.rst
index 9aba897c97ac..324610870de5 100644
--- a/Documentation/scsi/scsi-parameters.rst
+++ b/Documentation/scsi/scsi-parameters.rst
@@ -101,6 +101,11 @@ parameters may be changed at runtime by the command
 			allowing boot to proceed.  none ignores them, expecting
 			user space to do the scan.
 
+	sd_mod.stop_before_reboot=
+			[SCSI] configure stop action for disks before a reboot
+			Format: <integer>
+			0 = disabled (default), 1 = enabled
+
 	sim710=		[SCSI,HW]
 			See header of drivers/scsi/sim710.c.
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..506904bf15da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -98,6 +98,12 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
+static unsigned int stop_before_reboot = 0;
+
+module_param(stop_before_reboot, uint, 0644);
+MODULE_PARM_DESC(stop_before_reboot,
+		 "stop disks before reboot");
+
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
@@ -3576,9 +3582,11 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp, NULL);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
-		sd_start_stop_device(sdkp, 0);
+	if (sdkp->device->manage_start_stop) {
+		if (system_state != SYSTEM_RESTART || stop_before_reboot) {
+			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+			sd_start_stop_device(sdkp, 0);
+		}
 	}
 }
 
-- 
2.17.1

-- 
Simon Arlott
