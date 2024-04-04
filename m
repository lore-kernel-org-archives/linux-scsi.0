Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697D770CC2
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 23:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712272737; cv=none; b=HbnokSDNMf/FPNICwqIjo64C2xIyTCsrCgzkruORz6JfMB582wd9erCz+cQZXiOlKiZ3xCotUMySnR15aHM9cjeorZg9hrX3lGQnnsis8HoBlagn90vXc5M4pRyEj8wJ3tuRpgRg/oy/yvkASfI2OQqeUiwcFu2DHLS7W3FzD8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712272737; c=relaxed/simple;
	bh=TRV1NLl+9VrQ+fp+mrbQikVysy4tbFZ8KamRMe08Xwk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dOSgAVSJLUSctCEVw9ufpsub4jSLtr6g3Xr/GKHXWuPv7j7YbISCfGQRtnDS+b4vR07bYlpRTcFlbZvNEm5Exe2rjq7Cwt1Dvha6dEaCft403A3Yz6GTB0qh6Hf0V+dBelaxP+oE3b6VwhMh/vRFNm37yUwHXZpFMbTnFofHAiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EEwb33on; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EEwb33on"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 434MFh4q028442
	for <linux-scsi@vger.kernel.org>; Thu, 4 Apr 2024 16:18:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=usw/gh2y9qWVGV0Vizw/I/IGZTSvonEOaA+1wtcAL6Q=;
 b=EEwb33onZl7JufwLaEC7tB0va9etbpH/iW7+vVGC/RnXIFcpmbZJ0uLI4I/RLkDb5fHT
 69vsODt3An8dW//wUz0E4CQzCBUpdLg0c2THjsGlpji+bdHG54qt4CXpTYW8gGcK511s
 9kmdiR46Qvm2f6XEaSJzscJUhBRbFHfe/ZxUF32kjmhcquPYsOBfH/se99kIMbVSxCOW
 DJTg375qihX3eHWyYUU3evVey1NZiewmuAZAwcPceu3ZHm3STQzQPbjuCuM7nbLNYiWm
 NN4qjtwPpWPAw3rD6RNAd/bMWDJmRZabHiL4L4c20yyQbsJM0VPjunFY/PvPImEOxBSP Cw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3x9enhy5mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 16:18:54 -0700
Received: from twshared24822.14.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Apr 2024 23:18:53 +0000
Received: by devbig032.nao3.facebook.com (Postfix, from userid 544533)
	id 801281117EA0; Thu,  4 Apr 2024 16:18:40 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-scsi@vger.kernel.org>
CC: <dgilbert@interlog.com>, <martin.petersen@oracle.com>,
        Keith Busch
	<kbusch@kernel.org>,
        Alexander Wetzel <Alexander@wetzel-home.de>,
        Jakub
 Kicinski <kuba@kernel.org>
Subject: [PATCH] scsi: sg: fix refcount warning
Date: Thu, 4 Apr 2024 16:18:40 -0700
Message-ID: <20240404231840.2015678-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: k95uiRAOTNjkHA0G0axXCrDKUl2BAFD7
X-Proofpoint-GUID: k95uiRAOTNjkHA0G0axXCrDKUl2BAFD7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_20,2024-04-04_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

The refcount is taken multiple times on the open, from sg_add_sfp() and
sg_get_dev(). Both are still counted at the point of the warning, so it l=
ooks
like the WARN just wants to ensure at least one live reference exists rat=
her
than exactly one reference.

This fixes the warning:

 ------------[ cut here ]------------
 WARNING: CPU: 8 PID: 394 at drivers/scsi/sg.c:2236 sg_remove_sfp_usercon=
text+0x1ad/0x1d0 [sg]
 Modules linked in: sg(E) nfit(E) libnvdimm(E) kvm_intel(E) kvm(E) evdev(=
E) serio_raw(E) e1000(E) i2c_piix4(E) button(E) sch_fq_codel(E) drm(E) fu=
se(E) drm_panel_orientation_quirks(E) autofs4(E)
 CPU: 8 PID: 394 Comm: kworker/8:3 Tainted: G        W   E      6.9.0-rc2=
+ #545
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-1=
4-g1e1da7a96300-prebuilt.qemu.org 04/01/2014
 Workqueue: events sg_remove_sfp_usercontext [sg]
 RIP: 0010:sg_remove_sfp_usercontext+0x1ad/0x1d0 [sg]
 Code: e8 18 9d 49 e1 eb a2 4c 8b 04 24 49 8d 56 6d 48 c7 c1 d8 84 37 a0 =
48 c7 c7 fb 81 37 a0 49 8b 36 e8 28 14 74 e1 e9 48 ff ff ff <0f> 0b 41 8b=
 b6 98 00 00 00 48 c7 c7 03 85 37 a0 e8 3e 02 e1 e0 e9
 RSP: 0018:ffffc90000687e30 EFLAGS: 00010202
 RAX: 0000000000000002 RBX: ffff88801ecd9328 RCX: 0000000000000041
 RDX: 0000000000000040 RSI: 000000000003a1c0 RDI: ffff88801ecd8000
 RBP: ffff88801ecd8080 R08: 0000000000000000 R09: ffff88803ea3b340
 R10: 0000000000000214 R11: 0000000000000000 R12: ffff888004969000
 R13: ffff88803ea34240 R14: ffff888015ec1980 R15: ffff888015ec0900
 FS:  0000000000000000(0000) GS:ffff88803ea00000(0000) knlGS:000000000000=
0000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f9ab9cc8c60 CR3: 000000001aa7c003 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? __warn+0x7f/0x120
  ? sg_remove_sfp_usercontext+0x1ad/0x1d0 [sg]
  ? report_bug+0x17d/0x190
  ? handle_bug+0x42/0x70
  ? exc_invalid_op+0x14/0x70
  ? asm_exc_invalid_op+0x16/0x20
  ? sg_remove_sfp_usercontext+0x1ad/0x1d0 [sg]
  process_one_work+0x13e/0x300
  worker_thread+0x2cb/0x3e0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xc4/0xf0
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x2d/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 ---[ end trace 0000000000000000 ]---

Created from this simple reproducer:

---

int main() {
    int fd =3D open("/dev/sg0", O_RDWR);

    if (fd < 0)
        return 1;

    close(fd);
    return 0;
}
--

Fixes: 27f58c04a8f438 ("scsi: sg: Avoid sg device teardown race")
Cc: Alexander Wetzel <Alexander@wetzel-home.de>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 386981c6976a5..eba8fc8c88a51 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2233,7 +2233,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			"sg_remove_sfp: sfp=3D0x%p\n", sfp));
 	kfree(sfp);
=20
-	WARN_ON_ONCE(kref_read(&sdp->d_ref) !=3D 1);
+	WARN_ON_ONCE(kref_read(&sdp->d_ref) < 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(device);
 	module_put(THIS_MODULE);
--=20
2.43.0

