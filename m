From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Tue, 13 Apr 2010 23:23:53 +0400
Message-ID: <4BC4C4C9.70103@vlnb.net>
References: <4BB45632.5020700@suse.de> <4BC099C5.9090704@vlnb.net>	 <4BC431C8.9020800@suse.de>  <4BC4A559.4090806@vlnb.net> <1271183865.32337.39.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0DMTX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 15:23:56 -0400
In-Reply-To: <1271183865.32337.39.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Nicholas A. Bellinger, on 04/13/2010 10:37 PM wrote:
> On Tue, 2010-04-13 at 21:09 +0400, Vladislav Bolkhovitin wrote:
>> LIO doesn't support 1 to many pass-through devices sharing, so SCST in 
>> the only option.
> 
> Sorry, but this statement about your perceived limitiations wrt TCM/LIO
> is completely incorrect.
> 
> Using a single passthrough backstore device (eg: plain /dev/sdX) with
> TCM/pSCSI (or any TCM subsystem plugin) has been supported since the
> dawn of time to allow for any number of TCM_Loop Virtual SAS Ports with
> SG_IO going into KVM Guest.  The same is also true for LIO-Target
> (iSCSI) and TCM_FC (FCoE) ports as well regardless of TCM subsystem
> backstore.
> 
> Perhaps you would be so kind to provide a TCM/LIO source code reference
> from where you came up with this make-believe notion..?

I've just rechecked with the latest 
git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git and 
still wasn't able to find in LIO required pieces of functionality to 
support 1 to many pass-through. I see only code for non-enforced 1 to 1 
pass-through (single initiator only). You can use with it more 
initiators only as the SCSI violation, from pointing on which I started 
my participation in this discussion.

Particularly, I can't see the code, which in pass-through mode upon 
receive of RESERVE command sends it also to the backend device, if 
necessary (i.e. only the first time), and then sends RELEASE command to 
the device upon the reservation holder removal. Could you point me on 
the *exact* code which implements that?

Vlad
