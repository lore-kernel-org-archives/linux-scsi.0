From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 00:45:28 -0800
Message-ID: <20080107084528.GA8365@suse.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	<478120D9.5090404@s5r6.in-berlin.de>
	<20080107020944.GA3637@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Dave Young <hidave.darkstar@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, dbrownell@users.sourceforge.net, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, david-b@pacbell.net, krh@redhat.com, Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 07, 2008 at 10:09:44AM +0800, Dave Young wrote:
> 
> Thanks for your comment, I rewrite it for 2.6.24-rc7 as a all-in-one
> patch, please see following. Drop i2c maintainer and list in cc
> because there's no changes about i2c in this patch:
> 
> Convert semaphore to mutex in struct class

Most of the non-driver core code should be converted to not use the
lock in the class at all.  They should use a local lock instead.

So how about a patch series that removes the usage of the current
semaphore from the different drivers, and then, a single patch that
converts the semaphore to mutex in the class code, it should not touch
anything outside of the drivers/base/ directory (not including the
driver.h file.)

Sound reasonable?

thanks,

greg k-h

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
