From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Thu, 20 Feb 2014 21:07:27 -0500
Message-ID: <5306B4DF.4000901@hurleysoftware.com>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
	<1392929071-16555-5-git-send-email-tj@kernel.org>
	<5306AF8E.3080006@hurleysoftware.com>
	<20140221015935.GF6897@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20140221015935.GF6897@htj.dyndns.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/20/2014 08:59 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Feb 20, 2014 at 08:44:46PM -0500, Peter Hurley wrote:
>>> +static void fw_device_workfn(struct work_struct *work)
>>> +{
>>> +	struct fw_device *device = container_of(to_delayed_work(work),
>>> +						struct fw_device, work);
>>
>> I think this needs an smp_rmb() here.
>
> The patch is equivalent transformation and the whole thing is
> guaranteed to have gone through pool->lock.  No explicit rmb
> necessary.

The spin_unlock_irq(&pool->lock) only guarantees completion of
memory operations _before_ the unlock; memory operations which occur
_after_ the unlock may be speculated before the unlock.

IOW, unlock is not a memory barrier for operations that occur after.

>> IOW, the beginning of the work function should act like a barrier in
>> the same way that queue_work_on() (et. al.) already does.
>
> workqueue already has enough barriers; otherwise, the whole kernel
> would have crumbled long time ago.

See above.

Regards,
Peter Hurley

------------------------------------------------------------------------------
Managing the Performance of Cloud-Based Applications
Take advantage of what the Cloud has to offer - Avoid Common Pitfalls.
Read the Whitepaper.
http://pubads.g.doubleclick.net/gampad/clk?id=121054471&iu=/4140/ostg.clktrk
