From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Thu, 21 Feb 2013 16:32:10 +0000
Message-ID: <1361464328.2389.65.camel@dabdike.int.hansenpartnership.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
	 <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:53231 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3BUQcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2013 11:32:18 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-ID: <9F32DB537EC6554DA72A76E6E9B3CFA0@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>

On Thu, 2013-02-21 at 16:15 +0000, Elliott, Robert (Server Storage)
wrote:
> Regarding changes like this:
> -			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
> +			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%llu] "
>  			"FCP_ResponseInfo=%08xh\n", ioc->name,
>  			sc->device->host->host_no, sc->device->channel,
>  			sc->device->id, sc->device->lun,
> 
> It might be preferable to print the LUN values in hex rather than
> decimal, particularly if they are large values.  SAM-5 includes some
> guidance for displaying LUNs, shown below. 

We can't really change from decimal to hex without causing confusion and
possibly breaking ABIs.  All the existing SCSI references look like
h:c:t:l and all expect l to be a simple decimal.  It's not just in the
logs, we have active use of this form in all the /sys/class/scsi_*/
directories and some tools may parse this value.

> One important goal is to match the format, if any, that the user must
> use in a configuration file or command line argument, so
> cutting-and-pasting the LUN value works.  So, the answer might differ
> for prints from different drivers.  If a driver expects decimal input
> values, then print decimal.
> 
> SAM-5 excerpt:
> 4.7.2 Logical unit representation format
[...]

We're a bit bound by kernel convention here as well.  To retain
compatibility with SPI and flat addressing schemes, we really need to
show the 8 and 16 bit flat addresses as simple decimal numerics.
However, we *might* be free to move to a more hierarchical scheme with
the multi-level luns, since I don't think there's to many people who've
got arrays that output them (yet).

James

