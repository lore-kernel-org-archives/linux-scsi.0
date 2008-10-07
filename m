From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Tue, 7 Oct 2008 17:33:16 -0600
Message-ID: <20081007233315.GM25780@parisc-linux.org>
References: <1223416391.8195.22.camel@brick> <1223417543.7484.7.camel@localhost.localdomain> <1223419166.8195.37.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1223419166.8195.37.camel@brick>
Sender: linux-arch-owner@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 07, 2008 at 03:39:25PM -0700, Harvey Harrison wrote:
> As an example, in the write command handling in achba.c, a patch similar to the following
> (assumes the existence of a __be24 type somewhere):

What type could be defined to be '__be24'?  Would

typedef struct {
	unsigned char data[3];
} __be24;

do the trick?  It's not an integral type, but I'm not sure if that matters.

> +				cmnd_lba = unaligned_be24_to_cpup(&tmp->lba) & 0x001FFFFF;

That might be easier to read if you're using a 500-column terminal.  For
the rest of us,
				cmnd_lba = scsi_get_u24(cmnd + 2) & 0x1FFFFF;
is much easier to read.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
