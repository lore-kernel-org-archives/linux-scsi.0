From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: Re: [PATCH] Eliminate extra 'out_free' label from fcoe_init function
Date: Fri, 2 Jun 2017 18:03:38 +0530
Message-ID: <fefc51f4-62fa-57b8-09de-271dc10bd682@redhat.com>
References: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
 <20170601150233.2j6lxormywlvu7fa@mwanda>
 <e318d328-71f4-5212-c697-f71e5c77b660@redhat.com>
 <alpine.DEB.2.20.1706020748480.2312@hadrien>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1706020748480.2312@hadrien>
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 06/02/2017 11:19 AM, Julia Lawall wrote:
> 
> 
> On Fri, 2 Jun 2017, Milan P. Gandhi wrote:
> 
>> On 06/01/2017 08:32 PM, Dan Carpenter wrote:
>>> On Thu, Jun 01, 2017 at 05:41:06PM +0530, Milan P. Gandhi wrote:
>>>> Simplify the check for return code of fcoe_if_init routine
>>>> in fcoe_init function such that we could eliminate need for
>>>> extra 'out_free' label.
>>>>
>>>> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
>>>> ---
>>>>  drivers/scsi/fcoe/fcoe.c | 10 ++++------
>>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>>>> index ea21e7b..fb2a4c9 100644
>>>> --- a/drivers/scsi/fcoe/fcoe.c
>>>> +++ b/drivers/scsi/fcoe/fcoe.c
>>>> @@ -2523,13 +2523,11 @@ static int __init fcoe_init(void)
>>>>  	fcoe_dev_setup();
>>>>
>>>>  	rc = fcoe_if_init();
>>>> -	if (rc)
>>>> -		goto out_free;
>>>> -
>>>> -	mutex_unlock(&fcoe_config_mutex);
>>>> -	return 0;
>>>> +	if (rc == 0) {
>>>> +		mutex_unlock(&fcoe_config_mutex);
>>>> +		return 0;
>>>> +	}
>>>>
>>>> -out_free:
>>>>  	mutex_unlock(&fcoe_config_mutex);
>>>
>>> Gar...  Stop!  No1  Don't do this.
>>>
>>> Do failure handling, not success handling.
>>>
>>> People always think they should get creative with the last if statement
>>> in a function.  This leads to spaghetti code and it's confusing.  Please
>>> never do this again.
>>>
>>> The original is correct and the new code is bad rubbish code.
>>>
>>> regards,
>>> dan carpenter
>>>
>>>
>>
>> Oops, my bad sir. Will keep this in mind.
> 
> Still, does the mutex_unlock really need to be duplicated?
> 
> julia
> 

Hello Julia,

Thanks for your hint! I have found a better way to remove a need for 
duplicate mutex_unlock statement and extra 'out_free' label. Will send
the corrected path for the same.

Many thanks,
Milan.
