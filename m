From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [RFC] A SCSI fault injection framework using SystemTap.
Date: Tue, 22 Jan 2008 19:26:30 +0900
Message-ID: <4795C4D6.9010904@ce.jp.nec.com>
References: <478C22A9.5000009@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <478C22A9.5000009@ce.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org


>The new framework is tested on Fedora8(i386) running with kernel 2.6.23.12.
>So far, I'm cleaning up the tool set for release, and plan to post it in the near future.

Now it's ready. The scsi fault injection tool is available from the following site.
https://sourceforge.net/projects/scsifaultinjtst/
If you have any comments, please let me know.

Additionally, the deadlock problem reproduced also on md RAID10. I think that the
same reason for RAID1 deadlock reported earlier cause this problem, because
raid10.c is based on raid1.c.
> e.g.
>  -The kernel thread for md RAID1 could cause a deadlock when the error handler for
>    md RAID1 contends with the write access to the md RAID1 array.

I've reproduced the deadlock on RAID10 using this tool with a small shell script for
automatically injecting a fault repeatedly. But I can't come up with any good
idea for the patch to fix this problem so far.

-- 
------------------------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com

