From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Sun, 22 Aug 2004 18:55:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4129247D.1020309@optonline.net>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail04.vassar.edu ([143.229.1.33]:30415 "EHLO smtp.vassar.edu")
	by vger.kernel.org with ESMTP id S267497AbUHVW6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 18:58:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>


Alan Stern wrote:

>The SCSI core doesn't react properly when it receives SK/ASC/ASCQ = x 
>02/04/01 = Not Ready, Logical unit in process of becoming ready.
>
>The core is complex enough that I can't tell exactly what's wrong or how
>it should be fixed.  That particular sense data combination is spotted in
>two different places: scsi_lib.c:scsi_io_completion() and
>scsi_error.c:scsi_check_sense().  It's not clear which one is causing the
>problem -- maybe they both are.
>
>Anyway, the reaction in both routines is to requeue the request for
>immediate retry.  Obviously that's the wrong thing to do.  The request
>should be retried, yes, but only after a delay of, say, a second or so.  
>(Presumably the queue should remain blocked during that time.)  And this
>should keep happening for up to maybe 30 seconds.
>  
>
I agree that this needs to be fixed in the error handler proper. I'm 
currently working around this  kind of problem in my scsi suspend/resume 
patch by inserting explicit spinup calls on resume. It would be much 
better to not have to do so; I don't think it's possible to implement 
auto spindown/spinup without the error handler doing it for us.

>Instead what happens is that all the retries get exhausted in a fraction 
>of a second, which isn't long enough for any device to spin up.  The 
>drivers then proceed blindly with whatever else they want to do, which 
>generally incurs its own set of errors.
>
>This problem seems to be particularly bad for USB DVD drives.  One user
>was able to work around it by manually loading the usb-storage driver 20
>to 30 seconds after plugging the drive into the computer.  Obviously it
>would be much better to have the system do the right thing in the first
>place.
>  
>
It's probably also going to bite SATA drives. People are going to want 
SATA drives to have the same power-management features that IDE has, 
including standby timers and the associated ioctl's... sooner or later 
I'll bet laptops will end up with SATA.

>I don't know enough about the SCSI core to change it properly.  Can
>someone please help?
>
>Alan Stern
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

