From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 21:28:22 -0700
Message-ID: <20101113042821.GE18258@parisc-linux.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 12, 2010 at 05:42:06PM -0800, Linus Torvalds wrote:
> And the sad thing is that this could _trivially_ have been fixed while
> actually making the patch no bigger. Make the new function look like
> 
>    int func(struct Scsi_Host *shost, struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *));

Actually, it'd be even better if we took away an argument.

int queuecommand(struct scsi_cmnd *cmd);

Every single driver sets cmd->scsi_done = done;

(some don't do it immediately, but they all do it eventually.  Do it in
the single caller, and eventually remove the assignments from the drivers).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
