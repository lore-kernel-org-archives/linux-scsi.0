From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Tue, 01 Mar 2005 01:52:07 -0500
Message-ID: <1109659927.27139.276.camel@compaq-rhel4.xsintricity.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
	 <1109318231.6290.27.camel@laptopd505.fenrus.org>
	 <421EE410.7020603@pobox.com>
	 <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
	 <20050225170202.GB8539@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:65154 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261250AbVCAGwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 01:52:16 -0500
In-Reply-To: <20050225170202.GB8539@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Arjan van de Ven <arjan@infradead.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2005-02-25 at 09:02 -0800, Patrick Mansfield wrote:
> On Fri, Feb 25, 2005 at 06:57:39AM -0500, Doug Ledford wrote:
> > On Fri, 2005-02-25 at 03:38 -0500, Jeff Garzik wrote:
> > > Arjan van de Ven wrote:
> > > > On Thu, 2005-02-24 at 23:21 -0500, Doug Ledford wrote:
> > > > 
> > > >>Don't use cmd->request->nr_hw_segments as it may not be initialized
> > > >>(SG_IO in particular bypasses anything that initializes this and just
> > > >>uses scsi_do_req to insert a scsi_request directly on the head of the
> > > >>queue) 
> > > > 
> > > > 
> > > > should we fix that in the SG_IO layer ?
> > > 
> > > Possibly/probably.
> 
> Doug,
> 
> What kernel did you hit this with? 

Our RHEL4 kernel (2.6.9 plus bunches-o'-patches)

> And same question as Doug G: is it via sg (not the block SG_IO)? sg uses
> scsi_do_req(), block SG_IO doesn't.

At the moment, I'm sorting that out.  It's a bit of a black box.  We
have two different loops of commands running on my test machine.  There
are 10 instances of:

while true; do scsiinfo -i /dev/sdf; done 

which sends an INQUIRY request to the target device.  I'm running into a
problem getting an strace from this command, so I'm tell you more when I
can.

The other 10 loops are:

while true; do scsi_id -g -s /block/sdf -p 0x80; done

> Jens sent changes last August or so that fixed SG_IO (not sg) to always
> set nr_hw_segments, change should be in 2.6.10. It is not obvious that his
> change fixed this, I can't find the changeset or log.

Finding out if this is fixed is only greatly complicated by the fact
that there exists a drivers/block/scsi_ioctl.c and
drivers/scsi/scsi_ioctl.c and they both are compiled into the kernel, so
knowing which one is actually being used, codepath wise, can be
confusing.  Then on top of that there's drivers/scsi/sg.c with it's
SG_IO path.  It's not necessarily an easy issue to sort out without that
strace and for some reason strace is locking on the test box I'm
running.

(insert delay as we get the strace issue resolved)

OK, the program that's causing the problem, from what I can tell, is
opening /dev/sdf and then issuing a SCSI_IOCTL_SEND_COMMAND request.
That means we go to scsi/sd.c:sd_ioctl to
block/scsi_ioctl.c:scsi_cmd_ioctl to block/scsi_ioctl.c:sg_scsi_ioctl
and it's on that path that we aren't always getting an initialized
nr_hw_segments.

/me votes for consolidating some of this ioctl mess if at all possible.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford

