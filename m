From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sd: sd should not modify read capacity, cache type or
 write protect flag on rescan when there is a transport error
Date: Wed, 09 Mar 2011 18:01:22 -0600
Message-ID: <4D7814D2.8090101@cs.wisc.edu>
References: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>	 <1298907291.2487.18.camel@mulgrave.site>	 <D8C50530D6022F40A817A35C40CC06A706577BC8AE@DUBX7MCDUB01.EMEA.DELL.COM> <1299594151.2476.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34934 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1CJABO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2011 19:01:14 -0500
In-Reply-To: <1299594151.2476.10.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Menny_Hamburger@Dell.com, linux-scsi@vger.kernel.org

On 03/08/2011 08:22 AM, James Bottomley wrote:
> On Tue, 2011-03-08 at 09:30 +0000, Menny_Hamburger@Dell.com wrote:
>> Another totally different way may be to have the SCSI layer send some
>> notification (unknown property, needs rescan) that could be picked up
>> and handled by the transport layer.
>
> This is the hotplug I suggested, isn't it?
>

Yeah.

Menny, I think you can just do the scsi/iscsi_rescan_target option I 
suggested in my pseudo patch where when the transport comes back online 
the iscsi class calls some helper scsi function that calls 
scsi_rescan_device for each device on the target, so proper values are 
picked up.
