From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: ACARD SCSI driver update for Linux kernel v2.6
Date: Thu, 30 Dec 2004 09:20:17 -0600
Message-ID: <1104420017.5268.14.camel@mulgrave>
References: <026801c4ee56$1e802810$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12767 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261652AbUL3PUd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Dec 2004 10:20:33 -0500
In-Reply-To: <026801c4ee56$1e802810$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@mail.acard.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-12-30 at 17:58 +0800, jameshsu wrote:
> 1) Do you think this is necessary to forward this email to James Bottomley??
> (Don't know his email & how can I submit??)

The SCSI list is fine.  To find the emails of most maintainers, look in
the MAINTAINERS file in the kernel source.

> 2) A set of patch files attached with this email. Should this be good enough
> for process??

Not really.  Your patch is huge.  I'd like to see a set of incremental
patches each separately described adding individual features.
(Documentation/SubmittingPatches is a good place to start).

Some of the things in the current patch are obviously wrong:

+++ linux-2.6.10/drivers/scsi/atp870u.c	2004-12-29 15:13:55.000000000 -0500
@@ -1,21 +1,36 @@
-/*
- *  Copyright (C) 1997	Wu Ching Chen
- *  2.1.x update (C) 1998  Krzysztof G. Baranowski
- *  2.5.x update (C) 2002  Red Hat <alan@redhat.com>
- *  2.6.x update (C) 2004  Red Hat <alan@redhat.com>
+/* $Id: atp870u.c,v 2.0 2004/12/24 15:42:00 root Exp root $
  *
- * Marcelo Tosatti <marcelo@conectiva.com.br> : SMP fixes
- *

You can't remove people's copyrights from the file.  Even if you
originally owned it, several people have put effort into modifying the
file to make sure it still compiles and runs, the copyright marks their
ownership of the modifications they made.

-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h>
[...]
+#include "scsi.h"
+#include "hosts.h"

This is reversing the update to the new SCSI headers.  The old headers
are now deprecated, so this type of update isn't acceptable.

+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+static irqreturn_t atp885_intr_handle(int irq, void *dev_id, struct
pt_regs *regs)
+#else
+static void atp885_intr_handle(int irq, void *dev_id, struct pt_regs
*regs)
+#endif

Please don't do this type of thing.  the atp870u driver is nice at the
moment because it has no kernel version dependencies ... I'd really
rather it didn't get cluttered up with them.

+static struct Scsi_Host *atp_host[MAX_ADAPTER];
+static int host_index = 0;

This also isn't acceptable ... Zwane Mwaikambo did a lot of work early
this year breaking this driver's dependence on a static list and fixing
a whole host of other problems it had.  Static lists in drivers are bad,
so I don't want to see this reversed.

In short, it rather looks like you've been building a driver out of tree
for a while and have simply constructed diffs between that driver and
what's currently in the tree (the demolish and rebuild approach).
However, people have spent time correcting faults in the in-tree driver
which you haven't done for the out of tree one.  So please go back and
see what's been done in the tree that you can take advantage of.  Or,
start from the in-tree driver and work out what extra features need to
be added and what bugs need to be fixed and supply separate patches for
doing that.

James




