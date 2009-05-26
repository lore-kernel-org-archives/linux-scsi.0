From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in SCSI async probing
Date: Tue, 26 May 2009 17:52:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905261741430.11998-100000@iolanthe.rowland.org>
References: <1243373019.2815.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758693AbZEZVxE@vger.kernel.org>
In-Reply-To: <1243373019.2815.83.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 26 May 2009, James Bottomley wrote:

> > Also, I do still think that wait_scan_init() needs an extra call to 
> > async_synchronize_full() at the end.
> 
> I need to understand it before commenting ... I'm slowly working my way
> through the async patches.

There are two lists of queued asynchronous tasks: Arjan's list and the
SCSI scanning list.  As things stand now, routines in each list are
capable of submitting new jobs for the other list.  That is, an async
task may discover and register a new SCSI host (requiring scanning),
and the probe of a SCSI disk discovered during scanning will submit
a sd_probe_async task.

This makes it difficult to wait for both lists to become idle.  Maybe 
the whole idea behind scsi_wait_scan.c needs some rethinking...

Alan Stern
