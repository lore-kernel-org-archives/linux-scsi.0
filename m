From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: fix potential NULL pointer dereference.
Date: Tue, 25 Mar 2014 14:30:46 +0100
Message-ID: <20140325133046.GD2416@dhcp-27-189.brq.redhat.com>
References: <1395752333-12185-1-git-send-email-mlombard@redhat.com>
 <20140325131306.GA25392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaCYNb6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2014 09:31:58 -0400
Content-Disposition: inline
In-Reply-To: <20140325131306.GA25392@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, m.lombardi85@gmail.com

On Tue, Mar 25, 2014 at 06:13:06AM -0700, Christoph Hellwig wrote:
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 78b004d..4021849 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -2289,6 +2289,9 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
> >  		return FAILED;
> >  
> >  	scmd = scsi_get_command(dev, GFP_KERNEL);
> > +	if (!scmd)
> > +		return FAILED;
> > +
> 
> Fails to call scsi_autopm_put_host, or in Jame's latest tree that has
> my changes put_device on the sdev gendev.  I sent a correct version
> earlier, but there has been very little enthusiasm for it.
>

Yes you are right, it should call scsi_autopm_put_host before returning.
So if you already have a correct version for it then I drop this patch.

Maurizio.
 
