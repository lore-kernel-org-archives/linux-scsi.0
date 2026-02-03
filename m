Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62447318131;
	Tue,  3 Feb 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136406; cv=none; b=ozXIym+3iuX+qzz4v/F1T2O2MAmwaVqfSkIVFXJuFsR1EUYlrFkuGMndYptj9T5VnYOxpjmBZ/qRohmAh9FXRXg78HLJnBCMeP8OUBns2uDV+XeDQgyMSsbbWfgj8B7cpG2mQi5Jo4xwfoTUOQsYo6AJvv1Zjz3tAKkJkpue4PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136406; c=relaxed/simple;
	bh=Pd7EhqBdo2ShFSk+W4vE11ga6b5zrbFcrUDdyIHvWdw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sIi1FNDYouIL/4gQM3t0reBRM4LW2pLR0wNOqXJsRDzQY9qdwdpsnSIL1K62+9xceqRWOkn6iJGHQ4Vbk2fz6GoHljItgRdc84tSpCTyvsSclLosENaS/QHqAf5kaJcWgYmt8JC9FsgGHzwdU/BhoD+j1MC6QRhVhWzASmMIl5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=for5jMKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="for5jMKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB3EC116D0;
	Tue,  3 Feb 2026 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770136406;
	bh=Pd7EhqBdo2ShFSk+W4vE11ga6b5zrbFcrUDdyIHvWdw=;
	h=From:To:Cc:Subject:Date:From;
	b=for5jMKo9JqoqUrCqcHaxpqkB5xdFoXHmLuQyrIQdYiiZ9Qpw0s6WZ6lYInzdwEjW
	 U2qZmsURtQhHXzU3fIEky1ESIzR9LQg6qkspw5u5GthQcbZPI6ZcNNjOSCt+GPlKJA
	 W+vmKq6HLDEFlB3/PHuWPNIaIkkirT5f+DkeOVE4RZ15d1c885Q3MVuWQ36kISEjvX
	 tBLOMZKq6PC0kQOO1OW3iEaLEeEOljZmhvD0RdLAjtV9bb1B1BlAt9W8OwwxR9plkG
	 i9fyI3KK2X/BHyzK5nT7lvVcA3epn90VIo4NXbXfloE30xL2LGNOs10toCCsNxsEvi
	 xp41CSOdiQfWA==
From: Arnd Bergmann <arnd@kernel.org>
To: Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Alexey Gladkov <legion@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] SCSI: buslogic: reduce stack usage
Date: Tue,  3 Feb 2026 17:33:15 +0100
Message-Id: <20260203163321.2598593-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Some randconfig builds run into excessive stack usage with gcc-14 or
higher, which use __attribute__((cold)) where earlier versions did
not do that:

drivers/scsi/BusLogic.c: In function 'blogic_init':
drivers/scsi/BusLogic.c:2398:1: error: the frame size of 1680 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

The problem is that a lot of code gets inlined into blogic_init()
here. Two functions stick out, but they are a bit different:

 - blogic_init_probeinfo_list() actually uses a few hundred bytes of
   kernel stack, which is a problem in combination with other functions
   that also do. Marking this one as noinline means that the stack slots
   get get reused between function calls

 - blogic_reportconfig() has a few large variables, but whenever it is
   not inlined into its caller, the compiler is actually smart enough
   to reuse stack slots for these automatically, so marking it as
   noinline saves most of the stack space by itself.

The combination of both of these should avoid the problem entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/BusLogic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 865fcbac8fa1..49929d0339fa 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -920,7 +920,8 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
   a particular probe order.
 */
 
-static void __init blogic_init_probeinfo_list(struct blogic_adapter *adapter)
+static noinline_for_stack void __init
+blogic_init_probeinfo_list(struct blogic_adapter *adapter)
 {
 	/*
 	   If a PCI BIOS is present, interrogate it for MultiMaster and
@@ -1690,7 +1691,8 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
   blogic_reportconfig reports the configuration of Host Adapter.
 */
 
-static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
+static noinline_for_stack bool __init
+blogic_reportconfig(struct blogic_adapter *adapter)
 {
 	unsigned short alltgt_mask = (1 << adapter->maxdev) - 1;
 	unsigned short sync_ok, fast_ok;
-- 
2.39.5

