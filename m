From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Fri, 21 Feb 2014 21:45:48 +0100
Message-ID: <20140221214548.4dd6373c@stein>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
	<1392929071-16555-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1392929071-16555-5-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Feb 20 Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> firewire core-device and sbp2 have been been multiplexing work items
> with multiple work functions.  Introduce fw_device_workfn() and
> sbp2_lu_workfn() which invoke fw_device->workfn and
> sbp2_logical_unit->workfn respectively and always use the two
> functions as the work functions and update the users to set the
> ->workfn fields instead of overriding work functions using
> PREPARE_DELAYED_WORK().
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

And lightly runtime-tested as well.

This doesn't actually touch sbp-target; the following Cc's could be
dropped:

> Cc: Chris Boot <bootc@bootc.net>
> Cc: linux-scsi@vger.kernel.org
> Cc: target-devel@vger.kernel.org
> ---
>  drivers/firewire/core-device.c | 22 +++++++++++++++-------
>  drivers/firewire/sbp2.c        | 17 +++++++++++++----
>  include/linux/firewire.h       |  1 +
>  3 files changed, 29 insertions(+), 11 deletions(-)

-- 
Stefan Richter
-=====-====- --=- =-=-=
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Managing the Performance of Cloud-Based Applications
Take advantage of what the Cloud has to offer - Avoid Common Pitfalls.
Read the Whitepaper.
http://pubads.g.doubleclick.net/gampad/clk?id=121054471&iu=/4140/ostg.clktrk
