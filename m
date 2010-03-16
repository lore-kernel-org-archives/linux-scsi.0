From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_transport_fc: Initialize sysfs attributes with sysfs_attr_init
Date: Tue, 16 Mar 2010 15:48:59 -0500
Message-ID: <4B9FEEBB.8090809@cs.wisc.edu>
References: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39476 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0CPUpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2010 16:45:33 -0400
In-Reply-To: <20100316101453.GA9734@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 03/16/2010 05:14 AM, Christof Schmitt wrote:
> With the new lockdep tracking in sysfs, sysfs_attr_init has to be used
> for initializing all non-static sysfs attributes. Otherwise, lockdep
> will warn about the missing initialization with:
>
> Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae350 not in .data!
> Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae388 not in .data!
> Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3c0 not in .data!
> Mar 15 09:19:49 t6345029 kernel: BUG: key 000000002f5ae3f8 not in .data!
>

I think iscsi needs this too, but I am not see this error message. I 
just tried iscsi and fc/lpfc with linus's tree and did not see those 
errors for either. What .config settings do I need for this? I have:

CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

are there other lockdep settings?
