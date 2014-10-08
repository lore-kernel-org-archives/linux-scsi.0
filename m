From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Wed, 08 Oct 2014 22:41:23 +0200
Message-ID: <1790241.KrvEcO3C6i@wuerfel>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wednesday 08 October 2014 23:14:08 Ebru Akagunduz wrote:
> This patch changes 32-bit time types to 64-bit in
> ips.c
> 
> time_t can only represent signed 32-bit dates but
> the driver should represent dates that are after
> January 2038.
> 
> Use time64_t type instead of time_t.
> 
> Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
> 

Hi Ebru,

I think you missed the location in which ffdc_time is initially
assigned, and wher it gets compared to the current time:

                struct timeval tv;

                do_gettimeofday(&tv);
                ha->last_ffdc = tv.tv_sec;

This needs to be changed to timespec64 to actually avoid the
overflow problem. I think this one should also use monotonic time,
i.e. ktime_get_ts64 rather than getnstimeofday64.

	Arnd
