From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/7] qla4xxx: added BSG support
Date: Tue, 11 May 2010 10:51:10 -0500
Message-ID: <4BE97CEE.8060404@cs.wisc.edu>
References: <20100511075526.GA30474@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43663 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0EKPuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2010 11:50:14 -0400
In-Reply-To: <20100511075526.GA30474@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

I think we need James's comments on this one. I am not sure what is right.

On 05/11/2010 02:55 AM, Vikas Chaudhary wrote:
> This BSG interface is on top of patch :
> http://marc.info/?l=linux-scsi&m=126884917217355&w=2
>


All I want to be able to do is allow any app to be able to config any 
iscsi cards. I want to support Qlogic apps, but then I also want to 
support iscsiadm, virt tools, installers, boot tools, etc.


> +	case ISCSI_BSG_HST_VENDOR:
> +		rval = qla4xxx_process_vendor_specific(job);
> +		break;


I like the idea of allowing you to use the ISCSI_BSG_HST_VENDOR for all 
your commands, because it makes the kernel code so very very simple. If 
you guys can provide a userspace gpl friendly lib or plugin to a lib 
like IMA that allows distros tools to manage your card, then I am happy 
with this approach.

My concern with this is that, it takes you guys so long to get things 
out. We have no idea when or if it will ever be done.


> +	case ISCSI_BSG_HST_NET_CONFIG:
> +		printk(KERN_ERR "ISCSI_BSG_HST_NET_CONFIG Commands "
> +		    "NOT Supported\n");
> +		rval = -ENOSYS;
> +		break;

OTOH, I like the idea of ethtool like interface where for common 
operations there is a command command. Then the driver takes that 
info/cmd and does its vendor specifics.


James, someone mentioned that in the past you might have said it is ok 
to pass blobs around if it gets passed down directly to hardware. This 
is the case for qla4xxx here. Is it ok to let them just use the 
HST_VENDOR command?
