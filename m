From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 16:38:58 -0600
Message-ID: <4429BB02.80304@us.ibm.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com> <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32656 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932467AbWC1WjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 17:39:19 -0500
In-Reply-To: <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-03-28 at 16:17 -0600, Brian King wrote:
>> Add a max_cmd_len field to the scsi_device struct
>> to allow for per device limits of allowable command
>> lengths. This will be used by libata, which is currently
>> using the max_cmd_len field in the scsi_host struct,
>> which doesn't work for attaching libata controlled
>> SATA devices to SAS HBAs.
> 
> This really doesn't look correct.  What you want is a sata transport
> class with a max command length in the host device.

My direction at this point has been to move away from
the virtual scsi host device for SATA devices attached
to SAS HBAs. This seemed to me to be the clearest implementation.
Then you have 1 SAS HBA = 1 struct scsi_host, no matter
how many SATA devices are attached underneath it either
via direct attach or via an expander.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
