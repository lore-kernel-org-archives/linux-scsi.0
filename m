From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Remove the shutdown_controller call
Date: Thu, 25 Aug 2011 10:17:42 +0200
Message-ID: <4E560526.5060601@redhat.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com> <1314200130-28890-2-git-send-email-thenzl@redhat.com> <CAHtARFF1iwy2NR1G01hFqBo2hoYxAbG+0DQ0UJNSS3JO_s5qbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1HYIRq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 04:17:46 -0400
In-Reply-To: <CAHtARFF1iwy2NR1G01hFqBo2hoYxAbG+0DQ0UJNSS3JO_s5qbg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org, steve.masters@lsi.com, michael.benz@lsi.com, bo.yang@lsi.com

On 08/24/2011 10:55 PM, adam radford wrote:
> On Wed, Aug 24, 2011 at 8:35 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>> Remove the call to megasas_shutdown_controller in the megasas_shutdown.
> NACK.   The call to megasas_shutdown_controller() should not be removed.
>
> megasas_shutdown_controller() does 3 things:
>
> 1. Cancels pended AEN command in firmware.
> 2. Cancels pended map update command in firmware.
> 3. Fires a MR_DCMD_CTRL_SHUTDOWN to notify firmware there was a clean
> shutdown.  Without this, FW will think there was an 'unclean shutdown'
> on the next restart, which will cause rebuilds and other background FW
> activity to kick on every shutdown/reboot.
OK, from what I have seen the problem happens as a response to MR_DCMD_CTRL_SHUTDOWN
(it means we could let the 1+2 pass and remove only the third point),
but nobody wants 'background FW activity...' etc so let s skip patch.
We need to find a better method for this problem.

In the meantime - I've sent two patches, what do you think about the second one?
It solves(hides) the problem too.
 
Tomas

>
> -Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

