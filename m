From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: bidi support: FC transport layer...
Date: Wed, 16 Jul 2008 10:53:47 -0700
Message-ID: <B8532D23-197D-4C8E-A08C-6081DBDEE6DF@qlogic.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EE27@xbl3.ma.emulex.com> <77DD6D0A-346F-4797-B05D-C3C24EAD290E@qlogic.com> <C9F1A1B1-136B-4EE0-8F64-8EE5DF04E5B6@qlogic.com> <D1D4C3FF75F9354393DB8314DF43DEF2E7EF7B@xbl3.ma.emulex.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:16613 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYGPRxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 13:53:50 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7EF7B@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com


On Jul 15, 2008, at 12:35 PM, james.smart@emulex.com wrote:

>
>> -----Original Message-----
>> From: Seokmann Ju [mailto:seokmann.ju@qlogic.com]
>> Sent: Tuesday, July 15, 2008 2:55 PM
>> To: Smart, James
>> Cc: linux-scsi@vger.kernel.org; Andrew Vasquez
>> Subject: Re: bidi support: FC transport layer...
>>
>> From the code walk-through, for the SAS SMP case, the
>> transport layer
>> create
>> a file under sysfs per each device detection, which is former case.
>> Could you elaborate why we have to "temporarily create object X and
>> destroy"?
>
> Well - as long as you are only going to talk to what the driver  
> exports,
> ok...
>
> But, what if I want to talk to a Fabric Service or Switch entity the
> driver
> doesn't typically log into or stay logged into ?  Or what if I want to
> talk
> to another FCP initiator (not FCP traffic, but rather just ELS's/CT
> traffic)
> or want to talk to a non-FCP port, but the driver only enumerated the
> rports
> associated with FCP Targets ?  Or what if I just want to FC-Ping some
> random
> FC address ?
Just for my learning, should this (FC-ping the random FC address) case
also be covered by the implementation?

>
>
> Somehow we have to make the driver/transport enumerate the device that
> we
> want to talk to.  Along with this, I'm assuming the driver has to
> initiate/do
> the basic PLOGI to the other address, and be told when to tear it  
> down.
>
> Another part I don't like about the "create a file for each  
> enumeration"
> is,
> we rarely use these files. If the SAN is big, the system has lots of
> adapters,
> and so on, why make the system allocate/maintain/etc all of these  
> things
> that
> are rarely used ? When you start enumerating per phy, and with logical
> entities
> layering on top of the physical thingies, it can really grow. At what
> point does
> SGIO run out of dev_t space ?  Consider that we are enumerating many
> adapters in
> an enterprise system; and on the physical level down to phys, and
> everything
> on the transport such as expanders and phys on expanders and targets  
> and
> luns;
> and add in virtualization such as NPIV or VSANs, each with potentially
> large
> san connectivity and their own large trees of these things...
> Does SGIO actually scale ?
The kernel specifies max. as 32768.
~/block/gsg.c:BSG_MAX_DEVS	32768

It is not enough for 1.6 M max ports, clearly.
I'm just thinking that how the 32768 is small practically.

>
>
>> In general, I've been walking through the code to figure out overall
>> design
>> and implementation details about SAS SMP handling.
>> 1. when each of target device detected, a request_queue for the  
>> device
>>  allocated/associated to it.
>> 2. each of device gets device file under sysfs and the device file is
>>  used to send SMP via bsg and the packets get serviced in
>> the nature of
>>  bidi.
>>
>> I also think it should be safe to implement FC-CT/ELS support in the
>> manner similar to the SAS SMP.
>> Please let me know for any other missing pieces.
>
> Agreed - for the basic part.  However, you're still under the  
> assumption
> that SAS
> enumerated everything.  Given that some SAS parts could perform
> discovery on it's
> own, with the LLDD interacting with the transport just enough to
> enumerate what it
> found useful, this may not always be the case. Additionally, there
> aren't a lot
> of other "protocols" or "port roles" that exist in SAS - but there are
> in FC.
I see..
There are a couple of more roles have defined in the rports besides
FC_RPORT_ROLE_FCP_TARGET.

>
>
> The more interesting part is to those things (switch services, non-FCP
> targets)
> that the driver did not enumerate.  We should allow the directed
> enumeration of them
> to perform some basic diagnostics or san queries.  And once you have
> this,
> we can really open some interesting doors - why not an app that talks
> FICON ? or
> something that just message passes between 2 ports ? and so on...
OK.

Overall, I guess that having a device file under the sysfs for the
given port of the HBA should be the approach we need to pursue, then.
And single device file per each port on the instantiated HBA is also
be the case, I think.
For the approach, following are kind of questions that came to me,
1. tte driver has to maintain some sort of table of
  the all end ports, and identify one from the table with some index or
  opaque data provided by the application for a given FC-CT/ELS pkt.
2. Overall implementation framework should be similar to the one for
  SMP in the SAS transport.

Thank you,
Seokmann
>
>
> -- james
>
>
>

