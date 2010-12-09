From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Is it possible to issue device reset to PMC PM8388 expander using
 sg3_utils or smp_utils?
Date: Thu, 09 Dec 2010 15:53:33 -0500
Message-ID: <4D0141CD.60801@interlog.com>
References: <4D0122BC.8060501@aeoncomputing.com> <1291921192.3002.339.camel@mulgrave.site> <4D012872.2000505@aeoncomputing.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58609 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0LIUxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 15:53:39 -0500
In-Reply-To: <4D012872.2000505@aeoncomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-scsi@vger.kernel.org

On 10-12-09 02:05 PM, Jeff Johnson wrote:
> On 12/9/10 10:59 AM, James Bottomley wrote:
>> On Thu, 2010-12-09 at 10:41 -0800, Jeff Johnson wrote:
>>> Greetings,
>>>
>>> Is it possible to issue a low level device reset to a PMC-Sierra PM8388
>>> 24x3G SAS expander using either sg3_utils or smp_utils?
>>>
>>> I am able to enumerate and read the status of the phys on the PM8388,
>>> read end device information, etc. I tried sg_reset and it does a bus
>>> reset but not an expander reset.
>>>
>>> Technical documentation on the PM8388 is not readily available so I do
>>> not know if it has a mode select bit or other special method to get the
>>> expander to reset itself.
>>>
>>> I am looking for an inband method to reset the expander to clear a
>>> condition where some phys in a wide connection fail to link. A power
>>> cycle clears the condition and I am looking to mimic a power cycle by
>>> bouncing the expander at the lowest level possible via the SAS host
>>> connection.
>> There's no protocol defined way to reset an expander using SMP
>> functions, so it's not really possible to do it in-band. It's sort of
>> like asking if there's an ethernet packet you can send to a switch to
>> cause it to reset.
>
> Now that would be fun.... =)
>
>> If the wide port isn't forming, you could try doing a hard reset of all
>> the phys in the port.
>
> I have tried that from the hba side using lsiutil and it did not clear the
> condition. I will try the expander phys and see if the result is any better.
>
> When the wide port fails to form the error I see on the three phys that fail to
> link (from the PM8388 exp side) is "sspl reg trigger error"

You might be able to (link or hard) reset some or all
of the phys (hence what they are attached to) in the
expander with smp_phy_control.

First you need to work out how you can talk to the
expander (using SMP). smp_rep_manufacturer and
smp_rep_general may be useful for sorting that out.

Doug Gilbert

