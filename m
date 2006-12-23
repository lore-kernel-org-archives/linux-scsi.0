From: "Ken Hwang" <ken.hwang@zyxel.com>
Subject: RE: SG_IO ioctl
Date: Fri, 22 Dec 2006 22:49:40 -0800
Message-ID: <HIENIDNHFMODBIPFNJPDIEIGDOAA.ken.hwang@zyxel.com>
References: <a11f1f890612211756k64f305f6ic0f57eac0c037235@mail.gmail.com>
Reply-To: <ken.hwang@zyxel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:45884 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752401AbWLWGt3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Dec 2006 01:49:29 -0500
In-Reply-To: <a11f1f890612211756k64f305f6ic0f57eac0c037235@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Albert Collins <albert.ke@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hi Albert,

I found my problem with Kernel 2.6.15.4. Somehow this version mask off the msb 3 bits of the SCSI command byte [1] (the 2nd byte) but Kernel 2.6.12.2 let all the bytes untouched through the SCSI pass through (SG_IO IOCTL) command. And my USB dongle firmware reject the masked version. Thanks for the information anyway.

Happy holiday,

Ken

-----Original Message-----
From: Albert Collins [mailto:albert.ke@gmail.com]
Sent: Thursday, December 21, 2006 5:56 PM
To: ken.hwang@zyxel.com
Cc: linux-scsi@vger.kernel.org
Subject: Re: SG_IO ioctl


I think it might be that bio sets up the iov incorrectly.

I've had this problem that sdparm is receiving all-zero data (command
completes OK but no data is written into specified buffer) with kernel
2.6.19, and I've found that blk_rq_map_user receives the correct user
space buffer address but the iov generated for data transfer is not a
map to that user address.  So the low-level driver reads the data into
a wrong buffer. I'm running 2.6.19 on a dual-opteron box with 4G
memories, kernel compiled for x86_64. I haven't tried the git tree but
I've read all commit log ( til Dec 22nd ) and didn't find any commit
on this problem.

I thought it might be introduced in recent kernels ( 2.6.17-2.6.19 )
because sdparm works fine with SuSE Linux 10.1's kernel ( customized
2.6.16 ), which it seems is not the fact.

I planed to look into it further but is currently having no spare
time. If you've got an update, please let me know about it. TIA.

Cheers,
Albert Ke

On 12/22/06, Ken Hwang <ken.hwang@zyxel.com> wrote:
> Hi,
>
> I had a utility which uses SG_IO ioctl (scsi passthrough?) to issue private
> commands to a USB dongle (reported as a USB Mass Storage but with 0 bytes)
> to get some information back. It works fine with kernel 2.6.12.2. But after
> we upgraded to kernel 2.6.15.4 then the program could not get information
> back anymore (reads all 0 with the private command). Can anyone please give
> me a hint of where I should go studying more?
>
> Thanks,
>
> Ken
> --
> No virus found in this outgoing message.
> Checked by AVG Free Edition.
> Version: 7.1.409 / Virus Database: 268.15.26/594 - Release Date: 12/20/2006
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.409 / Virus Database: 268.15.26/594 - Release Date: 12/20/2006
 

-- 
No virus found in this outgoing message.
Checked by AVG Free Edition.
Version: 7.1.409 / Virus Database: 268.15.26/598 - Release Date: 12/22/2006
 

