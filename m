From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 23:37:28 +0300
Message-ID: <4CE19A08.8050606@vlnb.net>
References: <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101115070436.GC14442@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0KOUhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 15:37:19 -0500
In-Reply-To: <20101115070436.GC14442@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

Dmitry Torokhov, on 11/15/2010 10:04 AM wrote:
>> 1. What to do if another SCST object is being created with the same name
>> as supposed to be deleted, but not completely dead yet?
> 
> The same rules as with files - the object disappears from the
> "directories" so no new users can get it but is not destroyed till last
> reference is gone.
> 
>>
>> 2. What to do if a dieing object is found on some list and reference for
>> is supposed to be taken? If the object deleted from the list before it
>> marked dieing, i.e. the latest internal put() done, it made additional
>> problems during deleting it after the latest external put done.
> 
> You delete the object from the list, then mark it as dead, notify users,
> drop refcount. No new users will get it (as it is not on the list
> anymore) and existing ones should notice that it is dead and stop using
> it.

Those are good in theory, but on practice, you know, devil is in the
details..

>> This is because SYSFS doesn't hold references for the corresponding
>> kobjects for every open file handle. It holds references only when
>> show() and store() functions called. So, everything is under control and
>> a malicious user can do nothing to hold a reference forever.
> 
> Right, Tejun plugged this particular (and very annoying) attributes
> behavior

This behavior isn't annoying, it's GREAT, because it allows to use SYSFS
simply and reliably.

>, but that does not mean that this is the only way kobject's
> reference might be pinned.

Could you be more specific and point out on exact ways for that? From my
quite deep SYSFS source code study I see such cases should not exist.

Thanks,
Vlad
