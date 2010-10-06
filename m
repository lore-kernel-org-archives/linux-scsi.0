From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
Date: Tue, 05 Oct 2010 21:30:42 -0700
Message-ID: <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
References: <1285195750-11516-1-git-send-email-nab@linux-iscsi.org>
	 <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:31956 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753321Ab0JFEfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 00:35:24 -0400
In-Reply-To: <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com

On Wed, 2010-10-06 at 09:17 +0900, FUJITA Tomonori wrote:
> On Wed, 22 Sep 2010 15:49:10 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the TCM/ConfigFS core HBA and device backstore infrastructre
> > objects in /sys/kernel/config/target/core.  It includes wrappers to logic for
> > Persistent Reservations and ALUA, and supports Linux/SCSI, Linux/BLOCK, and Linux/FILEIO
> > backstores using TCM subsystem plugin API.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_configfs.c | 3334 +++++++++++++++++++++++++++++++++
> >  include/target/target_core_configfs.h |   57 +
> >  2 files changed, 3391 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/target_core_configfs.c
> >  create mode 100644 include/target/target_core_configfs.h
> 
> Can a driver create a directory/file under configfs?
> 
> ibmvscsi target driver gets the list of targets to set up from
> hardware (see how drivers/scsi/ibmvscsi/ibmvstgt.c use
> vio_register_driver). The driver needs to tell an user about it so
> that he can set up luns, etc via configfs.

Hi Tomo-san,

I have been thinking about something similar that is needed for the WIP
TCM HW target mode drivers when a:

	mkdir -p /sys/kernel/config/target/$TCM_MOD/$LPORT_WWPN/tpgt_1

happens the WWPN is coming from HW.  This currently looks like something
along the lines of the following for tcm_lpfc:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/tcm_lpfc/tcm_lpfc_configfs.c;hb=tcm_lpfc#l227

The main issue here is that the user still needs to know the $LPORT_WWPN
before hand (either from looking at a sticker on the card, or via
another method) in order to preform the initial TFO->fabric_make_wwn()
-> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
at the top level TCM fabric group in order to see a list of the
available hardware ports from the specific $TCM_MOD.  What I was
thinking for TCM HW fabric module ports would be to have something like:

	/sys/kernel/config/target/$TCM_MOD/hw_ports

that would walk the struct pci_dev looking for fabric module specific HW
target mode capabilities.  I assume this is what you had in mind for
drivers/scsi/ibmvscsi as well, yes..?

Anyways, this should be easy enough add a generic top level hw_ports
attrib into target_core_fabric_configfs.c and optionally provide this
logic for HW target mode capable code.

I have a few external items in the next days, but I will make sure to
get this coded and merged into TCM v4.0.0-rc5 and the next RFC-for.37
rebase.

Thanks Tomo!

--nab


