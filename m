From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Magical ansi scsi revision (was Re: [linux-usb-devel] Re: What
 is SCSI command 0xa0 ?)
Date: Thu, 17 Feb 2005 17:23:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502171719290.627-100000@ida.rowland.org>
References: <20050217221803.091fd840@hebus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:14084 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261179AbVBQWXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 17:23:55 -0500
In-Reply-To: <20050217221803.091fd840@hebus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 17 Feb 2005, Samuel Colin wrote:

> Anyway, I have interesting results for the scsi devel list : 
> 
> 
> Feb 17 21:19:09 gnondpom kernel: scsi0 : SCSI emulation for USB Mass Storage
> devices 
> Feb 17 21:19:09 gnondpom kernel:   Vendor: WDC WD25  Model:
> 00JB-00FUA0       Rev: 15.0 
> Feb 17 21:19:09 gnondpom kernel:   Type:  
> Direct-Access                      ANSI SCSI revision: 02
> 
> 
> Feb 17 21:26:10 gnondpom kernel: scsi0 : SCSI emulation for USB Mass Storage
> devices 
> Feb 17 21:26:15 gnondpom kernel:   Vendor: WDC WD25  Model:
> 00JB-00FUA0       Rev: 15.0 
> Feb 17 21:26:15 gnondpom kernel:   Type:  
> Direct-Access                      ANSI SCSI revision: 04
> 
> It means that for a 2.6.8 kernel, the revision is 02 (then no report_luns
> causing problems), while for a 2.6.10, the revision is 04. As I don't think
> the firmware of the disk upgrades itself magically depending on the running
> kernel, does anyone have an idea why the numbers reported are different ?

Well, that explains why you had problems starting with 2.6.10!

The explanation is simple enough, and it can be found in a line from your 
logs:

Feb 17 21:19:09 gnondpom kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 4

Back in 2.6.8, the usb-storage driver would automatically change the SCSI 
revision of any device to 2.  In 2.6.10 it doesn't do that if the actual 
revision is > 2.

Alan Stern

