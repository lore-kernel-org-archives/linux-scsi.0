From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
Date: Mon, 24 Sep 2012 11:35:04 +0400
Message-ID: <1348472104.2467.8.camel@dabdike>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348470210.2475.47.camel@ThinkPad-T420>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "Martin K. Petersen" <mkp@mkp.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-09-24 at 15:03 +0800, Li Zhong wrote:
> On Mon, 2012-09-24 at 09:44 +0400, James Bottomley wrote:
> > On Mon, 2012-09-24 at 13:30 +0800, Li Zhong wrote:
> > > Just noticed that after commit 919f797, it is possible that 
> > > scsi_cmd_to_driver() returns NULL. This patch adds the NULL checking for drv 
> > > returned from the above function. 
> > > 
> > > Maybe it is not possible at run time, but from the code itself, we'd better
> > > have this check?  
> > 
> > There's not much point having a check that never trips, unless it's an
> > assert, in which case a NULL deref does that.  All it does is add
> > pointless instructions to the critical path.  only REQ_TYPE_BLOCK_PC
> > commands can be submitted without a driver, so the check above would
> > seem to preclude that.
> 
> Hi James, 
> 
> Thank you, it sounds reasonable to me. Let's drop it. 

Well, there is another thing you might do: The path length of
scsi_cmd_to_driver() increased a lot thanks to 18a4d0a22ed6 it might be
worth getting it back to what it was (this looks to be doable with the
same != REQ_TYPE_BLOCK_PC test in the error handler.  Plus, I think it
fixes a bug where you get different behaviours from REQ_TYPE_BLOCK_PC
commands when a driver is and isn't attached (I've cc'd Martin to see
what he thinks).

James
