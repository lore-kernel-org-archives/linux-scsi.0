From: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: [PATCH] sym53c8xx_2: Add bios_param to sym_glue.c
Date: Fri, 17 Feb 2006 15:41:27 +0100
Message-ID: <43F5E097.4080709@bfh.ch>
References: <43F5D963.9080009@bfh.ch> <20060217143718.GS12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:34737 "EHLO mr1.bfh.ch")
	by vger.kernel.org with ESMTP id S1751461AbWBQOl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 09:41:29 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20060217143718.GS12822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



Matthew Wilcox wrote:
> On Fri, Feb 17, 2006 at 03:10:43PM +0100, Seewer Philippe wrote:
> 
>>This patch adds the scsi common function bios_param to the sym53c8xx
>>driver. For simplicity i just copied the code from the sym53c416 driver.
> 
> 
> If the driver doesn't define bios_param, the scsi core calls
> scsicam_bios_param, which seems to do everything this patch does,
> and more.
> 
> A quick survey suggests that most drivers should have their bios_param
> methods deleted.  Was there a particular problem you found with the
> default scsicam_bios_param implementation?
Yes. Using scsicam_bios_parm and other defaults result in a geometry of
64 heads and 32 sectors even for big disks, which is not what the pc bios
"gets" from the controller. That is more along the lines of 255/63.

Returning a geometry of x/255/63 seems to be the default for bigger disks
withing scsi drivers, so i just copied the code...

