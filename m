From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 10:25:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFB62B3AE3.6B336F4A-ONC1256BE6.002AB5F7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

Hi Doug,

you wrote
> Yes, the answer to this problem involves a timer.  Basically what I
> suggest (and do in my driver) is set it so that the driver waits unti=
l
> either A) a command is completed or B) 10ms has passed before sending=
 the
> command back out, whichever comes first.  Since most drives have had
> plenty of time to complete one or more commands in 10ms, we assume th=
at
> even if we haven't got a completion yet that the drive likely has som=
e
> freed up resources and so we try again.

I don't like the idea to implement those retries in each HBA driver.
It would be the same for each HBA driver:
On queue full condition setup a timer which triggers the retry.
(If the retry has not already been triggered by a returning command.)
How many retries would be allowed? How long may a sequence of retries
take? Do you have in mind that the mid layer has another timer which
watches the completion of your command being in your retry loop
and that this timer will force the command to be aborted on expiration.
I think, implementing this in an HBA driver correctly gets quite
complex. There are a lot of them and there is good chance
that a few of them will get buggy. Besides, it would be much cleaner
to let the mid layer or upper layer care about QUEUE_FULL since
the mentioned ml timer per command would be canceled.


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
