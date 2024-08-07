Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9C78C7D
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723048915; cv=none; b=QfDHakSTIhALZGGeKemVr1HHAg8wWFnZ6E+KVzNnjytAz9PpIBW1Tat+G51HVuaK3doZrj61NYTtavf/Ykgol5ySEMNiXqBHxq3Fqhbj2Qyx3nDMZaNwPJAe2Qqz5XbgzvZovUavsSwjy9D8sT4OgMTVw/bc6yTECu9LJoWhtwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723048915; c=relaxed/simple;
	bh=WX6Zqs+1F9XNlLU2QoO6B78SNYBa+JCCZNWtI7/LfN4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N9dAP2VWQAe31GvRBGybHTbHGXq8TwMpCeuflSbj08LRSnYUPX9UF0/rJoLLjpOcu9MshNQMHYmLX4bIzw1dWN4f0OtgzmqNZNJUdsPX97sfl+0nUSCI57Z/D+2lX8JM3EZA4bFkqPMs4Hopax12Scs+qYnwHZQv7wef8CkNQIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9FfQQQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9FfQQQx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C1C9C4AF11
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723048914;
	bh=WX6Zqs+1F9XNlLU2QoO6B78SNYBa+JCCZNWtI7/LfN4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V9FfQQQx0LFbjLXW042Edt3GKv/JZR8t4znPx0oLxT7s1D+wE4WYX1AaQ53RGKW5l
	 IaownfTMHhrq+dXFgOMqS0moCDCLs0oKx0kGCGEJtkNDrzQ8+1CCxPFD/uSj91ys4m
	 Rlau6M7Q+8Mjbop+ikxhB+M/MkbsBCY1D/L1Q/nsZTuDUsLCqX4tS2gpz+wdkTieed
	 Cm2/qUdOlu0qRrwkwxSkDUn6BdwOSXI/oR1wGw+i+MqO+UTXffFH3ig9NNpoG9yrxb
	 ec2BwH9sZSTJKnVZEe5uSDnQ3J638cfOrpbkoQmKa3Dlt3h91YYYoLNganb3Nm/7q2
	 HfL42nINUGs7g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 631F6C433E5; Wed,  7 Aug 2024 16:41:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Wed, 07 Aug 2024 16:41:54 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: justin.tee@broadcom.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219128-11613-Os89XxyAr0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219128-11613@https.bugzilla.kernel.org/>
References: <bug-219128-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219128

--- Comment #5 from justin.tee@broadcom.com ---
(In reply to Xavier from comment #4)
> I found I don't have permission to change the bug assignee even I am the
> reporter.
Okay, no worries.  Please find below a reply based on dmesg log provided.

(In reply to Xavier from comment #1)
> Created attachment 306673 [details]
> dmesg output log for upstream kernel 6.10
>=20
> Errors still exist with 6.10 kernel, the attachment file is the kernel bo=
ot
> log with parameter "lpfc.lpfc_log_verbose=3D4115 log_buf_len=3D32M"

1.) PRLI failure log messages.

[   12.754100] lpfc 0000:27:00.0: 0:(0):0108 No retry ELS command x18001420=
 to
remote NPORT x30700 Retried:1 Error:x9/b0000 IoTag x2f60 nflags x80020000
[   12.754102] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:030700
Status:x9/xb0000, data: x4 x0 x80020000
[   12.859313] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:020100
Status:x9/xb0000, data: x4 x0 x80020000
[   13.029796] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:051400
Status:x9/xb0000, data: x4 x0 x80000000
=E2=80=A6
[   13.127530] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:030F00
Status:x9/xb0000, data: x4 x0 x80020000
[   13.127948] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:051000
Status:x9/xb0000, data: x4 x0 x80000000
[   13.129275] lpfc 0000:27:00.0: 0:(0):0108 No retry ELS command x18001420=
 to
remote NPORT x51601 Retried:1 Error:x9/b2c00 IoTag x2f48 nflags x80000000
[   13.129277] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:051601
Status:x9/xb2c00, data: x4 x0 x80000000
[   13.131082] lpfc 0000:27:00.0: 0:(0):2754 PRLI failure DID:051201
Status:x9/xb2c00, data: x4 x0 x80000000
=E2=80=A6

These log messages indicate that several ports sent LS_RJT with reason code
0x0B (Command Unsupported) to our sent NVME-PRLI.  This is most likely due =
to a
target that does not support NVME.

2.) FDMI cmd failed messages.

[ 2236.658100] lpfc 0000:27:00.0: 0:(0):0220 FDMI cmd failed FS_RJT Data: x=
211

These log messages are benign and do not affect normal HBA operations.  It =
is
related to a proprietary management tool, which if interested, we can provi=
de
further information in a non-public setting.

3.) FCP command failed messages.

[   12.501657] lpfc 0000:27:00.0: 0:(0):9024 FCP command xa0 failed: x0 SNS=
 x0
x0 Data: x8 xff0 x0 x0 x0
[   12.526335] lpfc 0000:27:00.0: 0:(0):9024 FCP command x12 failed: x0 SNS=
 x0
x0 Data: x8 xa x0 x0 x0

These are Report_LUNs and Inquiry SCSI commands during FCP discovery getting
logged with underruns.  This is part of normal HBA operations and can be
ignored because returned status in the SCSI commands are SAM_STAT_GOOD =3D =
0x00.

4.) PLOGI failure messages.

[    9.707863] lpfc 0000:27:00.0: 0:(0):0116 Xmit ELS command x3 to remote
NPORT x30b00 I/O tag: x2fdd, port state:xd rpi xd fc_flag:x208114
=E2=80=A6
[    9.707936] lpfc 0000:27:00.0: 0:(0):0112 ELS command x3 received from N=
PORT
x30b00 refcnt 3 Data: x20 x208154 x41000 x41000
[    9.707938] lpfc 0000:27:00.0: 0:(0):3178 PLOGI confirm: ndlp x30b00 x40=
000
x3: new_ndlp x0 x0 x0
[    9.707941] lpfc 0000:27:00.0: 0:(0):0211 DSM in event x0 on NPort x30b0=
0 in
state 1 rpi xd Data: x40000 x30000
[    9.707943] lpfc 0000:27:00.0: 0:(0):0114 PLOGI chkparm OK Data: x30b00 =
x1
x40000 xd x20 x208154
[    9.707944] lpfc 0000:27:00.0: 0:(0):2819 Abort outstanding I/O on NPort
x30b00 Data: x40000 x1 xd
=E2=80=A6
[   10.481216] lpfc 0000:27:00.0: 0:(0):0102 PLOGI completes to NPort x030b=
00
IoTag x2fdd Data: x3 x3 x103 x0 x1d
[   10.481218] lpfc 0000:27:00.0: 0:(0):0108 No retry ELS command x3 to rem=
ote
NPORT x30b00 Retried:0 Error:x3/103 IoTag x2fdd nflags x1080000
[   10.481219] lpfc 0000:27:00.0: 0:(0):2753 PLOGI failure DID:030B00
Status:x3/x103

This particular PLOGI was =E2=80=9Cfailed=E2=80=9D out because the lpfc dri=
ver originally sent
a PLOGI to port_id 0x030B00, but did not receive a response.  Rather port_id
0x030B00, sent a PLOGI of its own instead.  Thus, this PLOGI failure message
indicates that this HBA=E2=80=99s port sent PLOGI was canceled.

In fact, 0x030B00 is an initiator port and not a target port.  So, this is
expected behavior:

[   10.484676] lpfc 0000:27:00.0: 0:(0):0103 PRLI completes to NPort x030b00
Data: x0 x41000 x7 x1 x0
[   10.484678] lpfc 0000:27:00.0: 0:(0):0211 DSM in event x7 on NPort x30b0=
0 in
state 4 rpi xd Data: x80080000 x30000
[   10.484680] lpfc 0000:27:00.0: 0:(0):6028 FCP NPR PRLI Cmpl Init 1 Targe=
t 0
EIP 0 AccCode x1


>   1. Although there're those failures, we can read/write date to SAN disk=
s.
Good, because the lpfc driver logs indicate successful SCSI-PRLIs and event=
ual
successful SCSI discovery:

[   12.464025] lpfc 0000:27:00.0: 0:(0):0103 PRLI completes to NPort x051500
Data: x0 x41000 x7 x0 x0
[   12.464027] lpfc 0000:27:00.0: 0:(0):0211 DSM in event x7 on NPort x5150=
0 in
state 4 rpi x18 Data: x80000000 x30008
[   12.464661] lpfc 0000:27:00.0: 0:(0):0212 DSM out state 7 on NPort x51500
rpi x18 Data: x80000000 x30008
[   12.466486] scsi 14:0:0:0: Direct-Access     LENOVO   DE_Series        0=
881
PQ: 1 ANSI: 5

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
