From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 08/13] scsi: move request preps in other places into prep_fn()
Date: Fri, 1 Apr 2005 14:20:35 +0900
Message-ID: <20050401052035.GF11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.94FFEC1E@htj.dyndns.org> <20050331102040.GD13842@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.199]:58671 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262633AbVDAFUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:20:43 -0500
Received: by wproxy.gmail.com with SMTP id 68so796696wra
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:20:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20050331102040.GD13842@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Christoph.

On Thu, Mar 31, 2005 at 11:20:40AM +0100, Christoph Hellwig wrote:
> > +/*
> > + * Macro to determine the size of SCSI command. This macro takes vendor
> > + * unique commands into account. SCSI commands in groups 6 and 7 are
> > + * vendor unique and we will depend upon the command length being
> > + * supplied correctly in cmd_len.
> > + */
> > +#define CDB_SIZE(cmd)	(((((cmd)->cmnd[0] >> 5) & 7) < 6) ? \
> > +				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
> 
> should probably go to scsi.h as it's generally usefull.

 I don't know.  Currently it's used only in one place.  Actually, I
was thinking about moving it into the function where it's used.  But
if it's useful, renaming it to something like SCSI_CMD_CDB_SIZE()
(maybe make it inline function?) and moving to scsi.h shouldn't be any
problem.  I think we need to hear other people's opinions.  Some
inputs please.

 Thanks.

-- 
tejun

