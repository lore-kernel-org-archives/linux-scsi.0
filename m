From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: ->proc_info in host template
Date: Fri, 16 May 2008 23:25:52 +0400
Message-ID: <20080516192552.GA5287@martell.zuzino.mipt.ru>
References: <20080429210154.GA28259@martell.zuzino.mipt.ru> <20080516155448.GA29279@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:3932 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYEPSaW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2008 14:30:22 -0400
Received: by gv-out-0910.google.com with SMTP id e6so177134gvc.37
        for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 11:30:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080516155448.GA29279@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Fri, May 16, 2008 at 11:54:48AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 30, 2008 at 01:01:55AM +0400, Alexey Dobriyan wrote:
> > I plan to remove ->read_proc from proc code and this will involve
> > ->proc_info hook in host templates. It's marked "OBSOLETE". Is it
> > obsoleted as in "will be removed" or obsoleted as in "no new such
> > hooks"? Should I convert them to ->proc_fops or just remove?
> > I suspect the former, in this case it will look like
> > 
> > 	#ifdef CONFIG_PROC_FS
> > 		const struct file_operations *proc_fops;
> > 	#endif
> > 
> > OK with that?
> 
> Back about five years ago when we did a bigger revamp of the scsi layer
> we decided that having the unstructed proc files were a bad idea and
> planned to remove them eventually.  And then for a long time nothing
> happened.  So either we bite the bullet and remove them all or we need
> to invest a lot of time into converting them.  In the latter case
> I'd prefer to just add a ->show method and limit them to a single page
> instead of adding boilerplate for the full file operations all over
> the legacy scsi drivers.

Some drivers allow writing to them so just ->show is not sufficient.
See ppa_proc_show() for example. Probably add ->write .

Boilerplate is tiny. Also, some crap like asc_proc_copy() will go away.

OTOH, some drivers are PITA to convert. I tried advansys out of
curiosity and failed several times.

