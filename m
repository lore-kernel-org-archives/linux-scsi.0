From: Matthew Wilcox <willy@debian.org>
Subject: Re: zalon/ncr53c720 crashes K460  (parisc port) on bootup.
Date: Sat, 27 Sep 2003 19:37:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030927183756.GT24824@parcelfarce.linux.theplanet.co.uk>
References: <1064634188.641.27.camel@laptop.bradetich.net> <1064677551.2002.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3745 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262127AbTI0Sh4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2003 14:37:56 -0400
Content-Disposition: inline
In-Reply-To: <1064677551.2002.20.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ryan Bradetich <rbradetich@uswest.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, PARISC list <parisc-linux@lists.parisc-linux.org>

On Sat, Sep 27, 2003 at 10:45:50AM -0500, James Bottomley wrote:
> This should fix the panic, but it simply detaches correctly.

We both missed it.  This is why it's panicing:

        host = ncr_attach(&zalon7xx_template, unit, &device);
        if (!host)
                goto fail;
 fail:
        ncr53c8xx_release(host);
        return error;

ie we're calling ncr53c8xx_release(NULL) so both your & my patch fail
to fix the problem.  This looks best to me:

+++ drivers/scsi/ncr53c8xx.c    27 Sep 2003 18:31:13 -0000
@@ -8855,11 +8855,14 @@ struct Scsi_Host * __init ncr_attach(str
 
 int ncr53c8xx_release(struct Scsi_Host *host)
 {
-       struct host_data *host_data = (struct host_data *)host->hostdata;
+       struct host_data *host_data;
 #ifdef DEBUG_NCR53C8XX
        printk("ncr53c8xx: release\n");
 #endif
-       if (host_data->ncb)
+       if (!host)
+               return 1;
+       host_data = (struct host_data *)host->hostdata;
+       if (host_data && host_data->ncb)
                ncr_detach(host_data->ncb);
        return 1;
 }

and it does fix the problem.  Maybe it's too much checking, but I'm not
interested in tracking down bugs like this again ;-)

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
