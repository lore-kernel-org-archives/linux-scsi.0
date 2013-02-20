From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/14] Corrections and customization of the SG_IO command
 whitelist (CVE-2012-4542)
Date: Wed, 20 Feb 2013 17:12:48 +0100
Message-ID: <5124F600.9030908@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 06/02/2013 16:15, Paolo Bonzini ha scritto:
> This series regards the whitelist that is used for the SG_IO ioctl.  This
> whitelist has three problems:
> 
> * the bitmap of allowed commands is designed for MMC devices (roughly,
>   "play/burn CDs without requiring root") but some opcodes overlap across SCSI
>   device classes and have different meanings for different classes.
> 
> * also because the bitmap of allowed commands is designed for MMC devices
>   only, some commands are missing even though they are generally useful and
>   not insecure.  At least not more insecure than anything else you can
>   do if you have access to /dev/sdX or /dev/stX nodes.
> 
> * the whitelist can be disabled per-process but not per-disk.  In addition,
>   the required capability (CAP_SYS_RAWIO) gives access to a range of other 
>   resources, enough to make it insecure.
> 
> The series corrects these problems.  Patches 1-4 solve the first problem,
> which also has an assigned CVE, by using different bitmaps for the various
> device classes.  Patches 5-11 solve the second by adding more commands
> to the bitmaps.  Patches 12 and 13 solve the third, and were already
> posted but ignored by the maintainers despite multiple pings.
> 
> Note: checkpatch hates the formatting of the command table.  I know about this,
> and ensured that there are no errors in the rest of the code.  The current
> formatting is IMHO quite handy, and roughly based on the files available
> from the SCSI standard body.
> 
> Ok for the next merge window?
> 
> Paolo
> 
> v1->v2: remove 2 MMC commands and 6 SBC commands (see patches 6 and 9
>         for details).  Added patch 14 and added a few more scanner
>         commands based on SANE (scanners are not whitelisted by default,
>         also were not in v1, but this makes it possible to opt into the
>         whitelist out of paranoia).  Removed C++ comments.  Removed the
>         large #if 0'd list of commands that the kernel does not pass
>         though.  Marked blk_set_cmd_filter_defaults as __init.

Ping...

Jens/James, is anyone going to pick this up for 3.9?

Paolo

> 
> Paolo Bonzini (14):
>   sg_io: pass request_queue to blk_verify_command
>   sg_io: reorganize list of allowed commands
>   sg_io: use different default filters for each device class
>   sg_io: resolve conflicts between commands assigned to multiple
>     classes (CVE-2012-4542)
>   sg_io: whitelist a few more commands for rare & obsolete device types
>   sg_io: whitelist another command for multimedia devices
>   sg_io: whitelist a few more commands for media changers
>   sg_io: whitelist a few more commands for tapes
>   sg_io: whitelist a few more commands for disks
>   sg_io: whitelist a few obsolete commands
>   sg_io: mark blk_set_cmd_filter_defaults as __init
>   sg_io: remove remnants of sysfs SG_IO filters
>   sg_io: introduce unpriv_sgio queue flag
>   sg_io: use unpriv_sgio to disable whitelisting for scanners
> 
>  Documentation/block/queue-sysfs.txt |    8 +
>  block/blk-sysfs.c                   |   33 +++
>  block/bsg.c                         |    2 +-
>  block/scsi_ioctl.c                  |  369 ++++++++++++++++++++++++++---------
>  drivers/scsi/scsi_scan.c            |   14 ++-
>  drivers/scsi/sg.c                   |    6 +-
>  include/linux/blkdev.h              |    8 +-
>  include/linux/genhd.h               |    9 -
>  include/scsi/scsi.h                 |    3 +
>  9 files changed, 344 insertions(+), 108 deletions(-)
> 
