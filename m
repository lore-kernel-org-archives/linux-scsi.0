From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: qla2xxx lock ordering question
Date: Sat, 22 Apr 2006 15:41:40 +0200
Message-ID: <1145713301.2882.3.camel@laptopd505.fenrus.org>
References: <1145438524.3085.19.camel@laptopd505.fenrus.org>
	 <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:58051 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751089AbWDVTuw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Apr 2006 15:50:52 -0400
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id k3MDiuwV006447
	for <linux-scsi@vger.kernel.org>; Sat, 22 Apr 2006 13:44:59 GMT
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


I actually don't believe so based on what the lockdep checker sees; it
really really sees a third behavior..

