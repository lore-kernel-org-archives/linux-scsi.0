From: Jeff Garzik <jeff@garzik.org>
Subject: Re: libata: Simulate REPORT LUNS for ATAPI devices when not supported
Date: Mon, 04 Dec 2006 18:12:56 -0500
Message-ID: <4574AB78.40102@garzik.org>
References: <4574A90E.5010801@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4574A90E.5010801@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Darrick J. Wong wrote:
> The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
> response to a REPORT LUNS packet.  If this happens to an ATAPI device
> that is attached to a SAS controller (this is the case with sas_ata),
> the device does not load because SCSI won't touch a "SCSI device"
> that won't report its LUNs.  If we see this command fail, we should
> simulate a response that indicates the presence of LUN 0.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

I think the answer to this issue lies in the behavior of the majority of 
ATAPI devices when responding to REPORT LUNS.  Regardless of SAS or SATA 
or whatever bus the device is using.

ISTR that REPORT LUNS can make ATAPI devices croak, so it might be wise 
and more safe to simply simulate REPORT LUNS by default for all ATAPI 
devices.  Then readdress the issue if someone has a burning need to 
support the rare multi-LUN ATAPI devices.  I have one, but I'm not 
highly motivated to dig it out.

	Jeff





