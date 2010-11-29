From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] megaraid_sas: Convert to host_lock less
	w/	interrupts disabled internally
Date: Mon, 29 Nov 2010 13:07:19 -0800
Message-ID: <1291064839.17194.16.camel@haakon2.linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
	 <1290929339.6216.188.camel@haakon2.linux-iscsi.org>
	 <4CF3CD22.2050504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48623 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0K2VMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 16:12:54 -0500
In-Reply-To: <4CF3CD22.2050504@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo Yang <Bo.Yang@lsi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, Kevin Wolf <kwolf@redhat.com>

On Mon, 2010-11-29 at 16:56 +0100, Hannes Reinecke wrote:
> On 11/28/2010 08:28 AM, Nicholas A. Bellinger wrote:
> > On Sat, 2010-11-27 at 23:17 -0800, Nicholas A. Bellinger wrote:
> >> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>
> >> Greetings Hannes, Bo and Co,
> >>
> >> This series converts megaraid_sas to run in modern host_lock-less mode
> >> for >= .37-rc3+ with interrupts disabled internally around megasas_instance->hba_lock.
> >> This series is currently living in lio-core-2.6.git/lock_less-LLDs-for-38-v2,
> >> and is intended for .38 mainline code.
> >>
> >> The first patch adds a handful of missing barriers around instance->fw_outstanding
> >> usage w/ atomic_add() and atomic_dec().
> >>
> >> The second converts instance->issuepend_done to an atomic_t, along with
> >> the necessary assignments in order to run w/ Scsi_Host->host_lock, and
> >> without instance->hba_lock.
> >>
> >> The third patch does the actual conversion, and adds a __megasas_get_cmd()
> >> usased by megasas_queue_command() w/ instance->hba_lock, along with
> >> being held for megasas_build_ldio() and megasas_build_dcdb() in order
> >> to locate the proper frame for struct megasas_cmd.  This is really the
> >> one major change in order to get host_lock-less to function with interrupts
> >> disabled around hba_lock.
> >>
> >> So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation with
> >> TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .37-rc3
> >> environment.  This has not been tested on real silicon yet, but I believe
> >> this series should be working there as well.
> >>
> > 
> > And quick screenshot running in KVM Host TCM_Loop host_lock-less mode
> > into KVM Guest megaraid_sas host_lock-less mode w/ small block LTP
> > disktest.
> > 
> > http://www.linux-iscsi.org/index.php/File:TCM_loop-megasas-37-rc3.png
> > 
> > Just a FYI, with scsi-generic <-> TCM_Loop everything appears to be
> > stable for both small and large block size tests.
> > 
> Oh, good. I did some initial tests with megaraid_sas & host_lock
> disabled, but ran into the problems you mentioned.
> And have been too lazy to pursue this problem further.
> Thanks for your work; I'll give it a spin and see if the throughput
> speed has increased.
> 
> Thanks for the patches.
> 

Aside from the extra __megasas_get_cmd() breakage, the conversion was
really quite straight-forward..  ;)

> Btw, I've found one issue wrt Windows7 booting; now we're not
> crashing anymore. But we're not exactly progressing, either;
> apparently Win7 fails to notify that we've finished the commands.
> Continue debugging.
> 

Ok, then we probably will need to verify that our v0.12.5-megasas in the
following qemu-kvm.git branch is still working as expected w/ your Win7
build:

windows7-megasas-working dde5ee2 [scsi-bus]: Add MAINTENANCE_IN and \
	MAINTENANCE_OUT case for SCSIRequest xfer and xfer_mode setup

Just for reference, this is back with the hardcoded defs for fw_sge and
fw_cmds:

/* Static definitions */
#define MEGASAS_MAX_FRAMES 1000
#define MEGASAS_MAX_SGE 8
#define MEGASAS_MAX_LUNS 128

Perhaps the larger default fw_sge in recent megasas emulation code is
causing an issue here..?

--nab

