From: Philip R Auld <pauld@egenera.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 16:28:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027202821.GO2853@vienna.egenera.com>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:26786 "EHLO
	coyote.egenera.com") by vger.kernel.org with ESMTP id S262675AbUJ0U1z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 16:27:55 -0400
Content-Disposition: inline
In-Reply-To: <1098903759.12464.32.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Rumor has it that on Wed, Oct 27, 2004 at 09:02:39PM +0200 christophe varoqui said:
> 
> > > Some SAN hardware present for a same LUN a bunch of valid paths and  a
> > > bunch ghost paths. In my case, the ghosts responds to standard INQUIRY
> > > (EVPD 0x83, 0x80, ...) but the READ_CAPACITY fails :
> > 
> > As a note, this is one mode the EMC CLARiiON arrays can also operate in.
> > Even worse, they won't present the block device at all, just the SCSI
> > generic mode. However, for the CLARiiONs, they can be configured to
> > behave sanely and reply to a READ_CAPACITY too (just all I/O will be
> > errored), if setting the failovermode to 1.
> > 
> > I wonder whether your system can also be configured as such?
> > 
> Yes it could, but it's a controler wide setting.
> 

So is the CLARiiON setting. 

> Compatibility with other OS sharing the same controlers might impose
> this mode though. So I'd like to straight this situation up.
> 

I suspect anything else doing failover on this device would already require 
that setting. And if not doing failover probably won't see the passive 
controller due to cabling/zoning setup.

I don't see anything wrong with asking for specific array settings if they are
needed for multipathing. Some arrays don't return meaningful LU IDs if not 
configured for it. 


> > > 
> > > 1) make the /sys/block/*/size attribute writable
> > > 2) resurrect a BLKSETSIZE ioctl
> > > 3) make device-mapper less strict, and hope we can fix the size by a
> > > device rescan when it get activated
> > > 4) sell the culprit hardware
> > 
> > Personally I would opt for 4), but 3) is the likely path to solve this.
> > 
> > Using the new priority group initialization code (where we sent magic
> > commands down to activate the newly switched-to PG) which Alasdair and I
> > are currently doing for the CLARiiON pampering and which provides a
> > plugin-architecture to the dm-mpath system, you should be able to plug
> > in a hardware-specific handler for your system too.
> > 
> > However, "relaxing" this check should likely also be a property of the
> > hardware plugin loaded; I'd not wish to have it relaxed in all
> > scenarios.
> > 
> I wonder if it's not simpler just to remove the NOSTARTONADD flag on
> this devices in scsi_devinfo.c. I tested that and all the READ CAPACITY
> succeed as expected (DEC HSG80 / COMPAQ HSV*).
> 

Doesnt that just failover the LUN with the START? I think you'd end up 
with all LUNs active on which ever controller you scanned last. This may 
not be ideal.

And that wouldn't work for a (misconfigured) CLARiiON anyway, I think.


> Wasn't this flag in part motivated by the lack of multipath support
> anyway ?
> 
> Even in a cluster context, I don't really buy the annoyance of
> occasional LUN ping-pong.
> 

This is very possible. You can bring many active/passive arrays to their 
knees if you flip it back and forth under load. Although, I don't see that 
this is specifc to the READ_CAPACITY issue.  


Cheers,

Phil

> regards,
> -- 
> christophe varoqui <christophe.varoqui@free.fr>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
