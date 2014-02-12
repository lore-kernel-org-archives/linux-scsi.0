From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][RFC] Add EVPD page 0x83 entries to sysfs
Date: Wed, 12 Feb 2014 15:41:45 +0000
Message-ID: <1392219704.2172.34.camel@dabdike>
References: <1391691878-61265-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:58578 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaBLPmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 10:42:31 -0500
In-Reply-To: <1391691878-61265-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <7D93CFBA7C708D439EE6F8F1B7BCF2F1@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kay@vrfy.org" <kay@vrfy.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On Thu, 2014-02-06 at 14:04 +0100, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device.
> So instead of having each and every program issue a separate
> SG_IO call to retrieve this information it does make far more
> sense to display it in sysfs.

Can someone please tell me what actual benefits we get from retrieving
an parsing this in the kernel instead of in userspace.  Just adding more
heuristics made your code grow by 150% since Thursday.  I'm really
worried about incomplete heuristics in the kernel because the process
for updating them is much more involved than simply doing an update to a
user package.

Please define what you're trying to achieve first, because if it's just
the best persistent name for the device it might be better to reverse
all of this and have a user writeable field in SCSI that udev populates
after it does all the heuristic stuff.  Is it a range (like name +
transport ID + other stuff) in which case we might get additional plug
ins to do that.

James

