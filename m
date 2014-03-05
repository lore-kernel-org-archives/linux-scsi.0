From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv7 0/3][Resend] Display EVPD pages in sysfs
Date: Wed, 05 Mar 2014 09:23:37 +0100
Message-ID: <5316DF09.4070704@acm.org>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <5312F1A1.4070605@acm.org> <5316D99D.3060005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:38125 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaCEIXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 03:23:41 -0500
In-Reply-To: <5316D99D.3060005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 03/05/14 09:00, Hannes Reinecke wrote:
> On 03/02/2014 09:53 AM, Bart Van Assche wrote:
>> A general comment about this patch series: I think the cached copies of
>> these pages should be refreshed at least after an INQUIRY DATA HAS
>> CHANGED unit attention code has been received. Some SCSI target
>> implementations allow to change this data after a LUN has been created.
>
> Yes, eventually. But this needs to be handled in a general context,
> as (potentially) even the inquiry string itself has been invalidated
> after receiving such an event.
> So we should be doing a rescan of the scsi device upon receiving
> such an event. But this is a general problem, not one particular to
> this patchset.

Sorry but since the ALUA patch series is based on this patch series I'm
afraid that the ALUA patch series introduces a regression that seems
unacceptable to me. SCSI target implementations like LIO allow to remove
and re-add a LUN after initial discovery of a SCSI host. My concern here
is that the caching introduced by this patch series and which is used in
the ALUA patch series will cause INQUIRY data not to be updated after it
has been changed at the target side. Today the scsi_dh_alua handler
processes such INQUIRY data changes fine. Does this make sense to you ?

Thanks,

Bart.

