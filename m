From: Ballabio_Dario@emc.com
Subject: RE: drop scsi_register_blocked_host() in 2.5?
Date: Mon, 24 Feb 2003 03:32:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <70652A801D9E0C469C28A0F8BCF49CF9012EBD27@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

This means giving up forever to support multiple isa scsi hba's.
The aim of these routines (left unimplemented by Eric during the 2.3
development cycle)
was to allow multiple isa hba working at the same time, but being active
one at a time. If you try to do heavy i/o on a system with multiple u14-34f
or isa eata boards (I have not tested aha1542 but it is probably the same)
it crashes immediately due to data corruption at the isa bus level.
Using a 2.2 kernel the same system works perfectly.


-db


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Friday, February 21, 2003 8:59 PM
To: Douglas Gilbert
Cc: linux-scsi@vger.kernel.org
Subject: Re: drop scsi_register_blocked_host() in 2.5?


On Fri, Feb 21, 2003 at 12:24:37PM +1100, Douglas Gilbert wrote:
> Just doing some documentation and noticed these two functions:
>    - scsi_register_blocked_host()
>    - scsi_deregister_blocked_host()
> that return void and do nothing. See scsi_lib.c around line 1344
> for Eric's comment. These functions are exported and the
> eata and u14-34f drivers call them.
> 
> Time for Christoph's razor?

Well, it's not used for ages and there's not much reason to keep it
around.  So this gets my vote.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
