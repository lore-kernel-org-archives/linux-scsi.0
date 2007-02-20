From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: fix probe_ent alloc/free bugs
Date: Tue, 20 Feb 2007 17:37:47 +0900
Message-ID: <45DAB35B.50005@gmail.com>
References: <45D710E8.3090104@gmail.com> <1171725374.3379.15.camel@mulgrave.il.steeleye.com> <45D73A55.90008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45D73A55.90008@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> ata_probe_ent_alloc() had a temporary hack such that devm_kzalloc()
> was used for allocation if devres had been previously initialized on
> the device; otherwise, plain kzalloc() was used.  This was to make the
> code useable from both the old and devres-aware libata drivers during
> transition.  This hack made ata_sas_port_alloc() unable to determine
> how the probe_ent is allocated, causing double free in some cases.
> 
> Remove the now-unneeded hack and make ata_sas_port_alloc() use
> devm_kfree().
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> ---
> James, thanks for the diagnosis and please ack if this fixes the
> problem.
> 
> Jeff, after James' ack, can you please verify this works with a libata
> driver?  Just loading and unloading a libata LLD should be enough.
> I'm visiting my hometown for lunar new year's day, so I can't do it
> till Tuesday.

Okay, verified.  Please apply.

-- 
tejun
