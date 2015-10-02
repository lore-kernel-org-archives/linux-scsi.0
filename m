From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 15/36] scsi_dh_alua: Make stpg synchronous
Date: Fri, 2 Oct 2015 10:33:46 -0700
Message-ID: <560EBFFA.8010300@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0073.outbound.protection.outlook.com ([157.56.110.73]:9525
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753191AbbJBRdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 13:33:53 -0400
In-Reply-To: <1443523658-87622-16-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> The 'activate_complete' function needs to be executed after
> stpg has finished, so we can as well execute stpg synchronously
> and call the function directly.

Hello Hannes,

Another patch in this series moves invocation of the STPG commands to 
the context of a workqueue. The setup on which I have been testing this 
patch series consists of an initiator system with four ports and a 
target system with eight ports and 100 LUNs. As a result, 4*8*100=3200 
/dev/sd* devices are created on the initiator system and monitored by 
the scsi_dh_alua handler. How many kernel threads will be needed to 
monitor all these paths concurrently and how much memory will be 
required for all these kernel threads ? What if the number of LUNs would 
be even higher, e.g. 1000 ? Sorry but because of scalability concerns my 
preference is that the RTPG and STPG commands are invoked asynchronously.

Thanks,

Bart.
