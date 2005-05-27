From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 15:04:26 -0400
Message-ID: <1117220666.7379.8.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC3D@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262546AbVE0TEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 15:04:40 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC3D@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, Douglas Gilbert <dougg@torque.net>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Fri, 2005-05-27 at 13:45 -0400, James.Smart@Emulex.Com wrote:
> The transport can be a subsystem on it's own and is perhaps independent
> of SCSI altogether. In this case, SCSI just happens to be a personality
> of something on the transport. This is at odds with the current design
> in which the transport is something under SCSI and inherently bound to
> the SCSI "host".

Actually, no that's no longer true.  Initially I did it this way, but
now the SCSI transport classes are build on top of the generic transport
classes (and these are independent of SCSI).  I anticipate that soon
we'll get a PHY transport class that will attach both to SAS and SATA
devices (and won't care which subsystem they're under).

> I understand how we got to where we are, but shouldn't we consider making
> some transports independent subsystems ? If the only protocol that
> can be run on the transport is SCSI (ex: SPI), then the transport can be
> under SCSI. However, if the transport can support multiple protocols (FC
> can support SCSI, IP, (or ATA)), shouldn't it be structured more like an io
> bus like pci ? 
> 
> It does mess up the device tree heirarchy. In general, you want the
> device tree to continue along the transport specific elements until it finds
> remote endpoints (things your going to use), at which point the protocol
> specific elements can kick in. For example (using FC):
>  /sys/devices/<pci>/fcport5/rport-5:3/target10:0:0/10:0:0:0  - the SCSI lun
> 
> What this leaves out is : where is the scsi host device ? It doesn't make
> sense to insert it in-between the transport elements. It likely just becomes
> a leaf entity. Continuing the example:
>  /sys/devices/<pci>/fcport5/host10  - scsi host interface
>  /sys/devices/<pci>/fcport5/eth3    - network interface
> 
> Food for thought...   Is this out in left field ?

Well, that's why it's a class.  All the devices appear under 

/class/<transport class name>

and these devices are simply the names of the actual generic devices, so
there's no reason target0:3:0 can't co-exist happily with ata3:0 or
something here.  The idea being (I think) that the class infrastructure
actually flattens the tree.  So there's always a device link that points
into the true device tree, but all the class properties are available in
flattened form.

James


