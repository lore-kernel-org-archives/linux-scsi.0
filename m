From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Sun, 29 Aug 2010 11:49:06 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Fri, 27 Aug 2010, Justin Piszcz wrote:

Hi,

Current theory:

Mobo: Intel DP55KG

I had this:
#append="3w-9xxx.use_msi=1 reboot=a snd_hda_intel.enable_msi=1"

Now I am no longer using MSI for the 3ware driver, so far, the 'lag' /
controller reset problem has not occurred yet:
append="reboot=a snd_hda_intel.enable_msi=1"

I wish both cards did not use the same IRQ, however, if this solves the problem
then I'll be happy.

>From /proc/interrupts:

16:      44899          0          0          0          0          0      12418          0   IO-APIC-fasteoi   3w-9xxx, 3w-9xxx, ehci_hcd:usb1

So far I'm typing this e-mail on the client and I do not see any lag at this
time, it appears this has fixed my problem, I'll give it a few more hours/days
before I consider it 'fixed' but after changing all of the settings in 3dm2
and replacing/removing the BBUs, noticing no change, it appears to be an
interrupt problem when the 3ware cards are used with MSI on my motherboard.

Are there cases in which MSI should/should not be used?  Generally I have it on
for all of my devices but perhaps the 3ware cards don't play well with it
on the Intel motherboard?

I am guessing the 'lag' issue causes the controller to reset when there is
too much I/O launched via cron (backups and such)..

We'll see if it happens again, I did briefly try the newest Beta firmware
as LSI recommended made no difference in terms of the lag issue.

I am still running with 'nobarrier' removed and have not gotten any controller
resets yet, but I had the lag issue as mentioned above until I removed the
MSI option from the 3w-9xxx driver.

Before removal of MSI option:

Drive Performance Monitor Configuration for /c1 ...
Performance Monitor: ON
Version: 1
Max commands for averaging: 100
Max latency commands to save: 10
Requested data: Instantaneous Drive Statistics

                                Queue           Xfer         Resp
Port   Status           Unit   Depth   IOPs    Rate(MB/s)   Time(ms)
------------------------------------------------------------------------
p0     OK               u0     1       123     1.202        730148 
p1     OK               u0     1       123     1.203        644249 
p2     OK               u1     1       7       0.000        132 
p3     NOT-PRESENT      -      -       -       -            -

After removal:

Drive Performance Monitor Configuration for /c1 ...
Performance Monitor: ON
Version: 1
Max commands for averaging: 100
Max latency commands to save: 10
Requested data: Instantaneous Drive Statistics

                                Queue           Xfer         Resp
Port   Status           Unit   Depth   IOPs    Rate(MB/s)   Time(ms)
------------------------------------------------------------------------
p0     OK               u0     1       53      3.124        85900 
p1     OK               u0     1       53      3.124        85900 
p2     OK               u1     0       0       0.000        0 
p3     NOT-PRESENT      -      -       -       -            -

..

This is what the problem looks like (sdb=root) as it happened twice (before
removal of the MSI option, I've not been able to reproduce it with the MSI
option disabled).

$ (output form dstat)
-dsk/total----dsk/sda-----dsk/sdb--
  read  writ: read  writ: read  writ
    0  6884k:   0     0 :   0  6884k
    0  4580k:   0     0 :   0  4580k
    0  4728k:   0     0 :   0  4728k
    0  3936k:   0     0 :   0  3936k
    0  5764k:   0     0 :   0  5764k
    0  1292k:   0     0 :   0  1292k
    0  7760k:   0     0 :   0  7760k
    0  5480k:   0     0 :   0  5480k
    0  7408k:   0     0 :   0  7408k
    0  5040k:   0     0 :   0  5040k
    0  6236k:   0     0 :   0  6236k
    0   788k:   0     0 :   0   788k
    0     0 :   0     0 :   0     0
    0  2900k:   0     0 :   0  2900k
    0  8160k:   0     0 :   0  8160k
4096B 7916k:   0     0 :4096B 7916k
    0  7812k:   0     0 :   0  7812k
    0  4804k:   0     0 :   0  4804k
  148k 7268k:   0     0 : 148k 7268k
    0   888k:   0     0 :   0   888k
    0  7688k:   0     0 :   0  7688k
    0  7644k:   0     0 :   0  7644k
    0  6352k:   0     0 :   0  6352k
-dsk/total----dsk/sda-----dsk/sdb--
  read  writ: read  writ: read  writ
    0  5324k:   0     0 :   0  5324k
    0  1432k:   0     0 :   0  1432k
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
-dsk/total----dsk/sda-----dsk/sdb--
  read  writ: read  writ: read  writ
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0 dddddddddd
    0  8700k:   0     0 :   0  8700k
    0  2076k:   0     0 :   0  2076k
    0  5428k:   0     0 :   0  5428k
    0  7984k:   0     0 :   0  7984k
    0  8236k:   0     0 :   0  8236k
    0  2536k:   0     0 :   0  2536k
    0   232k:   0     0 :   0   232k
    0   268k:   0     0 :   0   268k
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0   508k:   0     0 :   0   508k
    0    72k:   0     0 :   0    72k
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
4096B  232k:   0     0 :4096B  232k
  344k 2380k:   0     0 : 344k 2380k
    0  1172k:   0     0 :   0  1172k
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0 ^C^C^C
$


Justin.


