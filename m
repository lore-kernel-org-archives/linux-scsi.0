From: Thomas Georgiou <tageorgiou@gmail.com>
Subject: Re: QLA2200 causes kernel bug
Date: Fri, 7 Aug 2009 15:19:03 -0400
Message-ID: <6e4c20e70908071219v56f52c2te3b331a229fe9706@mail.gmail.com>
References: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com>
	 <20090806164925.GO2453@plap4-2.local>
	 <6e4c20e70908061012y3fa907aduca4f706cf5ccaa5a@mail.gmail.com>
	 <6e4c20e70908062040x39d8d0b3p90e674ec5925c5ac@mail.gmail.com>
	 <20090807070147.GA13292@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:38665 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbZHGTTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 15:19:04 -0400
Received: by yxe5 with SMTP id 5so2246021yxe.33
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2009 12:19:04 -0700 (PDT)
In-Reply-To: <20090807070147.GA13292@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I am not sure what is happening at 1840.

The current topology is royal (the machine in this backtrace)
connected via 2 fibre channel connections directly to a Powervault
224F jbod.  This is then connected via 2 connections again to another
224F, which is then connected to another machine, fiord (which also
has had problems).

I had royal connected to one 224f with 2 connections and did not
connect that jbod to anything else, and it worked with no problems for
the time it was connected like that (2 days).

I have also tried connecting fiord and royal to two powervault 51f
switches in a redundant configuration and then the switches to the
224Fs.  This also generated problems and was where most of the
backtraces in the bug reports came from.

I have set qlport_down_retry=3D1 for faster failover.  Should I unset
it?  A constant stream of RESETs is not expected.

On Fri, Aug 7, 2009 at 3:01 AM, Andrew Vasquez<andrew.vasquez@qlogic.co=
m> wrote:
> Could you let me know what's going on at timestamp - 1840:
> there's seems to be a great deal of fabric disruptions occuring on th=
e
> fibre. =A0This seems to be occurring on both 22xx ports. =A0It also
> appears that you've set port-down-timeout (dev-loss-tmo) to 0 seconds
> (for faster failovers)?
>
> Could you describe the topology? =A0Would it be possible to isolate t=
he
> faults, I take it the constant stream of RESETs are not expected?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
