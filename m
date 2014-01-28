From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH 0/3] m68k/atari - Atari NCR5380 SCSI driver fixes (resent)
Date: Wed, 29 Jan 2014 12:55:21 +1300
Message-ID: <1390953324-19962-1-git-send-email-schmitz@debian.org>
References: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1388664474-1710039-3-git-send-email-arnd@arndb.de>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, arnd@arndb.de
List-Id: linux-scsi@vger.kernel.org

Geert,

this patch series brings the Atari NCR5380 driver up to date with current 3.x
(or perhaps even 2.6) series SCSI midlevel and error handling changes.

The first patch fixes completion condition errors contained in Arnd Bergmann's
patch ([PATCH, RFC 02/30] scsi: atari_scsi: fix sleep_on race). The locking
scheme still isn't 100% race free that way, but much improved, and I've seen
the driver successfully handle error recovery from aborting a disconnected
command via bus reset with all three patches applied (never managed to do that
since 2.4 days). 
Not sure whether this one should be taken through your tree or handled by Arnd
rather.

The other two are a rehash of old patches I had prepared somewhere along the
2.6 series - somehow or other these were lost when one of my old git trees
went pear shaped. 

Abort and reset handlers nowadays return SUCCESS or FAILED only, and the SCSI
midlevel now queues commands (in particular error handling ones) from soft
interrupt context - the Falcon locking scheme still is ill equipped to handle
that. Return codes have been changed and the reset handler in particular will
leave running command completion handlers to the midlevel now. 

If a SCSI command is queued while IDE or floppy have reserved the shared DMA
and interrupt, queue_command() may not wait for lock release and instead will
return SCSI_MLQUEUE_HOST_BUSY to indicate that. 

CC: to linux-scsi and the SCSI maintainer added as per your request. 

Cheers,

	Michael
