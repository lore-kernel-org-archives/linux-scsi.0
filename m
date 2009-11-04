From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 17:55:09 +0100
Message-ID: <4AF1B1ED.1090104@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM> <4AF1A2F0.7060201@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:36738 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZKDQzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:55:07 -0500
In-Reply-To: <4AF1A2F0.7060201@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

John Hughes wrote:
> Attempts to change the "status" fail:
>
> # echo "unconfigured" > status
> [  626.389093] general protection fault: 0000 [#1] SMP [  626.389243] 
> last sysfs file: /sys/class/enclosure/0:0:32:0/0/status
This bug still exists in 2.6.32-rc6.

It's pretty crazy - if we use a legal value then the routine correctly 
returns -EINVAL as there is no setter.

If we write an illegal value to status we get an oops!

Aha!  It's because the enclosure_status array is not NULL terminated, so 
if we try to write an illegal value we run off the end of the array!



