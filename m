From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: using direct IO with sgp_dd
Date: Tue, 11 Mar 2008 09:50:14 +0100
Message-ID: <e2e108260803110150g453c790bu3a21537b5eaf762d@mail.gmail.com>
References: <47D63758.9000601@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:38373 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYCKIuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 04:50:16 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2328078fga.17
        for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2008 01:50:14 -0700 (PDT)
In-Reply-To: <47D63758.9000601@voltaire.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doron Shoham <dorons@voltaire.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 11, 2008 at 8:40 AM, Doron Shoham <dorons@voltaire.com> wrote:
>  sgp_dd if=/dev/sg1 of=/dev/null bs=512 bpt=128 thr=8 time=1 count=5M dio=1
>  time to transfer data was 2.236290 secs, 1200.36 MB/sec
>  5242880+0 records in
>  5242880+0 records out
>  Direct IO requested but incomplete 40960 times
>
>  What does it mean "Direct IO requested but incomplete 40960 times"?
>  And what could be the reason for this?

The man page of sgp_dd states that the parameter specified to bs must
be the block size of the physical device. You can query the block size
of a SCSI device with e.g. the scsi_readcap command:

$ scsi_readcap /dev/sda
sg_readcap   /dev/sda
Read Capacity results:
   Last logical block address=625142447 (0x2542eaaf), Number of blocks=625142448
   Logical block length=512 bytes
Hence:
   Device size: 320072933376 bytes, 305245.3 MiB, 320.07 GB

Bart.
