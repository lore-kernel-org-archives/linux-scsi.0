From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 09/11] block: add a new interface to block events
Date: Wed, 31 Oct 2012 14:51:21 -0700
Message-ID: <20121031215121.GC2945@htj.dyndns.org>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
 <1351501298-3716-10-git-send-email-aaron.lu@intel.com>
 <20121029153536.GL5171@htj.dyndns.org>
 <508F7BF1.1040009@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <508F7BF1.1040009@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Oct 30, 2012 at 03:04:17PM +0800, Aaron Lu wrote:
> > check_event() can retry.  Just add a per-sr mutex which is try-locked
> > by sr_block_check_events() and grab it when entering zero power.
> 
> Good suggestion. I didn't think about solving it this way.
> 
> Many people suggest me that ZPODD is pure SATA/ACPI stuff, and should
> not pollute sr driver, so I was trying hard not to touch sr while
> preparing these patches, unless there is no other choice(like the
> blocking event interface).
> 
> So I'm not sure if your suggestion is the way to go.
> 
> James, what do you think? Is it OK if I add a mutex into the scsi_cd
> structure to do this? Of course I'll define this only under
> CONFIG_SATA_ZPODD.

I don't think what James' and my suggestions are that different.  Just
silence check_event() while zpodd is kicked in somehow.  There's no
reason to synchronize across multiple subsystems.

Thanks.

-- 
tejun
