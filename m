From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
Date: Thu, 16 Sep 2010 16:18:02 -0700
Message-ID: <1284679082.13344.117.camel@haakon2.linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <1284678103.13344.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:47653 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752542Ab0IPXWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 19:22:13 -0400
In-Reply-To: <1284678103.13344.111.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>

On Thu, 2010-09-16 at 16:01 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This series contains the first round of a whole-sale conversion for droping
> > struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> > scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> > that is protected by host_lock is scsi_cmd_get_serial)_.
> > 
> > The patches #2 -> #8 converts libiscsi, libsas, lpfc, qla4xxx, qla2xxx,
> > TCM_Loop, and libfc code to drop their own SHT->queuecommand() internal
> > host_lock unlock() + lock() optimization that certain high performance libs
> > and LLDs have adopted over the years.  The changes involved here are really
> > quite straight forward, but please note that none of this code has been tested
> > with actual hardware yet, and is intended for generating comments for the relivent
> > SCSI LLD driver maintainers and other interested folks.
> > 
> > There are probably still be more LLDs which use this optimization, so please
> > let me know if there is another piece of SHT->queuecommand() caller code that
> > does this legacy optimization and needs to be updated.  I will be sure to
> > CC the right driver maintainers and CC linux-scsi as I come across any more
> > conversions.
> 
> Hi Guys,
> 
> drivers/scsi/fnic needs the conversion as well..  Here is that patch;
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=3c886b2ab6faccbe2803094deb7a9647199e5118
> 

Ok, after doing some more digging the BusLogic and the ever important
libata SCSI glue code use the legacy host_lock unlock() -> do_work ->
lock() optimization as well.  Here are those patches (jgarzik CC'ed):

buslogic: Remove host_lock unlock() + lock() from BusLogic_QueueCommand()
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=b465dfeb8e6950faa9c074681c72ca0a6c21276c

libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=29f2ded8876910d7eb84e4d270188de6f8a8c8ee

Thanks!

--nab

