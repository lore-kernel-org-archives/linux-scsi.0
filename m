From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Thu, 23 May 2002 11:18:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD184E35E.964CC6B1-ONC1256BC2.003294BC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org


Alas, there does not seem to be a timeout handler to restart IO when
queuecommand returned non 0.
The only way to retrigger IO seems to be a completion of an outstanding
command.
I have seen a lot of hangs in the FCP driver I am contributing to because
of this.
We finally decided never to let queuecommand fail and queue failed requests
internally while there might still be a chance to send them.
This is not too nice though, so it would probably be a good idea to use a
timeout as an alternative trigger to resend commands in the mlqueue.
Maybe a function to be called by the low-level driver would also be an
option.

Cheers,
Aron

On Thu, May 23, 2002 at 03:01:37AM +0100, Alan Cox wrote:
> One thing I see consistently as a problem in the block layers in 2.4 is
> that there is no way to say "thanks for the request you just threw at me
> but Im busy right now" and to flag "busy/idle".
>
> The network layer has a clean way to say "Im busy dont feed me",
> "Im no longer busy, feed me" and also "thanks but I've just discovered I
> am in fact busy have this request back anbd feed it me later"

No, that does in fact exist.  At least in the new scsi eh code you are
allowed to return a non-0 value from your low level driver's
queuecommand() routine.  On a non-0 return, the mid layer throws the
command onto the mlqueue and waits to send it until the mid layer
processes a completion event from you (or there might also be a timeout,
I'm not sure, but I would hope there is also a timeout since otherwise
returning non-0 with no outstanding commands on a device because your
driver is busy with something else could cause a queue to hang).  Anyway,
it's there even if I never did personally use it since my driver used the
old eh code ;-)

--
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




