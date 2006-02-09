From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Thu, 9 Feb 2006 21:05:29 +0100
Message-ID: <20060209200529.GA8968@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:12685 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750757AbWBIUFf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 15:05:35 -0500
Content-Disposition: inline
In-Reply-To: <1139265890.3022.63.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 On Mon, Feb 06, James Bottomley wrote:

> On Mon, 2006-02-06 at 23:04 +0100, Olaf Hering wrote:
> > I need help on this one.
> > What I have so far (via git-bisect) is:
> 
> My guess would be this patch:
> 
> 
> commit
> 863a930a40eb7f2d18534c2c166b22582f5c6cfd
> [SCSI] fix scsi_reap_target() device_del from atomic context

I'm testing this patch now.

+++ linux-2.6.16-rc2-olh/drivers/scsi/scsi_scan.c
@@ -428,18 +428,19 @@ static void scsi_target_reap_work(void *
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-       struct work_queue_wrapper *wqw = 
-               kzalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);
+       struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+       unsigned long flags;
+       spin_lock_irqsave(shost->host_lock, flags);
 
-       if (!wqw) {
-               starget_printk(KERN_ERR, starget,
-                              "Failed to allocate memory in scsi_reap_target()\n");
+       if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+               list_del_init(&starget->siblings);
+               spin_unlock_irqrestore(shost->host_lock, flags);
+               device_del(&starget->dev);
+               transport_unregister_device(&starget->dev);
+               put_device(&starget->dev);
                return;
        }
-
-       INIT_WORK(&wqw->work, scsi_target_reap_work, wqw);
-       wqw->starget = starget;
-       schedule_work(&wqw->work);
+       spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**



-- 
short story of a lazy sysadmin:
 alias appserv=wotan
