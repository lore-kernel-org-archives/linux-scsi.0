From: Doug Ledford <dledford@redhat.com>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 13:58:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020520135808.A1648@redhat.com>
References: <93F527C91A6ED411AFE10050040665D0049BFA5A@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <93F527C91A6ED411AFE10050040665D0049BFA5A@corpusmx1.us.dg.com>; from berthiaume_wayne@emc.com on Mon, May 20, 2002 at 12:34:46PM -0400
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, rabeeh@galileo.co.il

On Mon, May 20, 2002 at 12:34:46PM -0400, berthiaume_wayne@emc.com wrote:
> 	Will it, possibly, cause a reordering of other sd<xx> devices
> already on line when scsi_init is called?

No, it will not move any devices that already exist.  It will either 
insert into the chain in the first hole it finds, or append to the end of 
the chain.  This way, if you have drives sda through sdd and you remove 
sdb, then when you do an add, the new drive will take the now vacant sdb 
slot.  For the common case of wanting to replace a failed drive, this is 
the perfect behaviour.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
