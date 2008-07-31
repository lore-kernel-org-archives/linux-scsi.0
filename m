From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: aacraid and S.M.A.R.T
Date: Thu, 31 Jul 2008 10:47:33 -0400
Message-ID: <4F4EA7EA-60E1-4CDC-B03F-7FC2AD9980A7@adaptec.com>
References: <20080730235450.0fcc21a6.sam@home.se> <EC1C30B3-9ED0-4A8B-90FE-F4AB25FF5E7A@adaptec.com> <4891C69E.9000106@torque.net>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:42882 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYGaOri (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 10:47:38 -0400
In-Reply-To: <4891C69E.9000106@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dougg@torque.net" <dougg@torque.net>
Cc: Martin Samuelsson <sam@home.se>, Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Jul 31, 2008, at 10:05 AM, Douglas Gilbert wrote:

> Mark Salyzyn wrote:
>> aacraid driver is not the emulation. The Firmware itself has a SAT  
>> 0.9
>> translation layer to the raw SATA drives at the physical transport,  
>> the
>> Firmware then deals with all the targets as SCSI representations.
>
> Mark,
> Is that SAT interface at the physical transport accessible
> to something like smartmontools?

YES, that is the whole reason we added the physical access via /dev/ 
sg* in the driver!!!

You may have to do a '-d ata', the patch to smartmontools to automate  
this for SATA devices was not approved by Adaptec. SAS drives work.

> "SAT 0.9 transport layer" does not correspond to any t10 numbering.
> Is the "0.9" meant to imply that the implementation is just
> shy of compliance to the SAT-1 standard? [Perhaps a version
> descriptor in the INQUIRY response answers my question.]

Yes, officially shy of compliance ... but unofficially enhanced when  
needed when compliance issues have come up (translation: 0.9+) in  
Adaptec or OEM Q/A. The team responsible for the SAT layer was VERY  
risk averse when it came to making any changes even when introducing a  
new released card, so this level is true of old and new cards today.

> Doug Gilbert

Sincerely -- Mark Salyzyn

FYI, my last day of in-office employment with Adaptec is August 8, aacraid@adaptec.com 
  for driver support will continue to be answered by the team (I may  
continue at my discretion or at the hands of my new employer <shrug>)

>> SMART was supposed to be emulated, but on that old card it was never
>> tested ... make sure you have the latest Firmware on the card just in
>> case something got fixed ...
>>
>> Sincerely -- Mark Salyzyn
>>
>> On Jul 30, 2008, at 5:54 PM, Martin Samuelsson wrote:
>>
>>> Hello list,
>>>
>>> I have an old Adaptec 2610SA SATA RAID controller with six disks. As
>>> I'm a bit curious, I'd like to know, for example, the temperature  
>>> they
>>> report. (afacli can't report those, and I suspect aaccli can't  
>>> either)
>>> It seemed utterly impossible until I saw the expose_physicals module
>>> option, but after switching that on, I can at least see traces of  
>>> the
>>> individual disks.
>>>
>>> If I understand it correctly, aacraid provides an emulation layer
>>> between what I see and the physical disks, passing known commands  
>>> and
>>> responses back and forth. However, S.M.A.R.T commands doesn't seem  
>>> to
>>> be among those known ones, is that correct?
>>>
>>> I'm running CentOS 5 with kernel 2.6.18, which is kind of old. Would
>>> running a spanking new kernel make me happier and support reading  
>>> the
>>> temperature from the individual disks?
>>>
>>> Regards,
>>> /Sam
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux- 
>>> scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>

