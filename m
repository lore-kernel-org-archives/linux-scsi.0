From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8]  qla4xxx: new driver -- request for review.
Date: Tue, 06 Sep 2005 17:26:42 -0500
Message-ID: <431E17A2.6040208@cs.wisc.edu>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36569 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751056AbVIFW2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:28:52 -0400
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> All,
> 
> Here's a first-pass run for submission-review of the qla4xxx driver for
> QLogic's ISP4010 and ISP4022 products.
> 
> The patchset breaks-down as follows:
> 
> o Driver definitions
> o initialisation routines
> o OS integration files
> o iSNS routines
> o ISR routines
> o Mailbox routines
> o Support routines
> o Settings
> 
> There's still quite a bit of work to do:
> 
> - All command-queueing has been removed, so cable-pulls cannot be
>   tolerated.  We need to complete the iSCSI transport integration
>   (which seems to no be present).
> 
>   Are the iSCSI block()/unblock() routines moving forward similarly to
>   FC and now SAS?  Mike Christie had submitted patches:
> 
> 	[PATCH] add block/unblock to iscsi class
> 	http://marc.theaimsgroup.com/?l=linux-scsi&m=111201856631844&w=2
> 
>   some time back.  Why were the patches dropped?
> 

The class we have today in mainline and that patch was for the 
iscsi_sfnet driver. The open-iscsi driver in James's iscsi tree has a 
updated class. It is geared twords open-iscsi's design and so it has 
some things that may not work so well for qla4xxx off the bat due to 
what could live in userspace for us and what you do in firmware and 
where the scsi_host is allocated etc.
