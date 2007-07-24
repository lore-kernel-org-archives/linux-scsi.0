From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Mon, 23 Jul 2007 19:50:23 -0500
Message-ID: <1185238223.3417.42.camel@localhost.localdomain>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
	 <1184941136.3455.8.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
	 <1184950646.3455.45.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
	 <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
Sender: sparclinux-owner@vger.kernel.org
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-07-23 at 23:41 +0100, Mark Fortescue wrote:
> Hi James,
> 
> Can you point me in the direction of any documentation to aid me in 
> identifing what debugging I need to work out what is going on?

they're all in include/scsi/scsi.h

The code is divided into four bytes (from LSB): status, message, host
and driver.  The status is what the SCSI command actually returned (if
anything) the message is what the transport said (least used of the
status codes).  The host byte signals an error condition with the card
and the driver byte with the driver (plus an optional suggestion of what
to do about it).

> For targets without any connected disk, I get scan responses of:
>      scsi scan: INQUIRY failed with code 0x40000
> after app 417ms.

That's host byte 0x04 which is DID_BAD_TARGET.

> For targets with a disk connected, I get scan responses of:
>      scsi scan: INQUIRY failed with code 0x8000002
> after app 170ms.

Thats SCSI status 0x02 (which is CHECK_CONDITION) and driver byte of
0x08, which is DRIVER_SENSE (as in the device returned a sense code).
This is really strange, because the INQUIRY command isn't supposed to be
allowed to return a sense code for precisely this initial scan reason.
This tends to point to a device failure.

James


