From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: SAI_READ_CAPACITY_16?
Date: Wed, 06 Apr 2005 12:11:50 -0400
Message-ID: <1112803910.2883.50.camel@localhost.localdomain>
References: <60807403EABEB443939A5A7AA8A7458BFF2211@otce2k01.adaptec.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:42491 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262247AbVDFQL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 12:11:57 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BFF2211@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

we tested several iSCSI initiator/target combinations that work with
>2TB devices in current 2.6.11.x kernel.

our experience is that some code only support cdb len 10 or 12. you need
16.

Ming


On Wed, 2005-04-06 at 12:00, Salyzyn, Mark wrote:
> Troubled spoofing back >2TB support in the aacraid driver.
> 
> For some reason, sd_read_capacity (in sd.c) in the 2.6.9-5.EL (RHEL4)
> kernel is not issuing the SERVICE_REQUEST_IN+SAI_READ_CAPACITY_16
> command to the queuecommand handler (the handler is not even called),
> even though it instruments up that the command is issued (and returns
> not supported). The READ_CAPACITY call makes it through successfully
> indicating 0xFFFFFFFF capacity to trigger the SAI_READ_CAPACITY_16
> request fine. Could there be a bug in the scsi layers reissuing commands
> reusing the request structure misdirecting the requests?
> 
> The only changes to the current tree appear to be in the handling of the
> request sense information, so I expect the same behavior from
> latest/greatest.
> 
> Any successes in the current tree with >2TB support being reported by
> the SAI_READ_CAPACITY_16 call?
> 
> Sincerely -- Mark Salyzyn
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

