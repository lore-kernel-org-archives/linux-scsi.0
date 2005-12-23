From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 14:53:39 -0600
Message-ID: <1135371219.3728.50.camel@mulgrave>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	 <20051222221329.5f317b8d.akpm@osdl.org>
	 <20051223234338.798294f9.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47040 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161050AbVLWUxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:53:44 -0500
In-Reply-To: <20051223234338.798294f9.vsu@altlinux.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 23:43 +0300, Sergey Vlasov wrote:
> So if that GFP_ATOMIC allocation ever fails, the target is leaked
> forever - does not look nice.

Yes, but it will print a warning.

> Does anything depend on starget->siblings being empty after we had
> removed it from the shost->__targets list it was on?  Seems that all
> other uses of this field are:
>
> drivers/scsi/scsi_scan.c:313:   list_for_each_entry(starget, &shost->__targets, siblings) {
> drivers/scsi/scsi_scan.c:365:   INIT_LIST_HEAD(&starget->siblings);
> drivers/scsi/scsi_scan.c:373:   list_add_tail(&starget->siblings, &shost->__targets);
> 
> So probably we can reuse this field and do deferred reaping without any
> memory allocation at all.  The following patch should be applied
> _instead_ of the James' patch, not on top of it (I can make a combined
> patch if it is desired).  The difference with the previous patch is that
> scsi_target_reap() still removes the target from shost->__targets
> immediately - only device_del() and subsequent actions are deferred to a
> workqueue.

No, you can't.

If you do this, the target namespace will potentially be in use in sysfs
after the system thinks the target is gone.  Thus, any reallocation
fails because you can't add a new target with the same name as an
existing one.

James


