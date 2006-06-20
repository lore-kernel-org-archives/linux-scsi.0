From: "Tharindu Rukshan Bamunuarachchi" <tharindunix@gmail.com>
Subject: Linux disk write latencey
Date: Tue, 20 Jun 2006 15:42:47 +0530
Message-ID: <c49434130606200312j49477b9ck89df6c857c43405c@mail.gmail.com>
References: <010701c6944d$8b791a00$160a19ac@mitd77449ea6e5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.200]:34248 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S932572AbWFTKMs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 06:12:48 -0400
Received: by nz-out-0102.google.com with SMTP id 18so1194295nzp
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2006 03:12:47 -0700 (PDT)
In-Reply-To: <010701c6944d$8b791a00$160a19ac@mitd77449ea6e5>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Dear All,

I could see serious time latency with disk cache flush. Usually it takes
about 2-10 s to flush disk cache with a SCSI disk.I have tested this
with ide disk controller, and could not see big latency compared to
scsi.

This is the scenario;

1. using cp command; copying of large (500MB) file set in background.
Continuously copying.

2. Using my own small programme, i am writing 50 bytes of data blocks to
same disk PARTITION for 60 - 200 seconds.

    Usually it takes less than 1ms to return write() method. But in
that loop, there could be one or more write() method instances which
would take around 2-15s for return.



Exceptions:

If I use direct copy "cp", instead of  standard "cp". Result is normal.
If i use different partitions for two operations. Result is normal.
I have tried with three I/O schedulers and preemtible kernel options.
But no luck.

Up to my knowledge I hope, that 1-15s are taken for Disk Cache flush  or some
thing in kernel space.

Can there be such latency in disk write in SCSI or in Linux disk caching.

Thank You!

Best regards,

Tharindu R

-- 
Tharindu Rukshan Bamunuarachchi
all fabrications are subject to decay
