From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Suggestions for testing SAS cables via sg3_utils
Date: Wed, 18 Mar 2015 16:14:01 -0400
Message-ID: <5509DC89.9030506@interlog.com>
References: <5509D10F.2020601@aeoncomputing.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44288 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbbCRUOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 16:14:25 -0400
In-Reply-To: <5509D10F.2020601@aeoncomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On 15-03-18 03:25 PM, Jeff Johnson wrote:
> Greetings,
>
> Does anyone have an effective way of testing SAS cabling in a Linux
> environment without using a block storage device?
>
> Something like reading/writing to a buffer in an expander (LSI). Something
> that could stress all four lanes of a multilane cable. Like a SAS equivalent of
> a floodping between a SAS initiator and a SAS expander to stress the cable.

Jeff,
For SAS targets you could use sg_senddiag (sg3_utils)
to put one or more phys in test/training mode. In
the sg3_utils examples directory there are some
templates (e.g. sdiag_sas_p0_cjtpat.txt). [See
spl4r02.pdf section 9.2.9.2]

For expander phys you might use smp_phy_test to put one
or more in test/training mode. I'm not aware of a SCSI
loopback test in which the remote end is an expander ***.
[See spl4r02.pdf section 9.4.3.29]

On a 4 wide cable between a HBA and an expander with a
SAS disk beyond you might put 3 of those expander phys in
training mode then to to use READ BUFFER on the echo buffer
in the disk. The SCSI command should squeeze through on
the remaining path. Then rotate which phy is the "clear"
path.

My guess is initiator phys can also be put in training mode.
If so that would involve some LLD specific action.

Doug Gilbert


*** checked two LSI expanders (one SAS-2, the other SAS-3)
     and they don't support the SCSI READ BUFFER command on
     the SES target that is connected to a virtual expander
     phy. Might be useful if they did.


