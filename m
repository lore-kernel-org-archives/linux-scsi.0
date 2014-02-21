From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Thu, 20 Feb 2014 21:13:41 -0500
Message-ID: <20140221021341.GG6897@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
 <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5306B4DF.4000901@hurleysoftware.com>
Sender: target-devel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 20, 2014 at 09:07:27PM -0500, Peter Hurley wrote:
> On 02/20/2014 08:59 PM, Tejun Heo wrote:
> >Hello,
> >
> >On Thu, Feb 20, 2014 at 08:44:46PM -0500, Peter Hurley wrote:
> >>>+static void fw_device_workfn(struct work_struct *work)
> >>>+{
> >>>+	struct fw_device *device = container_of(to_delayed_work(work),
> >>>+						struct fw_device, work);
> >>
> >>I think this needs an smp_rmb() here.
> >
> >The patch is equivalent transformation and the whole thing is
> >guaranteed to have gone through pool->lock.  No explicit rmb
> >necessary.
> 
> The spin_unlock_irq(&pool->lock) only guarantees completion of
> memory operations _before_ the unlock; memory operations which occur
> _after_ the unlock may be speculated before the unlock.
> 
> IOW, unlock is not a memory barrier for operations that occur after.

It's not just unlock.  It's lock / unlock pair on the same lock from
both sides.  Nothing can sip through that.

-- 
tejun
