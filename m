From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 17 Nov 2005 13:24:18 -0500
Message-ID: <437CCAD2.3050807@hp.com>
References: <91888D455306F94EBD4D168954A9457C04F853D8@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:29114 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S932447AbVKQSR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 13:17:29 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C04F853D8@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Michael Renner <michael.renner@geizhals.at>, linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:

>On  Thursday, November 17, 2005 10:08 AM, Alan D. Brunelle wrote:
>  
>
>>>Please use the patch I posted last night, apply to 2.6.15-rc1-git4.
>>>It addresses this issue.  
>>>
>>>Here is the URL to this patch:
>>>
>>>http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282408101&w=2
>>>
>>>Eric Moore
>>>LSI Logic
>>>
>>>
>>> 
>>>
>>>      
>>>
>>FYI - I did try it earlier this morning with 2.6.14.2 and it 
>>did *not* 
>>fix the issue. I will see about updating to 2.6.15-rc1-git4, 
>>and trying 
>>that again...
>>
>>    
>>
>
>Ok, that make sense, I see your patch is handling mpt_config.
>
>So with the patch I provided at the link above, can you apply
>this patch over that. I've added the sync code in mpt_config.
>Please let me know the results.  I also have a tool called 
>getspeed that I can send you. It dump's the programmed
>speed the devices were negotiated at.
>
>Eric Moore
>
>
>
>  
>
Hi Eric -

I just added in this patch on top of the previous one (again, on 
2.6.14.2) and it worked just fine - I'm getting full U320 16-bit 
transfers. I use

% /usr/bin/sginfo -t 0x19,0x3 -Xz <dev>

to determine this - prior to these patches I would see some of these:

/dev/sde  255 0 0 0 2 0 0

Now I see:

/dev/sde  8 127 1 87 2 1 3

Which is *much* better!

Thanks!
Alan
PS. Expanded -

SPI-4 Negotiated Settings mode subpage (0x19,0x3)
--------------------------------------------
Transfer period                    8
REQ/ACK offset                     127
Transfer width exponent            1
Protocol option bits               87
Transciever mode                   2
Sent PCOMP_EN                      1
Received PCOMP_EN                  3




