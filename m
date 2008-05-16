From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Fri, 16 May 2008 11:53:21 -0700
Message-ID: <1210964001.21974.351.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53985 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762808AbYEPSvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2008 14:51:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4GIpaJQ015964
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:51:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4GIpX0x150620
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:51:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4GIpWQx017482
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2008 14:51:33 -0400
In-Reply-To: <482C0676.9070004@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>


On Thu, 2008-05-15 at 11:46 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > What is the purpose of this feature ?
> > 
> > With dh_state functionality, one could associate a handler to a new
> > device and then if one does "multipath", the hardware handler would be
> > associated with the multipath device. What are we achieving by this ?
> > 
> This allows multipath to override the device tables build into
> the device handler. Reason here is that multipath has a configuration
> file which allows the user to override the build-in defaults.
> And this includes the hardware handler, so we need to make sure that
> the hardware handler is indeed attached.

Hardware handler's existence is currently been verified during parsing
(by doing a request_module() followed by scsi_dh_handler_exist() in
parse_hw_handler()).

Hardware handler module is attached to the device itself (thru
try_module_get() in attach), so, the module will exist as long as the
device exists.

Hence, there is no need to attach it again from the multipath layer.

Or, I am missing something totally :)

<snip>


