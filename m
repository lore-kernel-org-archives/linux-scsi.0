From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: qla2xxx lock ordering question
Date: Thu, 27 Apr 2006 10:49:51 +0200
Message-ID: <1146127792.2894.24.camel@laptopd505.fenrus.org>
References: <1145438524.3085.19.camel@laptopd505.fenrus.org>
	 <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38583 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965009AbWD0Ity (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 04:49:54 -0400
In-Reply-To: <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: mingo@elte.hu, linux-scsi@vger.kernel.org

On Thu, 2006-04-20 at 16:46 -0700, Andrew Vasquez wrote:
> On Wed, 19 Apr 2006, Arjan van de Ven wrote:
> 
> > a question about qla2xxx lock ordering since it trips up with Ingo's
> > lock depenceny tool:
> > 
> > in qla2x00_mailbox_command() the code first grabs the mbx_reg_lock lock,
> > then the hardware_lock. So far so good. But then...
> > it drops the mbx_reg_lock, does stuff, and regrabs the mbx_reg_lock
> > lock, while keeping the hardware_lock held!
> > 
> > This appears to be an AB-BA deadlock risk since for the second part you
> > are taking the locks in the wrong order... or am I missing something
> > here?
> 
> Actually the code is a bit convoluted, but I believe we are OK.  There
> are two scenarios we need to consider:


ok found the real culprits ;)

in qla2x00_reset_chip the driver first takes the hardware lock, and then
later on takes the mbx lock.

In the mailbox_command code.. it goes the other way around.

Now I don't know if reset_chip can in theory race with the mailbox code,
but I'd not be surprised since reset_chip is called in error recovery
iirc...


