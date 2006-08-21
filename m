From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: Loading PATA_PDC2027x as a module
Date: Mon, 21 Aug 2006 11:08:52 -0500
Message-ID: <20060821160852.207632@bebe.enoyolf.org>
References: <BAY113-F29FED2E57FBE3CF8195662DF410@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <BAY113-F29FED2E57FBE3CF8195662DF410@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dwm@bebe.enoyolf.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 21 Aug 2006 10:38:12 CDT, "John Treubig" wrote:
> Can I load pata_pdc2027x as a module or must it be built as part of the 
> kernel?  I am using RedHat Fedora with 2.6.17.1 stock kernel.  LibATA has 
> been installed in the kernel with ATA_ENABLE_PATA undefined.  The 
> pata_pdc2027x driver is not part of the Fedora build, so I have been able to 
> build pata_pdc2027x as a module with ATA_ENABLE_PATA defined for the module. 
>   When I try to load the pata_pdc2027x module it will not displace the IDE 
> native driver.  What's the mechanism that is used to determine if the IDE 
> driver grabs the device or LibATA/pata_pdc_2027x?

The base kernel needs the old driver (pdc202xxx...) built as a module
(or not at all) to give the pata_pdc2027x module a chance to load.

Once that is done, you can add the module as required to mkinitrd and 
it should be the first loaded, which prevents the other driver from 
loading.
 
> 
> You may ask why I don't just live with the IDE driver.  This stems from 
> problems we saw in accessing the Promise PDC2027x drives under 2.6.10 where 
> the system lost time.  In discussions with Albert Lee, it was resolved that 
> the best approach was to convert our access to use LibATA.  After usage of 
> the LibATA access, the time loses issue has gone away.  I know that there 
> have been changes in both the IDE and LibATA structures, so I'm open to 
> additional advice.
> 
> Best wishes,
> John Treubig
> VT Miltope
> Senior Test Engineer


