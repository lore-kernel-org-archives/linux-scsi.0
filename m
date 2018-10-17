From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Wed, 17 Oct 2018 14:24:47 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810171327290.8@nippy.intranet>
References: <20181016091223.GA19765@embeddedor.com>        <yq1ftx5sgw1.fsf@oracle.com>        <alpine.LNX.2.21.1810170922480.130@nippy.intranet> <yq1r2gppdyf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r2gppdyf.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 16 Oct 2018, Martin K. Petersen wrote:

> 
> Finn,
> 
> > This looks wrong to me. I think you've just prevented all START STOP 
> > commands sent to logical volumes from reaching
> >
> >         return ((*ha->func.issue) (ha, scb));
> >
> > I think a better patch is to add a "fall though" comment not a "break" 
> > statement. (I no longer have access to a ServeRAID board so I can't 
> > test.)
> 
> When I looked at this a few days ago, it seemed that the fallthrough to 
> the TUR/INQUIRY case statement was accidental and that the intent was to 
> quickly complete START_STOP unit (which probably doesn't make much sense 
> for a RAID device anyway).
> 
> See the case statements above for another fast exit scenario.
> 

But that's an error path.

Also note that START_STOP also appears in ips_chkstatus(), which suggests 
to me that this command may be submitted legitimately.

> Sadly I have no way to test this. It just stuck out like a false 
> positive in Gustavo's fallthrough markup patch.
> 

Without testers, and without another maintainer to review this, I'd 
advocate a more prudent approach. I wonder whether there is another 
maintainer to do a review. The MAINTAINERS file seems to contradict 
itself.

$ grep -C5 drivers/scsi/ips MAINTAINERS 
...
IBM ServeRAID RAID DRIVER
S:      Orphan
F:      drivers/scsi/ips.*
...
IPS SCSI RAID DRIVER
M:      Adaptec OEM Raid Solutions <aacraid@microsemi.com>
L:      linux-scsi@vger.kernel.org
W:      http://www.adaptec.com/
S:      Maintained
F:      drivers/scsi/ips*
...

Note that 'drivers/scsi/ips*' got assigned to Microsemi by a janitorial 
change, as part of commit 679655daffdd ("MAINTAINERS - Add file patterns") 
in 2009. But for ips.c, the last acked-by from the vendor was in 2008.

-- 
