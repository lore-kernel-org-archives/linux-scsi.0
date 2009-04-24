From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13143] scsi_debug doesn't manage more than 1Tb
Date: Fri, 24 Apr 2009 18:27:30 GMT
Message-ID: <200904241827.n3OIRUvx030882@demeter.kernel.org>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41955 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZDXS1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 14:27:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3OIRUg5030883
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2009 18:27:30 GMT
In-Reply-To: <bug-13143-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13143





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-04-24 18:25:45 ---
Reply-To: dgilbert@interlog.com

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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.