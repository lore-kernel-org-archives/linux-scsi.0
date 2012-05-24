From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Thu, 24 May 2012 10:52:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205241049050.1349-100000@iolanthe.rowland.org>
References: <CAF1ivSZBasH-Nvw7kvOynN+XQqiOLfeyOnV5HjNbz5dyZJfkoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSZBasH-Nvw7kvOynN+XQqiOLfeyOnV5HjNbz5dyZJfkoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 May 2012, Lin Ming wrote:

> > When tested the patches, I found that kjournald and flusher thread
> > frequently resume the disk.
> 
> Just found that it's because "printk".
> 
> When disk is suspended, it prints out some message, for example,
> 
> [  670.597103] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  670.597827] sd 0:0:0:0: [sda] Stopping disk
> 
> Then syslogd is waken up to write the log.
> So disk is resumed right after suspended.

:-)  Very amusing!  So if you change those two messages in sd_suspend
(and maybe also the message in sd_resume) from KERN_NOTICE to
KERN_DEBUG, things ought to improve.

Alan Stern
