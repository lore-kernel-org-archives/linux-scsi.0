From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected
 device support
Date: Wed, 08 Apr 2015 00:40:28 -0700
Message-ID: <1428478828.18203.109.camel@haakon3.risingtidesystems.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-3-git-send-email-nab@daterainc.com>
	 <yq1sicbh63q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53488 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbDHHka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 03:40:30 -0400
In-Reply-To: <yq1sicbh63q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>

On Tue, 2015-04-07 at 19:27 -0400, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> nab> This specifically is to allow LIO to perform WRITE_STRIP +
> nab> READ_INSERT operations when functioning with non T10-PI enabled
> nab> devices, seperate from any available hw offloads the fabric
> nab> supports.
> 
> How do you handle RDPROTECT/WRPROTECT values of 3 if the PI is not
> persistent?
> 

AFAICT, this would result in cmd->prot_op = TARGET_PROT_*_PASS and
cmd->prot_checks = 0 for RDPROTECT/WRPROTECT == 0x3 in
sbc_set_prot_op_checks() code.

Do DOUT_STRIP + DIN_INSERT need to be called if a protection buffer is
present when RDPROTECT/WRPROTECT == 0x3 if fabric_prot was cleared..?  
Or should the command be rejected when a protection buffer is present +
RDPROTECT/WRPROTECT is non-zero if fabric_prot was cleared..?

Also wrt to PI persistence across session restart, one way it can work
is to store the last se_sess->sess_prot_type in se_node_acl, and
reinstate the previous setting across session restart.  This would allow
new sessions to pickup the latest fabric_prot_type endpoint attribute
value, but make existing ones with PI enabled keep their previous
sess_prot_type settings.

WDYT..? 

--nab

