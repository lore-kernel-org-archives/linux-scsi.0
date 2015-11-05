From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] Restart list search after unlock in scsi_remove_target
Date: Thu, 5 Nov 2015 08:55:59 -0800
Message-ID: <CAPcyv4iO0iX2_DCSKz8aXSqeu22bO=kq9CtRtH-MSrKm4ouxfg@mail.gmail.com>
References: <5633E9F2.5080209@sandisk.com>
	<5633EA98.8050604@sandisk.com>
	<563A883C.9060501@sandisk.com>
	<1446677072.2216.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38098 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030726AbbKEQ4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 11:56:00 -0500
Received: by wmeg8 with SMTP id g8so18989972wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 08:55:59 -0800 (PST)
In-Reply-To: <1446677072.2216.30.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Nov 4, 2015 at 2:44 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
[..]
> The fundamental problem with this is how have the conditions that caused
> us to move away from list restart:
>
> commit bc3f02a795d3b4faa99d37390174be2a75d091bd
> Author: Dan Williams <djbw@fb.com>
> Date:   Tue Aug 28 22:12:10 2012 -0700
>
>     [SCSI] scsi_remove_target: fix softlockup regression on hot remove
>
> Which was triggered by this bug report
>
> http://thread.gmane.org/gmane.linux.kernel/1348679
>
> been mitigated?
>

I think it has because the problem that led to that report was the
fact that scsi_target_destroy() did not advance the target state, but
we changed that in f2495e228fce.

http://marc.info/?l=linux-scsi&m=144527527308725&w=2
