From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v3 0/6] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Mon, 22 Jul 2013 17:13:22 -0400
Message-ID: <1374527602.4139.27.camel@localhost.localdomain>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1374507094.2335.21.camel@dabdike>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab3GVVN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jul 2013 17:13:26 -0400
In-Reply-To: <1374507094.2335.21.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, Kirill Korotaev <dev@parallels.com>

On Mon, 2013-07-22 at 15:31 +0000, James Bottomley wrote:
> Ping on this, please.
> 
> I have another possible consumer of this infrastructure, when it's
> ready, which is the SCSI RAID drivers.  We've been getting complaints
> that there's no event we get from them when a RAID system goes from
> online -> degraded which should be the sysadmin's cue to go in and
> replace the disk (well, this isn't quite true, a lot come with
> proprietary monitoring daemons which do this, but they're pretty unique
> per controller).
> 
> I was thinking we might resurrect the orphaned raid_class.c to do this
> and give a universally displayable but rudimentary view of the topology
> and health of the device and add an easy hook for RAID events.
> 
> James
> 

I'm testing a v4 version of these patches, which address your earlier
comments.  I'm still working on the code to suppress the duplicate
REPORTED LUNS DATA HAS CHANGED unit attentions from multiple LUNs.
As I mentioned in my earlier mail, doing this with the expected_cc_ua
mechanism is imperfect, because SCSI-3 devices will stop reporting it
when one of the LUNs on the target *receives* a REPORT LUNs command, and
it is difficult to know when this happens.  I'm trying out clearing
the flag before the SCSI scan code issues a REPORT LUNs, that might be
good enough.  (It doesn't handle someone from sending this command
through the sg driver, though.)

Will post the v4 soon.

-Ewan



