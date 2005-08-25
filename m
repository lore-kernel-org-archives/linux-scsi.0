From: Christoph Hellwig <hch@infradead.org>
Subject: Re: qla2xxx: does not respond to SCSI_IOCTL_PROBE_HOST
Date: Thu, 25 Aug 2005 17:09:02 +0100
Message-ID: <20050825160902.GA17366@infradead.org>
References: <1124915655.13251.16.camel@localhost> <20050824211348.GH8205@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15576 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932249AbVHYQJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 12:09:05 -0400
Content-Disposition: inline
In-Reply-To: <20050824211348.GH8205@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Drew Winstel <raw@dslr.net>, linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 02:13:48PM -0700, Andrew Vasquez wrote:
> /proc support has been stripped from the qla2xxx driver.  So,
> hostt->present is never incremented:
> 
> 	void scsi_proc_hostdir_add(struct scsi_host_template *sht)
> 	{
> 		if (!sht->proc_info)
> 			return;
> 
> 		down(&global_host_template_sem);
> 		if (!sht->present++) {
> 			...
> 
> SCSI_IOCTL_PROBE_HOST returns hostt->present:
> 
> 	static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
> 	{
> 		unsigned int len, slen;
> 		const char *string;
> 		int temp = host->hostt->present;
> 
> 		...
> 		return temp;
> 
> Not sure how we want to fix it, perhaps for backwards compatibility,
> increment present regardless of the value of proc_info.
> 
> Something like this, perhaps (untested)?

No, please not.  Just remove the ->present check in the ioctl, with
the hotplug mode in place we should consider an host always probed
for this legacy.

And while we're at it we should add deprecation warnings for most of
the crufy ioctls in scsi_ioctl.c..

