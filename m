From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [v6 2/4] mpt3sas: Fix Sync cache command failure during driver
 unload
Date: Tue, 30 Oct 2018 08:32:39 -0500
Message-ID: <20181030133239.GB41022@google.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1540290081-15827-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1540290081-15827-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2018 at 03:51:19PM +0530, Suganath Prabu wrote:
> This is to fix Sync cache and start stop command
>  failures with DID_NO_CONNECT during driver unload.
> 
> 1) Release drives first from SML, then remove internally
> in driver.
> 2) And allow sync cache and Start stop commands to firmware,
> even when remove_host flag is set

This looks like it should be two or maybe even three patches: (1) call
sas_remove_host() before releasing volumes and ports, (2) skipping
sas_port_delete_phy() and sas_port_delete() when ioc->remove_host (I'm not
sure if this is logically part of the sas_remove_host() change), and (3)
add _scsih_allow_scmd_to_device() -- this is purely mpt3sas-specific thing
independent of the SCSI midlayer.

Bjorn
