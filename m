From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 17:12:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFC7C4422A.2EFFDA04-ONC1256C24.00521A60@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


The mid-layer queueing code is know to have a starvation problem
under certain conditions. Mid-layer queueing is used if queuecommands
fails.
I think there was a thread about it a few months ago.
We implemented a queue processed by a timer in our HBA driver.
Same thing as you did.
Seems that nobody has tried a mid-layer fix yet.

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Michael Heinz <mheinz@infiniconsys.com>@vger.kernel.org on 29.08.2002
15:34:28

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi <linux-scsi@vger.kernel.org>
cc:
Subject:    Possible bug handling bad I/Os?



I ran into an interesting problem recently, and I'd like to ask if I ch=
ose
the correct solution.

The "virtual" HBA driver I've written was having a problem recovering w=
hen
it temporarily lost contact with the remote hardware. All signs were th=
at
the HBA itself recovered, but that SCSI stopped issuing I/Os.

The last thing to happen seemed to be that my driver would get a call t=
o
queue_command while I knew the connection was down. Since I knew the
connection was down I would simply immediately return an error and do
nothing else.

Since I already had a watchdog process to manage the reconnect, as an
experiment, I tried putting the bad SCSI_Cmnd on a linked list and
returning
success to the SCSI layer. A few seconds later, the watchdog picks up t=
he
command and calls the calls its done function. This immediately resolve=
d
the
problem!

So, my question is: Is this the right way to handle this problem, or is
there another issue? At least part of the SCSI system knows the command=
 was
bad, because it never tries to abort it - but it never issues another
command, either.

Any suggestions?
--
Michael Heinz <mheinz@infiniconsys.com>
Staff Software Engineer
InfiniCon Systems, Inc.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
