From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Mon, 13 Oct 2008 19:40:37 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA6506F@hkgmail01.lsi.com>
References: <20081009005126.GA7954@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56688 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbYJMLk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 07:40:56 -0400
In-Reply-To: <20081009005126.GA7954@akamai.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijit Paithankar <apaithan@akamai.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

I found the reason for the non zero err_cnt for SATA drives attached to mptsas.
It is due to the failure in sending mode sense request for page 0x19 from mptsas driver for SATA drives (which is not supported by MPTSAS controller).

In the slave_configure function of mptsas driver, the transport layer function sas_read_port_mode_page is called for all the devices attached with the MPTSAS controller. Since it is that particular mode page is not supported for SATA drives, Check condition with Skey=Invalid request and ASC=Invalid field in CDB is returned. Hence the error count is incremented by the scsi_done.

If it needs to be fixed, then we need to provide a patch in mptsas driver so that it will not call sas_read_port_mode_page for SATA devices.


Thanks
Sathya

-----Original Message-----
From: Abhijit Paithankar [mailto:apaithan@akamai.com]
Sent: Thursday, October 09, 2008 6:21 AM
To: Douglas Gilbert
Cc: Prakash, Sathya; linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up

* Douglas Gilbert (dgilbert@interlog.com) wrote:
>
> IMO it is not an error for the host to receive such UAs just after
> power up, and soon thereafter. It is potentially an error to have such
> UAs while a partition on a LU within a target is mounted. But the SCSI
> subsystem is not aware of mounts. Perhaps there should be a separate
> counter (i.e. other than ioerr_cnt) for UAs associated with hard
> resets.

If a hard reset is part of routine initialization at power-on, then it is not an error and the MPT driver should not tell the scsi mid-layer that an error happened.

Thanks!
Abhijit
