From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: How to online remove an error scsi disk from the system?
Date: Fri, 1 Feb 2013 17:24:51 +0800
Message-ID: <008b01ce005d$ff8c8200$fea58600$@com>
References: <510B5CFC.2040801@tao.ma> <008101ce0059$2a4976b0$7edc6410$@com> <510B8836.6090801@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510B8836.6090801@tao.ma>
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
To: 'Tao Ma' <tm@tao.ma>
Cc: linux-scsi@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 02/01/2013 04:50 PM, Jack Wang wrote:
> Hi All,
> 	In our product system, we have several sata disks attached to one 
> machine. So when one of the disk fails, the jbd2(yes, we use ext4) 
> will hang forever and we will get something in /var/log/messages like
below.
> It seems to me that the io sent to the scsi layer is never returned 
> back with -EIO which is a little bit surprised for me(It should be a 
> timeout somewhere, right?). We have tried echo "offline" > 
> /sys/block/sdl/device/state, but it doesn't work. So is there any way 
> for us to let the scsi device returns all the io requests back with 
> EIO so that all the end_io can be called accordingly? Am I missing
something here?
> 
> Thanks,
> Tao
> [Jack Wang]
> Hi Tao,
> 
> Have you tried:
>  echo 1 > /sys/block/sdv/device/delete
It will do some IO first so it will hang doing IO.
>  echo "- - -" > /sys/class/scsi_host/host
What do you mean for this line?

[Jack Wang] Sorry I mean to let the driver rescan to get the disk back.
The line should be :
 echo "- - -" > /sys/class/scsi_host/hostx/scan.

Per above delete does not work , so no need to run this.
> 
> another way is :
> find out which phy the disk attached to and:
> echo 1 > /sys/class/sas_phy/phy-x:x:x/link_reset
sorry, I have done it, but there is no response.

[Jack Wang] 
What about
echo 1 > /sys/class/sas_phy/phy-x:x:x/hard_reset

?
Thanks,
Tao
> 
> Jack
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
