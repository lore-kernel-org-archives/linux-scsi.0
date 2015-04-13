From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/2] mpt2sas,mpt3sas - PCI master abort fixups
Date: Sun, 12 Apr 2015 20:11:04 -0400
Message-ID: <552B0998.1050808@stratus.com>
References: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o143.mxlogic.net ([208.65.145.76]:55269 "EHLO
	p02c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbbDMALz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2015 20:11:55 -0400
In-Reply-To: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>

On 12/30/2014 09:07 AM, Joe Lawrence wrote:
> A colleague noticed that the mpt2 and mpt3sas drivers do not correctly
> check the PCI master abort pattern in _base_wait_for_doorbell_ack.  This
> pattern should be checked *prior* to any valid bit patterns, which would
> always return true since a PCI read on master abort sets all bits high.
> 
> The second patch adds similar checking to _base_wait_for_doorbell_int and
> _base_wait_for_doorbell_not_used to avoid potentially long loops around
> PCI reads.
> 
> Joe Lawrence (2):
>   mpt2sas,mpt3sas: correct master-abort checking in doorbell ack
>   mpt2sas,mpt3sas: additional master abort checks
> 
>  drivers/scsi/mpt2sas/mpt2sas_base.c |   17 ++++++++++++-----
>  drivers/scsi/mpt3sas/mpt3sas_base.c |   17 ++++++++++++-----
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 

Avago ping?

This one was pretty straightforward: check 0xFFFFFFFF *before* any
individual bit(s), i.e. before reading the doorbell register.

-- Joe
