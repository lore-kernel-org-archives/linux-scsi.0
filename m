From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Wed, 28 Oct 2009 15:27:36 +0100
Message-ID: <20091028142736.GA7642@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF4EC3.6010506@cs.wisc.edu> <20091023071324.GA5930@schmichrtp.de.ibm.com> <4AE76BEE.20907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:50662 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZJ1O1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 10:27:33 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.1/8.13.1) with ESMTP id n9SERbG4031088
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2009 14:27:37 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9SERbU91171560
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2009 15:27:37 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9SERaec029921
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2009 15:27:37 +0100
Content-Disposition: inline
In-Reply-To: <4AE76BEE.20907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 27, 2009 at 04:53:50PM -0500, Mike Christie wrote:
> Christof Schmitt wrote:
>> On Wed, Oct 21, 2009 at 01:11:15PM -0500, Mike Christie wrote:
>>> Christof Schmitt wrote:
>>>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>>>> midlayer error handling which cannot do much during the interruption
>>>> to the hardware and will mark the SCSI devices 'offline'. In order to
>>>> prevent this, the rule would be: First call fc_remote_port_delete to
>>>> set the remote port (or in the case of an HBA interruption all remote
>>>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>>>> SCSI commands back to the upper layers.
>>>>
>>> One other note when doing this.
>>>
>>> For problems where you are deleting the rport, it is best to use   
>>> something like DID_TRANSPORT_DISRUPTED to fail the cmd if you are   
>>> failing it right away.
>>
>> "something like DID_TRANSPORT_DISRUPTED" would be any error code that
>> goes through "maybe_retry" in scsi_decide_disposition? I guess moving
>> to DID_TRANSPORT_DISRUPTED is nice for consistency, but DID_ERROR
>> triggers the same code paths as far as i can see.
>
> It could be a little different. See scsi_noretry_cmd. If you used  
> DID_ERROR and something set the driver failfast bit then it would be  
> fast failed.

Ok. Somehow i missed scsi_noretry_cmd while looking at the SCSI code.
Then it makes sense to report DID_TRANSPORT_DISRUPTED from the zfcp. I
will target the zfcp patch for the next merge window.

Christof
