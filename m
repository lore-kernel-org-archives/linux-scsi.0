From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Sat, 16 Nov 2002 21:59:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117025901.GA24557@redhat.com>
References: <20021116204009.A24052@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021116204009.A24052@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Nov 16, 2002 at 08:40:09PM +0100, Christoph Hellwig wrote:
> There's a bunch of useless mod usecount handling in scsi:
> 
> o MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in exported functions that
>   are only used outside this module - a module that has exported
>   symbols use by other modules can't be unloaded at all
> o GET_USE_COUNT checks in scsi_unregister_device/scsi_unregister_host -
>   the scsi layer shouldn't care about the mod use count of the modules
>   implementing drivers, and as they are usually called from the mod
>   unload handler the check is totally pointless (if it ever triggers
>   the scsi midlayer could try to scramble at freed memory).  Also
>   GET_USE_COUNT is disfunct with the new module loader
> o lacking ->owner in megaraid's chardev leading to junk
> o double-increment of the modules use count in upper layer drivers
>   (chardev/bdev open already gets a reference on ->owner for us)
> 
> I also had a patch to get the increment on the host driver module
> in upper layer ->open right, but as Rusty's new loader changed the
> interface for that I'll submit that one once the new loader appears
> in the scsi tree.

[ snipped patch ]

This patch conflicts with one I had internally that I was still working 
on.  I had a bit more stuff in mine than you did in yours so I folded your 
changes into my stuff.  When I push my tree out it will be in there 
(otherwise it would have required hand merging by someone else anyway).  I 
just gotta wait till I go back up to the office and restart my test box in 
order to push the changes out :-/  (shutdown -nr segfaulted on me)


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
