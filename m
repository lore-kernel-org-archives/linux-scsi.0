From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16981] New: 2.6.36-rc1
Date: Tue, 24 Aug 2010 20:02:32 GMT
Message-ID: <bug-16981-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50058 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0HXUCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 16:02:33 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7OK2WeO014324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2010 20:02:32 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16981

           Summary: 2.6.36-rc1
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.36-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: tv@fuzzy.cz
        Regression: No


Created an attachment (id=27851)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27851)
error when runing tune2fs on a LVM2/MD partition

After executing a tune2fs on a partition (LVM2 on top of an md-based raid1
device, with an ext3 filesystem on top of it), the kernel crashes - the
messages are available in the tune2fs.log attachment, the most interesting one
references a drivers/scsi/scsi_lib.c:1113.

When executing the same tune2fs command on a simple partition everything seems
to work fine, as well as when running it under an older kernel
(2.6.32-gentoo-r7).

I received a very similar error (on the same device, referencing the same piece
of code in scsi_lib.c) when running a filesystem check during boot (due to
reaching a predefined number of mounts). See the attachment 'boot.log'. Again,
this works under the older kernel.

I haven't tried the 2.6.36-r2 version (yet).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
