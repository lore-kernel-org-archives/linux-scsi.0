From: Matthew Jacob <mjacob@feral.com>
Subject: Re: SCSI Command scatter-gather number
Date: Tue, 30 Jul 2002 22:26:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0207302222170.63843-100000@beppo>
References: <20020731011159.B27756@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020731011159.B27756@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, Mike Anderson <andmike@us.ibm.com>, Haofeng Kou <haofengk@ptu.promise.com>, linux-scsi@vger.kernel.org

> 
> However, the way that the Qlogic driver needs to calculate both the
> available sg table entries and the available command queue slots is
> actually odd enough that no generic mechanism for supporting it in the mid
> layer is possible.  Only the driver really knows how these finite
> resources are used up, and when you know the manipulations the driver goes
> through then you'll agree only the driver should know, I'm sure ;-)

It's a combination of:

	how much request queue space is available*

	how many s/g elements you need to use (depending on length of
	command and whether you need to use A64 or A32 entries)

	how much SRAM is on the card in question and how much was taken
	up by firmware version XYZ loaded from flash or host

	how many commands are in process

	how many current active exception conditions are in use

Note that the request queue space just is there long enough to put down a
command and notify the f/w on the qlogic. When it can, it moves the request
into onboard SRAM before beginning execution.

Except for running out of queue space with extremely long s/g lists, the rest
is far too hard to really figure out. 

Luckily the QLogic f/w will synthesize a QFULL if you go over execution
throttle, or otherwise overrun internal resources. So it goes.

-matt



* 256 entries for 1020/1040 product, any unsigned 16 bit value for
Ultra2/Ultra3 or FC products.

