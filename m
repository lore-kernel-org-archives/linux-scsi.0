From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Fri, 18 Nov 2005 17:24:21 +1000
Message-ID: <437D81A5.2010306@torque.net>
References: <91888D455306F94EBD4D168954A9457C04F853D8@nacos172.co.lsil.com> <437CCAD2.3050807@hp.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:44972 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1030371AbVKRHXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 02:23:41 -0500
Received: from borg.st.net.au (postfix@zorg.st.net.au [203.16.233.9])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id jAI7NbC5027526
	for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2005 23:23:39 -0800
In-Reply-To: <437CCAD2.3050807@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Michael Renner <michael.renner@geizhals.at>, linux-scsi@vger.kernel.org

Alan D. Brunelle wrote:
> Moore, Eric Dean wrote:
> 
>> On  Thursday, November 17, 2005 10:08 AM, Alan D. Brunelle wrote:
>>  
>>
>>>> Please use the patch I posted last night, apply to 2.6.15-rc1-git4.
>>>> It addresses this issue. 
>>>> Here is the URL to this patch:
>>>>
>>>> http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282408101&w=2
>>>>
>>>> Eric Moore
>>>> LSI Logic
>>>>
>>>>
>>>>
>>>>
>>>>     
>>>
>>> FYI - I did try it earlier this morning with 2.6.14.2 and it did
>>> *not* fix the issue. I will see about updating to 2.6.15-rc1-git4,
>>> and trying that again...
>>>
>>>   
>>
>>
>> Ok, that make sense, I see your patch is handling mpt_config.
>>
>> So with the patch I provided at the link above, can you apply
>> this patch over that. I've added the sync code in mpt_config.
>> Please let me know the results.  I also have a tool called getspeed
>> that I can send you. It dump's the programmed
>> speed the devices were negotiated at.
>>
>> Eric Moore
>>
>>
>>
>>  
>>
> Hi Eric -
> 
> I just added in this patch on top of the previous one (again, on
> 2.6.14.2) and it worked just fine - I'm getting full U320 16-bit
> transfers. I use
> 
> % /usr/bin/sginfo -t 0x19,0x3 -Xz <dev>
> 
> to determine this - prior to these patches I would see some of these:
> 
> /dev/sde  255 0 0 0 2 0 0
> 
> Now I see:
> 
> /dev/sde  8 127 1 87 2 1 3
> 
> Which is *much* better!
> 
> Thanks!
> Alan
> PS. Expanded -
> 
> SPI-4 Negotiated Settings mode subpage (0x19,0x3)
> --------------------------------------------
> Transfer period                    8
> REQ/ACK offset                     127
> Transfer width exponent            1
> Protocol option bits               87
> Transciever mode                   2
> Sent PCOMP_EN                      1
> Received PCOMP_EN                  3

Alan,
Good to see that sginfo is finding some use. I'm trying
to move most of sginfo's functionality into sdparm.
The sginfo invocation is a little less cryptic in sdparm:

 # sdparm -t spi -p ns -l /dev/sdd
    /dev/sdd: SEAGATE   ST373453LC        XXXX
port: negotiated settings (SPI) mode page:
  PPID_3      1  [cha: n, def:  1, sav:  1]  Port's (transport) protocol identifier
  TPF         8  [cha: n, def:  0, sav:  0]  Transfer period factor
  RAO        63  [cha: n, def:  0, sav:  0]  REQ/ACK offset
  TWE         1  [cha: n, def:  0, sav:  0]  Transfer width exponent
  POB        23  [cha: n, def:  0, sav:  0]  Protocol option bits
  TM          2  [cha: n, def:  0, sav:  0]  Transceiver mode
  SPE         1  [cha: n, def:  0, sav:  0]  Sent PCOMP_EN bit (for current I_T nexus)
  RPE         1  [cha: n, def:  0, sav:  0]  Received PCOMP_EN bit (for current I_T nexus)

The long hand invocation would be:
 # sdparm --transport=spi --page=ns --long /dev/sdd

Parameters can can fetched separately with sdparm:
 # sdparm -t spi -q --get=TPF,RAO /dev/sdd
TPF         8  [cha: n, def:  0, sav:  0]
RAO        63  [cha: n, def:  0, sav:  0]

sdparm is a lot easier to use than sginfo when in comes
to changing mode parameters (not that anything in the
above mode subpage can be changed). I will continue to
maintain sginfo, adding new mode pages and parameters
to both sdparm and sginfo.


BTW I recently fixed the sginfo bug that required "0x" to
appear additionally in front of the subpage number.
So this now works:
 # sginfo -t 0x19,3 -Xz /dev/sdd
8 63 1 23 2 1 1
in the soon to be released sg3_utils 1.18 .

Doug Gilbert
