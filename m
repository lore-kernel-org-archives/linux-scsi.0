From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 09:02:02 -0800
Message-ID: <20050225170202.GB8539@us.ibm.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com> <1109318231.6290.27.camel@laptopd505.fenrus.org> <421EE410.7020603@pobox.com> <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58755 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262741AbVBYRCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 12:02:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1PH288X016979
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 12:02:08 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1PH28W6223954
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 12:02:08 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1PH27hf014148
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 12:02:07 -0500
Content-Disposition: inline
In-Reply-To: <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Arjan van de Ven <arjan@infradead.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, Feb 25, 2005 at 06:57:39AM -0500, Doug Ledford wrote:
> On Fri, 2005-02-25 at 03:38 -0500, Jeff Garzik wrote:
> > Arjan van de Ven wrote:
> > > On Thu, 2005-02-24 at 23:21 -0500, Doug Ledford wrote:
> > > 
> > >>Don't use cmd->request->nr_hw_segments as it may not be initialized
> > >>(SG_IO in particular bypasses anything that initializes this and just
> > >>uses scsi_do_req to insert a scsi_request directly on the head of the
> > >>queue) 
> > > 
> > > 
> > > should we fix that in the SG_IO layer ?
> > 
> > Possibly/probably.

Doug,

What kernel did you hit this with? 

And same question as Doug G: is it via sg (not the block SG_IO)? sg uses
scsi_do_req(), block SG_IO doesn't.

Jens sent changes last August or so that fixed SG_IO (not sg) to always
set nr_hw_segments, change should be in 2.6.10. It is not obvious that his
change fixed this, I can't find the changeset or log.

> I'm not concerned with it personally.  The only reason that the scsi
> layer copies the block layer request struct into the scsi
> command/request is so that upon completion it has enough information to
> mark blocks as either up to date or not while at the same time allowing
> the scsi layer to free the original block request at queue time, not at
> completion time.  It was never intended to be used by low level drivers.

In 2.6, we no don't copy the request into the command:

struct scsi_cmnd {
	...
	struct request *request
	...
}

-- Patrick Mansfield
