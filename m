From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write protected devices, unexpected dm-multipath queueing
Date: Fri, 6 Jan 2012 17:32:12 -0500
Message-ID: <20120106223212.GB2393@redhat.com>
References: <1325878251.19595.13.camel@lapoo.opensvc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2AFWc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2012 17:32:26 -0500
Content-Disposition: inline
In-Reply-To: <1325878251.19595.13.camel@lapoo.opensvc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "cyril.galibern" <cyril.galibern@opensvc.com>, linux-scsi@vger.kernel.org

On Fri, Jan 06 2012 at  2:30pm -0500,
Christophe Varoqui <christophe.varoqui@gmail.com> wrote:

> Hannes, list,
> 
> reading your kernel path there
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=63583cca745f440167bf27877182dc13e19d4bcf
> I wonder if this is expected that a write io on a write protected device
> is returned to the queue ? I would have guessed it qualified as
> TARGET_ERROR, hence not retryable (and not causing path invalidation).
> 
> In the following log the sense code is clearly seen as 
> Sense Key : Data Protect [current]
> Add. Sense: Write protected
> 
> The log is grabbed from a el6 kernel rev. 131 which include the
> mentioned patch (since rev. 110 iirc).
> 
> Care to confirm something is fishy there ?

scsi_check_sense() needs to be trained to return TARGET_ERROR for this
case.

The commit you referenced wasn't meant to have covered _every_ possible
TARGET_ERROR case.  For example, I posted a patch for other TARGET_ERROR
cases here:
http://www.spinics.net/lists/linux-scsi/msg55792.html

> ====
> 
> Jan  6 02:54:20 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 0
> 
> Jan  6 02:54:20 wheeler multipathd: 360000970000292602571533030384444:
> Entering recovery mode: max_retries=5
> 
> Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
> sdbq - tur checker reports path is up
> 
> Jan  6 02:54:23 wheeler multipathd: 68:64: reinstated
> 
> Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
> queue_if_no_path enabled
> 
> Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
> Recovered to normal mode
> 
> Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 1
> 
> Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Unhandled sense code
> 
> Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> 
> Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Sense Key : Data
> Protect [current] 
> 
> Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Add. Sense: Write
> protected
> 
> Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] CDB: Write(10): 2a
> 00 00 00 00 d0 00 00 10 00
> 
> Jan  6 02:54:23 wheeler kernel: end_request: I/O error, dev sdbq, sector
> 208
> 
> Jan  6 02:54:23 wheeler kernel: device-mapper: multipath: Failing path
> 68:64.
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> sdq - tur checker reports path is up
> 
> Jan  6 02:54:24 wheeler multipathd: 65:0: reinstated
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 2
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> sdaq - tur checker reports path is up
> 
> Jan  6 02:54:24 wheeler multipathd: 66:160: reinstated
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 3
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> sdcq - tur checker reports path is up
> 
> Jan  6 02:54:24 wheeler multipathd: 69:224: reinstated
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 4
> 
> Jan  6 02:54:24 wheeler multipathd: 68:64: mark as failed
> 
> Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 3
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Unhandled sense code
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Sense Key : Data
> Protect [current] 
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Add. Sense: Write
> protected
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] CDB: Write(10): 2a 00
> 00 00 00 d0 00 00 10 00
> 
> Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdq, sector
> 208
> 
> Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
> 65:0.
> 
> Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Unhandled sense code
> 
> Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> 
> Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Sense Key : Data
> Protect [current] 
> 
> Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Add. Sense: Write
> protected
> 
> Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] CDB: Write(10): 2a
> 00 00 00 00 d0 00 00 10 00
> 
> Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdcq, sector
> 208
> 
> Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
> 69:224.
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Unhandled sense code
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Result:
> hostbyte=invalid driverbyte=DRIVER_SENSE
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Sense Key : Data
> Protect [current] 
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Add. Sense: Write
> protected
> 
> Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] CDB: Write(10): 2a
> 00 00 00 00 d0 00 00 10 00
> 
> Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdaq, sector
> 208
> 
> Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
> 66:160.
> 
> Jan  6 02:54:25 wheeler multipathd: 65:0: mark as failed
> 
> Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 2
> 
> Jan  6 02:54:25 wheeler multipathd: 66:160: mark as failed
> 
> Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 1
> 
> Jan  6 02:54:25 wheeler multipathd: 69:224: mark as failed
> 
> Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
> Entering recovery mode: max_retries=5
> 
> Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
> remaining active paths: 0
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
