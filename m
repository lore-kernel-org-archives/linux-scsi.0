From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: mpt2sas SATA spinup behavior
Date: Fri, 03 Jan 2014 08:44:09 -0600
Message-ID: <52C6CCB9.80601@nuclearwinter.com>
References: <52C35664.7000006@nuclearwinter.com> <94D0CD8314A33A4D9D801C0FE68B40295485D2BD@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([174.136.96.186]:46997 "EHLO
	mail.nuclearwinter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbaACOoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 09:44:08 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295485D2BD@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks for the reply, Rob.

The spinup count and spinup interval were 2 targets and 2 seconds. I
changed the values to 8 targets and 0 seconds.  The change did not alter
the behavior I'm seeing.

To spin down the drives I'm sending an ATA STANDBY IMMEDIATE command via
ATA Pass-Through SG_IO. The controller is definitely aware of this
because LSI's sas2ircu utility reports the drive status as "Available"
when in standby as opposed to "Ready" when spinning.

I'm running an IT firmware and these drives are JBOD as far as the
controller is concerned.

--Larkin

On 1/2/2014 5:02 PM, Elliott, Robert (Server Storage) wrote:
> In SAS systems, it's common for controllers and expanders to rotate spinup
> permission across phys to avoid overloading the power supply (e.g., if the
> system is sized to support 8 x 18 W drives, it might not work if 8 x 45 W
> are briefly consumed).  The most common algorithm allows n phys to spinup 
> at a time, waiting m seconds for the next set.  It would be prudent for a
> controller in an unknown server to be very cautious and use large values.
>
> A web search shows the LSI WebBIOS Configuration Utility offers 
> these controls:
> "Spinup Drive Count 
>  Controls the number of drives that spin up simultaneously.
> The default is 2 drives. 
>  
>  Spinup Delay 
>  Controls the interval (in seconds) between the spinup of drives connected 
> to this controller. The delay prevents a drain on the system power supply
>  that would occur if all drives spun up at the same time. 
> The default is 12 seconds. "
>
> For SAS drives, spinup is controlled with the NOTIFY (ENABLE SPINUP)
> primitive.  This occurs at power on and during any subsequent power draws 
> due to changing back to the active power condition using START STOP UNIT 
> commands (from stopped) or media access commands (from standby).
>
> For SATA drives, spinup is controlled at power on by delaying the initial
> OOB  signal exchange.  There is no easy way to control spinup thereafter if
> changing back to the active power condition with a media access command
> (from standby).
>
> How are you spinning down these drives - with the SCSI START STOP UNIT 
> command being translated by the LSI controller's SCSI-to-ATA translation
> layer into an ATA STANDBY IMMEDIATE command?  LSI might be keeping
> track of the drive's power condition and delaying media access commands 
> per the spinup rotation timing, while Marvell might be just passing the
> commands through.
> ---
> Rob Elliott    HP Server Storage
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Larkin Lowrey
>> Sent: Tuesday, 31 December, 2013 5:42 PM
>> To: linux-scsi@vger.kernel.org
>> Subject: mpt2sas SATA spinup behavior
>>
>> I'm seeing odd behavior while spinning up SATA drives on my LSI SAS 2008
>> controller.
>>
>> I have 8 drives I keep spun down (most of the time).  I wrote a tool to
>> spin them all up at the same time by reading a sector from each drive
>> (one thread per drive). Four of the drives are connected to a Marvell
>> controller (mvsas) and the other four to an LSI 2008 (mpt2sas).
>>
>> The four on the mvsas controller all finish spinning up after ~13s. The
>> four on the mpt2sas controller finish after 40s. The mpt2sas drives,
>> when spun up individually, will complete spin up in ~9s (except one at
>> 13s). It appears that each of the four drives are being accessed
>> sequentially instead of in parallel and that they must all complete
>> their spin up before any can complete their I/O. The mvsas drives, on
>> the other hand, perform their spin-up I/O in parallel (different brand
>> drive, 13s spin-up).
>>
>> Is there something unique to the LSI 2008 that requires SATA spin-up to
>> be handled this way (sequentially)?
>>
>> I see no errors in dmesg/syslog. Are there any debug facilities that
>> might shed light on what's going on?
>>
>> Can anyone recommend areas in the source code where I might start
>> hunting for a root cause?
>>
>> Here's some additional detail. My tool watches for activity on any
>> member drive and when there is activity on one it will spin up the
>> remaining drives. In this first case I kicked an mpt2sas drive so the
>> remaining 3 would be spun up along with the 4 mvsas drives. The three
>> large numbers in brackets are milliseconds since the beginning of time.
>> The first is the timestamp right before the block device is opened
>> (O_DIRECT), the second is after open but before read(), and the third is
>> after the read has completed.
>>
>> Interestingly, the open() does not complete for the 3 mpt2sas drives
>> until 9s after the trigger drive was kicked. So, it appears that all I/O
>> for the remaining drives was blocked while the controller waited for the
>> first drive to respond. That seems bad.
>>
>> Dec 31 16:26:14 fubar hdpwr[5941]: Now spinning: /dev/sdf
>> ST4000DM000-1F2168 s/n:#####NRE
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdg
>> ST4000DM000-1F2168 s/n:#####C85
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdh
>> ST4000DM000-1F2168 s/n:#####C8M
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sde Hitachi
>> HDS724040ALE640 s/n:#####4AT
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdm Hitachi
>> HDS724040ALE640 s/n:#####7TW
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdn Hitachi
>> HDS724040ALE640 s/n:#####R2T
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdo Hitachi
>> HDS724040ALE640 s/n:#####BST
>> Dec 31 16:26:14 fubar hdpwr[5941]: Spinning up /dev/sdp Hitachi
>> HDS724040ALE640 s/n:#####M3T
>> Dec 31 16:26:28 fubar hdpwr[5941]: Spinup completed in 13.366s for
>> /dev/sdp Hitachi HDS724040ALE640 s/n:#####M3T [1388528774946
>> 1388528774946 1388528788312]
>> Dec 31 16:26:28 fubar hdpwr[5941]: Spinup completed in 13.441s for
>> /dev/sdm Hitachi HDS724040ALE640 s/n:#####7TW [1388528774945
>> 1388528774945 1388528788386]
>> Dec 31 16:26:28 fubar hdpwr[5941]: Spinup completed in 13.464s for
>> /dev/sdn Hitachi HDS724040ALE640 s/n:#####R2T [1388528774946
>> 1388528774946 1388528788410]
>> Dec 31 16:26:28 fubar hdpwr[5941]: Spinup completed in 13.501s for
>> /dev/sdo Hitachi HDS724040ALE640 s/n:#####BST [1388528774946
>> 1388528774946 1388528788447]
>> Dec 31 16:26:56 fubar hdpwr[5941]: Spinup completed in 41.199s for
>> /dev/sde Hitachi HDS724040ALE640 s/n:#####4AT [1388528774945
>> 1388528784021 1388528816144]
>> Dec 31 16:26:57 fubar hdpwr[5941]: Spinup completed in 41.207s for
>> /dev/sdh ST4000DM000-1F2168 s/n:#####C8M [1388528774945
>> 1388528784021
>> 1388528816152]
>> Dec 31 16:26:57 fubar hdpwr[5941]: Spinup completed in 41.226s for
>> /dev/sdg ST4000DM000-1F2168 s/n:#####C85 [1388528774945
>> 1388528784021
>> 1388528816171]
>> Dec 31 16:26:57 fubar hdpwr[5941]: Spinup complete
>>
>> Here's another example:
>>
>> Dec 31 16:47:35 fubar hdpwr[5941]: Now spinning: /dev/sdp Hitachi
>> HDS724040ALE640 s/n:#####M3T
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdm Hitachi
>> HDS724040ALE640 s/n:#####7TW
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdh
>> ST4000DM000-1F2168 s/n:#####C8M
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sde Hitachi
>> HDS724040ALE640 s/n:#####4AT
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdg
>> ST4000DM000-1F2168 s/n:#####C85
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdn Hitachi
>> HDS724040ALE640 s/n:#####R2T
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdf
>> ST4000DM000-1F2168 s/n:#####NRE
>> Dec 31 16:47:35 fubar hdpwr[5941]: Spinning up /dev/sdo Hitachi
>> HDS724040ALE640 s/n:#####BST
>> Dec 31 16:47:49 fubar hdpwr[5941]: Spinup completed in 13.394s for
>> /dev/sdm Hitachi HDS724040ALE640 s/n:#####7TW [1388530055877
>> 1388530055877 1388530069271]
>> Dec 31 16:47:49 fubar hdpwr[5941]: Spinup completed in 13.431s for
>> /dev/sdn Hitachi HDS724040ALE640 s/n:#####R2T [1388530055877
>> 1388530055877 1388530069308]
>> Dec 31 16:47:49 fubar hdpwr[5941]: Spinup completed in 13.434s for
>> /dev/sdo Hitachi HDS724040ALE640 s/n:#####BST [1388530055879
>> 1388530055879 1388530069313]
>> Dec 31 16:48:07 fubar hdpwr[5941]: Spinup completed in 31.496s for
>> /dev/sde Hitachi HDS724040ALE640 s/n:#####4AT [1388530055877
>> 1388530055877 1388530087373]
>> Dec 31 16:48:16 fubar hdpwr[5941]: Spinup completed in 31.497s for
>> /dev/sdh ST4000DM000-1F2168 s/n:#####C8M [1388530055877
>> 1388530055877
>> 1388530087374]
>> Dec 31 16:48:16 fubar hdpwr[5941]: Spinup completed in 40.768s for
>> /dev/sdg ST4000DM000-1F2168 s/n:#####C85 [1388530055877
>> 1388530055877
>> 1388530096645]
>> Dec 31 16:48:16 fubar hdpwr[5941]: Spinup completed in 40.911s for
>> /dev/sdf ST4000DM000-1F2168 s/n:#####NRE [1388530055877
>> 1388530078331
>> 1388530096788]
>> Dec 31 16:48:16 fubar hdpwr[5941]: Spinup complete
>>
>> In this case I kicked an mvsas drive so all 4 mpt2sas drives would spin
>> up together. For three mpt2sas drives the open() calls completed at the
>> same time but the fourth open() was delayed 23s (13-ish + 9-ish). The
>> first two mpt2sas drives seem to be batched together and both I/O's had
>> to wait until both had spun up sequentially. The second two drives had
>> to wait until the first two drives had completed and both of them seem
>> to have been batched together.
>>
>> --Larkin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

