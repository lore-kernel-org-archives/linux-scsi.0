From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] mptfusion: combine fw_event_work and its event_data
Date: Thu, 5 Jun 2014 02:34:29 -0700
Message-ID: <20140605093429.GG727@infradead.org>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
 <1401900729-19855-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEJea (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:34:30 -0400
Content-Disposition: inline
In-Reply-To: <1401900729-19855-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

>  
> -	sz = offsetof(struct fw_event_work, event_data) +
> -	    sizeof(MpiEventDataSasDeviceStatusChange_t);
> +	sz = sizeof(*fw_event) +
> +		sizeof(MpiEventDataSasDeviceStatusChange_t);
>  	fw_event = kzalloc(sz, GFP_ATOMIC);

Seems like there is no point in keeping the sz variable here and at
the other occurances.  Not that it really matters, but if we make a pass
over this code we might as well fix that up, too.

> -	sz = offsetof(struct fw_event_work, event_data);
> +	sz = sizeof(*fw_event);

Eww, using offsetoff for an allocation size.  Good riddance that this
gets sorted out.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
