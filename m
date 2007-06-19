From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Tue, 19 Jun 2007 07:56:29 +0200
Message-ID: <20070619055629.GE18542@lst.de>
References: <20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
	<1181947242.3600.8.camel@mulgrave.il.steeleye.com>
	<20070615.160858.26276547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
Content-Disposition: inline
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
Cc: James.Bottomley@SteelEye.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2007 at 04:08:58PM -0700, David Miller wrote:
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

A SCSI pass through is of course perfectly fine.  If you have a separate
block passthrough that has additional magic a separate block driver is
the way to go because it actually is simpler than a scsi driver decoding
command blocks and translating them to deep magic.  The ps3 storage
drivers this thread discussed are a good example for that.  We now
have a very nice and simple disk, scsi and flash chardev driver each
that don't include abstractions layers and cruft.  Combine that with
their initial scsi layer driver that was full of internal dispatches
because each of these device types speaks a completely different command
set.
