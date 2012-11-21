From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 2/5] qla2xxx: Test and clear FCPORT_UPDATE_NEEDED
 atomically.
Date: Wed, 21 Nov 2012 08:12:23 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D01AD10@AVMB1.qlogic.org>
References: <1353483597-17206-3-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:25710
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab2KUI1c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 03:27:32 -0500
In-Reply-To: <1353483597-17206-3-git-send-email-saurav.kashyap@qlogic.com>
Content-Language: en-US
Content-ID: <56C0A13A4BAD9E43A9BE0A219CD88916@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

Hi,
This needs to be copied to stable, added in cc.

Thanks,
~Saurav



>From: David Jeffery <djeffery@redhat.com>
>
>When the qla2xxx driver loses access to multiple, remote ports, there is
>a race
>condition which can occur which will keep the request stuck on a scsi
>request
>queue indefinitely.
>
>This bad state occurred do to a race condition with how the
>FCPORT_UPDATE_NEEDED
>bit is set in qla2x00_schedule_rport_del(), and how it is cleared in
>qla2x00_do_dpc().  The problem port has its drport pointer set, but it
>has never
>been processed by the driver to inform the fc transport that the port has
>been
>lost.  qla2x00_schedule_rport_del() sets drport, and then sets the
>FCPORT_UPDATE_NEEDED bit.  In qla2x00_do_dpc(), the port lists are walked
>and
>any drport pointer is handled and the fc transport informed of the port
>loss,
>then the FCPORT_UPDATE_NEEDED bit is cleared.  This leaves a race where
>the
>dpc thread is processing one port removal, another port removal is marked
>with a call to qla2x00_schedule_rport_del(), and the dpc thread clears the
>bit for both removals, even though only the first removal was actually
>handled.  Until another event occurs to set FCPORT_UPDATE_NEEDED, the
>later
>port removal is never finished and qla2xxx stays in a bad state which
>causes
>requests to become stuck on request queues.
>
>This patch updates the driver to test and clear FCPORT_UPDATE_NEEDED
>atomically.  This ensures the port state changes are processed and not
>lost.
>
>Signed-off-by: David Jeffery <djeffery@redhat.com>
>Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>---
> drivers/scsi/qla2xxx/qla_os.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>index d501bf5..a603967 100644
>--- a/drivers/scsi/qla2xxx/qla_os.c
>+++ b/drivers/scsi/qla2xxx/qla_os.c
>@@ -4505,9 +4505,9 @@ qla2x00_do_dpc(void *data)
>                           "ISP abort end.\n");
>               }
>
>-              if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
>+              if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
>+                  &base_vha->dpc_flags)) {
>                       qla2x00_update_fcports(base_vha);
>-                      clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
>               }
>
>               if (test_bit(SCR_PENDING, &base_vha->dpc_flags)) {
>--
>1.7.7
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

