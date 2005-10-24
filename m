From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Tue, 25 Oct 2005 08:27:04 +1000
Message-ID: <435D5FB8.7000407@torque.net>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org> <435B5C15.5070106@s5r6.in-berlin.de> <435B8CC9.5000600@s5r6.in-berlin.de> <435BBF05.6010109@pobox.com> <435D0B5B.7010706@adaptec.com> <435D3E07.5050709@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:12509 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751352AbVJXW0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:26:00 -0400
In-Reply-To: <435D3E07.5050709@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>

Stefan Richter wrote:
> Luben Tuikov wrote:
> 
>> On 10/23/05 12:49, Jeff Garzik wrote:
>>
>>> Stefan Richter wrote:
>>>
>>>>                sprintf(s+2*i, "%02x", lun.scsi_lun[i]);
>>>
>>>
>>> There is obviously room for improvement.  Any naive representation is
>>> sub-optimal, be it for small luns (my current code) or larger luns
>>> (your example).
>>>
>>> For situations with smaller luns, we should probably continue to use
>>> the current scsilun_to_int() conversion, while using your example for
>>> larger luns, i.e.
>>>
>>>     if (upper 4 bytes zero)
>>>         scsilun to int
>>>         printk %d
>>>     else
>>>         for each byte
>>>             printk %x
>>>
>>> But Douglas's code suggested that if we are more motivated, we could
>>> provide an even better representation.
> 
> 
> A plain, non-interpreted representation should suffice. Compact but
> easily parseable, i.e. uniform.
> 
>> If a LUN is u8[8], then,
>>
>> #define SAS_ADDR(_sa)   ((unsigned long long) be64_to_cpu(*(__be64
>> *)(_sa)))
>>
>> "%016llx", SAS_ADDR(LUN)  prints it like this (e.g.):
>>
>> sas: 5000c50000513329 probing LUN:0000000000000000
>> sas: device 500000e000031c12 LUN: 0000000000000000 powering up or not
>> ready yet, sleeping...
>> sas: 500000e000031c12 probing LUN:0000000000000000
>> sas: device 50001c171601060d LUN: 0000000000000000 powering up or not
>> ready yet, sleeping...
>>
>> This is from drivers/scsi/sas/sas_discover.c.
>>
>>     Luben
> 
> 
> What about an 64bit integer as carrier of LUN in the first place? The
> most frequent occurrence of LUN data is when it is passed through in
> function calls but it seems rarely to be manipulated.
> 
> --- linux/include/scsi/scsi.h.orig      2005-10-20 08:23:05.000000000 +0200
> +++ linux/include/scsi/scsi.h   2005-10-24 21:45:41.000000000 +0200
> @@ -238,9 +238,7 @@
>  /*
>   * ScsiLun: 8 byte LUN.
>   */
> -struct scsi_lun {
> -       __u8 scsi_lun[8];
> -};
> +typedef __be64 scsi_lun;

Stefan,
IMO it is very important to keep luns as __u8[8]. Lots
of different lun conventions map into that array, almost
all of which would look horrible viewed as hex or
decimal integers. For example SCSI-2 luns (embedded
in cbds) run from 0 to 7 and map (in hex) to:
  00 00 00 00 00 00 00 00
  00 07 00 00 00 00 00 00

Just like a SCSI cdb, to decode a lun, first one needs
to examine scsi_lun[0], then depending on ... . As
you are no doubt aware, the only current transport
defined to have 2 byte luns is sbp-2/sbp-3 and it is
obvious what those 2 bytes will be: scsi_lun[0] and
scsi_lun[1].

Generic target+initiator (port) identifiers in SAM
(see sam4r03.pdf Annex A) should also be a sequence of
bytes (not an integer). iSCSI seems to be the limiting
case with up to 241 (utf-8) bytes. Linux may want to keep
its enumerating "id" integer, in which case a mapping
should be visible (as SDI does).

Doug Gilbert
