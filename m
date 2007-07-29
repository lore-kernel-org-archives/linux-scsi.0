From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 0/6] aha152x.c - Cleanup, bugfixes, convert to accessors
Date: Sun, 29 Jul 2007 22:10:39 +0300
Message-ID: <46ACE62F.4070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7993 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759679AbXG2TKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 15:10:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>

In motivation for the !use_sg cleanup and use of accessors
I needed to do some restructuring of the aha152x.c driver.

The patchset has been tested by Randy Dunlap on a PCMCIA
hardware based on aha152x.c. And some bugs where fixed
in the process by Randy.

The problematic parts were that the driver writes all over the
scsi_cmnd members in couple of places. To untangle that I divided
the work to stages for easier review and testing. I was very=20
verbose at each patch explanation, mainly for myself to try and
prove that the changes are sound.=20

[patch 1/6] aha152x in debug mode
 Enabling debug prints would not compile...

[patch 2/6] aha152x.c - use bounce buffer
 Override .slave_alloc() to force use of a bounce buffer
 This fixes a kernel crash with HIGHMEM=3Dy configs.

[patch 3/6] aha152x.c - Preliminary fixes and comments
 Some weird typos and some hard coded numbers made the code
 very hard to understand.

[patch 4/6]  aha152x.c - Clean Reset path
 On the Reset code path the driver would save, write, than=20
 restore scsi_cmnd members. Here I propose a solution that
 does not need to do that.

[patch 5/6] aha152x.c - Fix check_condition code-path
  In case of a Status return from a target. The driver
  would re-queue the command with a REQUEST_SENSE read.
  Again save, write, restore. I cleaned that up to a stage
  I can be happy with. Also while at it I fixed a BUG with
  "resid".

[patch 6/6] aha152x.c - use data accessors and !use_sg cleanup
  And now everything is ready for this one.

Jams I am not getting any response from J=FCrgen E. Fischer which
is to my understanding the maintainer of this driver. With Randy's
testing review, could we accept these changes?

Boaz

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
