From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 05 Jun 2013 13:38:20 +0200
Message-ID: <51AF232C.8060209@itwm.fraunhofer.de>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com> <51AF0CCF.8000909@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39543 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3FELiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 07:38:24 -0400
In-Reply-To: <51AF0CCF.8000909@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/05/2013 12:02 PM, Bernd Schubert wrote:
> On 06/04/2013 05:39 PM, Joe Lawrence wrote:
>>
>> Just curious, what type drives were in your RAID and what does
>> /sys/class/scsi_disk/*/max_write_same_blocks report?  If you have a spare
>> drive to test, maybe you could try a quick sg_write_same command to see
>> how the drive reacts?
>>
>
> I just run into the same issue with an ancient system from 2006. Except
> that I'm in hurry an need it to stress-test my own work, I can do
> anything with it - it is booted via NFS and disks are only used for
> development/testing.
>
>> (squeeze)fslab1:~# cat /sys/block/md126/queue/write_same_max_bytes
>> 16384
>
>> (squeeze)fslab1:~# cat /sys/block/sd[o,n,m,l]/queue/write_same_max_bytes
>> 0
>> 0
>> 0
>> 0
>
>
> Ah, now I found the reason why it fails, scsi-layer had set
> write_same_max_bytes to zero when it detected that it does not support
> it, but after reloading the arecal module (arcmsr) I now get:
>
>> (squeeze)fslab1:~# cat /sys/block/sd[o,n,m,l]/queue/write_same_max_bytes
>> 33553920
>> 33553920
>> 33553920
>> 33553920

In sd_config_write_same() it sets

	if (sdkp->max_ws_blocks == 0)
		sdkp->max_ws_blocks = SD_MAX_WS10_BLOCKS;

except when sdkp->device->no_write_same is set.
But only ata_scsi_sdev_config() sets that. And I also don't see any 
driver setting max_ws_blocks, so everything except of libata gets the 
default of SD_MAX_WS10_BLOCKS. This also seems to be consistent with the 
33553920 I see, except that there is somewhere a bit shift.
So no surprise that mptsas and arcmsr (and anything else) devices have 
write_same_max_bytes set.
As the correct handling in the md layer seems to be difficult, can we 
send a fake request at device configuration time to figure out if the 
device really support write-same?


