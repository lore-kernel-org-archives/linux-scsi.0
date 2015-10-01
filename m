From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
 device
Date: Thu, 1 Oct 2015 00:56:41 +0000
Message-ID: <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
 <20150930151857.GA26594@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:38107 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbbJAA6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 20:58:18 -0400
In-Reply-To: <20150930151857.GA26594@lst.de>
Content-Language: ja-JP
Content-ID: <2A023BCCBEF94144A5D02FF29F405EE1@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 10/01/15 00:18, Christoph Hellwig wrote:
> On Wed, Sep 30, 2015 at 12:35:50AM +0000, Junichi Nomura wrote:
>> With v4.3-rc3, stress testing of SCSI device addition/removal quickly
>> trigger random crash in memory allocator (e.g. __kmalloc).  I found that
>> a commit 086b91d052eb ("scsi_dh: integrate into the core SCSI code")
>> moved the call of scsi_dh->detach() to very early part of sdev tear down
>> process (scsi_remove_device()). As a result, related data structure such
>> as alua_dh_data can be freed while rtpg/stpg are still in-flight.
> 
> Hi Junichi,
> 
> the code should have been called from that early in the process before,
> as it was called from the bus notifier that was called first in device_del.

With 4.2 kernel, scsi_dh->detach() was not called until the last
reference has gone.  With 4.3-rc3, scsi_dh->detach() is directly called
from the context of scsi_remove_device(). That's the point.

And in terms of that, my example script might not be reproducing the
situation I'm claiming because activation via sysfs doesn't seem to take
refcount anyway..  The original crash I saw happend when dm-mpath was
involved, which used to take refcount of scsi_dh while in-use.

> While something in this series obviously caused the regression are you
> sure it's exactly this patch?

So it might be the commit 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm
detach device handlers"), which eliminates refcounting of scsi_dh.

-- 
Jun'ichi Nomura, NEC Corporation