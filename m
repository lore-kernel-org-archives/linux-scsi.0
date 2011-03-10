From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sd: sd should not modify read capacity, cache type or
 write protect flag on rescan when there is a transport error
Date: Thu, 10 Mar 2011 14:28:58 -0600
Message-ID: <4D79348A.7060609@cs.wisc.edu>
References: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>	 <1298907291.2487.18.camel@mulgrave.site>	 <D8C50530D6022F40A817A35C40CC06A706577BC8AE@DUBX7MCDUB01.EMEA.DELL.COM> <1299594151.2476.10.camel@mulgrave.site> <4D7814D2.8090101@cs.wisc.edu> <D8C50530D6022F40A817A35C40CC06A7065780048F@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52551 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1CJU2t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 15:28:49 -0500
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7065780048F@DUBX7MCDUB01.EMEA.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Menny_Hamburger@Dell.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 03/10/2011 02:49 AM, Menny_Hamburger@Dell.com wrote:
> Mike,
>
> I think there are still two open issues still here:
> 1) Should we always rescan when transport comes back up? My own opinion to this question is that doing a full rescan may be an overkill

I think we should always rescan. The values could have changed on the 
target even if we have not actually sent a command and had it failed, so 
either way we need to pick up new values.

>     In this case. If the decision is not to rescan always (only when we have invalid capacity, cache type, write protect flag), we will need to maintain
>     Additional state information in the device to indicate that the current values are invalid and a rescan is required.
>     James stated that it is a layering violation to test the host byte of the result in order to decide whether or not a rescan is required, so we will
>     need setup this state information in any case of failure when getting these properties from the device.
> 2) Should we rescan from within the kernel, or issue a uevent (hotplug) that would be picked up by userland (that would initiate the rescan)?
>     Rescanning from within the kernel seems a bit more "clean", however there may be other considerations here.

Kernel. In the iscsi and fc class we already do a scan for devices when 
the transport comes back up from the kernel, so this rescan of devices 
values can just run from the same function.
