From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: New SCSI exc handlers: Returning cmnds?
Date: Fri, 21 Jun 2002 16:16:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF912C2ED8.D5D9043D-ONC1256BDF.004D76C5@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

And after that the things happen you are asking for advice ;-)

Your eh_abort_handler is called for each timed out command (the concern=
ed
scsi_cmnd struct pointer is passed to your routine). Your driver should=
 try
to
abort the particular command and return either SUCCESS or FAILED. This
is a synchrounous step, i.e. your eh_abort_handler returns when the job=
 is
done. If you need to wait, then you are allowed to call schedule since
everything
happens in thread context.
You do not need to call scsi_done() for commands being aborted, but you=
 are
allowed to do so during abort (makes it easier for you to, you don't ha=
ve
to
cope with race conditions). You must not call scsi_done() for commands
after your eh_abort_handler called for this particular command has
returned.

Your eh_*_reset_handler should be implemented similarly.
They might be called if there is still recovery to do after aborting.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Aron Zeh/Germany/IBM@IBMDE@vger.kernel.org on 06/21/2002 03:39:42 PM

Please respond to Aron Zeh/Germany/IBM@IBMDE

Sent by:    linux-scsi-owner@vger.kernel.org


To:    Kurt Garloff <garloff@suse.de>
cc:    Linux SCSI list <linux-scsi@vger.kernel.org>
Subject:    Re: New SCSI exc handlers: Returning cmnds?





As far as I am aware the SCSI midlayer waits for all outstanding comman=
ds
to return or fail/time out.
Only after this has happened, the eh_ handler functions are called.
Starting points are scsi_times_out and __scsi_release_command were
host_busy and host_failed are compared.
In both cases error handling is started by means of waking the eh threa=
d,
e.e up(SCpnt->host->eh_wait);

Cheers,
Aron


Hi,

converting the dc395x_trm (Tekram DC3x5 / TRM-S1040) to new exception
handling, I wonder what needs to be done with queued commands when
eh_abort_handler() or eh_bus_reset_handler() are called.

In the old abort handler, I was feeding the command back with DID_ABORT
and call scsi_done() on it, if successful.
In the old reset handler, I was feeding all commands (including the one
that
was passed when _reset was called) that were sitting in the host adapte=
r
driver's queue  with DID_RESET back to midlayer by calling scsi_done() =
on
them.

How should this handled in the new EH code?
Is the new EH code implicitly aborting the commands, so I don't have to
do it?
Is the ML prepared to have scsi_done() called when doing EH?
Or do I have to use some bottom half/tasklet ... type of mechanism?

Do I have to give the cmnds in queueing order, or does the ML take care
of the correct ordering?

http://www.andante.org/scsi_error.html
is scarily ignorant on that subject.

Thanks for advice!
--
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security




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
