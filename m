From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block
	pc	requests	and simplify hw handlers
Date: Tue, 07 Jun 2005 10:59:26 -0500
Message-ID: <1118159966.4813.8.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	 <1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>
	 <1117982408.4990.12.camel@mulgrave> <1117998665.4990.17.camel@mulgrave>
	 <42A3E275.6030106@torque.net> <1118067544.5045.17.camel@mulgrave>
	 <42A59C35.5060207@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:25782 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261943AbVFGR5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 13:57:38 -0400
In-Reply-To: <42A59C35.5060207@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, LIRANS@il.ibm.com

On Tue, 2005-06-07 at 23:08 +1000, Douglas Gilbert wrote:
> I don't think it is important and I'm not aware of any
> real world applications that are using it. Naturally,
> I will find out if that is actually true after it
> gets removed.

Heh, true.  OK, let's do this: I'll remove it from the sg driver and
make sg use the do_command (or it's successor) interface.  If an actual
user for the iovecs does turn up, I'll add it to the block layer (it's a
fairly well understood multi-bio request setup) and make sg and also the
block layer SG_IO use it.

> I believe that I am guilty for SCSI_SENSE_BUFFERSIZE.
> But implementation details shouldn't necessarily limit
> new interface functions. Again OSD could be a problem
> here as it uses descriptor sense format with larger
> descriptors (than SPC-3). Perhaps Liran might comment
> on whether the current 96 bytes is sufficient. [According
> to SPC-3 there is still a limit of 252 bytes.]
> 
> Also scsi_do_command() could drop the direction
> argument and have an "in" pair (pointer and length)
> and an "out" pair. Then it could cope with OSD and
> advanced SBC-2 commands.

The basic trouble is that to use variable length sense buffer sizes we
need to modify the way block layer requests code sense data.  This
should be doable ... I'll look into it.

> Depending on the driver which controls the device node
> that has been opened, there are various policy decisions
> to maneouver (e.g. sr and st require O_NONBLOCK on
> open() otherwise they will wait until media is loaded,
> making the SCSI Test Unit Ready command pointless). Also
> there are state machines in some drivers, that
> can either be confused by the pass through or
> vice versa (e.g. try using the sg_prevent utility in
> sg3_utils via a sr device node, then
> try again with a sg device node). Should maximum
> transfer size limits that apply to the READ/WRITE
> SBC commands also apply to READ/WRITE_BUFFER SPC
> commands?

Well, but the former are only semantic ... and they can be fixed.  I'm
not aware that we do actually impose limits on READ/WRITE (at least not
when we receive them as packet commands).

> The SAS SMP protocol is for discovering what is out
> there. In the extreme case no block device has been found.
> There is just a SAS HBA on a PCI bus with sysfs information
> telling us about some phys and what they are attached
> to. If the attached device type is an expander that
> implements a SMP target then we need to issue SMP
> frames (commands) through a local phy to the SAS address
> of the expander. I'm not sure we need scatter-gather,
> command merging, tagged queues or pseudo block devices
> to accomplish this.

Yes, but this type of discovery is probably going to be the province of
the SAS class.  It will export an API (similar to the current SCSI sysfs
scanning one) that would allow the user to manipulate discovery.

The question is not whether such a process would make use of all the
features the block layer places at its disposal, but whether it's
capable of being done by the existing block layer infrastructure.  If
the latter is true, there's no need to invent new methods.

James


