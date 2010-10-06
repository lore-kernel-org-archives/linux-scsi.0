From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Tue, 05 Oct 2010 21:46:45 -0700
Message-ID: <1286340405.5685.93.camel@haakon2.linux-iscsi.org>
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>
	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.106]:41338 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753019Ab0JFEv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 00:51:26 -0400
In-Reply-To: <20101006111621O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>

On Wed, 2010-10-06 at 11:21 +0900, FUJITA Tomonori wrote:
> On Wed, 22 Sep 2010 15:48:22 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> >  drivers/Kconfig                                |    2 +
> >  drivers/Makefile                               |    1 +
> >  drivers/target/Kbuild                          |   30 +
> >  drivers/target/Kconfig                         |   36 +
> 
> Why do we need a new place for the target stuff? This could be used
> for non scsi protocl?
> 

Yes, I have envisioned the princaple pieces of TCM/ConfigFS design being
very much SCSI fabric independent from the start of v3.0 development,
and I think the v4.0 virtual HBA/DEV abstraction now present in
target_core_configfs.c and fabric module independent control plane in
target_core_fabric_configfs.c does demonstrate this design feature.

Of course doing 'SCSI-less' target mode this would still involve some
work to target_core_transport.c to add ATA specific
emulation/passthrough and disable others for the default SPC-3 emulation
logic currently in place.  However, I do believe the TCM subsystem
plugin API in target_core_transport.h for pSCSI, iBLOCK, FILEIO, etc is
already more or less SCSI fabric independent and adding a libata
subsystem plugin (eg: with it's own set of TCM fabric modules) minus
current libata-scsi.c glue code would be possible if the libata folks
would like to entertain that discussion..

> We had the similar discussion when I put stgt to mainline but we
> concluded that under drivers/scsi is the best place.
> 
> I don't like to put ibmvscsi driver under something like
> drivers/target/tcm_ibmvscsit because ibmvscsi needs to include some
> files under drivers/scsi/ibmvscsi/. It's more reasonable to put the
> driver there.
> 
> Can we change the name, TCM (Target Core Mod), to something more
> informative? I think that "Core Mod" is really pointless.
> 
> This will be the mainline scsi target feature so why can't we name
> the files and modules in more appropriate way?

Honestly, I tend not to care very much about naming and things, but that
said I would really hate to have to rename actual TCM code at this point
for .37 (other than say directory location/layout and file names) while
the drivers/target/lio-target -> iscsi_proto.h conversion is still on
our TODO list.

Best,

--nab


