From: Jeff Garzik <jeff@garzik.org>
Subject: Getting 'sync' to flush disk cache?
Date: Mon, 14 Aug 2006 14:39:47 -0400
Message-ID: <44E0C373.6060008@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

So...  has anybody given any thought to enabling fsync(2), fdatasync(2), 
and sync_file_range(2) issuing a [FLUSH|SYNCHRONIZE] CACHE command?

This has bugged me for _years_, that Linux does not do this.  Looking at 
forums on the web, it bugs a lot of other people too.

My suggestion would be to add a FLUSH op alongside the existing READ and 
WRITE[_SYNC] ops, rather than passing down WRITE_SYNC.  Why?  Doing so 
maintains a 1-1 translation between requests and disk commands, and it 
would allow MD and DM more flexibility in handling this operation.

But that's just a guess.  I'm open to suggestions.

	Jeff


