From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about scsi_device_online() usage in mptscsih
Date: Fri, 15 Apr 2005 09:30:26 -0500
Message-ID: <1113575426.5009.11.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C01F7C9F9@nacos172.co.lsil.com>
	 <200504151013.AA04188@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35514 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261745AbVDOOai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 10:30:38 -0400
In-Reply-To: <200504151013.AA04188@fukuchi.jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Fri, 2005-04-15 at 19:13 +0900, Masao Fukuchi wrote:
> The sequence is: 
> 1.Host issues SCSI command to fusion MPT driver.
> 2.Mid layer detects command timeout and then performs 
>   error recovery sequence. 
>   But the sequence fails and it causes device offline.
>   (fusion MPT driver still hold the command)
> 4.Fusion MPT driver activates host reset and calls
>   mptscsih_flush_running_cmds().

Well, this is the error:  The Fusion host reset should be activated from
the eh_host_reset_handler.

> 5.In mptscsih_flush_running_cmds(), pci_unmap_sg() is called
>   for all SCSI cmds.
>   But the buffer had already freed and this causes oops.

If you do the above, the command will still be valid.  If you wait until
after the device is offlined, of course the mid-layer throws away the
commands, since it's up to the driver to clean them up during the reset
sequences.

James


