From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: SG_SCSI_RESET ioctl reset escalation
Date: Mon, 13 Oct 2014 22:24:01 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CEF205@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:16737 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaJMWZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2014 18:25:27 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

Currently, if you request a reset through ioctl and it fails,
the kernel escalates like it does for scsi_abort_eh_cmnd:
	bus device reset ->
		target reset ->
			bus reset ->
				host reset

This is from scsi_error.c scsi_ioctl_reset:

        switch (val) {
        case SG_SCSI_RESET_NOTHING:
                break;
        case SG_SCSI_RESET_DEVICE:
                rtn = scsi_try_bus_device_reset(scmd);
                if (rtn == SUCCESS)
                        break;
                /* FALLTHROUGH */
        case SG_SCSI_RESET_TARGET:
                rtn = scsi_try_target_reset(scmd);
                if (rtn == SUCCESS)
                        break;
                /* FALLTHROUGH */
        case SG_SCSI_RESET_BUS:
                rtn = scsi_try_bus_reset(scmd);
                if (rtn == SUCCESS)
                        break;
                /* FALLTHROUGH */
        case SG_SCSI_RESET_HOST:
                rtn = scsi_try_host_reset(scmd);
                if (rtn == SUCCESS)
                        break;
        default:
                /* FALLTHROUGH */
                error = -EIO;
                break;
        }

Those stronger reset levels affect multiple devices,
which may or may not be desired.

sg-reset includes a --no-esc option to ask the kernel
to not escalate resets, based on a February 2013 thread,
but the matching kernel changes were never merged.

Original issue:
http://marc.info/?l=linux-scsi&m=136000904311597&w=2

Suggested fix:
http://marc.info/?l=linux-scsi&m=136095718729372&w=2

Could that fix be revived?

---
Rob Elliott    HP Server Storage


