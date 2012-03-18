From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND  0000/0002] drivers: scsi: storvsc
Date: Sun, 18 Mar 2012 12:59:49 -0700
Message-ID: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: devel-bounces@linuxdriverproject.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
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
