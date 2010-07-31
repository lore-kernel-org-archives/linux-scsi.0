From: Shyam Iyer <shyam_iyer@dell.com>
Subject: Re: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device handlers
Date: Fri, 30 Jul 2010 20:22:12 -0400
Message-ID: <4C536CB4.6090108@dell.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC420@cosmail01.lsi.com>	 <1280440444.17620.72.camel@chandra-lucid.beaverton.ibm.com>	 <E463DF2B2E584B4A82673F53D62C2EF4D0663845@cosmail01.lsi.com>	 <1280448276.17620.80.camel@chandra-lucid.beaverton.ibm.com>	 <E463DF2B2E584B4A82673F53D62C2EF4D0663A2C@cosmail01.lsi.com> <1280534189.17620.284.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:25171 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0GaAWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 20:22:19 -0400
In-Reply-To: <1280534189.17620.284.camel@chandra-lucid.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: "Moger, Babu" <Babu.Moger@lsi.com>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>

On 07/30/2010 07:56 PM, Chandra Seetharaman wrote:
> On Fri, 2010-07-30 at 12:12 -0600, Moger, Babu wrote:
>
>    
>>>>    Yes, We can do that.  Problem is I am hitting the issue with BUG_ON
>>>>   in get_rdac_data which is there in the beginning of rdac_activate.
>>>>          
>>> I do not understand the problem.
>>>
>>> If the BUG_ON on get_rdac_data() is being triggered, that means
>>> sdev->scsi_dh_data is NULL, if that is the case, how can you access
>>> sdev->scsi_dh_data->kref in scsi_dh_activate (in patch 2/6) ? Wouldn't
>>> it trip a oops ?
>>>        
>> Test case is deleting both active and passive paths almost together during
>>   the multipath testing.  Looks like DM picked up the active path failure
>> first. Then failed the active path and started scheduling activate_path to
>> failover to passive path. Passive path is also about to go down pretty soon.
>> When the control was in scsi_dh_activate, Looks like scsi_dh_data was still
>> valid because I did not see panic here.  But scsi_dh_data became NULL when
>> control went to rdac_activate. That is when I hit the bug on.
>>
>> kernel BUG at /usr/src/packages/BUILD/lsi-scsi_dh_rdac-01.00/obj/default/scsi_dh_rdac.c:232!
>> RIP: 0010:  rdac_activate+0x257/0x387 [scsi_dh_rdac]
>>
>> My understanding is someone triggered scsi_dh->detach for passive path during
>>   this small window.  Only way I could see problem go away is holding reference
>> counts between these calls.  Did i miss anything here? See the code snippet below..
>>      
> So, basically, the new patch just reduces the window of race. IOW, if it
> just spins for few seconds (or preempted) just before calling the
> kref_get() in the new patch, it will generate an oops as scsi_dh_data
> would be NULL.
>
> Looks like you have to create a lock to protect scsi_dh_data and then
> call kref_get() with the protection of lock.
>
>    
Second that.. Sounds like each kref_get/kref_put .. needs a lock protection not just this scenario.

