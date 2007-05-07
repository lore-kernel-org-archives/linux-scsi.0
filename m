From: Daniel.E.Messinger@seagate.com
Subject: bidi bsg is non-blocking
Date: Mon, 7 May 2007 10:21:18 -0500
Message-ID: <OF8468A26D.D2DDFDA3-ON862572D4.004E5BE6-862572D4.005458FE@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pps0.sv-ext.mailhost.seagate.com ([192.55.4.60]:43738 "EHLO
	pps0.sv-ext.mailhost.seagate.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934397AbXEGP4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 11:56:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tomof@acm.org
Cc: linux-scsi@vger.kernel.org


Greetings to all,

I'm attempting to use the bidi variant of bsg to talk to an OSD target
device. I've run into an undesirable situation.

My application has a free-running receive loop (doing a read() on the bsg
device) waiting for responses to commands sent to bsg by another thread.
The problem is that the receive thread is getting ENODATA from the read()
when there are no commands pending.  I have NOT set non-blocking.

Note that the old sg driver was quite willing to block until there was a
response available. I find this scenario greatly preferable.

Could bsg be fixed so that read() blocks when there is nothing to return?



Dan Messinger
Seagate Technology Research


