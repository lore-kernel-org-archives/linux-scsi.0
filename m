From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: add LBPRZ support
Date: Thu, 08 Mar 2012 00:04:39 -0500
Message-ID: <yq1boo7hee0.fsf@sermon.lab.mkp.net>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com>
	<4F5808EB.9000909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31966 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2CHFEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2012 00:04:45 -0500
In-Reply-To: <4F5808EB.9000909@redhat.com> (Eric Sandeen's message of "Wed, 07
	Mar 2012 19:18:35 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: dgilbert@interlog.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

Eric> While we're talking about names, looking at other scsi_debug_*
Eric> flags should it be lbprz / scsi_debug_lbprz / DEF_LBPRZ instead of
Eric> unmap_zeroes / scsi_debug_unmap_zeroes / DEF_UNMAP_ZEROES?

Yeah, that's more consistent with my recent updates which use the lbpfoo
flag names.


>> Ah, and inquiry_evpd_b2() should return 4 (not 8).

Eric> Is that at all related to this change or some other random bug?
Eric> Should that return be unconditional?  Should that be a separate
Eric> patch?  By someone who knows what it means? :)

The returned page length should not include the length of the header. I
mess that up all the time. The spec says: "If the DP bit is set to
zero, then the page length shall be set to 0004h." The memset also needs
to be fixed accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
