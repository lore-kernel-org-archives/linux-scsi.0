From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: 21 Jun 2004 11:32:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087835531.2077.45.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:14722 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266306AbUFUQcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 12:32:18 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925031@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: Eric Dean Moore <Emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 11:16, Moore, Eric Dean wrote:
> We are pleased to announce the MPT Fusion release candidate for lk 2.6

I really don't like this:

+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6))
+#define	mpt_scsi_device_online(scmd) scsi_device_online(scmd->device)
+#else
+#define	mpt_scsi_device_online(scmd) scmd->device->online
+#endif

What's wrong with just doing

#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
static inline void scsi_device_online(struct scsi_device *sdev)
{
	return sdev->online;
}
#endif

and then just using scsi_device_online() in the code instead of
mpt_scsi_device_online()?

Then the code is correct without obfuscations and still compiles on
2.6.5 and before.

This also:

-typedef int32_t   S32;
-typedef u_int32_t U32;
+#if defined(unix) || defined(__arm) || defined(ALPHA)
+
+    typedef signed   int   S32;
+    typedef unsigned int   U32;
+
+#else
+
+    typedef signed   long  S32;
+    typedef unsigned long  U32;
+
+#endif

Looks highly suspect.  What was wrong with the original?

James



