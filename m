From: loody <miloody@gmail.com>
Subject: Re: Kernel coredump about kblockd deadlock
Date: Wed, 1 Feb 2012 14:44:38 +0800
Message-ID: <CANudz+uaLFXSzriVSotDAT=_-zyKfpA9ecTcnGnFgn+yeyaZ2Q@mail.gmail.com>
References: <CANudz+um5XG2Qua6a1O7ENnBeYcfiG5mOyyA6-=ctccXMYEFhg@mail.gmail.com>
	<CANudz+uoY8pxCVEeKFhorfb0nqsD+re_Ai-6Ruz2b3ExtJChSA@mail.gmail.com>
	<CANudz+s9wTjWbTYyN292x1Ksh6POh63n-_P+6LX18gQhHmxULQ@mail.gmail.com>
	<4F140401.8050609@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F140401.8050609@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

hi

2012/1/16 Jun'ichi Nomura <j-nomura@ce.jp.nec.com>:
> Hi,
>
> On 01/15/12 23:45, loody wrote:
>> hi all:
>> 2012/1/15 loody <miloody@gmail.com>:
>>> Dear all:
>>> I use kernel 2.6.35.13 and cpu for mips
>>> When I plug in/out usb stick for several times I got following warn=
ing
>>> messages as I append at the end of mail.
>>>
>>> is it possible correlate to below issue
>>> http://thread.gmane.org/gmane.linux.kernel/1177383/focus=3D69879
>> I want to reproduce the issue of the thread above in my platform.
>> But I have no idea about:
>> 1 =A0dm-multipath
>> 2. dm-round-robin
>>
>> are they additional module I need to download or it already include
>> kernel source?
>> if the later, which config I shout select?
>
> They are in kernel source (in drivers/md).
> You have to select CONFIG_BLK_DEV_DM and CONFIG_DM_MULTIPATH
> to enable them.
>
> To try reproducer in the thread, you also need "dmsetup"
> command, which is part of device-mapper utility.
>
>
>> Appreciate your help,
>>
>>>
>>>
>>> INFO: task kblockd/0:10 blocked for more than 120 seconds.
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this me=
ssage.
>>> kblockd/0 =A0 =A0 =A0 =A0D [87016a78] 802d1e48 =A0 =A0 0 =A0 =A010 =
0x00100000 =A0 =A0 =A02
>>> =A0 =A0 =A0 =A0 =A011 =A0 =A0 =A0 9 =A0 =A0 =A0(kernel thread)
>>> Stack : 00000001 80107148 8562ed80 800e9098 00000001 00000001 7ffff=
fff 00000000
>>> =A0 =A0 =A0 =A000000000 7fffffff 87053d38 ffffffff 87053d38 87053d2=
8 872ff00c 802d1e48
>>> =A0 =A0 =A0 =A000000001 00000009 00000102 80071c80 00005965 0056add=
f 00005965 00000001
>>> =A0 =A0 =A0 =A000000000 00000000 7fffffff 80020c64 00000000 0000000=
2 00000000 00000000
>>> =A0 =A0 =A0 =A07fffffff 802d1ca8 00000000 80024538 00000004 0000000=
a 00000001 87016a78
>>> =A0 =A0 =A0 =A0...
>>> Call Trace:
>>> [<802d1764>] schedule+0x648/0x70c from[<802d1e48>] schedule_timeout=
+0x30/0x324
>>> [<802d1e48>] schedule_timeout+0x30/0x324 from[<802d1ca8>]
>>> wait_for_common+0xf8/0x1c0
>>> [<802d1ca8>] wait_for_common+0xf8/0x1c0 from[<80044400>]
>>> __cancel_work_timer+0x188/0x210
>>> [<80044400>] __cancel_work_timer+0x188/0x210 from[<801a48c4>]
>>> blk_cleanup_queue+0x18/0x6c
>>> [<801a48c4>] blk_cleanup_queue+0x18/0x6c from[<802098f4>]
>>> scsi_device_dev_release_usercontext+0x174/0x1e4
>>> [<802098f4>] scsi_device_dev_release_usercontext+0x174/0x1e4
>>> from[<80043aa8>] execute_in_process_context+0x30/0x5c
>>> [<80043aa8>] execute_in_process_context+0x30/0x5c from[<801eeda8>]
>>> device_release+0x54/0x90
>>> [<801eeda8>] device_release+0x54/0x90 from[<801b0180>] kobject_rele=
ase+0x70/0xa8
>>> [<801b0180>] kobject_release+0x70/0xa8 from[<801b17bc>] kref_put+0x=
80/0x98
>>> [<801b17bc>] kref_put+0x80/0x98 from[<80203c04>] scsi_request_fn+0x=
51c/0x61c
>>> [<80203c04>] scsi_request_fn+0x51c/0x61c from[<801a482c>]
>>> generic_unplug_device+0x38/0x7c
>>> [<801a482c>] generic_unplug_device+0x38/0x7c from[<80043e90>]
>>> worker_thread+0x1ec/0x2d4
>>> [<80043e90>] worker_thread+0x1ec/0x2d4 from[<800482c4>] kthread+0x7=
c/0x84
>>> [<800482c4>] kthread+0x7c/0x84 from[<80007818>] kernel_thread_helpe=
r+0x10/0x18
>>>
>>> -------------------------------------------------------------------=
------------------
>>> hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
>>> hub 1-0:1.0: port 1, status 0000, change 0001, 12 Mb/s
>>> usb 1-1: USB disconnect, address 35
>>> usb 1-1: unregistering device
>>> usb 1-1: unregistering interface 1-1:1.0
>>> usb 1-1: usb_disable_device nuking all URBs
>>> hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x0
>>> hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
>>> ehci-ehci ehci-ehci.0: GetStatus port 1 status 000803 sig=3Dj CSC C=
ONNECT
>>> hub 1-0:1.0: port 1, status 0401, change 0001, 480 Mb/s
>>> hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x40=
1
>>> ehci-ehci ehci-ehci.0: port 1 high speed
>>> ehci-ehci ehci-ehci.0: GetStatus port 1 status 00000d sig=3Dse0 PEC=
 PE CONNECT
>>> usb 1-1: new high speed USB device using ehci-ehci and address 36
>>> ehci-ehci ehci-ehci.0: port 1 high speed
>>> ehci-ehci ehci-ehci.0: GetStatus port 1 status 00000d sig=3Dse0 PEC=
 PE CONNECT
>>> usb 1-1: default language 0x0409
>>> usb 1-1: udev 36, busnum 1, minor =3D 35
>
> --
> Jun'ichi Nomura, NEC Corporation
Sorry for late expressing my appreciation.
I didn't see your mail until now.

--=20
Regards,
