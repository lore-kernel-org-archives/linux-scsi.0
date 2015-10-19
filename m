From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi: restart list search after unlock in scsi_remove_target
Date: Mon, 19 Oct 2015 10:21:11 -0700
Message-ID: <CAA9_cmfmzJA84VhDr582FPdrw+0uAYVKjh7zPR_zc-BSGypQzA@mail.gmail.com>
References: <20151019143546.GA7486@lst.de>
	<56250DF7.6050803@sandisk.com>
	<20151019155658.GA11453@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33186 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbbJSRVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 13:21:11 -0400
Received: by iodv82 with SMTP id v82so201034021iod.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 10:21:11 -0700 (PDT)
In-Reply-To: <20151019155658.GA11453@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, jthumshirn@suse.de

On Mon, Oct 19, 2015 at 8:56 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Oct 19, 2015 at 08:36:23AM -0700, Bart Van Assche wrote:
>> Thanks for looking into this. However, I think we need a motivation in the
>> patch description why this patch does not reintroduce the soft lockup
>> documented in patch "scsi_remove_target: fix softlockup regression on hot
>> remove" (commit bc3f02a795d3).
>
> Interesting.  I tried to find the original report and what state
> changes would cause an endless loop here.  Dan, do you remember any
> details about this bug report?

I believe the issue I was seeing back then might have been fixed or at
least modulated by "f2495e228fce [SCSI] dual scan thread bug fix"
which came a few years later.  The original problem was hot-remove
racing hot-add and that scsi_target_reap() was not guaranteed to
advance the state of the target if it was in the process of being
scanned when a removal event arrived.  However the comment in that
change:

+       /*
+        * if we get here and the target is still in the CREATED state that
+        * means it was allocated but never made visible (because a scan
+        * turned up no LUNs), so don't call device_del() on it.
+        */

...is not what I was seeing.  The target was in the CREATED state
because it had not yet completed the initial scan before tear down was
initiated.
