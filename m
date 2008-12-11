From: Raz <raziebe@gmail.com>
Subject: Re: Intel X25-M MLC SSD benchmarks - How can I be sure i am erased block aligned ?
Date: Thu, 11 Dec 2008 22:40:41 +0200
Message-ID: <5d96567b0812111240i60f70974y815a0775006da05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> ________________________________
> From: Matthew Wilcox [mailto:matthew@wil.cx]
> Sent: Thu 12/11/2008 5:44 AM
> To: Raz Ben-Yehuda
> Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: Intel X25-M MLC SSD benchmarks
>
> On Thu, Dec 11, 2008 at 12:12:37AM +0200, Raz Ben-Yehuda wrote:
>> I did not want to dive into details because it does not matter. Whether
>> noop,deadline, deadline parameters...
>> As for the controller I used 4 different controllers. Adaptec,AHCI and
>> Intel as Integrated chips on the 1025W-UR supermicro motherboard, and a
>> 4-th controller SuperMicro UIO Adaptec aac card.
>> All gave same results for most dd writes commands.
>> dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
>> other variants such erase block size ( 128K ) , several erase block size
>> and so on. Kernel is 2.6.18-8.el5.
>
>>>OK, I suspect you aren't giving the drive enough work to do for it to
>>>perform at its best.  Try doing something like this:
>
>>>for i in $(seq 0 9); do \
>  >>     dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct \
>  >>               seek=$(($i * 1000)) & \
>>>done
>
did that. nothing. also, I would like to note that IO flow is quite
weird.iostats reports 70GB/s in the first few seconds, and then it
degrades to 20
 MB/s and less. could it be that I am not erase-block aligment ?
how does SSD aligments interacts with a controller ?
 iostats looks like that:Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrt
 sda 746.46 0.00 191143.43 0 189232
 sda 546.53 0.00 139912.87 0 141312
 sda 480.00 0.00 122880.00 0 122880
 sda 469.00 0.00 120016.00 0 120016
 sda 347.00 0.00 88880.00 0 88880
 sda 403.96 0.00 103413.86 0 104448
 sda 349.00 0.00 89296.00 0 89296
 sda 424.00 0.00 108544.00 0 108544
 sda 480.00 0.00 122880.00 0 122880
 sda 184.00 0.00 47104.00 0 47104
 sda 467.00 0.00 119600.00 0 119600
 sda 408.00 0.00 104448.00 0 104448
 sda 320.00 0.00 81920.00 0 81920
 sda 357.00 0.00 91344.00 0 91344
 sda 195.00 0.00 49968.00 0 49968
 sda 280.00 0.00 71680.00 0 71680
 sda 475.25 0.00 121663.37 0 122880
 sda 85.00 0.00 21712.00 0 21712
 sda 235.00 0.00 60208.00 0 60208
 sda 216.00 0.00 55296.00 0 55296
 sda 112.00 0.00 28672.00 0 28672
 sda 245.00 0.00 62672.00 0 62672
 sda 72.00 0.00 18432.00 0 18432
 sda 75.00 0.00 19248.00 0 19248
 sda 141.00 0.00 36048.00 0 36048
 sda 11.00 0.00 2864.00 0 2864
 sda 200.00 0.00 51200.00 0 51200
 sda 88.00 0.00 22528.00 0 22528
 sda 160.00 0.00 40960.00 0 40960
 sda 118.81 0.00 30415.84 0 30720
 sda 32.00 0.00 8192.00 0 8192
 sda 128.00 0.00 32768.00 0 32768
 sda 77.00 0.00 19664.00 0 19664
 any idea ?

>> I used all on a supermicro 1025W-UR. Disks have a SAS interface, 80GB.
>> Also, I would like to note, I have 8 disks in array, while each one
>> perform READS 250 MB/s, together I degrade to 200 MB/s each. As for
>
>>>That doesn't surprise me; you're probably hitting a limitation either of
>>>the array or the cable itself.  A SAS cable can run up to 6Gbps, which
>>>will be around 600MB/s.  So three drives should be able to saturate your
>>>SAS cable.  If you're using an x4 link, that goes up to 2400MB/s which
>>>should be ample for 8 drives ... maybe you're using a 3Gbps cable which
>>>would limit each drive to 150MB/s.
I am not surprised as well. SSD is quite new for these controller. I
am using SAS cable(blue one), and no cx4 can connect to io card
controller.
anyway, I have contact supermicro for that, I want to bypass the back
panel, just to be sure.


> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
