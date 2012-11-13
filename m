From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 17/19] be2iscsi: Fix for MBX timeout issue
Date: Tue, 13 Nov 2012 15:34:26 -0600
Message-ID: <1352842466.8317.3.camel@dabdike>
References: <fc49c9f1-3026-472d-9dfb-bf256bc95627@CMEXHTCAS1.ad.emulex.com>
	 <50878E90.1000800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55952 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab2KNHCb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2012 02:02:31 -0500
In-Reply-To: <50878E90.1000800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: John Soni Jose <sony.john-n@Emulex.Com>, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>, Andy Whitcroft <apw@canonical.com>

On Wed, 2012-10-24 at 01:45 -0500, Mike Christie wrote:
> On 10/19/2012 06:15 PM, John Soni Jose wrote:
> > @@ -763,26 +750,14 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
> >  			    "BS_%d : Getting Port Speed Failed\n");
> >  
> >  		 return -EBUSY;
> > -	 } else
> > -		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
> > -				phba->ctrl.mcc_numtag[tag]);
> > -
> > -	wrb_num = (phba->ctrl.mcc_numtag[tag] & 0x00FF0000) >> 16;
> > -	extd_status = (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
> > -	status = phba->ctrl.mcc_numtag[tag] & 0x000000FF;
> > -
> > -	if (status || extd_status) {
> > +	 }
> > +	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
> > +	if (rc) {
> >  		beiscsi_log(phba, KERN_ERR,
> 
> There was some small whitespace issues in this patch. Maybe James will
> fix it up when it is merged. I do not know why checkpatch.pl and git did
> not warn about them.

I fixed it up.  I cc'd the checkpatch.pl maintainer.  No idea why it
failed to spot the extra space at line 465 in the patch.

James


