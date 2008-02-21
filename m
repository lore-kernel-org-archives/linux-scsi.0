From: Mark Hounschell <markh@compro.net>
Subject: New 2.6.24.2 SG_IO SCSI problems
Date: Thu, 21 Feb 2008 10:15:20 -0500
Message-ID: <47BD9588.9080803@compro.net>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.compro.net ([216.54.166.4]:30997 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYBUPSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 10:18:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

I seem to have run into some sort of regression in the SG_IO interface of 2.6.24.2. 
I have an application that up until 2.6.24 worked fine. The 2.6.23.16 kernel works fine.

During reads I get these kernel messages. Writes and other functions _seem_ OK. Actually basic
reads  are working. Its with large BC reads using an io_vec list that the problem shows up.

Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x1.
Feb 21 09:27:51 harley kernel: (scsi1:A:2:0): Have seen Data Phase.  Length = 256.  NumSGs = 1.
Feb 21 09:27:51 harley kernel: sg[0] - Addr 0x06256100 : Length 256
.
.
.
.
.
.

The status elements of the sg_io_hdr_t structure used in the application returns
 status = 0x0 msg_status 0x0 host_status = 0x7 driver_status = 0x0

The hardware in use on this particular machine is an simple Adaptec AHA-2930CU talking to an old
IMPRIMIS 94601-15 1.2GB disk drive.

Again, all this works fine with the 2.6.23.11 kernel

Any help would be appreciated

Regards
Mark Hounschell

