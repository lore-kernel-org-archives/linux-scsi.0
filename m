From: Ryan Richter <ryan@tau.solarneutrino.net>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Tue, 29 Nov 2005 15:31:12 -0500
Message-ID: <20051129203112.GD6326@tau.solarneutrino.net>
References: <20051129092432.0f5742f0.akpm@osdl.org> <Pine.LNX.4.63.0511292147120.5739@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932387AbVK2UbQ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0511292147120.5739@kai.makisara.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ryan@tau.solarneutrino.net
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2005 at 10:04:39PM +0200, Kai Makisara wrote:
> I looked at the driver and it seems that there is a bug: st_write calls 
> release_buffering at the end even when it has started an asynchronous 
> write. This means that it releases the mapping while it is being used!
> (I wonder why this has not been noticed earlier.)
> 
> The patch below (against 2.6.15-rc2) should fix this bug and some others 
> related to buffering. It is based on the patch "[PATCH] SCSI tape direct 
> i/o fixes" I sent to linux-scsi on Nov 21. The patch restores setting 
> pages dirty after reading and clears number of s/g segments when the 
> pointers are not valid any more.
> 
> The patch has been lightly tested with AMD64.

This applies cleanly to 2.6.14.2, do you forsee any problems using it
with that kernel?  I'd like to not change too many things at once.

If it should be OK, I'll boot this tonight or tomorrow - the backups run
every other night, so it won't get any testing until tomorrow night.

Thanks a lot,
-ryan
