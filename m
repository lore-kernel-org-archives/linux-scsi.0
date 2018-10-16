From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: ips: fix missing break in switch
Date: Wed, 17 Oct 2018 09:27:45 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810170922480.130@nippy.intranet>
References: <20181016091223.GA19765@embeddedor.com> <yq1ftx5sgw1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ftx5sgw1.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 16 Oct 2018, Martin K. Petersen wrote:

> 
> Gustavo,
> 
> > Add missing break statement in order to prevent the code from falling
> > through to case TEST_UNIT_READY.
> 
> Applied to 4.20/scsi-queue, thanks!
> 
> 

This looks wrong to me. I think you've just prevented all START STOP 
commands sent to logical volumes from reaching

        return ((*ha->func.issue) (ha, scb));

I think a better patch is to add a "fall though" comment not a "break" 
statement. (I no longer have access to a ServeRAID board so I can't test.)

-- 
