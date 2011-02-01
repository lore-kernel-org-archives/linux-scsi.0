From: Tejun Heo <htejun@gmail.com>
Subject: Re: Current plans for SDEV_EVT_* and friends
Date: Tue, 1 Feb 2011 15:59:03 +0100
Message-ID: <20110201145903.GO14211@htj.dyndns.org>
References: <4D481ED2.1060109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41170 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1BAO7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2011 09:59:08 -0500
Received: by ewy5 with SMTP id 5so3117829ewy.19
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2011 06:59:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4D481ED2.1060109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>, kay.sievers@vrfy.org

(cc'ing Kay)

Hello,

On Tue, Feb 01, 2011 at 03:55:14PM +0100, Hannes Reinecke wrote:
> seeing that you are moving the old SCSI / libata AEN handling over
> to the new block-based workqueue, I was wondering what your plans
> are with the remaining SDEV_EVT_* things.

SDEV_EVT_* are basically dead.  There's no valid user for it in the
kernel.  libata-scsi hasn't been converted yet - virtually SATA AN is
pretty much stillborn and converting it would require a way to map ATA
device to block device which isn't easy without changing SCSI.

> Thing is I'm currently working on implementing proper Unit Attention
> handling in the SCSI stack. For this I would need to have some field
> off the scsi_device structure into which I can store information
> about which events / event types are supported and which are activated.
> So the existing bitmap approach with 'supported_events' would quite
> a good starting point here, and it will even be useful to add
> another one, eg 'enabled_events'.
> And, of course, plan is to route appropriate events over to the
> block workqueue by calling disk_check_events().
> 
> Unless you have other ideas/plans here ...

So, I think using the block layer DISK_EVENT_* would be the right way
to do it, but what kind of events do you have on mind?

-- 
tejun
