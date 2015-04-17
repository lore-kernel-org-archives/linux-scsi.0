From: Suman Tripathi <stripathi@apm.com>
Subject: Re: ahci Port to Host interrupt as edge trigger
Date: Fri, 17 Apr 2015 22:39:25 +0530
Message-ID: <CAOHikRBpoc+2zSUn23V3i_0JnvLtTAFQsjfDLdx70c2WLWs8fA@mail.gmail.com>
References: <CAOHikRCrbKhchHM71KPUUxSw7107ZWpBCbmTHsSSqSbUdCLJyg@mail.gmail.com>
	<20150417144235.GB1954@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:51160 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932194AbbDQRJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 13:09:27 -0400
Received: by wgin8 with SMTP id n8so119540495wgi.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2015 10:09:25 -0700 (PDT)
In-Reply-To: <20150417144235.GB1954@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Loc Ho <lho@apm.com>

> Hi ,
>
> I need some suggestion .
>
> From the below interrupt handler in libahci.c it explains that the
> interrupt from port to Host is level  triggered. Do we have any
> existing implementation that handles the port to Host as Edge
> triggered.

Not that I know of but if it works as a edge triggered latch, would it
need anything done different?

 We met a scenario which explains the below :

1. PxIS0 raised set to 1 and Host IS detects a level . After some
interval PxIS1  raised and Host IS  detects a level and interrupt
service routine clear and it work. This is as per the libahci
implementation

2. PxIS0 set to 1 and Host IS detects a edge . After some interval
PxIS1 raised and Host IS detects a edge but ISR  implementation is
level trigger so it looses interrupts.  Was asking about this scenario
??

On Fri, Apr 17, 2015 at 8:12 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 17, 2015 at 04:22:17PM +0530, Suman Tripathi wrote:
>> Hi ,
>>
>> I need some suggestion .
>>
>> From the below interrupt handler in libahci.c it explains that the
>> interrupt from port to Host is level  triggered. Do we have any
>> existing implementation that handles the port to Host as Edge
>> triggered.
>
> Not that I know of but if it works as a edge triggered latch, would it
> need anything done different?
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
