From: Martin Zuziak <zuziak@math.ku.dk>
Subject: Re: aic79xx driver - hotswap error
Date: Thu, 31 Aug 2006 13:16:47 +0200
Message-ID: <20060831111647.GE7963@pc00112f87ceed.math.ku.dk>
References: <20060828121542.GA13993@pc000ffe3ca343.math.ku.dk> <1156779911.28832.28.camel@fc6.xsintricity.com> <44F40854.4050902@suse.de> <20060830132345.GA9100@pc000ffe3ca343.math.ku.dk> <44F59582.6000609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imf.math.ku.dk ([130.225.103.32]:64995 "EHLO mail.math.ku.dk")
	by vger.kernel.org with ESMTP id S1751490AbWHaLQ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 07:16:57 -0400
Content-Disposition: inline
In-Reply-To: <44F59582.6000609@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org

> >Thank you both for your replies.
> >
> >First off all the hardware (both server and disks) does support hot
> >swap. And I have tried on three different machines (same model) to rule
> >out a hardware fault.
> >
> >I have never had any problems with hot swap before. And indeed hot swap
> >on these machines work with the 2.6.15.7 kernel. But something has
> >changed since 2.6.16 so it no longer works.
> >
> Hmm. But you should see something in the logs for 2.6.15, too.
> Ideally some aic79xx stack dump. Can you dig it out?
> If a aic79xx state dump is available for 2.6.15 we might be able to 
> figure out the difference and fix the driver if possible.

No stack dump is logged and I don't know how to force one.

After echoing "scsi remove-single-device 1 0 2 0" to /proc/scsi/scsi
nothing is logged.

After the disk is physically removed from its bay this is logged:
Aug 31 12:45:58 nyimf kernel: scsi1: Someone reset channel A

And when it's re-inserted:
Aug 31 12:46:24 nyimf kernel: scsi1: Someone reset channel A

After echoing "scsi add-single-device 1 0 2 0" to /proc/scsi/scsi the
disk is detected and ready to use:
Aug 31 12:46:45 nyimf kernel:   Vendor: IBM-ESXS  Model: VPR036C3-ETS10FN  Rev: S3C0
Aug 31 12:46:45 nyimf kernel:   Type:   Direct-Access                      ANSI SCSI revision: 04
Aug 31 12:46:45 nyimf kernel:  target1:0:2: asynchronous.
Aug 31 12:46:45 nyimf kernel: scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
Aug 31 12:46:45 nyimf kernel:  target1:0:2: Beginning Domain Validation
Aug 31 12:46:45 nyimf kernel:  target1:0:2: wide asynchronous.
Aug 31 12:46:45 nyimf kernel:  target1:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 127)
Aug 31 12:46:45 nyimf kernel:  target1:0:2: Domain Validation skipping write tests
Aug 31 12:46:45 nyimf kernel:  target1:0:2: Ending Domain Validation
Aug 31 12:46:49 nyimf udevd-event[20583]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:06.0/0000:07:00.0/0000:08:07.1/host1/target1:0:2/1:0:2:0/bus' failed
Aug 31 12:46:52 nyimf udevd-event[20583]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:06.0/0000:07:00.0/0000:08:07.1/host1/target1:0:2/1:0:2:0/ioerr_cnt' failed
Aug 31 12:46:54 nyimf kernel: sdc: Spinning up disk............ready
Aug 31 12:46:54 nyimf kernel: SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
Aug 31 12:46:54 nyimf kernel: SCSI device sdc: drive cache: write through
Aug 31 12:46:54 nyimf kernel: SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
Aug 31 12:46:54 nyimf scsi_id[20586]: scsi_id: unable to access parent device of '/block/sdc'
Aug 31 12:46:54 nyimf kernel: SCSI device sdc: drive cache: write through
Aug 31 12:46:54 nyimf scsi_id[20587]: scsi_id: unable to access parent device of '/block/sdc'
Aug 31 12:46:54 nyimf kernel:  sdc:
Aug 31 12:46:54 nyimf kernel: sd 1:0:2:0: Attached scsi disk sdc
Aug 31 12:46:54 nyimf kernel: sd 1:0:2:0: Attached scsi generic sg2 type 0

> But saying that 'hotswap is supported' simply doesn't cut it.
> The spec actually allows you to claim 'hotswap is supported' when you 
> have to power-cycle the entire cabinet.
> Or the HBA.

I don't think IBM designed the server that way. But I must admit to
knowing very little about scsi. It just seemed suspicious that hot
swapping stopped working with 2.6.16 when the changelog showed a lot of
changes to the aic79xx driver.

Sincerely,

Martin Zuziak <zuziak@math.ku.dk>

