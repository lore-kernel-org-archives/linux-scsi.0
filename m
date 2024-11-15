Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840A21CEAD1
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684891; cv=none; b=juicn9Hz+1NF0iASf7aI/iP3iNatG7DxA+nVm0UO0cw1AF8AAdTTJJPBXwmvSQ6HPd8IQHYtfWlNuJbJytaDZJFKTnHSeRDdk6gFUwsBE5KFkCj5UqbkPX+pp4zDOAarQ30smIzx0a+uYZjM+Y1Cwu/EL8NHK2nPOUQaqZffsRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684891; c=relaxed/simple;
	bh=M8ZLivQu0Wj0bg/RzUl3ezoVud/hf0o13OF3gk0Y//o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qoC+krezAE3Xp2iSaqCHXdr+bFUZeIAyY5uxib4LP9kbKxDZ9QiMDM0ACOdWje+wSGJGfl3trQ/Anv2nht4S8hTBZKXk64iOrkKL6xvUxTPvdqizfISaFP+vw+4tv9IFpmanjAQuuVi7WSCnZOX+U1RUNBeAAgoaj3gflBC1WKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZX8Pv08g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZX8Pv08g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731684888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIsp/qh7aXicsbiCKry5bgmeu2jVgpjuy7ca5NUcPYs=;
	b=ZX8Pv08geOkcGtTgiWbQ3AKgtgCt/UfMSTvc0f758dklUuta/p/1smOxzPIUrM2xOotLVs
	SafzfAKG1VPGTdXDQGg6fYr8ejBAGBbueCYQpyIN3glp1QHA7uhSKsFhzhRwNDGKa8/QI6
	4vnBfXJYbu/xv14BhhpBhOhSzePHHbE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-cG8ZT1k9N4K77nFO3h3O1w-1; Fri,
 15 Nov 2024 10:34:46 -0500
X-MC-Unique: cG8ZT1k9N4K77nFO3h3O1w-1
X-Mimecast-MFC-AGG-ID: cG8ZT1k9N4K77nFO3h3O1w
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50A0D1955DC4;
	Fri, 15 Nov 2024 15:34:45 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 813C4195E480;
	Fri, 15 Nov 2024 15:34:44 +0000 (UTC)
Message-ID: <c1ac0724-df0f-44e8-a447-8186da6289a8@redhat.com>
Date: Fri, 15 Nov 2024 10:34:43 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
To: =?UTF-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, loberman@redhat.com
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-3-jmeneghi@redhat.com>
 <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
 <67da1859-cfd2-45f0-951b-258ebdf6fd5f@redhat.com>
 <01385357-3D40-4720-82ED-AF8EEAFE7351@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <01385357-3D40-4720-82ED-AF8EEAFE7351@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 11/14/24 11:51, "Kai Mäkisara (Kolumbus)" wrote:>
>> On 7. Nov 2024, at 18.05, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> On 11/3/24 13:32, "Kai Mäkisara (Kolumbus)" wrote:
>>>> On 31. Oct 2024, at 3.00, John Meneghini <jmeneghi@redhat.com> wrote:
>>>>
>>>> Be sure to clear was_reset when ever we clear pos_unknown. If we don't
>>>> then the code in st_chk_result() will turn on pos_unknown again.
>>>>
>>>>         STp->pos_unknown |= STp->device->was_reset;
>>>>
>>>> This results in confusion as future commands fail unexpectedly.
>>> This brings in my mind (again) the question: is the hack using was_reset set
>>> by scsi_error to detect device reset necessary any more? It was introduced
>>> as a temporary method somewhere between 1.3.20 and 1.3.30 (in 1995)
>>> when the POR (power on/reset) UAs (Unit Attention) were not passed to st.
>>> The worst problem with this hack is clearing was_reset. St should not clear
>>> something set by error handling (layering violation).
>>
>> OK. I wasn't aware of the history here... but I agree we want to get rid of the layering violation.
>>
> I have read code and done experiments. I think I now know how the POR UAs were lost
> in 1990s. And why that does not happen now.
> 
> In 1.3.30, scsi.c handled resets. When resetting, it set the device->expecting_cc_ua flag.
> If UA was received when expecting_cc_ua was set, the command was retried if
> retries were allowed. St allowed five retries for TEST UNIT READY and so the POR UA
> was left in the midlevel. (If expecting_cc_ua was zero, UA:s were returned to the upper
> level.)

> Now, st does allow zero retries. In addition to this, the requests use either REQ_OP_DRV_IN
> or REQ_OP_DRV_OUT and these requests are not retried. So, now POR UAs reach
> st (as the experiments have indicated).

Yes, the only time I've see the POR UA not get passed to the st driver is with scsi_debug, when
the driver first loads.

[tape_tests]# modprobe -r scsi_debug
[tape_tests]# modprobe scsi_debug  ptype=1  max_luns=1 dev_size_mb=10000
[Fri Nov 15 09:28:51 2024] scsi_debug:sdebug_driver_probe: scsi_debug: trim poll_queues to 0. poll_q/nr_hw = (0/1)
[Fri Nov 15 09:28:51 2024] scsi host8: scsi_debug: version 0191 [20210520]
                              dev_size_mb=10000, opts=0x0, submit_queues=1, statistics=0
[Fri Nov 15 09:28:51 2024] scsi 8:0:0:0: Sequential-Access Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[Fri Nov 15 09:28:51 2024] scsi 8:0:0:0: Power-on or device reset occurred
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The sg driver is clearing the UA here.

[Fri Nov 15 09:28:51 2024] st 8:0:0:0: Attached scsi tape st1
[Fri Nov 15 09:28:51 2024] st 8:0:0:0: st1: try direct i/o: yes (alignment 4 B)
[Fri Nov 15 09:28:51 2024] st 8:0:0:0: Attached scsi generic sg3 type 1

[tape_tests]# mt -f /dev/nst1 status
[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] check_tape: 1064: pos_unknown 0 was_reset 0 ready 0
[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] Error: 402, cmd: 5 0 0 0 0 0
[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] Sense Key : Illegal Request [current]
[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] Add. Sense: Invalid command operation code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
There should be a UA right here.

I have no idea whey the scsi_debug driver doesn't support READ BLOCK LIMITS.

[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] st_chk_result: 421: pos_unknown 0 was_reset 0 ready 0, result 1026
[Fri Nov 15 09:28:55 2024] st 8:0:0:0: [st1] Can't read block limits.
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (1010000):
  ONLINE IM_REP_EN

Another problem with using scsi_debug is:

[tape_tests]# sg_reset --target /dev/sg3

This does nothing.  I have to use the /dev/st device to reset.  This is not true if you have a real tape device.

[tape_tests]# sg_reset --target /dev/nst1
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] check_tape: 1064: pos_unknown 0 was_reset 1 ready 0
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: Power-on or device reset occurred
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 0
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Sense Key : Unit Attention [current]
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Add. Sense: Scsi bus reset occurred
[Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] st_chk_result: 421: pos_unknown 1 was_reset 1 ready 0, result 2
^^^^^^^^^^^^^^^^^^
Now we've set pos_unkown.

>>> Your earlier patch added code to st to set pos_unknown when a POR UA
>>> was found. So, is this now alone enough to catch the resets?
>>
>> As long at the tape device actually sends a UA, no I don't think we need the was_reset code anymore.
>> We should remove the device->was_reset code from st.c. >
> Using device->was_reset has the advantage that it does not depend on the
> drives sending UA. However, I think that a probability of a working drive
> not sending UA after reset is minimal.

Agreed. There are some idiosyncrasies in the scsi_debug tape emulation. But I don't want those problems to make their way into 
the st driver. I don't think the st driver should be paying attention to was_reset, or anything else in the mid layer.

>>> I now did some experiments with scsi_debug and in those experiments
>>> reset initiated using sg_reset did result in st getting POR UA.
>>> But this was just a simple and somewhat artificial test.
>>
>> Yes, I've noticed that not all of the different emulators out there like MHVTL and scsi_debug
>> will reliably send a POR UA following sg_reset. Especially scsi_debug. The tape emulation in
>> scsi_debug is inadequate when it comes to resets AFAIAC.
>>
>> I'll see if I can develop some further tests for MHVLT, but scsi_debug isn't worth the
>> trouble (for me) and I've told our QE group here at Red Hat to stop testing the st driver
>> with scsi_debug.  Doing this has led to too many false positives and passing tests. That's
>> why I finally purchased a tape drive and started testing this myself.
> 
> I have a more positive view about scsi_debug. Its tape support is minimal, but it can be
> useful if you consider what it does support and what it doesn't support.
> 
> A real drive is better, of course.

Please try my latest version of the tape_reset_debug.sh script.

https://github.com/johnmeneghini/tape_tests/blob/master/tape_reset_debug.sh

This test uses the scsi_debug driver with ptype=1 to test these patches using "sg_reset --target /dev/nst$i".

There is also the tape_reset_debug_sg.sh script. That script runs the same tests using "sg_reset --target /dev/sg$i"

They each give me different false negative and false positive results... but that may because of something I'm doing wrong.

>> If you want to remove the device->was_reset from the st driver I can help by running
>> the patch through my tests with the tape device.
> 
> I will send patches tomorrow. The patches will also include a fix to another problem:
> some parameters should be restored after reset in case of some operations like rewind:
> the partition, density and block size should be restored to the values set before reset.

OK, I will test those as soon as they show up.

> Thanks for your testing (so far and in future).

And Thanks for your help fixing these bugs...

/John

> Kai
> 

