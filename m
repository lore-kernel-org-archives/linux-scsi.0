From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: Fri, 22 Oct 2004 10:52:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0410221044470.2101@ppc970.osdl.org>
References: <1098137016.2011.339.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:16096 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267759AbUJVRwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 13:52:47 -0400
In-Reply-To: <1098137016.2011.339.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Testing my tty stuff with "allyesconfig" shows this bug in the SCSI layer:

	....
	  LD      drivers/scsi/built-in.o
	drivers/scsi/qla1280.o(.data+0xe67e): multiple definition of `risc_code_addr01'
	drivers/scsi/qlogicfc.o(.data+0x0):drivers/scsi/qlogicfc.c:697: first defined here
	make[2]: *** [drivers/scsi/built-in.o] Error 1

Can we _please_ fix these broken globals without any driver prefixes? 
Looking at the code, making them static doesn't seem to be an option for 
all of these - although some certainly should.

Also, there's this really ugly UNIQUE_FW_NAME thing, which implies that 
somebody knew about the problem, but
 (a) had absolutely no _f*cking_ taste (hint: just make the names unique 
     _unconditionally_, and if you need the old names for some ass-
     backwards compatibility reason, add a #define or a linker alias!)
 (b) didn't fix it right anyway.

Please? Can we fix this? "allyesconfig" may not be a realistic example, 
but not only is it good for testing, building two drivers into the system 
_is_ something that people do.

		Linus
