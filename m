From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mptsas: add mptsas_shutdown to call pci_disable_msi
Date: Wed, 07 May 2008 18:50:06 -0500
Message-ID: <1210204207.3067.30.camel@localhost.localdomain>
References: <200804221947.33524.yhlu.kernel@gmail.com>
	 <86802c440804222012w1536b0a7y14a5c2f9dc333624@mail.gmail.com>
	 <20080507163155.1217515f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56216 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbYEGXuL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 19:50:11 -0400
In-Reply-To: <20080507163155.1217515f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, Eric.Moore@lsi.com, ebiederm@xmission.com

On Wed, 2008-05-07 at 16:31 -0700, Andrew Morton wrote:
> On Tue, 22 Apr 2008 20:12:08 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> 
> > On Tue, Apr 22, 2008 at 7:47 PM, Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
> > >
> > >
> > >  this change
> > >
> > >  | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
> > >  | Author: Prakash, Sathya <sathya.prakash@lsi.com>
> > >  | Date:   Fri Mar 7 15:53:21 2008 +0530
> > >  |
> > >  |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
> > >  |
> > >  |     This patch modifies the driver to enable MSI by default for all SAS chips.
> > >  |
> > >  cause kexec RHEL 5.1 kernel fail.
> > >
> > >  root casue: the rhel 5.1 kernel still use INTx emulation.
> > >  and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path
> > >
> > >  so try to call mptsas_remove in mptsas_shutdown.
> > >  then pci_disable_msi will be called via mptsas_remove==>mptscih_remove==>
> > >  mpt_detach.
> > >
> > >  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >  CC: Prakash, Sathya <sathya.prakash@lsi.com>
> > >  CC: "Moore, Eric" <Eric.Moore@lsi.com>
> > >
> > >  Index: linux-2.6/drivers/message/fusion/mptsas.c
> > >  ===================================================================
> > >  --- linux-2.6.orig/drivers/message/fusion/mptsas.c
> > >  +++ linux-2.6/drivers/message/fusion/mptsas.c
> > >  @@ -3327,6 +3327,11 @@ static void __devexit mptsas_remove(stru
> > >         mptscsih_remove(pdev);
> > >   }
> > >
> > >  +static void mptsas_shutdown(struct pci_dev *pdev)
> > >  +{
> > >  +       mptsas_remove(pdev);
> > >  +}
> > >  +
> > >   static struct pci_device_id mptsas_pci_table[] = {
> > >         { PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
> > >                 PCI_ANY_ID, PCI_ANY_ID },
> > >  @@ -3348,7 +3353,7 @@ static struct pci_driver mptsas_driver =
> > >         .id_table       = mptsas_pci_table,
> > >         .probe          = mptsas_probe,
> > >         .remove         = __devexit_p(mptsas_remove),
> > >  -       .shutdown       = mptscsih_shutdown,
> > >  +       .shutdown       = mptsas_shutdown,
> > >   #ifdef CONFIG_PM
> > >         .suspend        = mptscsih_suspend,
> > >         .resume         = mptscsih_resume,
> > >  --
> > 
> > fail on one system with big sas expander...
> > 
> > LBSuse:~ # mkdir /xx
> > LBSuse:~ # mount /dev/sdl1 /xx
> > LBSuse:~ # cd /xx
> > LBSuse:/xx # sh kk_rh_5.1
> > LBSuse:/xx # ./kexec -e
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> > IP: [<ffffffff80337af4>] sysfs_find_dirent+0x1f/0x5f
> > PGD 41f137067 PUD 424482067 PMD 0
> > Oops: 0000 [1] SMP
> > CPU 7
> > Modules linked in:
> > Pid: 7534, comm: kexec Not tainted
> 
> I don't understand your email.
> 
> Are you saying that this oops is the thing which your patch fixes?
> 
> Or are you saying that this oops occurs even after your patch is applied? 
> That we have a second regression?

The regression is actually PCI generic, not mpt specific.  It was fixed
by this commit:

commit d52877c7b1afb8c37ebe17e2005040b79cb618b0
Author: Yinghai Lu <yhlu.kernel.send@gmail.com>
Date:   Wed Apr 23 14:58:09 2008 -0700

    pci/irq: let pci_device_shutdown to call pci_msi_shutdown v2


James


