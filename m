From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Tue, 16 Mar 2010 14:04:55 +0100
Message-ID: <20100316130454.GA15772@schmichrtp.mainz.de.ibm.com>
References: <20100309091848.4C7412BD8B@ochil.suse.de>
 <4B9657CD.6000805@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:42560 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0CPNE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 09:04:57 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o2GD4tNH000320
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 13:04:55 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2GD4tKn868438
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 13:04:55 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2GD4tjs015344
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 13:04:55 GMT
Content-Disposition: inline
In-Reply-To: <4B9657CD.6000805@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Mar 09, 2010 at 09:14:37AM -0500, James Smart wrote:
> I don't ever expect to see large dev_loss_tmo values, but the patch is fine.
> 
> Acked-by: James Smart <james.smart@emulex.com>
> 
> -- james s
> 
> 
> Hannes Reinecke wrote:
> >The rport structure defines dev_loss_tmo as u32, which is
> >later multiplied with HZ to get the actual timeout value.
> >This might overflow for large dev_loss_tmo values. So we
> >should be better using u64 as intermediate variables here
> >to protect against overflow.
> >
> >Signed-off-by: Hannes Reinecke <hare@suse.de>
[...]

I guess this is the intended use to prevent the dev_loss_tmo from
removing the SCSI devices:
http://git.kernel.org/?p=linux/kernel/git/hare/multipath-tools.git;a=commitdiff;h=b9903e2e8a6cdc5042897719fbae6c9346820bbf;hp=ed1dc6164fe530d146cfe65d4f99e44ec9b54b95

But does this raise the question again how to run SCSI EH with remote
port failures?

The SCSI FC LLDs call fc_block_scsi_eh to wait until the fc_rport
leaves the state FC_PORTSTATE_BLOCKED. This effectively prevents SCSI
devices from being taken offline when there is a command timeout and
the fc_rport is BLOCKED. With the large dev_loss_tmo, the dev_loss_tmo
never expires and a problem with a single remote port can block the
host error handler.

--
Christof
