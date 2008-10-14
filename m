From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 14:45:53 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650EE@hkgmail01.lsi.com>
References: <20081014025651.GB10518@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40679 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYJNGqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 02:46:00 -0400
In-Reply-To: <20081014025651.GB10518@akamai.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijit Paithankar <apaithan@akamai.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

I couldn't check with 1030 but with mptsas, with SATA drives with the patch sent by Eric, I am able to see the err_cnt not getting incremented to 1.

Can you please add some debug prints in the mptscsih_io_done before calling sc->scsi_done(sc); to print the command if the result is a non zero. Like the one below.

if(sc->result)
        scsi_print_command(sc);

And print the sensekey, ASC,ASCQ in mptscsih_copy_sense_data
        printk("SK %x ASC %x.. ASCQ %x\n ",sense_data[2], sense_data[12],sense_data[13]);

And send me the log offline, It should tell you which command is failing.

Thanks
Sathya


-----Original Message-----
From: Abhijit Paithankar [mailto:apaithan@akamai.com]
Sent: Tuesday, October 14, 2008 8:27 AM
To: Prakash, Sathya
Cc: Douglas Gilbert; linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up

* Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
> I found the reason for the non zero err_cnt for SATA drives attached to mptsas.
> It is due to the failure in sending mode sense request for page 0x19 from mptsas driver for SATA drives (which is not supported by MPTSAS controller).

I see the same problem with LSI53C1030 with SCSI disks attached. So it might not be a SATA-only problem.

Thanks!
Abhijit

