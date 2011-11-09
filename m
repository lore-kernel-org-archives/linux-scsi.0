From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Wed, 09 Nov 2011 19:54:21 +0100
Message-ID: <4EBACC5D.7000904@kernel.dk>
References: <20111109162512.GB1260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1KISye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2011 13:54:34 -0500
In-Reply-To: <20111109162512.GB1260@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 2011-11-09 17:25, Tejun Heo wrote:
> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
> 
> The commit introduced alias for block devices which is intended to be
> used during logging although actual usage hasn't been committed yet.
> This approach adds very limited benefit (raw log might be easier to
> follow) which can be trivially implemented in userland but has a lot
> of problems.
> 
> It is much worse than netif renames because it doesn't rename the
> actual device but just adds conveninence name which isn't used
> universally or enforced.  Everything internal including device lookup
> and sysfs still uses the internal name and nothing prevents two
> devices from using conflicting alias - ie. sda can have sdb as its
> alias.
> 
> This has been nacked by people working on device driver core, block
> layer and kernel-userland interface and shouldn't have been
> upstreamed.  Revert it.
> 
>  http://thread.gmane.org/gmane.linux.kernel/1155104
>  http://thread.gmane.org/gmane.linux.scsi/68632
>  http://thread.gmane.org/gmane.linux.scsi/69776

Ack on this, it seems both unneeded, unused, and a bad hack. We need to
revert it before 3.2 rolls out, otherwise we are stuck with it.

-- 
Jens Axboe

