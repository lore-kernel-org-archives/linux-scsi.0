From: Hannes Reinecke <hare@suse.de>
Subject: Overlapped command error handling
Date: Thu, 02 Feb 2006 14:00:34 +0100
Message-ID: <43E20272.5000506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:33967 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751033AbWBBNAf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2006 08:00:35 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 718CAEEF1
	for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2006 14:00:34 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

and here is something for the SCSI Gods out there:

my IOMEGA Zip drive is going into error handling upon access.
Surprisingly enough, the device recovered so it's not really critical.
However, I wonder whether the error recovery is really a hardware error
on the driver itself or whether it's again this blasted aic79xx driver.

What happens is the following:

sd 4:0:6:0: send 0xffff810076858dc0  sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 00 00 00 08 00
-> Read some bytes, ok.

sd 4:0:6:0: send 0xffff810076858488  sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 08 00 00 38 00
-> send request to read some more bytes, ok. Note that the previous
   request has not returned (yet).

sd 4:0:6:0: done 0xffff810076858488 RETRY    8000002 sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 08 00 00 38 00
sdb: Current: sense key: Aborted Command
    Additional sense: Overlapped commands attempted
-> this _looks_ like an error on the drive as the commands do not reall=
y
   overlap. It looks more as if the device can't handle more than one
   command at a time. Do we have a blacklist flag for such things?

sd 4:0:6:0: send 0xffff810076858488                  sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 08 00 00 38 00
-> Command requeued, okay.

sd 4:0:6:0: done 0xffff810076858488 SUCCESS        0 sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 08 00 00 38 00
-> command finished, okay.

sd 4:0:6:0: done 0xffff810076858dc0 TIMEOUT        0 sd 4:0:6:0:
        command: Read (10): 28 00 00 00 00 00 00 00 08 00
-> First command was still out there, but appearently never returned.
   So of course error recovery started for this command.

It looks to me as if the device has aborted _both_ commands when
returning the 'overlapped commands attempted' sense.
Is that conformant behaviour?

SCSI-2 states in section 7.5.2:
A target that detects an incorrect initiator connection shall abort all
I/O processes for the initiator on the logical unit or target routine
and shall return CHECK CONDITION status. The sense key shall be set to
ABORTED COMMAND and the additional sense code shall be set to OVERLAPPE=
D
COMMANDS ATTEMPTED.

So the behaviour of the drive seems to be okay; however, the scsi stack
doesn't abort all commands (yet).
Might that be an error in the scsi stack?

Curious,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
