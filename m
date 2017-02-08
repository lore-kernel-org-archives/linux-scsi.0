From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 03/14] qla2xxx: Allow vref count to timeout on vport
 delete.
Date: Wed, 8 Feb 2017 05:03:15 -0800
Message-ID: <20170208130315.GA22512@infradead.org>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
 <1486161655-2307-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33071 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752811AbdBHNZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 08:25:09 -0500
Content-Disposition: inline
In-Reply-To: <1486161655-2307-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Fri, Feb 03, 2017 at 02:40:44PM -0800, Himanshu Madhani wrote:
> -	spin_lock_irqsave(&ha->vport_slock, flags);
> -	while (atomic_read(&vha->vref_count)) {
> -		spin_unlock_irqrestore(&ha->vport_slock, flags);
> -
> +	while (count-- && atomic_read(&vha->vref_count))
>  		msleep(500);

Please add a wait queue to skeep on while waiting for vref_count to
drop to zero.  
