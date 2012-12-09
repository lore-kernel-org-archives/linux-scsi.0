From: Mel Gorman <mgorman@suse.de>
Subject: Re: 3.7-rc8 boot failure due to recent workqueue-related patch
Date: Sun, 9 Dec 2012 11:11:46 +0000
Message-ID: <20121209111146.GB1009@suse.de>
References: <20121208203524.GA1009@suse.de>
 <alpine.LFD.2.02.1212081647500.4593@air.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212081647500.4593@air.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 08, 2012 at 04:50:21PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 8 Dec 2012, Mel Gorman wrote:
> >
> > Commit 8852aac2 (workqueue: mod_delayed_work_on() shouldn't queue timer on
> > 0 delay) is causing the following boot failure for me. Found by bisection
> > but no further analysis unfortunately until I get back home properly.
> > I've added the relevant maintainers for megasas and SCSI in case it's
> > somehow specific to that driver.
> 
> This should be fixed by commit c1d390d8e612. The Megaraid SAS driver was 
> doing insane things, using a work-struct for delayed work, and casting 
> pointers around. It had happened to work for all the wrong reasons before, 
> the mod_delayed_work_on() changes just exposed how crazy that crap was.
> 

Correct, it is fixed by commit c1d390d8e612. Sorry for the noise.

-- 
Mel Gorman
SUSE Labs
