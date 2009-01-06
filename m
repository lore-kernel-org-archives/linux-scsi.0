From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Mon, 5 Jan 2009 20:37:06 -0800
Message-ID: <20090105203706.426cdc1f@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
	<20090105202514.399da36e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105202514.399da36e.akpm@linux-foundation.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 5 Jan 2009 20:25:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 5 Jan 2009 20:10:41 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> >  kernel/async.c         |  307
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Am still wondering if this is unacceptably duplicative of dhowells's
> slow-work infrastructure: http://lkml.org/lkml/2008/11/20/193
> 
> 

I talked to David about this today (as I wrote in 0/6). 
Based on that discussion we got to the conclusion we have incompatible
requirements. He needs priorities to be honored (which means rather out
of order execution of the tasks) while I need strict ordering (for the
synchronization). While it's not entirely impossible to combine those
two into one system, the resulting complexity isn't really worth it yet.

Of the 307 lines, only 100 are actual thread pool code (the rest is
synchronization and admin code), and about half of those 100 lines are
comments.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
