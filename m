From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 1/6] mpt3sas: Introduce
 mpt3sas_base_pci_device_is_available
Date: Fri, 12 Oct 2018 18:43:06 -0500
Message-ID: <20181012234306.GZ5906@bhelgaas-glaptop.roam.corp.google.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926213241.GI28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927070327.wvl5glb4c7gtjoa3@wunner.de>
 <20180927184746.GM28024@bhelgaas-glaptop.roam.corp.google.com>
 <20180927190959.dio4qwti3i4accjm@wunner.de>
 <CA+RiK64EdoSngTzDMUP4xXNcZQa6KfyucsRw42+DUo3s+JPmVQ@mail.gmail.com>
 <20181001204051.GD142872@bhelgaas-glaptop.roam.corp.google.com>
 <20181002140443.GA120535@bhelgaas-glaptop.roam.corp.google.com>
 <CA+RiK65MkxcHapivDqcGC5pM=OL8MHN3nk58_kxmS-hsKCGWkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+RiK65MkxcHapivDqcGC5pM=OL8MHN3nk58_kxmS-hsKCGWkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, Oliver <oohall@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 08, 2018 at 12:14:40PM +0530, Suganath Prabu Subramani wrote:
> On Tue, Oct 2, 2018 at 7:34 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Mon, Oct 01, 2018 at 03:40:51PM -0500, Bjorn Helgaas wrote:
> > > I think the names "pci_device_is_present()" and
> > > "mpt3sas_base_pci_device_is_available()" contribute to the
> > > problem because they make promises that can't be kept -- all we
> > > can say is that the device *was* present, but we don't know
> > > whether it is *still* present.
> 
> In the patch we are using '!' (i.e. not operation) of
> pci_device_is_present(), which is logically same as pci_device_is
> absent, and it is same for mpt3sas_base_pci_device_is_available().
>
> My understanding is that, you want us to rename these functions for
> better readability.  Is that correct ?

I think "pci_device_is_present()" is a poor name, but I'm not
suggesting you fix it in this patch.  Changing that would be a PCI
core change that would also touch the tg3, igb, nvme, and now mpt3sas
drivers that use it.

My personal opinion is that you should do something like the patch
below.  The main point is that you should for the device being
unreachable *at the places where you might learn that*.

If you WRITE to a device that has been removed, the write will mostly
likely get dropped and you won't learn anything.  But when you READ
from a device that has been removed, you'll most likely get ~0 data
back, and you can check for that.

Of course, it's also possible that pci_device_is_present() can tell
you something.  So you *could* sprinkle those all over, as in your
patch.  But you end up with code like this:

  if (!pci_device_is_present())
    return;

  writel();
  readl();

Here, the device might be removed right after pci_device_is_present()
returns true.  You do the writel() and the readl() anyway, so you
really haven't gained anything.  And if the readl() returned ~0, you
assume it's valid data when it's not.

It's better to do this:

  writel();
  val = readl();
  if (val == ~0) {
    /* device is unreachable, clean things up */
    ...
  }

(Obviously it's possible that ~0 is a valid value for whatever you
read from the device.  That depends on the device and you have to use
your knowledge of the hardware.  If you read ~0 from a register where
that might be a valid value, you can read from a different register
for with ~0 is *not* a valid value.)

I don't claim the patch below is complete because I don't know
anything about your hardware and what sort of registers or ring
buffers it uses.  You still have to arrange to flush or complete
whatever is outstanding when you learn the device is gone.

Bjorn


diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59d7844ee022..37b09362b31a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6145,6 +6145,11 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 		drsprintk(ioc, pr_info(MPT3SAS_FMT
 			"wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
 		    ioc->name, count, host_diagnostic));
+		if (host_diagnostic == ~0) {
+			ioc->remove_host = 1;
+			pr_err(MPT3SAS_FMT "HBA unreachable\n", ioc->name);
+			goto out;
+		}
 
 	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
 
@@ -6237,6 +6242,11 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
 	dhsprintk(ioc, pr_info(MPT3SAS_FMT "%s: ioc_state(0x%08x)\n",
 	    ioc->name, __func__, ioc_state));
+	if (ioc_state == ~0) {
+		pr_err(MPT3SAS_FMT "%s: HBA unreachable (ioc_state=0x%x)\n",
+			ioc->name, __func__, ioc_state);
+		return -EFAULT;
+	}
 
 	/* if in RESET state, it should move to READY state shortly */
 	count = 0;
@@ -6251,6 +6261,11 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 			}
 			ssleep(1);
 			ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+			if (ioc_state == ~0) {
+				pr_err(MPT3SAS_FMT "%s: HBA unreachable (ioc_state=0x%x)\n",
+					ioc->name, __func__, ioc_state);
+				return -EFAULT;
+			}
 		}
 	}
 
@@ -6854,6 +6869,11 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pending_io_count = 0;
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+	if (ioc_state == ~0) {
+		pr_err(MPT3SAS_FMT "%s: HBA unreachable\n",
+		       ioc->name, __func__);
+		return;
+	}
 	if ((ioc_state & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL)
 		return;
 
@@ -6909,6 +6929,14 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	    MPT3_DIAG_BUFFER_IS_RELEASED))) {
 		is_trigger = 1;
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+		if (ioc_state == ~0) {
+			pr_err(MPT3SAS_FMT "%s: HBA unreachable\n",
+			       ioc->name, __func__);
+			ioc->schedule_dead_ioc_flush_running_cmds(ioc);
+			r = 0;
+			mutex_unlock(&ioc->reset_in_progress_mutex);
+			goto out_unlocked;
+		}
 		if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
 			is_fault = 1;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 53133cfd420f..d0d4c8d94a10 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2653,6 +2653,11 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 	}
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+	if (ioc_state == ~0) {
+		pr_info(MPT3SAS_FMT "%s: HBA unreachable\n",
+                    __func__, ioc->name);
+		return FAILED;
+	}
 	if (ioc_state & MPI2_DOORBELL_USED) {
 		dhsprintk(ioc, pr_info(MPT3SAS_FMT
 			"unexpected doorbell active!\n", ioc->name));
