From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: BUG REPORT: terminal hangs when I load the sd_mod module
Date: Tue, 21 Oct 2003 11:20:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031021112057.A5014@beaverton.ibm.com>
References: <3F94A869.9070607@sympatico.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:20630 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263260AbTJUSVh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 14:21:37 -0400
Content-Disposition: inline
In-Reply-To: <3F94A869.9070607@sympatico.ca>; from chris_friesen@sympatico.ca on Mon, Oct 20, 2003 at 11:30:49PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <chris_friesen@sympatico.ca>
Cc: dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Oct 20, 2003 at 11:30:49PM -0400, Chris Friesen wrote:

> When I try and load the sd_mod module, that terminal just simply freezes
> and I can't break out.  Similarly, if I compile scsi disk support right
> into the kernel, it sits forever at boot time.  I have the following
> options set in my .config.

> This problem has been present since at least -test6.  Any ideas what's 
> going on?

Maybe the MODE SENSE page cache is causing problems (known problem with
some USB storage devices), triggering the error (i.e. timeout) handler to
run, leading to the command being retried forever.

Turn on all scsi logging (you must be logging and booting over IDE, so
the following won't cause infinite logging):

sysctl -w dev.scsi.logging_level=0xffffffff

Also get a trace of the hung process via sysrq.

After you get that data, try removing sd_do_mode_sense() calls in sd.c to
see if MODE SENSE commands are causing problems.

You could also try using sg (sg_utils) to send a MODE SENSE page 8, and
see what happens.

-- Patrick Mansfield
