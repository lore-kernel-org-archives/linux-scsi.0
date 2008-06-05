From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1 of 3] block: Export I/O hints for block devices and
	partitions
Date: Thu, 05 Jun 2008 09:42:37 -0500
Message-ID: <1212676957.13549.23.camel@localhost.localdomain>
References: <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-06-05 at 01:22 -0400, Martin K. Petersen wrote:
> 3 files changed, 74 insertions(+)
> block/genhd.c         |   39 +++++++++++++++++++++++++++++++++++++++
> fs/partitions/check.c |   11 +++++++++++
> include/linux/genhd.h |   24 ++++++++++++++++++++++++

This looks good.  However, the first observation I would have is that
the hints should be extensible without disrupting existing code.

Something like

enum disk_hint {
	DISK_HINT_OFFSET,
	DISK_HINT_BLOCK,
	DISK_HINT_LEN,
};

void disk_set_io_hints(struct gendisk *disk, enum disk_hint hint, u64 value) {
	switch (hint) {
	case DISK_HINT_OFFSET:
		disk->phys_offset = (sector_t)val;
		break;
...
etc.

Because I can just bet we will find other hints that people want adding.

I'm also not entirely sure that zero should be the no-hint value, but I
could be persuaded on that because I can't see a case where setting zero
to mean I'm telling you I definitely don't care should be different from
not setting it.

James


