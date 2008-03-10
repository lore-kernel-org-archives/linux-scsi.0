From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference
Date: Mon, 10 Mar 2008 22:50:04 +0100
Message-ID: <86zlt68d0z.fsf@deprecated.bitebene.org>
References: <867igc3w8r.fsf@deprecated.bitebene.org>
	<47D551B8.9080807@panasas.com>
	<1205183577.2941.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757280AbYCJWP4@vger.kernel.org>
In-Reply-To: <1205183577.2941.38.camel@localhost.localdomain> (James
	Bottomley's message of "Mon, 10 Mar 2008 16:12:57 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Mon, 2008-03-10 at 17:20 +0200, Boaz Harrosh wrote:
>> James and linux-scsi CCed.
>
> Looks fine .. could someone send the patch in an applyable form (i.e.
> not quoted).

Sure:

Fix NULL pointer dereference during execution of Internal commands,
where gdth only allocates scp, but not scp->sense_buffer. The rest of
the code assumes that sense_buffer is allocated, which leads to a kernel
oops e.g. on reboot (during cache flush).

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 drivers/scsi/gdth.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 27ebd33..0b2080d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -493,6 +493,12 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     if (!scp)
         return -ENOMEM;
 
+    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+    if (!scp->sense_buffer) {
+	kfree(scp);
+	return -ENOMEM;
+    }
+
     scp->device = sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
@@ -513,6 +519,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
+    kfree(scp->sense_buffer);
     kfree(scp);
     return rval;
 }
-- 
1.5.4.3
