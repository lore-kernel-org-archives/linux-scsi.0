From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND  0000/0002] drivers: scsi: storvsc
Date: Sun, 18 Mar 2012 17:11:55 -0700
Message-ID: <1332115915-26805-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org


The current Windows hosts only handle a subset of scsi commands
sent from the guest and for commands that are not supported, they are
filtered on the host side a generic failure is returned to the guest
as SRB status. The returned error code does not permit the guest to
figure out if there was an error or if the command was not supported.

Based on the input I got from the community, I have convinced the windows
developers to return an error code that allows the guest to distinguish between
unsupported command and true failures. However, it is not clear when this fix will
be shipped.

This patch set addresses this issue by filtering the ATA_16 command on the guest
(note that currently the host is filtering this command as it is not supported).
I also have a patch here the correctly handles SRB_STATUS_INVALID_REQUEST
error returns - note that the current windows hosts don't return this today.

This is a resend of the patches sent earlier based on suggestions from
Jeff Garzik <jgpobox@gmail.com> and Douglas Gilbert <dgilbert@interlog.com>. 


Regards,

K. Y
