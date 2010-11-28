From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/
	interrupts disabled internally
Date: Sat, 27 Nov 2010 23:28:59 -0800
Message-ID: <1290929339.6216.188.camel@haakon2.linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40213 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0K1Hec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Nov 2010 02:34:32 -0500
In-Reply-To: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>

On Sat, 2010-11-27 at 23:17 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings Hannes, Bo and Co,
> 
> This series converts megaraid_sas to run in modern host_lock-less mode
> for >= .37-rc3+ with interrupts disabled internally around megasas_instance->hba_lock.
> This series is currently living in lio-core-2.6.git/lock_less-LLDs-for-38-v2,
> and is intended for .38 mainline code.
> 
> The first patch adds a handful of missing barriers around instance->fw_outstanding
> usage w/ atomic_add() and atomic_dec().
> 
> The second converts instance->issuepend_done to an atomic_t, along with
> the necessary assignments in order to run w/ Scsi_Host->host_lock, and
> without instance->hba_lock.
> 
> The third patch does the actual conversion, and adds a __megasas_get_cmd()
> usased by megasas_queue_command() w/ instance->hba_lock, along with
> being held for megasas_build_ldio() and megasas_build_dcdb() in order
> to locate the proper frame for struct megasas_cmd.  This is really the
> one major change in order to get host_lock-less to function with interrupts
> disabled around hba_lock.
> 
> So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation with
> TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .37-rc3
> environment.  This has not been tested on real silicon yet, but I believe
> this series should be working there as well.
> 

And quick screenshot running in KVM Host TCM_Loop host_lock-less mode
into KVM Guest megaraid_sas host_lock-less mode w/ small block LTP
disktest.

http://www.linux-iscsi.org/index.php/File:TCM_loop-megasas-37-rc3.png

Just a FYI, with scsi-generic <-> TCM_Loop everything appears to be
stable for both small and large block size tests.

--nab



