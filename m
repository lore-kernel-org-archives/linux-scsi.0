From: Mike Snitzer <snitzer@redhat.com>
Subject: rq-based mpath failed path on SCSI target failure (malformed discard)
Date: Mon, 26 Jul 2010 09:30:08 -0400
Message-ID: <20100726133008.GA26771@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0GZNaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 09:30:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com

Hi,

I have been implementing discard support for the various DM targets.  I
have a LUN that requires a 4K alignment for all discard requests.  I
forced the issue (by misconfiguring the alignment such that discards
would be misaligned).  Multipath failed the path once the SCSI layer got
the following error.

My question: shouldn't mpath _not_ fail the path for "Illegal
Request".. "Parameter value invalid"?  The same request would fail on
any path given that the failure is on the target side (rejecting the
malformed discard request).  Following setup is ext4 FS ontop of linear
DM mapping (dm-2) ontop of request-based mpath mapping (dm-1):

EXT4-fs (dm-2): mounted filesystem with ordered data mode
sd 3:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 3:0:0:0: [sda] Sense Key : Illegal Request [current] 
Info fld=0x0
sd 3:0:0:0: [sda] Add. Sense: Parameter value invalid
sd 3:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 45 82 00 00 03 00 00 00
end_request: I/O error, dev sda, sector 17794
device-mapper: multipath: Failing path 8:0.
end_request: I/O error, dev dm-1, sector 17794
end_request: I/O error, dev dm-1, sector 17794
end_request: I/O error, dev dm-1, sector 0
end_request: I/O error, dev dm-1, sector 386
quiet_error: 1228 callbacks suppressed
Buffer I/O error on device dm-2, logical block 1
lost page write due to I/O error on dm-2
Buffer I/O error on device dm-2, logical block 2
lost page write due to I/O error on dm-2
end_request: I/O error, dev dm-1, sector 904
Buffer I/O error on device dm-2, logical block 260
lost page write due to I/O error on dm-2
end_request: I/O error, dev dm-1, sector 926
Buffer I/O error on device dm-2, logical block 271
lost page write due to I/O error on dm-2
end_request: I/O error, dev dm-1, sector 934
Buffer I/O error on device dm-2, logical block 275
lost page write due to I/O error on dm-2
end_request: I/O error, dev dm-1, sector 966
Buffer I/O error on device dm-2, logical block 291
lost page write due to I/O error on dm-2
Buffer I/O error on device dm-2, logical block 292
lost page write due to I/O error on dm-2

Here is the relevant scsi trace:

        kdmflush-3658  [000] 952692.258948: scsi_dispatch_cmd_start: host_no=3 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=17794 txlen=768 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 45 82 00 00 03 00 00 00)
          <idle>-0     [000] 952692.259650: scsi_dispatch_cmd_done: host_no=3 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=17794 txlen=768 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 45 82 00 00 03 00 00 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_CHECK_CONDITION)
      multipathd-3661  [000] 952692.261484: scsi_dispatch_cmd_start: host_no=3 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(READ_10 lba=0 txlen=8 protect=0 raw=28 00 00 00 00 00 00 00 08 00)

