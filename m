From: =?ISO-8859-1?Q?Rapha=EBl_Bauduin?= <rblists@gmail.com>
Subject: Re: strange observation, the queue depth is (64) meanwhile fw queue
 depth (65)
Date: Tue, 08 Apr 2014 09:13:05 +0200
Message-ID: <li07i1$306$1@ger.gmane.org>
References: <lh1c4r$uss$1@ger.gmane.org> <lh3sqb$i8p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50062 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbaDHHNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Apr 2014 03:13:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1WXQDd-0000PA-D1
	for linux-scsi@vger.kernel.org; Tue, 08 Apr 2014 09:13:17 +0200
Received: from 217.64.254.218.mactelecom.net ([217.64.254.218])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 08 Apr 2014 09:13:17 +0200
Received: from rblists by 217.64.254.218.mactelecom.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 08 Apr 2014 09:13:17 +0200
In-Reply-To: <lh3sqb$i8p$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 03/28/2014 02:18 PM, Rapha=EBl Bauduin wrote:
> On 03/27/2014 03:21 PM, Rapha=EBl Bauduin wrote:
>> Hi,
>>
>> I have these messages logged on 2 different servers (one production,=
 one
>> stand-by) when using recent vanilla kernels.
>>
>> I have found references to these logs, but this was supposedly
>> introduced in the 2.6.31 kernel.
>> However, running kernel 2.6.32.61, this message does not appear. It
>> appears when running kernel versions 3.12.15, 3.13.1 and 3.13.6. I
>> haven't tested other intermediate kernel versions.
>>
>> We had once the root filesystem remounted read-only on the productio=
n
>> server, and we found no significant error messages other than the on=
e in
>> the subject of this mail. This makes me wary to ignore these message=
s,
>> and since then we went back to kernel 2.6.32.61.... I've tried runni=
ng
>> kernels mentioned above on the stand-by server, and get the errors t=
here
>> too.
>>
>> Here is the exact error message from dmesg:
>>
>> [ 3776.788033] sd 7:1:0:0: strange observation, the queue depth is (=
64)
>> meanwhile fw queue depth (65)
>>
>> and below are some other extracts from dmesg.
>>
>> Both servers have these errors on a RAID1 volume on which the root
>> partition is located.
>>
>> I hope someone can help me to resolve this. I can send any informati=
on
>> you might require.
>>
>> Thanks in advance
>>
>> Rapha=EBl
>>
>>
>> [    2.978053] SCSI subsystem initialized
>> [    2.979969] Fusion MPT base driver 3.04.20
>> [    2.980059] Copyright (c) 1999-2008 LSI Corporation
>>
>>
>> [    3.712015] ioc0: LSISAS1064E B3: Capabilities=3D{Initiator}
>>
>> [   16.516096] scsi7 : ioc0: LSISAS1064E B3, FwRev=3D01182b00h, Port=
s=3D1,
>> MaxQ=3D286, IRQ=3D16
>> [   16.536672] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_=
id
>> 2, phy 0, sas_addr 0x500000e01ee1a602
>> [   16.538312] scsi 7:0:0:0: Direct-Access     FUJITSU  MBC2073RC  5=
201
>> PQ: 0 ANSI: 5
>> [   16.542605] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_=
id
>> 1, phy 1, sas_addr 0x500000e01edab602
>> [   16.544158] scsi 7:0:1:0: Direct-Access     FUJITSU  MBC2073RC  5=
201
>> PQ: 0 ANSI: 5
>> [   16.548445] mptsas: ioc0: attaching raid volume, channel 1, id 0
>> [   16.549304] scsi 7:1:0:0: Direct-Access     LSILOGIC Logical Volu=
me
>>   3000 PQ: 0 ANSI: 2
>> [   16.556492] sd 7:1:0:0: [sdr] 140623872 512-byte logical blocks:
>> (71.9 GB/67.0 GiB)
>> [   16.556824] sd 7:1:0:0: [sdr] Write Protect is off
>> [   16.556895] sd 7:1:0:0: [sdr] Mode Sense: 03 00 00 08
>> [   16.557109] sd 7:1:0:0: [sdr] No Caching mode page found
>> [   16.557180] sd 7:1:0:0: [sdr] Assuming drive cache: write through
>> [   16.558258] sd 7:1:0:0: [sdr] No Caching mode page found
>> [   16.558329] sd 7:1:0:0: [sdr] Assuming drive cache: write through
>> [   16.575039]  sdr: sdr1 sdr2
>> [   16.576018] sd 7:1:0:0: [sdr] No Caching mode page found
>> [   16.576088] sd 7:1:0:0: [sdr] Assuming drive cache: write through
>> [   16.576356] sd 7:1:0:0: [sdr] Attached SCSI disk
>>
>
>
> I have looked at the source code and the function
> mptsas_handle_queue_full_event is present and similar in all kernel
> versions I have tested, yet only version 2.6.32.61 doesn't log any er=
ror.
>
> I conclude that there's something else making that the queue is full.
> If this mailing list is not the right place to get help about this,
> please redirect me as I'm currently stuck on the 2.6.32 kernel due to
> this. Any help will be appreciated!
>
> Rapha=EBl
>

I have found out that using the deadline scheduler on the disk causes=20
the same error messages to appear, even with the 2.6.32 kernel. This=20
does not happen with the cfq scheduler. I will try to increase the valu=
e=20
in /sys/block/sdm/device/queue_depth (which is 64 like reported by the=20
error message) and the value in /sys/block/sdm/queue/nr_requests=20
accordingly (I read the cfq scheduler advises to use double the value=20
for nr_requests).

I'll post further findings here, in case it can help someone

Raph




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
