From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: 20 Nov 2003 04:19:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq0islf5rdm.fsf@wildopensource.com>
References: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44776 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S264275AbTKTJTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 04:19:53 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jbarnes@sgi.com

>>>>> "Andrew" == Andrew Vasquez <andrew.vasquez@qlogic.com> writes:

>> - Call pci_set_consistent_dma_mask() to allow for 64 bit consistent
>> allocations, required on some platforms such as the SN2.

Andrew> Yes, I believe Jeremy forwarded a patchset for the 6.x driver.

Andrew,

Yep, my patch is basically a consolidation of Jeremy's changes and a
few extras of my own.

>> - Wait 20 usecs (not sure how long is really necessary, but this
>> seems safe) after setting CSR_ISP_SOFT_RESET in the ctrl_status
>> register as the card doesn't respond to PCI reads while in reset
>> state. This causes a machine check on some architectures.  - Flush
>> PCI writes before calling udelay() to ensure the write is not
>> sitting idle in-flight for a while before hitting the hardware.

Andrew> Yes, we also need to look at some PCI posting issues with our
Andrew> move to MMIO.

I went through the init code and I didn't notice any other posting
issues, but that doesn't mean there aren't any ;-) Some of the higher
end ia64 McKinley boxees such as hte HP and SGI ones are good for
triggering these.

>> - Use auto-negotiate link speed when using default parameters
>> rather than NVRAM settings. Disable NVRAM reading on SN2 since it's
>> not possible to execute the HBA's BIOS on an SN2.

Andrew> Internally, we've been talking about taking a more defensive
Andrew> route within the driver if the NVRAM data is not valid --
Andrew> failing the initialization process completely, and therefore,
Andrew> removing this code completely from the driver.

I would really like to discourage this approach. Instead I think it
would be better to sit down with a manual and plug in safe defaults
for all the entries. I have run into the problem several times in
particular with the qla1280 based cards that the NVRAM settings were
bogus and I couldn't get to them. I don't know if this can happen with
the FC cards, but I have seen cases where machines have OEM'd SCSI
parts without and NVRAM and QL HBAs in their PCI slots, in this case
you end up with a situation where some of the devices have to be
mangled via a BIOS mangling tool and otheres require command line
parameters.

The Linux model is quite different here, we normally rely on sane
defaults in the driver and then allow users to tweek these settings in
/etc/modules.conf or through /proc at runtime.

Then there's the problems non-x86 platforms not having tools
available, and even if they are out there, they might not match the
version of glibc you are running or your distribution of choice. I
checked out your web page and I only see references to Red Hat Linux
and SuSE Linux both in 32 and 64 bit (presuming that by 32 bit you
mean x86 and by 64 bit you mean ia64 - just that naming doesn't make
any sense in the Linux space since we support a lot of different 32
and 64 bit architectures).

If the tools were open source that would make it slightly easier, but
even then you have the problem that you need to be able to boot the
system to get to the settings. If I have say an PPC64 box with my root
file system on a QL2344, I lose.

Andrew> Manufacturing writes a pre-canned NVRAM image along with a
Andrew> rolling serial number (unique to each HBA) to each card that
Andrew> leaves QLogic.  One obvious example of a potential problem in
Andrew> the case of using the (driver) doctored NVRAM data is how to
Andrew> assign a unique serial number to the ISP that is being
Andrew> initialized.  BTW: The serial number is actually encoded in
Andrew> bytes 5, 6, and 7 of the WWPN (portname); coupled with the
Andrew> hardcoded port number (33) and the QLogic copany code of (224
Andrew> and 139), code from qla2x00_nvram_config():

Ok this one is more tricky. There's a couple of options though, we
could generate a unique serial number based on the random driver
output, or maybe it's worth coming up with an infrastructure for this,
other FC card drivers will run into the same problem.

Andrew> I don't believe this is going to be a safe route.  QLogic does
Andrew> offer other methods to modify NVRAM parameters besides the
Andrew> BIOS utility, a GUI (SANsurfer) as well as a command-line tool
Andrew> (SANblade CLI) - the 64bit versions are available here:

I didn't actually know these existed, I never noticed a reference to
them in the driver. However as Matthew pointed out, they don't really
solve the problem for non-x86 and non-ia64 users.

>> /* Bad NVRAM data, set defaults parameters. */ if (chksum ||

Andrew> How about we keep the current byte array definition and add
Andrew> the following code:

Andrew> nv->special_options[1] = BIT_7;

Andrew> Same effect, less BE/LE structure overhead.

I prefer the other way, it's a lot more readable for outsiders who do
not have a copy of the firmware programming guide (such as myself).

Thanks,
Jes
