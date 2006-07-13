From: Andrew Morton <akpm@osdl.org>
Subject: Fw: MegaRaid 8408E goes out to lunch with nr_requests > 8
Date: Thu, 13 Jul 2006 03:25:14 -0700
Message-ID: <20060713032514.9b6eb098.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10446 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751509AbWGMKZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 06:25:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: linux-scsi@vger.kernel.org, Dave Lloyd <dlloyd@exegy.com>, Berkley Shands <bshands@exegy.com>



Begin forwarded message:

Date: Wed, 12 Jul 2006 09:46:52 -0500
From: Dave Lloyd <dlloyd@exegy.com>
To: linux-kernel@vger.kernel.org, Berkley Shands <bshands@exegy.com>
Subject: MegaRaid 8408E goes out to lunch with nr_requests > 8


This happens both on 2.6.17 and 2.6.18rc1 using the megaraid, mptsas and
mptscsih drivers supplied with the kernel.

While writing data to raid0 devs on a LSI MegaRaid 8408E controller, the
devices will hang after somewhere between 4-7gb of data written.  If I
dial the nr_requests back from the default down to 8, the hang will not
occur.  The hang does occur at 16.  I haven't tested values between the
two, but I'm not too optimistic.  From what I can see, it looks like 8
should be a magic number to make the queue look congested more often
than not.

Here are the messages I get when the devices go out to lunch:
Jul 11 14:13:34 systemname kernel: sd 4:2:0:0: megasas: RESET -40213 cmd=2a
Jul 11 14:13:34 systemname kernel: megasas: [ 0]waiting for 256 commands
to complete
Jul 11 14:13:39 systemname kernel: megasas: [ 5]waiting for 256 commands
to complete
Jul 11 14:13:44 systemname kernel: megasas: [10]waiting for 256 commands
to complete
Jul 11 14:13:49 systemname kernel: megasas: [15]waiting for 256 commands
to complete

[...]

Jul 11 14:16:35 systemname kernel: megasas: [175]waiting for 256
commands to complete
Jul 11 14:16:35 systemname kernel: megasas: failed to do reset
Jul 11 14:16:35 systemname kernel: sd 4:2:1:0: megasas: RESET -40216 cmd=2a
Jul 11 14:16:35 systemname kernel: megasas: cannot recover from previous
reset failures
Jul 11 14:16:35 systemname kernel: sd 4:2:0:0: megasas: RESET -40213 cmd=2a
Jul 11 14:16:35 systemname kernel: megasas: cannot recover from previous
reset failures
Jul 11 14:16:35 systemname kernel: sd 4:2:0:0: megasas: RESET -40213 cmd=2a
Jul 11 14:16:35 systemname kernel: megasas: cannot recover from previous
reset failures
Jul 11 14:16:35 systemname kernel: sd 4:2:0:0: scsi: Device offlined -
not ready after error recovery
Jul 11 14:16:36 systemname last message repeated 13 times

Interestingly, the machine will hang on shutdown and requires a hard
reset to reboot.  Bummer!

My next step is to try and reproduce and dig into this some in KDB.

Has anyone else seen this and/or does anyone have some suggestions for
further debugging info?

-- 
Dave Lloyd
Test Engineer, Exegy, Inc.
314.450.5342
dlloyd@exegy.com


-- 
Dave Lloyd
Test Engineer, Exegy, Inc.
314.450.5342
dlloyd@exegy.com
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
