From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] mpt2sas: Wait for port enable to get complete
 before reporting devices to OS.
Date: Sun, 05 Sep 2010 13:34:56 -0300
Message-ID: <1283704496.15944.1271.camel@mulgrave.site>
References: <20100804083355.GB13442@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40505 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab0IEQfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 12:35:03 -0400
In-Reply-To: <20100804083355.GB13442@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, 2010-08-04 at 14:04 +0530, Kashyap, Desai wrote:
> Add support in driver so it will wait for discovery to complete
> before returning from the send_port_enable routine.  There are some
> cases where firmware is doing discovery after port enable completes.
> When it does this, the driver will not have all the devices in the
> sas_device_init_list list prior to calling the sort routine for reporting
> boot devices to OS.
> 
> This patch is required so the driver is waiting for all the events to
> be processed in the hot plug worker thread prior to reporting them to the
> OS.
> 
> (1) The driver will wait for port enable to complete
> (2) Wait for the first discovery stop event
> (3) Wait an additional 500ms in case there are additional discoveries
> (4) process device list -> reporting devcies to OS

Why is there any need to wait and sort at all?  If you just report the
devices as hotplug sees them, boot will be much faster (especially for
root devices).

James


