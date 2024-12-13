Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DCF632
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734111164; cv=none; b=oVPo9hVphqtx9VTQoCXbCEvCZhB8BJFFGCtwvstG2zmLcLsyRXPIbSLSOyk4fgFNc51wXC11YyeZTs4GaZpvps4eeDmEeBvZKOS1sgj7OYwtjXLj/ayUnOUBy4/MzkHeriPzVtZxavDYWx/tyihSKvmOOlRowKWKqB6OiV4hXtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734111164; c=relaxed/simple;
	bh=oQY12+PRZw3Q5tgiaOzuiJr25OrpCa7HxcC9vp0oX9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SGN1zTfT89PQDivkA1CrYaL9ufYo8kBFRPfwW9oHBChuI8ef+U9Vt0mk3t8WuhuXAGkSNHmmDeVVSrRMYGXoIQ1cO16k7RpGxy/B71zmwH7KB4d2F+agX8JP86+oS0O5To5Ej/JF+IuHL93fynfeVvC0javStO40L+NhJOILM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQG6M9Xe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQG6M9Xe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734111161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MhpKoKFpLv6ek9HAesOhWyiErOhhmu1AE0LGwQpksVo=;
	b=HQG6M9XeLZqD8h/3Ns1iMcnDt4IYUAID+2VcHzMLFTTyqhLmUvEBUvOZsRf2LIvEcE+pAl
	frIsz5+PAF0WDrcdbVlFkj3QUDOnKMRi0DuVYnwQ1jQMGB8NJFz3ehoyQm5El21KIysS6e
	xMb6XC7vDKvaz5g8vlrnrE7diVdGxZs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-MwC5gezxMwKmbjaKm6mXPQ-1; Fri,
 13 Dec 2024 12:32:37 -0500
X-MC-Unique: MwC5gezxMwKmbjaKm6mXPQ-1
X-Mimecast-MFC-AGG-ID: MwC5gezxMwKmbjaKm6mXPQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 746F619560B5;
	Fri, 13 Dec 2024 17:32:36 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8AC1F1956052;
	Fri, 13 Dec 2024 17:32:34 +0000 (UTC)
Message-ID: <ad401bf6-e4a6-4372-8205-22e923900e5e@redhat.com>
Date: Fri, 13 Dec 2024 12:32:33 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>, loberman@redhat.com,
 Bryan Gurney <bgurney@redhat.com>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
 <8B3169CC-BD8A-46B5-B9B0-140047A44661@kolumbus.fi>
 <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <964CF609-B7DB-44CF-80A2-2955E73561EF@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 12/13/24 08:09, "Kai Mäkisara (Kolumbus)" wrote:
> 
>> On 12. Dec 2024, at 20.27, Kai Mäkisara (Kolumbus) <kai.makisara@kolumbus.fi> wrote:
>>
>> While doing some detective work, I found a serious problem. So, please hold these patches again.
>> More about the reason below.
> ...
>> The problem is that no driver options for the device can be set before something has
>> been done to clear the blocking. For instance, the stinit tool is a recommended method
>> to set the options based on a configuration file, but it fails.

And "the blocking" is because pos_unknown is set?

>> Note that this problem has existed since commit 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
>> (for version 6.6) that added recognition of POR UA as an additional method to detect
>> resets. Nobody seems to have noticed this problem in the "real world". (Using
>> was_reset was not problematic because it caught only resets initiated by the midlevel.)

Just to be clear. People in the real world did notice this problem. We have multiple customers who have reported "regressions" 
in the st driver, all of whom starting using a version of our distribution which had commit 9604eea5bd3a. The changes for
9604eea5bd3a (scsi: st: Add third party poweron reset handling) were necessary to fix a real customer reported problem, but 
there were a number of regressions introduced by this change and it looks like we haven't gotten to the bottom of these 
regressions. Basically, we had so many customer complaints about this that we reverted commit 9604eea5bd3a in rhel-8.

>> A solution might be to add some more ioctls to the list of allowed commands.
>> But I must think about this a little more.

I think that might be a good way to go.

> This does not seem to be a promising direction. I think it is better to see that the
> first test_ready() (called from st_open()) does not set the pos_unknown flag.
> If there are no objections, I will add this to the next version of the patches.

So I don't know about this. Any tur/open that detects a POR/UA should turn on pos_unknown. This is the third party reset 
problem.  If you ignore was_reset in the st driver then there's no way to tell if any particular POR/UA is a result of an 
intended action (the user reset the device on purpose) or if the tape device, or scsi gateway, or scsi transport error, or 
anything else actually reset the device.

> The justification for this solution is that just after the device is detected by st,
> the position of the tape is known to the user and there is no need to prevent,
> for instance, writing to the tape.

What do you mean by "just after the device is detected"?  How can you accurately detect this meta-condition?

I'd say, any time the st driver is loaded (modprobe -r st; modprobe st) the position should probably be assumed at unknown. And 
any time a POR, Not Ready or Media Change is detected, the position should DEFINITELY be unknown until the tape is 
rewound/re-positioned.

I don't think we can or should assume anything about the position of the tape in the driver.

Here's a test that's currently passing with my spc-3 tape device.

[root@to-be-determined tape_tests]# lsscsi -ig
[0:0:0:0]    disk    ATA      Samsung SSD 840  4B0Q  /dev/sda   3500253855022021d  /dev/sg0
[7:0:0:0]    tape    QUANTUM  ULTRIUM 4        U53F  /dev/st0   -  /dev/sg1
[7:0:1:0]    enclosu LSI      virtualSES       02    -          -  /dev/sg2
[N:0:0:1]    disk    INTEL SSDPEDMW400G4__1                     /dev/nvme0n1  -
[root@to-be-determined tape_tests]# modprobe -r st
[Fri Dec 13 11:44:40 2024] st: Unloaded.
[root@to-be-determined tape_tests]# lsscsi -ig
[0:0:0:0]    disk    ATA      Samsung SSD 840  4B0Q  /dev/sda   3500253855022021d  /dev/sg0
[7:0:0:0]    tape    QUANTUM  ULTRIUM 4        U53F  -          -  /dev/sg1
[7:0:1:0]    enclosu LSI      virtualSES       02    -          -  /dev/sg2
[N:0:0:1]    disk    INTEL SSDPEDMW400G4__1                     /dev/nvme0n1  -
[root@to-be-determined tape_tests]# sg_reset --target /dev/sg1
[Fri Dec 13 11:46:37 2024] scsi target7:0:0: attempting target reset! scmd(0x00000000b33bbaf4)
[Fri Dec 13 11:46:37 2024] scsi 7:0:0:0: CDB: Test Unit Ready
[Fri Dec 13 11:46:37 2024] scsi target7:0:0: handle(0x000a), sas_address(0x500110a0014e8914), phy(0)
[Fri Dec 13 11:46:37 2024] scsi target7:0:0: enclosure logical id(0x500605b00cf207c0), slot(4)
[Fri Dec 13 11:46:37 2024] scsi target7:0:0: enclosure level(0x0000), connector name( C1  )
[Fri Dec 13 11:46:37 2024] scsi target7:0:0: target reset: SUCCESS scmd(0x00000000b33bbaf4)

So now let's attach the st driver "for the fist time".
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[root@to-be-determined tape_tests]# modprobe st debug_flag=1
[Fri Dec 13 11:53:00 2024] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[Fri Dec 13 11:53:00 2024] st: Debugging enabled debug_flag = 1
[Fri Dec 13 11:53:00 2024] st 7:0:0:0: Attached scsi tape st0
[Fri Dec 13 11:53:00 2024] st 7:0:0:0: st0: try direct i/o: yes (alignment 4 B)

[root@to-be-determined tape_tests]# mt -f /dev/nst0 status
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: Power-on or device reset occurred
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Power on/reset recognized.
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Error: 2, cmd: 0 0 0 0 0 0
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Sense Key : Unit Attention [current]
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Add. Sense: Scsi bus reset occurred
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] st_chk_result: 432: pos_unknown 1 was_reset 1/1 ready 0, result 2
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x46 (LTO-4).
Soft error count since last status=0
General status bits on (1010000):
  ONLINE IM_REP_EN
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:53:17 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
pos_unnkown is set, as it should be, because the device was reset between close/unload and load/open.

[root@to-be-determined tape_tests]# sg_inq /dev/nst0
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 1 was_reset 1/1 ready 0
sg_inq failed: Input/output error
close error: Input/output error
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 11:59:00 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is the problem you're talking about.  There are many ioctls that won't work while pos_unknown is set.  They won't work 
until a rewind/reposition is done... but I think think this is the design.

[root@to-be-determined tape_tests]# mt -f /dev/nst0 stshowoptions
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:24:51 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0
The options set: buffer-writes async-writes read-ahead debug can-bsr

[root@to-be-determined tape_tests]# mt -f /dev/nst0 stsetoptions no-blklimits
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:26:12 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 1 was_reset 1/1 ready 0
/dev/nst0: Input/output error

[root@to-be-determined tape_tests]# mt -f /dev/nst0 rewind
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 1 was_reset 1/1 ready 0
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] Rewinding tape.
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:26:28 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 0 was_reset 1/1 ready 0

[root@to-be-determined tape_tests]# mt -f /dev/nst0 stsetoptions no-blklimits
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] Mode 0 options: buffer writes: 1, async writes: 1, read ahead: 1
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0]     can bsr: 1, two FMs: 0, fast mteom: 0, auto lock: 0,
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0]     defs for wr: 0, no block limits: 1, partitions: 0, s2 log: 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0]     sysv: 0 nowait: 0 sili: 0 nowait_filemark: 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0]     debugging: 1
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:26:31 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 0 was_reset 1/1 ready 0

[root@to-be-determined tape_tests]# mt -f /dev/nst0 stshowoptions
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] check_tape: 1082: pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] Density 46, tape length: 0, drv buffer: 1
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] check_tape: 1282: CHKRES_READY pos_unknown 0 was_reset 1/1 ready 0
[Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] st_flush: 1404: pos_unknown 0 was_reset 1/1 ready 0
[root@to-be-determined tape_tests]# [Fri Dec 13 12:29:12 2024] st 7:0:0:0: [st0] flush_buffer: 852: pos_unknown 0 was_reset 1/1
ready 0
The options set: buffer-writes async-writes read-ahead debug can-bsr no-blklimits



[root@to-be-determined tape_tests]#  sg_inq /dev/sg1
standard INQUIRY:
   PQual=0  PDT=1  RMB=1  LU_CONG=0  hot_pluggable=0  version=0x05  [SPC-3]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=1  3PC=0  Protect=0  [BQue=0]
   EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=1
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=96 (0x60)   Peripheral device type: tape
  Vendor identification: QUANTUM
  Product identification: ULTRIUM 4
  Product revision level: U53F
[root@to-be-determined tape_tests]#


