From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 11:03:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <798370000.1036087399@aslan.btc.adaptec.com>
References: <20021031170337.GO574@lapi0061>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031170337.GO574@lapi0061>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com
Cc: conway_heather@emc.com, linux-scsi@vger.kernel.org

> Justin can you change AHC_NUM_LUNS to 32 or suggest an alternative fix?

The aic7xxx driver is not at fault and so should not be changed.
The aic7xxx driver really does support all 64 luns.  In my opinion,
there are three problems here:

1) The Symetrix should treat a non-zero LUNTAR bit as an invalid
   selection.  This would prevent these higher luns from showing up
   as valid devices.

2) Linux should never use more than 5 bits of lun for a device that
   reports itself as SCSI-2.  If the lun is larger than what will
   fit in 3 bits, byte 1 of the CDB should not be altered even if
   the device is SCSI2.

3) Linux should be using the Report Luns command to determine how
   many luns are on a device and at what locations.  This might
   even allow you to never probe more than 8 luns on a SCSI 2
   device unless they support this command.  Does the Symetrix support
   it?  Going beyond 8 luns on a SCSI2 device is really a hack
   otherwise.

--
Justin
