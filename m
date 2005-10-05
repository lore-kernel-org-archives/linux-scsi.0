From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 5 Oct 2005 16:19:12 -0700 (PDT)
Message-ID: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com>
References: <43442AE3.6030000@pobox.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:8362 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030432AbVJEXTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 19:19:15 -0400
In-Reply-To: <43442AE3.6030000@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

--- Jeff Garzik <jgarzik@pobox.com> wrote:
> scans as well as no-LUN targets.  My vague preference would be to use 
> scsi_scan_target() unless there is a strong reason not to...

This sounds good too.

I'd like to move sas_do_lu_discovery(struct domain_device *dev)
into SCSI Core (as the comment therein says), for _new_ (non-legacy)
devices, i.e. with newer FW.

It also handles devices who do not even respond
to REPORT LUNS on either LU 0 or RL WLUN (like early prototype
SES FW), in which case it would register LU 0 for them since
this is where tasks are sent.

Example of those is seen in the domain sysfs tree here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2

The code is at drivers/scsi/sas/sas_discover.c
http://linux.adaptec.com/sas/ .

     Luben
P.S. REPORT LUNS is Mandatory as per SPC, so newer devices
(SAS) support it.  Furthermore if their LUs are sparse they
(really) support REPORT LUNS.

