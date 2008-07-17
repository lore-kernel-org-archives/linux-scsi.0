From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: bidi support: FC transport layer...
Date: Thu, 17 Jul 2008 06:57:31 -0700
Message-ID: <3C744A97-F780-41BD-A077-86450263A06B@qlogic.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com> <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com> <C9F1A1B1-136B-4EE0-8F64-8EE5DF04E5B6@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EF7B@xbl3.ma.emulex.com> <B8532D23-197D-4C8E-A08C-6081DBDEE6DF@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:45087 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbYGQN5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2008 09:57:34 -0400
In-Reply-To: <B8532D23-197D-4C8E-A08C-6081DBDEE6DF@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jul 16, 2008, at 10:53 AM, Seokmann Ju wrote:

>
> On Jul 15, 2008, at 12:35 PM, james.smart@emulex.com wrote:
...
>>
>> Agreed - for the basic part.  However, you're still under the  
>> assumption
>> that SAS
>> enumerated everything.  Given that some SAS parts could perform
>> discovery on it's
>> own, with the LLDD interacting with the transport just enough to
>> enumerate what it
>> found useful, this may not always be the case. Additionally, there
>> aren't a lot
>> of other "protocols" or "port roles" that exist in SAS - but there  
>> are
>> in FC.
> I see..
> There are a couple of more roles have defined in the rports besides
> FC_RPORT_ROLE_FCP_TARGET.
>
>>
>>
>> The more interesting part is to those things (switch services, non- 
>> FCP
>> targets)
>> that the driver did not enumerate.  We should allow the directed
>> enumeration of them
>> to perform some basic diagnostics or san queries.  And once you have
>> this,
>> we can really open some interesting doors - why not an app that talks
>> FICON ? or
>> something that just message passes between 2 ports ? and so on...
> OK.
>
> Overall, I guess that having a device file under the sysfs for the
> given port of the HBA should be the approach we need to pursue, then.
> And single device file per each port on the instantiated HBA is also
> be the case, I think.
> For the approach, following are kind of questions that came to me,
> 1. tte driver has to maintain some sort of table of
> the all end ports, and identify one from the table with some index or
> opaque data provided by the application for a given FC-CT/ELS pkt.
> 2. Overall implementation framework should be similar to the one for
> SMP in the SAS transport.
I just wanted make sure that I've delivered clear communication.
Please let me know otherwise.

And now, I've got a couple of more questions on the approach.
1. Should the device file created per instantiate HBA, or per port on
  the HBA?
    I think it should be per port base, for example, when 2-ports HBA
  detected, we will create 2 device for the HBA.
2. Should we worry about the 4KB size limit?
    I've heard that sysfs attribute has limited size of data it can
   transport at one time and that is 4KB.

Thank you,
Seokmann



>
>
> Thank you,
> Seokmann
>>
>>
>> -- james
>>
>>
>>
>

