From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Thu, 10 Jan 2013 18:17:01 -0800
Message-ID: <20130111021701.GA2513@mtj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-8-git-send-email-aaron.lu@intel.com>
 <20130110195610.GL20454@htj.dyndns.org>
 <20130111021110.GB26270@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130111021110.GB26270@aaronlu.sh.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Aaron.

On Fri, Jan 11, 2013 at 10:11:10AM +0800, Aaron Lu wrote:
> > What's the synchronization rule for this field?
> 
> I documented the rule in include/scsi/scsi_device.h.
> 
> This field is modified in the ata port's runtime suspend and resume
> callback, and is read accessed in the check_events callback of the sr
> block driver. The runtime PM callback is synchronized by PM core, in
> that the two callbacks will never run concurrently. So I guess saying
> synchronized by PM core is enough for this field?
> 
> This is what I've added in v12 for scsi_device structure:
> 
> +	bool disable_disk_events; /* disable poll for disk events, used in
> +				   * ATA layer, sychronized by PM core */
> +
> 
> Or do you mean I should add a comment explaining the sync rule when it
> is modifed, like in the above code?

The thing is that disabling disk events doesn't necessarily have
anything to do with PM, so tying synchronization to PM subsystem is a
bit unexpected.  How about making it an atomic_t?  That way, disabling
can stack and synchronization dependency to PM is removed.

Thanks.

-- 
tejun
