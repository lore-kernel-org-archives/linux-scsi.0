From: Doug Ledford <dledford@redhat.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Sat, 17 Jan 2004 15:36:33 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1074371793.13198.58.camel@compaq.xsintricity.com>
References: <OF317B32D5.C8C681CB-ONC1256E19.005066CF-C1256E19.00538DEF@de.ibm.com>
	 <20040112151230.GB5844@devserv.devel.redhat.com>
	 <20040112194829.A7078@infradead.org>
	 <1073937102.3114.300.camel@compaq.xsintricity.com>
	 <Pine.LNX.4.58L.0401131843390.6737@logos.cnet>
	 <1074345000.13198.25.camel@compaq.xsintricity.com>
	 <20040117165828.A4977@infradead.org>
	 <1074366452.13198.48.camel@compaq.xsintricity.com>
	 <20040117191704.A6344@infradead.org>
	 <1074367303.13198.52.camel@compaq.xsintricity.com>
	 <20040117192946.A6479@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040117192946.A6479@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Arjan Van de Ven <arjanv@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de
List-Id: linux-scsi@vger.kernel.org

On Sat, 2004-01-17 at 14:29, Christoph Hellwig wrote:
> On Sat, Jan 17, 2004 at 02:21:43PM -0500, Doug Ledford wrote:
> > I should pay more attention to what goes on in 2.6.  That was a crap
> > decision.  There are drivers out there that use global data and need one
> > lock across all controllers.  Putting a lock in the scsi host struct for
> > per controller locks is a waste of space.  Let the driver decide if it
> > needs a global driver lock, a per controller lock (in which case it
> > should be part of the driver private host struct), or just the global
> > io_request_lock.  It really is up to the driver and putting it into the
> > scsi host struct doesn't make sense.
> 
> I tend to disagree.  Giving the driver control over the lock used by the
> midlayer is just wrong.  If it has global state (which a good driver better
> shouldn't) it's up to the driver to protect it.  That we still have a way
> to override that lock is the big bug rather, and in fact only three drivers
> are doing that, and they all override it with a lock that's per-HBA anyway.

/me calls Christoph various unrepeatable names :-P

I'm exactly the opposite.  In my opinion, the mid layer should be using
the device locks for its internal operations and calling into the low
level drivers with no locks held.  The fact that the mid layer still
tries to lock drivers for the drivers is a bug IMO.  Every time I see a
driver do spin_unlock_irq(host->host_lock); do driver work;
spin_lock_irq(host->host_lock); return; it really points out that the
mid layer has no business locking down drivers for them.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606
