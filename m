From: Michael Heinz <mheinz@infiniconsys.com>
Subject: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 09:34:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B9939B24.2BFC%mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I ran into an interesting problem recently, and I'd like to ask if I chose
the correct solution.

The "virtual" HBA driver I've written was having a problem recovering when
it temporarily lost contact with the remote hardware. All signs were that
the HBA itself recovered, but that SCSI stopped issuing I/Os.

The last thing to happen seemed to be that my driver would get a call to
queue_command while I knew the connection was down. Since I knew the
connection was down I would simply immediately return an error and do
nothing else.

Since I already had a watchdog process to manage the reconnect, as an
experiment, I tried putting the bad SCSI_Cmnd on a linked list and returning
success to the SCSI layer. A few seconds later, the watchdog picks up the
command and calls the calls its done function. This immediately resolved the
problem!

So, my question is: Is this the right way to handle this problem, or is
there another issue? At least part of the SCSI system knows the command was
bad, because it never tries to abort it - but it never issues another
command, either.

Any suggestions?
-- 
Michael Heinz <mheinz@infiniconsys.com>
Staff Software Engineer
InfiniCon Systems, Inc.

