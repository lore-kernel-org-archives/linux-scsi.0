From: Doron Shoham <dorons@Voltaire.COM>
Subject: Re: using direct IO with sgp_dd
Date: Tue, 11 Mar 2008 11:12:40 +0200
Message-ID: <47D64D08.6070601@Voltaire.COM>
References: <47D63758.9000601@voltaire.com> <e2e108260803110150g453c790bu3a21537b5eaf762d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:16630 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757022AbYCKJMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 05:12:43 -0400
In-Reply-To: <e2e108260803110150g453c790bu3a21537b5eaf762d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Tue, Mar 11, 2008 at 8:40 AM, Doron Shoham <dorons@voltaire.com> wrote:
>>  sgp_dd if=/dev/sg1 of=/dev/null bs=512 bpt=128 thr=8 time=1 count=5M dio=1
>>  time to transfer data was 2.236290 secs, 1200.36 MB/sec
>>  5242880+0 records in
>>  5242880+0 records out
>>  Direct IO requested but incomplete 40960 times
>>
>>  What does it mean "Direct IO requested but incomplete 40960 times"?
>>  And what could be the reason for this?
> 
> The man page of sgp_dd states that the parameter specified to bs must
> be the block size of the physical device. You can query the block size
> of a SCSI device with e.g. the scsi_readcap command:
> 
> $ scsi_readcap /dev/sda
> sg_readcap   /dev/sda
> Read Capacity results:
>    Last logical block address=625142447 (0x2542eaaf), Number of blocks=625142448
>    Logical block length=512 bytes
> Hence:
>    Device size: 320072933376 bytes, 305245.3 MiB, 320.07 GB
> 
> Bart.

Hi,
sg_readcap /dev/sdb

Read Capacity results:
   Last block address=3221225471 (0xbfffffff), Number of blocks=3221225472
   Block size=512 bytes
Hence:
   Device size: 1649267441664 bytes, 1572864.0 MiB, 1649.27 GB

The block size is 512 as I used in the sgp_dd command.
The problem is just when using dio=1, without it it works ok.

Thanks,
Doron
