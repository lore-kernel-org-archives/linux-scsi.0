From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv3] Update scsi host to use ida for host number
Date: Tue, 1 Sep 2015 23:48:30 -0700
Message-ID: <20150902064830.GA17978@infradead.org>
References: <1441152208-20634-1-git-send-email-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbIBGsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2015 02:48:30 -0400
Content-Disposition: inline
In-Reply-To: <1441152208-20634-1-git-send-email-lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, hare@suse.com, jthumshirn@suse.de

On Tue, Sep 01, 2015 at 05:03:28PM -0700, Lee Duncan wrote:
> +static int host_get_index(int *index)
> +{
> +	int error = -ENOMEM;
> +
> +	do {
> +		if (!ida_pre_get(&host_index_ida, GFP_KERNEL))
> +			break;
> +		spin_lock(&host_index_lock);
> +		error = ida_get_new(&host_index_ida, index);
> +		spin_unlock(&host_index_lock);
> +	} while (error == -EAGAIN);
> +
> +	return error;
> +}
> +
> +static inline void host_put_index(int index)
> +{
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, index);
> +	spin_unlock(&host_index_lock);
> +}

I really hate how this pattern (and the equivalent for IDA) are
spread all over.  Any chance to have some simple_ida/simple_idr helpers
instead of duplicating it again an again.

Besides that why aren't we using and idr here and use it for host lookup
as well?
