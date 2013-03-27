From: James Smart <James.Smart@emulex.com>
Subject: error handler scheduling
Date: Tue, 26 Mar 2013 22:11:44 -0400
Message-ID: <51525560.3000008@emulex.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:51758 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3C0CLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Mar 2013 22:11:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In looking through the error handler, if a command times out and is 
added to the eh_cmd_q for the shost, the error handler is only awakened 
once shost->host_busy (total number of i/os posted to the shost) is 
equal to shost->host_failed (number of i/o that have been failed and put 
on the eh_cmd_q).  Which means, any other i/o that was outstanding must 
either complete or have their timeout fire.  Additionally, as all 
further i/o is held off at the block layer as the shost is in recovery, 
new i/o cannot be submitted until the error handler runs and resolves 
the errored i/os.

Is this true ?

I take it is also true that the midlayer thus expects every i/o to have 
an i/o timeout.  True ?

The crux of this point is that when the recovery thread runs to aborts 
the timed out i/os, is at the mercy of the last command to complete or 
timeout. Additionally, as all further i/o is held off at the block layer 
as the shost is in recovery, new i/o cannot be submitted until the error 
handler runs and resolves the errored i/os. So all I/O on the host is 
stopped until that last i/o completes/times out.   The timeouts may be 
eons later.  Consider SCSI format commands or verify commands that can 
take hours to complete.

Specifically, I'm in a situation currently, where an application is 
using sg to send a command to a target. The app selected no-timeout - by 
setting timeout to MAX_INT. Effectively it's so large its infinite.   
This I/O was one of those "lost" on the storage fabric. There was 
another command that long ago timed out and is sitting on the error 
handlers queue. But nothing is happening - new i/o, or error handler to 
resolve the failed i/o, until that inifinite i/o completes.

I'm hoping I hear that I just misunderstand things.  If not,  is there a 
suggestion for how to resolve this predicament ?    IMHO, I'm surprised 
we stop all i/o for error handling, and that it can be so long later...  
I would assume there's a minimum bound we would wait in the error 
handler (30s?) before we unconditionally run it and abort anything that 
was outstanding.

-- james s
