From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Tue, 16 Oct 2018 16:39:07 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810161611150.130@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au> <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de> <alpine.LNX.2.21.1810151717520.10@nippy.intranet>
 <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2b48c925-73f0-0ca0-2f3c-3c35d90010ba@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Oct 2018, Hannes Reinecke wrote:

> 
> However, the function declaration really is a worry, as the actual function
> body only exists when the config option is enabled.
> So either add a dummy function or surround the function declaration by
> CONFIG_ESP_PIO.
> Otherwise I think Dan Carpenter and the likes are guaranteed to send you a
> nice mail complaining about this ...
> 

Perhaps I've misunderstood your concern here. Is it a problem that 
esp_scsi.ko may or may not export the function, depending on .config?

For example, if esp_scsi.ko came from a build with CONFIG_SUN3X_ESP=y && 
!CONFIG_SCSI_ZORRO_ESP && !CONFIG_SCSI_MAC_ESP, then it would export no 
esp_send_pio_cmd() symbol.

A dummy function (mentioned above) might then avoid a link error from 
"modprobe zorro_esp" or "modprobe mac_esp" in this scenario. (The modules 
would load but fail to work properly.)

This seems a bit too contrived so I'll post v3 for you to consider.

-- 
