From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] libsas: fix "sysfs group not found" warnings at port
 teardown time
Date: Wed, 29 Mar 2017 10:11:42 +0200
Message-ID: <20170329081142.GA3794@linux-x5ow.site>
References: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170319124437.GA15094@linux-x5ow.site>
 <b98e90a0-4914-0277-4aca-03a897b59ac0@huawei.com>
 <20170321135154.GF30013@linux-x5ow.site>
 <5f350965-017b-fd5b-8fad-eba01682d72e@huawei.com>
 <20170324112347.GE3571@linux-x5ow.site>
 <8415e37f-4d96-4b92-a967-cf41a4291e8f@huawei.com>
 <20170324165354.GJ3571@linux-x5ow.site>
 <20170328214149.GE28157@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44393 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754849AbdC2IMG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 04:12:06 -0400
Content-Disposition: inline
In-Reply-To: <20170328214149.GE28157@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: John Garry <john.garry@huawei.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Tue, Mar 28, 2017 at 05:41:49PM -0400, Tejun Heo wrote:
> > But as I said, I don't belive this is a problem in the SAS transport or the
> > SAS drivers, but a device core or transport class.
> 
> So, what's most likely happening is that the parent device or kobject
> which contains the attribute group has already been removed earlier
> and because the removal is recursive, the later explicit removal is
> trying to remove already removed files.  It can be fixed either by
> reordering so that the parent node is removed after the children or
> simply dropping the explicit removal of children.

Hi Tejun,

Thanks for haivng a look at this. I already did this earlier and it didn't have
an effect at all. But I forgot to flush the SAS desctruct workqueue so it didn't
have an effect.

Thanks for re-pointing me to it. Patches fixing the issue are coming finally :-).

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
