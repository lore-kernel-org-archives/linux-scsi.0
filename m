From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Wed, 19 Nov 2003 15:03:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:34759 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S264176AbTKSXDG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 18:03:06 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jbarnes@sgi.com

Jes,

> More changes that really needs to go into the driver:
>  - Call qla2x00_config_dma_addressing() before performing any
>    consistent allocations. This is required since the dma mask
>    settings will affect the memory pci_alloc_consistent() will return.
>

This was definitely a problem.

>  - Call pci_set_consistent_dma_mask() to allow for 64 bit consistent
>    allocations, required on some platforms such as the SN2.
>

Yes, I believe Jeremy forwarded a patchset for the 6.x driver.

>  - Wait 20 usecs (not sure how long is really necessary, but this
>    seems safe) after setting CSR_ISP_SOFT_RESET in the ctrl_status
>    register as the card doesn't respond to PCI reads while in reset
>    state. This causes a machine check on some architectures.
>  - Flush PCI writes before calling udelay() to ensure the write is not
>    sitting idle in-flight for a while before hitting the hardware.

Yes, we also need to look at some PCI posting issues with our move to MMIO.

>  - Use auto-negotiate link speed when using default parameters rather
>    than NVRAM settings. Disable NVRAM reading on SN2 since it's
>    not possible to execute the HBA's BIOS on an SN2. 

Internally, we've been talking about taking a more defensive route
within the driver if the NVRAM data is not valid -- failing the
initialization process completely, and therefore, removing this code
completely from the driver.

We've had a number of support calls from folks that have fallen
through the catch-all path only to discover 'things' don't always work
as expected because one parameter was set or not cleared in the
doctored NVRAM data.

Manufacturing writes a pre-canned NVRAM image along with a rolling
serial number (unique to each HBA) to each card that leaves QLogic.
One obvious example of a potential problem in the case of using the
(driver) doctored NVRAM data is how to assign a unique serial number
to the ISP that is being initialized.  BTW: The serial number is actually
encoded in bytes 5, 6, and 7 of the WWPN (portname); coupled with
the hardcoded port number (33) and the QLogic copany code of (224 and
139), code from qla2x00_nvram_config():

		nv->port_name[0] = 33;
		nv->port_name[3] = 224;
		nv->port_name[4] = 139;

yield obvious results: each ISP on the host with invalid (or unread as
in the case of SN2) NVRAM data will have the same WWPN.  This (in
*most* cases) is not a good thing!

> I suggest doing something similar for all architectures that do not
> provide x86 BIOS emulation.
>

I don't believe this is going to be a safe route.  QLogic does offer
other methods to modify NVRAM parameters besides the BIOS utility, a
GUI (SANsurfer) as well as a command-line tool (SANblade CLI) - the
64bit versions are available here:

	http://www.qlogic.com/support/os_detail.asp?productid=256&osid=65

We'll need to talk more to figure this out.

>  - Include linux/vmalloc.h in qla_os.c since it uses vmalloc()
> 

Ok.

> And a quick recommendation: there's a lot of global variables in the
> driver which are explicitly being initialized to zero/NULL. Please
> don't do that as it forces them into the DATA segment rather than the
> BSS segment. Just declaring them 'static int foo;' is sufficient.
> 

Will do.



More comments below...

>  		/* If firmware needs to be loaded */
> -		if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
> +		if ((rval = qla2x00_isp_firmware(ha)) != QLA_SUCCESS) {
>  			if ((rval = qla2x00_chip_diag(ha)) == 
> QLA_SUCCESS) {
>  				rval = qla2x00_setup_chip(ha);
>  			}

Good catch, if disable_risc_code_load is set and verify checksum
fails, poof...Typically, this flag is cleared.

>  	/* Bad NVRAM data, set defaults parameters. */
>  	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
>  	    nv->id[2] != 'P' || nv->id[3] != ' ' || 
> nv->nvram_version < 1) {
> @@ -1184,6 +1210,7 @@
>  		nv->add_firmware_options[0] = BIT_5;
>  		nv->add_firmware_options[1] = BIT_5 | BIT_4;
>  		nv->frame_payload_size  = __constant_cpu_to_le16(2048);
> +		nv->special_options.data_rate = SO_DATA_RATE_AUTO;

How about we keep the current byte array definition and add the
following code:

	nv->special_options[1] = BIT_7;

Same effect, less BE/LE structure overhead.


Thanks for the patch,

Andrew Vasquez
QLogic Corporation
