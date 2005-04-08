From: Christoph Hellwig <hch@infradead.org>
Subject: Re: proc_name in sysfs
Date: Fri, 8 Apr 2005 07:46:45 +0100
Message-ID: <20050408064645.GA4860@infradead.org>
References: <4253CA94.8000500@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43956 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262705AbVDHGqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 02:46:48 -0400
Content-Disposition: inline
In-Reply-To: <4253CA94.8000500@bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:
> Hello,
> 
> 
> We are using HBAs modules names from "proc_name" interface in sysfs:
> /sys/class/scsi_host/hostX/proc_name.
> 
> But with new Emulex drivers (8.0.21 and +), proc_name is reporting <NULL> 
> (previous drivers were reporting "lpfc").
> => In the driver code, .proc_name field from scsi_host_template structure 
> is no more initialized.
> James Smart told us that the "removal" of .proc_name field (not really 
> removed, but no more initialized) was part of the /proc interfaces removal 
> (suggested by scsi-linux feedback).
> 
> So:
> 1/ now, what is the aim of proc_name interface (reporting "<NULL>") in 
> sysfs ?
> 2/ now, how can we get the adapter module name from sysfs ?
> 
> => I'm just thinking that .proc_name field has to be kept initialized 
> and/or something has to be changed to replace the confusing "proc" prefix.

The real problem is that someone decided to export the proc_name in sysfs.
It's supposed to be only procfs-specific but someone violated that rule.

Not sure how to proceed forward with this.
