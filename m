From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Question about scsi_device_online() usage in mptscsih
Date: Fri, 15 Apr 2005 10:11:44 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C01F7CD79@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11656 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261854AbVDOQM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 12:12:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Friday, April 15, 2005 8:30 AM, James Bottomley wrote:
> 
> On Fri, 2005-04-15 at 19:13 +0900, Masao Fukuchi wrote:
> > The sequence is: 
> > 1.Host issues SCSI command to fusion MPT driver.
> > 2.Mid layer detects command timeout and then performs 
> >   error recovery sequence. 
> >   But the sequence fails and it causes device offline.
> >   (fusion MPT driver still hold the command)
> > 4.Fusion MPT driver activates host reset and calls
> >   mptscsih_flush_running_cmds().
> 
> Well, this is the error:  The Fusion host reset should be 
> activated from
> the eh_host_reset_handler.
> 

Since I removed the eh timers, this is not going to happen.
The driver is always waiting for task management request 
to complete before returning control back to the mid-layer.
Before when the driver used timers, the eh thread returned
immediately back to the mid-layer, and the actual
task management request to the firmware was delayed and 
completed later. If the task management request didn't 
complete, the timer would expire, and host reset would be called,
and it was possible to opps as Fukuchi has indicated.

Thus I think its safe to say, we can remove the 
scsi_device_online from mptscsih_flush_running_cmds.
Right??

Eric Moore
LSI Logic

