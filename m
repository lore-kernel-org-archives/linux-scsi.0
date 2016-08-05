From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v5 4/8] char: rpmb: provide a user space interface
Date: Fri, 5 Aug 2016 22:08:23 +0200
Message-ID: <20160805200823.GB7999@amd>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56212 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424108AbcHEUI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2016 16:08:26 -0400
Content-Disposition: inline
In-Reply-To: <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon 2016-07-18 23:27:49, Tomas Winkler wrote:
> The user space API is achieved via two synchronous IOCTL.

IOCTLs?

> Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is performed
> by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD where
> the whole RPMB sequence including RESULT_READ is supplied by the caller.
> The latter is intended for  easier adjusting  of the  applications that
> use MMC_IOC_MULTI_CMD ioctl.

Why "  "?

> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

> +
> +static long rpmb_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
> +{
> +	return __rpmb_ioctl(fp, cmd, (void __user *)arg);
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long rpmb_compat_ioctl(struct file *fp, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	return	__rpmb_ioctl(fp, cmd, compat_ptr(arg));
> +}
> +#endif /* CONFIG_COMPAT */

Description of the ioctl is missing, and it should certainly be
designed in a way that it does not need compat support.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
