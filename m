From: David Miller <davem@davemloft.net>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Mon, 23 Jul 2007 19:49:27 -0700 (PDT)
Message-ID: <20070723.194927.41635520.davem@davemloft.net>
References: <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
	<Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
	<1185238223.3417.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1185238223.3417.42.camel@localhost.localdomain>
Sender: sparclinux-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: mark@mtfhpc.demon.co.uk, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Mon, 23 Jul 2007 19:50:23 -0500

> On Mon, 2007-07-23 at 23:41 +0100, Mark Fortescue wrote:
> > For targets with a disk connected, I get scan responses of:
> >      scsi scan: INQUIRY failed with code 0x8000002
> > after app 170ms.
> 
> Thats SCSI status 0x02 (which is CHECK_CONDITION) and driver byte of
> 0x08, which is DRIVER_SENSE (as in the device returned a sense code).
> This is really strange, because the INQUIRY command isn't supposed to be
> allowed to return a sense code for precisely this initial scan reason.
> This tends to point to a device failure.

Devices return CHECK_CONDITION and give SENSE (usually a
UNIT_ATTENTION) when they are given an INQUIRY command too soon after
a scsi bus reset, I saw it all the time when bringing up the new ESP
driver.

There is even special case code in the SCSI bus scan that accepts
certain special cases of UNIT_ATTENTION check conditions as valid:

		if (result) {
			/*
			 * not-ready to ready transition [asc/ascq=0x28/0x0]
			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
			 * INQUIRY should not yield UNIT_ATTENTION
			 * but many buggy devices do so anyway. 
			 */
			if ((driver_byte(result) & DRIVER_SENSE) &&
			    scsi_sense_valid(&sshdr)) {
				if ((sshdr.sense_key == UNIT_ATTENTION) &&
				    ((sshdr.asc == 0x28) ||
				     (sshdr.asc == 0x29)) &&
				    (sshdr.ascq == 0))
					continue;
			}
		}

asc/ascq values that do not pass this test are what Mark is seeing.

And again this is almost always because the device is being sent
the INQUIRY too soon after a scsi bus reset.
