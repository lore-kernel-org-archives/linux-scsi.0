From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 08:08:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFED46B639.A6655537-ONC1256BE6.00209712@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Doug Ledford <dledford@redhat.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org


Hi,

as we learned with zfcp (fibre channel HBA driver for zSeries)
QUEUE_FULL might occur even if there isn't any own SCSI
command of that initiator outstanding. Unfortunately the mid
layer assumes that it can queue at least one command.
This assumption is wrong considering the fact that
other initiators might have filled the queue of a target device
as you describe below. This condition results in a starvation
of I/O for that particular device. The command which was rejected
with QUEUE_FULL is moved into the ml queue and never retried
since the mid layer only triggers a retry when another command for
that device returns. But there is no other command which
could return.
We think this needs to be fixed in the ml code (e.g. retry periodically
triggered by timer?). Our current workaround is to map QUEUE_FULL
to BUSY which avoids moving commands into the ml queue.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Jeremy Higdon <jeremy@classic.engr.sgi.com>@vger.kernel.org on 06/28/20=
02
07:41:31 AM

Please respond to Jeremy Higdon <jeremy@classic.engr.sgi.com>

Sent by:    linux-scsi-owner@vger.kernel.org


To:    Doug Ledford <dledford@redhat.com>, Pete Zaitcev
       <zaitcev@redhat.com>
cc:    linux-scsi@vger.kernel.org
Subject:    Re: [PATCH + RFC] Beginning of some updates to scsi mid lay=
er



On Jun 19,  2:25pm, Doug Ledford wrote:
>
> This is actually from the runtime code, part of my interrupt handler.=
  It
> notices that we might get a lot of QUEUE_FULLs from a device all at t=
he
> same queue depth, and in that case it reduces the queue depth to the =
new
> depth.  So, in short, it's not backwards, it's actually taking the de=
pth
> down based upon solid feedback from the drive.

Is there any accounting for the following condition:

   An array with multiple logical units can accept 256 commands (for
   argument purposes) from all initiators for all luns.  Therefore,
   the number of commands that you can queue to sdX is dependent
   on how many commands queued by this initiator to other sds, as well
   as how many commands other initiators have issued to this sd and
   others.

This may not be an issue so much with parallel SCSI RAIDs, but it does
come up with Fibrechannel.

It is theoretically possible to get QUEUE_FULL when the host has no oth=
er
commands in progress on a logical unit.  Would the host driver then bel=
ieve
that it could issue 0 or 1 command only, or is there some lower limit?

jeremy
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
