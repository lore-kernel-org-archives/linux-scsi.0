From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] megaraid: fix use of delayed work
Date: Tue, 4 Dec 2012 07:57:39 -0800
Message-ID: <20121204155739.GG3885@mtj.dyndns.org>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
 <20121204153939.GD3885@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121204153939.GD3885@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, again, Xiaotian.

On Tue, Dec 04, 2012 at 07:39:39AM -0800, Tejun Heo wrote:
> Urgh... what the....  Didn't see that one coming.  I'm gonna push this
> to Linus through the workqueue tree.
> 
> Thanks for the fix.

It seems like megaraid doesn't have any reason to use delayed_work at
all.  It can use a plain work and cancel_work_sync() instead.  Maybe
it was doing the container_of() thing because workqueue didn't use to
have cancel_work_sync()?  Anyways, please convert it to use plain
work_struct post 3.7.

Thanks.

-- 
tejun
