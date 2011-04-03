From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: caviar black + mpt2sas horrific performance
Date: Sun, 03 Apr 2011 13:35:24 -0400
Message-ID: <4D98AFDC.3010401@interlog.com>
References: <20110330080114.GA5066@apartia.fr> <4565AEA676113A449269C2F3A549520F8086471A@cosmail03.lsi.com> <20110330201700.GA6775@apartia.fr> <4565AEA676113A449269C2F3A549520F808648E9@cosmail03.lsi.com> <20110331153456.GA13754@apartia.fr> <4565AEA676113A449269C2F3A549520F808E4AB6@cosmail03.lsi.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37254 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab1DCRfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Apr 2011 13:35:37 -0400
In-Reply-To: <4565AEA676113A449269C2F3A549520F808E4AB6@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-04-02 12:51 AM, Moore, Eric wrote:
> On Thursday, March 31, 2011 9:35 AM, Louis-David Mitterrand wrote:
>> On Thu, Mar 31, 2011 at 09:07:05AM -0600, Moore, Eric wrote:
>>> On Wednesday, March 30, 2011 2:17 PM, Louis-David Mitterrand wrote:
>>>> On Wed, Mar 30, 2011 at 02:02:12PM -0600, Moore, Eric wrote:
>>>>> Hi Louis, can you send me your /var/log/messages and dmesg output?
>>>>> Please capture after you've run your test.
>>>>
>>>> Hi,
>>>>
>>>> My test produces no specific output through dmesg or /var/log/messages
>>>> as there is no apparent error from the controller.
>>>>
>>>> However I can send you the syslog startup output. Let me know if I can
>>>> run any further tests or provide more information.
>>>>
>>>
>>> need you to set the mpt2sas logging level to 0x310 just before you run
>> you test, then capture the logs after.
>>> Please make sure your syslog level is set to capture all KERN_XXX levels
>> to include KERN_DEBUG.
>>>
>>> Example:
>>> # echo 0x310>  /sys/module/mpt2sas/parameters/logging_level
>>
>> Hi,
>>
>> Here is the output:
>>
>> Mar 31 17:07:50 zenon kernel: setting logging_level(0x00000310)
>> Mar 31 17:24:29 zenon kernel: sd 0:0:0:0: [sda] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:29 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221103000000), phy(3)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(0)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	handle(0x0009),
>> ioc_status(success)(0x0000), smid(1344)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:29 zenon kernel: sd 0:0:0:0: [sda] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:29 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221103000000), phy(3)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(0)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	handle(0x0009),
>> ioc_status(success)(0x0000), smid(884)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:29 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:30 zenon kernel: sd 0:0:1:0: [sdb] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221102000000), phy(2)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(1)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	handle(0x000a),
>> ioc_status(success)(0x0000), smid(100)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:30 zenon kernel: sd 0:0:1:0: [sdb] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221102000000), phy(2)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(1)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	handle(0x000a),
>> ioc_status(success)(0x0000), smid(510)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:30 zenon kernel: sd 0:0:2:0: [sdc] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221101000000), phy(1)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(2)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	handle(0x000b),
>> ioc_status(success)(0x0000), smid(1455)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:30 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:31 zenon kernel: sd 0:0:2:0: [sdc] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:31 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221101000000), phy(1)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(2)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	handle(0x000b),
>> ioc_status(success)(0x0000), smid(966)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:31 zenon kernel: sd 0:0:3:0: [sdd] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:31 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221100000000), phy(0)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(3)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	handle(0x000c),
>> ioc_status(success)(0x0000), smid(519)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:31 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:32 zenon kernel: sd 0:0:3:0: [sdd] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221100000000), phy(0)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(3)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	handle(0x000c),
>> ioc_status(success)(0x0000), smid(1125)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:32 zenon kernel: sd 0:0:4:0: [sde] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221104000000), phy(4)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(7)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	handle(0x000d),
>> ioc_status(success)(0x0000), smid(570)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:32 zenon kernel: sd 0:0:4:0: [sde] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221104000000), phy(4)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(7)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	handle(0x000d),
>> ioc_status(success)(0x0000), smid(28)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:32 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:33 zenon kernel: sd 0:0:5:0: [sdf] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:33 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221107000000), phy(7)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(4)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	handle(0x000e),
>> ioc_status(success)(0x0000), smid(471)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:33 zenon kernel: sd 0:0:5:0: [sdf] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:33 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221107000000), phy(7)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(4)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	handle(0x000e),
>> ioc_status(success)(0x0000), smid(789)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:33 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:34 zenon kernel: sd 0:0:6:0: [sdg] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:34 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221106000000), phy(6)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(5)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	handle(0x000f),
>> ioc_status(success)(0x0000), smid(594)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:34 zenon kernel: sd 0:0:6:0: [sdg] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:34 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221106000000), phy(6)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(5)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	handle(0x000f),
>> ioc_status(success)(0x0000), smid(761)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:34 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:35 zenon kernel: sd 0:0:7:0: [sdh] CDB: ATA command pass
>> through(16): 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> Mar 31 17:24:35 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221105000000), phy(5)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(6)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	handle(0x0010),
>> ioc_status(success)(0x0000), smid(1127)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> Mar 31 17:24:35 zenon kernel: sd 0:0:7:0: [sdh] CDB: ATA command pass
>> through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00
>> Mar 31 17:24:35 zenon kernel: mpt2sas0:
>> 	sas_address(0x4433221105000000), phy(5)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0:
>> 	enclosure_logical_id(0x5842b2b05020c600), slot(6)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	handle(0x0010),
>> ioc_status(success)(0x0000), smid(1583)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	request_len(0), underflow(0),
>> resid(0)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	tag(0), transfer_count(0), sc-
>>> result(0x00000002)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	scsi_status(check
>> condition)(0x02), scsi_state(autosense valid )(0x01)
>> Mar 31 17:24:35 zenon kernel: mpt2sas0: 	[sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>
>
> Well you've got a load of SATA passthru request with RECOVERED_ERROR sense key is probably effecting your performance.
>
> Any chance you could try shutdown the daemons that are sending those request?   I doubt its coming via the filesystem and the test your running.

The daemon in question is probably smartd. And RECOVERED
ERROR is the expected sense key when the CK_COND bit is
set in the SCSI ATA PASS-THROUGH command. It requests the
ATA registers after the ATA device has executed the related
command. And if that causes a significant delay in the
mpt2sas driver then IMO that is a bug in the driver.

One piece of additional information that may be useful is
whether fixed or descriptor format sense data is returned.
With SAT-1 only descriptor format was allowed. In SAT-2
(now a standard) it can be fixed or descriptor format with
the preference seeming to be with the former. My tools and
smartmontools (smartd) cannot handle fixed format sense
data from SCSI ATA PASS-THROUGH commands.

Doug Gilbert

