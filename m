From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Wed, 23 Oct 2013 04:58:02 -0400
Message-ID: <yq1mwm0fjol.fsf@sermon.lab.mkp.net>
References: <1378123118-111972-1-git-send-email-hare@suse.de>
	<1378123118-111972-2-git-send-email-hare@suse.de>
	<1381840900.3752.19.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21147 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3JWI7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 04:59:19 -0400
In-Reply-To: <1381840900.3752.19.camel@dabdike.lan> (James Bottomley's message
	of "Wed, 16 Oct 2013 19:22:09 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:

James> Once that's done, I think the patch looks like the one below, is
James> that OK?

Looks OK to me.


James> I still have qualms about the media access check because what can
James> happen is that we abort, TUR succeeds then the next Media access
James> command fails, we abort, TUR succeeds etc until the media access
James> timeout goes off.  The problem is that it never gets escalated to
James> a reset which might fix the condition.

All the cases we had in the field involved devices where the command
processing part of the device worked fine but the media access became
impossible (think wedged read/write head assembly, dead FTL on an SSD).

I haven't seen any cases where a device would respond to SPC commands
while failing all media accesses and then be able to resume media
accesses after a reset. Doesn't mean that such a device doesn't exist,
of course, but the patch was originally done to handle the "irreparably
broken" error case.

-- 
Martin K. Petersen	Oracle Linux Engineering
