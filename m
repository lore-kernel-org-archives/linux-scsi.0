From: Ewan Milne <emilne@redhat.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Fri, 04 Dec 2015 11:58:35 -0500
Message-ID: <1449248315.4067.140.camel@localhost.localdomain>
References: <20151201202053.GA4753@glen>
	 <1449097101.2203.67.camel@HansenPartnership.com>
	 <20151203203656.GA9278@glen>
	 <1449176346.2187.19.camel@HansenPartnership.com>
	 <20151203222004.GA22311@glen>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151203222004.GA22311@glen>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 23:20 +0100, Andrea Gelmini wrote:
> On Thu, Dec 03, 2015 at 12:59:06PM -0800, James Bottomley wrote:
> > sg_map -i
> > 
> > in your system, you should see something with an inquiry string like
> > enclosure.  It's the /dev/sg<n> of that you need to run sg_ses on.
> 
> root@glen:/home/gelma# sg_map -i
> /dev/sg0  /dev/sda  ATA       Samsung SSD 850   1B6Q
> /dev/sg1  /dev/sr0  HL-DT-ST  DVDRAM GU40N      QX23
> /dev/sg2  /dev/sdb  WD        My Passport 0820  1007
> /dev/sg3  WD        SES Device        1007
> 
> And following Douglas' instructions:
> 
> root@glen:/home/gelma# lsscsi -gs
> [0:0:0:0]    disk    ATA      Samsung SSD 850  1B6Q  /dev/sda   /dev/sg0   1.02TB
> [1:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GU40N     QX23  /dev/sr0   /dev/sg1        -
> [8:0:0:0]    disk    WD       My Passport 0820 1007  /dev/sdb   /dev/sg2   2.00TB
> [8:0:0:1]    enclosu WD       SES Device       1007  -          /dev/sg3       
> 
> root@glen:/home/gelma# sg_ses /dev/sg3
>   WD        SES Device        1007
> Supported diagnostic pages:
>   Supported Diagnostic Pages [sdp] [0x0]
>   Short Enclosure Status (SES) [ses] [0x8]
>   <unknown> [0x80]
>   <unknown> [0x83]
>   <unknown> [0x84]
>   <unknown> [0x85]
> 
> 
> Well, if it's better for you, I can give you root access to a machine with this device
> connected to.
> 
> Thanks a lot for your time,
> Andrea

There seems to be a problem with the ses code if the device only reports
Short Enclosure Status.  We probably need to do something like:

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eba183c..065a528 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -537,6 +537,15 @@ static int ses_intf_add(struct device *cdev,
        if (result)
                goto recv_failed;
 
+       /* If enclosure only supports Short Enclosure Status page (08),
+        * it returns that page regardless of what we requested, and
+        * only returns vendor-specific status.  There is nothing wrong
+        * with such enclosures, we just can't make use of them. */
+       if (hdr_buf[0] == 8) {
+               err = -ENODEV;
+               goto err_init_free_nomsg;
+       }
+
        len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
        buf = kzalloc(len, GFP_KERNEL);
        if (!buf)
@@ -646,9 +655,10 @@ static int ses_intf_add(struct device *cdev,
        kfree(ses_dev->page2);
        kfree(ses_dev->page1);
  err_init_free:
+       sdev_printk(KERN_ERR, sdev, "Failed to bind enclosure %d\n",
err);
+ err_init_free_nomsg:
        kfree(ses_dev);
        kfree(hdr_buf);
-       sdev_printk(KERN_ERR, sdev, "Failed to bind enclosure %d\n",
err);
        return err;
 }

Otherwise we go off issuing commands for pages the device says it won't
return.  I don't see offhand how this would cause KASAN errors though.

-Ewan
