From: Carl Schaefer <schaefer+lk0@employees.org>
Subject: aic7xxx generic SCSI hang in 2.4.22 and later
Date: Tue, 20 Apr 2004 10:23:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420142339.15D9C6730D@wot.wot>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-04-lbl.southeast.rr.com ([24.25.9.103]:42703 "EHLO
	ms-smtp-04-eri0.southeast.rr.com") by vger.kernel.org with ESMTP
	id S262927AbUDTOXl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 10:23:41 -0400
Received: from wot.wot (rdu74-157-179.nc.rr.com [24.74.157.179])
	by ms-smtp-04-eri0.southeast.rr.com (8.12.10/8.12.7) with SMTP id i3KENdC8020953
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2004 10:23:39 -0400 (EDT)
Received: from wot.cisco.com (localhost [127.0.0.1])
	by wot.wot (Postfix) with ESMTP id 0A8EB669E4
	for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2004 10:23:39 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I find that recent kernel versions hang when I run a program called
'vuescan' that uses a generic SCSI device to access a film scanner
(though my SCSI disks, tape drive and CD-RW seem to work fine).
Trying different kernel versions, I discovered that 2.4.21 didn't
hang, but 2.4.22 did.  The hang also occurs with 2.4.25 and 2.4.26.

The hang is such that a hardware reset is required to recover, and
there are no console or log messages generated.  I'm using a Dell PC
with integrated Adaptec 7899P (rev 01) controller and this kernel
config:

CONFIG_SCSI=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=64
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_MASK=0

As an experiment, I copied the aic7xxx directory from 2.4.21 into a
2.4.22 source tree and found that the hang no longer occurred with a
kernel built in that tree.  Is this a reasonable workaround that would
allow me to use recent kernels with my film scanner until the new
driver is fixed, or was I lucky that anything at all worked after a
stunt like that?  :-)

Please let me know if there's anything I can do to extract some useful
debugging information.

thanks!
Carl
