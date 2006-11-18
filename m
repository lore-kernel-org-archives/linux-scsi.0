From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: [Bug 5776] initio.c and k3b: git-bisect advice
Date: Sat, 18 Nov 2006 03:11:07 +0000 (GMT)
Message-ID: <Pine.LNX.4.63.0611180226490.5576@thor.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:31088 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1756171AbWKRDFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 22:05:09 -0500
Received: by ug-out-1314.google.com with SMTP id m3so860078ugc
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2006 19:05:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

I just ran git-bisect on Linus' tree to try to find the cause of
the hangs I've been experiencing with the below bug; 

http://bugzilla.kernel.org/show_bug.cgi?id=5776

and have narrowed down the search to one commit that causes the hang.

---
186d330e682210100c671355580a8592e4a21692 is first bad commit   
commit 186d330e682210100c671355580a8592e4a21692   
Author: Timothy Thelin <Timothy.Thelin@wdc.com>   
Date:   Tue Sep 13 19:56:28 2005 -0700   
   
    [SCSI] scsi: sd, sr, st, and scsi_lib all fail to copy cmd_len to
new cmd   
   
    This fixes an issue in scsi command initialization from a request   
    where sd, sr, st, and scsi_lib all fail to copy the request's   
    cmd_len to the scsi command's cmd_len field.   
   
    Signed-off-by: Timothy Thelin <timothy.thelin@wdc.com>   
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---

Running the latest k3b beta version does not produce a hang, running an
earlier version does. I'm guessing that the newer k3b version properly
passes the command length parameters to the SCSI system.

I just wanted to know:
  a) Is this the likely cause of the hangs?
  b) is the commit above correct in setting the cmd_len member even if
     sd, st, sr and scsi_lib fail? If those parts of SCSI system fail
     to set the length, why would this patch succeed to set the length
     correctly?

     (I'm a kernelnewbie and am not very familiar with SCSI so I'm very
      likely wrong. Please be gentle with the flames ;)  )

If k3b was indeed passing garbage to the SCSI layers, this would be
pretty dangerous because a userland application could hang the kernel
arbitrarily. Or did I misunderstand?

Regards,

Srdjan Todorovic
