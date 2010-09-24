From: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Thu, 23 Sep 2010 22:08:46 -0400
Message-ID: <20100924020846.GI13116@bombadil.infradead.org>
References: <4C9BE5A8.1090002@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C9BE5A8.1090002@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 23, 2010 at 07:41:28PM -0400, Mark Lord wrote:
> What's the purpose of this stack dump,
> and how can it be prevented in this NORMAL situation??
> 
> The command was "hdparm --security-erase NULL /dev/sdb",
> which takes about 66 minutes to complete on this particular drive.
> 
> I don't see any obvious way for the task to mark itself
> as needing longer than 120 secs to complete the operation.
> 

It's an excellent question, a large number of bug reports I see against
Fedora are the result of this firing on some long-running task (like a
huge 'sync') and the user getting scared by the message assuming the
universe was imploding and reporting a bug.

I'd suggest we add a new task_struct flag for it, but we appear to be
out of bits! Perhaps we can abuse one of the other ones (PF_FROZEN seems
the likely choice since the watchdog bails out if it sees it, but that
likely has other ramifications.)

--Kyle
