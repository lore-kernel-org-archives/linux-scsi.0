From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 00:13:36 +1100
Message-ID: <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
References: <4F312492.1040002@de.ibm.com>
	<OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
	<4F313526.2050907@redhat.com>
	<OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
	<4F3390FB.80107@redhat.com>
	<1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
	<4F38B657.7060405@de.ibm.com>
	<4F38C27E.7030300@redhat.com>
	<1329136806.9333.383.camel@haakon2.linux-iscsi.org>
	<4F3907EB.4030402@redhat.com>
	<20120213130005.GB26773@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120213130005.GB26773@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>> Only if you use the pci multi-function option but that kills
>> standard hot unplug
>
> It doesn't kill it as such, rather you can't unplug luns individually.

Isnt that just a consequence of the current implementation rather than
a SCSI limitation?

A different way to do hoplug could be to flag all devices as removable
in the standard inq page then
leave the LUN there persistently and what you remove/add is not the
LUN device itself but just the media in the device.

Instead of hot-plug remove the LUN,  hot-plug becomes "media eject" or
"media insert".
The device remains present all time, you never remove it, but instead
hot-plug controls if the media is present or not.


This would require implementing at least START_STOP_UNIT and
PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.


regards
ronnie sahlberg
