From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 20:18:32 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03111920183201.15831@naveenb-lnx.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <20031027153932.A16679@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:1660 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S264126AbTKSOpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 09:45:24 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

On Monday 27 October 2003 09:09 pm, Christoph Hellwig wrote:

> iscsi-probe.c:
> 	- the whole iscsi_do_cmnd use looks very very strange.  

After a device gets detected by iSCSI LLD, it uses iscsi_do_cmnd to send scsi 
commands to that device even before registering it with the scsi mid-layer.
 
For example user can configure in iscsi LLD configuration (iscsi.conf) file 
what various LUNs of a particular target needs to be activated. To acheive 
this we need to execute REPORT LUN command on target, to find out what 
various luns are present and selectively issue scsi_add_device for luns that 
needs to be activated.

>          you're probably
> 	much better of to use the scsi_request based interfaces and use midlayer
> 	queueing and sometimes even higher level interfaces

All these interfaces requires scsi_device instance which implies that device 
must be registered with the scsi mid-layer,  before using these interfaces. 

Naveen.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

