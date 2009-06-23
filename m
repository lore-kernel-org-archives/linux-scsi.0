From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: How To Get WWN and Device Mapping
Date: Tue, 23 Jun 2009 11:51:31 -0700
Message-ID: <E91498F0-E2A5-4594-BC24-0263A07EB661@qlogic.com>
References: <D9D8963FC28A1C49BBF5EE152BE9763601278B8276@CBA0EXBE01.CBA0.centerbeam.com> <1245457284.12515.13.camel@mulgrave.site> <D9D8963FC28A1C49BBF5EE152BE9763601285D36A8@CBA0EXBE01.CBA0.centerbeam.com> <4A41221D.502@interlog.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33634 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZFWSv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2009 14:51:29 -0400
In-Reply-To: <4A41221D.502@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "Paul Lung (paul.lung@loglogic.com)" <Paul.Lung@loglogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

cat /sys/class/fc_remote_ports/rport-x:x-x/port-name will get you the  
information.

Thanks,
Giridhar.M.B


On Jun 23, 2009, at 11:42 AM, Douglas Gilbert wrote:

> Paul,
> Does 'lsscsi -tL' give you what you want in the
> node_name entry?
>
> That is for the target, 'lsscsi -tHL' would be for
> the initiator.
>
> Doug Gilbert
>
>
> Paul Lung (paul.lung@loglogic.com) wrote:
>> Hi James,
>>
>> Thank you for the reply. I'm actually looking for the WWN. The  
>> reason is I want to setup multipath, and for that I would want to  
>> know which mapped devices on my linux box actually point to the  
>> same disk. The disk array I'm using for multipath has two  
>> controllers, and therefore two WWPNs. So using WWPN would not work  
>> for this purpose.
>>
>> Paul Lung
>>
>> -----Original Message-----
>> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
>> Sent: Friday, June 19, 2009 5:21 PM
>> To: Paul Lung (paul.lung@loglogic.com)
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: How To Get WWN and Device Mapping
>>
>> On Fri, 2009-06-19 at 16:54 -0700, Paul Lung (paul.lung@loglogic.com)
>> wrote:
>>> Hi,
>>>
>>> I'm using 2.6.25.14 kernel with the qla2xxx driver turned on for a
>>> SAN, and I tried to use SCLI from QLogic to get the linux device- 
>>> >wwn
>>> mapping. However, SCLI does not seem to be able to detect any LUNs
>>> with the driver in 2.6.25 kernel.
>>
>> You'll need to ask qlogic about their tools.
>>
>>> I then found that doing a scsi_id on a device(say, ./block/sde)   
>>> will
>>> give me the wwn, with an extra number in the front.
>>
>> man scsi_id will tell you what this is and why it's there.
>>
>>> However, further research seems to indicate that scsi_id does not
>>> always give back the wwn. It's is totally dependent on the physical
>>> device being queried.
>>
>> For WWN this is true ... the device must export it properly via the
>> correct VPD inquiry for it to be displayed ... although most fibre
>> devices do nowadays.
>>
>>> So, is there any way to reliably get the WWN of a linux device? The
>>> qla2xxx driver must have gotten the wwn of all the drives on the  
>>> SAN.
>>> Is this information "published" anywhere?
>>
>> I think you're confusing WWN and WWPN ... it's the latter the fibre  
>> has
>> to know. If it's the WWPN you're after, it's the fc_transport  
>> port_name
>> attribute (either of the rport or the target).
>>
>> James
>>
>>
>>> Thank you very much for your time.
>>>
>>> Paul Lung--
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
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

