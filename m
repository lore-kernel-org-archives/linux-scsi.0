From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Tue, 16 Oct 2018 21:19:20 -0400
Message-ID: <yq1r2gppdyf.fsf@oracle.com>
References: <20181016091223.GA19765@embeddedor.com>
        <yq1ftx5sgw1.fsf@oracle.com>
        <alpine.LNX.2.21.1810170922480.130@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1810170922480.130@nippy.intranet> (Finn Thain's
        message of "Wed, 17 Oct 2018 09:27:45 +1100 (AEDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> This looks wrong to me. I think you've just prevented all START STOP
> commands sent to logical volumes from reaching
>
>         return ((*ha->func.issue) (ha, scb));
>
> I think a better patch is to add a "fall though" comment not a "break"
> statement. (I no longer have access to a ServeRAID board so I can't
> test.)

When I looked at this a few days ago, it seemed that the fallthrough to
the TUR/INQUIRY case statement was accidental and that the intent was to
quickly complete START_STOP unit (which probably doesn't make much sense
for a RAID device anyway).

See the case statements above for another fast exit scenario.

Sadly I have no way to test this. It just stuck out like a false
positive in Gustavo's fallthrough markup patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
