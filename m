From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:07:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031200758.GB30047@redhat.com>
References: <20021031170337.GO574@lapi0061> <798370000.1036087399@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <798370000.1036087399@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 11:03:19AM -0700, Justin T. Gibbs wrote:
> > Justin can you change AHC_NUM_LUNS to 32 or suggest an alternative fix?
> 
> The aic7xxx driver is not at fault and so should not be changed.
> The aic7xxx driver really does support all 64 luns.  In my opinion,
> there are three problems here:
> 
> 1) The Symetrix should treat a non-zero LUNTAR bit as an invalid
>    selection.  This would prevent these higher luns from showing up
>    as valid devices.
> 
> 2) Linux should never use more than 5 bits of lun for a device that
>    reports itself as SCSI-2.  If the lun is larger than what will
>    fit in 3 bits, byte 1 of the CDB should not be altered even if
>    the device is SCSI2.

The whole "support more than 8 luns on SCSI-2 devices" is a hack anyway, I 
would be more likely to just remove it instead of changing other things.

> 3) Linux should be using the Report Luns command to determine how
>    many luns are on a device and at what locations.  This might
>    even allow you to never probe more than 8 luns on a SCSI 2
>    device unless they support this command.  Does the Symetrix support
>    it?  Going beyond 8 luns on a SCSI2 device is really a hack
>    otherwise.

We currently only do report luns on SCSI-3 devices.  I didn't think this 
was a supported command on SCSI-2, but I hadn't checked the spec 
recently...hmmm...nope, not supported in SCSI-2, so using report luns on 
SCSI-2 devices is just as much a hack as going above lun 7 on SCSI-2 
devices without specific knowledge of transfer interconnect.

> --
> Justin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
