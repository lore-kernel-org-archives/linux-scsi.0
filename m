From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] scsi device recovery
Date: Fri, 14 Dec 2007 16:26:59 +0100
Message-ID: <200712141627.00024.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <200712141304.12490.bs@q-leap.de> <1197642901.3154.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:42367 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbXLNP1D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 10:27:03 -0500
In-Reply-To: <1197642901.3154.79.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Friday 14 December 2007 15:35:01 James Bottomley wrote:
> > > This is some type of ioc internal error.  What we do on DID_SOFT_ERROR
> > > is retry for the usual number of times up to the timeout limit.
> > > Unfortunately, the retries are fixed at SD_MAX_RETRIES in sd.c. 
> > > Without diagnosing what's going wrong in the fusion, it's impossible to
> > > say if this is reasonable, but your fusion is signalling ioc errors
> > > (firmware errors).
> >
> > besides this seems to be a fusion driver or firmware problem, I still
> > think eh is not activated for this error. I'm not absulutely sure, but I
> > think with my patch deh and later on eh would be triggered, wouldn't it?
>
> the full eh machinery, by design, isn't activated for a simple retry.
> If you look in scsi_lib.c:scsi_softirq_done() you'll see the processing
> of the outcome of scsi_decide_disposision() (DID_SOFT_ERROR comes out of
> here with NEEDS_RETRY, providing there are retries left).  Right at the
> moment, this means that the retry is absolutely immediate, so you
> probably run through all of the retries before firmware recovery even
> has time to activate.  I'd be amenable to giving it an ADD_TO_MLQUEUE
> type return (provided it still increments retries) which will cause a
> pause in the resubmission (until either a command returns or io pressure
> builds up in the block layer).

Isn't there always i/o pressure if the scsi bus is satturated? Can we activate 
eh machinery when retries is exceeded? 


Index: linux-2.6.22/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_error.c	2007-12-14 15:53:48.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_error.c	2007-12-14 15:58:27.000000000 +0100
@@ -1235,7 +1235,7 @@ int scsi_decide_disposition(struct scsi_
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
-		goto maybe_retry;
+		goto maybe_requeue;
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
 
@@ -1342,6 +1342,24 @@ int scsi_decide_disposition(struct scsi_
 		 */
 		return SUCCESS;
 	}
+
+      maybe_requeue:
+
+	/* we requeue for retry because the error was retryable, and
+	 * the request was not marked fast fail.  Note that above,
+	 * even if the request is marked fast fail, we still requeue
+	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
+	if ((++scmd->retries) <= scmd->allowed
+	    && !blk_noretry_request(scmd->request)) {
+		return ADD_TO_MLQUEUE;
+	} else {
+		/*
+		 * no more retries - report this one back to upper level.
+		 *
+		 * TODO: initiate full error recovery now?
+		 */
+		return SUCCESS;
+	}
 }
 
 /**


>
> > > > Full log attached.
> > > >
> > > > > immediate error with no eh intervention because it means that the
> > > > > target went away.  Handling this as a retryable error isn't an
> > > > > option because it will interfere with hotplug.
> > > >
> > > > Then we need a sysfs flag one can set to manually enable eh for these
> > > > devices on DID_NO_CONNECT.
> > >
> > > No, because that will seriously damage a lot of other systems.
> >
> > How would it, if we create a device specific sysfs parameter defaulting
> > to off? If you think users could activate it by accident, we could also
> > print a big warning when the paramter is read from userspace.
> > Furthermore, as far as I did understand you, DID_NO_CONNECT is only
> > required for hotplugging. But real scsi doesn't do automatic hotplugging,
> > does it?
>
> Yes, it does.  Most modern busses are hot plug aware and use
> DID_NO_CONNECT to signal target went away.  Even some SPI frames are
> quasi hotplug aware.
>
> > One
> > always needs to do it manually, e.g. with scsiadd or similar tools. So is
> > DID_NO_CONNECT really required for native scsi? If not, we also could
> > make the scsi-drivers to set a flag to activate eh on DID_NO_CONNECT.
>
> Just grep through the mid layer ... you'll see we use DID_NO_CONNECT on
> a host of other error conditions to force an immediate error as well.

I will do later on. I will also write a patch allowing error recovery for 
manually overridden devices.

[...]

> > > This looks like a genuine bug.  I missed the thread, since my email
> > > system went off line while I was on holiday for two weeks.  The
> > > symptoms look to be lost commands, but I can't see why from the traces.
> > >  There's a known bug where we can hang in domain validation because of
> > > a resource starvation issue, but I know of none where everything hangs
> > > just after error recovery completes.
> >
> > Since still not much happend to solve this bug, shall I create a bugzilla
> > entry?
>
> Sure ... on further analysis, it is the fusion DV resource starvation
> issue.  The email thread is here:
>
> http://marc.info/?t=118039577800004


Interesting thread, I don't understand the details yet, but I'm really curious 
if this can somehow also explain the *almost deadlock* we are seeing when we 
do md-resync at maximum device speed.


Thanks a lot for your help,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
