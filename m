From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
	infrastructure
Date: Wed, 6 Oct 2010 16:09:26 +0900
Message-ID: <20101006155833G.fujita.tomonori@lab.ntt.co.jp>
References: <1285195750-11516-1-git-send-email-nab@linux-iscsi.org>
	<20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
	<1286339442.5685.76.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34287 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649Ab0JFHJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 03:09:55 -0400
In-Reply-To: <1286339442.5685.76.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com

On Tue, 05 Oct 2010 21:30:42 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> I have been thinking about something similar that is needed for the WIP
> TCM HW target mode drivers when a:
> 
> 	mkdir -p /sys/kernel/config/target/$TCM_MOD/$LPORT_WWPN/tpgt_1
> 
> happens the WWPN is coming from HW.  This currently looks like something
> along the lines of the following for tcm_lpfc:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/tcm_lpfc/tcm_lpfc_configfs.c;hb=tcm_lpfc#l227

The above link doesn't work for me so I'm not sure.

But I guess that you are talking about the problem that
tcm_lpfc_make_lport() can accept proper hardware port addresses. We
are on the same page if so.


> The main issue here is that the user still needs to know the $LPORT_WWPN
> before hand (either from looking at a sticker on the card, or via
> another method) in order to preform the initial TFO->fabric_make_wwn()
> -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
> at the top level TCM fabric group in order to see a list of the
> available hardware ports from the specific $TCM_MOD.  What I was
> thinking for TCM HW fabric module ports would be to have something like:
> 
> 	/sys/kernel/config/target/$TCM_MOD/hw_ports
> 
> that would walk the struct pci_dev looking for fabric module specific HW
> target mode capabilities.  I assume this is what you had in mind for
> drivers/scsi/ibmvscsi as well, yes..?

Doesn't sound so.

I want the driver to create necessary target directories in
/sys/kernel/config/target/ibmvscsit/ automatically.


And 'hw_ports' looks unnecessary because fc drivers already provide
such information under /sys/class/, I think.
