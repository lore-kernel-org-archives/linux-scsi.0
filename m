From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 10:28:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311027500.23076-100000@beppo>
References: <798370000.1036087399@aslan.btc.adaptec.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <798370000.1036087399@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org



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
> 
> 3) Linux should be using the Report Luns command to determine how
>    many luns are on a device and at what locations.  This might
>    even allow you to never probe more than 8 luns on a SCSI 2
>    device unless they support this command.  Does the Symetrix support
>    it?  Going beyond 8 luns on a SCSI2 device is really a hack
>    otherwise.

Absolutely.


