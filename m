From: Mark Lord <kernel@teksavvy.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Thu, 23 Sep 2010 22:53:18 -0400
Message-ID: <4C9C129E.5050504@teksavvy.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C9BEB49.2060208@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10-09-23 08:05 PM, Douglas Gilbert wrote:
> Mark,
> If you issued the SG_IO ioctl with a timeout of at
> least 66 minutes (expressed in milliseconds) then
> it looks like ata_scsi_queuecmd() has a problem.
..

Mmm.. more like  blk_execute_rq() perhaps.
That's where the wait_for_completion(&wait) call is at.

Perhaps I should change it to wait in smaller increments,
so that the lockup detection doesn't trigger on it..

Doing that seems rather wasteful, though.

Note that this is the ATA "SECURITY ERASE" command,
which doesn't have an "immed" bit to toggle.
So one must wait for it to complete.

cheers
