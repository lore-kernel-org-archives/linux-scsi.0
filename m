From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Aic94xx and Linux kernel 2.6.19
Date: Mon, 13 Nov 2006 17:53:42 -0800
Message-ID: <455921A6.8080102@us.ibm.com>
References: <834553.41356.qm@web31804.mail.mud.yahoo.com>	<4557707B.8040701@us.ibm.com> <45577499.1010101@garzik.org>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:61670 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1755383AbWKNBxo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Nov 2006 20:53:44 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAE1riTG001057
	for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2006 20:53:44 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAE1riGG511532
	for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2006 18:53:44 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAE1rhPO014038
	for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2006 18:53:44 -0700
In-Reply-To: <45577499.1010101@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, mike.redan@bell.ca, James.Bottomley@SteelEye.com, alexisb@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:

> I'll queue it, but let me know results from your testing regardless.

I no longer see disk errors; it looks like the commands are being
retried at some point in the future, as I'd expect.

However, now I periodically see this:

BUG: warning at drivers/ata/libata-core.c:4597/ata_qc_issue()

One cause of this is that sas_ata was writing the aic94xx sequencer's
version of sactive into the libata's ata_port->sactive shadow register.
 Since we now know that aic94xx assigns its own NCQ tags, the solution
is to avoid this copy, since libata manages ata_port->sactive anyway.

Unfortunately, even with that patched up I still see the message, but
only about 10% as frequently as I used to.  I suspect that I haven't the
right locking around ata_sas_queuecmd and ata_qc_complete; I'm testing
that fix overnight.

--D
