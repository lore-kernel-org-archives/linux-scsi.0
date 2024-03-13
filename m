Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B8A3EA72;
	Wed, 13 Mar 2024 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710329430; cv=none; b=L591MWBMTZnk81D3gEn8KZ6AhEIXkigVmCaO+DpNU7DNhjbIidPk3LI1vtqIJriEITGqBLyvM6UsrC59hfeCAGfNq5q9st7Xys0gvRlltrtMpzk+LF1QZ0rS1li7WdusZC+q5p5PU3QuTBuPKFd4s7wB14FBqaMNm18Ds44Xnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710329430; c=relaxed/simple;
	bh=rwEW4ySKbuvJZTu5EpEHtshEWyyGgcijixSrw4EKNwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nyZvgj2IWacyZfRc/oTrEwPyh/1nUvF4VmD5nNS/gL78uCicSk9j2f7oCNkl+/v8e3CqvLADCea58nYUnXdm3ROxzdA3vNXS6Bd6u5AELuGbCkc95nqpkCpt3qsW25DJlw5BotOa7ZqA4NBVpPxhZzGYOn0VTMWMM8bISdsU+h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=JHTkQMP3; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="JHTkQMP3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kky/dRJyKBUx3h381cnSb+YhqF1W+SBQhMlIYZOCUjM=; b=JHTkQMP3eWxl1jUynSym40Wck1
	g2mAz51Fn20s+96CmQHKcDABvD0U7X7MAh8NV7U2WODtevqXR+r8b54O4wETah2klzrZr0JSF9Klr
	JCO6EBtnGl4WIzUgTXbxYw8ATutMGifsELKriAZe14vi2xe3feV3COcNe8fh8P5QEBP8muiGfF5uh
	PIR55YxKP0+WQEuJZYhrb7gt9/hMS65JrRi+SAeubqb4sxzT5LY1sMc122Z2V+cPs9h0g7WbFc0W5
	dTuICzDf03P8r0XenOZhJqn45vVLCoiFWmmaKunBfnN3Wn6DpGh/WHZ+7gzsYscYbvrM6z5xnQylM
	VGF4cc5w==;
Received: from [177.62.247.190] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1rkMoN-009vIC-01; Wed, 13 Mar 2024 12:30:19 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	stern@rowland.harvard.edu,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: core: Fix unremoved procfs host directory regression
Date: Wed, 13 Mar 2024 08:21:20 -0300
Message-ID: <20240313113006.2834799-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} directory
earlier") fixed a bug related to modules loading/unloading, by adding a
call to scsi_proc_hostdir_rm() on scsi_remove_host(). But that led to a
potential duplicate call to the hostdir_rm() routine, since it's also
called from scsi_host_dev_release(). That triggered a regression report,
which was then fixed by commit be03df3d4bfe ("scsi: core: Fix a procfs host
directory removal regression"). The fix just dropped the hostdir_rm() call
from dev_release().

But happens that this proc directory is created on scsi_host_alloc(),
and that function "pairs" with scsi_host_dev_release(), while
scsi_remove_host() pairs with scsi_add_host(). In other words, it seems
the reason for removing the proc directory on dev_release() was meant to
cover cases in which a SCSI host structure was allocated, but the call
to scsi_add_host() didn't happen. And that pattern happens to exist in
some error paths, for example.

Syzkaller causes that by using USB raw gadget device, error'ing on usb-storage
driver, at usb_stor_probe2(). By checking that path, we can see that the
BadDevice label leads to a scsi_host_put() after a SCSI host allocation, but
there's no call to scsi_add_host() in such path. That leads to messages like
this in dmesg (and a leak of the SCSI host proc structure):

usb-storage 4-1:87.51: USB Mass Storage device detected
proc_dir_entry 'scsi/usb-storage' already registered
WARNING: CPU: 1 PID: 3519 at fs/proc/generic.c:377 proc_register+0x347/0x4e0 fs/proc/generic.c:376

The proper fix seems to still call scsi_proc_hostdir_rm() on dev_release(),
but guard that with the state check for SHOST_CREATED; there is even a
comment in scsi_host_dev_release() detailing that: such conditional is
meant for cases where the SCSI host was allocated but there was no calls
to {add,remove}_host(), like the usb-storage case.

This is what we propose here and with that, the error path of usb-storage
does not trigger the warning anymore.

Reported-by: syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com
Fixes: be03df3d4bfe ("scsi: core: Fix a procfs host directory removal regression")
Cc: stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Hi folks, thanks in advance for reviews.

The issue  with usb-storage happens upstream but despite we have a
repro in the aforementioned Syzkaller report, it's only easy to reproduce
the proc_dir_entry warning in a timely manner on stable right now.

The reason for that is commit 036abd614007 ("scsi: core: Introduce a new
list for SCSI proc directory entries") not being present on stable. This
commit (indirectly) bumps the ->present field from unsigned char to uint,
and the bug reproducer shows the warning whenever such field overflows,
hence it's way easier/faster to see this problem in stable, though it's
present in latest v6.8.0 too.

Cheers,

Guilherme


 drivers/scsi/hosts.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index d7f51b84f3c7..445f4a220df3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -353,12 +353,13 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
-		 * Free the shost_dev device name here if scsi_host_alloc()
-		 * and scsi_host_put() have been called but neither
+		 * Free the shost_dev device name and remove the proc host dir
+		 * here if scsi_host_{alloc,put}() have been called but neither
 		 * scsi_host_add() nor scsi_remove_host() has been called.
 		 * This avoids that the memory allocated for the shost_dev
-		 * name is leaked.
+		 * name as well as the proc dir structure are leaked.
 		 */
+		scsi_proc_hostdir_rm(shost->hostt);
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-- 
2.43.0

