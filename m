From: "Gwendal Grignou" <gwendal@google.com>
Subject: Re: [2.6.25] scsi mid layer: add a time threshold to force device to completed command queued for a long time.
Date: Mon, 24 Mar 2008 16:53:32 -0700
Message-ID: <e7510f760803241653t79aa4bc3p1bc2595ff6d39508@mail.gmail.com>
References: <e7510f760803111741h71de33b0i3764b7759a340803@mail.gmail.com>
	 <1205286251.2941.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:56635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYCXXxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Mar 2008 19:53:39 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m2ONrXdO011167
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2008 16:53:33 -0700
Received: from wr-out-0506.google.com (wri69.prod.google.com [10.54.9.69])
	by zps77.corp.google.com with ESMTP id m2ONqjD8029731
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2008 16:53:33 -0700
Received: by wr-out-0506.google.com with SMTP id 69so2134739wri.5
        for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2008 16:53:33 -0700 (PDT)
In-Reply-To: <1205286251.2941.84.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

Thanks for the input, I am rethinking my patch. I agree with your
second and third points.
However, I am not using tag_map for this feature:
In blk_queue_start_tag(), I assumed q->tag_busy_list contains the list
of requests send to given device when q is tagged.
q is the one managed by scsi_request_fn(), allocated in
scsi_alloc_sdev() by scsi_alloc_queue(); I believe it is unique per
scsi device.
q->tag_busy_list is not shared by several device, can't I use it to
track requests send to a given disk?

Let me know if I missed something.
Thanks,

Gwendal.



On Tue, Mar 11, 2008 at 6:44 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2008-03-11 at 17:41 -0700, Gwendal Grignou wrote:
>  > Please ignore the patch I sent earlier, it was out of context.
>  > [scsi_sysfs: Fix cut and paste errors]
>  > This patch allows to throttle command queuing to a device, if
>  > older commands are outstanding for too long already.
...
>
>  Firstly there's a structural problem with this:  you don't take into
>  account the fact that the tag map may be shared, so the first entry in
>  the tag list may belong to a completely different device.
>
>  Secondly, this req->timeout_time_thres is really at the wrong layer:
>  it's only ever set and read from SCSI, so there's not really a good
>  reason to place it in the request ... it should probably be in the
>  command.  Additionally, cmnd->jiffies_at_alloc already exists, so you
>  can probably get it do do everything you need without adding even a
>  parameter to the command.
>
>  Finally, it doesn't look like it will work well with error handling: we
>  use the ->queuecommand path for certain error handling commands; if the
>  device is stopped and we've passed the threshold, this will reject the
>  error handling commands as well.  The basic problem here is that the tag
>  is held in the block layer and isn't released until the command is
>  completed (after error handling is done).
>
>  James
>
>
>
