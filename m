From: Alok Kataria <akataria@vmware.com>
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Date: Tue, 08 Sep 2009 18:07:47 -0700
Message-ID: <1252458467.24914.66.camel@ank32.eng.vmware.com>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
	 <4AA03A9F.2040500@linux.vnet.ibm.com>
	 <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752895AbZIIBHs@vger.kernel.org>
In-Reply-To: <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>
Cc: "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "eike-kernel@sf-tec.de" <eike-kernel@sf-tec.de>, "matthew@wil.cx" <matthew@wil.cx>, "rdreier@cisco.com" <rdreier@cisco.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "robert.w.love@intel.com" <robert.w.love@intel.com>, "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>
List-Id: linux-scsi@vger.kernel.org

Hi Chetan,

> Alok, 
> 
> (This is just a optimization.You don't need it in order to get your
> code merged upstream.You can always patch it later on)In fact hw_lock
> should be split into two locks - 
> 
> req_path_lock(aka tx_lock) and 
> cmpl_path_lock(aka rx_lock).
> 
> You can then have a full-duplex channel.
> 
> Revised-code - 
> 	::pvscsi_acquire_context->spin_lock_irqsave(tx_lock)
> 	::pvscsi_isr->spin_lock_irqsave(rx_lock)
> 	::some_future_napi_style_pvrx_poll_func->spin_lock_irqsave(rx_lock)
> 	
> 	::for aborts synchronize on the rx_lock so that you know what's
> completed and what's not.
> 

I agree about the optimization. Though IMO this will be more attractive
once we have a device which supports multiple queue pairs.
Anyways, let me keep this on my plate, I will check how much of an
benefit this gets us and will decide if this should be done, but as you
suggested this is for later.

Thanks for taking a look.

--Alok

> This is the kind of common code that should be provided by the bottom
> edge of the scsi-layer so that all the scsi-LLDD's can split their
> tx/rx paths!
> 
