From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no
 management
Date: Wed, 14 Oct 2015 11:34:00 -0700
Message-ID: <561EA018.7020700@suse.com>
References: <cover.1444241058.git.lduncan@suse.com>
 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
 <1444830904.2220.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444830904.2220.28.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/14/2015 06:55 AM, James Bottomley wrote:
> On Wed, 2015-10-07 at 16:51 -0700, Lee Duncan wrote:
>> Update the SCSI hosts module to use the ida_simple*() routines
>> to manage its host_no index instead of an ATOMIC integer. This
>> means that the SCSI host number will now be reclaimable.
> 
> OK, but why would we want to do this?  We do it for sd because our minor
> space for the device nodes is very constrained, so packing is essential.
> For HBAs, there's no device space density to worry about, they're
> largely statically allocated at boot time and not reusing the numbers
> allows easy extraction of hotplug items for the logs (quite useful for
> USB) because each separate hotplug has a separate and monotonically
> increasing host number.
> 
> James
> 

Good question, James. Apologies for not making the need clear.

The iSCSI subsystem uses a host structure for discovery, then throws it
away. So each time it does discovery it gets a new host structure. With
the current approach, that number is ever increasing. It's only a matter
of time until some user with a hundreds of disks and perhaps thousands
of LUNs, that likes to do periodic discovery (think super-computers)
will run out of host numbers. Or, worse yet, get a negative number
number (because the value is signed right now).

And this use case is a real one right now, by the way.

As you can see from the patch, it's a small amount of code to ensure
that the host number management is handled more cleanly.

-- 
Lee Duncan
