From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: New SCSI exc handlers: Returning cmnds?
Date: Fri, 21 Jun 2002 17:15:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF3B6F224.7885A87F-ONC1256BDF.0052A9FF@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


Kurt,

> To make sure I understand you: The midlayer just discards the timed o=
ut
> SCSI commands, whether I give them back with scsi_done() [and result
> DID_ABORT] or not?

Yes. If your eh_abort_handler returns SUCCESS then the mid layer assume=
s
that the concerned command is gone.
If you call scsi_done() during aborting then only a done_late flag is s=
et
for this command. This flag has no importance.

> But I don't understand your comment about race conditions. I just fre=
e
> up the structures that are allocated in the driver for the command an=
d
> skip the scsi_done() callback that I used to call in the old exc hand=
ler.
> No races ...

Since aborting timed out commansd and returning finished
commands are different control threads, it can happen that
your driver is going to call scsi_done() for a command
which is being aborted. If that's no problem
for your driver then everything is fine.
You only need to make sure that you do not call scsi_done()
after eh_abort_handler() returns.
I remember that this was not a trivial thing in zfcp.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
