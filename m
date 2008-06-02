From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 12:57:08 -0500
Message-ID: <1212429428.3369.45.camel@localhost.localdomain>
References: <12124164141515-patch-mail.ibm.com>
	 <48441AEE.6050605@garzik.org>  <48441F82.6060706@linux.vnet.ibm.com>
	 <1212425124.3369.20.camel@localhost.localdomain>
	 <4844312C.7010403@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4844312C.7010403@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-06-02 at 13:43 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > The problems seem to come at us from the 1:1 relationship between a
> > 'port' and a host in libata.  Is there no way we can perhaps recast what
> > we think of as a phy as what libata thinks of as a link and thus keep us
> > at one host per actual physical device?
> 
> 
> It's difficult to do that universally, but OTOH it would be quite 
> reasonable to do that for modern SATA controllers, leaving the older 
> master/slave controllers as one-host-per-port.
> 
> I've been wanting to do that for a while, even.
> 
> The main thing holding me back is not any technical issue, but desire to 
> avoid breakage caused by abrupt topology change.

Actually, that's not quite what I was suggesting, but actually it would
be better since then the ata topology will map easily into what sas
wants.

The quickest way seems to be to break the scsi_host <-> ata_port link by
mapping scsi_host <-> ata_host instead.  Legacy controllers with only a
single port can keep the apparent 1:1 mapping (we can even keep the
hostdata stuff).  Unfortunately, the standard way of doing this is via
the transport classes, but as long as you have a pointer from the port
to the host and from the device to the port (which you do) it should be
possible.

The downside I can see is that qc_defer handling changes non trivially
because of this, but there don't seem to be many other issues.

The ideal (for us at least) would be to completely separate port
operations from host operations, because libsas really wants to control
the host and attach the port only to SATA devices.

James


