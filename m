From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 20/20] scsi_error: format abort error message
Date: Sat, 13 Sep 2014 01:07:11 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C77D3B@G9W0745.americas.hpqcorp.net>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-21-git-send-email-hare@suse.de>
 <20140906003305.GA18426@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:7246 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaIMBKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 21:10:24 -0400
In-Reply-To: <20140906003305.GA18426@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Friday, 05 September, 2014 7:33 PM
> Subject: Re: [PATCH 20/20] scsi_error: format abort error message
> 
> On Wed, Sep 03, 2014 at 12:06:15PM +0200, Hannes Reinecke wrote:
...
> > Decode the return value if the command abort failed.
> > @@ -157,8 +157,8 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  		} else {
> >  			SCSI_LOG_ERROR_RECOVERY(3,
> >  				scmd_printk(KERN_INFO, scmd,
> > -					    "scmd %p abort failed, rtn %d\n",
> > -					    scmd, rtn));
> > +					    "scmd %p abort failed, rtn %s\n",
> > +					    scmd, scsi_retval_string(rtn)));
...
> I've not seen an answer to my question in reply to the previous version
> of this.  Why would you do pretty printing of a variable that can just
> return SUCCESS or FAILURE?

Is there anything prohibiting the scsi_eh_abort_handler provided by
the LLD from returning any of the other values like NEEDS_RETRY?

#define NEEDS_RETRY     0x2001
#define SUCCESS         0x2002
#define FAILED          0x2003
#define QUEUED          0x2004
#define SOFT_ERROR      0x2005
#define ADD_TO_MLQUEUE  0x2006
#define TIMEOUT_ERROR   0x2007
#define SCSI_RETURN_NOT_HANDLED   0x2008
#define FAST_IO_FAIL    0x2009

---
Rob Elliott    HP Server Storage



