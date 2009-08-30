From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Sun, 30 Aug 2009 09:35:02 -0500
Message-ID: <1251642902.10135.4.camel@mulgrave.site>
References: <4A92BE18.50208@gmail.com>
	 <1251416731.27356.8.camel@mulgrave.site>  <4A9A6676.8050304@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbZH3OfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Aug 2009 10:35:07 -0400
In-Reply-To: <4A9A6676.8050304@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Sun, 2009-08-30 at 14:45 +0300, Boaz Harrosh wrote:
> On 08/28/2009 02:45 AM, James Bottomley wrote:
> > On Mon, 2009-08-24 at 18:21 +0200, Roel Kluin wrote:
> >> kmalloc() may fail, so test whether it succeeded.
> >>
> >> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >> ---
> >> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> >> index 2de5f3a..34fdde0 100644
> >> --- a/drivers/scsi/scsi.c
> >> +++ b/drivers/scsi/scsi.c
> >> @@ -1056,6 +1056,9 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
> >>  
> >>  	kfree(buf);
> >>  	buf = kmalloc(len + 4, GFP_KERNEL);
> >> +	if (!buf)
> >> +		return NULL;
> >> +
> > 
> > Firstly, this won't actually apply ... you should be developing against
> > either the SCSI trees or linux-next to get the latest versions in git.
> > 
> > Secondly it's not really right for the most common use cases, which
> > don't usually want the whole vpd buffer anyway.  I don't really see a
> > simple way of fixing it without altering the interface, though.
> > 
> 
> "most common use cases" do not have pages bigger then 255. Can you think
> of any? For these few places that anticipate pages bigger then 255 I don't
> see much choice, we just freed 255 bytes and tried a new size, say 317, which
> failed with GFP_KERNEL, In such a busy system, better fail with NULL then BUG,
> No? In any way caller must check for NULL because of the first allocation.

Other way around: common use cases means the callers.  What I'm saying
is that regardless of the size of the VPD page, the caller usually only
wants a few bytes into it.  Once we have all the information the caller
ever needs, there's no point in trying again with a larger buffer just
because the VPD page is larger ... to code this into the interface,
though, the caller would need to specify the max length it is looking
for.

James


