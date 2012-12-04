From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] megaraid: fix use of delayed work
Date: Tue, 4 Dec 2012 07:39:39 -0800
Message-ID: <20121204153939.GD3885@mtj.dyndns.org>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 04, 2012 at 07:33:54PM +0800, Xiaotian Feng wrote:
> megaraid use INIT_WORK to declare a hotplug_work, but cast the hotplug_work
> from work_struct to delayed_work and schedule_delayed_work on it. This is
> very dangerous, as other part of delayed_work might be kernel memories allocated
> by others.
> 
> With commit 8852aac, schedule_delayed_work() will check dwork->timer before
> queue_work, this will cause megaraid code to hit the BUG_ON in workqueue code.
> Change megaraid code to use delayed work.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org

Urgh... what the....  Didn't see that one coming.  I'm gonna push this
to Linus through the workqueue tree.

Thanks for the fix.

-- 
tejun
