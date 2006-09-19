From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 12:14:50 -0700
Message-ID: <451041AA.4060702@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:29057 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751965AbWISTOy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 15:14:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi everybody!

Alexis and I connected both a Adaptec 9410 and a LSI 1064E SAS initiator
to an expander.  Both machines saw the disks attached to the expander,
and both could send I/Os to the disks.  So far, so good.

We then connected a SATA disk to the expander.  libsas BUGd up in
sas_ex_discover_end_dev (sas_expander.c:636):

BUG_ON(sas_port_add(phy->port) != 0);

mptsas didn't seem to do anything with the SATA device at all, though
when we disconnected the SATA disk it recognized that a SATA device went
away.  We'll have a look at the libsas problem in a jiffy.

--D

