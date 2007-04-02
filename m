From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Mon, 02 Apr 2007 13:57:56 -0500
Message-ID: <46115234.20308@us.ibm.com>
References: <11751999513070-patch-mail.ibm.com> <460C375F.1000000@torque.net>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38214 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965693AbXDBS6B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:58:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l32Itq4t001470
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 14:55:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l32Iw05o198200
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 12:58:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l32IvxYO006813
	for <linux-scsi@vger.kernel.org>; Mon, 2 Apr 2007 12:58:00 -0600
In-Reply-To: <460C375F.1000000@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

Douglas Gilbert wrote:
> Brian King wrote:
>> Currently, the scsi error handler will issue a START_UNIT
>> command if the drive indicates it needs its motor started
>> and the allow_restart flag is set in the scsi_device. If,
>> after the scsi error handler invokes a host adapter reset
>> due to error recovery, a device is in a unit attention
>> state AND also needs a START_UNIT, that device will be placed
>> offline. The disk array devices on an ipr RAID adapter
>> will do exactly this when in a dual initiator configuration.
>> This patch adds a single retry to the EH initiated
>> START_UNIT.
> 
> I have no objection to this patch. Just seems a pity
> that SCSI devices go to the trouble of sending unit
> attentions while OSes just throw them away.

I agree. The reason the ipr adapter firmware added this UA
in this configuration was to support SCSI 1 reservations and
communicate to the host that any reservation previously
held to the disk array is now lost since the adapter was reset.

> Perhaps the scsi_device sysfs directory could have entries
> like:
>   last_ua_asc
>   last_ua_ascq
>   last_ua_timestamp
> where code could place the asc/ascq codes and a timestamp
> then continue doing a retry.
> Could we get a log entry, hotplug event?

If we did have a way to communicate UA's to userspace like this
it seems like it would allow usage of SCSI 1 reservations
in this config and make it easier for an out of band tool to
manage these reservations. I wonder if it would be cleaner if
UAs could simply be sent up as netlink events / uevents, so they
could contain all the information needed in one packet, rather
than having to read sysfs attributes to figure out what happened.

> Logical units may queue unit attentions (sam4r10.pdf
> section 5.8.7) so it is possible that one retry may
> not be enough. With my suggestion above, only the last
> one would persist for a reasonable time.

Yep. I've already ran into that with dual ported SAS devices.
While one retry is sufficient for the ipr disk array devices I am
trying to fix this for, I have no objection to increasing it.
Maybe its just a case of increasing it later if it ends up
being an issue.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

