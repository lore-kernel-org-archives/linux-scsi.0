From: Tejun Heo <htejun@gmail.com>
Subject: Re: ata/scsi crash on halt
Date: Sun, 13 May 2007 15:03:56 +0200
Message-ID: <46470CBC.6040308@gmail.com>
References: <20070512112537.4981f82d.akpm@linux-foundation.org> <1178998256.3723.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1178998256.3723.24.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, James, Andrew.

James Bottomley wrote:
> On Sat, 2007-05-12 at 11:25 -0700, Andrew Morton wrote:
>> [  715.196000] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>> [  715.196000] sd 2:0:0:0: [sda] Stopping disk
>> [  715.196000] ata3.00: DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
>> [  715.196000] ata3.00: For more info, visit http://linux-ata.org/shutdown.html
>> [  715.196000] BUG: scheduling while atomic: swapper/0x00000100/0
>> [  715.196000]  [<c02e282d>] __sched_text_start+0x55/0x504
>> [  715.196000]  [<c0239faa>] scsi_done+0x0/0x1d
>> [  715.196000]  [<c02e32fb>] schedule_timeout+0x78/0x95
>> [  715.196000]  [<c011ffc2>] process_timeout+0x0/0x5
>> [  715.196000]  [<c011ff87>] msleep+0x10/0x18
>> [  715.196000]  [<c024d455>] ata_scsi_start_stop_xlat+0xe3/0x11b
> 
> This is a bug in libata ... there's a ssleep in the command translation
> path.  The commit that did it was this one:
> 
> commit 920a4b1038e442700a1cfac77ea7e20bd615a2c3
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Fri May 4 21:28:48 2007 +0200
> 
>     libata: implement libata.spindown_compat
> 
> I'm afraid the queuecommand path is not necessarily connected to a user
> process because of the way block scheduling works ... you can't call
> sleeping functions along it. 

Right, I missed that.

> Ordinarily, what you'd do if you want to delay calling ->done() is to
> schedule a timer to handle it ... unfortunately I don't see an easy way
> of doing that because of the way this particular layering works.

Yeah, thought about doing it with timer but it required modifications to
command issue hot path, so I tried to cheat there (apparently
unsuccessfully).  I'll think about something better.

Thanks.

-- 
tejun
