From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: sg timeout problem
Date: Wed, 6 May 2009 16:15:45 +0900
Message-ID: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.mail.tnz.yahoo.co.jp ([203.216.226.139]:34928 "HELO
	smtp11.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758519AbZEFHWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 03:22:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

struct sg_io_hdr sg_io;
[...]
sg_io.timeout = UINT_MAX;
[...]
ioctl(fd, SG_IO, &sg_io);

As far as I can tell, if sg is running on top of LIBATA, the infinite
timeout is honoured.

But if sg is running on top of an actual SCSI driver, someone aborts the
ioctl after 3 seconds.  The ioctl returns success even though the operation
didn't complete.  I tried this with two Adaptec drivers and one NinjaSCSI 
driver with 100% repro.

What am I missing?  I need the call to run to completion. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
