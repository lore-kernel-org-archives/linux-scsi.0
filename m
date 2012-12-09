From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.7-rc8 boot failure due to recent workqueue-related patch
Date: Sat, 8 Dec 2012 16:50:21 -0800 (PST)
Message-ID: <alpine.LFD.2.02.1212081647500.4593@air.linux-foundation.org>
References: <20121208203524.GA1009@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121208203524.GA1009@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Sat, 8 Dec 2012, Mel Gorman wrote:
>
> Commit 8852aac2 (workqueue: mod_delayed_work_on() shouldn't queue timer on
> 0 delay) is causing the following boot failure for me. Found by bisection
> but no further analysis unfortunately until I get back home properly.
> I've added the relevant maintainers for megasas and SCSI in case it's
> somehow specific to that driver.

This should be fixed by commit c1d390d8e612. The Megaraid SAS driver was 
doing insane things, using a work-struct for delayed work, and casting 
pointers around. It had happened to work for all the wrong reasons before, 
the mod_delayed_work_on() changes just exposed how crazy that crap was.

So please test current -git. If it's still broken, we'll need to know, but 
I'm assuming this is the already-known-and-fixed bug.

             Linus
