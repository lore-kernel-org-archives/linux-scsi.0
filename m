From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 13143] New: scsi_debug doesn't manage more than 1Tb
Date: Wed, 22 Apr 2009 22:35:47 -0400
Message-ID: <49EFD403.9080206@interlog.com>
References: <bug-13143-11613@http.bugzilla.kernel.org/> <20090423094200T.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33343 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZDWCfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 22:35:53 -0400
In-Reply-To: <20090423094200T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 21 Apr 2009 16:07:08 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=13143
>>
>>            Summary: scsi_debug doesn't manage more than 1Tb
>>            Product: SCSI Drivers
>>            Version: 2.5
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Other
>>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>>         ReportedBy: tvignaud@mandriva.com
>>         Regression: No
>>
>>
>> While debugging a partitionner software that has issues with disks bigger than
>> 1Tb, I found out that scsi_debug doesn't manage more than 1Tb:
>>
>> # modprobe scsi_debug virtual_gb=1000
>> # cat /proc/partitions |fgrep sdc
>>    8       32 1048576000 sdc
>> # rmmod scsi_debug
>> # modprobe scsi_debug virtual_gb=1100
>> # cat /proc/partitions |fgrep sdc
>>    8       32 9223372035860725760 sdc
>>
>>
>> dmesg shows that the additionnal 100Gb makes it loose sight:
>> sd 16:0:0:0: [sdc] 2097152000 512-byte hardware sectors: (1.07 TB/1000 GiB)
>> versus:
>> sd 15:0:0:0: [sdc] 18446744071721451520 512-byte hardware sectors: (18.4
>> EB/15.9 EiB)
> 
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi_debug: fix virtual disk larger than 1TB 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Wow, a 1 TB ram disk!

> ---
>  drivers/scsi/scsi_debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 213123b..41a2177 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -887,7 +887,7 @@ static int resp_start_stop(struct scsi_cmnd * scp,
>  static sector_t get_sdebug_capacity(void)
>  {
>  	if (scsi_debug_virtual_gb > 0)
> -		return 2048 * 1024 * scsi_debug_virtual_gb;
> +		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
>  	else
>  		return sdebug_store_sectors;
>  }

