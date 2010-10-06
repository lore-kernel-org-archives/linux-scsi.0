From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Wed, 06 Oct 2010 00:24:58 -0700
Message-ID: <1286349898.5685.117.camel@haakon2.linux-iscsi.org>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>
	 <1286340405.5685.93.camel@haakon2.linux-iscsi.org>
	 <20101006160434M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101006160434M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, jeff@garzik.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-10-06 at 16:09 +0900, FUJITA Tomonori wrote:
> On Tue, 05 Oct 2010 21:46:45 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2010-10-06 at 11:21 +0900, FUJITA Tomonori wrote:
> > > On Wed, 22 Sep 2010 15:48:22 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > >  drivers/Kconfig                                |    2 +
> > > >  drivers/Makefile                               |    1 +
> > > >  drivers/target/Kbuild                          |   30 +
> > > >  drivers/target/Kconfig                         |   36 +
> > > 
> > > Why do we need a new place for the target stuff? This could be used
> > > for non scsi protocl?
> > > 
> > 
> > Yes, I have envisioned the princaple pieces of TCM/ConfigFS design being
> > very much SCSI fabric independent from the start of v3.0 development,
> > and I think the v4.0 virtual HBA/DEV abstraction now present in
> > target_core_configfs.c and fabric module independent control plane in
> > target_core_fabric_configfs.c does demonstrate this design feature.
> > 
> > Of course doing 'SCSI-less' target mode this would still involve some
> > work to target_core_transport.c to add ATA specific
> > emulation/passthrough and disable others for the default SPC-3 emulation
> > logic currently in place.  However, I do believe the TCM subsystem
> > plugin API in target_core_transport.h for pSCSI, iBLOCK, FILEIO, etc is
> > already more or less SCSI fabric independent and adding a libata
> > subsystem plugin (eg: with it's own set of TCM fabric modules) minus
> > current libata-scsi.c glue code would be possible if the libata folks
> > would like to entertain that discussion..
> 
> I like to hear the opinions of SCSI maintainer and ATA folks.

jejb, jgarzik, tejun and co..?  Any thoughts here..?

> 
> Even if the target feature is SCSI independent, the SCSI drivers
> should go to under driver/scsi. As I explained, at least, it's a
> cleaner solution for ibmvscsi target driver.
> 
> 

Fair enough then.  Then I will plan to move the upstream
lio-core-2.6.git/lio-4.0 branch to live under drivers/scsi/ soon, and
rebase the next .37 branch for mainline following this new layout.

> > > We had the similar discussion when I put stgt to mainline but we
> > > concluded that under drivers/scsi is the best place.
> > > 
> > > I don't like to put ibmvscsi driver under something like
> > > drivers/target/tcm_ibmvscsit because ibmvscsi needs to include some
> > > files under drivers/scsi/ibmvscsi/. It's more reasonable to put the
> > > driver there.
> > > 
> > > Can we change the name, TCM (Target Core Mod), to something more
> > > informative? I think that "Core Mod" is really pointless.
> > > 
> > > This will be the mainline scsi target feature so why can't we name
> > > the files and modules in more appropriate way?
> > 
> > Honestly, I tend not to care very much about naming and things, but that
> > said I would really hate to have to rename actual TCM code at this point
> > for .37 (other than say directory location/layout and file names) while
> > the drivers/target/lio-target -> iscsi_proto.h conversion is still on
> > our TODO list.
> 
> I'm not sure this goes for .37 (up to James) but anyway I think that
> we need to take care about the module names now. Once we put stuff
> into mainline, it's not good to change the module names.

Yes, definately not..

>  File and directory names and layout can be changed any time.

Thanks again for your comments Tomo!

--nab
