From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v2] fusion-mptbase: handle failed allocation for
 workqueue
Date: Thu, 18 Feb 2016 11:40:15 -0500
Message-ID: <1455813615.22112.473.camel@localhost.localdomain>
References: <1455770459-905-1-git-send-email-wuninsu@gmail.com>
	 <20160218090043.GQ18134@c203.arch.suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FGeXHH/WNXmKbVeVPXM3"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160218090043.GQ18134@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, thenzl@redhat.com
Cc: Insu Yun <wuninsu@gmail.com>, nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org


--=-FGeXHH/WNXmKbVeVPXM3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2016-02-18 at 10:00 +0100, Johannes Thumshirn wrote:
> On Wed, Feb 17, 2016 at 11:40:59PM -0500, Insu Yun wrote:
> > the failure of ioc->reset_work_q is checked,
> > but not ioc->fw_event_q.
> > 
> > Signed-off-by: Insu Yun <wuninsu@gmail.com>
> > ---
> >  drivers/message/fusion/mptbase.c | 44 ++++++++++++++++++++++++----------------
> >  1 file changed, 27 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> > index 5dcc031..53a5015 100644
> > --- a/drivers/message/fusion/mptbase.c
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -1871,9 +1871,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	if (!ioc->reset_work_q) {
> >  		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
> >  		    ioc->name);
> > -		pci_release_selected_regions(pdev, ioc->bars);
> > -		kfree(ioc);
> > -		return -ENOMEM;
> > +		r = -ENOMEM;
> > +		goto err3;
> >  	}
> >  
> >  	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
> > @@ -1996,24 +1995,16 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
> >  	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
> >  
> > +	if (!ioc->fw_event_q) {
> > +		r = -ENOMEM;
> > +		goto err2;
> > +	}
> > +
> >  	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
> >  	    CAN_SLEEP)) != 0){
> >  		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
> >  		    ioc->name, r);
> > -
> > -		list_del(&ioc->list);
> > -		if (ioc->alt_ioc)
> > -			ioc->alt_ioc->alt_ioc = NULL;
> > -		iounmap(ioc->memmap);
> > -		if (r != -5)
> > -			pci_release_selected_regions(pdev, ioc->bars);
> > -
> > -		destroy_workqueue(ioc->reset_work_q);
> > -		ioc->reset_work_q = NULL;
> > -
> > -		kfree(ioc);
> > -		pci_set_drvdata(pdev, NULL);
> > -		return r;
> > +		goto err1;
> >  	}
> >  
> >  	/* call per device driver probe entry point */
> > @@ -2040,6 +2031,25 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >  			msecs_to_jiffies(MPT_POLLING_INTERVAL));
> >  
> >  	return 0;
> > +
> > +err1:
> > +		destroy_workqueue(ioc->fw_event_q);
> > +		ioc->fw_event_q = NULL;
> > +err2::
> > +		destroy_workqueue(ioc->reset_work_q);
> > +		ioc->reset_work_q = NULL;
> > +
> > +		list_del(&ioc->list);
> > +		if (ioc->alt_ioc)
> > +			ioc->alt_ioc->alt_ioc = NULL;
> > +		iounmap(ioc->memmap);
> > +		pci_set_drvdata(pdev, NULL);
> > +err3:
> > +		if (r != -5)
> > +			pci_release_selected_regions(pdev, ioc->bars);
> > +		kfree(ioc);
> > +		return r;
> > +
> >  }
> 
> Please no. Not err1, err2 and err3.
> 
> err1 could be "goto destroy_fw_event_q", err2 "destroy_reset_workq", err3
> goto "free_ioc".

It also appears to me upon further inspection that the existing code has
other problems.  In particular, once mpt_mapresources() has returned
with a nonzero error code, it looks like iounmap() should be called, but
it is not in the case of a failed allocation of reset_work_q.  I'm also
not sure why pci_release_selected_regions() is only called for the case
of mpt_do_ioc_recovery() returning != -5 when it is called whenever
there is a failed allocation of reset_work_q.

Consider the attached patch (untested, because I don't have hardware):
It shows what I would do for labels & error handling.  If the rc != -5
case of return from mpt_do_ioc_recovery() could be eliminated, then
another label "out_free_fw_event_q:" could be added prior to the other
error cases at the end, and all the code after the printk() in that path
could be replaced by "goto out_free_fw_event_q;"

	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
	    CAN_SLEEP)) != 0){
		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
		    ioc->name, r);
		goto out_free_fw_event_q;
	}
...

out_free_fw_event_q:
	destroy_workqueue(ioc->fw_event_q);
	ioc->fw_event_q = NULL;

out_remove_ioc:
...

However I do not know if that change is legitimate.

-Ewan

> >  
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--=-FGeXHH/WNXmKbVeVPXM3
Content-Disposition: attachment; filename="0001-mptbase-fixup-error-handling-paths-in-mpt_attach.patch"
Content-Type: text/x-patch; name="0001-mptbase-fixup-error-handling-paths-in-mpt_attach.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 83f117b81d58d01bfe7e01e04e4f2f2a602e2c9f Mon Sep 17 00:00:00 2001
From: "Ewan D. Milne" <emilne@redhat.com>
Date: Thu, 18 Feb 2016 11:24:02 -0500
Subject: [PATCH RFC] mptbase: fixup error handling paths in mpt_attach()

mpt_attach() was not checking for the failure to create fw_event_q.
Also, iounmap() was not being called in all error cases after ioremap()
had been called by mpt_mapresources().
---
 drivers/message/fusion/mptbase.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5dcc031..1fdc882 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1801,8 +1801,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->pcidev = pdev;
 	if (mpt_mapresources(ioc)) {
-		kfree(ioc);
-		return r;
+		goto out_free_ioc;
 	}
 
 	/*
@@ -1871,9 +1870,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->reset_work_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
-		pci_release_selected_regions(pdev, ioc->bars);
-		kfree(ioc);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_unmap_resources;
 	}
 
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
@@ -1995,12 +1993,21 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->fw_event_lock);
 	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
 	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
+	if (!ioc->reset_work_q) {
+		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
+		    ioc->name);
+		r = -ENOMEM;
+		goto out_remove_ioc;
+	}
 
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
 	    CAN_SLEEP)) != 0){
 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
 		    ioc->name, r);
 
+		destroy_workqueue(ioc->fw_event_q);
+		ioc->fw_event_q = NULL;
+
 		list_del(&ioc->list);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
@@ -2040,6 +2047,24 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 			msecs_to_jiffies(MPT_POLLING_INTERVAL));
 
 	return 0;
+
+out_remove_ioc:
+	list_del(&ioc->list);
+	if (ioc->alt_ioc)
+		ioc->alt_ioc->alt_ioc = NULL;
+	pci_set_drvdata(ioc->pcidev, NULL);
+
+	destroy_workqueue(ioc->reset_work_q);
+	ioc->reset_work_q = NULL;
+
+out_unmap_resources:
+	iounmap(ioc->memmap);
+	pci_release_selected_regions(pdev, ioc->bars);
+
+out_free_ioc:
+	kfree(ioc);
+
+	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -6229,7 +6254,7 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 	memcpy(ioc->board_assembly, pbuf->BoardAssembly, sizeof(ioc->board_assembly));
 	memcpy(ioc->board_tracer, pbuf->BoardTracerNumber, sizeof(ioc->board_tracer));
 
-	out:
+out:
 
 	if (pbuf)
 		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
-- 
2.1.0


--=-FGeXHH/WNXmKbVeVPXM3--
