From: Doug Ledford <dledford@redhat.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 13:27:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020829132728.G31625@redhat.com>
References: <20020829124142.D31625@redhat.com> <B993CDEB.2C0F%mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B993CDEB.2C0F%mheinz@infiniconsys.com>; from mheinz@infiniconsys.com on Thu, Aug 29, 2002 at 01:11:07PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Aug 29, 2002 at 01:11:07PM -0400, Michael Heinz wrote:
> 
> A little more detail - if the caller wasn't checking my return code at all,
> I would expect the SCSI layer to send me an abort when the command times out
> - but it doesn't, it goes inert.

Yep.  It's the queue starvation issue that someone else brought up (can't 
remember who that was...).  Basically, if you don't have some outstanding 
command that will complete after you fail your queue_command() call then 
there is no method of goosing the current holding queue in the mid layer.  
It doesn't have a timer backup goose method as of yet.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
