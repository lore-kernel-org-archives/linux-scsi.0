From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_status() macro
Date: Sat, 17 May 2003 14:38:44 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC5BCD4.3020600@torque.net>
References: <UTC200305161212.h4GCCcI13287.aeb@smtp.cwi.nl>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:4625 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261207AbTEQEZT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 00:25:19 -0400
In-Reply-To: <UTC200305161212.h4GCCcI13287.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Andries.Brouwer@cwi.nl wrote:
>     > If you're doing this:
>     > 
>     >>+#define scsi_status(result) ((result) & 0x7e)
>     > 
>     > because bit0 is reserved in SCSI-2, then it should be 0x3e because bits
>     > 6 and 7 are also reserved.  Of course, this would clash with the SCSI-3
>     > definition of TASK ABORTED, sigh.
>     > 
>     > Perhaps it's better just not to bother with the mask?
> 
>     James,
>     The macro still gets rid of the upper bytes in
>     scsi_cmnd::result so in needs to be at least
>     a mask of 0xff.
> 
>     With a mask of 0x7e it is correct for SCSI-3,
>     bit 6 is reserved in SCSI-2  and "vendor unique"
>     in SCSI-1 and SCSI_1_CCS. I dug up a SCSI 1 draft and
>     the Status byte table is attached. So as far as I
>     can see our only exposure is to SCSI 1 and CCS
>     devices.
> 
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

In recent standards and drafts COMMAND TERMINATED is deprecated
but in the still important SCSI 2 standard it exists and
also implies that a sense buffer is available and should be
checked.

How long since anyone saw COMMAND TERMINATED? Well I'm
fighting with the ide-scsi driver (and probably losing)
and I see it often. I have a Creative x52 ATAPI CD
reader that once in a while when reading a data CD
with sg_dd fails with COMMAND_TERMINATED/overlapping_
commands. Since sg_dd sends SCSI reads in a purely
sequential order it points to something really sick
in the ide state machine (most likely caused by ide-scsi).
But I digress.

The bottom line:
    (status & CHECK_CONDITION)
is obscure shorthand for:
    ((status == CHECK_CONDITION) || (status == COMMAND_TERMINATED))
and that second check should not be dropped any time
soon.

Doug Gilbert

