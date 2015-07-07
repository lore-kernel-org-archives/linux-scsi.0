From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv2] sd: retry READ CAPACITY for ALUA state transition
Date: Tue, 7 Jul 2015 13:48:26 -0700
Message-ID: <559C3B1A.3020002@sandisk.com>
References: <1436181130-82905-1-git-send-email-hare@suse.de>
	 <559A9B23.4020705@sandisk.com>
 <1436216244.6241.7.camel@HansenPartnership.com> <559B6F24.6020804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:64170
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932704AbbGGUsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 16:48:30 -0400
In-Reply-To: <559B6F24.6020804@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/06/2015 11:18 PM, Hannes Reinecke wrote:
> However, to handle the above case correctly we would need to keep
> track of the entire multipath topology, to figure out which devices
> belong to that relative target port and might need to be updated
> (there might be several paths in standby, and we will have sent the
> RTPG only for one of them).
> Patches for that are not done yet, so I thought the above patch
> would be a simple stop-gap measure.

Hello Hannes,

Are you sure that keeping track of the entire multipath topology would 
be required to implement what I proposed ? In the patch "scsi_dh_alua: 
Use separate alua_port_group structure" 
(http://thread.gmane.org/gmane.linux.scsi/101388/focus=101380) I see 
that the new scsi_dh_alua code keeps track of the target port group 
(TPG) ID and relative target port (RTP) ID. As you know this information 
can be queried for each LUN via the Device Identification VPD page. How 
about caching the TPG and RTP IDs per LUN such that the scsi_dh_alua 
code can figure out which LUNs are associated with which target ports by 
iterating over the known LUNs ?

Thanks,

Bart.
