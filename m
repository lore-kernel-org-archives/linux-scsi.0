Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A782290F;
	Tue, 18 Mar 2025 06:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742278432; cv=none; b=KwhXvFp/BT+sZIs/0RA/cJLwlDfYbcOrh1TuiltEh362HlvuWNzbibXcMldnrBfC05ErfYuWXW/4Zzd6Ki+/84eqYn8DLvcCGDeaAlm8oJA8ecDVhrIrfF6UuEimf1fxRaBQvW3oR9HFJXvnm1ps7ZqdfOEAWEiAWrC91KGfAZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742278432; c=relaxed/simple;
	bh=wW11WPGWZXfeBr+65PzVK2Is1YZ5/NBbOpCTJYGtdZc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ltuRES+JjhNoYaVI5hZ35GGKrWhiEftT6/uku3adq6oSuMNfRvOhiOqfZS+KQm7v7aY/rdrgYBrjTerXeRTlmGNoi9hqw2Yrf8dn40frwWd11dtXLYeWfALEB0j4O8s9MeKDZSRwg6zDxxADFM2ZnjupEX1ZGkT7c7V2wlJBwuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=PN64qqgP; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="PN64qqgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1742278373;
	bh=APKMq1NbDiXH5foBPtZZIgWCd1f872XrI1YJfzrVDEo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=PN64qqgPG+C8eZ5262Q+fX+WoQWV6jPkd3ByRg6bu+EXZbe7xO17yXYVh5uZOCYvb
	 g+mTW0rR+apVlyuf8h83Aly2kuFAPk5wQ4wmwczt6w/N+GEyBxKcrb8Yf729I8EVQL
	 36yi2wlvIv6v8NckU80+Ec/qiAOcvwU5bfaZqqSI=
X-QQ-mid: bizesmtpip3t1742278305t0febod
X-QQ-Originating-IP: 7MGpOCn7dX77ZiiBcRKfnFhbCvQRGrudO7eH0JUYBeI=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 18 Mar 2025 14:11:43 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3640286069538374966
From: WangYuli <wangyuli@uniontech.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stern@rowland.harvard.edu,
	bvanassche@acm.org,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com,
	WangYuli <wangyuli@uniontech.com>,
	Xinwei Zhou <zhouxinwei@uniontech.com>,
	Xu Rao <raoxu@uniontech.com>,
	Yujing Ming <mingyujing@uniontech.com>
Subject: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks with "use_192_bytes_for_3f" attribute
Date: Tue, 18 Mar 2025 14:11:25 +0800
Message-ID: <798FB027101C5650+20250318061125.477498-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MOpOMm42OY9CTn4k3dPyxkpGDIynXj2Qm1ZjBexoy6JEKkgOjHpBrMVc
	NQ6jLIH/Q98Oxu/61ALt72Co2uipA3Tk1VsUkkQEWFN/n/k3HLFFZRROjPXUzOMbib3w9RD
	fYFUKJfW8PT4V33d7bQmST3Ieq/zc7JTH+zC+DL/BCP+c7KrG19K5v+mfTXz2SyJE1c4KEK
	YiwJlxZ0aVfQE4of6TW/k3ObnnmNPjpnTSPf6x4zIu52ZPoKmNITsP9L1VmygaGSWFZD/ns
	8lXaWhcenpwjld+V0C0QLY/mLwOMrnGLZ6ybO4KnQS66/4xFpFy3jOqYZJGQi3tsaomfSXh
	5Rpc3O5J7kbQMOW1SqFvPsBDy/CIDqx4MHdMbxIWL0ByCN37E153IC//aHZHDko1F2R12+H
	FTIMQmdrF4vKY6XJlh+UXcOrat/68lJepJy8XgAiyhszfSMpYpwaMCUhXDvXTYA4A9k1xPh
	D+ua16nIOn3Cyj09QxWgszKUheLdWCHfYiDJGAUKDD2f7U08oF0FpsQPdkkd5+NTiTsUA0Y
	3eNTn0kgFvZcIIz9DyovmvjeJE4gmxHtxs3Wt+i81+bxyNraIS4+EssJ1hxSgZma2ljNyzm
	k4UYQ07x8Vjoaj4lWy36Z0jpaMIXhx4Dqo14KZITj6fhR4q643MUvM0LWREXu9EAoMT7133
	Z6CGmt5Rs7NfjPOyxY4k2JdArvprN63JSEwvVoBgIwK8+hDAwFVK/ilBiHg+tWa+aemdXyF
	atISAy9ZLg9spYafdFcS4JoOCT8h6bozjQRnu1CaNkTLA8LJd5Ifab198n1+g850KA+oonx
	giq034y5tss7n2esBlBGgRzx9H+MkWhbEgXaiTFMnYNmknwRA8IEQwN+0FtqID+Sc2j2DGE
	X9cp5sr2ufnyOce3OxyHMguVh1K1/gQZbdf9L3tnc/+iSjbOVCAyA95fX5xqfPBQ3tubfWe
	k5jzVryuc6Tdl/ClRoJnxWwG/Fx3mSgczD+kZheExaA6+870yHDIB2+n8JTQ2wXjtdJjiZp
	zpj+C5fPH7S53gbFdvV1Kz14BEnQl7Tzb8SN4lDxqYno+WHrPl61jTe61dKZNz1rMhLc4h0
	y/YgUP2q2tvZr3mOMH5JqI=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

On some external USB hard drives, mounting can fail if "lshw" is
executed during the process.

This occurs because data sent to the device's output endpoint in
certain abnormal scenarios does not receive a response, leading to
a mount timeout.

[ Description of "use_192_bytes_for_3f" in the kernel code: ]
  /*
   * Many disks only accept MODE SENSE transfer lengths of
   * 192 bytes (that's what Windows uses).
   */
   sdev->use_192_bytes_for_3f = 1;

The kernel's SCSI driver, when handling devices with this attribute,
sends commands with a length of 192 bytes like this:
  if (sdp->use_192_bytes_for_3f)
  	res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 192, &data, NULL);

However, "lshw" disregards the "use_192_bytes_for_3f" attribute and
transmits data with a length of 0xff bytes via ioctl, which can cause
some hard drives to hang and become unusable.

To resolve this issue, prevent commands with a length of 0xff bytes
from being queued via ioctl when it detects the "use_192_bytes_for_3f"
attribute on the device.

The hard drive device identified with the issue is Lenovo USB 17ef:4531.
Tested on HONOR NBLK-WAX9X (C234) Notebook with AMD Ryzen 7 3700U.

[ Kernel logs: ]
  2024-10-31 13:36:11 localhost kernel: [   25.770091] usb 2-2: new SuperSpeed Gen 1 USB device number 2 using xhci_hcd
  2024-10-31 13:36:11 localhost kernel: [   25.798558] usb 2-2: New USB device found, idVendor=17ef, idProduct=4531, bcdDevice= 5.12
  2024-10-31 13:36:11 localhost kernel: [   25.798562] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  2024-10-31 13:36:11 localhost kernel: [   25.798564] usb 2-2: Product: Lenovo Portable HDD
  2024-10-31 13:36:11 localhost kernel: [   25.798566] usb 2-2: Manufacturer: Lenovo
  2024-10-31 13:36:11 localhost kernel: [   25.798567] usb 2-2: SerialNumber: 000000001E4C
  2024-10-31 13:36:11 localhost kernel: [   25.820244] usb-storage 2-2:1.0: USB Mass Storage device detected
  2024-10-31 13:36:11 localhost kernel: [   25.820457] scsi host0: usb-storage 2-2:1.0
  2024-10-31 13:36:11 localhost kernel: [   25.820633] usbcore: registered new interface driver usb-storage
  2024-10-31 13:36:11 localhost kernel: [   25.825598] usbcore: registered new interface driver uas
  2024-10-31 13:36:14 localhost kernel: [   28.852179] scsi 0:0:0:0: Direct-Access     Lenovo   USB Hard Drive   0006 PQ: 0 ANSI: 2
  2024-10-31 13:36:14 localhost kernel: [   28.852961] sd 0:0:0:0: Attached scsi generic sg0 type 0
  2024-10-31 13:36:14 localhost kernel: [   28.891218] sd 0:0:0:0: [sda] 976773164 512-byte logical blocks: (500 GB/466 GiB)
  2024-10-31 13:36:14 localhost kernel: [   28.906892] sd 0:0:0:0: [sda] Write Protect is off
  2024-10-31 13:36:14 localhost kernel: [   28.906896] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
  2024-10-31 13:36:14 localhost kernel: [   28.922606] sd 0:0:0:0: [sda] No Caching mode page found
  2024-10-31 13:36:14 localhost kernel: [   28.922612] sd 0:0:0:0: [sda] Assuming drive cache: write through
  2024-10-31 13:36:14 localhost kernel: [   29.007816]  sda: sda1
  2024-10-31 13:36:15 localhost kernel: [   30.180380] sd 0:0:0:0: [sda] Attached SCSI disk
  2024-10-31 13:36:16 localhost kernel: [   30.722863] snd_hda_codec_realtek hdaudioC1D0: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
  2024-10-31 13:36:16 localhost kernel: [   30.734139] snd_hda_codec_realtek hdaudioC1D0: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
  2024-10-31 13:36:17 localhost kernel: [   31.396011] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)
  2024-10-31 13:36:18 localhost kernel: [   32.933537] snd_hda_codec_realtek hdaudioC1D0: hda_codec_cleanup_stream: NID=0x3
  2024-10-31 13:36:18 localhost kernel: [   32.933541] snd_hda_codec_realtek hdaudioC1D0: hda_codec_cleanup_stream: NID=0x2
  2024-10-31 13:36:39 localhost kernel: [   54.242220] usb 2-2: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
  2024-10-31 13:36:50 localhost kernel: [   64.408879] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)
  2024-10-31 13:37:11 localhost kernel: [   85.466479] usb 2-2: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
  2024-10-31 13:37:11 localhost kernel: [   85.490248] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
  2024-10-31 13:37:11 localhost kernel: [   85.490255] sd 0:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 20 00 00 08 00
  2024-10-31 13:37:11 localhost kernel: [   85.490258] print_req_error: I/O error, dev sda, sector 32
  2024-10-31 13:37:33 localhost kernel: [  107.432186] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)
  2024-10-31 13:37:41 localhost kernel: [  116.194201] usb 2-2: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
  2024-10-31 13:37:49 localhost kernel: [  123.555484] dolphin[7271]: segfault at 10 ip 00007fcccc0d7f76 sp 00007ffe8004b860 error 4 in libKF5CoreAddons.so.5.102.0[7fcccc0a5000+83000]
  2024-10-31 13:37:49 localhost kernel: [  123.555502] Code: d6 90 66 90 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 e8 8e 94 01 00 ba 04 00 00 00 48 89 de 48 89 c7 e8 4e 8f 01 00 84 c0 75 2a <48> 8b 7d 10 48 85 ff 74 21 45 89 e1 48 89 da 48 89 ee 5b 41 b8 01
  2024-10-31 13:38:11 localhost kernel: [  146.229510] usb 2-2: USB disconnect, device number 2
  2024-10-31 13:38:11 localhost kernel: [  146.237993] scsi 0:0:0:0: rejecting I/O to dead device
  2024-10-31 13:38:11 localhost kernel: [  146.238003] print_req_error: I/O error, dev sda, sector 32
  2024-10-31 13:38:11 localhost kernel: [  146.238009] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238029] scsi 0:0:0:0: rejecting I/O to dead device
  2024-10-31 13:38:11 localhost kernel: [  146.238030] print_req_error: I/O error, dev sda, sector 36
  2024-10-31 13:38:11 localhost kernel: [  146.238032] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238045] scsi 0:0:0:0: rejecting I/O to dead device
  2024-10-31 13:38:11 localhost kernel: [  146.238047] print_req_error: I/O error, dev sda, sector 6291480
  2024-10-31 13:38:11 localhost kernel: [  146.238062] Buffer I/O error on dev sda1, logical block 786431, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238168] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238170] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238175] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238176] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238184] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238185] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238199] Buffer I/O error on dev sda, logical block 40, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238201] Buffer I/O error on dev sda, logical block 41, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238205] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238206] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238210] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238211] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238215] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238217] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238220] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238221] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238224] Buffer I/O error on dev sda, logical block 8, async page read
  2024-10-31 13:38:11 localhost kernel: [  146.238226] Buffer I/O error on dev sda, logical block 9, async page read
  2024-10-31 13:38:12 localhost kernel: [  146.482007] snd_hda_codec_realtek hdaudioC1D0: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
  2024-10-31 13:38:12 localhost kernel: [  146.494064] snd_hda_codec_realtek hdaudioC1D0: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
  2024-10-31 13:38:15 localhost kernel: [  150.065848] snd_hda_codec_realtek hdaudioC1D0: hda_codec_cleanup_stream: NID=0x3
  2024-10-31 13:38:15 localhost kernel: [  150.065852] snd_hda_codec_realtek hdaudioC1D0: hda_codec_cleanup_stream: NID=0x2
  2024-10-31 13:38:26 localhost kernel: [  160.433037] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)
  2024-10-31 13:39:29 localhost kernel: [  223.444589] start_addr=(0x20000), end_addr=(0x40000), buffer_size=(0x20000), smp_number_max=(16384)

Link: https://linux-hardware.org/?id=usb:17ef-4531
Link: https://lore.kernel.org/all/80ef917b-3680-4f85-93ba-c92d2b69ebaa@rowland.harvard.edu/
Link: https://lore.kernel.org/all/ad4bd008-8d0d-439b-879c-e9cf4c89ec56@acm.org/
Link: https://lore.kernel.org/all/4EB8ECD64F601331+e2f01a1f-8da5-4e7b-b909-d920a792756a@uniontech.com/
Reported-by: Xinwei Zhou <zhouxinwei@uniontech.com>
Co-developed-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Tested-by: Yujing Ming <mingyujing@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/scsi/scsi_lib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f1cfe0bb89b2..96f3418c0cdd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1565,6 +1565,7 @@ static void scsi_complete(struct request *rq)
 static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
+	struct scsi_device *sdev = cmd->device;
 	int rtn = 0;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
@@ -1613,6 +1614,17 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto done;
 	}
 
+	/*
+	 * Before we queue this command, check attribute use_192_bytes_for_3f.
+	 * Because transmits data with a length of 0xff bytes via ioctl may
+	 * cause some hard drives to hang and become unusable.
+	 */
+	if (cmd->cmnd[0] == MODE_SENSE && sdev->use_192_bytes_for_3f &&
+		cmd->cmnd[2] == 0x3f && cmd->cmnd[4] != 192) {
+		cmd->result = DID_ABORT << 16;
+		goto done;
+	}
+
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		goto done;
-- 
2.49.0

