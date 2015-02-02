From: Suman Tripathi <stripathi@apm.com>
Subject: Re: sequential I/O on SSD disk varies from 20 to 300 MBytes/s every week
Date: Mon, 2 Feb 2015 19:19:01 +0530
Message-ID: <CAOHikRBjOuUMdeyKDx0=+6YPKNrhZNquukAfdv-qMxYGFdX34Q@mail.gmail.com>
References: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Siim Vahtre <siim@xf.ee>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I have an extremely odd situation when the I/O speed changes for both
SATA and SSD disks every few days or weeks with no apparent reason.

The servers have clean base install with nothing but SSH running and
the test I am doing is the following:

# dd if=/dev/zero of=/dev/sda4 bs=1M count=10240 conv=fsync

And the results are:
1) 3.5Mbytes/s - 120Mbytes/s for SATA disks
2) 20Mbytes/s - 300Mbytes/s for SSD disks

The previous reply failed to deliver as plaintext mode was not.
Please check whether write cache is enabled in the drive . This can be
checked from the logs during bootup and also check whether NCQ is
enabled or not.

you can enable write cache by :

hdparm -W 1 /dev/<sdX>

On Mon, Feb 2, 2015 at 6:37 PM, Siim Vahtre <siim@xf.ee> wrote:
> Hello,
>
> I have an extremely odd situation when the I/O speed changes for both SATA
> and SSD disks every few days or weeks with no apparent reason.
>
> The servers have clean base install with nothing but SSH running and the
> test I am doing is the following:
>
> # dd if=/dev/zero of=/dev/sda4 bs=1M count=10240 conv=fsync
>
> And the results are:
> 1) 3.5Mbytes/s - 120Mbytes/s for SATA disks
> 2) 20Mbytes/s - 300Mbytes/s for SSD disks
>
>
> Note that:
>
> 1) for every disk, the speed (either slow or fast) is usually consistent
> 2-14 days, and then it randomly changes.
>
> 2) One disk speed does not correlate with the speeds of other disks in the
> same server - one can be 100Mbyte/s while other is 10Mbytes/s) and month
> later it might be vice-versa.
>
> 3) I have not yet discovered anything that triggers the change of speed.
> Seemingly it is just random: on week 1 the speed is ~70-80Mbytes/s, and then
> on week two it goes to 20Mbytes/s, and then few days later goes to
> 90Mbyte/s. But the speed (slow or fast) is consistent for a longer period of
> time - it does not usually change in matter of hours.
>
> 4) Speed is slow for reads as well, but the difference is a bit less
> dramatic. (eg. 400Mbytes/s vs 500Mbytes/s).
>
> 5) The random I/O speed also changes, but as it is easier to test.
>
>
> During the testing period of about 5 months I have concluded:
>
> 1) There are 3 identical Fujitsu RX200 S6 test servers which all show the
> same problem, but I also reproduced it on some Sun Fire and Dell server.
>
> 2) The problem happens with both HW RAID (MegaRAID SAS 2108) and when disks
> were directly on integrated SATA card.
>
> 3) The problem happens with different Kernel versions (tried 3.14, 3.16,
> 3.18)
>
> 4) The problem happens with newest FW/BIOS versions and on older version
>
> 5) I have checked/replaced the cabling.
>
> 6) It is not a caching issue (controller/disk caches were off during
> testing, but even putting them on had minor impact on the results)
>
> 7) The problem happens with both 2.5" SATA (12 x HGST Travelstar 1TB, 3 x WD
> Black 750G), and SSD disks (3 x Samsung Pro 840)
>
> 8) I have NOT been able to reproduce it on Windows - the speeds have been
> good for all disks at all times.
>
> 9) Changing the disks (eg. taking currently slow disk and putting it to
> another server) has mixed results - it usually triggers some change of speed
> (slow becomes fast or vice-versa) but not always.
>
>
> The only thing that somewhat correlates with the change of speed is the
> environment: the IO speed of disks is generally better when testing in the
> office vs if that exact same server is in the server room. It might just
> been luck, however.
>
> I did not find correlation with the uptime, restarts, change of temperature,
> etc, so I assumed it might be the vibrations/rotations for SATA disks, but
> now that I have reproduced it with expensive SSD disks as well, I am out of
> ideas.
>
> Only 20Mbytes/s on SSD must be wrong, right? (Especially if week earlier or
> week later it is ~300MBytes/s).
>
> Any comments would be highly appreciated.
>
> --
> Siim Vahtre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
with regards,
Suman Tripathi
