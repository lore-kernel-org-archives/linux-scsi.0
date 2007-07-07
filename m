From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Fri, 06 Jul 2007 23:25:47 -0400
Message-ID: <468F07BB.4000909@torque.net>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com> <1183752169.3448.93.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbXGGD0Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2007 23:26:16 -0400
In-Reply-To: <1183752169.3448.93.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2007-07-05 at 14:06 -0700, Kristen Carlson Accardi wrote:
>> Since gendisk will now become part of struct scsi_device, we don't need
>> to store this value in any private data structs where they already store
>> scsi_device.  This series cleans up a few drivers which did this.
> 
> Actually, as Al pointed out, we do have lifetime rules issues with doing
> this.  The problem is that gendisk itself always has a shorter lifetime
> than scsi_device (not much shorter, usually, but if you execute a legal
> ULD unbind manoeuvre you'll end up with a dangling gendisk pointer).

What about having short-lived scsi_device objects? For example:
one that lives long enough for a pass-through to send a
SCSI command (and receive its response) to one of a target's
well known logical units.

> The other problem with taking gendisk out of the ULD structure and
> putting it into the scsi_device is that for the sg driver, we have two
> of them (one for the attached ULD and one for the sg driver).

Add the bsg driver and that would make three of them. Or; if
the lu's peripheral device type was not of interest to sd, st,
sr, and osst; back to two gendisk objects (i.e. one each
for sg and bsg).

> The fundamental issue seems to be that the gendisk is the holder of all
> the other info (queue, ULD etc) not vice versa ... and this patch is
> trying to reverse that relationship.

A minor issue is the name gendisk ... unless, of course,
you go and look at its definition in linux/genhd.h in
which case the name looks somewhat appropriate. It looks
like a mess [queue, ULD name, major/minor(s), partitions,
capacity, disk_stats, kobjects, etc]. That is a considerable
amount of superfluous information for "just a tag for
requests coming into (a) given queue" when that queue leads
to a non-block device.

Doug Gilbert
