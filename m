From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 09:44:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020524094425.A20663@eng2.beaverton.ibm.com>
References: <OF0C31DF68.3F987A16-ONC1256BC3.00347B94@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF0C31DF68.3F987A16-ONC1256BC3.00347B94@de.ibm.com>; from ARZEH@de.ibm.com on Fri, May 24, 2002 at 11:35:40AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: rakesh rakesh <majordomo_linux@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Fri, May 24, 2002 at 11:35:40AM +0200, Aron Zeh wrote:
> 
> True, unfortunately the zSeries FCP adapter does not work that way. You
> have no guarrantee that anything may be queued onto it at any time. I am
> not certain if there are other adapters that work this way.
> 
> Aron

Here's a patch you might want to try out. It should at least prevent
the IO from hanging when the adapter queues up nothing, although it
will loop trying to send out IO. I've never been able to hit this,
it would be good to modify scsi_debug such that we can easily get
queue fulls and host busy's.

--- linux-2.4.18/drivers/scsi/scsi_queue.c-orig	Fri Feb  9 11:30:23 2001
+++ linux-2.4.18/drivers/scsi/scsi_queue.c	Thu May 23 09:50:49 2002
@@ -103,7 +103,7 @@
 		 * If a host is inactive and cannot queue any commands, I don't see
 		 * how things could possibly work anyways.
 		 */
-		if (host->host_busy == 0) {
+		if (host->host_busy == 1) {
 			if (scsi_retry_command(cmd) == 0) {
 				return 0;
 			}
@@ -118,7 +118,7 @@
 		 * If a host is inactive and cannot queue any commands, I don't see
 		 * how things could possibly work anyways.
 		 */
-		if (cmd->device->device_busy == 0) {
+		if (cmd->device->device_busy == 1) {
 			if (scsi_retry_command(cmd) == 0) {
 				return 0;
 			}
