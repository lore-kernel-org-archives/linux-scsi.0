From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Mon, 06 Feb 2006 16:44:49 -0600
Message-ID: <1139265890.3022.63.camel@mulgrave.il.steeleye.com>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com>
	 <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de>
	 <20060130164954.GA4711@suse.de>  <20060206220434.GA11732@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:58262 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964836AbWBFWo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 17:44:57 -0500
In-Reply-To: <20060206220434.GA11732@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-02-06 at 23:04 +0100, Olaf Hering wrote:
> I need help on this one.
> What I have so far (via git-bisect) is:

My guess would be this patch:


commit
863a930a40eb7f2d18534c2c166b22582f5c6cfd






[SCSI] fix scsi_reap_target() device_del from atomic context

scsi_reap_target() was desgined to be called from any context.
However it must do a device_del() of the target device, which may only
be called from user context.  Thus we have to reimplement
scsi_reap_target() via a workqueue.

James



