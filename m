From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 11:52:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F556CE.9000707@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:420 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267424AbUGNPxB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 11:53:01 -0400
In-Reply-To: <200407141216.i6ECGHxg008332@harpo.it.uu.se>
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mikael Pettersson wrote:
> gcc-3.4.1 errors out in 2.6.8-rc1-mm1 at drivers/scsi/sg.c:
> 
> drivers/scsi/sg.c: In function `sg_ioctl':
> drivers/scsi/sg.c:209: sorry, unimplemented: inlining failed in call to 'sg_jif_to_ms': function body not available
> drivers/scsi/sg.c:930: sorry, unimplemented: called from here
> make[2]: *** [drivers/scsi/sg.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> sg_jif_to_ms() is marked inline but used defore its function
> body is available. Moving it nearer the top of sg.c (together
> with sg_ms_to_jif() for consistency) fixes the problem.
> 
> Signed-off-by: Mikael Pettersson <mikpe@csd.uu.se>


This looks like a compiler bug to me.

sg_jif_to_ms is properly declared at the top of the file...

 > static int sg_ms_to_jif(unsigned int msecs);
 > static inline unsigned sg_jif_to_ms(int jifs);
 > static int sg_allow_access(unsigned char opcode, char dev_type);

If gcc is insisting that prototypes for inlines no longer work, we have 
a lot of code churn on our hands ;-(  Grumble.

	Jeff


