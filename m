From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Thu, 31 Mar 2011 12:56:51 -0500
Message-ID: <4D94C063.5030000@linux.vnet.ibm.com>
References: <4D385C0A.3000901@suse.de> <4D385F69.5060209@interlog.com> <1295541361.3014.8.camel@mulgrave.site> <4D3C100C.1010609@panasas.com> <4D3D327F.1040807@suse.de> <AANLkTikL-EP=HsVjd_x9AmzptnrjSXdiNh3q1AriBz77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42336 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab1CaR4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2011 13:56:54 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2VHbxcI021779
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 13:37:59 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 9D44138C8039
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 13:56:46 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2VHurE7220146
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 13:56:53 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2VHuqpT006974
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 14:56:53 -0300
In-Reply-To: <AANLkTikL-EP=HsVjd_x9AmzptnrjSXdiNh3q1AriBz77@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@suse.de>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 03/31/2011 11:40 AM, Bart Van Assche wrote:
> On Mon, Jan 24, 2011 at 9:04 AM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> Currently sense codes have two problems:
>>
>> - They are limited to 96 bytes. Anything larger than that will just
>>  be discarded (or crash with your patch above :-)
>> - They inherit the same lifetime than the scsi command. But for any
>>  decent handling you really need to push them into some
>>  asynchronous context as you might well be within an interrupt
>>  handler here.
>>
>> I'm currently working on a handling framework using relayfs
>> (basically blktrace for SCSI Unit Attention); I can be doing a short
>> presentation at LSF if requested.
> 
> (replying to an e-mail of two months ago)
> 
> There is another scenario where better unit attention support would
> help. Both the LIO-port and the SCST-port of the ibmvstgt driver
> suffer from the same race condition during reboot of the virtual I/O
> server (VIOS). Since the ibmvscsic driver reconnects to the ibmvscsis
> driver as soon as the ibmvscsis driver has been loaded the client
> reconnects before all LUNs have been configured in the VIOS system. So
> even if the target implementation generates an INQUIRY DATA HAS
> CHANGED unit attention condition for each LUN change, LUNs will have
> to be rescanned explicitly at the initiator side in order to get the
> initiator state in sync with the target state.

This sounds to me like the vscsi server drivers really need to change
to only register their CRQ and not initialize their CRQ until userspace has
setup all the target devices.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


