From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Mon, 22 Nov 2004 22:06:37 +1000
Message-ID: <41A1D64D.4030508@torque.net>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org> <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org> <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:48780 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262054AbUKVMGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 07:06:31 -0500
In-Reply-To: <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Winterfeldt <snwint@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Steffen Winterfeldt wrote:
> On Mon, 15 Nov 2004, Matthias Andree wrote:
> 
> 
>>James Bottomley <James.Bottomley@SteelEye.com> writes:
>>
>>
>>>Well, I think we're stuck on that one.  SUSE doesn't seem willing to
>>>debug hwscan enough to give a coherent description of the problem or a
>>>non hwscan test case and no-one else wants to take hwscan apart to find
>>>out exactly what it is doing.
> 
> 
> Sorry for the late response; I'm just back from vacation.
> 
> 
>>Steffen, SuSE's hwinfo package throws parity errors on SYM53C8xx
>>hardware.  Same issue with all kernels SuSE shipped for 9.1 including
>>the current 2.6.5-7.111 kernel as well as vanilla 2.6.9.
>>hwinfo-8.62-0.2. hotplugctl-0.08-256 - yet another undocumented piece of
>>who-knows-what-its-good-for.
>>
>>Common trouble introduced by running yast2 or hwinfo is SCSI parity
>>error, phase mismatch, bus reset and sometimes the machine going out to
>>lunch for 2 minutes. It is unclear whether hwinfo probes the hardware
>>directly, confusing the sym53c8xx, or uses some SCSI ioctl that confuses
>>the adaptor. Please help finding _this_ out and if it's hwinfo hacking
>>PCI registers directly, don't do that on ncr/sym/lsi53c8xx and 53c1010
>>chips.
> 
> 
> hwinfo is just a normal program and doesn't do any special tricks on
> hardware. In particular, it issues an scsi inquiry command to get the serial
> number, but that's about all.
> 
> If running just hwinfo breaks things for you, you might try running it
> through strace and look at the files it accesses. Maybe that gives some hint
> to narrow things down.

Steffen,
I recently noticed that VPD page 0x80 (unit serial number)
can be tricky to decode accurately. The reason is that many
"SCSI" devices ignore the EVPD bit and return a
standard INQUIRY response. Previously I simply checked
that byte 1 (origin 0) of the response of a valid VPD
page was its code, in this case: 0x80 .

The problem is that byte 1 of a standard INQUIRY response for
a device with removable media is also 0x80 . So now I also
retrieve the "supported VPD pages" page (0x0) and make
sure it is well formed and indicates that VPD page 0x80 is
supported.

In VPD pages 0x0 and 0x80 byte 2 of the reponse should be 0x0.
Byte 2 in a standard INQUIRY response is only zero when the device
claims no compliance with any SCSI standard. So that is
another possible sanity check.

Doug Gilbert
