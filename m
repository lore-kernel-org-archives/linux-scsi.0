From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: New SCSI exc handlers: Returning cmnds?
Date: Fri, 21 Jun 2002 15:39:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCE591944.D6D9D70C-ONC1256BDF.004A60F7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>



As far as I am aware the SCSI midlayer waits for all outstanding commands
to return or fail/time out.
Only after this has happened, the eh_ handler functions are called.
Starting points are scsi_times_out and __scsi_release_command were
host_busy and host_failed are compared.
In both cases error handling is started by means of waking the eh thread,
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
was passed when _reset was called) that were sitting in the host adapter
driver's queue  with DID_RESET back to midlayer by calling scsi_done() on
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




