From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Thu, 03 May 2007 16:00:57 -0400
Message-ID: <463A3F79.80809@emulex.com>
References: <20070419132459.GB1481@korben.rdu.redhat.com>	 <1176991356.31764.3.camel@mulgrave.il.steeleye.com>	 <20070419150655.GC1481@korben.rdu.redhat.com>	 <20070421002345.673d9988.akpm@linux-foundation.org>	 <20070421135956.GA22873@korben.rdu.redhat.com>	 <20070423181318.GD22873@korben.rdu.redhat.com> <1177352786.6284.51.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59250 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbXECUD2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 16:03:28 -0400
In-Reply-To: <1177352786.6284.51.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Josef Bacik <jwhiter@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

I doubt it's in the fc transport - it's doing what it always did, which has
nothing to do with coherency of the sdev's.

We're seeing like problems, and it looks like it's related to the scan_mutex
being held when some of the entry points are being called via the recent
async scan code (which also still has a bunch of issues around rmmod).
We should be sending some patches shortly.

-- james s

James Bottomley wrote:
> On Mon, 2007-04-23 at 14:13 -0400, Josef Bacik wrote:
>> Ok I have a new patch that I've built and tested on both my UP and SMP machine
>> and it appears to work fine.  I took the async check out of scsi_add_lun, I
>> don't really see the point in waiting to do the sysfs registration stuff (if
>> theres a reason I haven't been able to find it in the original submission of
>> this functionality).  Please let me know if this is incorrect.  Thank you,
> 
> Yes, it's incorrect ... if you do this, the devices will come up in a
> random order for multiple SCSI cards.  One of the original design goals
> was not to require udev, so the final ordering should be the same as for
> the sync case.
> 
> I think the root cause of the problem is somewhere in the fc transport
> rport addition code.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
