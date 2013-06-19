From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v3 4/6] [SCSI] Generate uevents for certain Unit
 Attention codes
Date: Wed, 19 Jun 2013 18:48:20 +0000
Message-ID: <1371667700.2409.82.camel@dabdike>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-5-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:35456 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965011Ab3FSSsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 14:48:21 -0400
In-Reply-To: <1371663761-22481-5-git-send-email-emilne@redhat.com>
Content-Language: en-US
Content-ID: <4D36B3BA9BD8364E8FFABAA05424F86B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>

On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> Generate a uevent on the scsi_target object when the following
> Unit Attention ASC/ASCQ code is received:
> 
>     3F/0E  REPORTED LUNS DATA HAS CHANGED
> 
> Generate a uevent on the scsi_device object when the following
> Unit Attention ASC/ASCQ codes are received:
> 
>     2A/01  MODE PARAMETERS CHANGED
>     2A/09  CAPACITY DATA HAS CHANGED
>     38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
> 
> All uevent generation is aggregated and rate-limited so that any
> individual event is delivered no more than once every 2 seconds.

Why?  What causes you to think these events would be repeated on a
massive scale.  Mode and Capacity changes are signalled only once per
actual change, which doesn't occur very often.  SBC-3 says that the TP
thresholds are only signalled once but may be signalled again after a
reset.  In general, T10 treats UA as exceptional conditions ... there's
no reason to think they keep repeating.

Dumping all the hand rolled rate limit code would simplify the patch
quite a lot.

> Log kernel messages when the following Unit Attention ASC/ASCQ
> codes are received:
> 
>     2A/xx  PARAMETERS CHANGED
>     3F/03  INQUIRY DATA HAS CHANGED
>     3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED
> 
> Also changed the kernel log messages on existing Unit Attention
> codes, to remove text that indicates that the conditions were not
> handled in any way (since they are now handled in some way) and
> reflect the wording used in SPC-4.

This isn't a good idea because

     1. They might not be acted on if there's no actual listener for the
        uevent
     2. Anyone currently using a log message reaper to process the event
        (which is currently the only way of doing it) would now miss it
        because the log message has changed.

> Also log a kernel message when the a scsi device reports a Unit
> Attention queue overflow, indicating that status has been lost.
> 
> These changes are only enabled when the kernel config option
> CONFIG_SCSI_ENHANCED_UA is set.  Otherwise, the behavior is the
> same as before, including the existing kernel log messages.
> However, the detection of these conditions was moved to be earlier
> in scsi_check_sense(), because the code was not always reached.
> 
> Added a new exported function scsi_report_sense() to allow drivers
> to report sense data that is not associated with a SCSI command.

No: we don't add APIs until there are consumers.  The refactor into
scsi_report_sense is fine, just don't add the export or prototype until
someone comes along with a use case.

James

