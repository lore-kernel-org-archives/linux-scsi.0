From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1
 operation
Date: Mon, 1 Oct 2012 04:46:05 -0400
Message-ID: <20121001084605.GA23497@infradead.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
 <1348984696-30992-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348984696-30992-2-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 30, 2012 at 05:58:11AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch re-adds the ability to optionally run in buffered FILEIO mode
> (eg: w/o O_DSYNC) for device backends in order to once again use the
> Linux buffered cache as a write-back storage mechanism.
> 
> This difference with this patch is that fd_create_virtdevice() now
> forces the explicit setting of emulate_write_cache=1 when buffered FILEIO
> operation has been enabled.

What this lacks is a clear reason why you would enable this inherently
unsafe mode.  While there is some clear precedence to allow people doing
stupid thing I'd least like a rationale for it, and it being documented
as unsafe.

> +	 /*

Indention error.

> +	 * Optionally allow fd_buffered_io=1 to be enabled for people
> +	 * who know what they are doing w/o O_DSYNC.
> +	 */

This comment doesn't explain at all what's going on here.  It should be
something like

	/*
	 * Unsafe mode allows disabling data integrity by not forcing
	 * data out to disk in writethrough cache mode.  Only to be used
	 * for benchmark cheating or similar purposes.
	 */

>  #define FBDF_HAS_PATH		0x01
>  #define FBDF_HAS_SIZE		0x02
> +#define FDBD_USE_BUFFERED_IO	0x04

This should be named BDBD_UNSAFE
