From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] target: Use scsi helpers to build the sense data
 correctly
Date: Fri, 3 Jul 2015 09:12:36 -0700
Message-ID: <20150703161236.GA32744@infradead.org>
References: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2015 at 06:05:25PM +0300, Sagi Grimberg wrote:
> Instead of open coding the sense buffer construction, use
> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
> helpers.
> 
> This patch also fixes wrong setting of descriptor format sense data
> for t10-pi integrity errors.

This looks good in general, but we'd need to move this functions to
the scsi common module first now that the target code doesn't use
scsi_mod.ko. (Oh, for some reason 4.2 still builds scsi_common.c into
scsi_mod.ko, but in the long run it shouldn't).

Whie we're at it I'd also really love to Barts sense handling
updates to go in:

https://github.com/bvanassche/linux/commit/c8e3ccce0753522cff50987db8e411be2b452cdd
https://github.com/bvanassche/linux/commit/50e0e2c6681091cda23e677fe9b6fbd2c70d99b1
https://github.com/bvanassche/linux/commit/02b27ec5c94117a976e16421556c1cb7287b6635

Bart, any chance you could resend them?
