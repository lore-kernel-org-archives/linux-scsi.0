From: Doug Ledford <dledford@redhat.com>
Subject: Re: underflow field
Date: Mon, 3 Feb 2003 17:49:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030203224931.GI29516@redhat.com>
References: <43220000.1043970348@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43220000.1043970348@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 30, 2003 at 04:45:48PM -0700, Justin T. Gibbs wrote:
> I received a recent report of the aic7xxx driver reporting:
> 
> (scsi0:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
> (scsi0:A:0:0): Saw underflow (80 of 96 bytes). Treated as error
> 
> This is because the aic7xxx driver (and the aic79xx driver) honors
> the underflow field.  Has this field been deprecated and thus should
> be ignored by HBA drivers?  If not, why is it that scsi_scan.c doesn't
> set underflow to 0 (or maybe 1 in this case) for commands that can have
> variable length responses?  The above is a fetch of the serial number
> from VPD page 0x80.

Because it was an oversight that needs fixing.  When the VPD Inquiry code 
was added it should have had a correct underflow initializer and it 
doesn't look like it does.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
