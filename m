Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5FB1EC4CF
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 21:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954247; cv=none; b=qSs8HOMg+IUlbNKNTUDVjfHdcG6bq1GGTPRBLswcX9scyNyIOo1QOBzJB6VxLnTALnr3e2gof7fVb7gfGv0THSNthlnTjH6PnszyvCTCOiZj5Lv9ASbAZzCalkhAMVzz7ZU6+zN1advzRSLjb4pU1jOYhMUHM/RDineSu9C8K8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954247; c=relaxed/simple;
	bh=hT6HyvGlrfkgipePte6k5uPwmtS7WK5tD5NhYMvt4yE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VaSrWeeR2DFOsRYLx2DVMo8Z+G3sg4r4gQavier9ySmisOEicXVqrICRzaT9N9YQxErFh0FteajcHo9AtW+DYpLHq1tAkwtmtGadMxjr8TzoUcAqqIrJqSezaNKfpsWL0FGhOaj4NtnP5HGS+5jQ2BLywN701E0tgUxNV87U7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKnBtbBx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKnBtbBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733954243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOLEDRhVNx0gY2IEVfvQ0z6mtkp/8i8UVHEn43vZtZ0=;
	b=XKnBtbBxi7CvY44gIpm1r1b1j4iyc8zIqa48EYYsEECPnaMhXWeMIyn2UCAlq4+qN0XW8R
	9wEYpRLnBAdy3lZeQ02Qd3ielRDwaZUhGQJwN9VCfeRIc12rvzxlQ4zc2GSwgCrwyQR/ea
	hya1qmn/GbxRfDbNaCj6tYArzuUOrTc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-JN5_0y0VOZORJirWzbOaAw-1; Wed,
 11 Dec 2024 16:57:20 -0500
X-MC-Unique: JN5_0y0VOZORJirWzbOaAw-1
X-Mimecast-MFC-AGG-ID: JN5_0y0VOZORJirWzbOaAw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD1A119560BA;
	Wed, 11 Dec 2024 21:57:18 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 73386300019E;
	Wed, 11 Dec 2024 21:57:17 +0000 (UTC)
Message-ID: <0c6e699b-8f77-411f-b73d-e6762c6ad286@redhat.com>
Date: Wed, 11 Dec 2024 16:57:16 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] scsi: st: scsi_error: More reset patches
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Sorry it has taken me so long to get back to this....

I've tested these patches with both my tape drive and with scsi_debug tape emulation.

see:

   https://github.com/johnmeneghini/tape_tests

All hardware tests are passing and everything is working as expected with the tape drive tests, but the power on reset behavior 
of the scsi_debug test is still showing the some strangeness.

  https://github.com/johnmeneghini/tape_tests/blob/master/tape_reset_debug.sh

Specifically, every time you reload the scsi_debug driver the SCSI mid layer clears the POR UA. If I am not mistaken, your 
intention with adding the counters for ua_new_media_ctr and ua_por_ctr to the mid layer was to catch these events and report 
them to the upper layer driver.

Here's what the scsi_debug test does:

[tape_tests]# ./tape_reset_debug.sh 1 3 1 1

modprobe -r scsi_debug
modprobe scsi_debug tur_ms_to_ready=10000 ptype=1  max_luns=1 dev_size_mb=10000

[Wed Dec 11 15:35:48 2024] scsi_debug:sdebug_driver_probe: scsi_debug: trim poll_queues to 0. poll_q/nr_hw = (0/1)
[Wed Dec 11 15:35:48 2024] scsi host8: scsi_debug: version 0191 [20210520]
                              dev_size_mb=10000, opts=0x0, submit_queues=1, statistics=0
[Wed Dec 11 15:35:48 2024] scsi 8:0:0:0: Sequential-Access Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[Wed Dec 11 15:35:48 2024] scsi 8:0:0:0: Power-on or device reset occurred

                                            ^^^^^^^^^^^^^^^^^^^^^^
                        Here's where the scsi layer is clearing the POR UA.

[Wed Dec 11 15:35:48 2024] st 8:0:0:0: Attached scsi tape st1
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: st1: try direct i/o: yes (alignment 4 B)
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: Attached scsi generic sg3 type 1
[0:0:0:0]    disk    ATA      Samsung SSD 840  4B0Q  /dev/sda   3500253855022021d  /dev/sg0
[7:0:0:0]    tape    QUANTUM  ULTRIUM 4        U53F  /dev/st0   -  /dev/sg1
[7:0:1:0]    enclosu LSI      virtualSES       02    -          -  /dev/sg2
[8:0:0:0]    tape    Linux    scsi_debug       0191  /dev/st1   -  /dev/sg3
[N:0:0:1]    disk    INTEL SSDPEDMW400G4__1                     /dev/nvme0n1  -

  Check the status

mt -f /dev/nst1 status
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] check_tape: 1082: pos_unknown 0 was_reset 0/0 ready 0
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (10000):
  IM_REP_EN
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 0
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] Sense Key : Not Ready [current]
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] Add. Sense: Logical unit is in process of becoming ready
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 2

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
st_chk_result was run here... but it looks like scsi_get_ua_por_ctr(STp->device) didn't report the first POR UA.

[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] check_tape: 1141: CHKRES_NOT_READY pos_unknown 0 was_reset 0/0 ready 1
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 1
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] st_flush: 1404: pos_unknown 0 was_reset 0/0 ready 1
[Wed Dec 11 15:35:48 2024] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 1

  Sleeping for 20 seconds

  Check the status

mt -f /dev/nst1 status
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] check_tape: 1082: pos_unknown 0 was_reset 0/0 ready 1
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] Error: 402, cmd: 5 0 0 0 0 0
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] Add. Sense: Invalid command operation code
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 1026
[Wed Dec 11 15:36:08 2024] st 8:0:0:0: [st1] Can't read block limits.
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (1010000):
  ONLINE IM_REP_EN

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A second mt status command is done after the tape is ready...
So it looks like the initial POR UA is never recorded in ua_por_ctr.

Following this, resetting the device works.

sg_reset --target /dev/nst1
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] check_tape: 1082: pos_unknown 0 was_reset 0/0 ready 0
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Error: 402, cmd: 5 0 0 0 0 0
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Add. Sense: Invalid command operation code
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 1026
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Can't read block limits.
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Error: 402, cmd: 1a 0 0 0 c 0
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Add. Sense: Invalid field in cdb
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 1026
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                   scsi mid layer has NOT set was_reset.

[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] No Mode Sense.
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] check_tape: 1282: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] st_flush: 1404: pos_unknown 0 was_reset 1/1 ready 0
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                   We see the scsi mid layer sets was_reset here.

[Wed Dec 11 15:36:09 2024] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 1/1 ready 0

  Sleeping for 5 seconds
  Check the status

  mt -f /dev/nst1 status
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] check_tape: 1082: pos_unknown 0 was_reset 1/1 ready 0
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: Power-on or device reset occurred
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Power on/reset recognized.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here's your code : scsi_get_ua_por_ctr(STp->device) found the reset here.

[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 0
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Sense Key : Unit Attention [current]
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Add. Sense: Scsi bus reset occurred
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 1 was_reset 1/1 ready 0, result 2
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            Position unknown is now set.

[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Error: 402, cmd: 5 0 0 0 0 0
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Add. Sense: Invalid command operation code
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 1 was_reset 1/1 ready 0, result 1026
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Can't read block limits.
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Error: 402, cmd: 1a 0 0 0 c 0
[Wed Dec 11 15:36:14 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
SCSI 2 tape drive:

All in all this is no different from what we have w/out your patches, so I have no problem approving this change.

One thing that did get fixed by this patch series is I can now use the sg device to reset the scsi_debug driver.

This is a good improvement.  I can now run my new script.

https://github.com/johnmeneghini/tape_tests/blob/master/tape_reset_debug_sg.sh

sg_reset --target /dev/sg3

  Sleeping for 5 seconds
  Check the status

  mt -f /dev/nst1 status
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] check_tape: 1082: pos_unknown 0 was_reset 1/1 ready 0
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: Power-on or device reset occurred
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Power on/reset recognized.

  This didn't work before your change.

[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 0
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Sense Key : Unit Attention [current]
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Add. Sense: Scsi bus reset occurred
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 1 was_reset 1/1 ready 0, result 2
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Error: 402, cmd: 5 0 0 0 0 0
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Add. Sense: Invalid command operation code
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 1 was_reset 1/1 ready 0, result 1026
[Wed Dec 11 16:03:39 2024] st 8:0:0:0: [st1] Can't read block limits.
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (1010000):
  ONLINE IM_REP_EN

So all in all I think this is an improvement... I'd like to ask Martin to merge these changes in v6.13.

/John

P.S. There are still many issues with the scsi_debug tape emulation. See my test results for more information about how the 
scsi_debug tape emulation test are failing at:

    https://bugzilla.kernel.org/show_bug.cgi?id=219419#c21

On 11/25/24 09:02, Kai Mäkisara wrote:
> This set applies to 6.12 + the three patches accepted earlier (and in
> linux-next).
> 
> The first patch re-applies after device reset some settings changed
> by the user (partition, density, block size). This is the same as in v1.
> 
> The second and third patch address the case where more than one ULD
> access the same device. The Unit Attention (UA) sense data is sent only
> to one ULD and the others miss it. The st driver needs to find out
> if device reset or media change has happened.
> 
> The second patch adds counters for New Media and Power On/Reset (POR)
> Unit Attentions to the scsi_device struct. The third one changes st
> so that these are used: if the value in the scsi_device struct does
> not match the one stored locally, the corresponding UA has happened.
> Use of the was_reset flag has been removed.
> 
> The fourth patch adds a file to sysfs to tell the user if reads/writes
> to a tape have been blocked following a device reset.
> ---
> Changes since V1:
> - replace the patch removing was_reset handling with patches two and three
> - add sysfs file reset_blocked
> 
> Kai Mäkisara (4):
>    scsi: st: Restore some drive settings after reset
>    scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT
>      ATTENTIONs
>    scsi: st: Modify st.c to use the new scsi_error counters
>    scsi: st: Add sysfs file reset_blocked
> 
>   Documentation/scsi/st.rst  |  5 +++
>   drivers/scsi/scsi_error.c  | 12 +++++++
>   drivers/scsi/st.c          | 73 +++++++++++++++++++++++++++++++++-----
>   drivers/scsi/st.h          |  6 ++++
>   include/scsi/scsi_device.h |  9 +++++
>   5 files changed, 97 insertions(+), 8 deletions(-)
> 

