From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Sat, 22 Feb 2014 09:38:59 -0500
Message-ID: <20140222143859.GD12830@htj.dyndns.org>
References: <20140221021341.GG6897@htj.dyndns.org>
	<5306E06C.5020805@hurleysoftware.com>
	<20140221100301.GA14653@mtj.dyndns.org>
	<53074BE4.1020307@hurleysoftware.com>
	<20140221130614.GH6897@htj.dyndns.org>
	<5307849A.9050209@hurleysoftware.com>
	<20140221165730.GA10929@htj.dyndns.org>
	<5307DAC9.2020103@hurleysoftware.com>
	<20140221231833.GC12830@htj.dyndns.org>
	<5307E550.4040004@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <5307E550.4040004@hurleysoftware.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey,

On Fri, Feb 21, 2014 at 06:46:24PM -0500, Peter Hurley wrote:
> It's a long story but the short version is that
> Documentation/memory-barriers.txt recently was overhauled to reflect
> what cpus actually do and what the different archs actually
> deliver.
> 
> Turns out that unlock + lock is not guaranteed by all archs to be
> a full barrier. Thus the smb_mb__after_unlock_lock().
> 
> This is now all spelled out in memory-barriers.txt under the
> sub-heading "IMPLICIT KERNEL MEMORY BARRIERS".

So, that one is for unlock/lock sequence, not smp_mb__after_unlock().
Urgh... kinda dislike adding smp_rmb() there as it's one of the
barriers which translate to something weighty on most, if not all,
archs.

Thanks.

-- 
tejun

------------------------------------------------------------------------------
Managing the Performance of Cloud-Based Applications
Take advantage of what the Cloud has to offer - Avoid Common Pitfalls.
Read the Whitepaper.
http://pubads.g.doubleclick.net/gampad/clk?id=121054471&iu=/4140/ostg.clktrk
