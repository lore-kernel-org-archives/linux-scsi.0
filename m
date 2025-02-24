Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984232F37;
	Mon, 24 Feb 2025 03:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740368997; cv=none; b=etAm/Z7PIkWlGeHf1Y+6+6jSJ9S3WVacTZ/bOQggdrA55Vx47gpXv5FeaVPInIqqKZI3UcMUaEvtc6sPwva+z1boJWfubh+jI+8fRBTKYNko/1CEfmZZb/QB98lqAXFx90mSakzSANIlRW2lf49+MAwGPcUqnGpqyigJgJMqQrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740368997; c=relaxed/simple;
	bh=ucpFcICbXnxqon+vc03f0t+KDNO8IRHqAMw6VI4V3PM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LIhyWWsYUkitYIOdSYwDBEzcOhZ0RZdmPARe9uQED7OqXqo1QG3l9qjbzDV+jwk0EK+Ti4h5myRmCgN/jCuO386cWQkDCT3ZPd59OTa9Ek9ByeqI/ydkCFjjmrKQyEK9Zt7+galMSXXuzo7y3QqB7IuLFGW3nK8x3KLSxbB4OB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=nr0eOB0S; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="nr0eOB0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1740368938;
	bh=EnAZ452qoUGgtUThxJU++mXh5YKV0rU6C42JkdV8iCc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=nr0eOB0S6b0Y69CtK/FhLXFr5N3PZGGKMfG1r2a8Xw5F/rSj9ozG8d8pXZMsYIYqG
	 SzLuuUvQr1tgESFUZcSmteaoSBr99b1ypjSQVfNpFxwg74Vu3W7e3Gu+PP31B4MDq+
	 5cCt74XPFGtvDLLxrauMjbkwcRFDX8LBttRix2/c=
X-QQ-mid: bizesmtpip4t1740368920too81bh
X-QQ-Originating-IP: hD3FSCRwadebq84E+cIw3Lr6rGdy/WKTu7vigxlQwaA=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 24 Feb 2025 11:48:38 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1507648413831126121
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
	chenlinxuan@uniontech.com,
	WangYuli <wangyuli@uniontech.com>,
	Xinwei Zhou <zhouxinwei@uniontech.com>,
	Xu Rao <raoxu@uniontech.com>,
	Yujing Ming <mingyujing@uniontech.com>
Subject: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks with "use_192_bytes_for_3f" attribute
Date: Mon, 24 Feb 2025 11:48:32 +0800
Message-ID: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: Mk3s51uRGBS+8pT5vRQHp0igKKkGd682qJcXkEkqiwhVwXgsHyXtw7yn
	pmDxpUopAf7tWuKF5eXlVsgDV0Ni0FhJBpYWyI2DsMcYIoHY3jFh0l78x1XNxK92X6qhG8D
	jirhEkDbfHvTjamMQtylChytNp5EAdnKuOLCnE05bz3898F3rs+Rw3kFxD1ZN4BD7bhxnmQ
	seGjysV7ktXXEra2LseTD8teBcKnSYyuui2dgTSC75wANAevhMmCCqTt67+lbiWygRIo1kz
	rM6KZBVLgON/Yh9uKap6J6eX9ZehkjqHVtnU7CgnXIFir1016WdVLe3X0mKX/uqnC9SafyN
	cNOgK/YWdbywdQ6ysLemx426eCxKRkoBtWJs1awIr6WVDoX17fLi0XazlF9eEKdXiQZmbIJ
	WHGQOW+gHPFj2Pn2iSuhzbk++YKVqvG0JyuyXV5xNI5TiyslP22uHMAsNYTkNskPQ2tNQLe
	MB5mEmucBDeTKFrzIV1eQJ0liS67Gk4nT1WRav/biQAmb9qAVg67eizluRSKnJYN265YwUh
	NnqCAycemvpwgQdznHheBZatJWz/kBWeyq8VzSKyyissNYeFdtJYoWfwXw/hqhD7IWRzaEo
	g0KN/3JDi34wqp843QS0Pz9Ijlz14d3zzMjuhOp1kh8TrSo4izCFHvd5tk5wb/nsVObdTPB
	epyJmaXEOI9idF/yFMLxBCIWE7t6Zj56RHSWhb9rzLlqpEYOk/Arh527w61xOExVOZyaAdf
	Igs+RcJmmdY0uLMC4OtgY5BacT+b02kU3Y6bNbLXjce/Ef84ega5OpcR2zux8r7Q4FqXujv
	/yA1ykk2oZ0hudhIysF0aH7pqRFoKYSvdlIFPa2TtEEPiBcr0qNYLxLo5TzZ6I4+RtFV4df
	ydJ00pZFdgnepAX+EIMGB5+Qeisx8/iYIpPI/zGw64MmaM14X2L4QxfvNce4F6d/h+cRcJl
	uxz23iHmtJfHLJXqt63wZhSBn8AvbARXsqQ4X9cXwwUyHgQyc0px9LQXUz3v5m0keTrGi2J
	aM70JBR1rA+F5plgXkXfawOhgaaIlWTDsYY1hKizSh3myI+mi7RIs5lSjU0Lo=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
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
Reported-by: Xinwei Zhou <zhouxinwei@uniontech.com>
Co-developed-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Tested-by: Yujing Ming <mingyujing@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
Changelog:
 *v1->v2: Move the bugfix to the SCSI layer.
  v2->v3: Optimize code style and comment readability.
---
 drivers/scsi/scsi_lib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be0890e4e706..29371826fc85 100644
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
2.47.2

