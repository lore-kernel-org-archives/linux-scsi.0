From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Tue, 08 Mar 2005 08:11:36 -0500
Message-ID: <422DA488.2050007@adaptec.com>
References: <0B1E13B586976742A7599D71A6AC733C12ECDC@xbl3.ma.emulex.com> <20050308070010.GE5141@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:31455 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262045AbVCHNLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2005 08:11:42 -0500
In-Reply-To: <20050308070010.GE5141@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On 03/08/05 02:00, Andrew Vasquez wrote:
> There were some background tasks I shelved until the remote-ports
> stuff settled down which I thought could use the deferred processing
> thread:
> 
> * Initiate LIP -- several customers have asked for this ability as
>   several topological configurations isolate disruptive FC events.
> * Initiate LLDD rescan (i.e. ports (fibre channel), devices (iSCSI),
>   etc.)
> 
> I had originally envisioned these functions residing in the transport.

Yes, I agree.  Domain (target, topology, etc) discovery should be
"part" of the transport class.

What I'm thinking of is that the LLDD would register a known
trasport class with the SCSI Core at/after registering a host
template and then would call something with a name like
"start_scsi" which would do whatever necessary for the domain
(SAS, FC, iSCSI, etc) before scanning for targets.  Of course
for some domains no additional work is needed.

	Luben
