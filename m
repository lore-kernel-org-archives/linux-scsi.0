From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi:NCR5380: remove same check condition in
 NCR5380_select
Date: Fri, 3 Aug 2018 16:04:33 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1808031548290.34@nippy.intranet>
References: <1533179408-20631-1-git-send-email-zhongjiang@huawei.com> <c99a75a2905c1eef50f94ccc0871c36af431e21a.camel@wdc.com> <5B627E71.5020600@huawei.com> <928ae07a-8c4a-05fc-16af-48fb6e9c341d@gmail.com> <alpine.LNX.2.21.1808031148320.16@nippy.intranet>
 <6e28be9a-b601-17e2-4a04-9635925e5958@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6e28be9a-b601-17e2-4a04-9635925e5958@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: zhong jiang <zhongjiang@huawei.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 3 Aug 2018, Michael Schmitz wrote:

> > > Finn - does the ICR_ARBITRATION_LOST bit have to be cleared by a 
> > > write to the mode register?
> > > 
> > 
> > Something like that: the write to the mode register does clear the 
> > ICR_ARBITRATION_LOST bit, because it clears the MR_ARBITRATE bit.
> 
> Yes, but is that the only way the bit can get cleared? [...]

Short of a reset, yes.

> 
> > > In that case, the first load would have been redundant and can be 
> > > omitted without changing driver behaviour?
> > 
> > This code is a faithful rendition of the arbitration flow chart in the 
> > datasheet, so even if you are right, I wouldn't want to change the 
> > code.
> 
> I think that's a pretty clear hint that the 'arbitration lost' condition 
> isn't latched. [...]

It's not a hint. It's just an algorithm with fewer assumptions than the 
one you proposed.

As for latching, the datasheet is pretty clear on that. Writing MR_BASE to 
the mode register clears the ICR_ARBITRATION_LOST bit. As in,

        if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
            (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
            (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
                NCR5380_write(MODE_REG, MR_BASE);

-- 
