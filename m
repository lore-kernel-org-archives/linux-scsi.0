From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/4] be2iscsi : Fix the retry count for boot targets
Date: Tue, 16 Dec 2014 10:53:00 -0600
Message-ID: <5490636C.5050706@cs.wisc.edu>
References: <0cb35f54-b286-4416-971f-b0fd9d389ce7@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49133 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaLPQxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2014 11:53:09 -0500
In-Reply-To: <0cb35f54-b286-4416-971f-b0fd9d389ce7@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Minh Tran <minhduc.tran@Emulex.Com>, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 12/16/14, 8:33 PM, John Soni Jose wrote:
> +#define GET_BOOT_RETRIES	45
> +#define GET_BOOT_TO		20
>   /**

Does beiscsi_get_boot_info() succeed when the fw is able to log into the 
target (go into iscsi full feature phase) or just able to reach it (ICMP 
ping the port or something like that)? It was not clear why the above 
values were selected. Was it meant to detect when the target could be 
down for extended periods due to something like maintenance or a reboot, 
or is just handling some shorter settle period where the link is up but 
the fw could not reach the target port due to needing to do some other 
network setup.

Also, I think you want to add some sort of BEISCSI or at least BE prefix 
to the names to avoid collisions since they are pretty generic.
