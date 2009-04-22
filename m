From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Re: The order of generating sd name
Date: Wed, 22 Apr 2009 19:09:57 +0800
Message-ID: <d364733c0904220409g4a86cf54k82ab3b7afdbcb8a2@mail.gmail.com>
References: <d364733c0904210226i2b48ae21pb5c39f338f53194b@mail.gmail.com>
	 <20090421144313.GA313@mars.virtualiron.com>
	 <d364733c0904210801n2d317adeh1978d71c35741c0b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:9625 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZDVLJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 07:09:58 -0400
Received: by wf-out-1314.google.com with SMTP id 26so212028wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 04:09:57 -0700 (PDT)
In-Reply-To: <d364733c0904210801n2d317adeh1978d71c35741c0b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: linux-scsi@vger.kernel.org

2009/4/21 =D0=BB=B8=D9 <xiegang112@gmail.com>:
> On Tue, Apr 21, 2009 at 10:43 PM, Konrad Rzeszutek
> <konrad@virtualiron.com> wrote:
>> On Tue, Apr 21, 2009 at 05:26:40PM +0800, =D0=BB=B8=D9 wrote:
>>> Hi,
>>>
>>> I find there will be different name order of sd device when connect=
ing
>>> different array. My case is as following:
>>> I have a SUSE server, and two array (let's say host, array1 and
>>> array2. Two arrays are from different vendor). They are connected
>>> through FC. There is two HBA controllers(let's say c1,c2) on host.
>>> case1: host is connected to array1.
>>> sd driver will generate the name orderly for each HBA controller. F=
or examle:
>>> c1: /dev/sda  /dev/sdb /dev/sdc
>>> c2:/dev/sdd /dev/sde  /dev/sdf
>>>
>>> case2: host is connected to array2.
>>> sd driver will generate the name ramdonly for each HBA controller. =
=46or examle:
>>> c1: /dev/sda  /dev/sdd /dev/sde
>>> c2:/dev/sdb /dev/sdc  /dev/sdf
>>>
>>> Why is the order different with different array?
>>
>> You can also use /dev/disk/by-path instead of the /dev/sdX names.
>>
>>>
>>> I went through the sd probe part of linux scsi subsystem.  In
>>> scsi_probe_lun, an inquery command will be issued to probe the lun.
>>> This request will be executed with scsi_execute. This function is s=
ync
>>> and blocked. Because it invokes the blk_execute_rq to exec the
>>> request, in blk_execute_rq:
>>> rq->end_io_data =3D &wait;
>>> blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
>>> wait_for_completion(&wait);
>>>
>>> According to above, sd driver probes one lun at one time. Before
>>> respone to current inquery is returned, no other inquery is issued.=
 In
>>> another word, the proccess of probe lun is sync and blocked.
>>
>> Per HBA. Since you have two HBA's they can both probe the LUNs at th=
e
>> same time. Or depending on how the array works, it allows you to pro=
be
>> on the first HBA first, and then on the second.
I found that, my my kernel version is 2.6.16 (SUSE10). And the HBA
driver are qla. The scsi async scan is not supported in this version.
And It seems that,  if the scan starts at scsi_scan_host, the naming
order is ensured.  Did the qla driver scan the lun in the thread
qla2x00_do_dpc itself?  To generate the sd name, sd_probe need to be
invoked. I can not find the invokation in the qla driver.
> I noticed that the async lun scaning was added to sd driver in later
> version of kernel.It seems that the scan of scsi host would start onl=
y
> after the scan of previous finished:
>
>        if (!shost->async_scan)
>                scsi_complete_async_scans();
> Is this means that for the luns which belong to the same host
> controller, the naming order is preserved?
>>
>>> The whole sequence of proble lun is:
>>> scan host controller->scan target->probe and add lun.
>>> So,  the whole procedure of sd probe should be serial.  but why is
>>> there case2? Is it because the different order of executing command=
 on
>>> array? But according the code of  sd driver, it seems it's not the
>>> root cause.
>>>
>>> Thanks,
>>>
>>>
>>>
>>> --
>>> Xie Gang
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Xie Gang
>



--=20
Xie Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
