From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Kernel Crash when using the open-iscsi initiator on 2.6.25.6
Date: Wed, 25 Jun 2008 12:47:58 -0500
Message-ID: <486284CE.1000003@cs.wisc.edu>
References: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>	 <48627851.9010804@cs.wisc.edu> <81083a450806251035k285e4e3dga052f041c9e2d94d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070705000909040701000809"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50706 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYFYRsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 13:48:08 -0400
In-Reply-To: <81083a450806251035k285e4e3dga052f041c9e2d94d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com

This is a multi-part message in MIME format.
--------------070705000909040701000809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ashutosh Naik wrote:
> On Wed, Jun 25, 2008 at 10:24 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> 
>>>  connection5:0: ping timeout of 5 secs expired, last rx 4309652882,
>>> last ping 4309657882, now 4309662882
>>
>> However, once it happens we should not report it again like is done here.
>> There is something weird there. Do you have the iscsid output? Between these
>> two reports of pings timing out is there any messages from iscsid about
>> reconnecting?
> 
> iscsid tried to reconnect but the target died, I think.
> 
>>>  connection5:0: detected conn error (1011)
>>>  connection5:0: detected conn error (1011)
>>>  session5: host reset succeeded
>>
>> And we should not get here. The iscsi driver's scsi command timeout handler
>> should prevent the command from firing the scsi eh, because in this case we
>> think it is a transport problem.
>>
>> What version of the iscsi tools are you using? Are they from a distro or
>> open-iscsi.org?
>>
>> Are you running with the iscsi kernel modules from 2.6.25.6, or are you
>> using the iscsi modules from the open-iscsi.org website that come with the
>> tarball?
>>
>> Is the kernel a unmodified 2.6.25.6 or does it have some distro patches or
>> patches that you have created?
> 
> It was an unmodififed 2.6.25.6 kernel, and open-iscsi version 2.0-869.2
> 
>>> INFO: task fdisk:5226 blocked for more than 120 seconds.
>> I think you get this message and what follows, is a result of the above
>> problem. While the iscsi initiator is trying to reconnect, IO is queued by
>> the scsi layer so fdisk is going to be waiting around until we recover or
>> give up.
> 
> Yep, but is there any way to close gracefully and avoid the kernel dump?
> 

What do you mean close gracefully? If you are doing IO to the disk you 
can wait for the host to reconnect and execute the IO. If you are going 
to wait for as long as it takes (or for whatever you have setup in the 
host (see the iscsi documentation/README on open-iscsi.org about the 
replacement_timeout)), and you do not want to see the dump then you can 
do what the dump says and do this I think:

echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

If you want to just disable the message I guess you can do that. But I 
do not think we should even get that far. We should not be firing the 
scsi eh in this case in the first place. I think that might be a bug. I 
attached a patch which will give us more infomation. You can just send 
that output to the iscsi list.


--------------070705000909040701000809
Content-Type: text/x-patch;
 name="debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug.patch"

--- linux-2.6.25.2/include/scsi/libiscsi.h	2008-05-06 18:21:32.000000000 -0500
+++ linux-2.6.25.2.work/include/scsi/libiscsi.h	2008-06-25 12:45:18.000000000 -0500
@@ -41,7 +41,7 @@ struct iscsi_cls_conn;
 struct iscsi_session;
 struct iscsi_nopin;
 
-/* #define DEBUG_SCSI */
+#define DEBUG_SCSI 1
 #ifdef DEBUG_SCSI
 #define debug_scsi(fmt...) printk(KERN_INFO "iscsi: " fmt)
 #else

--------------070705000909040701000809--
