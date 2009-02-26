From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 10:53:48 +0100
Message-ID: <49A666AC.9030202@interlog.com>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39373 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZBZJxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 04:53:55 -0500
In-Reply-To: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> There are a few cases where it would be useful to know which transport
> is associated with a scsi_device.  For instance when determining whether
> to send a READ CAPACITY(16) to a device or not:
> 
>     static int sd_try_rc16_first(struct scsi_device *sdp)
>     {
> 	if (scsi_device_transport(sdp) == SCSI_TRANSPORT_USB)
> 	   return 0; /* Run screaming for the hills */
>     [...]
> 
> This patch implements support for a transport identifier in the
> scsi_host.  The id defaults to SPI and it is explicitly overridden in
> the host templates for FC, SAS, USB, etc. drivers.
> 
> It also looks like the availability of this transport id could improve
> the sysfs parsing in lsscsi.

lsscsi could do with some help detecting the transport.
It uses an untidy set of heuristics now that can easily
be tripped up by sysfs changes.

It may be helpful to differentiate between a "near end"
transport (i.e. between the initiator and the target) and
the transport (and possibly different command set) that
the logical unit (LU) reports.

Doug Gilbert
