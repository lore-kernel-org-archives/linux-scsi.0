From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Wed, 09 Mar 2005 08:25:13 -0600
Message-ID: <422F0749.6050404@us.ibm.com>
References: <0B1E13B586976742A7599D71A6AC733C12ED0C@xbl3.ma.emulex.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Received: from e3.ny.us.ibm.com ([32.97.182.143]:62093 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261632AbVCIOZP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 09:25:15 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j29EPFYf023822
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 09:25:15 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j29EPEnA067336
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 09:25:14 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j29EPEHf022978
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 09:25:14 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12ED0C@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> So, is there a reason we aren't just starting the workq thread
> upon the first call to queue something to it ?

Don't you need to be at task level to create a workq thread?

-Brian


> -- james s
> 
> 
>>-----Original Message-----
>>From: Luben Tuikov [mailto:luben_tuikov@adaptec.com]
>>Sent: Tuesday, March 08, 2005 8:12 AM
>>To: Andrew Vasquez
>>Cc: Smart, James; linux-scsi@vger.kernel.org
>>Subject: Re: [RFC] adding per scsi-host workqueues for defered
>>processing
>>
>>
>>On 03/08/05 02:00, Andrew Vasquez wrote:
>>
>>>There were some background tasks I shelved until the remote-ports
>>>stuff settled down which I thought could use the deferred processing
>>>thread:
>>>
>>>* Initiate LIP -- several customers have asked for this ability as
>>>  several topological configurations isolate disruptive FC events.
>>>* Initiate LLDD rescan (i.e. ports (fibre channel), devices (iSCSI),
>>>  etc.)
>>>
>>>I had originally envisioned these functions residing in the 
>>
>>transport.
>>
>>Yes, I agree.  Domain (target, topology, etc) discovery should be
>>"part" of the transport class.
>>
>>What I'm thinking of is that the LLDD would register a known
>>trasport class with the SCSI Core at/after registering a host
>>template and then would call something with a name like
>>"start_scsi" which would do whatever necessary for the domain
>>(SAS, FC, iSCSI, etc) before scanning for targets.  Of course
>>for some domains no additional work is needed.
>>
>>	Luben
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
