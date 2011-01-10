From: Luben Tuikov <ltuikov@yahoo.com>
Subject: SCSI reusing tags during error recovery
Date: Mon, 10 Jan 2011 10:21:16 -0800 (PST)
Message-ID: <537305.92125.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:25797 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753919Ab1AJSVS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 13:21:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

Observed is on the wire, the following scenario:

0: Tag A (READ) -->
  (Times out)
1: Tag X (TMF ABORT TASK, TTBM=A) -->
2: Tag X (TMR FUNCTION COMPLETE) <--
3: Tag A (TUR) -->
4: Tag A (TUR status GOOD) <--
5: Tag A+2 (some command) -->
...

Undoubtedly resulting from the SCSI layer reusing the request
structure of the timed out Tag A to issue the Test Unit Ready
command, sequence 3.

However, if the task manager were unable to abort Tag A and
returned a different task management result, then the TUR would
complete with CHECK CONDITION (ABORTED COMMAND, OVERLAPPED
COMMANDS ATTEMPTED). Not all transports require the task router
to implement overlapped tag checking, and in most it is optional.
The TUR should go out with Tag A+1.

The SCSI layer should ideally, not perform error recovery ("error
handling" to use Linux' own terminology) on behalf of a timed out
request, but allow higher layers to issue TMF only based on a
ITLQ (tag, a number) or ITL (LUN, a structure) or IT nexus
(target port).

A previous issue I raised, tag generation for tags of task
management functions, can be found here:
http://marc.info/?l=linux-scsi&m=128902337522890&w=2

   Luben

