From: Michael Reed <mdr@sgi.com>
Subject: Re: PATCH [1/1]: sd_remove() hangs waiting on async_synchronize of
 unrelated threads
Date: Tue, 01 Dec 2009 16:28:44 -0600
Message-ID: <4B15989C.80108@sgi.com>
References: <4B158E7B.3040708@sgi.com> <1259704166.11762.516.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:58051 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752402AbZLAW2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2009 17:28:39 -0500
In-Reply-To: <1259704166.11762.516.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jeremy Higdon <jeremy@sgi.com>, James Smart <James.Smart@Emulex.Com>



James Bottomley wrote:
> On Tue, 2009-12-01 at 15:45 -0600, Michael Reed wrote:
>> Prevent delays and hangs due to sd_remove() waiting for the completion of
>> async threads executing sd_probe_async of disks on unrelated host adapters.
>> This patch executes every sd_probe_async in its own async domain allowing
>> sd_remove() to wait for just the completion of the async thread associated with
>> the scsi_disk being removed.
> 
> This patch was thought of a while ago. Unfortunately, some of the
> unrelated threads we end up waiting on are libata ones.  you confine sd
> to only its own probes, we end up unsynchronised with respect to libata
> probes and we might cause ordering problems amongst the ata devices.
> 

Isn't sd_remove() only concerned with the removal of a a single scsi_disk?
Shouldn't libata use reference counting if it has is an issue with a scsi_disk
being prematurely removed?  Or is this a concern about "sd" naming?  Or something
else that I admittedly don't understand (but should)?

I would truly like to better understand the issue.  Would someone mind expanding
upon the concern about ata ordering issues associated with the removal of a
single scsi_disk?

Thanks,
 Mike

> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
