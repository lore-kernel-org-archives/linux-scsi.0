From: Jeff Woods <kazrak+kernel@cesmail.net>
Subject: Re: [PATCH] oops in sd_shutdown
Date: Mon, 11 Aug 2003 18:13:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <5.2.1.1.0.20030811180413.01a67dc0@no.incoming.mail>
References: <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher>
 <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030812002844.B1353@pclin040.win.tue.nl>
To: Andries Brouwer <aebr@win.tue.nl>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

At +0200 12:28 AM 8/12/2003, Andries Brouwer wrote (in part):
>The obvious patch (with whitespace damage)
>
>diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/sd.c 
>b/drivers/scsi/sd.c
>--- a/drivers/scsi/sd.c Mon Jul 28 05:39:31 2003
>+++ b/drivers/scsi/sd.c Tue Aug 12 01:24:51 2003
>@@ -1351,10 +1351,14 @@
>  static void sd_shutdown(struct device *dev)
>  {
>         struct scsi_device *sdp = to_scsi_device(dev);
>-       struct scsi_disk *sdkp = dev_get_drvdata(dev);
>+       struct scsi_disk *sdkp;
>         struct scsi_request *sreq;
>         int retries, res;
>
>+       sdkp = dev_get_drvdata(dev);
>+       if (!sdkp)
>+               return;         /* this can happen */
>+
>         if (!sdp->online || !sdkp->WCE)
>                 return;


Looking only at the above code snippet, I'd suggest something more like:
~~~~~~~~~~~~~~~~~~
diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/sd.c 
b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c Mon Jul 28 05:39:31 2003
+++ b/drivers/scsi/sd.c Tue Aug 12 01:24:51 2003
@@ -1351,10 +1351,14 @@
  static void sd_shutdown(struct device *dev)
  {
         struct scsi_device *sdp = to_scsi_device(dev);
         struct scsi_disk *sdkp = dev_get_drvdata(dev);
         struct scsi_request *sreq;
         int retries, res;

-       if (!sdp->online || !sdkp->WCE)
+       if (!sdp || !sdp->online || !sdkp || !sdkp->WCE)
                 return;
~~~~~~~~~~~~~~~~~~
If sdp can *never* be NULL *and* this is a performance-critical code-path 
then perhaps it makes sense to leave off the "!sdp || " which I added to 
the logic, but it seems a very small cost to pay for the insurance checking 
in sd_shutdown().

--
Jeff Woods <kazrak+kernel@cesmail.net> 
