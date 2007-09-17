From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: command failing at iSCSI disconnect
Date: Mon, 17 Sep 2007 14:01:17 -0500
Message-ID: <46EECEFD.5080805@cs.wisc.edu>
References: <46EB008F.7040003@mvista.com> <20070914184534G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47864 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXIQTBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2007 15:01:45 -0400
In-Reply-To: <20070914184534G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: djiang@mvista.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Fri, 14 Sep 2007 14:43:43 -0700
> Dave Jiang <djiang@mvista.com> wrote:
> 
>> I'm using the latest linus git tree. This is in fileio mode with
>> IOMode=wb. It seems that if I do I/O and then immediately disconnect
>> then the cache sync commands fail. Is this expected behavior or should
>> the connection wait till all existing commands has been flushed before
>> logout? Thanks!
>>
>> root@192.168.1.171:~/iscsi2# iscsiadm -m node -T
>> iqn.2007.com.mvista:disk1 -p 192.168.1.239:3260 --logout
>> Logout session [sd 1:0:0:0: [sdb] Synchronizing SCSI cache
>> sid: 1, target: iqn.2007.com.mvista:disk1, portal: 192.168.1.239,3260]
>> iscsi: cmd 0x35 is not queued (6)
>> iscsi: cmd 0x35 is not queued (6)
>> iscsi: cmd 0x35 is not queued (6)
>> sd 1:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> 
> I think that the fix is in Mike's iscsi git tree.
> 

Yeah, we used to remove the devices from userspace as a workaround, but 
in 2.6.21 doing

echo 1 > /sys/block/sdc/device/delete

changed behavior from where it used to not return until the delete was 
done to where it returns right away.

In my iscsi git tree I finally fixed up the iscsi shutdown code so we do 
not encounter this problem. We did not notice the problem until, 
recently and the fix is larger than what people probably want for stable 
kernels the  so it should hopefully make the next 2.6 kernel.
