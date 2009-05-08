From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED,
 CAPACITY_DATA_CHANGED,
Date: Fri, 8 May 2009 09:41:19 +0900
Message-ID: <20090508094158T.fujita.tomonori@lab.ntt.co.jp>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu>
	<49E90243.7080806@cs.wisc.edu>
	<49EC46A8.1070704@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36677 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764878AbZEHAle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 20:41:34 -0400
In-Reply-To: <49EC46A8.1070704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Mon, 20 Apr 2009 11:55:52 +0200
Hannes Reinecke <hare@suse.de> wrote:

> Hi Mike,
> 
> Mike Christie wrote:
> > Hey Hannes
> > 
> > While we are talking about LSF stuff and you are not busy with distro
> > stuff....
> > 
> Ah, irony detector kicked in.
> (Current bugilla count is at 114. Ask me about being busy.)
> 
> > I implemented this based on what we talked about at the last LSF.
> > 
> Yes, I've seen it. You again beat me to it; I've done an initial implementation
> already but failed to send it mainline. Sigh.
> 
> But yes, we _do_ need something like this.
> 
> > I was thinking that maybe using kobject_uevent_env would be better. The
> > info that gets passed to userspace would be the decoded sense and
> > asc/ascq based on values from the drivers/scsi/constants.c.
> > 
> No. This patch has the possibility of generating _huge_ amounts of
> messages, most of which are information only and of no influence
> to the actual operation.
> udev would be flooded with it and won't be able to react to 'important'
> messages while processing them.

Do we really have huge amount of messages, errors, unit attentions,
etc?

We already have a mechanism to send events to user space,
sdev_evt_send(). Could we simply use (or extend) it?


> Hence a separate mechanism like the proposed SCSI generic netlink
> facility is the better approach.
