From: Jochen Friedrich <jochen@scram.de>
Subject: Re: [linux-usb-devel] USB storage problems (2.5.69 BK)
Date: Tue, 27 May 2003 21:59:56 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305272158030.910-100000@gfrw1044.bocc.de>
References: <UTC200305262302.h4QN2PF04675.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.scram.de ([195.226.127.112]:9221 "EHLO mail2.scram.de")
	by vger.kernel.org with ESMTP id S264057AbTE0Trj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 15:47:39 -0400
In-Reply-To: <UTC200305262302.h4QN2PF04675.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hi Andries,

> (iii) maybe your device wants to return more bytes than 4;
>       the error is -EOVERFLOW, that is, "babble".
>       I expect my recent patch would help.

Unfortunately, it doesn't. The "babble" still happens, even if requesting
8 bytes:

Before patching:

May 26 08:21:00 gfrw1044 kernel: sdc: Mode Sense: 4b 00 00 08
May 26 08:21:00 gfrw1044 kernel: usb-storage: queuecommand() called
May 26 08:21:00 gfrw1044 kernel: usb-storage: *** thread awakened.
May 26 08:21:00 gfrw1044 kernel: usb-storage: Command MODE_SENSE (6 bytes)
May 26 08:21:00 gfrw1044 kernel: usb-storage:  1a 48 08 00 04 00
May 26 08:21:00 gfrw1044 kernel: usb-storage: Bulk command S 0x43425355 T 0x12 Trg 0 LUN 2 L 4 F 128 CL 6
May 26 08:21:00 gfrw1044 kernel: usb-storage: usb_stor_bulk_transfer_buf(): xfer 31 bytes
May 26 08:21:00 gfrw1044 kernel: usb-storage: Status code 0; transferred 31/31
May 26 08:21:00 gfrw1044 kernel: usb-storage: -- transfer complete
May 26 08:21:00 gfrw1044 kernel: usb-storage: Bulk command transfer result=0
May 26 08:21:00 gfrw1044 kernel: usb-storage: usb_stor_bulk_transfer_buf(): xfer 4 bytes
May 26 08:21:00 gfrw1044 kernel: drivers/usb/host/uhci-hcd.c: uhci_result_common() failed with status 500000
May 26 08:21:00 gfrw1044 kernel: [c3003240] link (03003212) element (03002030)
May 26 08:21:00 gfrw1044 kernel:   0: [c3002030] link (00000001) e3 SPD IOC Stalled Babble Length=3 MaxLen=3 DT1 EndPt=1 Dev=2, PID=69(IN) (buf=0076ae00)

With patch to sd.c applied and translation 6->10:

May 27 21:40:57 gfrw1044 kernel: sdc: Mode Sense: 47 00 00 ff
May 27 21:40:57 gfrw1044 kernel: usb-storage: queuecommand() called
May 27 21:40:57 gfrw1044 kernel: usb-storage: *** thread awakened.
May 27 21:40:57 gfrw1044 kernel: usb-storage: Command MODE_SENSE (6 bytes)
May 27 21:40:57 gfrw1044 kernel: usb-storage:  1a 48 08 00 08 00
May 27 21:40:57 gfrw1044 kernel: usb-storage: Invoking Mode Translation
May 27 21:40:57 gfrw1044 kernel: usb-storage: Bulk command S 0x43425355 T 0x12 Trg 0 LUN 2 L 8 F 128 CL 12
May 27 21:40:57 gfrw1044 kernel: usb-storage: usb_stor_bulk_transfer_buf(): xfer 31 bytes
May 27 21:40:57 gfrw1044 kernel: usb-storage: Status code 0; transferred 31/31
May 27 21:40:57 gfrw1044 kernel: usb-storage: -- transfer complete
May 27 21:40:57 gfrw1044 kernel: usb-storage: Bulk command transfer result=0
May 27 21:40:57 gfrw1044 kernel: usb-storage: usb_stor_bulk_transfer_buf(): xfer 8 bytes
May 27 21:40:57 gfrw1044 kernel: drivers/usb/host/uhci-hcd.c: uhci_result_common() failed with status 500000
May 27 21:40:57 gfrw1044 kernel: [c0e40240] link (00e40212) element (00dfb030)
May 27 21:40:57 gfrw1044 kernel:   0: [c0dfb030] link (00000001) e3 SPD IOC Stalled Babble Length=7 MaxLen=7 DT1 EndPt=1 Dev=2, PID=69(IN) (buf=00ebfe00)

Thanks,
--jochen

