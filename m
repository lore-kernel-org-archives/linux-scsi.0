From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Mon, 7 Mar 2005 23:00:10 -0800
Message-ID: <20050308070010.GE5141@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C12ECDC@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:17083 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261859AbVCHG7n
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 01:59:43 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12ECDC@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Sat, 05 Mar 2005, James.Smart@Emulex.Com wrote:

> In thinking this through a little further - if the workq is just
> for the transport, the transport ought to simply create and use
> the workq. There would be no need to modify the host structure.
> 
> If we're trying to avoid the potential for several workq's on a
> per-host basis (one by the transport, another by the LLDD, another
> for ?) - the idea of one in the host is worth while.
>

Yes, that was the general idea -- reduce the number of worker-threads
contending for the same shost resource.  In also thinking a bit more
about this subject, I wonder if there are truly many other (useful)
purposes for a generic 'deferred' work_q at the shost level, other
than for scanning.  

There were some background tasks I shelved until the remote-ports
stuff settled down which I thought could use the deferred processing
thread:

* Initiate LIP -- several customers have asked for this ability as
  several topological configurations isolate disruptive FC events.
* Initiate LLDD rescan (i.e. ports (fibre channel), devices (iSCSI),
  etc.)

I had originally envisioned these functions residing in the transport.

>
> However, it
> should always be allocated and available. No "create" flag should
> be needed.
> 

Not to sure about that -- a large percentage of drivers would not
(currently) benefit from having a deferred work_q created for each
shost instance it registered.  

--
AV
