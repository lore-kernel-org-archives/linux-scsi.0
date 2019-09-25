Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65598C432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 18:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345192146E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 18:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440199AbfIYSLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:11:13 -0400
Received: from h3.fbrelay.privateemail.com ([131.153.2.44]:60585 "EHLO
        h3.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439904AbfIYSLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Sep 2019 14:11:13 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 14:11:12 EDT
Received: from MTA-08-4.privateemail.com (mta-08.privateemail.com [68.65.122.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 1FCB380B25
        for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2019 14:03:24 -0400 (EDT)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id CFA3A60056;
        Wed, 25 Sep 2019 14:03:22 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.218])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id 50AD860038;
        Wed, 25 Sep 2019 18:03:22 +0000 (UTC)
From:   Ryan Attard <ryanattard@ryanattard.info>
To:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH 00/01] scsi: Add sysfs attributes for VPD pages 0h and 89h
Date:   Wed, 25 Sep 2019 13:02:51 -0500
Message-Id: <20190925180251.49980-1-ryanattard@ryanattard.info>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As an application developer, vpd_pg83/vpd_pg80 have been extremely helpful, and having access to that data without issuing a command to hardware significantly reduces the the chance for hung tasks to a storage management application. Having access to the ATA Information page (page 89h) would be similarly useful for information about ATA inquiry data. 

Identifying ATA models can be troublesome.  /sys/block/sda/device/model is not the ATA model. vpd_pg80 returns the SCSI model, however the ATA specification defines the model with a different length (16 vs 20 bytes). This leaves 4 bytes of model information truncated in vpd_pg80 by the SAT layer.  Extending the length of the model attribute in the kernel is not sufficient for resolving the issue. This information can be retrieved in full from the ATA Information page. 

I would prefer that the /model attribute was correct, however modifying its contents is a user impacting change, and would requiring parsing information from the ATA Identify page. This patch was more straightforward and had no backwards compatibility impacts, since it leverages existing paths for the vpd_pg80/vpd_pg83 attributes.

For those that prefer positive indicators that vpd_pg89 is available before attempting the read (and to cross-correlate between it and the vendor field),  I included vpd_pg0.  

There’s a few mechanisms for determining ATA models in userspace today: 
1. Issue sg_sat_identify
2. Issue sg_vpd -p 0x89 
3. Rely on udev attributes sourced by ata_id 

Performing inquiries on disks can be expensive, and requires special handling in the cases of ailing hardware. For all the same reasons it helps to have vpd_pg80 and 83 for this application, having page 89 is equally as valuable.

ata_id has some open issues, and is being only minimally maintained by systemd[1], forcing applications interested in basic information about ATA drives in those situations to perform additional inquiries. ata_id and udev rules in general suffer from problems where the cascading behavior of the rules can trigger incorrect attribute population in some cases (eg, ata_id fails for an unrelated reason, and the device gets scsi_id attributes instead). 

The maintainers of sg3-utils have a pending udev ruleset to eliminate scsi_id, which suffers similarly as ata_id from being abandoned[2].   That udev ruleset does not eliminate the usage of ata_id, and despite a comment does issue an inquiry to the drive[3][4]. This patch compliments the rules file for SCSI disks, which bypasses the drive inquiry in favor of reading the sysfs attributes, vpd_pg80 and vpd_pg83. [5]

In some discussion with colleagues, there was pushback that this is just an application architecture problem - “just cache this data in the application”.  Userspace applications come in many forms that may be short or long lived, caching this data in the kernel for the length of the scsi_device structure provides better granularity for applications that are heavy users of sysfs: rather than racing between multiple data sources, applications can then leverage only sysfs for this information. This also opens up better authored udev rules which are short lived.  

The ATA Information VPD page is included in SPC-4 and above, with support for ATA based ZBC devices in SPC-5. It is reserved in all prior versions. SPC-4 is relatively widespread from what I’ve seen, with even some of the oldest disks I could find supporting SPC-4 (an ancient Hitachi Deskstar from 2009), and those supporting SPC-3 (nearly same age Seagate Constellation) having support for the ATA Information VPD page. 

Testing:

I tested this patch with both the 5.1 and 4.14 kernel series, on a system with a AHCI controller for one SATA drive, and a LSI 9207-8i with SATA and SAS drives. All devices expose the vpd_pg89 field, with SAS drives returning EINVAL on read as expected.  I used a mix of Intel and Seagate drives for verification.  

[1] systemd is not actively maintaining hardware utilities including ata_id: https://github.com/systemd/systemd/pull/2500#issuecomment-178071901 -> https://github.com/systemd/systemd/pull/2665#issuecomment-186190469 -> https://github.com/systemd/systemd/pull/2500#issuecomment-186200195 -> https://github.com/systemd/systemd/issues/2362#issuecomment-178079214
[2] Rules being implemented to replace scsi_id: https://github.com/systemd/systemd/pull/7594
[3] sg3-utils comment indicating that it does not intend to read from the device: https://github.com/systemd/systemd/pull/7594/files#diff-0339411185b16666d3485e680b9c5c73R8
[4] ata_id source: https://github.com/systemd/systemd/blob/master/src/udev/ata_id/ata_id.c#L60
[5] Usage of vpd_pg83 in sg3-utils rules: https://github.com/hreinecke/sg3_utils/blob/master/scripts/55-scsi-sg3_id.rules#L57 


