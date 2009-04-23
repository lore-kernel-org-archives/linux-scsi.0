From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 13143] New: scsi_debug doesn't manage more than 1Tb
Date: Wed, 22 Apr 2009 17:42:25 -0700 (PDT)
Message-ID: <20090423094200T.fujita.tomonori@lab.ntt.co.jp>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:41219 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZDWAm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 20:42:27 -0400
Received: by wf-out-1314.google.com with SMTP id 26so217719wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 17:42:26 -0700 (PDT)
In-Reply-To: <bug-13143-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Tue, 21 Apr 2009 16:07:08 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13143
> 
>            Summary: scsi_debug doesn't manage more than 1Tb
>            Product: SCSI Drivers
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: tvignaud@mandriva.com
>         Regression: No
> 
> 
> While debugging a partitionner software that has issues with disks bigger than
> 1Tb, I found out that scsi_debug doesn't manage more than 1Tb:
> 
> # modprobe scsi_debug virtual_gb=1000
> # cat /proc/partitions |fgrep sdc
>    8       32 1048576000 sdc
> # rmmod scsi_debug
> # modprobe scsi_debug virtual_gb=1100
> # cat /proc/partitions |fgrep sdc
>    8       32 9223372035860725760 sdc
> 
> 
> dmesg shows that the additionnal 100Gb makes it loose sight:
> sd 16:0:0:0: [sdc] 2097152000 512-byte hardware sectors: (1.07 TB/1000 GiB)
> versus:
> sd 15:0:0:0: [sdc] 18446744071721451520 512-byte hardware sectors: (18.4
> EB/15.9 EiB)


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_debug: fix virtual disk larger than 1TB 

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 213123b..41a2177 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -887,7 +887,7 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 static sector_t get_sdebug_capacity(void)
 {
 	if (scsi_debug_virtual_gb > 0)
-		return 2048 * 1024 * scsi_debug_virtual_gb;
+		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
 	else
 		return sdebug_store_sectors;
 }
-- 
1.5.6.5

