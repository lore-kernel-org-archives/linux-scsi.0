From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
Date: Wed, 06 Oct 2010 00:43:37 -0700
Message-ID: <1286351017.5685.137.camel@haakon2.linux-iscsi.org>
References: <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
	 <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
	 <20101006155833G.fujita.tomonori@lab.ntt.co.jp>
	 <20101006162018R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101006162018R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-10-06 at 16:25 +0900, FUJITA Tomonori wrote:
> On Wed, 6 Oct 2010 16:09:26 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Tue, 05 Oct 2010 21:30:42 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > I have been thinking about something similar that is needed for the WIP
> > > TCM HW target mode drivers when a:
> > > 
> > > 	mkdir -p /sys/kernel/config/target/$TCM_MOD/$LPORT_WWPN/tpgt_1
> > > 
> > > happens the WWPN is coming from HW.  This currently looks like something
> > > along the lines of the following for tcm_lpfc:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/tcm_lpfc/tcm_lpfc_configfs.c;hb=tcm_lpfc#l227
> > 
> > The above link doesn't work for me so I'm not sure.
> > 
> > But I guess that you are talking about the problem that
> > tcm_lpfc_make_lport() can accept proper hardware port addresses. We
> > are on the same page if so.
> > 
> > 
> > > The main issue here is that the user still needs to know the $LPORT_WWPN
> > > before hand (either from looking at a sticker on the card, or via
> > > another method) in order to preform the initial TFO->fabric_make_wwn()
> > > -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
> > > at the top level TCM fabric group in order to see a list of the
> > > available hardware ports from the specific $TCM_MOD.  What I was
> > > thinking for TCM HW fabric module ports would be to have something like:
> > > 
> > > 	/sys/kernel/config/target/$TCM_MOD/hw_ports
> > > 
> > > that would walk the struct pci_dev looking for fabric module specific HW
> > > target mode capabilities.  I assume this is what you had in mind for
> > > drivers/scsi/ibmvscsi as well, yes..?
> > 
> > Doesn't sound so.
> > 
> > I want the driver to create necessary target directories in
> > /sys/kernel/config/target/ibmvscsit/ automatically.
> 
> In addition, I also think that /sys/kernel/config/target/$TCM_MOD
> should show up automatically when I load the module.
> 
> vine:/home/fujita# modprobe iscsi_target_mod
> 
> Then why do I need to create iscsi directory by hand?

Because configfs is driven by completely userspace syscalls.  8-)

> 
> vine:/home/fujita# mkdir /sys/kernel/config/target/iscsi
> 

Actually, these is an LKM autoload feature for LIO-Target and TCM_Loop
currently in place when:

	mkdir /sys/kernel/config/target/[iscsi,loopback]

occurs and propigates through target_Core_configfs.c code into
target_core_register_fabric() here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_configfs.c;hb=lio-4.0#l144

Other than these two hardcoded cases (I plan to add these as new modules
are merged into mainline), the userspace code is expected to:

	 modprobe $TCM_FAB_MOD ;
	 mkdir /sys/kernel/config/target/$FAB_MOD

in order to access the top level generic fabric directory/group in
target_core_fabric_configfs.c code.

> 
> btw, 'iscsi' needs to renamed to iscsi_tcp or something like that?

I was thinking here to keep the default software iSCSI LIO-Target code
to use 'iscsi' and use add a seperate iSCSI HW target mode with a iscsi_
$HWNAME prefix as necessary for the existing iSCSI HW TOE cases.  

However there is a certain flavour of iSCSI HW target offload silicon
currently in development that I am considering to integrate directly
into LIO-Target code in order to function transparently with existing
LIO kernel code, along with some new fabric configfs attribute knobs for
tuning, debugging, etc.

--nab
