From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Date: Sun, 23 Sep 2007 15:19:13 +0200
Message-ID: <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
References: <20070921085711.GG2367@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070921085711.GG2367@kernel.dk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/21/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> SG chaining bits:
> - This is the bulk of the patchset. It consists of three major
>   components:
>
>         - sglist-core, which add helpers for iterating sg lists and
>           switches the block layer and SCSI to use those. Should not
>           have any functional changes.
>         - sglist-drivers, which converts drivers to use the sg list
>           helpers. Again, should not contain functional changes.
>         - sglist-arch, which adds support to most architectures and
>           actually enables sg chaining.

Adding linux-ide and linux-scsi as CC like Andrew did with my last report.

I still have trouble with my Silicon Image, Inc. SiI 3132 Serial ATA
Raid II Controller as reported on 2.6.23-rc4-mm1 on the new
2.6.23-rc6-mm1.

I'm not 100% sure if this caused by the sg chaining, but the patch
from http://lkml.org/lkml/2007/9/10/251 which touches that chaining
makes a difference, so it might be related.

First report: http://lkml.org/lkml/2007/9/1/92
With patch it fails fewer times: http://lkml.org/lkml/2007/9/14/107

To update the statistik:
prior to 2.6.23-rc4-mm1: no trouble with any drives on the SiI 3132.
2.6.23-rc4-mm1 without patch: 2 out of 2 bad.
back to 2.6.23-rc3-mm1: 18x good.
2.6.23-rc4-mm1 with patch:  2 out of 8 bad
after that second mail:
2.6.23-rc4-mm1 with patch: 1 out of 5 bad
2.6.23-rc6-mm1: 1 out of 2 bad
switching back to 2.6.23-rc3-mm1 to rule out the hardware:
2.6.23-rc3-mm1: 6x good

The error messages from the failed 2.6.23-rc6-mm1:
Sep 18 18:50:01 treogen [   33.340000] md1: bitmap initialized from
disk: read 10/10 pages, set 0 bits
Sep 18 18:50:01 treogen [   33.340000] created bitmap (145 pages) for device md1
Sep 18 18:50:01 treogen [   63.440000] ata1.00: exception Emask 0x0
SAct 0x1 SErr 0x0 action 0x6 frozen
Sep 18 18:50:01 treogen [   63.440000] ata1.00: cmd
61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
Sep 18 18:50:01 treogen [   63.440000]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 18 18:50:01 treogen [   63.440000] ata1.00: status: {DRDY }
Sep 18 18:50:01 treogen [   63.440000] ata1: hard resetting link
Sep 18 18:50:01 treogen [   65.740000] ata1: softreset failed (port not ready)
Sep 18 18:50:01 treogen [   65.740000] ata1: reset failed (errno=-5),
retrying in 8 secs
Sep 18 18:50:01 treogen [   73.440000] ata1: hard resetting link
Sep 18 18:50:01 treogen [   75.740000] ata1: softreset failed (port not ready)
Sep 18 18:50:01 treogen [   75.740000] ata1: reset failed (errno=-5),
retrying in 8 secs
Sep 18 18:50:01 treogen [   83.440000] ata1: hard resetting link
Sep 18 18:50:01 treogen [   85.740000] ata1: softreset failed (port not ready)
Sep 18 18:50:01 treogen [   85.740000] ata1: reset failed (errno=-5),
retrying in 33 secs
Sep 18 18:50:01 treogen [  118.440000] ata1: limiting SATA link speed
to 1.5 Gbps
Sep 18 18:50:01 treogen [  118.440000] ata1: hard resetting link
Sep 18 18:50:01 treogen [  120.740000] ata1: softreset failed (port not ready)
Sep 18 18:50:01 treogen [  120.740000] ata1: reset failed, giving up
Sep 18 18:50:01 treogen [  120.740000] ata1.00: disabled
Sep 18 18:50:01 treogen [  120.740000] ata1: EH complete
Sep 18 18:50:01 treogen [  120.740000] sd 0:0:0:0: [sda] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 18 18:50:01 treogen [  120.740000] end_request: I/O error, dev
sda, sector 625137161
Sep 18 18:50:01 treogen [  120.740000] md: super_written gets
error=-5, uptodate=0
Sep 18 18:50:01 treogen [  120.740000] raid5: Disk failure on sda2,
disabling device. Operation continuing on 2 devices

After that many more errors like this, only differing in the sector number:
Sep 18 18:50:01 treogen [  120.810000] sd 0:0:0:0: [sda] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 18 18:50:01 treogen [  120.810000] end_request: I/O error, dev
sda, sector 19550919

Any more infos needed?

Torsten
