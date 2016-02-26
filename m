From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: Fix regression when loading firmware
Date: Fri, 26 Feb 2016 13:04:48 -0800
Message-ID: <1456520688.2369.50.camel@HansenPartnership.com>
References: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
	 <56D0BB28.6040502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42702 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbcBZVEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2016 16:04:51 -0500
In-Reply-To: <56D0BB28.6040502@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Insu Yun <wuninsu@gmail.com>

On Fri, 2016-02-26 at 14:52 -0600, Brian King wrote:
> On 02/25/2016 10:54 AM, Gabriel Krisman Bertazi wrote:
> > Commit d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite")
> > removed the
> > end of line handling when storing the update_fw sysfs attribute. 
> >  This
> > changed the userpace API because it started refusing writes
> > terminated
> > by a line feed, which broke the update tools we already have.
> > 
> > This patch re-adds that handling, so both a write terminated by a
> > line
> > feed or not can make it through with the update.
> > 
> > Fixes: d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite")
> > Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> > Cc: Insu Yun <wuninsu@gmail.com>
> > ---
> >  drivers/scsi/ipr.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > index 3b3e099..d6a691e 100644
> > --- a/drivers/scsi/ipr.c
> > +++ b/drivers/scsi/ipr.c
> > @@ -4002,6 +4002,7 @@ static ssize_t ipr_store_update_fw(struct
> > device *dev,
> >  	struct ipr_sglist *sglist;
> >  	char fname[100];
> >  	char *src;
> > +	char *endline;
> >  	int result, dnld_size;
> > 
> >  	if (!capable(CAP_SYS_ADMIN))
> > @@ -4009,6 +4010,10 @@ static ssize_t ipr_store_update_fw(struct
> > device *dev,
> > 
> >  	snprintf(fname, sizeof(fname), "%s", buf);
> > 
> > +	endline = strchr(fname, '\n');
> > +	if (endline)
> > +		*endline = '\0';
> > +
> >  	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev
> > ->dev)) {
> >  		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not
> > found\n", fname);
> >  		return -EIO;
> > 
> 
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> 
> James - since this is a regression, can we get this fix in for 4.5 
> yet?

Yes, but in future, could you actually check patches in your driver
before they get sent to Linus?  This one went via the usual merge
window process, so there was plenty of time to test it. We get a lot of
these apparently innocuous minor bug fixes that actually contain a much
more subtle bug.  They're very difficult for reviewers to spot, but
they do show up on hardware testing.

James
 

