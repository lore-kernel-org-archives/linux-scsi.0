From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [Open-FCoE] Issue with fc_exch_alloc failing initiated by
 fc_queuecommand on NUMA or large configurations with Intel ixgbe running
 FCOE
Date: Tue, 11 Oct 2016 10:51:29 -0400
Message-ID: <1476197489.4019.68.camel@localhost.localdomain>
References: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com>
         <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752801AbcJKOvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 10:51:31 -0400
In-Reply-To: <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Laurence Oberman <loberman@redhat.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, fcoe-devel@open-fcoe.org, "Curtis Taylor (cjt@us.ibm.com)" <cjt@us.ibm.com>, Bud Brown <bubrown@redhat.com>

On Sat, 2016-10-08 at 19:35 +0200, Hannes Reinecke wrote:
> You might actually be hitting a limitation in the exchange manager code.
> The libfc exchange manager tries to be really clever and will assign a 
> per-cpu exchange manager (probably to increase locality). However, we 
> only have a limited number of exchanges, so on large systems we might 
> actually run into a exchange starvation problem, where we have in theory 
> enough free exchanges, but none for the submitting cpu.
> 
> (Personally, the exchange manager code is in urgent need of reworking.
> It should be replaced by the sbitmap code from Omar).
> 
> Do check how many free exchanges are actually present for the stalling 
> CPU; it might be that you run into a starvation issue.

We are still looking into this but one thing that looks bad is that
the exchange manager code rounds up the number of CPUs to the next
power of 2 before dividing up the exchange id space (and uses the lsbs
of the xid to extract the CPU when looking up an xid). We have a machine
with 288 CPUs, this code is just begging for a rewrite as it looks to
be wasting most of the limited xid space on ixgbe FCoE.

Looks like we get 512 offloaded xids on this adapter and 4096-512
non-offloaded xids.  This would give 1 + 7 xids per CPU.  However, I'm
not sure that even 4096 / 288 = 14 would be enough to prevent stalling.

And, of course, potentially most of the CPUs aren't submitting I/O, so
the whole idea of per-CPU xid space is questionable.

-Ewan

