From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/8] Fix spi initialisation failure
Date: Fri, 21 Mar 2008 16:15:06 -0500
Message-ID: <1206134106.2961.55.camel@localhost.localdomain>
References: <20080318133228.6DFD9159159@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59624 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbYCUVPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 17:15:10 -0400
In-Reply-To: <20080318133228.6DFD9159159@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> With the target rework we cannot set the attribute of the
> sysfs files as the sysfs object is not registered yet. So
> just modify the attribute itself.

Actually, this isn't the problem.  The problem is that the target is
added too early ... before we've had time to gather the necessary data
from the devices, so is_visible() is returning 0 (i.e. invisible) for a
lot of the files.  Then when we try to chmod a nonexistent file, sysfs
goes boom.

I think this can be fixed by making the sysfs API more elastic ... I'll
send patches shortly.

James


