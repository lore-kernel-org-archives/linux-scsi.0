From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 13:51:44 -0600
Message-ID: <20060924195144.GD2595@parisc-linux.org>
References: <20060924190623.GB2595@parisc-linux.org> <20060924194345.GC4094@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39832 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1750782AbWIXTvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 15:51:45 -0400
Content-Disposition: inline
In-Reply-To: <20060924194345.GC4094@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Sep 24, 2006 at 03:43:45PM -0400, Dave Jones wrote:
> On Sun, Sep 24, 2006 at 01:06:24PM -0600, Matthew Wilcox wrote:
>  > +
>  > +int scsi_complete_async_scans(void)
>  > +{
>  > +	struct async_scan_data *data;
>  > +
>  > +	do {
>  > +		if (list_empty(&scanning_hosts))
>  > +			return 0;
>  > +		data = kmalloc(sizeof(*data), GFP_KERNEL);
>  > +		if (!data)
>  > +			msleep(1);
>  > +	} while (!data);
> 
> does __GFP_NOFAIL or __GFP_REPEAT have the desired effect here? 

Well ... that would probably be OK.  But I think it's actually preferable
to not use it.  See, the scan might finish while we're waiting for
memory, and if it does, then we don't need to allocate memory after all.
This is totally quibbling over the most unlikely of scenarios though,
so I have no problem with making the change if we just want to exemplify
best practice here.

