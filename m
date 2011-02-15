From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 10:46:49 -0500
Message-ID: <4D5A9FE9.9020409@interlog.com>
References: <4D5A5388.3010208@ngs.ru>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D5A5388.3010208@ngs.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Artem Bokhan <aptem@ngs.ru>
Cc: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11-02-15 05:20 AM, Artem Bokhan wrote:
> Hello!
>
> I'm trying to get/set sctserc (SMART Command Transport Error Recovery Control)
> data from sata disk attached to lsi megaraid controller with smartmontools, but
> this function does not work.
>
> I want to figure out: is this driver or firmware issue? May someone to help to
> fix this?
>
> The issue can be described as follows:
>
> The ATA PASS-THROUGH(16) implementation in the SAT layer of the megaraid driver
> or firmware does not return the ATA output registers if requested. This violates
> SAT standard (http://www.t10.org/drafts.htm#SAT).
>
> Expected: If CK_COND (bit 5 of CDB[2]) is set, ATA PASS-THROUGH(16) (CDB[0] =
> 0x85) shall return a CHECK CONDITION even if the ATA command completed
> successfully, and return the ATA output registers in the sense data using ATA
> return descriptor format (descriptor code 0x09).
>
> Observed: If CK_COND is set and the ATA command completed successfully, ATA
> PASS-THROUGH(16) does not return a CHECK CONDITION or the sense data does not
> contain an ATA return descriptor.
>
> See also the smartmontools SAT implementation
> (http://sourceforge.net/apps/trac/smartmontools/browser/trunk/smartmontools/scsiata.cpp?rev=3258#L146)
> for further info.

That code looked familiar but I'm not sure what your
point was referring to it. Anyway ...

Haven't worked much with Megaraid controllers but mptsas
controllers implement SAT (or at least did) in their
firmware. So upgrading the firmware on the controller fixed
the problems I had (some years back) with SAT compliance.

Doug Gilbert




