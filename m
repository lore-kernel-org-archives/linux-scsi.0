From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/6] qla4xxx: Add change_queue_depth API support
Date: Fri, 27 Apr 2012 10:43:15 -0500
Message-ID: <4F9ABE93.2060606@cs.wisc.edu>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com> <1335245557-17169-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49697 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760653Ab2D0Pn0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 11:43:26 -0400
In-Reply-To: <1335245557-17169-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
>  
> +static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
> +				      int reason)
> +{
> +	int queue_depth;
> +	if (!ql4xqfulltracking)
> +		return -EOPNOTSUPP;
> +
> +	queue_depth = iscsi_change_queue_depth(sdev, qdepth, reason);
> +	return queue_depth;
> +}
> +

No need for queue_depth. Just do

return iscsi_change_queue_depth(sdev, qdepth, reason);
