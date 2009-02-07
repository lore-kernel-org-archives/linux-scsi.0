From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sat, 07 Feb 2009 11:14:08 -0500
Message-ID: <498DB350.8000905@redhat.com>
References: <20090123041558.GC24652@parisc-linux.org>	 <4979AF62.7070409@redhat.com>	 <1232721777.4430.7.camel@macbook.infradead.org>	 <498DA052.6090605@redhat.com> <1234019372.4658.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1234019372.4658.9.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Eyal Shani <Eyal.Shani@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sat, 2009-02-07 at 09:53 -0500, Ric Wheeler wrote:
>   
>> I have been poked at by some vendors about the status of our support for 
>> the virtually/thinly provisioned luns since they are getting close to 
>> being able to test with real devices.
>>     
>
> With my LSF hat on, a certain array vendor might be sponsoring to get
> the opportunity to raise this issue more fully.  The impression (mostly
> correct) is that we're thinking about trim/unmap purely from the SSD FTL
> point of view and perhaps not being as useful as we might to virtually
> provisioned LUNs ... so you could mention to the other vendors that they
> might have an interest in coming (and even possibly sponsoring).
>   

That is probably worth bringing up - I don't see this as a large project 
and should be reasonably quick to get completed given all the work that 
David and others have already put into it. If you (with you LF hat on 
:-)) have a standard form or offer process, you might want to poke at 
NetApp, EMC, Hitachi,  IBM, HP and Dell. We both know the names of some 
people in storage in a few of those companies, others I have less 
contacts with.

On the other hand, this might also be an opportunity to get them and 
their engineers on the array side more directly and personally involved.
>   
>> My quick summary is that we most of the work so far has been done 
>> without any real hardware to play with - in 2.6.29-rc3, I don't see any 
>> low level ATA or SCSI bits that turn requests tagged with REQ_DISCARD 
>> into the specific ATA or SCSI commands. Did I miss something & if not, 
>> do we have plans to push anything upstream soonish?
>>     
>
> With no devices it's a bit hard.  Also we need at least three pieces for
> SSDs: Devices supporting trim, the T13 implementation of TRIM and the
> SAT for UNMAP.  We can get the latter two out of the proposals, but it's
> still a bit of a moving target.
>   

I think that it has settled a bit - do we have a good sense of the 
status of the various proposals in T13 and T10?
>   
>> One note on the SCSI devices, there was a T10 proposal to add an "UNMAP" 
>> bit to the "WRITE SAME" command for SCSI. The details of the proposed 
>> interface are at:
>>
>> http://www.t11.org/t10/document.08/08-356r4.pdf
>>
>> The up side of using WRITE SAME with unmap is that there are no fuzzy 
>> semantics about what the unmapped sectors will be - they will all be 
>> whatever the WRITE SAME command would have set (usually zeroes I assume).
>>
>> The summary of write same is that you send down one sector (say 512 
>> bytes of zeroes) and a count so you can do a zeroing of the target 
>> without having to send all of the data over the wire. Very useful for 
>> initializing members of a RAID device for example to a known pattern.
>>
>> The down side would be that if we incorrectly send down a WRITE SAME 
>> command to a non-thin device, I think that we would kick off a potential 
>> extremely long IO. For example, imagine doing a write same of a full TB 
>> - that could take an hour which might be an issue :-)  Of course, we 
>> should not be doing that if we get the code right.
>>     
>
> As I read it, non thin provisioned devices can be identified (and may
> not even accept WRITE SAME).
>   

I agree that the intersection of write same and thin devices is not 
going to be 100%. We might end up needing both for SCSI in the worst 
case I suppose.
>   
>> I don't see another of the PDF's claims of advantages for file systems 
>> to be really all that useful.
>>
>> With either the write same and its proposed unmap bit or with the 
>> original T10 unmap, do we have a short list of infrastructure that needs 
>> fleshed out? Anything we can do to help get peoples patches to test with 
>> their non-GA thin enabled devices?
>>     
>
> Yes, REQ_DISCARD simply isn't broad enough to cope with all the
> potential uses of WRITE SAME.  If it's just a mechanism to get known
> data into a discard sector, fine, we can set that at the lower level.
> However, WRITE SAME has uses beyond TRIM in that it can be used as an
> engine for data deduplication.  If vendors are thinking of doing this,
> then REQ_DISCARD isn't flexible enough.
>   

I am more interested personally in the sparse support. On the dedup 
side, I think that most implementations do not rely on write same. They 
tend to compute hashes on the various blocks and so on.
>   
>> Is there a similar short list of things to be done for T13 devices with 
>> TRIM? Anyone have a chance to test on real hardware yet?
>>     
>
> Not that I know of yet.  It's all sort of on hold until actual devices
> become available.
>
> James
>
>
>   
The vendors certainly have things that they could try in their labs if 
we can get bits and pieces together for them to test with. We will need 
to avoid the chicken and egg scenario where they wait for us and we wait 
for them :-)

Ric
 
