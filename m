From: Doug Ledford <dledford@redhat.com>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 17:22:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122222247.GB18664@redhat.com>
References: <20021122183603.GC16865@redhat.com> <20021122204538.A10657@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021122204538.A10657@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 08:45:38PM +0000, Christoph Hellwig wrote:
> On Fri, Nov 22, 2002 at 01:36:03PM -0500, Doug Ledford wrote:
> > Like last time, this has been through a full compile test, but not a boot 
> > test.  I'm heading up to the office next so the boot test will come 
> > shortly.  But, because it touches lots of files, again, I thought I would 
> > go ahead and push it up for people to see.  If there are no objections to 
> > this or my previous patches, then once the boot test is complete and I'm 
> > satisfied things are working properly, I'll push the whole lot to Linus 
> > (which will necessarily include the scsi-misc-2.5 changes because they are 
> > in my tree as well).
> 
> Heh, now you managed to get stuff commited before me and I need to merge
> up :)  But your changes help me a lot in fact so I surely won't complain.

Quoting from my email yesterday:

It's a race Charlie Brown!

;-)

> Two comments: 
> 
>  o as you already had to change all callers of host->host_queue/
>    host->my_devices could you add a lock to properly protect it?  That's
>    pretty important for hotplugging/etc.. (like the fc hotplug patch
>    from montavista)

I'm actually thinking that the locking of the devices is not needed as 
long as the next step is to A) make sure that all people walking the 
my_devices list already are holding a reference to the parent host vi 
host_get_*() and B) that proper locking for hosts is actually implemented 
in the host_get*() routines instead of the stub comments that are there 
now.

>  o what's the reason in continuing after an error from scsi_add_host
>    in scsi_add_host?  IMHO it doesn't make much sense to continue the
>    bus scan in that case.

There's no guarantee that devices later on in the chain will fail to 
attach, so I saw little reason to leave things half done.  If they all 
fail after the first failure, then we are no worse off then by bailing 
early, but if some actually succeed then we are better off.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
