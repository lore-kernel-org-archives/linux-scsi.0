From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: Question about scsi_device_online() usage in mptscsih
Date: Fri, 15 Apr 2005 19:13:09 +0900
Message-ID: <200504151013.AA04188@fukuchi.jp.fujitsu.com>
References: <91888D455306F94EBD4D168954A9457C01F7C9F9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48811 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261795AbVDOKOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 06:14:02 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C01F7C9F9@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>

Hi Eric.

The problem was caused by calling pci_unmap_sg() 
after device offline.

The sequence is: 
1.Host issues SCSI command to fusion MPT driver.
2.Mid layer detects command timeout and then performs 
  error recovery sequence. 
  But the sequence fails and it causes device offline.
  (fusion MPT driver still hold the command)
4.Fusion MPT driver activates host reset and calls
  mptscsih_flush_running_cmds().
5.In mptscsih_flush_running_cmds(), pci_unmap_sg() is called
  for all SCSI cmds.
  But the buffer had already freed and this causes oops.

I don't know your removal of error handling timer resolves
this issue.

Masao Fukuchi

Moore, Eric Dean wrote:
>Masao Fukuchi reported an issue when the
>outstanding mf queue was being flushed in
>contents of slave_destroy, the scsi dev was 
>offlined already by the mid-layer.
>
>They may not be an issue anymore since I removed
>the error handling timers from mptscsih.
>
>Masao can you validate this pls?
>
>Christoph Hellwig, wrote:
>> 
>> On Sat, Apr 02, 2005 at 02:35:57PM +0900, Tejun Heo wrote:
>> >  Hello, Eric.
>> >  Hello, James.
>> > 
>> >  I've been working on new SCSI state model and was checking on
>> > scsi_device_online() users.  As the state model is going to 
>> change, I
>> > need to audit device state usages in lldd's and I'm having difficult
>> > time understanding why scsi_device_online() is used in mptscsih.
>> > 
>> >  In mptscsih.c, mptscsih_flush_running_cmds() uses
>> > scsi_device_online() to determine whether or not dma-unmap data area
>> > of active commands.  This was added in the changeset 1.1371.776.1 by
>> > Eric Moore with the comment "MPT Fusion add back FC909 
>> support".  Can
>> > you please explain me why and how scsi_device_online() condition is
>> > used here?
>> 
>> I brought that issue up a while ago, but we didn't really get 
>> anywhere,
>> see the "fix dma mapping leak in fusion" thread on linux-scsi.
>> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
