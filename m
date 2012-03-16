From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0002] drivers: scsi: storvsc
Date: Fri, 16 Mar 2012 13:24:08 -0700
Message-ID: <1331929448-6838-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46826
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757604Ab2CPUwP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2012 16:52:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>


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
(note that currently the host is filtering this command as it is not supported). I also have
a patch here the correctly handles SRB_STATUS_INVALID_REQUEST error returns - note that
the current windows hosts don't return this today.


Regards,

K. Y
