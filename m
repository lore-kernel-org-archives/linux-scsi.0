From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] qla2xxx: sleep while IRQ disabled fix in eh_abort
Date: 01 Apr 2004 10:04:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080831910.2118.6.camel@mulgrave>
References: <opr3u0ffo7l6e53g@us.ibm.com>
	<20040225134518.A4238@infradead.org> <opr3xta6gbl6e53g@us.ibm.com>
	<1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com>
	<406B3FDA.9010507@pobox.com> <opr5q1enb6l6e53g@us.ibm.com>
	<1080776399.11299.63.camel@mulgrave>
	<20040401061740.GA14121@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3291 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262453AbUDAPFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 10:05:25 -0500
In-Reply-To: <20040401061740.GA14121@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-01 at 01:17, Andrew Vasquez wrote:
> Attached is a patch which fixes a problem in qla2xxx_eh_abort() where
> we incorrect use spin_unlock() before calling qla2x00_abort_command()
> - which can of course sleep.

Well, actually, sleeping with interrupts disabled is only a minor bug. 
Assuming they'll be disabled when you return from a sleep is the major
bug because if you take the host lock again without disabling
interrupts, you'll deadlock on a SCSI interrupt.

Regardless, this patch doesn't look right.  Flags contains interrupt
state.  If you actually go around the for loop, you set the state
unconditionally to disabled because of the

			spin_lock_irq(ha->host->host_lock);
			spin_lock_irqsave(&ha->hardware_lock, flags);

James


