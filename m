From: Willem Riede <wrlk@riede.org>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Wed, 28 Jan 2004 13:33:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128183323.GG23308@serve.riede.org>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org> <20040128084142.A4835@beaverton.ibm.com> <20040128173609.GE23308@serve.riede.org> <20040128095341.A5242@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:53914 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266131AbUA1Sd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 13:33:26 -0500
Content-Disposition: inline
In-Reply-To: <20040128095341.A5242@beaverton.ibm.com> (from patmans@us.ibm.com on Wed, Jan 28, 2004 at 12:53:41 -0500)
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 2004.01.28 12:53, Patrick Mansfield wrote:
> On Wed, Jan 28, 2004 at 12:36:09PM -0500, Willem Riede wrote:
> > On 2004.01.28 11:41, Patrick Mansfield wrote:
> 
> > > Do you know if the single lun code is for performance, or because of
> > > hardware limitations - that is we don't want a disc change between IO, or
> > > does the device just fail?
> > 
> > In the case of the NEC PD/CD, it is a hardware limitation. You can only
> > have one disc inserted at a time, either CD or PD. Mixing IO will fail
> > for the absent media type.
> 
> BTW what is PD?

PD stands for PowerDrive, it uses 650MB (CD size) cartridges that Panasonic
invented before there were writable CDs. I assume they're a type of magneto-
optical device.
 
> So there is one physical drive that can hold one disc, and it can only use
> the LUN associated with the disc that is currently in the drive; and reading
> or accessing the wrong LUN will always fail?
> 
> We don't need single_lun code for that, we can just let the IO fail, right?

That would be no problem. All the single-lun code does is delay the inevitable:
if I address the /dev/scdX which corresponds to the /dev/sdY that's the PD disk
when it's loaded, it _will_ fail (after all IO to the PD's lun finishes).

> I assume there are other single_lun devices that automatically change discs.

Yes, there would be, like CD changers. (That reminds me, I've got one of
those lying around too - I just don't remember how broken it was when I
removed it...)

Regards, Willem Riede.


