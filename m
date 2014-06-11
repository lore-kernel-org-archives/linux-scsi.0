From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 14:24:19 +0000
Message-ID: <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
	 <1401953203-103015-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43811 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaFKOYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 10:24:20 -0400
In-Reply-To: <1401953203-103015-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <0A8383862498D74E82A8D3F101D4FF83@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "elliot@hp.com" <elliot@hp.com>

On Thu, 2014-06-05 at 09:26 +0200, Hannes Reinecke wrote:
> REPORT_LUN_SCAN does not report any outstanding unit attention
> condition as per SAM. However, the target might not be fully
> initialized at that time, so we might end up getting a
> default entry (or even a partially filled one).
> But as we're not able to process the REPORT LUN DATA HAS CHANGED
> unit attention correctly we'll be missing out some LUNs during
> startup.
> So it's better to send a TEST UNIT READY for modern implementations
> and wait until the unit attention condition goes away.

Are you sure this is a good idea: we just spent ages tuning SCSI init so
we don't slow systems down.  This patch, in the event the array is
having a power on problem, takes us right back to waiting for init
again ... basically the busy wait in scsi_test_lun.

Since the array should send us a UA anyway when it's got itself sorted
out, what's wrong with just processing the report luns data has changed
condition?

James

