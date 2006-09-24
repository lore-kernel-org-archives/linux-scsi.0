From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 15:43:45 -0400
Message-ID: <20060924194345.GC4094@redhat.com>
References: <20060924190623.GB2595@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:6605 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750770AbWIXTnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 15:43:49 -0400
Content-Disposition: inline
In-Reply-To: <20060924190623.GB2595@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, Sep 24, 2006 at 01:06:24PM -0600, Matthew Wilcox wrote:
 > +
 > +int scsi_complete_async_scans(void)
 > +{
 > +	struct async_scan_data *data;
 > +
 > +	do {
 > +		if (list_empty(&scanning_hosts))
 > +			return 0;
 > +		data = kmalloc(sizeof(*data), GFP_KERNEL);
 > +		if (!data)
 > +			msleep(1);
 > +	} while (!data);

does __GFP_NOFAIL or __GFP_REPEAT have the desired effect here? 

	Dave

