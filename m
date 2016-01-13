From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 13/22] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 13 Jan 2016 11:05:03 +0100
Message-ID: <20160113100503.GB15163@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-14-git-send-email-hare@suse.de> <20160112171404.GE23947@lst.de> <5695F66A.9040709@suse.de> <5695F932.5010806@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41984 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbcAMKFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 05:05:04 -0500
Content-Disposition: inline
In-Reply-To: <5695F932.5010806@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 08:13:54AM +0100, Hannes Reinecke wrote:
>> _Actually_ we only need to call flush_delayed_work if sdev ==
>> rtgp_sdev. Otherwise the workqueue item is running off a different
>> device and won't be affected.
>>
> Hmm. Well, not quite. We run into flush_delayed_work()  only if the port 
> group changes or upon bus detach.
> For all other callers rtpg_sdev() should already be NULL.
> But looking at the call sites we can indeed move the flush_delayed_work() 
> into the release function.

Looks like the earlier you made sense after all :)
