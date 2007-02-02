From: Ric Wheeler <ric@emc.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 02 Feb 2007 11:16:19 -0500
Message-ID: <45C363D3.20809@emc.com>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <45C2474E.9030306@rtr.ca>	 <1170366920.3388.62.camel@mulgrave.il.steeleye.com>	 <45C32C7F.9050706@emc.com>  <20070202144211.5a2d2365@localhost.localdomain> <1170428007.3380.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170428007.3380.4.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



James Bottomley wrote:
> On Fri, 2007-02-02 at 14:42 +0000, Alan wrote:
>   
>>> The interesting point of this question is about the typically pattern of 
>>> IO errors. On a read, it is safe to assume that you will have issues 
>>> with some bounded numbers of adjacent sectors.
>>>       
>> Which in theory you can get by asking the drive for the real sector size
>> from the ATA7 info. (We ought to dig this out more as its relevant for
>> partition layout too).
>>     

Actually, my point is that damage typically impacts a cluster of disk 
sectors that are adjacent. Think of a drive that has junk on the platter 
or a some such thing - the contamination is likely to be localized.
>>     
>>> I really like the idea of being able to set this kind of policy on a per 
>>> drive instance since what you want here will change depending on what 
>>> your system requirements are, what the system is trying to do (i.e., 
>>> when trying to recover a failing but not dead yet disk, IO errors should 
>>> be as quick as possible and we should choose an IO scheduler that does 
>>> not combine IO's).
>>>       
>> That seems to be arguing for a bounded "live" time including retry run
>> time for a command. That's also more intuitive for real time work and for
>> end user setup. "Either work or fail within n seconds"
>>     
>
> Actually, then I think perhaps we use the allowed retries for this ...
>   
I really am not a big retry fan for most modern drives - the drive will 
try really, really hard to complete an IO for us and multiple retries 
can just slow down the higher level application from recovering.
> So you would fail a single sector and count it against the retries.
> When you've done this allowed retries times, you fail the rest of the
> request.
>
> James
>
>   
I think that we need to play with some of these possible solutions on 
some  real-world bad drives and see how they react. 

We should definitely talk more about this at the workshop ;-)

ric

