From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Fri, 8 Aug 2003 13:58:43 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308081357160.13076@filesrv1.baby-dragons.com>
References: <20030806231359.A28252@mail.kroptech.com>
 <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local> <20030807201916.A1065@mail.kroptech.com>
 <20030808173003.GA3231@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from filesrv1.baby-dragons.com ([199.33.245.55]:52187 "EHLO
	filesrv1.baby-dragons.com") by vger.kernel.org with ESMTP
	id S271733AbTHHR6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 13:58:48 -0400
In-Reply-To: <20030808173003.GA3231@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

	Hello Kai ,  Is this (or something simular) necessary for 2.4.x ?
		Tia ,  JimL
On Fri, 8 Aug 2003, Kai [iso-8859-1] M=E4kisara wrote:
> Thus spake Adam Kropelin (akropel1@rochester.rr.com):
> > On Fri, Aug 08, 2003 at 12:00:56AM +0300, Kai Makisara wrote:
> ...
> > I tried aic7xxx_old and hit the same BUG so Justin's driver would s=
eem
> > to be exonerated. The new backtrace is below. The commonality is cl=
early
> > the st driver and the SCSI midlayer. Perhaps I'll try to verbosify
> > things a bit in that area and see what comes up.

> I reproduced the problem with an aha2940. The patch at the end of thi=
s
> message fixes the problem but I must think a little more before
> sending a permanent fix (at least some comments must be added).
> In case someone wonders what this has to do with the symptoms: the bu=
g
> lead to setting sr_use_sg to one even when the byte count was zero an=
d
> DMA direction DMA_NONE. The byte count in the first s/g segment was
> non-zero. Different SCSI HBA drivers handle this inconsistency
> differently and this is why I have not seen this in my tests.
> This bug has been in st for quite a long time. Thanks for finally
> detecting it :-)
--=20
       +---------------------------------------------------------------=
---+
       | James   W.   Laferriere | System    Techniques | Give me VMS  =
   |
       | Network        Engineer |     P.O. Box 854     |  Give me Linu=
x  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  A=
XP |
       +---------------------------------------------------------------=
---+
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
