Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E7EC5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 15:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACA921D7B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 15:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfKGP6u convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 10:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbfKGP6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Nov 2019 10:58:49 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 205461] New: Power-On-Reset Prevents Successful Receive
 Diagnostics Command in SES Module.
Date:   Thu, 07 Nov 2019 15:58:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ssiwinski@attotech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-205461-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205461

            Bug ID: 205461
           Summary: Power-On-Reset Prevents Successful Receive Diagnostics
                    Command in SES Module.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: ssiwinski@attotech.com
        Regression: No

Created attachment 285817
  --> https://bugzilla.kernel.org/attachment.cgi?id=285817&action=edit
Power-On-Reset Prevents Successful Receive Diagnostics Command

Overview:

When booting an SES device connected to an ATTO SAS HBA, the SES module issues
a 'Receive Diagnostics' command that fails with check condition power-on-reset
and is not retried by the SES module.

Interestingly, when booting an SES device connected to an LSI SAS HBA, the
Receive Diagnostics succeeds due to LSI issuing a 'Mode Sense' command prior to
the SES module sending the 'Receive Diagnostics' that clears the check
condition power-on-reset.

Us (ATTO) does not want to have to issue a command to clear the check condition
power-on-reset unless we must. There is no spec that states this is what must
happen and seems to be a case that the SES module should handle.


Steps to Reproduce:

With an ATTO SAS HBA:
Connect an SES device to an ATTO SAS HBA, then power on the SES device. 

With an LSI SAS HBA:
I was able to reproduce this issue with an LSI SAS HBA and other SAS HBAs by
unloading the SES module, issuing a target reset to the SES device, then
re-loading the SES module.


Actual Results:

In the system log you will see

[  953.809858] scsi 7:0:0:0: Power-on or device reset occurred
[  953.809891] scsi 7:0:0:0: Failed to get diagnostic page 0x1
[  953.809931] scsi 7:0:0:0: Failed to bind enclosure -19

This can also be observed in the "sas_poweron_atto.scs" SAS trace.


Expected Results:

The Receive Diagnostics command to succeed and no error logged to the system
log.

This can also be observed in a SAS trace of an SES device connected to an LSI
HBA, where the 'Receive Diagnostics' command succeeds due to the check
condition power-on-reset being cleared by the 'Mode Sense' command issued prior
to the 'Receive Diagnostics'. (Trace can be provided upon request).


Additional Information:

It appears that I cannot attach SAS traces from both ATTO and LSI devices, so I
have attached the trace while connected to an ATTO SAS HBA that clearly
exhibits the error. If both traces are needed, I can provide them by a
different means.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
