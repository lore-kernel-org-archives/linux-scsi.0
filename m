From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Retry counters in sd.c
Date: Thu, 16 Aug 2007 16:19:39 -0700
Message-ID: <20070816161939.42e2d68b.zaitcev@redhat.com>
References: <Pine.LNX.4.44L0.0708151108000.3895-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXHPXXp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2007 19:23:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0708151108000.3895-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, zaitcev@redhat.com

On Wed, 15 Aug 2007 11:19:43 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:

> And that's not even taking into account the fact that
> sd_read_capcity(), together with everything else under
> sd_revalidate_disk(), gets called twice in a row during device
> scanning.  (What's the reason for that, anyway?)

I think this is an oldish problem in the block layer, which started
around 2.6.9. Right about that time Al Viro did something to make the
opens sane, and required ioctl to do opens right. This in turn busted
DASD on s390, and even floppies. The symptom was that after a media
change, first open would fail. This was fixed back in some 2.6.12
or so, I do not remember exactly, but the price was the redundant
call to revalidate the media.

IIRC the issue is open-from-within open, which is needed to check
partitions. Application opens sda1, and this in turn opens sda.
Something like that.

-- Pete
