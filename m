From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] csiostor: Chelsio FCoE offload driver
Date: Thu, 26 Feb 2015 12:49:16 +0300
Message-ID: <20150226094916.GI5116@mwanda>
References: <20140416153324.GA16325@mwanda>
 <20140416153716.GH4963@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43894 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbbBZJte (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2015 04:49:34 -0500
Content-Disposition: inline
In-Reply-To: <20140416153716.GH4963@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Praveen Madhavan <praveenm@chelsio.com>, Hariprasad Shenai <hariprasad@chelsio.com>

Some of the Chelsio people should add themselves to the MAINTAINERS
file for this driver?  I have a new static checker warning:

	drivers/scsi/csiostor/csio_mb.c:928 csio_fcoe_vnp_alloc_init_mb()
	warn: variable dereferenced before check 'vnport_wwnn' (see line 926)

"vnport_wwnn" can't be NULL so we should probably just delete the check.

Anyway, I was looking at old csiostor bugs in my in box and this one
from last November is more serious.

On Wed, Apr 16, 2014 at 06:37:16PM +0300, Dan Carpenter wrote:
> Naresh's email is dead.
> 
> regards,
> dan carpenter
> 
> On Wed, Apr 16, 2014 at 06:33:24PM +0300, Dan Carpenter wrote:
> > Hello Naresh Kumar Inna,
> > 
> > The patch a3667aaed569: "[SCSI] csiostor: Chelsio FCoE offload
> > driver" from Nov 15, 2012, leads to the following static checker
> > warning:
> > 
> > 	drivers/scsi/csiostor/csio_mb.c:1534 csio_mb_isr_handler()
> > 	warn: was 'sizeof(*mbp)' intended?
> > 
> > drivers/scsi/csiostor/csio_mb.c
> >   1451  int
> >   1452  csio_mb_isr_handler(struct csio_hw *hw)
> >   1453  {
> >   1454          struct csio_mbm         *mbm = &hw->mbm;
> >                                          ^^^
> > This struct is fairly large.
> > 
> >   1455          struct csio_mb          *mbp =  mbm->mcurrent;
> >   1456          __be64                  *cmd;
> >   1457          uint32_t                ctl, cim_cause, pl_cause;
> >   1458          int                     i;
> >   1459          uint32_t                ctl_reg = PF_REG(hw->pfn, CIM_PF_MAILBOX_CTRL);
> > 
> > [ snip ]
> > 
> >   1530                  /*
> >   1531                   * Enqueue event to EventQ. Events processing happens
> >   1532                   * in Event worker thread context
> >   1533                   */
> >   1534                  if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
> >                                                                     ^^^^^^^^^^
> > This is equivalent to sizeof(long) when sizeof(*mbp) was probably
> > intended.

Definitely the original code is buggy.  It's possible that sizeof(*mbp)
was intended as I said before but this is really weird to pass "mbp"
here so I'm not sure.  Someone should test this.

regards,
dan carpenter

