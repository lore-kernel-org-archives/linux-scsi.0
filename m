From: Andries.Brouwer@cwi.nl
Subject: Re: [PATCH] scsi_status() macro
Date: Sat, 17 May 2003 06:59:30 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200305170459.h4H4xUh19188.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:44009 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261220AbTEQEqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 00:46:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

    From dougg@torque.net  Sat May 17 06:38:09 2003

    > Yes, SCSI-1 has RVVSSSSV with R=reserved, V=vendor unique, S=status.
    > Originally this was a bitmap, and it is still the case that codes
    > are not randomly assigned. (We have several places in the
    > kernel source that test (status & CHECK_CONDITION).)
    <snip>

    Andries,
    There is method in the madness with (status & CHECK_CONDITION).
    In SCSI-2 there is COMMAND TERMINATED status which has the
    value of 0x22. It is the only status in SCSI 2, 3 or the most
    recent drafts that has bit 1 set besides CHECK CONDITION.

    The bottom line:
        (status & CHECK_CONDITION)
    is obscure shorthand for:
        ((status == CHECK_CONDITION) || (status == COMMAND_TERMINATED))
    and that second check should not be dropped any time
    soon.

Yes, you are just saying what I said, namely that the values
are not randomly assigned but still behave like a bitmap.
The code "(status & CHECK_CONDITION)" would be altogether wrong
otherwise.
Still, I dislike such code - when a new code 0x16, or 0x42, is introduced,
do we expect it to describe a status that also requires the actions
that follow "if(status & CHECK_CONDITION)" ?
No SCSI standard describes status as a bitmap. This is from SASI times.

Andries
