From: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 3 Jan 2008 08:06:09 +0100
Message-ID: <20080103070609.GA1677@ff.dom.local>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756430AbYACHA2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net, krh@redhat.com, stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net, James.Bottomley@HansenPartnership.com, a.zummo@towertech.it, cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org, i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net, spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 03, 2008 at 01:50:20PM +0800, Dave Young wrote:
> Convert semaphore to mutex in struct class.
...
> One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add
> 
> Jan  3 10:45:15 darkstar kernel: =============================================
> Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
> Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
> Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
...
> If there's anything missed please help to point out, thanks.

Dave, IMHO it's not 'the right' way to do it: from this and earlier
discussions it seems there could be many more warnings like this one;
lockdep simply always turns itself off after first one. So, merging
your patches like this would effectively turn off lockdep for all
other places as well, maybe for a long time.

I'd suggest to try first to do it with some wrappers around mutexes,
which simply omit lockdep verification, and later try to replace them
one by one, after checking and testing there are no such warnings
anymore (which would often need some additional annotations about
nesting and probably some changes in lockdep too).

Thanks,
Jarek P.
