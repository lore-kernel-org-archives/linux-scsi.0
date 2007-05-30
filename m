From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: kexec and aacraid broken
Date: Wed, 30 May 2007 18:54:30 +0530
Message-ID: <20070530132430.GA3773@in.ibm.com>
References: <20070529191347.9b1edd8b.akpm@linux-foundation.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42097 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbXE3NYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 09:24:52 -0400
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On Wed, May 30, 2007 at 07:44:02AM -0400, Salyzyn, Mark wrote:
> I believe this issue is a result of the aacraid_commit_reset patch (as
> posted for scsi-misc-2.6, enclosed to permit testing) not yet propagated
> to the 2.6.22-rc3 tree.
> 
> This is the adapter taking longer than 3 minutes to start after a reset.
> I seriously doubt either of these patches suggested below will have an
> affect. And if they do, they are not root cause, one reduces the chances
> that the card will be reset during initialization (thus applied would
> likely mitigate this problem), the other prevents a panic when the
> Adapter is reset (removed, would result in dogs and cats sleeping with
> each other).
> 
> Please use kernel parameter aacraid.startup_timeout=540 (merely larger
> than the default 180 seconds) when spawning the kexec or see if the
> aacraid_commit_reset.patch resolves the issue to confirm my hunch.
> 

Hi Mark,

During a normal kexec (not kdump) adapter reset should not have taken
place at all. device_shutdown() routines should have taken care to
bring the device to a known sane state in first kernel so that second
kernel can initialize it without doing a reset.

With reset patch, now reset triggers on every kexec. Previously
that was not the case with kexec and adapter used to come up. I think
this needs to be looked into.

Thanks
Vivek
