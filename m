From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Sun, 11 Nov 2018 08:42:42 -0500
Message-ID: <20181111134241.GA2447@thunk.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181111131445.GB25441@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2018 at 05:14:45AM -0800, Christoph Hellwig wrote:
> I think this goes in the wrong way.  There isn't really any point
> in filtering at all if we have access to the whole device by the
> file persmissions, and we generally should not allow any access for
> partitions.

It really depends on the security model being used on a particular
system.  I can easily imagine scenarios where userspace is allowed
full access to the device with respect to read/write/open, but the
security model doesn't want to allow access to various SCSI commands
such as firmware upload commands, TCG commads, the
soon-to-be-standardized Zone Activation Commands (which allow dynamic
conversion of HDD recording modes between CMR and SMR), etc.

And this is before we get to crazy container / namespace scenarios.
And *no*, let's not have a SG_IO namespace!  :-)

> I think we need to simplify the selection, not add crazy amounts of
> special case code.

I have the opposite opinions in terms of wanting more complex
filtering rules, but I also agree that special case C code is not the
answer --- and why I suggested that eBPF filtering rules is the right
way to go.

					- Ted
