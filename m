From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the
	queue
Date: Tue, 19 Dec 2006 11:03:33 +0100
Message-ID: <1166522613.3365.1198.camel@laptopd505.fenrus.org>
References: <20061219083507.GA20847@localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:38966 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932776AbWLSKnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2006 05:43:19 -0500
In-Reply-To: <20061219083507.GA20847@localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 2006-12-19 at 10:35 +0200, Dan Aloni wrote:
> Hello,
> 
> scsi_execute_async() has replaced scsi_do_req() a few versions ago, 
> but it also incurred a change of behavior. I noticed that over-queuing 
> a SCSI device using that function causes I/Os to be starved from 
> low-level queuing for no justified reason.
>  
> I think it makes much more sense to perserve the original behaviour 
> of scsi_do_req() and add the request to the tail of the queue.

Hi,

some things should really be added to the head of the queue, like
maintenance requests and error handling requests. Are you sure this is
the right change? At least I'd expect 2 apis, one for a head and one for
a "normal" queueing...

Greetings,
   Arjan van de Ven
