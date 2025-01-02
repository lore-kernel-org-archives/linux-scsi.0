Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB17634
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735779449; cv=none; b=Ux52EL2uyh8soJBtwAsdXG6hORoWSicolrKlct/3hFa1Rwr6J5a7t0jd3pLzXcG4XbH4n9rulWCROy7l1NvX/8zr8Ne0IfdiKNZ7ovGnb4rxAyIi2L88+nZ7AKzqnoUfLpSOf90TiyRk1/1JRpqQqC+aqUs/nWCNS/H6J59eDTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735779449; c=relaxed/simple;
	bh=uqmzDVcI+oeNZ1BNPFM62KKBYEeLvNFdmvktCMLMqDM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XUVT+VCX3EuUo02ZhnstA3RNwS9Fq8WJUfXm7VuV75178i4+BEydYXmFYoOKef929wT6WyoymfsifJdWsxnbkeL/nLEbWTLzy+xpNPGVnC6Ss6uvaakPROqxS72YAeWjh9m4XxOnEADQuzi37dz7I102UXGmk6uaJmvye2bzwg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyh56j3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyh56j3X"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52DEBC4CEDD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735779447;
	bh=uqmzDVcI+oeNZ1BNPFM62KKBYEeLvNFdmvktCMLMqDM=;
	h=From:To:Subject:Date:From;
	b=hyh56j3Xe3+2qXPQs2xQmUtf+wKgyMxLOd8FJMLZJOjncYY5wI8n91BITFGlBzKaH
	 vXCDzfmg5UVNn0curlc9tR2cKtJKkM95ocLBkC5FtuY96lZPSupciYT/8+I9MPfumm
	 aTof8vle6QOsEoYujhuKkWiuHiifrSxUPdLVCG9RQieB/ljgWXxgxLNwzTSrmQxVKP
	 WuDiIf0QtLvveW75X1oIyktk04jGMgf2d9XZrstviM/0bgnPDefv584d7q1jvuZHnB
	 fnTox6TWSO9JrpZcMhv3C5h/2uuvhPvYMrp0c9Rycxywl2acbfVRHkNGhbdBNiwWvL
	 ecsLdEthRB7wQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 425F2C41614; Thu,  2 Jan 2025 00:57:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219652] New: READ CAPACITY(16) not used on large USB-attached
 drive in recent kernels
Date: Thu, 02 Jan 2025 00:57:26 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugs-a21@moonlit-rail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter cc
 cf_regression attachments.created
Message-ID: <bug-219652-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219652

            Bug ID: 219652
           Summary: READ CAPACITY(16) not used on large USB-attached drive
                    in recent kernels
           Product: IO/Storage
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: bugs-a21@moonlit-rail.com
                CC: stern@rowland.harvard.edu
        Regression: Yes

Created attachment 307435
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307435&action=3Dedit
diff without stamps of the usbmon output, good (-) to bad (+)

Upgrading from old mainline LTS kernel 6.6 to current LTS kernel 6.12, a la=
rge
3.00TB SATA drive connected via USB through an "Initio Corporation INIC-161=
0P
SATA bridge" (id 13fd:1e40) is falsely reported as a 2.00TiB capacity drive=
.=20
According to the dmesg output, the newer kernel fails to identify the need =
to
call read_capacity_16(), resulting in a 32-bit size calculation.

I had reported this initially to the linux-usb mailing list.  Alan Stern
(CC'ed) wrote back, suggesting I redirect to linux-scsi, and include some
usbmon traces.  To upload the traces, I'm opening this on bugzilla.

A few notes:

* The USB-to-SATA bridge (via lsusb) is:
  ID 13fd:1e40 Initio Corporation INIC-1610P SATA bridge

* When booting into kernel 6.12.7, the external drive capacity
  is mis-reported.  Booting /back/ into 6.6.68, the capacity
  continues to be mis-reported.  One must now yank the USB
  cable (or power-cycle) to get the correct size detection again.

Here is a diff of the dmesg output when plugging in the drive.
From (-) is kernel 6.1.122
To   (+) is kernel 6.12.7:
 scsi host12: usb-storage 1-13:1.0
 scsi 12:0:0:0: Direct-Access     TOSHIBA  DT01ACA300       3.00 PQ: 0 ANSI=
: 4
 sd 12:0:0:0: Attached scsi generic sg1 type 0
-sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
-sd 12:0:0:0: [sdb] 5860533167 512-byte logical blocks: (3.00 TB/2.73 TiB)
+sd 12:0:0:0: [sdb] 4294967295 512-byte logical blocks: (2.20 TB/2.00 TiB)
 sd 12:0:0:0: [sdb] Write Protect is off
 sd 12:0:0:0: [sdb] Mode Sense: 23 00 00 00
 sd 12:0:0:0: [sdb] No Caching mode page found
 sd 12:0:0:0: [sdb] Assuming drive cache: write through
-sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
- sdb: sdb1
 sd 12:0:0:0: [sdb] Attached SCSI disk

I am attaching a diff of the usbmon output for the earlier kernel (good) and
current kernel (bad), in case the sequence of commands sent to/from the bri=
dge
shows whatever it is that puts the bridge into a low-capacity state.  As I
think I can only attach one file to this posting, I'll make separate
attachments for the good and bad usbmon listings.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
