From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Thu, 07 Dec 2006 10:47:15 -0500
Message-ID: <45783783.3040800@torque.net>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org> <4574B004.6030606@us.ibm.com> <45780726.8010107@garzik.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45780726.8010107@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Darrick J. Wong wrote:
>> The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
>> response to a REPORT LUNS packet.  If this happens to an ATAPI device
>> that is attached to a SAS controller (this is the case with sas_ata),
>> the device does not load because SCSI won't touch a "SCSI device"
>> that won't report its LUNs.  Since most ATAPI devices don't support
>> multiple LUNs anyway, we might as well fake a response like we do for
>> ATA devices.
>>
>> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> Seems sane to me, but I would like additional comment/testing/etc.
> before applying...

A SCSI target contains zero or more logical units. As
in this case, those logical units may use a different
transport. In such cases a SCSI target needs to emulate responses
to some SCSI commands (and modify the responses to others).
Here is a list that is probably not comprehensive:
  - INQUIRY  (peripheral qualifier in standard response)
  - INQUIRY, device identification VPD page (0x83)
       - obviously for the device name+identifier and port
         name+identifier
       - may need to concatenate those with the lu's
         name+identifier
  - INQUIRY, SCSI ports VPD page
  - INQUIRY, ATA Information VPD page (for SAT)
  - REPORT LUNS [mandatory in SPC-3 hence mandatory in SAT]
  - protocol specific port mode page (0x19)
  - protocol specific lu mode page (0x18) [could simulate]
  - PATA control mode page (0xa,0xf1) (for SAT)
  - protocol specific port _log_ page (0x18)

And for SAT you could add the ATA PASS-THROUGH
commands to that list. Those that are really ambitious
could implement well know logical units (wluns) which are
essentially a clean way to talk directly to the target
rather than a logical unit.


About the multi-lun ATAPI devices comment: how would libata
represent multiple S-ATAPI devices connected to a SATA
port multiplier?

Doug Gilbert


