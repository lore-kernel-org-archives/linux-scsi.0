From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Need help with libata error handling in libsas
Date: Sun, 24 Feb 2008 16:02:16 -0500
Message-ID: <1203886936.3135.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I keep hearing that we need to convert libsas to use libata's new error
handling.  Unfortunately, I have very little conception of what that
means.  Right at the moment, libsas doesn't use any error handling
functions of libata at all.

I've looked through the libata-eh functions, and I find them frankly
incomprehensible.

Firstly, let me say what SAS error handling actually does:

First of all, we may (or may not) get early warning of problems, so we
have callbacks to allow drivers to trigger the error handler early
(There's a particular event from the aic94xx sequencer which says "I've
detected a screw up on this task, begin error handling now"), which
seems to correspond with ata_qc_schedule_eh().

Then we quiesce the host (standard eh practice, so libata does this to
because SCSI forces it).  Then we go through the remaining tasks.  The
first thing we try is to abort a task.  This is basically asking the HBA
to give me back my task, and is applicable to both ATA and SAS tasks.
Abort serves a dual purpose; if the task is pending or completed, it can
just be flushed from the HBA issue queue.  If the task is actually
active on the end device, then we can send a SCSI TMF after it.  For
ATA, we can't do this, but the docs recommend sending a register D2H FIS
with a soft reset after a non-NCQ task or a CHECK POWER MODE fis after
an NCQ command.  I just don't see anywhere in libata where this is done?

After this, libsas uses a query function (which has no ATA parallel) to
find what the target is doing with the task.

Finally we come to the escalating reset sequece (LUN (hard), phy,
pathway) which seems to mirror what libata-eh would do (well, barring
the pathway reset, since ATA has no concept of that).

All of this leads me to conclude, that all libsas needs is to plumb in
the ATA equivalent of abort, junk the task query for libata devices and
simply proceed, as if the task is held at the target, along the
escalating reset path.

We might be able to weld the error handlers of libsas and libata
together (i.e. use the libata one for everything up to pathway reset and
then move to the libsas one for pathway reset on), the problem is I just
don't see any way of doing this.  Plus abort and TMF query skip are
fairly small alterations to the current libsas eh, so it's not clear
there's any value to acutally welding in the libsas eh, even if I could
get it to provide the information I need.

So, my conclusion is tending towards simply adding an ATA component to
libsas and keeping all eh libsas local.  In that case, is there anything
I need to do to convince libata that I don't care whether it uses old or
new error handling?

James


