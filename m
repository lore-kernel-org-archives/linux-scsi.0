From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 2.5] fix megaraid driver compile error
Date: 06 Feb 2003 12:39:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044563962.4858.59.camel@markh1.pdx.osdl.net>
References: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XcPf8iw+vAKEM6RsPDTv"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302061202430.3545-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>


--=-XcPf8iw+vAKEM6RsPDTv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2003-02-06 at 12:04, Linus Torvalds wrote:
> On 6 Feb 2003, Mark Haverkamp wrote:
> >
> > This moves access of the host element to device since host has been
> > removed from struct scsi_cmnd.
> 
> This is whitespace-damaged.
> 
> Please fix broken mailers. I generally don't bother to fix up whitespace
> damage from people who can't bother to have a good mailer. It's just not 
> worth it - if I try to fix it up (even if it is often trivial), it just 
> means that people will continue to send crap patches to me.
> 
> 		Linus

Sorry about the bad patch.   Is an attached text file OK?


-- 
Mark Haverkamp <markh@osdl.org>

--=-XcPf8iw+vAKEM6RsPDTv
Content-Disposition: attachment; filename=megaraid.patch
Content-Type: text/plain; name=megaraid.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

===== drivers/scsi/megaraid.c 1.32 vs edited =====
--- 1.32/drivers/scsi/megaraid.c	Fri Jan  3 10:58:49 2003
+++ edited/drivers/scsi/megaraid.c	Thu Feb  6 10:18:43 2003
@@ -4515,7 +4515,7 @@
 		if(scsicmd == NULL) return -ENOMEM;
 
 		memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-		scsicmd->host = shpnt;
+		scsicmd->device->host = shpnt;
 
 		if( outlen || inlen ) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -4652,7 +4652,7 @@
 		if(scsicmd == NULL) return -ENOMEM;
 
 		memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-		scsicmd->host = shpnt;
+		scsicmd->device->host = shpnt;
 
 		if (outlen || inlen) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)

--=-XcPf8iw+vAKEM6RsPDTv--

