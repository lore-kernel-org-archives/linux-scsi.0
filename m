From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Wed, 14 Oct 2015 06:55:04 -0700
Message-ID: <1444830904.2220.28.camel@HansenPartnership.com>
References: <cover.1444241058.git.lduncan@suse.com>
	 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-10-07 at 16:51 -0700, Lee Duncan wrote:
> Update the SCSI hosts module to use the ida_simple*() routines
> to manage its host_no index instead of an ATOMIC integer. This
> means that the SCSI host number will now be reclaimable.

OK, but why would we want to do this?  We do it for sd because our minor
space for the device nodes is very constrained, so packing is essential.
For HBAs, there's no device space density to worry about, they're
largely statically allocated at boot time and not reusing the numbers
allows easy extraction of hotplug items for the logs (quite useful for
USB) because each separate hotplug has a separate and monotonically
increasing host number.

James
