From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] unsolicited sense in 2.6.0-test5 usb-storage.ko
Date: 10 Sep 2003 15:24:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063229049.6245.12.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:2704 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265626AbTIJV0G
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 17:26:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309101700230.1579-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> The reason for the unsolicited REQUEST-SENSE ...

Help, lost me.

I'm thinking usb-storage auto sense should always and only follow
bCSWStatus = x01 Failed.  I'm thinking unsolicited auto sense should
occur only if the layers above request such an abuse - never
automagically.

I'm thinking not injecting unsolicited auto sense is a part of the
unwritten specification that "everyone knows" helps hosts get along with
devices.

No?  Where have I gone wrong?

> usb-storage expects that certain commands will
> never yield a short transfer, so if they do it
> must mean something has gone wrong,

I agree something has gone wrong, indeed I am delighted to see that
linux usb-storage detects that something has gone wrong.

> Since sgp_dd asked for a 64-byte
> READ-CAPACITY, it gets what it deserves.

Ah, here we educate me.

I should prepare and forward a patch to correct sgp_dd?

We the community now broadly accept this rule?  We say apps own the job
of keeping the bus "on the thin diagonal" i.e. asking for precisely the
expected count of data bytes?

I expect we can do better, but already I stumbled into a patch that
works (-: because I needed one :-):

--- sg3_utils-1.05/sgp_dd.c	2003-05-29 03:00:48.000000000 -0600
+++ sg3_utils/sgp_dd.c	2003-09-10 14:52:40.408420816 -0600
@@ -244,6 +244,9 @@
     io_hdr.mx_sb_len = sizeof(sense_b);
     io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
     io_hdr.dxfer_len = sizeof(rcBuff);
+#if 1 // PEL
+    io_hdr.dxfer_len = 8;
+#endif
     io_hdr.dxferp = rcBuff;
     io_hdr.cmdp = rcCmdBlk;
     io_hdr.sbp = sense_b;

Pat LaVarre



