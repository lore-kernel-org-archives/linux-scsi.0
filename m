From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC] enclosure & ses: modernize and add target power management
Date: Fri, 11 Nov 2011 16:33:02 -0500
Message-ID: <4EBD948E.9000104@interlog.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49221 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1KKVdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 16:33:14 -0500
In-Reply-To: <1321028069.21400.24.camel@nebulus.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11-11-11 11:14 AM, Mark Salyzyn wrote:
> The enclosed code change suggestion is proposed to modernize the
> enclosure drivers. The changes outlined are but only compile&
> checkpatch tested so do not propagate. We will be testing this on a real
> enclosure... Inspection is invited. We would however like the answer to
> a question (with two parts) and a few others:
>
> 1) Is /sys/.../enclosure_device:#/device_power an acceptable node name
> for switching the power on and off for the target?
> 2) Do you think that target power management be made part of the Linux
> power management hierarchy (and clues/pointers to how would be
> nice :-) )
> 3) Add other enclosure bits (eg: Lock&  LED control) while we are here?
> 4) Should the enclosure_component retained values be changed to
> bit-fields?
> 5) Does Evolution work better than Outlook for delivering patch content?
>
> Coincident repair of enclosure and ses device support. Fix problems with
> setting enclosure values careful to preserve other settings. Corrected
> fault setting as well. Modernize code. Add support for Device Power
> Management.

I agree that the code was pretty fragile and needs cleaning up.

> Future: Add target device power-cycle to error recovery escalation,
> between target reset and host bus adapter reset (has to be added to each
> lib<transport>  handler, difficult to visualize in error-handler common
> code :-( ) ?

I wonder about the approach of the ses/enclosure driver
that uses element descriptors as unique labels for overall
and individual element instances. I have an LSI SAS-2
expander (Intel RES2SV240) with a built in SES device
that does exactly that.

However I have output from a "XYRATEX HB-2435"
enclosure where almost all of the array instances
have element descriptors which are empty strings.
Yet things like a power supply element instance
have an element descriptor like this:
"TP=9C;SN=xxx;F1=0311;VR=03;VC=yyy;PN=zzz;"
Is that an abnormal case?
SES-3 says nothing about element descriptors apart
from being ASCII strings. Is it reasonable to assume
they are unique labels?


Anyway I have been doing some work on sg_ses again
(re-jigging its indexing for a second time). My
latest is in the sg3_utils beta on this page:
    http://sg.danny.cz/sg/

With my equipment, setting "device off" has no
effect. [What does "device off" do on your test
hardware?] Since my test setup has unique element
descriptors I can do this:
   sg_ses -D ArrayDevice05 -S devoff /dev/sg3

Alternatively an element index and individual element
index can be used to address that slot:
   sg_ses -I 0,5 -S devoff /dev/sg3


To your question about target power management, the
kernel ses driver is probably better placed than a
user space utility like sg_ses. Yet there are several
ways of target (and related) power management. There
is the Power condition mode page in SCSI which recent
disks support (and the older START STOP UNIT command).
In the SAS (transport) domain there are also power
saving techniques, for example the expander phys facing
the target disk can be put into slumber state (and I
presume the target disk would go into a low power
state in response to that).

Doug Gilbert



