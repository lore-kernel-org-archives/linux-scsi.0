From: Pedro Pla <pedropla@holidaymarketing.com>
Subject: Re: Problem with Gdt driver under smp?
Date: Wed, 06 Nov 2002 11:34:44 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC88DD4.2010301@holidaymarketing.com>
References: <3DC0EBB3.9030707@holidaymarketing.com> <20021031120257.GF23217@redhat.com> <3DC71BF8.80100@holidaymarketing.com> <20021105033435.GA16634@redhat.com> <3DC79701.8070802@holidaymarketing.com> <20021105164106.GG16634@redhat.com> <3DC87019.3000504@holidaymarketing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-smp@vger.kernel.org

Just to eliminate the possibility of a faulty cpu in up mode I swapped 
cpus and it continues to run flawlessly in up, not sure how to eliminate 
the possibility of it being the cache controller or the ram since all 
simms tested so far failed in mp and ran flawlessly in up, could it be a 
bios issue? I think I'm just trying anything and everything to locate 
the exact problem now. Any test ideas that could help me pinpoint it?

Thanks,
Pedro

Pedro Pla wrote:

> Doug Ledford wrote:
>
>> On Tue, Nov 05, 2002 at 06:01:37PM +0800, Pedro Pla wrote:
>>  
>>
>>> Been running the script all day and still no errors yet, and yes, it 
>>> seems to have used up all the memory or so says a cat /proc/meminfo 
>>> with only a few megs free and no swap activated. This is under a no 
>>> smp compiled kernel, under an smp compiled kernel I think it could 
>>> die while ungzipping the first source directory.. yeah it's that 
>>> bad, no "subtle" problem, just an asap kernel oops or segmentation 
>>> fault.. can't switch to mp 1.1 from mp 1.4 on this motherboard 
>>> either, or at least I haven't found out how yet, it's an intel scb2, 
>>> intel says nothing about how to do so on their sites, and the bios 
>>> has no such option... at least the machine runs flawlessly all tests 
>>> in non-smp mode which makes me think it isn't hardware..
>>>   
>>
>>
>> Why would you think that?  You don't really think that the linux 
>> kernel SMP support is so flaky that it can't survive the first round 
>> of ungizzipping on an SMP machine do you?  I mean, after all, 
>> millions of SMP boxes are out there running the linux kernel every 
>> day without a glitch.  If the kernel were that bad, they would *all* 
>> be dying.
>>
> Of course not :) I have been running linux smp machines for nearly 4 
> years, since I had to compile the smp support in by putting the smp = 
> 1 manually ;) and it has been a breeze, that's why initially I did 
> think it was definately a hardware issue, however these are "branded" 
> machines and I have tried two different setups with the same kind of 
> peices (identical cpu's, ram, motherboard, raid controller, etc) and 
> both have failed. Yes it could be a fundamental flaw in the design or 
> build of both of these machines, although that is a little out of the 
> ordinary, that is why I suspected it might be some flaw somewhere in 
> the kernel that gave it a hard time running on this particular setup. 
> Or maybe a design flaw in the hardware that makes it not run correctly 
> under linux? However all this hardware is certified to run under 
> Redhat by both the manufacturer intel, and Redhat...
>
>>  OTOH, several things on the motherboard change when running SMP 
>> mode.  Power consumption goes up (so a bad power supply can cause 
>> these problems), you start using a CPU that isn't being used now (so 
>> a totally busted CPU could cause this, swapping CPU sockets might 
>> make it start failing in UP mode as well), amount of data your are 
>> pumping to RAM from CPU goes up (because you have two CPUs pumping 
>> data instead of one, and if the memory controller or cache coherency 
>> controller or RAM itself can't handle the increased speed of data 
>> throughput you get all sorts of errors), etc.  There are *tons* of 
>> things that change going from UP to SMP in the hardware and all sorts 
>> of things that used to work fine can start breaking.  The fact that 
>> your machine works OK in UP mode means absolutley nothing about how 
>> it will work in SMP mode or whether or not the hardware is up to 
>> running SMP.
>>
>>  
>>
> Point taken, I will wait till I receive the other 4 machines with 
> identical configurations, and if each and every one fails under smp 
> mode must I still think it is hardware? that would be 6 seperate 
> machines with identical configurations failing in smp? These are all 
> pure intel except ram and hard disks. Although I did read on the intel 
> site that the raid controller scrmr had problems with the scb2 
> motherboard, and I did apply the bios upgrade, but it still fails... 
> sigh... maybe I should find a less stressful profession ;) after being 
> on comps for 12 years you wonder just what more can fail when you are 
> pressed for time and bosses are looking over your shoulder ;)
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-smp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



