From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/3] cnic: Add CNIC driver.
Date: Fri, 23 May 2008 13:14:54 -0700
Message-ID: <adad4nc7p6p.fsf@cisco.com>
References: <1211418386-18203-1-git-send-email-mchan@broadcom.com>
	<1211418386-18203-3-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1211418386-18203-3-git-send-email-mchan@broadcom.com> (Michael
	Chan's message of "Wed, 21 May 2008 18:06:25 -0700")
Sender: netdev-owner@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: davem@davemloft.net, michaelc@cs.wisc.edu, anilgv@broadcom.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

 > +		/* Tell compiler that status_blk fields can change. */
 > +		barrier();
 > +		if (status_idx != sblk->status_idx) {

Is a compiler barrier sufficient here?  It seems an out-of-order CPU
could still mess things up, so an rmb() or smp_rmb() would be required.
