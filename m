From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch 16/17] mptbase: reset ioc initiator during PCI resume
Date: Wed, 3 Oct 2007 13:32:56 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70A0A994@NAMAIL4.ad.lsil.com>
References: <20071002230625.GA16003@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54886 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXJCTd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 15:33:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071002230625.GA16003@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tuesday, October 02, 2007 5:06 PM,  Darrick J. Wong wrote:
> Yep.  Replied to it, too.  Apparently it never got to you, so I've
> attached it below.
> 

Sorry, I didn't receive the previous email you sent. 

> ---------------------
> 
> On Thu, Sep 20, 2007 at 07:06:35PM -0600, Moore, Eric wrote:
> > Darrick - MESSAGE_UNIT_RESET is already issued from inside
> > mpt_do_ioc_recovery(), so you don't need to send this in advance of
> > that.    YOu will find that occuring from the function MakeIocReady.
> > Anyways... would it be possible for you to enable debug 
> logging so I can
> > see what problem your having?   I suggest MPT_DEBUG and 
> MPT_DEBUG_INIT.
> > If its possible for you to manually load mptbase, that way 
> you can set
> > the command line option. 
> 
> I took a look at MakeIocReady(), and this section caught my eye:
> 
> /* Is it already READY? */
> if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == 
> MPI_IOC_STATE_READY)
> 	return 0;

Yes, the purpose of MakeIocReady is to get the card in READY state.  If
your already in READY state, there is no reason to continue in
MakeIocReady.  A MESSAGE_UNIT_RESET places the card into READY state.
You will see that we already issued MESSAGE_UNIT_RESET from
mptbase_suspend.  So it should be in READY state coming into
mptbase_resume, depending on which power state you transferred to from
suspend.    The code you added in this patch is not required, meaning we
dont need to send MESSAGE_UNIT_RESET prior to ioc_do_recovery, becuase
from MakeIocReady will issue a MESSAGE_UNIT_RESET if your not already in
READY.    I suspect there must be something else going on if you have to
issue MESSAGE_UNIT_RESET when your already in READY state.   My card
works fine without your patch.  I did the following:

# echo standby > /sys/power/state


There could be issues in the firmware your using.   I noticed
FwRev=00060200h in the log,, which is 6.02, and over a year old.    

I will send out a seperate email which I will copy you to the IBM system
engineer support here at LSI, should be able to assist on this issue.

Eric

