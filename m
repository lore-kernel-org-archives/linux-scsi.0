From: Robert Trace <maillist@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 19:27:08 -0400
Message-ID: <4FFCBA4C.4000502@farcaster.org>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eris.farcaster.org ([75.127.72.104]:42920 "EHLO
	smtp.farcaster.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2GJX1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jul 2012 19:27:13 -0400
In-Reply-To: <4FFB8A86.7000009@farcaster.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-scsi@vger.kernel.org

On 07/09/2012 09:51 PM, Robert Trace wrote:
> 
> Huh..  I just retested this and I'm seeing really random behavior.

Ok, with a refined test I've been able to reliably reproduce this and I
bisected it back to commit 85ef06d1d252f6a2e73b678591ab71caad4667bb in
Linus' tree (introduced between 3.0 and 3.1):

commit 85ef06d1d252f6a2e73b678591ab71caad4667bb
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Jul 1 16:17:47 2011 +0200

    block: flush MEDIA_CHANGE from drivers on close(2)

Prior to the above commit, sleeping disks will spin up as a result of
I/O sent to them.  With the above commit, they don't spin up and
immediately return an I/O failure.

That's all the further I've gotten so far.  I'll be happy to test any
patches or suggestions.

-- Rob
