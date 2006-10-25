From: Aboo Valappil <aboo@aboo.org>
Subject: Re: About SG Elements of request_buffer
Date: Wed, 25 Oct 2006 19:05:09 +1000
Message-ID: <453F28C5.5000104@aboo.org>
References: <453223AA.50409@aboo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070803000201000900080403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:3200 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S1423140AbWJYJFM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 05:05:12 -0400
Received: from [192.168.1.65] ([192.168.1.65])
	by localhost.localdomain (8.13.1/8.13.1) with ESMTP id k9P8xJSm003025
	for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2006 18:59:19 +1000
In-Reply-To: <453223AA.50409@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070803000201000900080403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

I have posted this a while ago on strange behavior I see when "dd" opens 
and reads the disk presented by my virtual HBA. I am attaching the code 
in this email.

Basically, I have this virtual HBA which is being served by a user space 
SCSI engine. It basically transports SCSI commands out side kernel and 
get serviced by a user space scsi engine.

I have successfully implemented this using read and write system call to 
a character device. So the SCSI request buffer is copied back and forth 
user and kernel space for every request. It works alright.

Now i wanted a method of sharing SCSI request_buffer between user space 
and kernel without doing copy_to_user and copy_from_user of the 
request_buffer. I have implemented memmap and facing some challenges. I 
am memory mapping the scsi request_buffer to the user space. But i am 
facing a problem with page cache.

The SCSI device presented by my HBA is /dev/sdb (for eg:). If I open 
this device and read a block ( 512 bytes). I can see a SCSI read coming 
down my HBA. But I also a see a SCSI write later on when I close 
/dev/sdb. Up on investigation I found that it is the effect of page 
cache. When /dev/sdb opened and initiated a read, a page cache is 
already allocated. When I do memmap, I am actually mem mapping that page 
buffer to my user space SCSI engine. When the SCSI engine service the 
SCSI read, it writes the SCSI READ output to the buffer making it dirty. 
When the application  closed /dev/sdb, the kernel causes all the dirty 
pages to be written and causing the SCSI write which is what I am 
seeing. This means that for every SCSI read, i will see a SCSI write.It 
is a very strange implementation from my side. Even Xen source is doing 
the same memory mapping technique and I do not know how it avoid this 
page cache interference.

Can some one throw some lights on this for me to prevent this page cache 
interference? I have done bit of research on marking the pages/buffer 
clean after writing to the memory mapped area. But I could not find 
anything conclusive.

Thanks in advance,

Aboo


Aboo Valappil wrote:
> Hi All,
>
> Thanks for all your support for my previous posts.
>
> I have two questions.
>
> 1. Is it safe to assume that all the SG elements of request_buffer are 
> page aligned? (Except the first one and last one),  I mean, it is 
> always multiple of pages?
>
> 2. What are situations reading a scsi disk (using dd ) cause a write 
> to the disk?  When I read my virtual scsi disk using dd command, block 
> layer is generating lot of SCSI write, as well as reads. Any thoughts? 
> Besides this observation, everything is working fine.
>
> Thanks in advance.
>
> Aboo
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------070803000201000900080403
Content-Type: application/octet-stream;
 name="scsitap.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="scsitap.tgz"

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
eAAA
--------------070803000201000900080403--
