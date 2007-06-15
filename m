From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 16:28:03 -0700
Message-ID: <1181950083.3600.18.camel@mulgrave.il.steeleye.com>
References: <20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
	<1181947242.3600.8.camel@mulgrave.il.steeleye.com>
	<20070615.160858.26276547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070615.160858.26276547.davem@davemloft.net>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: David Miller <davem@davemloft.net>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-06-15 at 16:08 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 15 Jun 2007 15:40:42 -0700
> 
> > On Fri, 2007-06-15 at 14:19 -0700, David Miller wrote:
> > > Another quirk I have to deal with is that under LDOMs you
> > > can export full disks and also just slices.  So I'll have
> > > to get down into the partition machinery to support that
> > > somehow.
> > 
> > For this, it sounds like you might find nbd a more enticing
> > proposition ... it already is partition independent and is basically a
> > block to net socket exporter.
> 
> That's not gonna work, it's a totally different model.
> 
> I have a predefined protocol over hypervisor provided "channels" and
> page flipping also done by the hypervisor for the bulk data transfer.
> For the client side I cannot change the hypervisor nor the server
> speaking on the other end.  And when I do write a server I do want
> it to be able to speak to all of the existing clients.
> 
> There's SCSI command pass through as well, as I keep mentioning as
> it's an important reason I don't want to go with any of the non-SCSI
> solutions (other than perhaps ATA) being suggested.

Then sure, use SCSI ... the ibmvscsi client originally talked to some
type of hypervisor interface too before IBM extracted it and open
sourced the server.  If actual SCSI commands are going in somewhere ...
be it a real device, a RAID firmware emulation or a hypervisor input,
then I'm happy with the driver being in SCSI.

James
