Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46892C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B2F246AF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgASAqt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgASAqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jan 2020 19:46:49 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 206253] New: mpt3sas driver crash under heavy load
Date:   Sun, 19 Jan 2020 00:46:48 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: itoufiqu@uci.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-206253-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206253

            Bug ID: 206253
           Summary: mpt3sas driver crash under heavy load
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.10.0-957.27.2.el7.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: itoufiqu@uci.edu
        Regression: No

Created attachment 286877
  --> https://bugzilla.kernel.org/attachment.cgi?id=286877&action=edit
console screenshot

Hi guys, 

I am new to this site, so if this problem is a repeat, my apology in advance.

I have a Dell R7425 server with dual AMD EPYC-7301 CPUs, 256GB of RAM, with
dual SAS 3008 cards. OS is centOS 7.6.  

I have 60-bay JBOD connected to these 2 HBA cards, all bays are full with HGST
SAS 10TB drives.  We run BeeGFS (with ZFS at the backend) in this system.  This
is a brand new setup and we noticed that under heavy load after a while , the
system completely freezes up.  It then needs a hard reboot.  I ran starce-ng
for 2 days on the CPUs and RAM, the system was stable.  I torture tested the
boot drives as well for 2 days, nothing came out.  Everything seems normal. 
the problem seems come in when we start stressing the drives in the JBOD,
connected with the HBA card. I have the system configured with dual connected
multipath ( roound-robin ) between both of the HBA cards and primary and
secondary SAS expanders of the of JBOD.

Since this is a Dell server, I went to Dell's support website, and found a
newer mpt3sas driver and installed it.  OS installed driver version was
16.100.01.00 , and updated version now is 27.00.01.00 .

This morning, the system hung again, and I was able to capture something from
the console.  I have attached the screenshot.  

The error was, mpt3sas_cm0 fault_state(0x5854!)

Below is the current modinfo output ( in brief ) from the current mpt3sas
driver:

filename:      
/lib/modules/3.10.0-957.27.2.el7.x86_64/kernel/drivers/scsi/mpt3sas/mpt3sas.ko.xz
alias:          mpt2sas
version:        27.00.01.00
license:        GPL
description:    LSI MPT Fusion SAS 3.0 & SAS 3.5 Device Driver
author:         Broadcom Inc. <MPT-FusionLinux.pdl@broadcom.com>
retpoline:      Y
rhelversion:    7.6
srcversion:     26E62E1FFC69FC8709F8CD7



I have no idea what to do here.  What can I do to fix this issue? Do I need a
special configuration?  A new driver? Our file servers are usually under
moderate to high load.  We have a 1.6PB system here ( BeeGFS + ZFS at the
backend ), with CentOS 6.9.  that system run pretty solid without much hiccup. 
that system also has a HBA 3008 card.

Thanks.

-- 
You are receiving this mail because:
You are the assignee for the bug.
