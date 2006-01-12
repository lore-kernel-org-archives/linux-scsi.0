From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Calling scsi_done from queuecommand()
Date: Thu, 12 Jan 2006 08:59:00 +0100
Message-ID: <1137052740.2936.7.camel@laptopd505.fenrus.org>
References: <200601121157417180341@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9353 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932121AbWALH7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 02:59:05 -0500
In-Reply-To: <200601121157417180341@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-01-12 at 11:57 +0800, Zhikun Wang wrote:
> Hi list, 
> 	Can we call scsi_done() to complete the I/O from the queuecommand() ? 

yes that should be fine *IF THE COMMAND COMPLETED*. (for example that
can be done for battery backed ram cards)

> (e.g. to make queuecommand synchronous). 
> 	I try this method in my LsiLogic 22320 SCSI card driver 

but... that sounds unlikely to be right. That is real scsi, which means
you have to wait a REALLY long time (easily 5 miliseconds) before the
command completes, and you cannot sleep in queuecommand (it's called
from interrupt context). So this sounds really fishy

> in Redhat9,

you do realize you're using a truely antique linux kernel/distribution
there, right? I suggest you go to a far more recent (and an actual
maintained) distribution


