From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ->proc_info in host template
Date: Fri, 16 May 2008 11:54:48 -0400
Message-ID: <20080516155448.GA29279@infradead.org>
References: <20080429210154.GA28259@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbYEPPyt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2008 11:54:49 -0400
Content-Disposition: inline
In-Reply-To: <20080429210154.GA28259@martell.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 30, 2008 at 01:01:55AM +0400, Alexey Dobriyan wrote:
> I plan to remove ->read_proc from proc code and this will involve
> ->proc_info hook in host templates. It's marked "OBSOLETE". Is it
> obsoleted as in "will be removed" or obsoleted as in "no new such
> hooks"? Should I convert them to ->proc_fops or just remove?
> I suspect the former, in this case it will look like
> 
> 	#ifdef CONFIG_PROC_FS
> 		const struct file_operations *proc_fops;
> 	#endif
> 
> OK with that?

Back about five years ago when we did a bigger revamp of the scsi layer
we decided that having the unstructed proc files were a bad idea and
planned to remove them eventually.  And then for a long time nothing
happened.  So either we bite the bullet and remove them all or we need
to invest a lot of time into converting them.  In the latter case
I'd prefer to just add a ->show method and limit them to a single page
instead of adding boilerplate for the full file operations all over
the legacy scsi drivers.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
