Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043411;
	b=RDxAsFLpsIUCPLHQon6SzCUBFjw7dF9nBZt2r/i2/ugNfzx6N6yHsMSJc99PML8Y0IDc
	 LfrHUaLTPArRRtpCOlw4sd3KPbgWgzMxYB0ZTOJvHwubBwuCDm9JRLx3He0Fs5V3CHcpr
	 PT3Nvmy0acs7lzzk2oX3iMUDN1fvNXpxJMy4Gryu8hI1Vfj/eKq2+lHEJUlB1eqqBwa8X
	 u2KA0AWZKxtYisLDNGyjUDWyQwEYueMgpoTHsuT/67fCZ76c+D9lvzu9c4sX3B6oXxoBj
	 nu95/k6sFErW6qbLFaAh7/qcvO6SVxhPQamgpOxuBo+EXmC2QoMW08FjqHhKv3UoKfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043411;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lV/VzxV/O5uCisVr5/DBuvmgXtlXoGoJtLjIIr/Q174=;
	b=xrgYWg6CFcUen2yGMCrtw00AqRsEXJ048Sir07QAZZKY8KxJK7YF5MrujJZJw8rCpxFP
	 kdv4U+W7eVaNCwR0lATUxSBoqKvnFQnYvwoeY3qewFU36cMglLgSGpH+bBR736Bb0f0JN
	 NAmwI71h24bK3tLVMy3Hc/RzSqx+Ew2JvkDbS4aNadCZ55+qiTA8aH1Im4MzhYED1X3Np
	 C2n1X5z8+VrNFvU1J5tpZA9kVrpok+8FZoaX9hOZqdMDep4Kwo4WIaPCAXRqeUaGI83dM
	 Od3lj9LRP8N8UscNn1r8KOWtx8hcWKjXfZNZ9nvr9P0v6f5VI0RHYJeYU02QeOk3Gyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayy8YFcI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613D8606A320;
	Wed, 18 Nov 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayy8YFcI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904E71F000C4;
	Wed, 18 Nov 2026 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043411;
	bh=lV/VzxV/O5uCisVr5/DBuvmgXtlXoGoJtLjIIr/Q174=;
	h=From:Subject:Date:To:Cc;
	b=ayy8YFcIpHFtRQNBMg7Rn/a9FcC6e3L+o9U0LqOtiH+E0rOLi9i/g/G7A68mGXect
	 e+Xhuh0RlmQwxY+XmUVobpTPOm60/Z4XtSrIq11r+2CDcrslWIvX5IFgNXj4xn6fXj
	 1p24yTKh6qUWENJoPMJb5cUVVnmG25sU/q8QTB7Qf1+eb7Q2ewXHnkLfAtx0CYBYcs
	 sIukfNBnyAQYaotNe9EAIjBvTGdEMqlEMw/raERefSgvwvDSEntL44nbwP42FuamlT
	 tv1MnJnGWRm0bCeM7kxpqoxSZ/b9ZoNWcaFRRgnwPSlrQIGkQw6YDOdMdg/7RnYi+B
	 ymLFsdrCFjo8w==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 00/11] scsi: mpt3sas: Fix delayed not-responding block
 deadlock and related bugs
Date: Wed, 18 Nov 2026 15:09:57 -0800
Message-Id: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22MywrCMBBFf6XM2pE8+tKV/yEuJum0DUojiQSl9
 N9Nu1HB5bncc2aIHBxHOBYzBE4uOj9l0LsC7EjTwOi6zKCEqqXQAiNFJGMImWxvbVn1rGvI93v
 g3j231PmSeXTx4cNrKye5rn8iSaJE09qua2RJurGnK4eJb3sfBlgrSX1MKdSXqVCg0eZgqG1KU
 9GPuSzLG0xwCMrbAAAA
X-Change-ID: 20261030-sas-abba-eacfcc45fe36
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4069; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=7Wt6lpvC0hBqjt0y/k312yL4X9WbV5yC3jZogA6cu+o=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBL94WEQPprHVcuZOHLIzPhCHfk9j+PwlNmB
 I079CynVZaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wSwAKCRAADmhBGVaC
 FUqQD/0UAa+pykYJOExXnP63XRXAHuJsVzW4OAqfqxMMmZ0UUgrVhVaudSFCTuXssmK8uIL9S2X
 NvVSNyDAcG6UjQvxCsrSJ2chKPMJGx+1xs5vyfK56g2jkSQrFubj1bIaO+0zQd7ykp8Kp7yPdj+
 Be+UN/CSDuxpUDoKFNBJTnwnnyz42juzzIC2gFeGT1TjV8K+c3qXvLv++AJRsrJVtZ4rgSm/v3y
 QyXLwvJ5ccrqLqN/CU37J6aJAilC8QBcLa/WH1ans6AFavf5Rewb7TR7jTOkX8TjDndqtgjVam4
 zWnqs00xAyZSWFsW0AeVhMACRSwO+J5BVHY3SELlFhtyqLG4vl25QEJA7F3oN+1JrJkeB7RGTCK
 wiil2o53ys574iVaV5KGLVEak0y9fWZnbF+EG5ssF6MNfZJosTvZMyr6qgDUJCTAJqh3TMLoxh9
 pgRaC3OVuX9YW9eGWep8wNVlo1ZeI2T9pwAqQQwAiAngcXxbUgdks4gpWJx0fyEBS4zcuFBmArw
 LgFyTBQZBjqWXfydSbApJBasquLjalvP6+ka5nDS7nSBHdp/zKeTEDuML5owPib4RmKaGqrmqgu
 OP1s+pi+xu7TRjWti0URn6HLhOrNDXF8KxnHn4HF1VA/mxZbj7wW2o1fwBxfmaRJSF+cz2+lOpy
 Kh6DsrbxvkYe9rw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

I posted v2 some time ago. Since then, I did a lot of adversarial review
with AI agents. The review found a large number of bugs. Many of these
bugs were preexisting.

This series fixes a deadlock that occurs regularly in Meta's fleet. The
fix unblocks sdevs after a timeout, and this breaks the deadlock.

I don't do much SCSI driver work, but this problem came to me. I
relied heavily on AI agents for this series.

If this series is acceptable, I would like to see it in linux-next
soon.

Thanks,
Jeff

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v3:
- New patches 1-8 and 10 fix pre-existing bugs in the code that this
  series changes:
  - 1-2: fix UAFs and refcounting in the cleanup of the fw event queue.
    Do not leave requeued events pending at teardown.
  - 3: requeue topology events only for busy devices. Do not requeue
    them for devices that the driver cannot add.
  - 4-7: fix these TUR polling bugs:
    - a pcie_device leak
    - a lost unblock retry
    - polling that continues after the scan is cancelled
    - a retry count that is not per device
  - 8: cache the missing delays that the IOC actually uses
  - 10: do not use freed hostdata while the driver polls devices
- Patch 9: also publish sdev->hostdata under ioc->block_lock in
  scsih_sdev_init()
- Patch 11:
  - Use the PCIe missing delay (from PCIe IO Unit Page 1) for NVMe
    devices.
  - Arm dnr_unblock_work for the earliest deadline.
  - Skip the timed unblock during host reset, but not during SCSI EH.
  - Clear the deadline of an sdev under ioc->block_lock before the fw
    event worker polls the sdev.
  - Do not put a timed block on offline sdevs.
  - When a hard reset cancels polling, give new deadlines to the sdevs
    that stay blocked.
  - Give deadlines to the sdevs that a broadcast primitive pass blocks.
    Prevent dnr_unblock_work from unblocking them while the pass runs.
  - A repeat DNR restarts the deadline, at most
    MPT3SAS_DNR_BLOCK_MAX_EXTENDS times.
  - At the next worker unblock, do a TUR check on expired sdevs.
  - Keep the blocks that the driver makes during polling.
  - Use system_dfl_wq instead of system_wq.
- Link to v2: https://lore.kernel.org/r/20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org

Changes in v2:
- New patch 1: use a new ioc->block_lock to serialize the
  interrupt-time sdev block with the hostdata teardown in
  scsih_sdev_destroy(). This fixes a pre-existing UAF.
- Do the timed unblock under ioc->block_lock. This prevents a race with
  an interrupt-time block.
- Clear block_deadline before the fw event worker polls a returning
  device with TURs. Then dnr_unblock_work cannot unblock the device
  during the poll.
- Link to v1: https://lore.kernel.org/r/20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org

---
Jeff Layton (11):
      scsi: mpt3sas: Don't leave requeued firmware events pending at teardown
      scsi: mpt3sas: Hold event references while cleaning up the event queue
      scsi: mpt3sas: Requeue topology events only for busy devices
      scsi: mpt3sas: Fix pcie_device leak in _scsih_ublock_io_device_wait()
      scsi: mpt3sas: Restore unblock retry in _scsih_ublock_io_device_wait()
      scsi: mpt3sas: Stop polling devices when the unresponding scan is cancelled
      scsi: mpt3sas: Reset the TUR retry count for each device
      scsi: mpt3sas: Cache the missing delays the IOC actually uses
      scsi: mpt3sas: Serialize interrupt-time sdev block with hostdata teardown
      scsi: mpt3sas: Don't use freed hostdata while polling devices
      scsi: mpt3sas: Time out delayed not-responding device blocks

 drivers/scsi/mpt3sas/mpt3sas_base.c  |  62 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  25 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 869 +++++++++++++++++++++++++++++------
 3 files changed, 810 insertions(+), 146 deletions(-)
---
base-commit: e8017d29067fd1310a65c3494ce1a1b492adbac6
change-id: 20261030-sas-abba-eacfcc45fe36

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

