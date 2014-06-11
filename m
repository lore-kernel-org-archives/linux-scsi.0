From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 16:33:38 +0200
Message-ID: <539868C2.50406@suse.de>
References: <1401953203-103015-1-git-send-email-hare@suse.de>	 <1401953203-103015-2-git-send-email-hare@suse.de> <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaFKOdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 10:33:41 -0400
In-Reply-To: <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "elliot@hp.com" <elliot@hp.com>

On 06/11/2014 04:24 PM, James Bottomley wrote:
> On Thu, 2014-06-05 at 09:26 +0200, Hannes Reinecke wrote:
>> REPORT_LUN_SCAN does not report any outstanding unit attention
>> condition as per SAM. However, the target might not be fully
>> initialized at that time, so we might end up getting a
>> default entry (or even a partially filled one).
>> But as we're not able to process the REPORT LUN DATA HAS CHANGED
>> unit attention correctly we'll be missing out some LUNs during
>> startup.
>> So it's better to send a TEST UNIT READY for modern implementations
>> and wait until the unit attention condition goes away.
>
> Are you sure this is a good idea: we just spent ages tuning SCSI init so
> we don't slow systems down.  This patch, in the event the array is
> having a power on problem, takes us right back to waiting for init
> again ... basically the busy wait in scsi_test_lun.
>
> Since the array should send us a UA anyway when it's got itself sorted
> out, what's wrong with just processing the report luns data has changed
> condition?
>
Because we can't.

_If_ we were attempting this we'd run into several issues:
a) Boot will fail, as REPORT LUNs will return 0 LUNs (or just LUN 0).
    So the scanning code will assume everything's fine. Booting will
    continue, only to figure out that no LUNs are present.
    As there is _no_ indication that REPORT LUNs should indeed have
    returned an error (only it can't due to SAM) we wouldn't even
    now that there _is_ an issue.
    (In fact, that's what triggered the patchset in the first place.)
b) Even _if_ we're able so somehow recover from that we will have
    to rescan the host and any attached devices.
    The only way to do this currently is to _remove_ all devices
    from that host and then do a full rescan.
    Trying this with any devices which are already part of some
    complex setup will become ... interesting.

So the easy way out here is indeed just to send a TEST UNIT READY.
And as we're checking for a reasonably SCSI compliance we should
be catching most of the oddballs.

Cheers,

Hannes
