From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] b2iscsi: Fix memory leak in mgmt_set_ip()
Date: Tue, 1 Jul 2014 20:53:33 +0200
Message-ID: <20140701185333.GA7225@infradead.org>
References: <1403873720-9642-1-git-send-email-mlombard@redhat.com>
 <53AD9C8A.7010007@redhat.com>
 <53ADC822.1040508@redhat.com>
 <53B05AD2.7050200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbaGASvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 14:51:19 -0400
Content-Disposition: inline
In-Reply-To: <53B05AD2.7050200@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hch@infradead.org, JBottomley@parallels.com

On Sun, Jun 29, 2014 at 08:28:34PM +0200, Tomas Henzl wrote:
> On 06/27/2014 09:38 PM, Maurizio Lombardi wrote:
> >
> >>> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> >>> index 07934b0..a3e5648 100644
> >>> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> >>> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> >>> @@ -1015,7 +1015,7 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
> >>>  		if (if_info->dhcp_state) {
> >>>  			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
> >>>  				    "BG_%d : DHCP Already Enabled\n");
> >>> -			return 0;
> >>> +			goto exit;
> >> rc should be initialised - so this needs to be added to your patch
> > It is initialized at the beginning of the function, and it must contain zero when the "goto exit" is executed.
> 
> Correct, I haven't noticed the initialisation, sorry for the confusion.

Is this a formal review from you?

