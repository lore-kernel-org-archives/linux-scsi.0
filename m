From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 1/2 scsi-misc] qla1280: use request_firmware
Date: Wed, 8 Apr 2009 00:43:42 -0700
Message-ID: <20090408074342.GA3919@sgi.com>
References: <1238654083.4940.8.camel@ht.satnam> <1238654959.4940.12.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.156.57]:33847 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbZDHHnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2009 03:43:45 -0400
Content-Disposition: inline
In-Reply-To: <1238654959.4940.12.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jes Sorensen <jes@sgi.com>, David Woodhouse <dwmw2@infradead.org>, holt@sgi.com

On Thu, Apr 02, 2009 at 12:19:19PM +0530, Jaswinder Singh Rajput wrote:
> It seems LKML is rejected old email because of big size. so I am CC LKML
> after deleting firmware blobs:
> 
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Thu, 2 Apr 2009 11:13:17 +0530
> Subject: [PATCH] qla1280: use request_firmware
> 
> Firmware blob is little endian looks like this...
>         unsigned char  Version1
>         unsigned char  Version2
>         unsigned char  Version3
>         unsigned char  Padding
>         unsigned short start_address
> 	unsigned short data

This patch causes a problem.  It looks as though the firmware file may be
incorrectly built for at least 12160.  We get a checksum error from the
ISP12160 when it does the checksum:

qla1280 0001:00:03.0: firmware: using built-in firmware qlogic/12160.bin
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x6000
m0 4003, m1 b141, m2 5555, m3 aa55
m4 55aa, m5 a5a5, m6 5a5a, m7 2525
scsi(0): RISC checksum failed.
scsi(0): initialize: pci probe failed!
qla1x160: Failed to initialize adapter


>From qla1280_start_firmware():
        /* Verify checksum of loaded RISC code. */
        mb[0] = MBC_VERIFY_CHECKSUM;
        /* mb[1] = ql12_risc_code_addr01; */
        mb[1] = ha->fwstart;
        err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
        if (err) {
                printk(KERN_ERR "scsi(%li): RISC checksum failed.\n", ha->host_no);
                return err;
        }

jeremy


> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/scsi/ql1040_fw.h       | 2130 ----------------------------------------
>  drivers/scsi/ql12160_fw.h      | 1811 ----------------------------------
>  drivers/scsi/ql1280_fw.h       | 2048 --------------------------------------
>  drivers/scsi/qla1280.c         |  114 ++-
>  drivers/scsi/qla1280.h         |    6 +
>  firmware/Makefile              |    2 +
>  firmware/WHENCE                |   13 +
>  firmware/qlogic/1040.bin.ihex  | 2111 +++++++++++++++++++++++++++++++++++++++
>  firmware/qlogic/12160.bin.ihex | 1771 +++++++++++++++++++++++++++++++++
>  firmware/qlogic/1280.bin.ihex  | 2008 +++++++++++++++++++++++++++++++++++++
>  10 files changed, 5985 insertions(+), 6029 deletions(-)
>  delete mode 100644 drivers/scsi/ql1040_fw.h
>  delete mode 100644 drivers/scsi/ql12160_fw.h
>  delete mode 100644 drivers/scsi/ql1280_fw.h
>  create mode 100644 firmware/qlogic/1040.bin.ihex
>  create mode 100644 firmware/qlogic/12160.bin.ihex
>  create mode 100644 firmware/qlogic/1280.bin.ihex
