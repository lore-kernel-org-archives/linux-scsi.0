From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Sun, 22 Feb 2009 11:40:36 -0600
Message-ID: <1235324436.4531.54.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902181048210.3186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40249 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbZBVRkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 12:40:40 -0500
In-Reply-To: <Pine.LNX.4.44L0.0902181048210.3186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2009-02-18 at 10:52 -0500, Alan Stern wrote:
> The SCSI core calls scsi_proc_hostdir_add() from within
> scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm()
> routine is called from within scsi_remove_host().  As a result, if a
> host is allocated and then deallocated without ever being registered,
> the host's directory in /proc is leaked.
> 
> This patch (as1181) fixes this bug in the SCSI core by moving
> scsi_proc_hostdir_add() into scsi_host_add().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Note: This is a repost of a bug-fix patch that was first submitted on 
> December 1.
> 
> After looking through the documentation and code for the SCSI legacy 
> API, I can't find anything incompatible with this change.  However I 
> don't have any hardware with a legacy driver so I can't actually make 
> the test.

OK, but resending a patch you expressed reservations about putting in
without testing doesn't really help me.  I need a way to get comfortable
with its safety.

So, what about this alternative fix instead: if the removal were moved
to scsi_host_put(), that would address all the problems and have the
advantage that everyone will test it ...

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index aa670a1..f4240a8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -176,7 +176,6 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
-	scsi_proc_hostdir_rm(shost->hostt);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -493,6 +492,7 @@ EXPORT_SYMBOL(scsi_host_get);
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
+	scsi_proc_hostdir_rm(shost->hostt);
 	put_device(&shost->shost_gendev);
 }
 EXPORT_SYMBOL(scsi_host_put);


