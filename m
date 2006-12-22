From: "Albert Collins" <albert.ke@gmail.com>
Subject: Re: SG_IO ioctl
Date: Fri, 22 Dec 2006 09:56:08 +0800
Message-ID: <a11f1f890612211756k64f305f6ic0f57eac0c037235@mail.gmail.com>
References: <HIENIDNHFMODBIPFNJPDGEHFDOAA.ken.hwang@zyxel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:62499 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945904AbWLVB4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2006 20:56:10 -0500
Received: by nf-out-0910.google.com with SMTP id o25so3249785nfa
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2006 17:56:08 -0800 (PST)
In-Reply-To: <HIENIDNHFMODBIPFNJPDGEHFDOAA.ken.hwang@zyxel.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ken.hwang@zyxel.com
Cc: linux-scsi@vger.kernel.org

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
