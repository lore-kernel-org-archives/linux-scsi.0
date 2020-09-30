Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DA8C4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 19:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173DE20BED
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 19:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgI3TD5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 15:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgI3TD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 15:03:57 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 209177] mpt2sas_cm0: failure at
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
Date:   Wed, 30 Sep 2020 19:03:56 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sun.nagarajan@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: drivers_other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209177-11613-WZq3yVtVNs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209177-11613@https.bugzilla.kernel.org/>
References: <bug-209177-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209177

--- Comment #3 from sun.nagarajan@gmail.com ---
(2020-09-30): Suganath Prabu Subramani suggested the following:

From log, I could see that the HBA queue depth is very high "32455" as
shown below.

[   11.465416] mpt2sas_cm0: hba queue depth(32455), max chains per io(128).

In this patch "https://patchwork.kernel.org/patch/11505139/" driver is
allocating the DMA-able memory for RDPQ's in sets of 16 reply queues using
limitation of Ventura series controller.

With 32455 queue depth and above patch, Driver may request a large DMA-able
memory where the kernel may fail to allocate.

To confirm this, Please try by tuning the queue depth to 8000/10000 using the
module parameter "mpt3sas.max_queue_depth=10000".

With the same unmodified 5.8.12 kernel, boot completed with no errors.

Attaching dmesg.mpt3sas.max_queue_depth.20200930

-- 
You are receiving this mail because:
You are on the CC list for the bug.
