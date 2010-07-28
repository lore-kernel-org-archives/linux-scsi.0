From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/3 ver 2] SCSI: implement runtime Power Management
Date: Tue, 27 Jul 2010 22:57:59 -0500
Message-ID: <1280289480.2833.1418.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1006171036540.1915-100000@iolanthe.rowland.org>
	 <1280269302.2833.516.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0G1D6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 23:58:08 -0400
In-Reply-To: <1280269302.2833.516.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2010-07-27 at 17:21 -0500, James Bottomley wrote:
> On Thu, 2010-06-17 at 10:41 -0400, Alan Stern wrote:
> > This patch (as1398b) adds runtime PM support to the SCSI layer.  Only
> > the machanism is provided; use of it is up to the various high-level
> > drivers, and the patch doesn't change any of them.  Except for sg --
> > the patch expicitly prevents a device from being runtime-suspended
> > while its sg device file is open.
> > 
> > The implementation is simplistic.  In general, hosts and targets are
> > automatically suspended when all their children are asleep, but for
> > them the runtime-suspend code doesn't actually do anything.  (A host's
> > runtime PM status is propagated up the device tree, though, so a
> > runtime-PM-aware lower-level driver could power down the host adapter
> > hardware at the appropriate times.)  There are comments indicating
> > where a transport class might be notified or some other hooks added.
> > 
> > LUNs are runtime-suspended by calling the drivers' existing suspend
> > handlers (and likewise for runtime-resume).  Somewhat arbitrarily, the
> > implementation delays for 100 ms before suspending an eligible LUN.
> > This is because there typically are occasions during bootup when the
> > same device file is opened and closed several times in quick
> > succession.
> > 
> > The way this all works is that the SCSI core increments a device's
> > PM-usage count when it is registered.  If a high-level driver does
> > nothing then the device will not be eligible for runtime-suspend
> > because of the elevated usage count.  If a high-level driver wants to
> > use runtime PM then it can call scsi_autopm_put_device() in its probe
> > routine to decrement the usage count and scsi_autopm_get_device() in
> > its remove routine to restore the original count.
> > 
> > Hosts, targets, and LUNs are not suspended while they are being probed
> > or removed, or while the error handler is running.  In fact, a fairly
> > large part of the patch consists of code to make sure that things
> > aren't suspended at such times.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > ---
> > 
> > Version 2 changes:
> > 
> > 	Rebase to apply on top of the revised 1/3 patch.
> > 
> > 	Add a KERN_ERR log level to the SCSI_LOG_ERROR_RECOVERY
> > 	call, as recommended by checkpatch.
> > 
> > Incidentally, although I didn't mention it before, this patch assumes 
> > that the 7-part series beginning here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=127551091314515&w=2
> > 
> > has been merged.
> > 
> > 
> > Index: usb-2.6/drivers/scsi/scsi_priv.h
> > ===================================================================
> > --- usb-2.6.orig/drivers/scsi/scsi_priv.h
> > +++ usb-2.6/drivers/scsi/scsi_priv.h
> > @@ -7,6 +7,7 @@ struct request_queue;
> >  struct request;
> >  struct scsi_cmnd;
> >  struct scsi_device;
> > +struct scsi_target;
> >  struct scsi_host_template;
> >  struct Scsi_Host;
> >  struct scsi_nl_hdr;
> > @@ -147,7 +148,18 @@ static inline void scsi_netlink_exit(voi
> >  /* scsi_pm.c */
> >  #ifdef CONFIG_PM_OPS
> >  extern const struct dev_pm_ops scsi_bus_pm_ops;
> > +#ifdef CONFIG_PM_RUNTIME
> > +extern void scsi_autopm_get_target(struct scsi_target *);
> > +extern void scsi_autopm_put_target(struct scsi_target *);
> > +extern int scsi_autopm_get_host(struct Scsi_Host *);
> > +extern void scsi_autopm_put_host(struct Scsi_Host *);
> >  #else
> > +static inline void scsi_autopm_get_target(struct scsi_target *) {}
> > +static inline void scsi_autopm_put_target(struct scsi_target *) {}
> > +static inline int scsi_autopm_get_host(struct Scsi_Host *) { return 0; }
> > +static inline void scsi_autopm_put_host(struct Scsi_Host *) {}
> 
> You didn't compile this, did you?  The compiler gets distinctly annoyed
> to see an inline function with no actual variable for the argument ...
> 
> I fixed up this and the one in scsi_device.h

Since there were actually 3 relevant config variations, this turned out
to be the final fix.

James

---

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 53010a3..026295e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -148,20 +148,20 @@ static inline void scsi_netlink_exit(void) {}
 /* scsi_pm.c */
 #ifdef CONFIG_PM_OPS
 extern const struct dev_pm_ops scsi_bus_pm_ops;
+#else /* CONFIG_PM_OPS */
+#define scsi_bus_pm_ops		(*NULL)
+#endif
 #ifdef CONFIG_PM_RUNTIME
 extern void scsi_autopm_get_target(struct scsi_target *);
 extern void scsi_autopm_put_target(struct scsi_target *);
 extern int scsi_autopm_get_host(struct Scsi_Host *);
 extern void scsi_autopm_put_host(struct Scsi_Host *);
 #else
-static inline void scsi_autopm_get_target(struct scsi_target *) {}
-static inline void scsi_autopm_put_target(struct scsi_target *) {}
-static inline int scsi_autopm_get_host(struct Scsi_Host *) { return 0; }
-static inline void scsi_autopm_put_host(struct Scsi_Host *) {}
+static inline void scsi_autopm_get_target(struct scsi_target *t) {}
+static inline void scsi_autopm_put_target(struct scsi_target *t) {}
+static inline int scsi_autopm_get_host(struct Scsi_Host *h) { return 0; }
+static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM_RUNTIME */
-#else /* CONFIG_PM_OPS */
-#define scsi_bus_pm_ops		(*NULL)
-#endif
 
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7df2eff..50cb34f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -385,8 +385,8 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 extern int scsi_autopm_get_device(struct scsi_device *);
 extern void scsi_autopm_put_device(struct scsi_device *);
 #else
-static inline int scsi_autopm_get_device(struct scsi_device *) { return 0; }
-static inline void scsi_autopm_put_device(struct scsi_device *) {}
+static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
+static inline void scsi_autopm_put_device(struct scsi_device *d) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)


