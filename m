From: Anton Blanchard <anton@samba.org>
Subject: Re: sym2 oops in 2.6.9-rc2-BK
Date: Thu, 30 Sep 2004 23:05:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040930130518.GB3167@krispykreme.ozlabs.ibm.com>
References: <20040928135826.GA3373@krispykreme.ozlabs.ibm.com> <1096385921.2008.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47059 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S269255AbUI3NIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 09:08:46 -0400
Content-Disposition: inline
In-Reply-To: <1096385921.2008.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

 
> Actually, this patch can't be correct.  We should never be negotiating
> with a NULL sdev.  Previously we negotated after slave_alloc, but I've
> tried to change the driver to defer negotiation until slave_configure.
> 
> What were the messages in the log prior to the NULL deref?  What I'm
> trying to understand is how we got to this point.

Im confused, why are we checking sdev earlier on? Unfortunately I dont
have the machine at the moment, if I get it back I'll get a dmesg.

Anton

static int sym_prepare_nego(hcb_p np, ccb_p cp, int nego, u_char
*msgptr)
{
        tcb_p tp = &np->target[cp->target];
        int msglen = 0;
        struct scsi_device *sdev = tp->sdev;

        if (likely(sdev))
                sym_check_goals(sdev);

        /*
         *  Early C1010 chips need a work-around for DT
         *  data transfer to work.
         */
        if (!(np->features & FE_U3EN))
                tp->tinfo.goal.options = 0;
        /*
         *  negotiate using PPR ?
         */
        if (scsi_device_dt(sdev)) {
                nego = NS_PPR;
        } else {
