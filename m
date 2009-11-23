From: Jan Kara <jack@suse.cz>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Mon, 23 Nov 2009 11:54:40 +0100
Message-ID: <20091123105440.GB15679@duck.suse.cz>
References: <20091113050907.GA4965@roll>
 <20091119160700.GC2943@atrey.karlin.mff.cuni.cz>
 <20091120082359.GA29538@roll>
 <20091120094641.GB15422@duck.suse.cz>
 <20091123080919.GA3115@roll>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091123080919.GA3115@roll>
Sender: linux-ext4-owner@vger.kernel.org
To: tmhikaru@gmail.com
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  Hi,

On Mon 23-11-09 03:09:19, tmhikaru@gmail.com wrote:
> 	Okay, finally had some time to dismantle the machine in question and
> inserted the backup drive without the enclosure. Now that I was able to get
> smartctl to give me information on what was going on, it seems there's
> nothing wrong with the drive itself (no remapped sectors, nothing prefail or
> fail going wrong, drive's smart status is good) but it's had a history of
> 406 (!!!) errors reported, the last five happening within the same second,
> all of which seem (to my untrained eye) to imply a bad IDE cable. Which
> means likely my USB enclosure is screwing up.
> 
> 	To be sure, I did some extended testing with it hooked up: Tried
> doing a full and incremental backup of my machine with no errors reported,
> as well as an offline and then immediately afterwards, long test via
> smartctl. Nothing changed in the output.
  Yeah, from what you write, it looks like USB enclosure is at fault (or it
could still be your USB controller but I doubt it).  It's still a bit
bothering that the error reported by the drive was not properly propagated
up to VFS. Either it's some block layer retry/ignore magic that I missed or
we ignore errors from block layer in some place.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
