From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Fri, 16 Sep 2005 15:53:30 -0500
Message-ID: <432B30CA.7000907@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACB6@SRMANNING.eng.emc.com>
	<432B2A71.6020305@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <432B2A71.6020305@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> goggin, edward wrote:
> 
>> Mike,
>>
>> I don't think it is reasonably possible to anticipate
>> all possible parsing requirements for the asc and ascq
>> portions of SCSI sense information across all device
>> models.  I'm in favor of having a "small" framework in
>> SCSI where a SCSI sense interpreter module (per
>> vendor & model possibly) could be registered
>> dynamically, by dm-emc.c for instance.
> 
> 
> Yeah I agree, I mentioned this before in some other mails. I think a 
> module versus some table that userspace could write to were discussed.
> 
> The BLKERR values were meant to be able to tell upper layer code whether 
> a transport or device or driver error occured and whether the lower 
> level thought it was retryable. But then I thought I could also wedge in 
> the handling of the vendor specifcs by adding a vendor specific SCSI 
> module that would map the their specific value to a BLKERR_* one. And as 
> I said offlist it is not working perfectly becuase we are losing some 
> information in the translations.
> 

Oh yeah so the problem I am having is emc boxes may return "LUN Not 
Ready - Manual Intervention Required". When dm-emc.c sees this error it 
wants to bypass a group of paths and retry the IO but under ceratin 
conditions not fail those paths. So I am not sure what to return for 
this error. I thought if I redo my BLKERR so they describe the error like

BLKERR_DEV_NOT_READY
BLKERR_MANUAL_INTERVENTION_REQ
BLKERR_NOT_CONN

... and set them up as a bitmap like suggested by JamesB. I could return
BLKERR_MANUAL_INTERVENTION_REQ from a scsi module then have dm-emc.c 
evaluate that value to a dm-mpaths return value of "MP_BYPASS_PG | 
MP_RETRY_IO" which means bypass the priority group (group of paths) and 
retry the IO.

But as more vendors use dm and they cannot use existing BLKERR values I 
have to add more and more. And then we have to handle the case where 
some block layer code may return BLKERR_MANUAL_INTERVENTION_REQ for 
something not related to the reasons EMC's HW was returning "LUN Not 
Ready - Manual Intervention Required" and we end up with getting things 
wrong.
