From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 3/6] mpt3sas: Introdude _scsih_get_shost_and_ioc.
Date: Mon, 1 Oct 2018 08:40:58 -0500
Message-ID: <20181001134058.GA142872@bhelgaas-glaptop.roam.corp.google.com>
References: <1537935759-14754-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1537935759-14754-4-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20180926210918.GH28024@bhelgaas-glaptop.roam.corp.google.com>
 <CA+RiK66toWULgXRa+nZVOEom70ntQW8PTO7N_8qFn2AvXB_8QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+RiK66toWULgXRa+nZVOEom70ntQW8PTO7N_8qFn2AvXB_8QA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, lukas@wunner.de, Andy Shevchenko <andy.shevchenko@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[+cc LKML]

On Mon, Oct 01, 2018 at 12:57:01PM +0530, Suganath Prabu Subramani wrote:
> On Thu, Sep 27, 2018 at 2:39 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Wed, Sep 26, 2018 at 09:52:36AM +0530, Suganath Prabu S wrote:
> > > The code for getting shost and IOC is redundant so
> > > moved that to function "scsih_get_shost_and_ioc".
> > > Also checks for NULL are added to IOC and shost.
> > >
> > > Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> > > ---
> > >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 98 ++++++++++++++++++++++++++++++------
> > >  1 file changed, 82 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > index 566a550..f6e92eb 100644
> > > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > > @@ -9809,6 +9809,35 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
> > >  }
> > >
> > >  /**
> > > + * _scsih_get_shost_and_ioc - get shost and ioc
> > > + *                   and verify whether they are NULL or not
> > > + * @pdev: PCI device struct
> > > + * @shost: address of scsi host pointer
> > > + * @ioc: address of HBA adapter pointer
> > > + *
> > > + * Return zero if *shost and *ioc are not NULL otherwise return error number.
> > > + */
> > > +static int
> > > +_scsih_get_shost_and_ioc(struct pci_dev *pdev,
> > > +     struct Scsi_Host **shost, struct MPT3SAS_ADAPTER **ioc)
> > > +{
> > > +     *shost = pci_get_drvdata(pdev);
> > > +     if (*shost == NULL) {
> > > +             dev_err(&pdev->dev, "pdev's driver data is null\n");
> > > +             return -ENXIO;
> > > +     }
> > > +
> > > +     *ioc = shost_priv(*shost);
> > > +     if (*ioc == NULL) {
> > > +             dev_err(&pdev->dev, "shost's private data is null\n");
> > > +             return -ENXIO;
> >
> > I think it's better to omit NULL pointer checks like these because
> > there should not be a path where we can execute this code when these
> > pointers are NULL.
> >
> > If there *is* such a path, I think that's a serious bug and it's
> > better to oops when we try to dereference the NULL pointer.  If we
> > just return an error code, it's likely the bug will be ignored and
> > never fixed.
> >
> We have added the ioc and shost checks, because of kernel panic in
> below scenario.
> Have 3 HBA's in system and perform below operation.
> 1) Run “poweroff”.
> 2) Immediate hot unplug HBA.
> We have observed, kernel's shutdown process has removed all the 3
> HBA devices smoothly, and also user have unplugged the HBA device
> during this time. PCI subsystem's hot-plug thread is also trying to
> remove the hot plugged PCI device which is already removed/cleaned
> by the shutdown process. (Which is not expected for the already
> removed device) Due to this kernel panic is observed. And we are not
> sure whether it has to fixed from pciehp layer, so we added sanity
> checks in driver.

This is a great example.  scsih_remove() is the mpt3sas_driver.remove
method.  It sounds like it's getting called twice for the same HBA.
I think that's a PCI core defect and we should fix it there instead of
trying to work around it in every driver.

The trace below is from v4.4.55.  Can you reproduce the same problem
with a current tree, e.g., v4.19-rc?  There have been many changes
since v4.4 that may have fixed this problem.

> [ 1745.605510] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000a98
> [ 1745.606554] IP: [<ffffffffa054c750>] scsih_remove+0x20/0x2d0 [mpt3sas]
> [ 1745.607609] PGD 0
> [ 1745.608621] Oops: 0000 [#1] SMP
> [ 1745.622989] CPU: 0 PID: 668 Comm: kworker/0:2 Tainted: G
> O    4.4.55-1.el7.elrepo.x86_64 #1
> [ 1745.624800] Hardware name: PRO-MNU65930231
> PRO-NME69559126/BRD-PRO55212588, BIOS 0.51e 05/08/2017
> [ 1745.626673] Workqueue: pciehp-3 pciehp_power_thread
> [ 1745.628566] task: ffff881fe50dd880 ti: ffff881fe88e4000 task.ti:
> ffff881fe88e4000
> [ 1745.630530] RIP: 0010:[<ffffffffa054c750>]  [<ffffffffa054c750>]
> scsih_remove+0x20/0x2d0 [mpt3sas]
> [ 1745.632577] RSP: 0018:ffff881fe88e7c98  EFLAGS: 00010292
> [ 1745.634639] RAX: 0000000000000001 RBX: ffff881feef5c000 RCX: 0000000000000000
> [ 1745.636718] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff881feef5c000
> [ 1745.638832] RBP: ffff881fe88e7cc8 R08: 0000000000000000 R09: 0000000180220002
> [ 1745.640972] R10: 00000000eaf4a401 R11: ffffea007fabd280 R12: 0000000000000000
> [ 1745.643136] R13: ffffffffa0576020 R14: ffff881fe9af8240 R15: 0000000000000000
> [ 1745.645320] FS:  0000000000000000(0000) GS:ffff881ffde00000(0000)
> knlGS:0000000000000000
> [ 1745.647572] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1745.649833] CR2: 0000000000000a98 CR3: 0000001fe76df000 CR4: 00000000003406f0
> [ 1745.652147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1745.654476] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1745.656825] Stack:
> [ 1745.659138]  ffff881fe88e7cc8 ffff881feef5c098 ffff881feef5c000
> ffffffffa0576020
> [ 1745.661562]  ffff881fe9af8240 0000000000000000 ffff881fe88e7cf0
> ffffffff8137f9d9
> [ 1745.663990]  ffff881feef5c098 ffffffffa0576088 ffff881feef5c000
> ffff881fe88e7d10
> [ 1745.666428] Call Trace:
> [ 1745.668830]  [<ffffffff8137f9d9>] pci_device_remove+0x39/0xc0
> [ 1745.671256]  [<ffffffff8147db36>] __device_release_driver+0x96/0x130
> [ 1745.673664]  [<ffffffff8147dbf3>] device_release_driver+0x23/0x30
> [ 1745.676071]  [<ffffffff8137851c>] pci_stop_bus_device+0x8c/0xa0
> [ 1745.678485]  [<ffffffff81378612>] pci_stop_and_remove_bus_device+0x12/0x20
> [ 1745.680909]  [<ffffffff81392eea>] pciehp_unconfigure_device+0xaa/0x1b0
> [ 1745.683331]  [<ffffffff813929e2>] pciehp_disable_slot+0x52/0xd0
> [ 1745.685767]  [<ffffffff81392aed>] pciehp_power_thread+0x8d/0xb0
> [ 1745.688210]  [<ffffffff8109728f>] process_one_work+0x14f/0x400
> [ 1745.690633]  [<ffffffff81097b04>] worker_thread+0x114/0x470
> [ 1745.693080]  [<ffffffff810979f0>] ? rescuer_thread+0x310/0x310
> [ 1745.695518]  [<ffffffff8109d648>] kthread+0xd8/0xf0
> [ 1745.697936]  [<ffffffff8109d570>] ? kthread_park+0x60/0x60
> [ 1745.700359]  [<ffffffff816f854f>] ret_from_fork+0x3f/0x70
> [ 1745.702747]  [<ffffffff8109d570>] ? kthread_park+0x60/0x60
