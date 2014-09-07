From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/20] scsi: remove scsi_show_result()
Date: Sun, 7 Sep 2014 09:17:36 -0700
Message-ID: <20140907161736.GD16238@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaIGQRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:17:38 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:13PM +0200, Hannes Reinecke wrote:
> scsi_show_result() was only ever used in one place in sd.c.
> So open-code scsi_show_result() in sd.c and remove it from
> constants.c.

This does a lot more refactoring in sd.c, which needs a proper
explanation and probably splitting into a separate patch.

I also think we're much better having a different prototype
for scsi_print_result and use it here, similar to your
sdev_prefix_printk:

void scsi_print_result(struct scsi_device *sdev, const char *prefix)
{
	...
}
