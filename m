Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A73F31E823;
	Wed, 12 Aug 2026 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537657; cv=none; b=dOfr4jbpGMgxv+moEc//3gZZLbse8+CqW+Eu2TBASkkedsN4Gfas1/2m7QOJI3YXY4FN2eJm1Ibz5TNeQlAtZ9PTnDTB1l0g3iq+GrFC7vBLD2xxFd9GKFya+myRhebMUvnbd0Oj1hLuJXfJ3xd1Gd0p4BeHmZI4ztRZvjDwsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537657; c=relaxed/simple;
	bh=DHG4WOZEmDwTU3+GxM3cI8lbkXMDPsFPddcxi9d0sts=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=EqQDJOJM9W4CejBjgUgtTlCov4A/xYMFzU51hQfsKIYWdKIzvzj8U3lre+/8IVQw0SFNLJdb4qfAruDlSvmhB+kTAH94nu+kb/NiGX6XX3LLi7GnvjtK6jJdkiNufusDO3gznZ8gJBqUSKv6Ka8oZDYQqREB3R9QFdXO4+iASX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=n8pxuc+o; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="n8pxuc+o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1786537654;
	bh=DHG4WOZEmDwTU3+GxM3cI8lbkXMDPsFPddcxi9d0sts=;
	h=Message-ID:Subject:From:To:Date:From;
	b=n8pxuc+oggZFHNLwZ3l9aaOCziSCLIhNhZkwHpWu9ZoPADDW4NHEtZF0ibegwUkDZ
	 SHGUnIRiLbMhlSfn+9CN2fpAJdBACYpQZGNu0I6IGaDBz9kBrD9Wt++NwC2oL/UOx9
	 mzSsfe/tkmtZmmd4Iy9yG4ugA53Ozv64Y3teGDNI=
Received: from [172.16.45.132] (unknown [194.168.75.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5BD481C029D;
	Wed, 12 Aug 2026 08:27:33 -0400 (EDT)
Message-ID: <b1267cecf372f9f8f8472bfc8eaff8290803b5c9.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.2-rc7+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Wed, 12 Aug 2026 13:27:31 +0100
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The following changes since commit 0279fd451a9971c0d5b959fc59f3e11b55e1694e=
:

  scsi: ufs: core: Initialize hba->rpmbs list in ufshcd (2026-07-28 22:26:5=
1 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to c4f6916a99cf105c3ff340b6210fcbba3fa66b35:

  scsi: scsi_debug: Negate wrapped memcmp() result (2026-08-07 12:14:19 -04=
00)

----------------------------------------------------------------
Two minor core fixes: one for power management issues in error handling
and the other to fix a deadlock in door locking of SCSI devices with
removable media; and a minor bug fix for the debug driver.

----------------------------------------------------------------
Hongjie Fang (1):
      scsi: core: pair EH runtime PM get and put

Xu Rao (1):
      scsi: scsi_debug: Negate wrapped memcmp() result

Zizhi Wo (1):
      scsi: core: Do not block on tag allocation in scsi_eh_lock_door()

 drivers/scsi/scsi_debug.c | 4 ++--
 drivers/scsi/scsi_error.c | 8 +++++---
 drivers/ufs/core/ufshcd.c | 4 ++--
 include/scsi/scsi_host.h  | 6 +++---
 4 files changed, 12 insertions(+), 10 deletions(-)

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 643051332132..4fb2dc403962 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4310,8 +4310,8 @@ static bool comp_write_worker(struct
sdeb_store_info *sip, u64 lba, u32 num,
 	if (!res)
 		return res;
 	if (rest)
-		res =3D memcmp(fsp, arr + ((num - rest) * lb_size),
-			     rest * lb_size);
+		res =3D !memcmp(fsp, arr + ((num - rest) * lb_size),
+			      rest * lb_size);
 	if (!res)
 		return res;
 	if (compare_only)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 453a2232452d..b729407348f7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2161,7 +2161,7 @@ static void scsi_eh_lock_door(struct scsi_device
*sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
=20
-	req =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
0);
+	req =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd =3D blk_mq_rq_to_pdu(req);
@@ -2362,6 +2362,7 @@ static void scsi_unjam_host(struct Scsi_Host
*shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost =3D data;
+	bool eh_noresume;
=20
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2403,7 +2404,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again
(if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost)
!=3D 0) {
+		eh_noresume =3D READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) !=3D 0)
{
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to
autoresume\n",
@@ -2427,7 +2429,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 13e6357a8bbb..a41b56dbf3b7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10016,7 +10016,7 @@ static int ufshcd_set_dev_pwr_mode(struct
ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in
error
 	 * handling context.
 	 */
-	hba->host->eh_noresume =3D 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
=20
 	/*
 	 * Current function would be generally called from the power
management
@@ -10038,7 +10038,7 @@ static int ufshcd_set_dev_pwr_mode(struct
ufs_hba *hba,
 	}
=20
 	scsi_device_put(sdp);
-	hba->host->eh_noresume =3D 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
=20
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6b286fa59f2..98b0ccf0813e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -664,6 +664,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	bool async_scan __guarded_by(&scan_mutex);
=20
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
=20
 	/*
@@ -682,9 +685,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
=20
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
=20

