From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8329] New: mtplan.c: kmalloc while spinlock is
 held
Date: Sun, 15 Apr 2007 14:12:10 -0700
Message-ID: <20070415141210.183c8371.akpm@linux-foundation.org>
References: <200704152046.l3FKkGEc025163@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36340 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXDOVMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Apr 2007 17:12:23 -0400
In-Reply-To: <200704152046.l3FKkGEc025163@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, matthias.kaehlcke@gmail.com, linux-scsi@vger.kernel.org

On Sun, 15 Apr 2007 13:46:16 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8329
> 
>            Summary: mtplan.c: kmalloc while spinlock is held
>     Kernel Version: 2.6.20
>             Status: NEW
>           Severity: normal
>              Owner: jgarzik@pobox.com
>          Submitter: matthias.kaehlcke@gmail.com
> 
> 
> Problem Description:
> 
> under some conditions mpt_lan_type_trans() can do a kmalloc(GFP_KERNEL) while
> the spinlock bad_naa_lock is held
> 
> drivers/message/fusion/mptlan.c:
> 
> ...
>                 write_lock_irq(&bad_naa_lock);
>                 for (prevnh = nh = mpt_bad_naa; nh != NULL;
>                      prevnh=nh, nh=nh->next) {
>                         if ((nh->ieee[0] == fch->saddr[0]) &&
>                             (nh->ieee[1] == fch->saddr[1]) &&
>                             (nh->ieee[2] == fch->saddr[2]) &&
>                             (nh->ieee[3] == fch->saddr[3]) &&
>                             (nh->ieee[4] == fch->saddr[4]) &&
>                             (nh->ieee[5] == fch->saddr[5])) {
>                                 found = 1;
>                                 dlprintk ((KERN_INFO "mptlan/type_trans: ARP Re"
>                                          "q/Rep w/ bad NAA from system already"
>                                          " in DB.\n"));
>                                 break;
>                         }
>                 }
> 
>                 if ((!found) && (nh == NULL)) {
> 
>                         nh = kmalloc(sizeof(struct NAA_Hosed), GFP_KERNEL);
> ...
> 
> AFAIK this should not be done as kmalloc could sleep while holding the spinlock
> 

yup.  And the fact that nobody has ever reported a might_sleep() warning
coming out of there makes me think that it is dead code.

