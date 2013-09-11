From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 8/9] fnic: Fnic Statistics Collection
Date: Wed, 11 Sep 2013 16:11:25 -0700
Message-ID: <1378941085.4061.49.camel@dabdike.int.hansenpartnership.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
	 <1378758713-22443-8-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51351 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757288Ab3IKXLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 19:11:32 -0400
In-Reply-To: <1378758713-22443-8-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2013-09-09 at 13:31 -0700, Hiral Patel wrote:
> This feature gathers active and cumulative per fnic stats for io,
> abort, terminate, reset, vlan discovery path and it also includes
> various important stats for debugging issues. It also provided
> debugfs and ioctl interface for user to retrieve these stats.
> It also provides functionality to reset cumulative stats through
> user interface.

Checkpatch has quite a bit to say about this, but in particular it
doesn't like the instances of 

> +	if (fnic_stats_debugfs_root) {
> +		debugfs_remove(fnic_stats_debugfs_root);

Because debugfs_remove() can be called on a NULL pointer

and

> +	ret = strict_strtoul(buf, 10, &val);
> +	if (ret < 0)
> +		return ret;

Because this should be using kstrtoul(); we're trying to obsolete
strict_strtoul.

Please fix.

Thanks,

James


