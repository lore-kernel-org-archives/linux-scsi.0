Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F0A31C578
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.71.130.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357918; cv=none; b=D/H/yxk88YH7Kt6r2X7rvoCc+ZSb4zJvjhnymrP+1icS2cFmnA/8BvwwSc3bJn97uF46VpWkQYx9flAGZ3r91PreY8o+Q2avddBfxkYEPGLXPHmL3PHi83mREvETX1wfoVeu42ixdF0GrJ0QHoxyI8ISPfrhKttK77hH/rrxhbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357918; c=relaxed/simple;
	bh=z9+41aqwA+e2oS2HurKpjpxD41hAxqO245N9vYI4mGI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=BTUQigeo2EQjTxW8mxkXgS48X86grKkHtQ/RvXi+Y31NuqVsU4uEqFNqVD4Oi4frzIipwrGLEHkaV4lHWMHRqSvOWPMauAS0H2kB6GnSoWMt9cDetW9ClAWTRwVWSZ9UrN+hDztD5T4IKxMfnibPxcLOpVCxIIkJ5t5fJ6jPNsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=eZg5kJIr reason="signature verification failed"; arc=none smtp.client-ip=173.71.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="eZg5kJIr"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id SkersB4jDXbQHmmC; Mon, 08 Sep 2025 14:45:57 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=+ftaLcyqukJE07mN520eP0GkDIrw9OIG2RnCE5DtPSs=;
	h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:Content-Language:
	MIME-Version:Date:Message-ID; b=eZg5kJIrSXN78gn3JNABfGoD/yiMg97PxCMa0NFpQyv7T
	30ruoNBrJwPtlGXrCsgaJOhU+WrBkFfvUT62Wo0Js7GRZ5Bj9BM0IIaIbt8G//slt3IL9a//K4+Yk
	m0vrzV1GcQwODHjJhcM3Zc1Ra0cp9HKSryVTNzcOMidUyisnk=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189108; Mon, 08 Sep 2025 14:45:57 -0400
Message-ID: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 14:45:57 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 00/15] qla2xxx target mode improvements
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: [PATCH 00/15] qla2xxx target mode improvements
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757357157
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 3125
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1757357157-1cf43947df30c210001-ziuLRu

This patch series improves the qla2xxx FC driver in target mode.=C2=A0 I
developed these patches using the out-of-tree SCST target-mode subsystem
(https://scst.sourceforge.net/), although most of the improvements will
also apply to the other target-mode subsystems such as the in-tree LIO.=C2=
=A0
Unfortunately qla2xxx+LIO does not pass all of my tests, but my patches
do not make it any worse (results below).=C2=A0 These patches have been
well-tested at my employer with qla2xxx+SCST in both initiator mode and
target mode and with a variety of FC HBAs and initiators.=C2=A0 Since SCS=
T is
out-of-tree, some of the patches have parts that apply in-tree and other
parts that apply out-of-tree to SCST.=C2=A0 I am going to include the
out-of-tree SCST patches to provide additional context; feel free to
ignore them if you are not interested.

All patches apply to linux 6.17-rc5 and SCST 3.10 master branch.

Summary of patches:
- bugfixes
- cleanups
- improve handling of aborts and task management requests
- improve log message
- add back SLER / SRR support (removed in 2017)

Some of these patches improve handling of aborts and task management
requests.=C2=A0 This is some of the testing that I did:

Test 1: Use /dev/sg to queue random disk I/O with short timeouts; make
sure cmds are aborted successfully.
Test 2: Queue lots of disk I/O, then use "sg_reset -N -d /dev/sg" on
initiator to reset logical unit.
Test 3: Queue lots of disk I/O, then use "sg_reset -N -t /dev/sg" on
initiator to reset target.
Test 4: Queue lots of disk I/O, then use "sg_reset -N -b /dev/sg" on
initiator to reset bus.
Test 5: Queue lots of disk I/O, then use "sg_reset -N -H /dev/sg" on
initiator to reset host.
Test 6: Use fiber channel attenuator to trigger SRR during
write/read/compare test; check data integrity.

With my patches, SCST passes all of these tests.

Results with in-tree LIO target-mode subsystem:

Test 1: Seems to abort the same cmd multiple times (both
qlt_24xx_retry_term_exchange() and __qlt_send_term_exchange()).=C2=A0 But
cmds get aborted, so give it a pass?

Test 2: Seems to work; cmds are aborted.

Test 3: Target reset doesn't seem to abort cmds, instead, a few seconds
later:
qla2xxx [0000:04:00.0]-f058:9: qla_target(0): tag 1314312, op 2a: CTIO
with TIMEOUT status 0xb received (state 1, port 51:40:2e:c0:18:1d:9f:cc,
LUN 0)

Tests 4 and 5: The initiator is unable to log back in to the target; the
following messages are repeated over and over on the target:
qla2xxx [0000:04:00.0]-e01c:9: Sending TERM ELS CTIO (ha=3D00000000f88113=
90)
qla2xxx [0000:04:00.0]-f097:9: Linking sess 000000008df5aba8 [0] wwn
51:40:2e:c0:18:1d:9f:cc with PLOGI ACK to wwn 51:40:2e:c0:18:1d:9f:cc
s_id 00:00:01, ref=3D2 pla 00000000835a9271 link 0

Test 6: passes with my patches; SRR not supported previously.

So qla2xxx+LIO seems a bit flaky when handling exceptions, but my
patches do not make it any worse.=C2=A0 Perhaps someone who is more famil=
iar
with LIO can look at the difference between LIO and SCST and figure out
how to improve it.

Tony Battersby
https://www.cybernetics.com/

