From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
Date: Wed, 06 Oct 2010 00:22:10 -0700
Message-ID: <1286349730.5685.113.camel@haakon2.linux-iscsi.org>
References: <1285195750-11516-1-git-send-email-nab@linux-iscsi.org>
	 <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
	 <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
	 <20101006155833G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101006155833G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-10-06 at 16:09 +0900, FUJITA Tomonori wrote:
> On Tue, 05 Oct 2010 21:30:42 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > I have been thinking about something similar that is needed for the WIP
> > TCM HW target mode drivers when a:
> > 
> > 	mkdir -p /sys/kernel/config/target/$TCM_MOD/$LPORT_WWPN/tpgt_1
> > 
> > happens the WWPN is coming from HW.  This currently looks like something
> > along the lines of the following for tcm_lpfc:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/tcm_lpfc/tcm_lpfc_configfs.c;hb=tcm_lpfc#l227
> 
> The above link doesn't work for me so I'm not sure.
> 

Hmmm, this URL still is working OK for me..?

> But I guess that you are talking about the problem that
> tcm_lpfc_make_lport() can accept proper hardware port addresses. We
> are on the same page if so.
> 
> 

Well, just what the list of possible/available hardware WWNs that the
fabric module will be referencing for the individual:

	mkdir -p /sys/kernel/config/target/$TCM_FAB_MOD/$FABRIC_WWPN

to locate and initialize the per HW port context fabric module configfs
group.

> > The main issue here is that the user still needs to know the $LPORT_WWPN
> > before hand (either from looking at a sticker on the card, or via
> > another method) in order to preform the initial TFO->fabric_make_wwn()
> > -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
> > at the top level TCM fabric group in order to see a list of the
> > available hardware ports from the specific $TCM_MOD.  What I was
> > thinking for TCM HW fabric module ports would be to have something like:
> > 
> > 	/sys/kernel/config/target/$TCM_MOD/hw_ports
> > 
> > that would walk the struct pci_dev looking for fabric module specific HW
> > target mode capabilities.  I assume this is what you had in mind for
> > drivers/scsi/ibmvscsi as well, yes..?
> 
> Doesn't sound so.
> 
> I want the driver to create necessary target directories in
> /sys/kernel/config/target/ibmvscsit/ automatically.
> 
> 

Hmmmm, well configfs is entirely driven by userspace syscalls, so we
want to try to avoid doing this (jlbec CC'ed).  We want userspace code
to parse a list of these values from sysfs+configfs and use these
individual HW WWPN value(s) as the directory/group names for the
mkdir(2) mentioned above.

> And 'hw_ports' looks unnecessary because fc drivers already provide
> such information under /sys/class/, I think.
> --

Well, it really depends on what is required for individual target fabric
modules I think, and perhaps could contain some other useful information
about target mode HW specific available resources.  For the HW FC +
libfc case, as long as the LLD continues to register TARGET_MODE capable
HW ports in /sys/class, I think we should be good to go.

--nab
