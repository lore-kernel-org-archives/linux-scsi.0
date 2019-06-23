From: lijiang <lijiang@redhat.com>
Subject: Re: When SME is enabled on Dell PowerEdge R7425(AMD) machine, the
 first kernel can not successfully boot because of the megaraid_sas failure
Date: Sun, 23 Jun 2019 11:05:19 +0800
Message-ID: <d6b5ebc1-2d4b-0446-28ee-0966b633dc8a@redhat.com>
References: <e1a1f87b-0dc7-ec53-e60f-cac3dd3349e6@redhat.com>
 <aad69259-617e-7d89-1347-01e45b447f31@amd.com>
 <50455778-58f0-dd6d-87d6-ba4a4510b2c5@redhat.com>
 <894d6108-71c3-a3ce-2caa-97e2117bbae1@amd.com>
 <05957295-a29f-8249-867f-77ca7b3a925b@amd.com>
 <fc5fe59c-2a25-f3a0-58a7-7bd1a999232a@redhat.com>
 <ab2dd485-406f-0670-f95d-d483cbffec66@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ab2dd485-406f-0670-f95d-d483cbffec66@amd.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>, "shivasharan.srikanteshwara@broadcom.com" <shivasharan.srikanteshwara@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

在 2019年06月21日 21:45, Lendacky, Thomas 写道:
> On 6/21/19 1:09 AM, lijiang wrote:
>> 在 2019年06月18日 23:51, Lendacky, Thomas 写道:
>>> On 6/17/19 9:49 PM, Lendacky, Thomas wrote:
>>>> On 6/17/19 4:24 AM, lijiang wrote:
>>>>> 在 2019年06月16日 22:40, Lendacky, Thomas 写道:
>>>>>> On 6/14/19 11:31 PM, lijiang wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On the Dell PowerEdge R7425(AMD) machine, when SME is enabled, the first kernel can not successfully boot because of
>>>>>>> the following failure:
>>>>>>> ......
>>>>>>> [  211.950273] megaraid_sas 0000:61:00.0: Init cmd return status FAILED for SCSI host 0
>>>>>>> [  211.982750] megaraid_sas 0000:61:00.0: Failed from megasas_init_fw 5900
>>>>>>> ......
>>>>>>>
>>>>>>> Please refer to the kernel log.
>>>>>>
>>>>>> That points to something that the driver is doing that is not compatible
>>>>>> with SME in the area of DMA. Either something to do with the DMA masks
>>>>>> or the use (or not use of) of the DMA allocation/mapping area:
>>>>>>
>>>>>> [  211.950273] megaraid_sas 0000:61:00.0: Init cmd return status FAILED for SCSI host 0
>>>>>> [  211.982750] megaraid_sas 0000:61:00.0: Failed from megasas_init_fw 5900
>>>>>>
>>>>>> You'll need to look at that init sequence and see what is being supplied
>>>>>> to the hardware. It doesn't appear that the IOMMU is enabled, so if the
>>>>>> driver isn't using SWIOTLB, then any DMA addresses should have the
>>>>>> encryption bit set as part of what is supplied to the device. If the
>>>>>> descriptor has physical addresses in it the driver should be using the DMA
>>>>>> api to map those (which will return an address with the encryption bit
>>>>>> set).
>>>>>>
>>>>>
>>>>> Thank you, Tom. I made a draft patch, it works well.
>>>>>
>>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>> index 3dd1df472dc6..e1b2855f0af3 100644
>>>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>>>> @@ -5493,7 +5493,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
>>>>>          }
>>>>>   
>>>>>          base_addr = pci_resource_start(instance->pdev, instance->bar);
>>>>> -       instance->reg_set = ioremap_nocache(base_addr, 8192);
>>>>> +       instance->reg_set = ioremap_nocache(__sme_clr(base_addr), 8192);
>>>>
>>>> Good find!  I wonder why base_addr is coming back with a physical address
>>>> that has the encryption bit set, though. Can you see how the device
>>>> resources are being set?  I think a better fix might be for bar resources
>>>> not to have the encryption bit set to begin with. I'll see what I can find
>>>> also.
>>>
>>>  From my quick scanning, it seems that the resource start value is read
>>> from the PCI config without modification. Is BIOS/UEFI possibly setting
>>> the value with the encryption bit set when it shouldn't be?
>>>
>> Sorry for the delay.
>>
>> Although the draft patch is not a correct bugfix, i'm not sure the reason why this
>> problem only happened when SME was active. Probably it also needs to figure out the
>> reason why it cannot be reproduced after applying the draft patch.
> 
> Right, I agree. As a start, It would be good to printk the base_addr value
> in both the SME and non-SME active cases to see what the value is, along

I just wanted to tell you about this. Previously, the base_addr value was mistaken for
having the SME mask. But, i printed the base_addr value, which was 0xc4000000 in both
the SME and non-SME active case.

#cat /proc/iomem|grep -i pci
......
c4000000-d0ffffff : PCI Bus 0000:60
  c4000000-c41fffff : PCI Bus 0000:61
......

I'm curious why it can not be reproduced after applying the draft patch(clear the sme mask)
although the draft patch was not correct.

Not sure whether you noticed the following kernel logs by journalctl:
......
systemd-udevd[1056]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
......
systemd-udevd[1020]: seq 3835 '/devices/pci0000:60/0000:60:03.1/0000:61:00.0' is taking a long time
systemd[1]: dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device: Job dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device/start timed out.
systemd[1]: Timed out waiting for device dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device.
......
systemd-udevd[1020]: seq 3835 '/devices/pci0000:60/0000:60:03.1/0000:61:00.0' killed
kernel: megaraid_sas 0000:61:00.0: Init cmd return status FAILED for SCSI host 0
kernel: megaraid_sas 0000:61:00.0: Failed from megasas_init_fw 5896
systemd-udevd[1020]: worker [1045] terminated by signal 9 (KILL)

Thanks.
Lianbo

> with the PCI config space for the device to see if somehow the kernel is
> changing the BAR value somewhere based on the SME state.
> 
> Thanks,
> Tom
> 
>>
>> Therefore, I collected more detailed logs by journalctl command, probably which will
>> help to find out the root cause.
>>
>> Thanks.
>>
>> Jun 21 02:33:21 systemd[1]: Starting Show Plymouth Boot Screen...
>> Jun 21 02:33:21 kernel: megasas: 07.707.51.00-rc1
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: FW now in Ready state
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: 63 bit DMA mask and 63 bit consistent mask
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: firmware supports msix        : (128)
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: current msix/online cpus        : (96/96)
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: RDPQ mode        : (enabled)
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: Current firmware supports maximum commands: 4077         LDIO threshold: 0
>> Jun 21 02:33:21 systemd[1]: Received SIGRTMIN+20 from PID 1099 (plymouthd).
>> Jun 21 02:33:21 systemd[1]: Started Show Plymouth Boot Screen.
>> Jun 21 02:33:21 systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
>> Jun 21 02:33:21 systemd[1]: Reached target Paths.
>> Jun 21 02:33:21 kernel: igb: Intel(R) Gigabit Ethernet Network Driver - version 5.6.0-k
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: Configured max firmware commands: 4076
>> Jun 21 02:33:21 kernel: igb: Copyright (c) 2007-2014 Intel Corporation.
>> Jun 21 02:33:21 kernel: i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.8.20-k
>> Jun 21 02:33:21 kernel: i40e: Copyright (c) 2013 - 2014 Intel Corporation.
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.0: fw 6.81.49447 api 1.7 nvm 6.80 0x80003d71 18.8.9 [8086:1572] [1028:1f99]
>> Jun 21 02:33:21 kernel: megaraid_sas 0000:61:00.0: FW supports sync cache        : Yes
>> Jun 21 02:33:21 kernel: igb 0000:04:00.0: added PHC on eth0
>> Jun 21 02:33:21 kernel: igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
>> Jun 21 02:33:21 kernel: igb 0000:04:00.0: eth0: (PCIe:5.0Gb/s:Width x2) 24:6e:96:ad:1c:3a
>> Jun 21 02:33:21 kernel: igb 0000:04:00.0: eth0: PBA No: H39167-011
>> Jun 21 02:33:21 kernel: igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.0: MAC address: 24:6e:96:ad:1c:1a
>> Jun 21 02:33:21 systemd-udevd[1166]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
>> Jun 21 02:33:21 kernel: ahci 0000:06:00.2: version 3.0
>> Jun 21 02:33:21 kernel: ahci 0000:06:00.2: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
>> Jun 21 02:33:21 kernel: ahci 0000:06:00.2: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part
>> Jun 21 02:33:21 kernel: scsi host1: ahci
>> Jun 21 02:33:21 kernel: ata1: SATA max UDMA/133 abar m4096@0xf9a02000 port 0xf9a02100 irq 301
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.0: PCI-Express: Speed 8.0GT/s Width x8
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.0: Features: PF-id[0] VFs: 64 VSIs: 2 QP: 96 RSS FD_ATR FD_SB NTUPLE DCB VxLAN Geneve PTP VEPA
>> Jun 21 02:33:21 kernel: checking generic (eb000000 300000) vs hw (eb000000 1000000)
>> Jun 21 02:33:21 kernel: fb: switching to mgag200drmfb from EFI VGA
>> Jun 21 02:33:21 kernel: Console: switching to colour dummy device 80x25
>> Jun 21 02:33:21 kernel: mgag200 0000:03:00.0: vgaarb: deactivate vga console
>> Jun 21 02:33:21 kernel: [TTM] Zone  kernel: Available graphics memory: 32723572 kiB
>> Jun 21 02:33:21 kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
>> Jun 21 02:33:21 kernel: [TTM] Initializing pool allocator
>> Jun 21 02:33:21 systemd-vconsole-setup[2257]: KD_FONT_OP_GET failed while trying to get the font metadata: Function not implemented
>> Jun 21 02:33:21 systemd-vconsole-setup[2257]: Fonts will not be copied to remaining consoles
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.1: fw 6.81.49447 api 1.7 nvm 6.80 0x80003d71 18.8.9 [8086:1572] [1028:0000]
>> Jun 21 02:33:21 kernel: [TTM] Initializing DMA pool allocator
>> Jun 21 02:33:21 kernel: i40e 0000:01:00.1: MAC address: 24:6e:96:ad:1c:1c
>> Jun 21 02:33:21 kernel: igb 0000:04:00.1: added PHC on eth2
>> Jun 21 02:33:21 kernel: igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
>> Jun 21 02:33:21 kernel: igb 0000:04:00.1: eth2: (PCIe:5.0Gb/s:Width x2) 24:6e:96:ad:1c:3b
>> Jun 21 02:33:21 kernel: igb 0000:04:00.1: eth2: PBA No: H39167-011
>> Jun 21 02:33:21 kernel: igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>> Jun 21 02:33:21 kernel: fbcon: mgadrmfb (fb0) is primary device
>> Jun 21 02:33:21 kernel: Console: switching to colour frame buffer device 128x48
>> Jun 21 02:33:21 kernel: ata1: SATA link down (SStatus 0 SControl 300)
>> Jun 21 02:33:22 systemd-udevd[1177]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
>> Jun 21 02:33:22 kernel: igb 0000:04:00.1 eno4: renamed from eth2
>> Jun 21 02:33:22 kernel: i40e 0000:01:00.1: PCI-Express: Speed 8.0GT/s Width x8
>> Jun 21 02:33:22 systemd-udevd[2174]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
>> Jun 21 02:33:22 kernel: igb 0000:04:00.0 eno3: renamed from eth0
>> Jun 21 02:33:22 kernel: i40e 0000:01:00.1: Features: PF-id[1] VFs: 64 VSIs: 2 QP: 96 RSS FD_ATR FD_SB NTUPLE DCB VxLAN Geneve PTP VEPA
>> Jun 21 02:33:22 systemd-udevd[1166]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
>> Jun 21 02:33:22 systemd-udevd[1056]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
>> Jun 21 02:33:22 kernel: i40e 0000:01:00.0 eno1: renamed from eth1
>> Jun 21 02:33:22 kernel: mgag200 0000:03:00.0: fb0: mgadrmfb frame buffer device
>> Jun 21 02:33:22 kernel: [drm] Initialized mgag200 1.0.0 20110418 for 0000:03:00.0 on minor 0
>> Jun 21 02:33:22 kernel: i40e 0000:01:00.1 eno2: renamed from eth3
>> Jun 21 02:34:21 systemd-udevd[1020]: seq 3835 '/devices/pci0000:60/0000:60:03.1/0000:61:00.0' is taking a long time
>> Jun 21 02:34:50 systemd[1]: dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device: Job dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device/start timed out.
>> Jun 21 02:34:50 systemd[1]: Timed out waiting for device dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device.
>> Jun 21 02:34:50 systemd[1]: Dependency failed for Resume from hibernation using device /dev/mapper/rhel_dell--per7425--02-swap.
>> Jun 21 02:34:50 systemd[1]: systemd-hibernate-resume@dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.service: Job systemd-hibernate-resume@dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.service/start failed with result 'dependency'.
>> Jun 21 02:34:50 systemd[1]: dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device: Job dev-mapper-rhel_dell\x2d\x2dper7425\x2d\x2d02\x2dswap.device/start failed with result 'timeout'.
>> Jun 21 02:34:50 systemd[1]: Reached target Local File Systems (Pre).
>> Jun 21 02:34:50 systemd[1]: Reached target Local File Systems.
>> Jun 21 02:34:50 systemd[1]: Starting Create Volatile Files and Directories...
>> Jun 21 02:34:50 systemd[1]: Started Create Volatile Files and Directories.
>> Jun 21 02:34:50 systemd[1]: Reached target System Initialization.
>> Jun 21 02:34:50 systemd[1]: Reached target Basic System.
>> Jun 21 02:36:21 systemd-udevd[1020]: seq 3835 '/devices/pci0000:60/0000:60:03.1/0000:61:00.0' killed
>> Jun 21 02:36:39 kernel: megaraid_sas 0000:61:00.0: Init cmd return status FAILED for SCSI host 0
>> Jun 21 02:36:39 kernel: megaraid_sas 0000:61:00.0: Failed from megasas_init_fw 5896
>> Jun 21 02:36:39 systemd-udevd[1020]: worker [1045] terminated by signal 9 (KILL)
>> Jun 21 02:36:39 systemd-udevd[1020]: worker [1045] failed while handling '/devices/pci0000:60/0000:60:03.1/0000:61:00.0'
>> Jun 21 02:38:45 dracut-initqueue[1087]: Warning: dracut-initqueue timeout - starting timeout scripts
>>
>> dracut:/# ip link show
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 2: eno3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether 24:6e:96:ad:1c:3a brd ff:ff:ff:ff:ff:ff
>> 3: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether 24:6e:96:ad:1c:1a brd ff:ff:ff:ff:ff:ff
>> 4: eno4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether 24:6e:96:ad:1c:3b brd ff:ff:ff:ff:ff:ff
>> 5: eno2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether 24:6e:96:ad:1c:1c brd ff:ff:ff:ff:ff:ff
>>
>>
>>> Thanks,
>>> Tom
>>>
>>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>   
>>>>>          if (!instance->reg_set) {
>>>>>                  dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to map IO mem\n");
>>>>>
>>>>>
>>>>> Lianbo
>>>>>
>>>>>> Thanks,
>>>>>> Tom
>>>>>>
>>>>>>>
>>>>>>> Thanks.
>>>>>>> Lianbo
>>>>>>>
>>>>>>>
>>>>>>> Kernel log:
>>>>>>>
>>>>>>> [    0.000000] Linux version 5.2.0-rc4+ (root@dell-per7425-02.khw.lab.eng.bos.redhat.com) (gcc version 8.3.1 20190507 (Red Hat 8.3.1-4) (GCC)) #1 SMP Fri Jun 14 23:28:09 EDT 2019
>>>>>>> [    0.000000] Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.2.0-rc4+ root=/dev/mapper/rhel_dell--per7425--02-root ro crashkernel=auto resume=/dev/mapper/rhel_dell--per7425--02-swap rd.lvm.lv=rhel_dell-per7425-02/root rd.lvm.lv=rhel_dell-per7425-02/swap console=ttyS0,115200n81 mem_encrypt=on
>>>>>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
>>>>>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
>>>>>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
>>>>>>> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
>>>>>>> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
>>>>>>> [    0.000000] BIOS-provided physical RAM map:
>>>>>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
>>>>>>> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
>>>>>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006cacefff] usable
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000006cacf000-0x000000006efcefff] reserved
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000006efcf000-0x000000006fdfefff] ACPI NVS
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000006fdff000-0x000000006fffefff] ACPI data
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000006ffff000-0x000000006fffffff] usable
>>>>>>> [    0.000000] BIOS-e820: [mem 0x0000000070000000-0x000000008fffffff] reserved
>>>>>>> [    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
>>>>>>> [    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
>>>>>>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107effffff] usable
>>>>>>> [    0.000000] BIOS-e820: [mem 0x000000107f000000-0x000000107fffffff] reserved
>>>>>>> [    0.000000] NX (Execute Disable) protection: active
>>>>>>> [    0.000000] extended physical RAM map:
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000008efff] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ffff] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000049e2401f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000049e24020-0x0000000049e8345f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000049e83460-0x0000000049e8401f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000049e84020-0x0000000049ee345f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000049ee3460-0x0000000062c7801f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062c78020-0x0000000062c8f45f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062c8f460-0x0000000062c9001f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062c90020-0x0000000062c9805f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062c98060-0x0000000062c9901f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062c99020-0x0000000062cfb65f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062cfb660-0x0000000062cfc01f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062cfc020-0x0000000062d5e65f] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000062d5e660-0x000000006cacefff] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000006cacf000-0x000000006efcefff] reserved
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000006efcf000-0x000000006fdfefff] ACPI NVS
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000006fdff000-0x000000006fffefff] ACPI data
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000006ffff000-0x000000006fffffff] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000070000000-0x000000008fffffff] reserved
>>>>>>> [    0.000000] reserve setup_data: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
>>>>>>> [    0.000000] reserve setup_data: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
>>>>>>> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000107effffff] usable
>>>>>>> [    0.000000] reserve setup_data: [mem 0x000000107f000000-0x000000107fffffff] reserved
>>>>>>> [    0.000000] efi: EFI v2.50 by Dell Inc.
>>>>>>> [    0.000000] efi:  ACPI=0x6fffe000  ACPI 2.0=0x6fffe014  SMBIOS=0x6eab3000  SMBIOS 3.0=0x6eab1000
>>>>>>> [    0.000000] SMBIOS 3.0.0 present.
>>>>>>> [    0.000000] DMI: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.7.6 01/14/2019
>>>>>>> [    0.000000] tsc: Fast TSC calibration using PIT
>>>>>>> [    0.000000] tsc: Detected 1996.202 MHz processor
>>>>>>> [    0.000063] last_pfn = 0x107f000 max_arch_pfn = 0x400000000
>>>>>>> [    0.001334] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
>>>>>>> [    0.001755] last_pfn = 0x70000 max_arch_pfn = 0x400000000
>>>>>>> [    0.014865] Using GB pages for direct mapping
>>>>>>> [    0.015176] Secure boot disabled
>>>>>>> [    0.015178] RAMDISK: [mem 0x38c1c000-0x3dfd1fff]
>>>>>>> [    0.015191] ACPI: Early table checksum verification disabled
>>>>>>> [    0.015200] ACPI: RSDP 0x000000006FFFE014 000024 (v02 DELL  )
>>>>>>> [    0.015208] ACPI: XSDT 0x000000006FFFD0E8 0000C4 (v01 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015223] ACPI: FACP 0x000000006FFDD000 000114 (v06 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015235] ACPI: DSDT 0x000000006FFCC000 00D22C (v02 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015242] ACPI: FACS 0x000000006FDC8000 000040
>>>>>>> [    0.015249] ACPI: SSDT 0x000000006FFFC000 0000D2 (v02 DELL   PE_SC3   00000002 MSFT 04000000)
>>>>>>> [    0.015256] ACPI: BERT 0x000000006FFFB000 000030 (v01 DELL   BERT     00000001 DELL 00000001)
>>>>>>> [    0.015263] ACPI: HEST 0x000000006FFFA000 0006DC (v01 DELL   HEST     00000001 DELL 00000001)
>>>>>>> [    0.015269] ACPI: SSDT 0x000000006FFEC000 00D1C4 (v01 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015276] ACPI: SRAT 0x000000006FFEB000 0006D0 (v03 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015282] ACPI: MSCT 0x000000006FFEA000 0000A6 (v01 DELL   PE_SC3   00000000 AMD  00000001)
>>>>>>> [    0.015289] ACPI: SLIT 0x000000006FFE9000 00006C (v01 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015296] ACPI: CRAT 0x000000006FFE3000 005A10 (v01 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015302] ACPI: CDIT 0x000000006FFE2000 000068 (v01 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015309] ACPI: SSDT 0x000000006FFE1000 0003C6 (v02 DELL   Tpm2Tabl 00001000 INTL 20170119)
>>>>>>> [    0.015315] ACPI: TPM2 0x000000006FFE0000 000038 (v04 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015322] ACPI: EINJ 0x000000006FFDF000 000150 (v01 DELL   PE_SC3   00000001 AMD  00000001)
>>>>>>> [    0.015328] ACPI: SLIC 0x000000006FFDE000 000024 (v01 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015334] ACPI: HPET 0x000000006FFDC000 000038 (v01 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015341] ACPI: APIC 0x000000006FFDB000 0004B2 (v03 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015347] ACPI: MCFG 0x000000006FFDA000 00003C (v01 DELL   PE_SC3   00000002 DELL 00000001)
>>>>>>> [    0.015354] ACPI: SSDT 0x000000006FFCB000 0005CA (v02 DELL   xhc_port 00000001 INTL 20170119)
>>>>>>> [    0.015360] ACPI: IVRS 0x000000006FFCA000 000370 (v02 DELL   PE_SC3   00000001 AMD  00000000)
>>>>>>> [    0.015367] ACPI: SSDT 0x000000006FFC8000 001658 (v01 AMD    CPMCMN   00000001 INTL 20170119)
>>>>>>> [    0.015449] SRAT: PXM 0 -> APIC 0x00 -> Node 0
>>>>>>> [    0.015450] SRAT: PXM 0 -> APIC 0x01 -> Node 0
>>>>>>> [    0.015451] SRAT: PXM 0 -> APIC 0x02 -> Node 0
>>>>>>> [    0.015452] SRAT: PXM 0 -> APIC 0x03 -> Node 0
>>>>>>> [    0.015453] SRAT: PXM 0 -> APIC 0x04 -> Node 0
>>>>>>> [    0.015453] SRAT: PXM 0 -> APIC 0x05 -> Node 0
>>>>>>> [    0.015454] SRAT: PXM 0 -> APIC 0x08 -> Node 0
>>>>>>> [    0.015455] SRAT: PXM 0 -> APIC 0x09 -> Node 0
>>>>>>> [    0.015456] SRAT: PXM 0 -> APIC 0x0a -> Node 0
>>>>>>> [    0.015456] SRAT: PXM 0 -> APIC 0x0b -> Node 0
>>>>>>> [    0.015457] SRAT: PXM 0 -> APIC 0x0c -> Node 0
>>>>>>> [    0.015458] SRAT: PXM 0 -> APIC 0x0d -> Node 0
>>>>>>> [    0.015459] SRAT: PXM 1 -> APIC 0x10 -> Node 1
>>>>>>> [    0.015460] SRAT: PXM 1 -> APIC 0x11 -> Node 1
>>>>>>> [    0.015461] SRAT: PXM 1 -> APIC 0x12 -> Node 1
>>>>>>> [    0.015461] SRAT: PXM 1 -> APIC 0x13 -> Node 1
>>>>>>> [    0.015462] SRAT: PXM 1 -> APIC 0x14 -> Node 1
>>>>>>> [    0.015463] SRAT: PXM 1 -> APIC 0x15 -> Node 1
>>>>>>> [    0.015464] SRAT: PXM 1 -> APIC 0x18 -> Node 1
>>>>>>> [    0.015464] SRAT: PXM 1 -> APIC 0x19 -> Node 1
>>>>>>> [    0.015465] SRAT: PXM 1 -> APIC 0x1a -> Node 1
>>>>>>> [    0.015466] SRAT: PXM 1 -> APIC 0x1b -> Node 1
>>>>>>> [    0.015467] SRAT: PXM 1 -> APIC 0x1c -> Node 1
>>>>>>> [    0.015468] SRAT: PXM 1 -> APIC 0x1d -> Node 1
>>>>>>> [    0.015468] SRAT: PXM 2 -> APIC 0x20 -> Node 2
>>>>>>> [    0.015469] SRAT: PXM 2 -> APIC 0x21 -> Node 2
>>>>>>> [    0.015470] SRAT: PXM 2 -> APIC 0x22 -> Node 2
>>>>>>> [    0.015471] SRAT: PXM 2 -> APIC 0x23 -> Node 2
>>>>>>> [    0.015472] SRAT: PXM 2 -> APIC 0x24 -> Node 2
>>>>>>> [    0.015472] SRAT: PXM 2 -> APIC 0x25 -> Node 2
>>>>>>> [    0.015473] SRAT: PXM 2 -> APIC 0x28 -> Node 2
>>>>>>> [    0.015474] SRAT: PXM 2 -> APIC 0x29 -> Node 2
>>>>>>> [    0.015475] SRAT: PXM 2 -> APIC 0x2a -> Node 2
>>>>>>> [    0.015475] SRAT: PXM 2 -> APIC 0x2b -> Node 2
>>>>>>> [    0.015476] SRAT: PXM 2 -> APIC 0x2c -> Node 2
>>>>>>> [    0.015477] SRAT: PXM 2 -> APIC 0x2d -> Node 2
>>>>>>> [    0.015478] SRAT: PXM 3 -> APIC 0x30 -> Node 3
>>>>>>> [    0.015479] SRAT: PXM 3 -> APIC 0x31 -> Node 3
>>>>>>> [    0.015479] SRAT: PXM 3 -> APIC 0x32 -> Node 3
>>>>>>> [    0.015480] SRAT: PXM 3 -> APIC 0x33 -> Node 3
>>>>>>> [    0.015481] SRAT: PXM 3 -> APIC 0x34 -> Node 3
>>>>>>> [    0.015482] SRAT: PXM 3 -> APIC 0x35 -> Node 3
>>>>>>> [    0.015482] SRAT: PXM 3 -> APIC 0x38 -> Node 3
>>>>>>> [    0.015483] SRAT: PXM 3 -> APIC 0x39 -> Node 3
>>>>>>> [    0.015484] SRAT: PXM 3 -> APIC 0x3a -> Node 3
>>>>>>> [    0.015485] SRAT: PXM 3 -> APIC 0x3b -> Node 3
>>>>>>> [    0.015486] SRAT: PXM 3 -> APIC 0x3c -> Node 3
>>>>>>> [    0.015486] SRAT: PXM 3 -> APIC 0x3d -> Node 3
>>>>>>> [    0.015487] SRAT: PXM 4 -> APIC 0x40 -> Node 4
>>>>>>> [    0.015488] SRAT: PXM 4 -> APIC 0x41 -> Node 4
>>>>>>> [    0.015489] SRAT: PXM 4 -> APIC 0x42 -> Node 4
>>>>>>> [    0.015489] SRAT: PXM 4 -> APIC 0x43 -> Node 4
>>>>>>> [    0.015490] SRAT: PXM 4 -> APIC 0x44 -> Node 4
>>>>>>> [    0.015491] SRAT: PXM 4 -> APIC 0x45 -> Node 4
>>>>>>> [    0.015492] SRAT: PXM 4 -> APIC 0x48 -> Node 4
>>>>>>> [    0.015493] SRAT: PXM 4 -> APIC 0x49 -> Node 4
>>>>>>> [    0.015493] SRAT: PXM 4 -> APIC 0x4a -> Node 4
>>>>>>> [    0.015494] SRAT: PXM 4 -> APIC 0x4b -> Node 4
>>>>>>> [    0.015495] SRAT: PXM 4 -> APIC 0x4c -> Node 4
>>>>>>> [    0.015496] SRAT: PXM 4 -> APIC 0x4d -> Node 4
>>>>>>> [    0.015497] SRAT: PXM 5 -> APIC 0x50 -> Node 5
>>>>>>> [    0.015497] SRAT: PXM 5 -> APIC 0x51 -> Node 5
>>>>>>> [    0.015498] SRAT: PXM 5 -> APIC 0x52 -> Node 5
>>>>>>> [    0.015499] SRAT: PXM 5 -> APIC 0x53 -> Node 5
>>>>>>> [    0.015500] SRAT: PXM 5 -> APIC 0x54 -> Node 5
>>>>>>> [    0.015500] SRAT: PXM 5 -> APIC 0x55 -> Node 5
>>>>>>> [    0.015501] SRAT: PXM 5 -> APIC 0x58 -> Node 5
>>>>>>> [    0.015502] SRAT: PXM 5 -> APIC 0x59 -> Node 5
>>>>>>> [    0.015503] SRAT: PXM 5 -> APIC 0x5a -> Node 5
>>>>>>> [    0.015504] SRAT: PXM 5 -> APIC 0x5b -> Node 5
>>>>>>> [    0.015504] SRAT: PXM 5 -> APIC 0x5c -> Node 5
>>>>>>> [    0.015505] SRAT: PXM 5 -> APIC 0x5d -> Node 5
>>>>>>> [    0.015506] SRAT: PXM 6 -> APIC 0x60 -> Node 6
>>>>>>> [    0.015507] SRAT: PXM 6 -> APIC 0x61 -> Node 6
>>>>>>> [    0.015507] SRAT: PXM 6 -> APIC 0x62 -> Node 6
>>>>>>> [    0.015508] SRAT: PXM 6 -> APIC 0x63 -> Node 6
>>>>>>> [    0.015509] SRAT: PXM 6 -> APIC 0x64 -> Node 6
>>>>>>> [    0.015510] SRAT: PXM 6 -> APIC 0x65 -> Node 6
>>>>>>> [    0.015511] SRAT: PXM 6 -> APIC 0x68 -> Node 6
>>>>>>> [    0.015511] SRAT: PXM 6 -> APIC 0x69 -> Node 6
>>>>>>> [    0.015512] SRAT: PXM 6 -> APIC 0x6a -> Node 6
>>>>>>> [    0.015513] SRAT: PXM 6 -> APIC 0x6b -> Node 6
>>>>>>> [    0.015514] SRAT: PXM 6 -> APIC 0x6c -> Node 6
>>>>>>> [    0.015514] SRAT: PXM 6 -> APIC 0x6d -> Node 6
>>>>>>> [    0.015515] SRAT: PXM 7 -> APIC 0x70 -> Node 7
>>>>>>> [    0.015516] SRAT: PXM 7 -> APIC 0x71 -> Node 7
>>>>>>> [    0.015517] SRAT: PXM 7 -> APIC 0x72 -> Node 7
>>>>>>> [    0.015518] SRAT: PXM 7 -> APIC 0x73 -> Node 7
>>>>>>> [    0.015518] SRAT: PXM 7 -> APIC 0x74 -> Node 7
>>>>>>> [    0.015519] SRAT: PXM 7 -> APIC 0x75 -> Node 7
>>>>>>> [    0.015520] SRAT: PXM 7 -> APIC 0x78 -> Node 7
>>>>>>> [    0.015521] SRAT: PXM 7 -> APIC 0x79 -> Node 7
>>>>>>> [    0.015521] SRAT: PXM 7 -> APIC 0x7a -> Node 7
>>>>>>> [    0.015522] SRAT: PXM 7 -> APIC 0x7b -> Node 7
>>>>>>> [    0.015523] SRAT: PXM 7 -> APIC 0x7c -> Node 7
>>>>>>> [    0.015524] SRAT: PXM 7 -> APIC 0x7d -> Node 7
>>>>>>> [    0.015530] ACPI: SRAT: Node 1 PXM 1 [mem 0x00000000-0x0009ffff]
>>>>>>> [    0.015531] ACPI: SRAT: Node 1 PXM 1 [mem 0x00100000-0x7fffffff]
>>>>>>> [    0.015532] ACPI: SRAT: Node 1 PXM 1 [mem 0x100000000-0x87fffffff]
>>>>>>> [    0.015534] ACPI: SRAT: Node 5 PXM 5 [mem 0x880000000-0x107fffffff]
>>>>>>> [    0.015546] NUMA: Node 1 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0x7fffffff] -> [mem 0x00000000-0x7fffffff]
>>>>>>> [    0.015548] NUMA: Node 1 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
>>>>>>> [    0.015564] NODE_DATA(1) allocated [mem 0x87ffd6000-0x87fffffff]
>>>>>>> [    0.015587] NODE_DATA(5) allocated [mem 0x107efd5000-0x107effefff]
>>>>>>> [    0.015755] crashkernel: memory value expected
>>>>>>> [    0.015844] Zone ranges:
>>>>>>> [    0.015846]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>>>>>>> [    0.015847]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>>>>>>> [    0.015849]   Normal   [mem 0x0000000100000000-0x000000107effffff]
>>>>>>> [    0.015850]   Device   empty
>>>>>>> [    0.015851] Movable zone start for each node
>>>>>>> [    0.015855] Early memory node ranges
>>>>>>> [    0.015856]   node   1: [mem 0x0000000000001000-0x000000000008efff]
>>>>>>> [    0.015857]   node   1: [mem 0x0000000000090000-0x000000000009ffff]
>>>>>>> [    0.015858]   node   1: [mem 0x0000000000100000-0x000000006cacefff]
>>>>>>> [    0.015858]   node   1: [mem 0x000000006ffff000-0x000000006fffffff]
>>>>>>> [    0.015859]   node   1: [mem 0x0000000100000000-0x000000087fffffff]
>>>>>>> [    0.015860]   node   5: [mem 0x0000000880000000-0x000000107effffff]
>>>>>>> [    0.015987] Zeroed struct page in unavailable ranges: 13714 pages
>>>>>>> [    0.015989] Initmem setup node 1 [mem 0x0000000000001000-0x000000087fffffff]
>>>>>>> [    0.030543] Initmem setup node 5 [mem 0x0000000880000000-0x000000107effffff]
>>>>>>> [    0.031632] ACPI: PM-Timer IO Port: 0x408
>>>>>>> [    0.031670] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
>>>>>>> [    0.031702] IOAPIC[0]: apic_id 128, version 33, address 0xfec00000, GSI 0-23
>>>>>>> [    0.031708] IOAPIC[1]: apic_id 129, version 33, address 0xfd880000, GSI 24-55
>>>>>>> [    0.031713] IOAPIC[2]: apic_id 130, version 33, address 0xea900000, GSI 56-87
>>>>>>> [    0.031719] IOAPIC[3]: apic_id 131, version 33, address 0xdd900000, GSI 88-119
>>>>>>> [    0.031724] IOAPIC[4]: apic_id 132, version 33, address 0xd0900000, GSI 120-151
>>>>>>> [    0.031731] IOAPIC[5]: apic_id 133, version 33, address 0xc3900000, GSI 152-183
>>>>>>> [    0.031737] IOAPIC[6]: apic_id 134, version 33, address 0xb6900000, GSI 184-215
>>>>>>> [    0.031743] IOAPIC[7]: apic_id 135, version 33, address 0xa9900000, GSI 216-247
>>>>>>> [    0.031749] IOAPIC[8]: apic_id 136, version 33, address 0x9c900000, GSI 248-279
>>>>>>> [    0.031754] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>>>>>> [    0.031757] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
>>>>>>> [    0.031765] Using ACPI (MADT) for SMP configuration information
>>>>>>> [    0.031769] ACPI: HPET id: 0x10228201 base: 0xfed00000
>>>>>>> [    0.031780] smpboot: Allowing 128 CPUs, 32 hotplug CPUs
>>>>>>> [    0.031786] NODE_DATA(0) allocated [mem 0x107efa4000-0x107efcdfff]
>>>>>>> [    0.031787]     NODE_DATA(0) on node 5
>>>>>>> [    0.031817] Initmem setup node 0 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.031821] NODE_DATA(4) allocated [mem 0x107ef7a000-0x107efa3fff]
>>>>>>> [    0.031821]     NODE_DATA(4) on node 5
>>>>>>> [    0.031852] Initmem setup node 4 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.031855] NODE_DATA(2) allocated [mem 0x107ef50000-0x107ef79fff]
>>>>>>> [    0.031855]     NODE_DATA(2) on node 5
>>>>>>> [    0.031885] Initmem setup node 2 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.031888] NODE_DATA(6) allocated [mem 0x107ef26000-0x107ef4ffff]
>>>>>>> [    0.031889]     NODE_DATA(6) on node 5
>>>>>>> [    0.031920] Initmem setup node 6 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.031923] NODE_DATA(3) allocated [mem 0x107eefc000-0x107ef25fff]
>>>>>>> [    0.031924]     NODE_DATA(3) on node 5
>>>>>>> [    0.031955] Initmem setup node 3 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.031958] NODE_DATA(7) allocated [mem 0x107eed2000-0x107eefbfff]
>>>>>>> [    0.031959]     NODE_DATA(7) on node 5
>>>>>>> [    0.031989] Initmem setup node 7 [mem 0x0000000000000000-0x0000000000000000]
>>>>>>> [    0.032032] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
>>>>>>> [    0.032035] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
>>>>>>> [    0.032037] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
>>>>>>> [    0.032039] PM: Registered nosave memory: [mem 0x49e24000-0x49e24fff]
>>>>>>> [    0.032042] PM: Registered nosave memory: [mem 0x49e83000-0x49e83fff]
>>>>>>> [    0.032043] PM: Registered nosave memory: [mem 0x49e84000-0x49e84fff]
>>>>>>> [    0.032045] PM: Registered nosave memory: [mem 0x49ee3000-0x49ee3fff]
>>>>>>> [    0.032047] PM: Registered nosave memory: [mem 0x62c78000-0x62c78fff]
>>>>>>> [    0.032050] PM: Registered nosave memory: [mem 0x62c8f000-0x62c8ffff]
>>>>>>> [    0.032050] PM: Registered nosave memory: [mem 0x62c90000-0x62c90fff]
>>>>>>> [    0.032053] PM: Registered nosave memory: [mem 0x62c98000-0x62c98fff]
>>>>>>> [    0.032054] PM: Registered nosave memory: [mem 0x62c99000-0x62c99fff]
>>>>>>> [    0.032056] PM: Registered nosave memory: [mem 0x62cfb000-0x62cfbfff]
>>>>>>> [    0.032057] PM: Registered nosave memory: [mem 0x62cfc000-0x62cfcfff]
>>>>>>> [    0.032059] PM: Registered nosave memory: [mem 0x62d5e000-0x62d5efff]
>>>>>>> [    0.032062] PM: Registered nosave memory: [mem 0x6cacf000-0x6efcefff]
>>>>>>> [    0.032063] PM: Registered nosave memory: [mem 0x6efcf000-0x6fdfefff]
>>>>>>> [    0.032063] PM: Registered nosave memory: [mem 0x6fdff000-0x6fffefff]
>>>>>>> [    0.032066] PM: Registered nosave memory: [mem 0x70000000-0x8fffffff]
>>>>>>> [    0.032067] PM: Registered nosave memory: [mem 0x90000000-0xfec0ffff]
>>>>>>> [    0.032067] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
>>>>>>> [    0.032068] PM: Registered nosave memory: [mem 0xfec11000-0xfed7ffff]
>>>>>>> [    0.032069] PM: Registered nosave memory: [mem 0xfed80000-0xfed80fff]
>>>>>>> [    0.032070] PM: Registered nosave memory: [mem 0xfed81000-0xffffffff]
>>>>>>> [    0.032073] [mem 0x90000000-0xfec0ffff] available for PCI devices
>>>>>>> [    0.032076] Booting paravirtualized kernel on bare hardware
>>>>>>> [    0.032082] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
>>>>>>> [    0.134372] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:128 nr_cpu_ids:128 nr_node_ids:8
>>>>>>> [    0.148017] percpu: Embedded 54 pages/cpu s184320 r8192 d28672 u262144
>>>>>>> [    0.148212] Built 8 zonelists, mobility grouping on.  Total pages: 16431900
>>>>>>> [    0.148214] Policy zone: Normal
>>>>>>> [    0.148217] Kernel command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.2.0-rc4+ root=/dev/mapper/rhel_dell--per7425--02-root ro crashkernel=auto resume=/dev/mapper/rhel_dell--per7425--02-swap rd.lvm.lv=rhel_dell-per7425-02/root rd.lvm.lv=rhel_dell-per7425-02/swap console=ttyS0,115200n81 mem_encrypt=on
>>>>>>> [    0.181358] Memory: 1723672K/66775480K available (12292K kernel code, 2045K rwdata, 3824K rodata, 2344K init, 6360K bss, 1425828K reserved, 0K cma-reserved)
>>>>>>> [    0.182296] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=128, Nodes=8
>>>>>>> [    0.182345] ftrace: allocating 36145 entries in 142 pages
>>>>>>> [    0.202232] rcu: Hierarchical RCU implementation.
>>>>>>> [    0.202234] rcu:     RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=128.
>>>>>>> [    0.202236] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
>>>>>>> [    0.202238] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=128
>>>>>>> [    0.205498] NR_IRQS: 524544, nr_irqs: 5800, preallocated irqs: 16
>>>>>>> [    0.206511] random: get_random_bytes called from start_kernel+0x330/0x50a with crng_init=0
>>>>>>> [    0.206928] Console: colour dummy device 80x25
>>>>>>> [    1.925216] printk: console [ttyS0] enabled
>>>>>>> [    1.939471] AMD Secure Memory Encryption (SME) active
>>>>>>> [    1.944959] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
>>>>>>> [    1.956174] ACPI: Core revision 20190509
>>>>>>> [    1.960514] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
>>>>>>> [    1.969689] APIC: Switch to symmetric I/O mode setup
>>>>>>> [    2.746014] Switched APIC routing to physical flat.
>>>>>>> [    2.753874] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>>>>>> [    2.764705] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398c54e8bdf, max_idle_ns: 881590506184 ns
>>>>>>> [    2.775226] Calibrating delay loop (skipped), value calculated using timer frequency.. 3992.40 BogoMIPS (lpj=1996202)
>>>>>>> [    2.776226] pid_max: default: 131072 minimum: 1024
>>>>>>> [    2.784004] LSM: Security Framework initializing
>>>>>>> [    2.784261] Yama: becoming mindful.
>>>>>>> [    2.785252] SELinux:  Initializing.
>>>>>>> [    2.786301] *** VALIDATE SELinux ***
>>>>>>> [    2.799942] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
>>>>>>> [    2.806249] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
>>>>>>> [    2.807499] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>>>>>>> [    2.808408] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>>>>>>> [    2.809655] *** VALIDATE proc ***
>>>>>>> [    2.811151] *** VALIDATE cgroup1 ***
>>>>>>> [    2.811226] *** VALIDATE cgroup2 ***
>>>>>>> [    2.812394] LVT offset 2 assigned for vector 0xf4
>>>>>>> [    2.813236] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
>>>>>>> [    2.814224] Last level dTLB entries: 4KB 1536, 2MB 1536, 4MB 768, 1GB 0
>>>>>>> [    2.815227] Spectre V2 : Mitigation: Full AMD retpoline
>>>>>>> [    2.816224] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
>>>>>>> [    2.817229] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
>>>>>>> [    2.818224] Spectre V2 : User space: Vulnerable
>>>>>>> [    2.819225] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
>>>>>>> [    2.821415] Freeing SMP alternatives memory: 32K
>>>>>>> [    2.825223] smpboot: CPU0: AMD EPYC 7401 24-Core Processor (family: 0x17, model: 0x1, stepping: 0x2)
>>>>>>> [    2.825655] Performance Events: Fam17h core perfctr, AMD PMU driver.
>>>>>>> [    2.826227] ... version:                0
>>>>>>> [    2.827224] ... bit width:              48
>>>>>>> [    2.828224] ... generic registers:      6
>>>>>>> [    2.829224] ... value mask:             0000ffffffffffff
>>>>>>> [    2.830224] ... max period:             00007fffffffffff
>>>>>>> [    2.831223] ... fixed-purpose events:   0
>>>>>>> [    2.832224] ... event mask:             000000000000003f
>>>>>>> [    2.833507] rcu: Hierarchical SRCU implementation.
>>>>>>> [    2.834945] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
>>>>>>> [    2.838533] smp: Bringing up secondary CPUs ...
>>>>>>> [    2.840394] x86: Booting SMP configuration:
>>>>>>> [    2.841226] .... node  #4, CPUs:          #1
>>>>>>> [    2.853227] .... node  #1, CPUs:     #2
>>>>>>> [    2.856226] .... node  #5, CPUs:     #3
>>>>>>> [    2.858227] .... node  #2, CPUs:     #4
>>>>>>> [    2.861226] .... node  #6, CPUs:     #5
>>>>>>> [    2.864226] .... node  #3, CPUs:     #6
>>>>>>> [    2.866227] .... node  #7, CPUs:     #7
>>>>>>> [    2.869227] .... node  #0, CPUs:     #8
>>>>>>> [    2.871227] .... node  #4, CPUs:     #9
>>>>>>> [    2.874226] .... node  #1, CPUs:    #10
>>>>>>> [    2.876227] .... node  #5, CPUs:    #11
>>>>>>> [    2.879227] .... node  #2, CPUs:    #12
>>>>>>> [    2.881227] .... node  #6, CPUs:    #13
>>>>>>> [    2.884226] .... node  #3, CPUs:    #14
>>>>>>> [    2.886227] .... node  #7, CPUs:    #15
>>>>>>> [    2.889227] .... node  #0, CPUs:    #16
>>>>>>> [    2.892224] .... node  #4, CPUs:    #17
>>>>>>> [    2.894227] .... node  #1, CPUs:    #18
>>>>>>> [    2.897226] .... node  #5, CPUs:    #19
>>>>>>> [    2.900228] .... node  #2, CPUs:    #20
>>>>>>> [    2.903226] .... node  #6, CPUs:    #21
>>>>>>> [    2.906227] .... node  #3, CPUs:    #22
>>>>>>> [    2.908227] .... node  #7, CPUs:    #23
>>>>>>> [    2.911227] .... node  #0, CPUs:    #24
>>>>>>> [    2.913227] .... node  #4, CPUs:    #25
>>>>>>> [    2.916227] .... node  #1, CPUs:    #26
>>>>>>> [    2.919228] .... node  #5, CPUs:    #27
>>>>>>> [    2.921228] .... node  #2, CPUs:    #28
>>>>>>> [    2.924226] .... node  #6, CPUs:    #29
>>>>>>> [    2.926227] .... node  #3, CPUs:    #30
>>>>>>> [    2.929226] .... node  #7, CPUs:    #31
>>>>>>> [    2.931227] .... node  #0, CPUs:    #32
>>>>>>> [    2.934227] .... node  #4, CPUs:    #33
>>>>>>> [    2.936227] .... node  #1, CPUs:    #34
>>>>>>> [    2.939226] .... node  #5, CPUs:    #35
>>>>>>> [    2.941227] .... node  #2, CPUs:    #36
>>>>>>> [    2.944226] .... node  #6, CPUs:    #37
>>>>>>> [    2.946227] .... node  #3, CPUs:    #38
>>>>>>> [    2.949226] .... node  #7, CPUs:    #39
>>>>>>> [    2.952227] .... node  #0, CPUs:    #40
>>>>>>> [    2.955225] .... node  #4, CPUs:    #41
>>>>>>> [    2.958228] .... node  #1, CPUs:    #42
>>>>>>> [    2.960227] .... node  #5, CPUs:    #43
>>>>>>> [    2.963226] .... node  #2, CPUs:    #44
>>>>>>> [    2.965228] .... node  #6, CPUs:    #45
>>>>>>> [    2.968226] .... node  #3, CPUs:    #46
>>>>>>> [    2.970227] .... node  #7, CPUs:    #47
>>>>>>> [    2.973226] .... node  #0, CPUs:    #48
>>>>>>> [    2.978225] .... node  #4, CPUs:    #49
>>>>>>> [    2.980227] .... node  #1, CPUs:    #50
>>>>>>> [    2.983226] .... node  #5, CPUs:    #51
>>>>>>> [    2.986227] .... node  #2, CPUs:    #52
>>>>>>> [    2.988227] .... node  #6, CPUs:    #53
>>>>>>> [    2.991226] .... node  #3, CPUs:    #54
>>>>>>> [    2.993227] .... node  #7, CPUs:    #55
>>>>>>> [    2.996226] .... node  #0, CPUs:    #56
>>>>>>> [    2.998227] .... node  #4, CPUs:    #57
>>>>>>> [    3.000227] .... node  #1, CPUs:    #58
>>>>>>> [    3.003225] .... node  #5, CPUs:    #59
>>>>>>> [    3.005227] .... node  #2, CPUs:    #60
>>>>>>> [    3.008226] .... node  #6, CPUs:    #61
>>>>>>> [    3.010227] .... node  #3, CPUs:    #62
>>>>>>> [    3.013225] .... node  #7, CPUs:    #63
>>>>>>> [    3.016227] .... node  #0, CPUs:    #64
>>>>>>> [    3.019224] .... node  #4, CPUs:    #65
>>>>>>> [    3.021227] .... node  #1, CPUs:    #66
>>>>>>> [    3.023227] .... node  #5, CPUs:    #67
>>>>>>> [    3.026226] .... node  #2, CPUs:    #68
>>>>>>> [    3.028227] .... node  #6, CPUs:    #69
>>>>>>> [    3.031225] .... node  #3, CPUs:    #70
>>>>>>> [    3.033227] .... node  #7, CPUs:    #71
>>>>>>> [    3.036226] .... node  #0, CPUs:    #72
>>>>>>> [    3.039227] .... node  #4, CPUs:    #73
>>>>>>> [    3.041227] .... node  #1, CPUs:    #74
>>>>>>> [    3.044225] .... node  #5, CPUs:    #75
>>>>>>> [    3.046227] .... node  #2, CPUs:    #76
>>>>>>> [    3.049226] .... node  #6, CPUs:    #77
>>>>>>> [    3.051227] .... node  #3, CPUs:    #78
>>>>>>> [    3.054225] .... node  #7, CPUs:    #79
>>>>>>> [    3.056228] .... node  #0, CPUs:    #80
>>>>>>> [    3.059224] .... node  #4, CPUs:    #81
>>>>>>> [    3.061227] .... node  #1, CPUs:    #82
>>>>>>> [    3.064225] .... node  #5, CPUs:    #83
>>>>>>> [    3.066227] .... node  #2, CPUs:    #84
>>>>>>> [    3.069226] .... node  #6, CPUs:    #85
>>>>>>> [    3.071227] .... node  #3, CPUs:    #86
>>>>>>> [    3.074225] .... node  #7, CPUs:    #87
>>>>>>> [    3.076227] .... node  #0, CPUs:    #88
>>>>>>> [    3.079225] .... node  #4, CPUs:    #89
>>>>>>> [    3.081227] .... node  #1, CPUs:    #90
>>>>>>> [    3.084225] .... node  #5, CPUs:    #91
>>>>>>> [    3.086227] .... node  #2, CPUs:    #92
>>>>>>> [    3.089226] .... node  #6, CPUs:    #93
>>>>>>> [    3.091227] .... node  #3, CPUs:    #94
>>>>>>> [    3.094226] .... node  #7, CPUs:    #95
>>>>>>> [    3.095452] smp: Brought up 8 nodes, 96 CPUs
>>>>>>> [    3.097225] smpboot: Max logical packages: 3
>>>>>>> [    3.098231] smpboot: Total of 96 processors activated (382738.36 BogoMIPS)
>>>>>>> [    3.206239] node 1 initialised, 7699898 pages in 89ms
>>>>>>> [    3.212232] node 5 initialised, 8206597 pages in 95ms
>>>>>>> [    3.221458] devtmpfs: initialized
>>>>>>> [    3.225312] x86/mm: Memory block size: 128MB
>>>>>>> [    3.233283] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
>>>>>>> [    3.241228] PM: Registering ACPI NVS region [mem 0x6efcf000-0x6fdfefff] (14876672 bytes)
>>>>>>> [    3.250260] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
>>>>>>> [    3.259310] futex hash table entries: 32768 (order: 9, 2097152 bytes)
>>>>>>> [    3.267227] pinctrl core: initialized pinctrl subsystem
>>>>>>> [    3.274090] NET: Registered protocol family 16
>>>>>>> [    3.278361] audit: initializing netlink subsys (disabled)
>>>>>>> [    3.284238] audit: type=2000 audit(1560557598.523:1): state=initialized audit_enabled=0 res=1
>>>>>>> [    3.292229] cpuidle: using governor menu
>>>>>>> [    3.298566] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>>>>>>> [    3.306229] ACPI: bus type PCI registered
>>>>>>> [    3.310227] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>>>>>> [    3.316462] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
>>>>>>> [    3.326362] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
>>>>>>> [    3.333238] PCI: Using configuration type 1 for base access
>>>>>>> [    3.338233] PCI: Dell System detected, enabling pci=bfsort.
>>>>>>> [    3.349616] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
>>>>>>> [    3.356226] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
>>>>>>> [    3.393351] cryptd: max_cpu_qlen set to 1000
>>>>>>> [    3.409276] alg: No test for lzo-rle (lzo-rle-generic)
>>>>>>> [    3.414319] alg: No test for lzo-rle (lzo-rle-scomp)
>>>>>>> [    3.426335] ACPI: Added _OSI(Module Device)
>>>>>>> [    3.431226] ACPI: Added _OSI(Processor Device)
>>>>>>> [    3.435225] ACPI: Added _OSI(3.0 _SCP Extensions)
>>>>>>> [    3.440225] ACPI: Added _OSI(Processor Aggregator Device)
>>>>>>> [    3.445230] ACPI: Added _OSI(Linux-Dell-Video)
>>>>>>> [    3.450226] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
>>>>>>> [    3.455224] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
>>>>>>> [    3.469831] ACPI: 6 ACPI AML tables successfully acquired and loaded
>>>>>>> [    3.480352] ACPI: Interpreter enabled
>>>>>>> [    3.484239] ACPI: (supports S0 S5)
>>>>>>> [    3.488226] ACPI: Using IOAPIC for interrupt routing
>>>>>>> [    3.493526] HEST: Table parsing has been initialized.
>>>>>>> [    3.498228] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>>>>>>> [    3.507588] ACPI: Enabled 2 GPEs in block 00 to 1F
>>>>>>> [    3.522832] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.530266] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.536261] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.543263] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.550259] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.556271] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.563259] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.570260] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
>>>>>>> [    3.576414] ACPI: PCI Root Bridge [PC00] (domain 0000 [bus 00-1f])
>>>>>>> [    3.583232] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    3.592268] acpi PNP0A08:00: PCIe AER handled by firmware
>>>>>>> [    3.597266] acpi PNP0A08:00: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    3.604293] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    3.612225] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    3.620391] PCI host bridge to bus 0000:00
>>>>>>> [    3.625226] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
>>>>>>> [    3.631226] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
>>>>>>> [    3.638225] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
>>>>>>> [    3.645227] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
>>>>>>> [    3.652226] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
>>>>>>> [    3.660224] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
>>>>>>> [    3.667226] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
>>>>>>> [    3.675230] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
>>>>>>> [    3.682225] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
>>>>>>> [    3.690226] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
>>>>>>> [    3.697225] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
>>>>>>> [    3.705226] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
>>>>>>> [    3.712224] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
>>>>>>> [    3.720225] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
>>>>>>> [    3.727226] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
>>>>>>> [    3.735225] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
>>>>>>> [    3.742224] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
>>>>>>> [    3.750226] pci_bus 0000:00: root bus resource [io  0x0d00-0x1fff window]
>>>>>>> [    3.756224] pci_bus 0000:00: root bus resource [mem 0xeb000000-0xfebfffff window]
>>>>>>> [    3.764226] pci_bus 0000:00: root bus resource [mem 0x10000000000-0x1df9fffffff window]
>>>>>>> [    3.772227] pci_bus 0000:00: root bus resource [bus 00-1f]
>>>>>>> [    3.777232] pci 0000:00:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    3.783371] pci 0000:00:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    3.790362] pci 0000:00:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.796332] pci 0000:00:01.1: [1022:1453] type 01 class 0x060400
>>>>>>> [    3.802360] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    3.808362] pci 0000:00:01.3: [1022:1453] type 01 class 0x060400
>>>>>>> [    3.815322] pci 0000:00:01.3: PME# supported from D0 D3hot D3cold
>>>>>>> [    3.821356] pci 0000:00:01.4: [1022:1453] type 01 class 0x060400
>>>>>>> [    3.828323] pci 0000:00:01.4: PME# supported from D0 D3hot D3cold
>>>>>>> [    3.834369] pci 0000:00:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.840349] pci 0000:00:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.846310] pci 0000:00:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.852353] pci 0000:00:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.859330] pci 0000:00:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    3.865444] pci 0000:00:07.1: enabling Extended Tags
>>>>>>> [    3.870334] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    3.876367] pci 0000:00:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    3.882337] pci 0000:00:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    3.888818] pci 0000:00:08.1: enabling Extended Tags
>>>>>>> [    3.894340] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    3.900407] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
>>>>>>> [    3.906457] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
>>>>>>> [    3.913497] pci 0000:00:18.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    3.919320] pci 0000:00:18.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    3.925316] pci 0000:00:18.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    3.931318] pci 0000:00:18.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    3.937320] pci 0000:00:18.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    3.943294] pci 0000:00:18.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    3.949316] pci 0000:00:18.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    3.956316] pci 0000:00:18.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    3.962317] pci 0000:00:19.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    3.968323] pci 0000:00:19.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    3.974320] pci 0000:00:19.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    3.980315] pci 0000:00:19.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    3.986312] pci 0000:00:19.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    3.992318] pci 0000:00:19.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    3.998310] pci 0000:00:19.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.004301] pci 0000:00:19.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.010312] pci 0000:00:1a.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.017313] pci 0000:00:1a.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.023308] pci 0000:00:1a.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.029306] pci 0000:00:1a.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.035315] pci 0000:00:1a.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.041308] pci 0000:00:1a.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.047308] pci 0000:00:1a.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.053310] pci 0000:00:1a.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.059313] pci 0000:00:1b.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.065308] pci 0000:00:1b.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.071286] pci 0000:00:1b.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.077309] pci 0000:00:1b.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.084315] pci 0000:00:1b.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.090309] pci 0000:00:1b.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.096309] pci 0000:00:1b.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.102307] pci 0000:00:1b.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.108316] pci 0000:00:1c.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.114318] pci 0000:00:1c.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.120315] pci 0000:00:1c.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.126320] pci 0000:00:1c.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.132314] pci 0000:00:1c.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.138316] pci 0000:00:1c.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.145317] pci 0000:00:1c.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.151319] pci 0000:00:1c.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.157319] pci 0000:00:1d.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.163319] pci 0000:00:1d.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.169315] pci 0000:00:1d.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.175319] pci 0000:00:1d.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.181318] pci 0000:00:1d.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.187320] pci 0000:00:1d.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.193314] pci 0000:00:1d.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.199311] pci 0000:00:1d.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.206320] pci 0000:00:1e.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.212314] pci 0000:00:1e.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.218314] pci 0000:00:1e.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.224311] pci 0000:00:1e.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.230317] pci 0000:00:1e.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.236314] pci 0000:00:1e.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.242315] pci 0000:00:1e.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.248326] pci 0000:00:1e.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.254316] pci 0000:00:1f.0: [1022:1460] type 00 class 0x060000
>>>>>>> [    4.260304] pci 0000:00:1f.1: [1022:1461] type 00 class 0x060000
>>>>>>> [    4.266315] pci 0000:00:1f.2: [1022:1462] type 00 class 0x060000
>>>>>>> [    4.273316] pci 0000:00:1f.3: [1022:1463] type 00 class 0x060000
>>>>>>> [    4.279321] pci 0000:00:1f.4: [1022:1464] type 00 class 0x060000
>>>>>>> [    4.285315] pci 0000:00:1f.5: [1022:1465] type 00 class 0x060000
>>>>>>> [    4.291316] pci 0000:00:1f.6: [1022:1466] type 00 class 0x060000
>>>>>>> [    4.297318] pci 0000:00:1f.7: [1022:1467] type 00 class 0x060000
>>>>>>> [    4.304336] pci 0000:01:00.0: [8086:1572] type 00 class 0x020000
>>>>>>> [    4.310248] pci 0000:01:00.0: reg 0x10: [mem 0xed000000-0xedffffff 64bit pref]
>>>>>>> [    4.317240] pci 0000:01:00.0: reg 0x1c: [mem 0xee008000-0xee00ffff 64bit pref]
>>>>>>> [    4.324238] pci 0000:01:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
>>>>>>> [    4.331282] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.337381] pci 0000:01:00.1: [8086:1572] type 00 class 0x020000
>>>>>>> [    4.343238] pci 0000:01:00.1: reg 0x10: [mem 0xec000000-0xecffffff 64bit pref]
>>>>>>> [    4.351241] pci 0000:01:00.1: reg 0x1c: [mem 0xee000000-0xee007fff 64bit pref]
>>>>>>> [    4.358238] pci 0000:01:00.1: reg 0x30: [mem 0xfff80000-0xffffffff pref]
>>>>>>> [    4.365279] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.371389] pci 0000:00:01.1: PCI bridge to [bus 01]
>>>>>>> [    4.376231] pci 0000:00:01.1:   bridge window [mem 0xec000000-0xee0fffff 64bit pref]
>>>>>>> [    4.384566] pci 0000:02:00.0: [1556:be00] type 01 class 0x060400
>>>>>>> [    4.393240] pci 0000:00:01.3: PCI bridge to [bus 02-03]
>>>>>>> [    4.399230] pci 0000:00:01.3:   bridge window [mem 0xf9000000-0xf98fffff]
>>>>>>> [    4.405227] pci 0000:00:01.3:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    4.413251] pci_bus 0000:03: extended config space not accessible
>>>>>>> [    4.419247] pci 0000:03:00.0: [102b:0536] type 00 class 0x030000
>>>>>>> [    4.425241] pci 0000:03:00.0: reg 0x10: [mem 0xeb000000-0xebffffff pref]
>>>>>>> [    4.432233] pci 0000:03:00.0: reg 0x14: [mem 0xf9808000-0xf980bfff]
>>>>>>> [    4.438234] pci 0000:03:00.0: reg 0x18: [mem 0xf9000000-0xf97fffff]
>>>>>>> [    4.445267] pci 0000:03:00.0: BAR 0: assigned to efifb
>>>>>>> [    4.450359] pci 0000:02:00.0: PCI bridge to [bus 03]
>>>>>>> [    4.455232] pci 0000:02:00.0:   bridge window [mem 0xf9000000-0xf98fffff]
>>>>>>> [    4.462229] pci 0000:02:00.0:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    4.469915] pci 0000:04:00.0: [8086:1521] type 00 class 0x020000
>>>>>>> [    4.476248] pci 0000:04:00.0: reg 0x10: [mem 0xf9f00000-0xf9ffffff]
>>>>>>> [    4.482247] pci 0000:04:00.0: reg 0x1c: [mem 0xfa004000-0xfa007fff]
>>>>>>> [    4.489247] pci 0000:04:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
>>>>>>> [    4.495300] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.502269] pci 0000:04:00.0: 8.000 Gb/s available PCIe bandwidth, limited by 5 GT/s x2 link at 0000:00:01.4 (capable of 16.000 Gb/s with 5 GT/s x4 link)
>>>>>>> [    4.515319] pci 0000:04:00.1: [8086:1521] type 00 class 0x020000
>>>>>>> [    4.522263] pci 0000:04:00.1: reg 0x10: [mem 0xf9e00000-0xf9efffff]
>>>>>>> [    4.528248] pci 0000:04:00.1: reg 0x1c: [mem 0xfa000000-0xfa003fff]
>>>>>>> [    4.534248] pci 0000:04:00.1: reg 0x30: [mem 0xfff80000-0xffffffff pref]
>>>>>>> [    4.541349] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.547569] pci 0000:00:01.4: PCI bridge to [bus 04]
>>>>>>> [    4.552232] pci 0000:00:01.4:   bridge window [mem 0xf9e00000-0xfa0fffff]
>>>>>>> [    4.559346] pci 0000:05:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    4.565267] pci 0000:05:00.0: enabling Extended Tags
>>>>>>> [    4.570362] pci 0000:05:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    4.576246] pci 0000:05:00.2: reg 0x18: [mem 0xf9c00000-0xf9cfffff]
>>>>>>> [    4.583237] pci 0000:05:00.2: reg 0x24: [mem 0xf9d00000-0xf9d01fff]
>>>>>>> [    4.589233] pci 0000:05:00.2: enabling Extended Tags
>>>>>>> [    4.594370] pci 0000:05:00.3: [1022:145f] type 00 class 0x0c0330
>>>>>>> [    4.600241] pci 0000:05:00.3: reg 0x10: [mem 0xf9b00000-0xf9bfffff 64bit]
>>>>>>> [    4.607248] pci 0000:05:00.3: enabling Extended Tags
>>>>>>> [    4.612262] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.618351] pci 0000:00:07.1: PCI bridge to [bus 05]
>>>>>>> [    4.623228] pci 0000:00:07.1:   bridge window [mem 0xf9b00000-0xf9dfffff]
>>>>>>> [    4.630696] pci 0000:06:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    4.636268] pci 0000:06:00.0: enabling Extended Tags
>>>>>>> [    4.641358] pci 0000:06:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    4.648247] pci 0000:06:00.1: reg 0x18: [mem 0xf9900000-0xf99fffff]
>>>>>>> [    4.654237] pci 0000:06:00.1: reg 0x24: [mem 0xf9a00000-0xf9a01fff]
>>>>>>> [    4.660233] pci 0000:06:00.1: enabling Extended Tags
>>>>>>> [    4.665353] pci 0000:06:00.2: [1022:7901] type 00 class 0x010601
>>>>>>> [    4.671262] pci 0000:06:00.2: reg 0x24: [mem 0xf9a02000-0xf9a02fff]
>>>>>>> [    4.678232] pci 0000:06:00.2: enabling Extended Tags
>>>>>>> [    4.683263] pci 0000:06:00.2: PME# supported from D3hot D3cold
>>>>>>> [    4.688345] pci 0000:00:08.1: PCI bridge to [bus 06]
>>>>>>> [    4.694230] pci 0000:00:08.1:   bridge window [mem 0xf9900000-0xf9afffff]
>>>>>>> [    4.701497] ACPI: PCI Root Bridge [PC01] (domain 0000 [bus 20-3f])
>>>>>>> [    4.707229] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    4.716268] acpi PNP0A08:01: PCIe AER handled by firmware
>>>>>>> [    4.722265] acpi PNP0A08:01: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    4.729297] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    4.737225] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    4.745444] PCI host bridge to bus 0000:20
>>>>>>> [    4.749226] pci_bus 0000:20: root bus resource [io  0x2000-0x3fff window]
>>>>>>> [    4.756226] pci_bus 0000:20: root bus resource [mem 0xde000000-0xeaffffff window]
>>>>>>> [    4.763226] pci_bus 0000:20: root bus resource [mem 0x1dfa0000000-0x2bf3fffffff window]
>>>>>>> [    4.771225] pci_bus 0000:20: root bus resource [bus 20-3f]
>>>>>>> [    4.777229] pci 0000:20:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    4.783334] pci 0000:20:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    4.789350] pci 0000:20:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.795334] pci 0000:20:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.801338] pci 0000:20:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.807331] pci 0000:20:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.813341] pci 0000:20:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.820316] pci 0000:20:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    4.826269] pci 0000:20:07.1: enabling Extended Tags
>>>>>>> [    4.831317] pci 0000:20:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.837360] pci 0000:20:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    4.843319] pci 0000:20:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    4.849270] pci 0000:20:08.1: enabling Extended Tags
>>>>>>> [    4.854320] pci 0000:20:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.861474] pci 0000:21:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    4.867265] pci 0000:21:00.0: enabling Extended Tags
>>>>>>> [    4.872342] pci 0000:21:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    4.878246] pci 0000:21:00.2: reg 0x18: [mem 0xe8300000-0xe83fffff]
>>>>>>> [    4.884238] pci 0000:21:00.2: reg 0x24: [mem 0xe8400000-0xe8401fff]
>>>>>>> [    4.891232] pci 0000:21:00.2: enabling Extended Tags
>>>>>>> [    4.896355] pci 0000:21:00.3: [1022:145f] type 00 class 0x0c0330
>>>>>>> [    4.902240] pci 0000:21:00.3: reg 0x10: [mem 0xe8200000-0xe82fffff 64bit]
>>>>>>> [    4.909237] pci 0000:21:00.3: enabling Extended Tags
>>>>>>> [    4.914245] pci 0000:21:00.3: PME# supported from D0 D3hot D3cold
>>>>>>> [    4.920337] pci 0000:20:07.1: PCI bridge to [bus 21]
>>>>>>> [    4.925229] pci 0000:20:07.1:   bridge window [mem 0xe8200000-0xe84fffff]
>>>>>>> [    4.932462] pci 0000:22:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    4.938268] pci 0000:22:00.0: enabling Extended Tags
>>>>>>> [    4.943354] pci 0000:22:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    4.949248] pci 0000:22:00.1: reg 0x18: [mem 0xe8000000-0xe80fffff]
>>>>>>> [    4.955239] pci 0000:22:00.1: reg 0x24: [mem 0xe8100000-0xe8101fff]
>>>>>>> [    4.962232] pci 0000:22:00.1: enabling Extended Tags
>>>>>>> [    4.967371] pci 0000:20:08.1: PCI bridge to [bus 22]
>>>>>>> [    4.972229] pci 0000:20:08.1:   bridge window [mem 0xe8000000-0xe81fffff]
>>>>>>> [    4.979378] ACPI: PCI Root Bridge [PC02] (domain 0000 [bus 40-5f])
>>>>>>> [    4.985227] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    4.994264] acpi PNP0A08:02: PCIe AER handled by firmware
>>>>>>> [    5.000264] acpi PNP0A08:02: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    5.007295] acpi PNP0A08:02: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    5.014226] acpi PNP0A08:02: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    5.023406] PCI host bridge to bus 0000:40
>>>>>>> [    5.027226] pci_bus 0000:40: root bus resource [io  0x4000-0x5fff window]
>>>>>>> [    5.034225] pci_bus 0000:40: root bus resource [mem 0xd1000000-0xddffffff window]
>>>>>>> [    5.041226] pci_bus 0000:40: root bus resource [mem 0x2bf40000000-0x39edfffffff window]
>>>>>>> [    5.049224] pci_bus 0000:40: root bus resource [bus 40-5f]
>>>>>>> [    5.055229] pci 0000:40:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    5.061331] pci 0000:40:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    5.067349] pci 0000:40:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.073334] pci 0000:40:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.079331] pci 0000:40:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.085334] pci 0000:40:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.091336] pci 0000:40:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.097318] pci 0000:40:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.104269] pci 0000:40:07.1: enabling Extended Tags
>>>>>>> [    5.109320] pci 0000:40:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.115360] pci 0000:40:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.121317] pci 0000:40:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.127608] pci 0000:40:08.1: enabling Extended Tags
>>>>>>> [    5.132332] pci 0000:40:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.139378] pci 0000:41:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    5.145264] pci 0000:41:00.0: enabling Extended Tags
>>>>>>> [    5.150349] pci 0000:41:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    5.156246] pci 0000:41:00.2: reg 0x18: [mem 0xdb200000-0xdb2fffff]
>>>>>>> [    5.162238] pci 0000:41:00.2: reg 0x24: [mem 0xdb300000-0xdb301fff]
>>>>>>> [    5.169232] pci 0000:41:00.2: enabling Extended Tags
>>>>>>> [    5.173370] pci 0000:40:07.1: PCI bridge to [bus 41]
>>>>>>> [    5.179229] pci 0000:40:07.1:   bridge window [mem 0xdb200000-0xdb3fffff]
>>>>>>> [    5.185384] pci 0000:42:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    5.192269] pci 0000:42:00.0: enabling Extended Tags
>>>>>>> [    5.197350] pci 0000:42:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    5.203248] pci 0000:42:00.1: reg 0x18: [mem 0xdb000000-0xdb0fffff]
>>>>>>> [    5.209239] pci 0000:42:00.1: reg 0x24: [mem 0xdb100000-0xdb101fff]
>>>>>>> [    5.215233] pci 0000:42:00.1: enabling Extended Tags
>>>>>>> [    5.220377] pci 0000:40:08.1: PCI bridge to [bus 42]
>>>>>>> [    5.225228] pci 0000:40:08.1:   bridge window [mem 0xdb000000-0xdb1fffff]
>>>>>>> [    5.232421] ACPI: PCI Root Bridge [PC03] (domain 0000 [bus 60-7f])
>>>>>>> [    5.239227] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    5.248263] acpi PNP0A08:03: PCIe AER handled by firmware
>>>>>>> [    5.253264] acpi PNP0A08:03: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    5.260295] acpi PNP0A08:03: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    5.268226] acpi PNP0A08:03: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    5.276436] PCI host bridge to bus 0000:60
>>>>>>> [    5.280226] pci_bus 0000:60: root bus resource [io  0x6000-0x7fff window]
>>>>>>> [    5.287225] pci_bus 0000:60: root bus resource [mem 0xc4000000-0xd0ffffff window]
>>>>>>> [    5.295225] pci_bus 0000:60: root bus resource [mem 0x39ee0000000-0x47e7fffffff window]
>>>>>>> [    5.303227] pci_bus 0000:60: root bus resource [bus 60-7f]
>>>>>>> [    5.308229] pci 0000:60:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    5.314321] pci 0000:60:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    5.320346] pci 0000:60:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.326329] pci 0000:60:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.333327] pci 0000:60:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.339317] pci 0000:60:03.1: [1022:1453] type 01 class 0x060400
>>>>>>> [    5.345349] pci 0000:60:03.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.351449] pci 0000:60:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.357340] pci 0000:60:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.363319] pci 0000:60:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.369362] pci 0000:60:07.1: enabling Extended Tags
>>>>>>> [    5.375336] pci 0000:60:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.381359] pci 0000:60:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.387322] pci 0000:60:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.393264] pci 0000:60:08.1: enabling Extended Tags
>>>>>>> [    5.398315] pci 0000:60:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.405441] pci 0000:61:00.0: [1000:0016] type 00 class 0x010400
>>>>>>> [    5.411253] pci 0000:61:00.0: reg 0x10: [mem 0xc4000000-0xc40fffff 64bit pref]
>>>>>>> [    5.418235] pci 0000:61:00.0: reg 0x18: [mem 0xc4100000-0xc41fffff 64bit pref]
>>>>>>> [    5.425233] pci 0000:61:00.0: reg 0x20: [mem 0xce400000-0xce4fffff]
>>>>>>> [    5.432231] pci 0000:61:00.0: reg 0x24: [io  0x6000-0x60ff]
>>>>>>> [    5.437232] pci 0000:61:00.0: reg 0x30: [mem 0xfff00000-0xffffffff pref]
>>>>>>> [    5.444282] pci 0000:61:00.0: supports D1 D2
>>>>>>> [    5.448336] pci 0000:60:03.1: PCI bridge to [bus 61]
>>>>>>> [    5.453227] pci 0000:60:03.1:   bridge window [io  0x6000-0x6fff]
>>>>>>> [    5.459226] pci 0000:60:03.1:   bridge window [mem 0xce400000-0xce4fffff]
>>>>>>> [    5.466228] pci 0000:60:03.1:   bridge window [mem 0xc4000000-0xc41fffff 64bit pref]
>>>>>>> [    5.474305] pci 0000:62:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    5.480260] pci 0000:62:00.0: enabling Extended Tags
>>>>>>> [    5.485353] pci 0000:62:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    5.491244] pci 0000:62:00.2: reg 0x18: [mem 0xce200000-0xce2fffff]
>>>>>>> [    5.498237] pci 0000:62:00.2: reg 0x24: [mem 0xce300000-0xce301fff]
>>>>>>> [    5.504231] pci 0000:62:00.2: enabling Extended Tags
>>>>>>> [    5.509363] pci 0000:60:07.1: PCI bridge to [bus 62]
>>>>>>> [    5.514229] pci 0000:60:07.1:   bridge window [mem 0xce200000-0xce3fffff]
>>>>>>> [    5.521471] pci 0000:63:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    5.527262] pci 0000:63:00.0: enabling Extended Tags
>>>>>>> [    5.532351] pci 0000:63:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    5.538244] pci 0000:63:00.1: reg 0x18: [mem 0xce000000-0xce0fffff]
>>>>>>> [    5.544238] pci 0000:63:00.1: reg 0x24: [mem 0xce100000-0xce101fff]
>>>>>>> [    5.551229] pci 0000:63:00.1: enabling Extended Tags
>>>>>>> [    5.556341] pci 0000:60:08.1: PCI bridge to [bus 63]
>>>>>>> [    5.561228] pci 0000:60:08.1:   bridge window [mem 0xce000000-0xce1fffff]
>>>>>>> [    5.568355] ACPI: PCI Root Bridge [PC04] (domain 0000 [bus 80-9f])
>>>>>>> [    5.574228] acpi PNP0A08:04: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    5.583266] acpi PNP0A08:04: PCIe AER handled by firmware
>>>>>>> [    5.588265] acpi PNP0A08:04: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    5.596294] acpi PNP0A08:04: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    5.603226] acpi PNP0A08:04: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    5.612329] PCI host bridge to bus 0000:80
>>>>>>> [    5.616227] pci_bus 0000:80: root bus resource [io  0x8000-0x9fff window]
>>>>>>> [    5.623225] pci_bus 0000:80: root bus resource [mem 0xb7000000-0xc3ffffff window]
>>>>>>> [    5.630226] pci_bus 0000:80: root bus resource [mem 0x47e80000000-0x55e1fffffff window]
>>>>>>> [    5.638225] pci_bus 0000:80: root bus resource [bus 80-9f]
>>>>>>> [    5.644230] pci 0000:80:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    5.650302] pci 0000:80:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    5.656365] pci 0000:80:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.662339] pci 0000:80:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.668342] pci 0000:80:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.674337] pci 0000:80:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.680348] pci 0000:80:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.686327] pci 0000:80:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.693397] pci 0000:80:07.1: enabling Extended Tags
>>>>>>> [    5.698303] pci 0000:80:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.704369] pci 0000:80:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.710329] pci 0000:80:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.717227] pci 0000:80:08.1: enabling Extended Tags
>>>>>>> [    5.722336] pci 0000:80:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.729288] pci 0000:81:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    5.735274] pci 0000:81:00.0: enabling Extended Tags
>>>>>>> [    5.740359] pci 0000:81:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    5.746250] pci 0000:81:00.2: reg 0x18: [mem 0xc1200000-0xc12fffff]
>>>>>>> [    5.752241] pci 0000:81:00.2: reg 0x24: [mem 0xc1300000-0xc1301fff]
>>>>>>> [    5.759234] pci 0000:81:00.2: enabling Extended Tags
>>>>>>> [    5.764363] pci 0000:80:07.1: PCI bridge to [bus 81]
>>>>>>> [    5.769229] pci 0000:80:07.1:   bridge window [mem 0xc1200000-0xc13fffff]
>>>>>>> [    5.776304] pci 0000:82:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    5.782278] pci 0000:82:00.0: enabling Extended Tags
>>>>>>> [    5.787363] pci 0000:82:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    5.793252] pci 0000:82:00.1: reg 0x18: [mem 0xc1000000-0xc10fffff]
>>>>>>> [    5.799241] pci 0000:82:00.1: reg 0x24: [mem 0xc1100000-0xc1101fff]
>>>>>>> [    5.806234] pci 0000:82:00.1: enabling Extended Tags
>>>>>>> [    5.811358] pci 0000:80:08.1: PCI bridge to [bus 82]
>>>>>>> [    5.816229] pci 0000:80:08.1:   bridge window [mem 0xc1000000-0xc11fffff]
>>>>>>> [    5.823327] ACPI: PCI Root Bridge [PC05] (domain 0000 [bus a0-bf])
>>>>>>> [    5.829227] acpi PNP0A08:05: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    5.838264] acpi PNP0A08:05: PCIe AER handled by firmware
>>>>>>> [    5.843263] acpi PNP0A08:05: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    5.851297] acpi PNP0A08:05: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    5.858225] acpi PNP0A08:05: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    5.867370] PCI host bridge to bus 0000:a0
>>>>>>> [    5.871225] pci_bus 0000:a0: root bus resource [io  0xa000-0xbfff window]
>>>>>>> [    5.878225] pci_bus 0000:a0: root bus resource [mem 0xaa000000-0xb6ffffff window]
>>>>>>> [    5.885226] pci_bus 0000:a0: root bus resource [mem 0x55e20000000-0x63dbfffffff window]
>>>>>>> [    5.893226] pci_bus 0000:a0: root bus resource [bus a0-bf]
>>>>>>> [    5.899229] pci 0000:a0:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    5.905340] pci 0000:a0:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    5.911351] pci 0000:a0:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.917340] pci 0000:a0:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.923335] pci 0000:a0:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.929336] pci 0000:a0:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.935344] pci 0000:a0:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.941324] pci 0000:a0:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.948485] pci 0000:a0:07.1: enabling Extended Tags
>>>>>>> [    5.953327] pci 0000:a0:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.959361] pci 0000:a0:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    5.965328] pci 0000:a0:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    5.971272] pci 0000:a0:08.1: enabling Extended Tags
>>>>>>> [    5.976322] pci 0000:a0:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    5.983486] pci 0000:a1:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    5.989270] pci 0000:a1:00.0: enabling Extended Tags
>>>>>>> [    5.994348] pci 0000:a1:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    6.000248] pci 0000:a1:00.2: reg 0x18: [mem 0xb4200000-0xb42fffff]
>>>>>>> [    6.007238] pci 0000:a1:00.2: reg 0x24: [mem 0xb4300000-0xb4301fff]
>>>>>>> [    6.013234] pci 0000:a1:00.2: enabling Extended Tags
>>>>>>> [    6.018377] pci 0000:a0:07.1: PCI bridge to [bus a1]
>>>>>>> [    6.023229] pci 0000:a0:07.1:   bridge window [mem 0xb4200000-0xb43fffff]
>>>>>>> [    6.030505] pci 0000:a2:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    6.036273] pci 0000:a2:00.0: enabling Extended Tags
>>>>>>> [    6.041361] pci 0000:a2:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    6.047249] pci 0000:a2:00.1: reg 0x18: [mem 0xb4000000-0xb40fffff]
>>>>>>> [    6.054240] pci 0000:a2:00.1: reg 0x24: [mem 0xb4100000-0xb4101fff]
>>>>>>> [    6.060236] pci 0000:a2:00.1: enabling Extended Tags
>>>>>>> [    6.065389] pci 0000:a0:08.1: PCI bridge to [bus a2]
>>>>>>> [    6.070230] pci 0000:a0:08.1:   bridge window [mem 0xb4000000-0xb41fffff]
>>>>>>> [    6.077454] ACPI: PCI Root Bridge [PC06] (domain 0000 [bus c0-df])
>>>>>>> [    6.083228] acpi PNP0A08:06: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    6.092263] acpi PNP0A08:06: PCIe AER handled by firmware
>>>>>>> [    6.098265] acpi PNP0A08:06: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    6.105294] acpi PNP0A08:06: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    6.113228] acpi PNP0A08:06: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    6.121427] PCI host bridge to bus 0000:c0
>>>>>>> [    6.125225] pci_bus 0000:c0: root bus resource [io  0xc000-0xdfff window]
>>>>>>> [    6.132226] pci_bus 0000:c0: root bus resource [mem 0x9d000000-0xa9ffffff window]
>>>>>>> [    6.139224] pci_bus 0000:c0: root bus resource [mem 0x63dc0000000-0x71d5fffffff window]
>>>>>>> [    6.147226] pci_bus 0000:c0: root bus resource [bus c0-df]
>>>>>>> [    6.153229] pci 0000:c0:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    6.159339] pci 0000:c0:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    6.165358] pci 0000:c0:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.171349] pci 0000:c0:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.177342] pci 0000:c0:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.183349] pci 0000:c0:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.189343] pci 0000:c0:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.196304] pci 0000:c0:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    6.202471] pci 0000:c0:07.1: enabling Extended Tags
>>>>>>> [    6.207325] pci 0000:c0:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    6.213360] pci 0000:c0:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.219328] pci 0000:c0:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    6.225274] pci 0000:c0:08.1: enabling Extended Tags
>>>>>>> [    6.231238] pci 0000:c0:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    6.237503] pci 0000:c1:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    6.243275] pci 0000:c1:00.0: enabling Extended Tags
>>>>>>> [    6.248354] pci 0000:c1:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    6.255249] pci 0000:c1:00.2: reg 0x18: [mem 0xa7200000-0xa72fffff]
>>>>>>> [    6.261240] pci 0000:c1:00.2: reg 0x24: [mem 0xa7300000-0xa7301fff]
>>>>>>> [    6.267235] pci 0000:c1:00.2: enabling Extended Tags
>>>>>>> [    6.272384] pci 0000:c0:07.1: PCI bridge to [bus c1]
>>>>>>> [    6.277230] pci 0000:c0:07.1:   bridge window [mem 0xa7200000-0xa73fffff]
>>>>>>> [    6.284389] pci 0000:c2:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    6.290276] pci 0000:c2:00.0: enabling Extended Tags
>>>>>>> [    6.295365] pci 0000:c2:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    6.301252] pci 0000:c2:00.1: reg 0x18: [mem 0xa7000000-0xa70fffff]
>>>>>>> [    6.308240] pci 0000:c2:00.1: reg 0x24: [mem 0xa7100000-0xa7101fff]
>>>>>>> [    6.314235] pci 0000:c2:00.1: enabling Extended Tags
>>>>>>> [    6.319389] pci 0000:c0:08.1: PCI bridge to [bus c2]
>>>>>>> [    6.324230] pci 0000:c0:08.1:   bridge window [mem 0xa7000000-0xa71fffff]
>>>>>>> [    6.331427] ACPI: PCI Root Bridge [PC07] (domain 0000 [bus e0-ff])
>>>>>>> [    6.337227] acpi PNP0A08:07: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
>>>>>>> [    6.346263] acpi PNP0A08:07: PCIe AER handled by firmware
>>>>>>> [    6.352260] acpi PNP0A08:07: _OSC: platform does not support [SHPCHotplug LTR]
>>>>>>> [    6.359295] acpi PNP0A08:07: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
>>>>>>> [    6.367226] acpi PNP0A08:07: FADT indicates ASPM is unsupported, using BIOS configuration
>>>>>>> [    6.375368] acpi PNP0A08:07: host bridge window [mem 0x71d60000000-0xffffffffffff window] ([0x80000000000-0xffffffffffff] ignored, not CPU addressable)
>>>>>>> [    6.389284] PCI host bridge to bus 0000:e0
>>>>>>> [    6.393225] pci_bus 0000:e0: root bus resource [io  0xe000-0xffff window]
>>>>>>> [    6.399225] pci_bus 0000:e0: root bus resource [mem 0x90000000-0x9cffffff window]
>>>>>>> [    6.407224] pci_bus 0000:e0: root bus resource [mem 0x71d60000000-0x7ffffffffff window]
>>>>>>> [    6.415225] pci_bus 0000:e0: root bus resource [bus e0-ff]
>>>>>>> [    6.420229] pci 0000:e0:00.0: [1022:1450] type 00 class 0x060000
>>>>>>> [    6.426334] pci 0000:e0:00.2: [1022:1451] type 00 class 0x080600
>>>>>>> [    6.433340] pci 0000:e0:01.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.439351] pci 0000:e0:02.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.445341] pci 0000:e0:03.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.451342] pci 0000:e0:04.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.457345] pci 0000:e0:07.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.463326] pci 0000:e0:07.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    6.469276] pci 0000:e0:07.1: enabling Extended Tags
>>>>>>> [    6.474333] pci 0000:e0:07.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    6.481357] pci 0000:e0:08.0: [1022:1452] type 00 class 0x060000
>>>>>>> [    6.487326] pci 0000:e0:08.1: [1022:1454] type 01 class 0x060400
>>>>>>> [    6.493723] pci 0000:e0:08.1: enabling Extended Tags
>>>>>>> [    6.498328] pci 0000:e0:08.1: PME# supported from D0 D3hot D3cold
>>>>>>> [    6.505303] pci 0000:e1:00.0: [1022:145a] type 00 class 0x130000
>>>>>>> [    6.511274] pci 0000:e1:00.0: enabling Extended Tags
>>>>>>> [    6.516363] pci 0000:e1:00.2: [1022:1456] type 00 class 0x108000
>>>>>>> [    6.522249] pci 0000:e1:00.2: reg 0x18: [mem 0x9a200000-0x9a2fffff]
>>>>>>> [    6.528240] pci 0000:e1:00.2: reg 0x24: [mem 0x9a300000-0x9a301fff]
>>>>>>> [    6.535234] pci 0000:e1:00.2: enabling Extended Tags
>>>>>>> [    6.539385] pci 0000:e0:07.1: PCI bridge to [bus e1]
>>>>>>> [    6.545229] pci 0000:e0:07.1:   bridge window [mem 0x9a200000-0x9a3fffff]
>>>>>>> [    6.551328] pci 0000:e2:00.0: [1022:1455] type 00 class 0x130000
>>>>>>> [    6.558276] pci 0000:e2:00.0: enabling Extended Tags
>>>>>>> [    6.563362] pci 0000:e2:00.1: [1022:1468] type 00 class 0x108000
>>>>>>> [    6.569238] pci 0000:e2:00.1: reg 0x18: [mem 0x9a000000-0x9a0fffff]
>>>>>>> [    6.575240] pci 0000:e2:00.1: reg 0x24: [mem 0x9a100000-0x9a101fff]
>>>>>>> [    6.581235] pci 0000:e2:00.1: enabling Extended Tags
>>>>>>> [    6.586390] pci 0000:e0:08.1: PCI bridge to [bus e2]
>>>>>>> [    6.591229] pci 0000:e0:08.1:   bridge window [mem 0x9a000000-0x9a1fffff]
>>>>>>> [    6.602360] pci 0000:03:00.0: vgaarb: setting as boot VGA device
>>>>>>> [    6.603223] pci 0000:03:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
>>>>>>> [    6.617294] pci 0000:03:00.0: vgaarb: bridge control possible
>>>>>>> [    6.623225] vgaarb: loaded
>>>>>>> [    6.626445] SCSI subsystem initialized
>>>>>>> [    6.630249] ACPI: bus type USB registered
>>>>>>> [    6.634256] usbcore: registered new interface driver usbfs
>>>>>>> [    6.639232] usbcore: registered new interface driver hub
>>>>>>> [    6.645233] usbcore: registered new device driver usb
>>>>>>> [    6.650253] pps_core: LinuxPPS API ver. 1 registered
>>>>>>> [    6.655225] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
>>>>>>> [    6.664227] PTP clock support registered
>>>>>>> [    6.669224] EDAC MC: Ver: 3.0.0
>>>>>>> [    6.672535] Registered efivars operations
>>>>>>> [    6.825690] PCI: Using ACPI for IRQ routing
>>>>>>> [    6.849411] NetLabel: Initializing
>>>>>>> [    6.853225] NetLabel:  domain hash size = 128
>>>>>>> [    6.857225] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
>>>>>>> [    6.863244] NetLabel:  unlabeled traffic allowed by default
>>>>>>> [    6.869341] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>>>>>>> [    6.874226] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
>>>>>>> [    6.882594] clocksource: Switched to clocksource tsc-early
>>>>>>> [    6.903672] VFS: Disk quotas dquot_6.6.0
>>>>>>> [    6.907692] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>>>>>>> [    6.914638] *** VALIDATE hugetlbfs ***
>>>>>>> [    6.918516] pnp: PnP ACPI init
>>>>>>> [    6.921920] system 00:00: [mem 0x80000000-0x8fffffff] has been reserved
>>>>>>> [    6.929477] pnp: PnP ACPI: found 4 devices
>>>>>>> [    6.940182] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
>>>>>>> [    6.949062] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
>>>>>>> [    6.958979] pci 0000:01:00.1: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
>>>>>>> [    6.968893] pci 0000:04:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
>>>>>>> [    6.978808] pci 0000:04:00.1: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
>>>>>>> [    6.988743] pci 0000:61:00.0: can't claim BAR 6 [mem 0xfff00000-0xffffffff pref]: no compatible bridge window
>>>>>>> [    6.998745] pci 0000:00:01.1: BAR 14: assigned [mem 0xee100000-0xee1fffff]
>>>>>>> [    7.005645] pci 0000:01:00.0: BAR 6: assigned [mem 0xee100000-0xee17ffff pref]
>>>>>>> [    7.012867] pci 0000:01:00.1: BAR 6: assigned [mem 0xee180000-0xee1fffff pref]
>>>>>>> [    7.020098] pci 0000:00:01.1: PCI bridge to [bus 01]
>>>>>>> [    7.025078] pci 0000:00:01.1:   bridge window [mem 0xee100000-0xee1fffff]
>>>>>>> [    7.031873] pci 0000:00:01.1:   bridge window [mem 0xec000000-0xee0fffff 64bit pref]
>>>>>>> [    7.039630] pci 0000:02:00.0: PCI bridge to [bus 03]
>>>>>>> [    7.044609] pci 0000:02:00.0:   bridge window [mem 0xf9000000-0xf98fffff]
>>>>>>> [    7.051404] pci 0000:02:00.0:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    7.059156] pci 0000:00:01.3: PCI bridge to [bus 02-03]
>>>>>>> [    7.064392] pci 0000:00:01.3:   bridge window [mem 0xf9000000-0xf98fffff]
>>>>>>> [    7.071186] pci 0000:00:01.3:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    7.078943] pci 0000:04:00.0: BAR 6: assigned [mem 0xfa080000-0xfa0fffff pref]
>>>>>>> [    7.086168] pci 0000:04:00.1: BAR 6: no space for [mem size 0x00080000 pref]
>>>>>>> [    7.093219] pci 0000:04:00.1: BAR 6: failed to assign [mem size 0x00080000 pref]
>>>>>>> [    7.100618] pci 0000:00:01.4: PCI bridge to [bus 04]
>>>>>>> [    7.105598] pci 0000:00:01.4:   bridge window [mem 0xf9e00000-0xfa0fffff]
>>>>>>> [    7.112398] pci 0000:00:07.1: PCI bridge to [bus 05]
>>>>>>> [    7.117375] pci 0000:00:07.1:   bridge window [mem 0xf9b00000-0xf9dfffff]
>>>>>>> [    7.124174] pci 0000:00:08.1: PCI bridge to [bus 06]
>>>>>>> [    7.129147] pci 0000:00:08.1:   bridge window [mem 0xf9900000-0xf9afffff]
>>>>>>> [    7.135967] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
>>>>>>> [    7.142155] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
>>>>>>> [    7.148344] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
>>>>>>> [    7.154529] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff window]
>>>>>>> [    7.161409] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000c3fff window]
>>>>>>> [    7.168294] pci_bus 0000:00: resource 9 [mem 0x000c4000-0x000c7fff window]
>>>>>>> [    7.175177] pci_bus 0000:00: resource 10 [mem 0x000c8000-0x000cbfff window]
>>>>>>> [    7.182143] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cffff window]
>>>>>>> [    7.189109] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d3fff window]
>>>>>>> [    7.196079] pci_bus 0000:00: resource 13 [mem 0x000d4000-0x000d7fff window]
>>>>>>> [    7.203044] pci_bus 0000:00: resource 14 [mem 0x000d8000-0x000dbfff window]
>>>>>>> [    7.210014] pci_bus 0000:00: resource 15 [mem 0x000dc000-0x000dffff window]
>>>>>>> [    7.216986] pci_bus 0000:00: resource 16 [mem 0x000e0000-0x000e3fff window]
>>>>>>> [    7.223951] pci_bus 0000:00: resource 17 [mem 0x000e4000-0x000e7fff window]
>>>>>>> [    7.230921] pci_bus 0000:00: resource 18 [mem 0x000e8000-0x000ebfff window]
>>>>>>> [    7.237888] pci_bus 0000:00: resource 19 [mem 0x000ec000-0x000effff window]
>>>>>>> [    7.244853] pci_bus 0000:00: resource 20 [mem 0x000f0000-0x000fffff window]
>>>>>>> [    7.251820] pci_bus 0000:00: resource 21 [io  0x0d00-0x1fff window]
>>>>>>> [    7.258099] pci_bus 0000:00: resource 22 [mem 0xeb000000-0xfebfffff window]
>>>>>>> [    7.265068] pci_bus 0000:00: resource 23 [mem 0x10000000000-0x1df9fffffff window]
>>>>>>> [    7.272555] pci_bus 0000:01: resource 1 [mem 0xee100000-0xee1fffff]
>>>>>>> [    7.278827] pci_bus 0000:01: resource 2 [mem 0xec000000-0xee0fffff 64bit pref]
>>>>>>> [    7.286060] pci_bus 0000:02: resource 1 [mem 0xf9000000-0xf98fffff]
>>>>>>> [    7.292329] pci_bus 0000:02: resource 2 [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    7.299552] pci_bus 0000:03: resource 1 [mem 0xf9000000-0xf98fffff]
>>>>>>> [    7.305827] pci_bus 0000:03: resource 2 [mem 0xeb000000-0xebffffff 64bit pref]
>>>>>>> [    7.313058] pci_bus 0000:04: resource 1 [mem 0xf9e00000-0xfa0fffff]
>>>>>>> [    7.319333] pci_bus 0000:05: resource 1 [mem 0xf9b00000-0xf9dfffff]
>>>>>>> [    7.325608] pci_bus 0000:06: resource 1 [mem 0xf9900000-0xf9afffff]
>>>>>>> [    7.331957] pci 0000:20:07.1: PCI bridge to [bus 21]
>>>>>>> [    7.336940] pci 0000:20:07.1:   bridge window [mem 0xe8200000-0xe84fffff]
>>>>>>> [    7.343742] pci 0000:20:08.1: PCI bridge to [bus 22]
>>>>>>> [    7.348721] pci 0000:20:08.1:   bridge window [mem 0xe8000000-0xe81fffff]
>>>>>>> [    7.355520] pci_bus 0000:20: resource 4 [io  0x2000-0x3fff window]
>>>>>>> [    7.361711] pci_bus 0000:20: resource 5 [mem 0xde000000-0xeaffffff window]
>>>>>>> [    7.368591] pci_bus 0000:20: resource 6 [mem 0x1dfa0000000-0x2bf3fffffff window]
>>>>>>> [    7.375994] pci_bus 0000:21: resource 1 [mem 0xe8200000-0xe84fffff]
>>>>>>> [    7.382271] pci_bus 0000:22: resource 1 [mem 0xe8000000-0xe81fffff]
>>>>>>> [    7.388581] pci 0000:40:07.1: PCI bridge to [bus 41]
>>>>>>> [    7.393555] pci 0000:40:07.1:   bridge window [mem 0xdb200000-0xdb3fffff]
>>>>>>> [    7.400358] pci 0000:40:08.1: PCI bridge to [bus 42]
>>>>>>> [    7.405335] pci 0000:40:08.1:   bridge window [mem 0xdb000000-0xdb1fffff]
>>>>>>> [    7.412133] pci_bus 0000:40: resource 4 [io  0x4000-0x5fff window]
>>>>>>> [    7.418324] pci_bus 0000:40: resource 5 [mem 0xd1000000-0xddffffff window]
>>>>>>> [    7.425204] pci_bus 0000:40: resource 6 [mem 0x2bf40000000-0x39edfffffff window]
>>>>>>> [    7.432609] pci_bus 0000:41: resource 1 [mem 0xdb200000-0xdb3fffff]
>>>>>>> [    7.438879] pci_bus 0000:42: resource 1 [mem 0xdb000000-0xdb1fffff]
>>>>>>> [    7.445177] pci 0000:61:00.0: BAR 6: no space for [mem size 0x00100000 pref]
>>>>>>> [    7.452227] pci 0000:61:00.0: BAR 6: failed to assign [mem size 0x00100000 pref]
>>>>>>> [    7.459633] pci 0000:60:03.1: PCI bridge to [bus 61]
>>>>>>> [    7.464604] pci 0000:60:03.1:   bridge window [io  0x6000-0x6fff]
>>>>>>> [    7.470711] pci 0000:60:03.1:   bridge window [mem 0xce400000-0xce4fffff]
>>>>>>> [    7.477510] pci 0000:60:03.1:   bridge window [mem 0xc4000000-0xc41fffff 64bit pref]
>>>>>>> [    7.485263] pci 0000:60:07.1: PCI bridge to [bus 62]
>>>>>>> [    7.490245] pci 0000:60:07.1:   bridge window [mem 0xce200000-0xce3fffff]
>>>>>>> [    7.497044] pci 0000:60:08.1: PCI bridge to [bus 63]
>>>>>>> [    7.502024] pci 0000:60:08.1:   bridge window [mem 0xce000000-0xce1fffff]
>>>>>>> [    7.508824] pci_bus 0000:60: resource 4 [io  0x6000-0x7fff window]
>>>>>>> [    7.515010] pci_bus 0000:60: resource 5 [mem 0xc4000000-0xd0ffffff window]
>>>>>>> [    7.521895] pci_bus 0000:60: resource 6 [mem 0x39ee0000000-0x47e7fffffff window]
>>>>>>> [    7.529293] pci_bus 0000:61: resource 0 [io  0x6000-0x6fff]
>>>>>>> [    7.534875] pci_bus 0000:61: resource 1 [mem 0xce400000-0xce4fffff]
>>>>>>> [    7.541151] pci_bus 0000:61: resource 2 [mem 0xc4000000-0xc41fffff 64bit pref]
>>>>>>> [    7.548377] pci_bus 0000:62: resource 1 [mem 0xce200000-0xce3fffff]
>>>>>>> [    7.554651] pci_bus 0000:63: resource 1 [mem 0xce000000-0xce1fffff]
>>>>>>> [    7.560948] pci 0000:80:07.1: PCI bridge to [bus 81]
>>>>>>> [    7.565921] pci 0000:80:07.1:   bridge window [mem 0xc1200000-0xc13fffff]
>>>>>>> [    7.572717] pci 0000:80:08.1: PCI bridge to [bus 82]
>>>>>>> [    7.577690] pci 0000:80:08.1:   bridge window [mem 0xc1000000-0xc11fffff]
>>>>>>> [    7.584489] pci_bus 0000:80: resource 4 [io  0x8000-0x9fff window]
>>>>>>> [    7.590682] pci_bus 0000:80: resource 5 [mem 0xb7000000-0xc3ffffff window]
>>>>>>> [    7.597563] pci_bus 0000:80: resource 6 [mem 0x47e80000000-0x55e1fffffff window]
>>>>>>> [    7.604967] pci_bus 0000:81: resource 1 [mem 0xc1200000-0xc13fffff]
>>>>>>> [    7.611237] pci_bus 0000:82: resource 1 [mem 0xc1000000-0xc11fffff]
>>>>>>> [    7.617534] pci 0000:a0:07.1: PCI bridge to [bus a1]
>>>>>>> [    7.622510] pci 0000:a0:07.1:   bridge window [mem 0xb4200000-0xb43fffff]
>>>>>>> [    7.629308] pci 0000:a0:08.1: PCI bridge to [bus a2]
>>>>>>> [    7.634283] pci 0000:a0:08.1:   bridge window [mem 0xb4000000-0xb41fffff]
>>>>>>> [    7.641087] pci_bus 0000:a0: resource 4 [io  0xa000-0xbfff window]
>>>>>>> [    7.647275] pci_bus 0000:a0: resource 5 [mem 0xaa000000-0xb6ffffff window]
>>>>>>> [    7.654161] pci_bus 0000:a0: resource 6 [mem 0x55e20000000-0x63dbfffffff window]
>>>>>>> [    7.661561] pci_bus 0000:a1: resource 1 [mem 0xb4200000-0xb43fffff]
>>>>>>> [    7.667830] pci_bus 0000:a2: resource 1 [mem 0xb4000000-0xb41fffff]
>>>>>>> [    7.674142] pci 0000:c0:07.1: PCI bridge to [bus c1]
>>>>>>> [    7.679124] pci 0000:c0:07.1:   bridge window [mem 0xa7200000-0xa73fffff]
>>>>>>> [    7.685931] pci 0000:c0:08.1: PCI bridge to [bus c2]
>>>>>>> [    7.690904] pci 0000:c0:08.1:   bridge window [mem 0xa7000000-0xa71fffff]
>>>>>>> [    7.697707] pci_bus 0000:c0: resource 4 [io  0xc000-0xdfff window]
>>>>>>> [    7.703895] pci_bus 0000:c0: resource 5 [mem 0x9d000000-0xa9ffffff window]
>>>>>>> [    7.710777] pci_bus 0000:c0: resource 6 [mem 0x63dc0000000-0x71d5fffffff window]
>>>>>>> [    7.718178] pci_bus 0000:c1: resource 1 [mem 0xa7200000-0xa73fffff]
>>>>>>> [    7.724452] pci_bus 0000:c2: resource 1 [mem 0xa7000000-0xa71fffff]
>>>>>>> [    7.730749] pci 0000:e0:07.1: PCI bridge to [bus e1]
>>>>>>> [    7.735725] pci 0000:e0:07.1:   bridge window [mem 0x9a200000-0x9a3fffff]
>>>>>>> [    7.742524] pci 0000:e0:08.1: PCI bridge to [bus e2]
>>>>>>> [    7.747500] pci 0000:e0:08.1:   bridge window [mem 0x9a000000-0x9a1fffff]
>>>>>>> [    7.754299] pci_bus 0000:e0: resource 4 [io  0xe000-0xffff window]
>>>>>>> [    7.760495] pci_bus 0000:e0: resource 5 [mem 0x90000000-0x9cffffff window]
>>>>>>> [    7.767371] pci_bus 0000:e0: resource 6 [mem 0x71d60000000-0x7ffffffffff window]
>>>>>>> [    7.774776] pci_bus 0000:e1: resource 1 [mem 0x9a200000-0x9a3fffff]
>>>>>>> [    7.781048] pci_bus 0000:e2: resource 1 [mem 0x9a000000-0x9a1fffff]
>>>>>>> [    7.787520] NET: Registered protocol family 2
>>>>>>> [    7.792686] tcp_listen_portaddr_hash hash table entries: 32768 (order: 7, 524288 bytes)
>>>>>>> [    7.801264] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
>>>>>>> [    7.810039] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>>>>>>> [    7.816992] TCP: Hash tables configured (established 524288 bind 65536)
>>>>>>> [    7.823892] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
>>>>>>> [    7.830503] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
>>>>>>> [    7.837998] NET: Registered protocol family 1
>>>>>>> [    7.842372] NET: Registered protocol family 44
>>>>>>> [    7.846998] pci 0000:03:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
>>>>>>> [    7.855814] pci 0000:06:00.2: CLS mismatch (128 != 64), using 64 bytes
>>>>>>> [    7.862718] Trying to unpack rootfs image as initramfs...
>>>>>>> [    9.163353] Freeing initrd memory: 85720K
>>>>>>> [    9.167463] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.174475] pci 0000:20:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.181397] pci 0000:40:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.188324] pci 0000:60:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.195256] pci 0000:80:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.202185] pci 0000:a0:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.209114] pci 0000:c0:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.216042] pci 0000:e0:00.2: AMD-Vi: IOMMU performance counters supported
>>>>>>> [    9.223873] pci 0000:00:01.0: Adding to iommu group 0
>>>>>>> [    9.228978] pci 0000:00:01.1: Adding to iommu group 1
>>>>>>> [    9.234078] pci 0000:00:01.3: Adding to iommu group 2
>>>>>>> [    9.239174] pci 0000:00:01.4: Adding to iommu group 3
>>>>>>> [    9.244277] pci 0000:00:02.0: Adding to iommu group 4
>>>>>>> [    9.249387] pci 0000:00:03.0: Adding to iommu group 5
>>>>>>> [    9.254501] pci 0000:00:04.0: Adding to iommu group 6
>>>>>>> [    9.259616] pci 0000:00:07.0: Adding to iommu group 7
>>>>>>> [    9.264717] pci 0000:00:07.1: Adding to iommu group 8
>>>>>>> [    9.269828] pci 0000:00:08.0: Adding to iommu group 9
>>>>>>> [    9.274924] pci 0000:00:08.1: Adding to iommu group 10
>>>>>>> [    9.280134] pci 0000:00:14.0: Adding to iommu group 11
>>>>>>> [    9.285307] pci 0000:00:14.3: Adding to iommu group 11
>>>>>>> [    9.290624] pci 0000:00:18.0: Adding to iommu group 12
>>>>>>> [    9.295800] pci 0000:00:18.1: Adding to iommu group 12
>>>>>>> [    9.300977] pci 0000:00:18.2: Adding to iommu group 12
>>>>>>> [    9.306155] pci 0000:00:18.3: Adding to iommu group 12
>>>>>>> [    9.311337] pci 0000:00:18.4: Adding to iommu group 12
>>>>>>> [    9.316510] pci 0000:00:18.5: Adding to iommu group 12
>>>>>>> [    9.321683] pci 0000:00:18.6: Adding to iommu group 12
>>>>>>> [    9.326860] pci 0000:00:18.7: Adding to iommu group 12
>>>>>>> [    9.332181] pci 0000:00:19.0: Adding to iommu group 13
>>>>>>> [    9.337353] pci 0000:00:19.1: Adding to iommu group 13
>>>>>>> [    9.342527] pci 0000:00:19.2: Adding to iommu group 13
>>>>>>> [    9.347698] pci 0000:00:19.3: Adding to iommu group 13
>>>>>>> [    9.352877] pci 0000:00:19.4: Adding to iommu group 13
>>>>>>> [    9.358048] pci 0000:00:19.5: Adding to iommu group 13
>>>>>>> [    9.363222] pci 0000:00:19.6: Adding to iommu group 13
>>>>>>> [    9.368396] pci 0000:00:19.7: Adding to iommu group 13
>>>>>>> [    9.373721] pci 0000:00:1a.0: Adding to iommu group 14
>>>>>>> [    9.378894] pci 0000:00:1a.1: Adding to iommu group 14
>>>>>>> [    9.384066] pci 0000:00:1a.2: Adding to iommu group 14
>>>>>>> [    9.389243] pci 0000:00:1a.3: Adding to iommu group 14
>>>>>>> [    9.394414] pci 0000:00:1a.4: Adding to iommu group 14
>>>>>>> [    9.399590] pci 0000:00:1a.5: Adding to iommu group 14
>>>>>>> [    9.404765] pci 0000:00:1a.6: Adding to iommu group 14
>>>>>>> [    9.409935] pci 0000:00:1a.7: Adding to iommu group 14
>>>>>>> [    9.415264] pci 0000:00:1b.0: Adding to iommu group 15
>>>>>>> [    9.420444] pci 0000:00:1b.1: Adding to iommu group 15
>>>>>>> [    9.425617] pci 0000:00:1b.2: Adding to iommu group 15
>>>>>>> [    9.430790] pci 0000:00:1b.3: Adding to iommu group 15
>>>>>>> [    9.435969] pci 0000:00:1b.4: Adding to iommu group 15
>>>>>>> [    9.441148] pci 0000:00:1b.5: Adding to iommu group 15
>>>>>>> [    9.446325] pci 0000:00:1b.6: Adding to iommu group 15
>>>>>>> [    9.451503] pci 0000:00:1b.7: Adding to iommu group 15
>>>>>>> [    9.456823] pci 0000:00:1c.0: Adding to iommu group 16
>>>>>>> [    9.462001] pci 0000:00:1c.1: Adding to iommu group 16
>>>>>>> [    9.467174] pci 0000:00:1c.2: Adding to iommu group 16
>>>>>>> [    9.472347] pci 0000:00:1c.3: Adding to iommu group 16
>>>>>>> [    9.477521] pci 0000:00:1c.4: Adding to iommu group 16
>>>>>>> [    9.482695] pci 0000:00:1c.5: Adding to iommu group 16
>>>>>>> [    9.487874] pci 0000:00:1c.6: Adding to iommu group 16
>>>>>>> [    9.493058] pci 0000:00:1c.7: Adding to iommu group 16
>>>>>>> [    9.498382] pci 0000:00:1d.0: Adding to iommu group 17
>>>>>>> [    9.503562] pci 0000:00:1d.1: Adding to iommu group 17
>>>>>>> [    9.508744] pci 0000:00:1d.2: Adding to iommu group 17
>>>>>>> [    9.513928] pci 0000:00:1d.3: Adding to iommu group 17
>>>>>>> [    9.519112] pci 0000:00:1d.4: Adding to iommu group 17
>>>>>>> [    9.524290] pci 0000:00:1d.5: Adding to iommu group 17
>>>>>>> [    9.529468] pci 0000:00:1d.6: Adding to iommu group 17
>>>>>>> [    9.534647] pci 0000:00:1d.7: Adding to iommu group 17
>>>>>>> [    9.539964] pci 0000:00:1e.0: Adding to iommu group 18
>>>>>>> [    9.545149] pci 0000:00:1e.1: Adding to iommu group 18
>>>>>>> [    9.550329] pci 0000:00:1e.2: Adding to iommu group 18
>>>>>>> [    9.555513] pci 0000:00:1e.3: Adding to iommu group 18
>>>>>>> [    9.560690] pci 0000:00:1e.4: Adding to iommu group 18
>>>>>>> [    9.565865] pci 0000:00:1e.5: Adding to iommu group 18
>>>>>>> [    9.571041] pci 0000:00:1e.6: Adding to iommu group 18
>>>>>>> [    9.576222] pci 0000:00:1e.7: Adding to iommu group 18
>>>>>>> [    9.581538] pci 0000:00:1f.0: Adding to iommu group 19
>>>>>>> [    9.586720] pci 0000:00:1f.1: Adding to iommu group 19
>>>>>>> [    9.591901] pci 0000:00:1f.2: Adding to iommu group 19
>>>>>>> [    9.597077] pci 0000:00:1f.3: Adding to iommu group 19
>>>>>>> [    9.602263] pci 0000:00:1f.4: Adding to iommu group 19
>>>>>>> [    9.607443] pci 0000:00:1f.5: Adding to iommu group 19
>>>>>>> [    9.612623] pci 0000:00:1f.6: Adding to iommu group 19
>>>>>>> [    9.617800] pci 0000:00:1f.7: Adding to iommu group 19
>>>>>>> [    9.622996] pci 0000:01:00.0: Adding to iommu group 20
>>>>>>> [    9.628190] pci 0000:01:00.1: Adding to iommu group 21
>>>>>>> [    9.633372] pci 0000:02:00.0: Adding to iommu group 22
>>>>>>> [    9.638525] pci 0000:03:00.0: Adding to iommu group 22
>>>>>>> [    9.643720] pci 0000:04:00.0: Adding to iommu group 23
>>>>>>> [    9.648903] pci 0000:04:00.1: Adding to iommu group 24
>>>>>>> [    9.654100] pci 0000:05:00.0: Adding to iommu group 25
>>>>>>> [    9.659287] pci 0000:05:00.2: Adding to iommu group 26
>>>>>>> [    9.664480] pci 0000:05:00.3: Adding to iommu group 27
>>>>>>> [    9.669678] pci 0000:06:00.0: Adding to iommu group 28
>>>>>>> [    9.674863] pci 0000:06:00.1: Adding to iommu group 29
>>>>>>> [    9.680062] pci 0000:06:00.2: Adding to iommu group 30
>>>>>>> [    9.685265] pci 0000:20:01.0: Adding to iommu group 31
>>>>>>> [    9.690453] pci 0000:20:02.0: Adding to iommu group 32
>>>>>>> [    9.695646] pci 0000:20:03.0: Adding to iommu group 33
>>>>>>> [    9.700836] pci 0000:20:04.0: Adding to iommu group 34
>>>>>>> [    9.706030] pci 0000:20:07.0: Adding to iommu group 35
>>>>>>> [    9.711208] pci 0000:20:07.1: Adding to iommu group 36
>>>>>>> [    9.716400] pci 0000:20:08.0: Adding to iommu group 37
>>>>>>> [    9.721574] pci 0000:20:08.1: Adding to iommu group 38
>>>>>>> [    9.726753] pci 0000:21:00.0: Adding to iommu group 39
>>>>>>> [    9.731931] pci 0000:21:00.2: Adding to iommu group 40
>>>>>>> [    9.737103] pci 0000:21:00.3: Adding to iommu group 41
>>>>>>> [    9.742280] pci 0000:22:00.0: Adding to iommu group 42
>>>>>>> [    9.747455] pci 0000:22:00.1: Adding to iommu group 43
>>>>>>> [    9.752656] pci 0000:40:01.0: Adding to iommu group 44
>>>>>>> [    9.757858] pci 0000:40:02.0: Adding to iommu group 45
>>>>>>> [    9.763054] pci 0000:40:03.0: Adding to iommu group 46
>>>>>>> [    9.768249] pci 0000:40:04.0: Adding to iommu group 47
>>>>>>> [    9.773452] pci 0000:40:07.0: Adding to iommu group 48
>>>>>>> [    9.778635] pci 0000:40:07.1: Adding to iommu group 49
>>>>>>> [    9.783830] pci 0000:40:08.0: Adding to iommu group 50
>>>>>>> [    9.789018] pci 0000:40:08.1: Adding to iommu group 51
>>>>>>> [    9.794216] pci 0000:41:00.0: Adding to iommu group 52
>>>>>>> [    9.799410] pci 0000:41:00.2: Adding to iommu group 53
>>>>>>> [    9.804601] pci 0000:42:00.0: Adding to iommu group 54
>>>>>>> [    9.809793] pci 0000:42:00.1: Adding to iommu group 55
>>>>>>> [    9.814988] pci 0000:60:01.0: Adding to iommu group 56
>>>>>>> [    9.820185] pci 0000:60:02.0: Adding to iommu group 57
>>>>>>> [    9.825381] pci 0000:60:03.0: Adding to iommu group 58
>>>>>>> [    9.830572] pci 0000:60:03.1: Adding to iommu group 59
>>>>>>> [    9.835773] pci 0000:60:04.0: Adding to iommu group 60
>>>>>>> [    9.840971] pci 0000:60:07.0: Adding to iommu group 61
>>>>>>> [    9.846163] pci 0000:60:07.1: Adding to iommu group 62
>>>>>>> [    9.851368] pci 0000:60:08.0: Adding to iommu group 63
>>>>>>> [    9.856549] pci 0000:60:08.1: Adding to iommu group 64
>>>>>>> [    9.861741] pci 0000:61:00.0: Adding to iommu group 65
>>>>>>> [    9.866934] pci 0000:62:00.0: Adding to iommu group 66
>>>>>>> [    9.872124] pci 0000:62:00.2: Adding to iommu group 67
>>>>>>> [    9.877320] pci 0000:63:00.0: Adding to iommu group 68
>>>>>>> [    9.882517] pci 0000:63:00.1: Adding to iommu group 69
>>>>>>> [    9.887713] pci 0000:80:01.0: Adding to iommu group 70
>>>>>>> [    9.892909] pci 0000:80:02.0: Adding to iommu group 71
>>>>>>> [    9.898098] pci 0000:80:03.0: Adding to iommu group 72
>>>>>>> [    9.903291] pci 0000:80:04.0: Adding to iommu group 73
>>>>>>> [    9.908493] pci 0000:80:07.0: Adding to iommu group 74
>>>>>>> [    9.913681] pci 0000:80:07.1: Adding to iommu group 75
>>>>>>> [    9.918884] pci 0000:80:08.0: Adding to iommu group 76
>>>>>>> [    9.924068] pci 0000:80:08.1: Adding to iommu group 77
>>>>>>> [    9.929266] pci 0000:81:00.0: Adding to iommu group 78
>>>>>>> [    9.934458] pci 0000:81:00.2: Adding to iommu group 79
>>>>>>> [    9.939650] pci 0000:82:00.0: Adding to iommu group 80
>>>>>>> [    9.944846] pci 0000:82:00.1: Adding to iommu group 81
>>>>>>> [    9.950041] pci 0000:a0:01.0: Adding to iommu group 82
>>>>>>> [    9.955236] pci 0000:a0:02.0: Adding to iommu group 83
>>>>>>> [    9.960435] pci 0000:a0:03.0: Adding to iommu group 84
>>>>>>> [    9.965631] pci 0000:a0:04.0: Adding to iommu group 85
>>>>>>> [    9.970832] pci 0000:a0:07.0: Adding to iommu group 86
>>>>>>> [    9.976013] pci 0000:a0:07.1: Adding to iommu group 87
>>>>>>> [    9.981214] pci 0000:a0:08.0: Adding to iommu group 88
>>>>>>> [    9.986403] pci 0000:a0:08.1: Adding to iommu group 89
>>>>>>> [    9.991604] pci 0000:a1:00.0: Adding to iommu group 90
>>>>>>> [    9.996801] pci 0000:a1:00.2: Adding to iommu group 91
>>>>>>> [   10.002002] pci 0000:a2:00.0: Adding to iommu group 92
>>>>>>> [   10.007199] pci 0000:a2:00.1: Adding to iommu group 93
>>>>>>> [   10.012394] pci 0000:c0:01.0: Adding to iommu group 94
>>>>>>> [   10.017593] pci 0000:c0:02.0: Adding to iommu group 95
>>>>>>> [   10.022790] pci 0000:c0:03.0: Adding to iommu group 96
>>>>>>> [   10.027988] pci 0000:c0:04.0: Adding to iommu group 97
>>>>>>> [   10.033188] pci 0000:c0:07.0: Adding to iommu group 98
>>>>>>> [   10.038376] pci 0000:c0:07.1: Adding to iommu group 99
>>>>>>> [   10.043580] pci 0000:c0:08.0: Adding to iommu group 100
>>>>>>> [   10.048854] pci 0000:c0:08.1: Adding to iommu group 101
>>>>>>> [   10.054143] pci 0000:c1:00.0: Adding to iommu group 102
>>>>>>> [   10.059422] pci 0000:c1:00.2: Adding to iommu group 103
>>>>>>> [   10.064709] pci 0000:c2:00.0: Adding to iommu group 104
>>>>>>> [   10.069994] pci 0000:c2:00.1: Adding to iommu group 105
>>>>>>> [   10.075282] pci 0000:e0:01.0: Adding to iommu group 106
>>>>>>> [   10.080563] pci 0000:e0:02.0: Adding to iommu group 107
>>>>>>> [   10.085843] pci 0000:e0:03.0: Adding to iommu group 108
>>>>>>> [   10.091119] pci 0000:e0:04.0: Adding to iommu group 109
>>>>>>> [   10.096402] pci 0000:e0:07.0: Adding to iommu group 110
>>>>>>> [   10.101677] pci 0000:e0:07.1: Adding to iommu group 111
>>>>>>> [   10.106962] pci 0000:e0:08.0: Adding to iommu group 112
>>>>>>> [   10.112237] pci 0000:e0:08.1: Adding to iommu group 113
>>>>>>> [   10.117520] pci 0000:e1:00.0: Adding to iommu group 114
>>>>>>> [   10.122794] pci 0000:e1:00.2: Adding to iommu group 115
>>>>>>> [   10.128078] pci 0000:e2:00.0: Adding to iommu group 116
>>>>>>> [   10.133365] pci 0000:e2:00.1: Adding to iommu group 117
>>>>>>> [   10.138875] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.144367] pci 0000:00:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.151248]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.155177] pci 0000:20:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.160666] pci 0000:20:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.167546]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.171486] pci 0000:40:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.176980] pci 0000:40:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.183858]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.187796] pci 0000:60:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.193286] pci 0000:60:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.200159]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.204098] pci 0000:80:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.209589] pci 0000:80:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.216464]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.220398] pci 0000:a0:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.225895] pci 0000:a0:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.232776]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.236706] pci 0000:c0:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.242196] pci 0000:c0:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.249077]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.253014] pci 0000:e0:00.2: AMD-Vi: Found IOMMU cap 0x40
>>>>>>> [   10.258507] pci 0000:e0:00.2: AMD-Vi: Extended features (0xf77ef22294ada):
>>>>>>> [   10.265387]  PPR NX GT IA GA PC GA_vAPIC
>>>>>>> [   10.269323] AMD-Vi: Interrupt remapping enabled
>>>>>>> [   10.273863] AMD-Vi: Virtual APIC enabled
>>>>>>> [   10.279420] AMD-Vi: Lazy IO/TLB flushing enabled
>>>>>>> [   10.284054] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>>>>>> [   10.290491] software IO TLB: mapped [mem 0x5ec78000-0x62c78000] (64MB)
>>>>>>> [   10.297311] amd_uncore: AMD NB counters detected
>>>>>>> [   10.301966] amd_uncore: AMD LLC counters detected
>>>>>>> [   10.314008] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
>>>>>>> [   10.321177] perf/amd_iommu: Detected AMD IOMMU #1 (2 banks, 4 counters/bank).
>>>>>>> [   10.328333] perf/amd_iommu: Detected AMD IOMMU #2 (2 banks, 4 counters/bank).
>>>>>>> [   10.335483] perf/amd_iommu: Detected AMD IOMMU #3 (2 banks, 4 counters/bank).
>>>>>>> [   10.342636] perf/amd_iommu: Detected AMD IOMMU #4 (2 banks, 4 counters/bank).
>>>>>>> [   10.349816] perf/amd_iommu: Detected AMD IOMMU #5 (2 banks, 4 counters/bank).
>>>>>>> [   10.357140] perf/amd_iommu: Detected AMD IOMMU #6 (2 banks, 4 counters/bank).
>>>>>>> [   10.364302] perf/amd_iommu: Detected AMD IOMMU #7 (2 banks, 4 counters/bank).
>>>>>>> [   10.407722] Initialise system trusted keyrings
>>>>>>> [   10.412191] Key type blacklist registered
>>>>>>> [   10.416390] workingset: timestamp_bits=36 max_order=24 bucket_order=0
>>>>>>> [   10.424310] zbud: loaded
>>>>>>> [   10.430894] Platform Keyring initialized
>>>>>>> [   10.436636] NET: Registered protocol family 38
>>>>>>> [   10.441094] Key type asymmetric registered
>>>>>>> [   10.445197] Asymmetric key parser 'x509' registered
>>>>>>> [   10.450087] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
>>>>>>> [   10.457842] io scheduler mq-deadline registered
>>>>>>> [   10.462376] io scheduler kyber registered
>>>>>>> [   10.466452] io scheduler bfq registered
>>>>>>> [   10.473681] atomic64_test: passed for x86-64 platform with CX8 and with SSE
>>>>>>> [   10.481900] pcieport 0000:00:01.1: PME: Signaling with IRQ 34
>>>>>>> [   10.488687] pcieport 0000:00:01.3: PME: Signaling with IRQ 35
>>>>>>> [   10.494844] pcieport 0000:00:01.4: PME: Signaling with IRQ 36
>>>>>>> [   10.500876] pcieport 0000:00:07.1: PME: Signaling with IRQ 37
>>>>>>> [   10.507794] pcieport 0000:00:08.1: PME: Signaling with IRQ 39
>>>>>>> [   10.514031] pcieport 0000:20:07.1: PME: Signaling with IRQ 40
>>>>>>> [   10.520165] pcieport 0000:20:08.1: PME: Signaling with IRQ 42
>>>>>>> [   10.526979] pcieport 0000:40:07.1: PME: Signaling with IRQ 44
>>>>>>> [   10.533114] pcieport 0000:40:08.1: PME: Signaling with IRQ 46
>>>>>>> [   10.539835] pcieport 0000:60:03.1: PME: Signaling with IRQ 47
>>>>>>> [   10.545989] pcieport 0000:60:07.1: PME: Signaling with IRQ 49
>>>>>>> [   10.552085] pcieport 0000:60:08.1: PME: Signaling with IRQ 51
>>>>>>> [   10.558433] pcieport 0000:80:07.1: PME: Signaling with IRQ 53
>>>>>>> [   10.565308] pcieport 0000:80:08.1: PME: Signaling with IRQ 55
>>>>>>> [   10.571971] pcieport 0000:a0:07.1: PME: Signaling with IRQ 57
>>>>>>> [   10.578121] pcieport 0000:a0:08.1: PME: Signaling with IRQ 59
>>>>>>> [   10.584726] pcieport 0000:c0:07.1: PME: Signaling with IRQ 61
>>>>>>> [   10.590869] pcieport 0000:c0:08.1: PME: Signaling with IRQ 63
>>>>>>> [   10.597556] pcieport 0000:e0:07.1: PME: Signaling with IRQ 65
>>>>>>> [   10.603699] pcieport 0000:e0:08.1: PME: Signaling with IRQ 67
>>>>>>> [   10.609717] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>>>>>>> [   10.616563] efifb: probing for efifb
>>>>>>> [   10.620464] efifb: framebuffer at 0xeb000000, using 3072k, total 3072k
>>>>>>> [   10.626994] efifb: mode is 1024x768x32, linelength=4096, pages=1
>>>>>>> [   10.633006] efifb: scrolling: redraw
>>>>>>> [   10.636585] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
>>>>>>> [   10.657812] Console: switching to colour frame buffer device 128x48
>>>>>>> [   10.679441] fb0: EFI VGA frame buffer device
>>>>>>> [   10.684045] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
>>>>>>> [   10.692402] ACPI: Power Button [PWRB]
>>>>>>> [   10.696124] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>>>>>>> [   10.703587] ACPI: Power Button [PWRF]
>>>>>>> [   10.717509] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
>>>>>>> [   10.725332] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>>>>> [   10.752465] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
>>>>>>> [   10.780729] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>>>>>> [   10.788672] Non-volatile memory driver v1.3
>>>>>>> [   10.804328] rdac: device handler registered
>>>>>>> [   10.808647] hp_sw: device handler registered
>>>>>>> [   10.812927] emc: device handler registered
>>>>>>> [   10.817509] alua: device handler registered
>>>>>>> [   10.821757] libphy: Fixed MDIO Bus: probed
>>>>>>> [   10.826032] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>>>>>> [   10.832565] ehci-pci: EHCI PCI platform driver
>>>>>>> [   10.837039] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>>>>>> [   10.843226] ohci-pci: OHCI PCI platform driver
>>>>>>> [   10.847692] uhci_hcd: USB Universal Host Controller Interface driver
>>>>>>> [   10.854353] xhci_hcd 0000:05:00.3: xHCI Host Controller
>>>>>>> [   10.859684] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 1
>>>>>>> [   10.867260] xhci_hcd 0000:05:00.3: hcc params 0x0270f665 hci version 0x100 quirks 0x0000000000000410
>>>>>>> [   10.876982] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.02
>>>>>>> [   10.885249] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>>>>>> [   10.892475] usb usb1: Product: xHCI Host Controller
>>>>>>> [   10.897356] usb usb1: Manufacturer: Linux 5.2.0-rc4+ xhci-hcd
>>>>>>> [   10.903103] usb usb1: SerialNumber: 0000:05:00.3
>>>>>>> [   10.907856] hub 1-0:1.0: USB hub found
>>>>>>> [   10.911623] hub 1-0:1.0: 2 ports detected
>>>>>>> [   10.915972] xhci_hcd 0000:05:00.3: xHCI Host Controller
>>>>>>> [   10.921329] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 2
>>>>>>> [   10.928742] xhci_hcd 0000:05:00.3: Host supports USB 3.0  SuperSpeed
>>>>>>> [   10.935111] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
>>>>>>> [   10.943229] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.02
>>>>>>> [   10.951491] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>>>>>> [   10.958720] usb usb2: Product: xHCI Host Controller
>>>>>>> [   10.963608] usb usb2: Manufacturer: Linux 5.2.0-rc4+ xhci-hcd
>>>>>>> [   10.969363] usb usb2: SerialNumber: 0000:05:00.3
>>>>>>> [   10.974114] hub 2-0:1.0: USB hub found
>>>>>>> [   10.977879] hub 2-0:1.0: 2 ports detected
>>>>>>> [   10.982295] xhci_hcd 0000:21:00.3: xHCI Host Controller
>>>>>>> [   10.987624] xhci_hcd 0000:21:00.3: new USB bus registered, assigned bus number 3
>>>>>>> [   10.995137] xhci_hcd 0000:21:00.3: hcc params 0x0270f665 hci version 0x100 quirks 0x0000000000000410
>>>>>>> [   11.004616] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.02
>>>>>>> [   11.012878] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>>>>>> [   11.020111] usb usb3: Product: xHCI Host Controller
>>>>>>> [   11.024991] usb usb3: Manufacturer: Linux 5.2.0-rc4+ xhci-hcd
>>>>>>> [   11.030740] usb usb3: SerialNumber: 0000:21:00.3
>>>>>>> [   11.035491] hub 3-0:1.0: USB hub found
>>>>>>> [   11.039258] hub 3-0:1.0: 2 ports detected
>>>>>>> [   11.043594] xhci_hcd 0000:21:00.3: xHCI Host Controller
>>>>>>> [   11.048962] xhci_hcd 0000:21:00.3: new USB bus registered, assigned bus number 4
>>>>>>> [   11.056368] xhci_hcd 0000:21:00.3: Host supports USB 3.0  SuperSpeed
>>>>>>> [   11.062736] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
>>>>>>> [   11.070841] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.02
>>>>>>> [   11.079103] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>>>>>> [   11.086334] usb usb4: Product: xHCI Host Controller
>>>>>>> [   11.091221] usb usb4: Manufacturer: Linux 5.2.0-rc4+ xhci-hcd
>>>>>>> [   11.096976] usb usb4: SerialNumber: 0000:21:00.3
>>>>>>> [   11.101700] hub 4-0:1.0: USB hub found
>>>>>>> [   11.105464] hub 4-0:1.0: 2 ports detected
>>>>>>> [   11.109773] usbcore: registered new interface driver usbserial_generic
>>>>>>> [   11.116319] usbserial: USB Serial support registered for generic
>>>>>>> [   11.122413] i8042: PNP: No PS/2 controller found.
>>>>>>> [   11.127201] mousedev: PS/2 mouse device common for all mice
>>>>>>> [   11.132921] rtc_cmos 00:01: RTC can wake from S4
>>>>>>> [   11.137855] rtc_cmos 00:01: registered as rtc0
>>>>>>> [   11.142326] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
>>>>>>> [   11.150280] EFI Variables Facility v0.08 2004-May-17
>>>>>>> [   11.234327] usb 1-1: new high-speed USB device number 2 using xhci_hcd
>>>>>>> [   11.363246] hidraw: raw HID events driver (C) Jiri Kosina
>>>>>>> [   11.368693] usbcore: registered new interface driver usbhid
>>>>>>> [   11.374265] usbhid: USB HID core driver
>>>>>>> [   11.376259] usb 1-1: New USB device found, idVendor=1604, idProduct=10c0, bcdDevice= 0.00
>>>>>>> [   11.378491] drop_monitor: Initializing network drop monitor service
>>>>>>> [   11.386295] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>>>>>> [   11.392712] Initializing XFRM netlink socket
>>>>>>> [   11.404127] NET: Registered protocol family 10
>>>>>>> [   11.409270] Segment Routing with IPv6
>>>>>>> [   11.412957] NET: Registered protocol family 17
>>>>>>> [   11.417507] mpls_gso: MPLS GSO support
>>>>>>> [   11.427706] mce: Using 23 MCE banks
>>>>>>> [   11.431251] microcode: CPU0: patch_level=0x08001230
>>>>>>> [   11.432265] tsc: Refined TSC clocksource calibration: 1996.245 MHz
>>>>>>> [   11.436153] microcode: CPU1: patch_level=0x08001230
>>>>>>> [   11.442473] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398ca5c3e2a, max_idle_ns: 881590548659 ns
>>>>>>> [   11.447272] microcode: CPU2: patch_level=0x08001230
>>>>>>> [   11.462140] clocksource: Switched to clocksource tsc
>>>>>>> [   11.462158] hub 1-1:1.0: USB hub found
>>>>>>> [   11.462200] microcode: CPU3: patch_level=0x08001230
>>>>>>> [   11.462224] microcode: CPU4: patch_level=0x08001230
>>>>>>> [   11.462274] microcode: CPU5: patch_level=0x08001230
>>>>>>> [   11.462298] microcode: CPU6: patch_level=0x08001230
>>>>>>> [   11.462313] microcode: CPU7: patch_level=0x08001230
>>>>>>> [   11.462329] microcode: CPU8: patch_level=0x08001230
>>>>>>> [   11.462344] microcode: CPU9: patch_level=0x08001230
>>>>>>> [   11.462360] microcode: CPU10: patch_level=0x08001230
>>>>>>> [   11.462376] microcode: CPU11: patch_level=0x08001230
>>>>>>> [   11.462393] microcode: CPU12: patch_level=0x08001230
>>>>>>> [   11.462409] microcode: CPU13: patch_level=0x08001230
>>>>>>> [   11.462424] microcode: CPU14: patch_level=0x08001230
>>>>>>> [   11.462439] microcode: CPU15: patch_level=0x08001230
>>>>>>> [   11.462451] microcode: CPU16: patch_level=0x08001230
>>>>>>> [   11.462465] microcode: CPU17: patch_level=0x08001230
>>>>>>> [   11.462477] microcode: CPU18: patch_level=0x08001230
>>>>>>> [   11.462489] microcode: CPU19: patch_level=0x08001230
>>>>>>> [   11.462502] microcode: CPU20: patch_level=0x08001230
>>>>>>> [   11.462516] microcode: CPU21: patch_level=0x08001230
>>>>>>> [   11.462529] microcode: CPU22: patch_level=0x08001230
>>>>>>> [   11.462541] microcode: CPU23: patch_level=0x08001230
>>>>>>> [   11.462225] microcode: CPU24: patch_level=0x08001230
>>>>>>> [   11.467147] microcode: CPU25: patch_level=0x08001230
>>>>>>> [   11.471130] hub 1-1:1.0: 4 ports detected
>>>>>>> [   11.475793] microcode: CPU26: patch_level=0x08001230
>>>>>>> [   11.489405] usb 2-2: new SuperSpeed Gen 1 USB device number 2 using xhci_hcd
>>>>>>> [   11.490445] microcode: CPU27: patch_level=0x08001230
>>>>>>> [   11.510511] usb 2-2: New USB device found, idVendor=0424, idProduct=5744, bcdDevice= 1.21
>>>>>>> [   11.515025] microcode: CPU28: patch_level=0x08001230
>>>>>>> [   11.519974] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=0
>>>>>>> [   11.524961] microcode: CPU29: patch_level=0x08001230
>>>>>>> [   11.529905] usb 2-2: Product: USB5734
>>>>>>> [   11.534895] microcode: CPU30: patch_level=0x08001230
>>>>>>> [   11.539848] usb 2-2: Manufacturer: Microchip Tech
>>>>>>> [   11.544833] microcode: CPU31: patch_level=0x08001230
>>>>>>> [   11.575278] hub 2-2:1.0: USB hub found
>>>>>>> [   11.579575] microcode: CPU32: patch_level=0x08001230
>>>>>>> [   11.579601] microcode: CPU33: patch_level=0x08001230
>>>>>>> [   11.584769] hub 2-2:1.0: 4 ports detected
>>>>>>> [   11.588587] microcode: CPU34: patch_level=0x08001230
>>>>>>> [   11.622250] usb 1-2: new high-speed USB device number 3 using xhci_hcd
>>>>>>> [   11.625844] microcode: CPU35: patch_level=0x08001230
>>>>>>> [   11.683278] microcode: CPU36: patch_level=0x08001230
>>>>>>> [   11.688277] microcode: CPU37: patch_level=0x08001230
>>>>>>> [   11.693268] microcode: CPU38: patch_level=0x08001230
>>>>>>> [   11.698260] microcode: CPU39: patch_level=0x08001230
>>>>>>> [   11.703254] microcode: CPU40: patch_level=0x08001230
>>>>>>> [   11.708244] microcode: CPU41: patch_level=0x08001230
>>>>>>> [   11.713235] microcode: CPU42: patch_level=0x08001230
>>>>>>> [   11.718230] microcode: CPU43: patch_level=0x08001230
>>>>>>> [   11.723220] microcode: CPU44: patch_level=0x08001230
>>>>>>> [   11.728215] microcode: CPU45: patch_level=0x08001230
>>>>>>> [   11.733215] microcode: CPU46: patch_level=0x08001230
>>>>>>> [   11.738205] microcode: CPU47: patch_level=0x08001230
>>>>>>> [   11.743191] microcode: CPU48: patch_level=0x08001230
>>>>>>> [   11.748187] microcode: CPU49: patch_level=0x08001230
>>>>>>> [   11.753180] microcode: CPU50: patch_level=0x08001230
>>>>>>> [   11.758172] microcode: CPU51: patch_level=0x08001230
>>>>>>> [   11.759131] usb 1-2: New USB device found, idVendor=0424, idProduct=2744, bcdDevice= 1.21
>>>>>>> [   11.763171] microcode: CPU52: patch_level=0x08001230
>>>>>>> [   11.771328] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>>>>>> [   11.776313] microcode: CPU53: patch_level=0x08001230
>>>>>>> [   11.783434] usb 1-2: Product: USB2734
>>>>>>> [   11.788421] microcode: CPU54: patch_level=0x08001230
>>>>>>> [   11.792072] usb 1-2: Manufacturer: Microchip Tech
>>>>>>> [   11.797060] microcode: CPU55: patch_level=0x08001230
>>>>>>> [   11.806731] microcode: CPU56: patch_level=0x08001230
>>>>>>> [   11.811726] microcode: CPU57: patch_level=0x08001230
>>>>>>> [   11.816716] microcode: CPU58: patch_level=0x08001230
>>>>>>> [   11.821708] microcode: CPU59: patch_level=0x08001230
>>>>>>> [   11.826700] microcode: CPU60: patch_level=0x08001230
>>>>>>> [   11.831694] microcode: CPU61: patch_level=0x08001230
>>>>>>> [   11.836684] microcode: CPU62: patch_level=0x08001230
>>>>>>> [   11.841677] microcode: CPU63: patch_level=0x08001230
>>>>>>> [   11.846664] microcode: CPU64: patch_level=0x08001230
>>>>>>> [   11.851662] microcode: CPU65: patch_level=0x08001230
>>>>>>> [   11.856651] microcode: CPU66: patch_level=0x08001230
>>>>>>> [   11.861644] microcode: CPU67: patch_level=0x08001230
>>>>>>> [   11.863282] hub 1-2:1.0: USB hub found
>>>>>>> [   11.866641] microcode: CPU68: patch_level=0x08001230
>>>>>>> [   11.870635] hub 1-2:1.0: 4 ports detected
>>>>>>> [   11.875367] microcode: CPU69: patch_level=0x08001230
>>>>>>> [   11.884352] microcode: CPU70: patch_level=0x08001230
>>>>>>> [   11.889345] microcode: CPU71: patch_level=0x08001230
>>>>>>> [   11.894336] microcode: CPU72: patch_level=0x08001230
>>>>>>> [   11.899328] microcode: CPU73: patch_level=0x08001230
>>>>>>> [   11.904319] microcode: CPU74: patch_level=0x08001230
>>>>>>> [   11.909308] microcode: CPU75: patch_level=0x08001230
>>>>>>> [   11.914300] microcode: CPU76: patch_level=0x08001230
>>>>>>> [   11.919292] microcode: CPU77: patch_level=0x08001230
>>>>>>> [   11.924283] microcode: CPU78: patch_level=0x08001230
>>>>>>> [   11.929275] microcode: CPU79: patch_level=0x08001230
>>>>>>> [   11.934256] microcode: CPU80: patch_level=0x08001230
>>>>>>> [   11.939253] microcode: CPU81: patch_level=0x08001230
>>>>>>> [   11.944250] microcode: CPU82: patch_level=0x08001230
>>>>>>> [   11.949245] microcode: CPU83: patch_level=0x08001230
>>>>>>> [   11.954237] microcode: CPU84: patch_level=0x08001230
>>>>>>> [   11.959229] microcode: CPU85: patch_level=0x08001230
>>>>>>> [   11.964230] microcode: CPU86: patch_level=0x08001230
>>>>>>> [   11.969222] microcode: CPU87: patch_level=0x08001230
>>>>>>> [   11.974212] microcode: CPU88: patch_level=0x08001230
>>>>>>> [   11.979206] microcode: CPU89: patch_level=0x08001230
>>>>>>> [   11.984199] microcode: CPU90: patch_level=0x08001230
>>>>>>> [   11.989190] microcode: CPU91: patch_level=0x08001230
>>>>>>> [   11.994181] microcode: CPU92: patch_level=0x08001230
>>>>>>> [   11.999172] microcode: CPU93: patch_level=0x08001230
>>>>>>> [   12.004164] microcode: CPU94: patch_level=0x08001230
>>>>>>> [   12.009158] microcode: CPU95: patch_level=0x08001230
>>>>>>> [   12.014196] microcode: Microcode Update Driver: v2.2.
>>>>>>> [   12.014217] AVX2 version of gcm_enc/dec engaged.
>>>>>>> [   12.023894] AES CTR mode by8 optimization enabled
>>>>>>> [   12.068375] sched_clock: Marking stable (9513534863, 2554828575)->(12744723501, -676360063)
>>>>>>> [   12.081379] registered taskstats version 1
>>>>>>> [   12.085508] Loading compiled-in X.509 certificates
>>>>>>> [   12.121247] Loaded X.509 cert 'Build time autogenerated kernel key: f74ccf1915f7d0151bd5bc954b9029c0d9b84393'
>>>>>>> [   12.131430] zswap: loaded using pool lzo/zbud
>>>>>>> [   12.146342] Key type big_key registered
>>>>>>> [   12.153861] Key type encrypted registered
>>>>>>> [   12.160191] integrity: Loading X.509 certificate: UEFI:db
>>>>>>> [   12.165636] integrity: Loaded X.509 cert 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988a1bd4'
>>>>>>> [   12.176411] integrity: Loading X.509 certificate: UEFI:db
>>>>>>> [   12.179233] usb 1-1.1: new high-speed USB device number 4 using xhci_hcd
>>>>>>> [   12.181832] integrity: Loaded X.509 cert 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae17c55af53'
>>>>>>> [   12.199554] integrity: Loading X.509 certificate: UEFI:db
>>>>>>> [   12.205003] integrity: Loaded X.509 cert 'VMware, Inc.: 4ad8ba0472073d28127706ddc6ccb9050441bbc7'
>>>>>>> [   12.213868] integrity: Loading X.509 certificate: UEFI:db
>>>>>>> [   12.219434] integrity: Loaded X.509 cert 'VMware, Inc.: VMware Secure Boot Signing: 04597f3e1ffb240bba0ff0f05d5eb05f3e15f6d7'
>>>>>>> [   12.232124] integrity: Loading X.509 certificate: UEFI:MokListRT
>>>>>>> [   12.238397] integrity: Loaded X.509 cert 'Red Hat Secure Boot (CA key 1): 4016841644ce3a810408050766e8f8a29c65f85c'
>>>>>>> [   12.250888] ima: No TPM chip found, activating TPM-bypass!
>>>>>>> [   12.252298] random: fast init done
>>>>>>> [   12.256395] ima: Allocated hash algorithm: sha1
>>>>>>> [   12.264329] No architecture policies found
>>>>>>> [   12.268438] evm: Initialising EVM extended attributes:
>>>>>>> [   12.272263] usb 1-1.1: New USB device found, idVendor=1604, idProduct=10c0, bcdDevice= 0.00
>>>>>>> [   12.273583] evm: security.selinux
>>>>>>> [   12.273583] evm: security.ima
>>>>>>> [   12.273584] evm: security.capability
>>>>>>> [   12.273584] evm: HMAC attrs: 0x1
>>>>>>> [   12.281959] rtc_cmos 00:01: setting system clock to 2019-06-15T00:13:31 UTC (1560557611)
>>>>>>> [   12.285275] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>>>>>> [   12.343303] hub 1-1.1:1.0: USB hub found
>>>>>>> [   12.347507] hub 1-1.1:1.0: 4 ports detected
>>>>>>> [   12.356243] Freeing unused decrypted memory: 2040K
>>>>>>> [   12.362321] Freeing unused kernel image memory: 2344K
>>>>>>> [   12.369228] Write protecting the kernel read-only data: 18432k
>>>>>>> [   12.377310] Freeing unused kernel image memory: 2012K
>>>>>>> [   12.383308] Freeing unused kernel image memory: 272K
>>>>>>> [   12.388284] Run /init as init process
>>>>>>> [   12.417444] usb 1-1.3: new high-speed USB device number 5 using xhci_hcd
>>>>>>> [   12.535833] usb 1-1.3: New USB device found, idVendor=413c, idProduct=a102, bcdDevice= 4.01
>>>>>>> [   12.565489] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>>>>>> [   12.591648] usb 1-1.3: Product: iDRAC Virtual NIC USB Device
>>>>>>> [   12.611366] usb 1-1.3: Manufacturer: Dell(TM)
>>>>>>> [   12.732299] usb 1-1.4: new high-speed USB device number 6 using xhci_hcd
>>>>>>> [   12.815710] systemd[1]: systemd 239 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
>>>>>>> [   12.835263] usb 1-1.4: New USB device found, idVendor=1604, idProduct=10c0, bcdDevice= 0.00
>>>>>>> [   12.845320] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>>>>>> [   12.859341] systemd[1]: Detected architecture x86-64.
>>>>>>> [   12.864405] systemd[1]: Running in initial RAM disk.
>>>>>>> [   12.887436] hub 1-1.4:1.0: USB hub found
>>>>>>> [   12.892046] hub 1-1.4:1.0: 4 ports detected
>>>>>>>
>>>>>>> Welcome to Red Hat Enterprise Linux 8.1 Beta (Ootpa) dracut-049-12.git20190604.el8 (Initramfs)!
>>>>>>>
>>>>>>> [   12.953297] systemd[1]: Set hostname to <dell-per7425-02.khw.lab.eng.bos.redhat.com>.
>>>>>>> [   13.019978] random: systemd: uninitialized urandom read (16 bytes read)
>>>>>>> [   13.053873] systemd[1]: Created slice system-systemd\x2dhibernate\x2dresume.slice.
>>>>>>> [  OK  ] Created slice system-systemd\x2dhibernate\x2dresume.slice.
>>>>>>> [   13.069277] random: systemd: uninitialized urandom read (16 bytes read)
>>>>>>> [   13.075906] systemd[1]: Reached target Timers.
>>>>>>> [  OK  ] Reached target Timers.
>>>>>>> [   13.085249] random: systemd: uninitialized urandom read (16 bytes read)
>>>>>>> [   13.091963] systemd[1]: Listening on Journal Socket.
>>>>>>> [  OK  ] Listening on Journal Socket.
>>>>>>> [   13.104162] systemd[1]: Starting Setup Virtual Console...
>>>>>>>            Starting Setup Virtual Console...
>>>>>>> [   13.115307] systemd[1]: Reached target Swap.
>>>>>>> [  OK  ] Reached target Swap.
>>>>>>> [   13.138367] systemd[1]: Listening on udev Control Socket.
>>>>>>> [  OK  ] Listening on udev Control Socket.
>>>>>>> [  OK  ] Reached target Slices.
>>>>>>>            Starting Create list of required st…ce nodes for the current kernel...
>>>>>>>            Starting Apply Kernel Variables...
>>>>>>> [  OK  ] Listening on Journal Socket (/dev/log).
>>>>>>>            Starting Journal Service...
>>>>>>> [  OK  ] Listening on udev Kernel Socket.
>>>>>>> [  OK  ] Reached target Sockets.
>>>>>>> [  OK  ] Started Setup Virtual Console.
>>>>>>> [  OK  ] Started Create list of required sta…vice nodes for the current kernel.
>>>>>>> [  OK  ] Started Apply Kernel Variables.
>>>>>>>            Starting Create Static Device Nodes in /dev...
>>>>>>>            Starting dracut cmdline hook...
>>>>>>> [  OK  ] Started Create Static Device Nodes in /dev.
>>>>>>> [  OK  ] Started dracut cmdline hook.
>>>>>>>            Starting dracut pre-udev hook...
>>>>>>> [   13.364623] device-mapper: uevent: version 1.0.3
>>>>>>> [   13.369367] device-mapper: ioctl: 4.40.0-ioctl (2019-01-18) initialised: dm-devel@redhat.com
>>>>>>> [  OK  ] Started dracut pre-udev hook.
>>>>>>>            Starting udev Kernel Device Manager...
>>>>>>> [  OK  ] Started Journal Service.
>>>>>>> [  OK  ] Started udev Kernel Device Manager.
>>>>>>>            Starting udev Coldplug all Devices...
>>>>>>>            Mounting Kernel Configuration File System...
>>>>>>> [  OK  ] Mounted Kernel Configuration File System.
>>>>>>> [  OK  ] Started udev Coldplug all De[   13.849742] dca service started, version 1.12.1
>>>>>>> vices.
>>>>>>> [   13.866084] i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.8.20-k
>>>>>>> [   13.874115] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
>>>>>>> [   13.875358] megasas: 07.707.51.00-rc1
>>>>>>> [   13.884845] megaraid_sas 0000:61:00.0: FW now in Ready state
>>>>>>> [   13.890574] megaraid_sas 0000:61:00.0: 63 bit DMA mask and 63 bit consistent mask
>>>>>>> [   13.893836] i40e 0000:01:00.0: fw 6.81.49447 api 1.7 nvm 6.80 0x80003d71 18.8.9 [8086:1572] [1028:1f99]
>>>>>>> [   13.894895] megaraid_sas 0000:61:00.0: firmware supports msix	: (128)
>>>>>>> [   13.894897] megaraid_sas 0000:61:00.0: current msix/online cpus	: (96/96)
>>>>>>> [   13.894899] megaraid_sas 0000:61:00.0: RDPQ mode	: (enabled)
>>>>>>> [   13.894902] megaraid_sas 0000:61:00.0: Current firmware supports maximum commands: 4077	 LDIO threshold: 0
>>>>>>>            Startin[   13.897599] megaraid_sas 0000:61:00.0: Configured max firmware commands: 4076
>>>>>>> g Show Plymouth [   13.914905] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.6.0-k
>>>>>>> [   13.925768] megaraid_sas 0000:61:00.0: FW supports sync cache	: Yes
>>>>>>>
>>>>>>>            Starti[   13.926577] igb: Copyright (c) 2007-2014 Intel Corporation.
>>>>>>> ng dracut initqueue hook...
>>>>>>> [  OK  ] Started Show Plymouth Boot Screen.
>>>>>>> [  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
>>>>>>> [  OK  ] Reached target Paths.
>>>>>>> [   14.029370] i40e 0000:01:00.0: MAC address: 24:6e:96:ad:1c:1a
>>>>>>> [   14.065643] ahci 0000:06:00.2: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
>>>>>>> [   14.073832] ahci 0000:06:00.2: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part
>>>>>>> [   14.104181] i40e 0000:01:00.0: PCI-Express: Speed 8.0GT/s Width x8
>>>>>>> [   14.118557] scsi host1: ahci
>>>>>>> [   14.123407] ata1: SATA max UDMA/133 abar m4096@0xf9a02000 port 0xf9a02100 irq 301
>>>>>>> [   14.148411] i40e 0000:01:00.0: Features: PF-id[0] VFs: 64 VSIs: 2 QP: 96 RSS FD_ATR FD_SB NTUPLE DCB VxLAN Geneve PTP VEPA
>>>>>>> [   14.168364] mgag200 0000:03:00.0: remove_conflicting_pci_framebuffers: bar 0: 0xeb000000 -> 0xebffffff
>>>>>>> [   14.177686] mgag200 0000:03:00.0: remove_conflicting_pci_framebuffers: bar 1: 0xf9808000 -> 0xf980bfff
>>>>>>> [   14.187123] mgag200 0000:03:00.0: remove_conflicting_pci_framebuffers: bar 2: 0xf9000000 -> 0xf97fffff
>>>>>>> [   14.196961] fb0: switching to mgag200drmfb from EFI VGA
>>>>>>> [   14.202532] igb 0000:04:00.0: added PHC on eth1
>>>>>>> [   14.202536] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
>>>>>>> [   14.214503] igb 0000:04:00.0: eth1: (PCIe:5.0Gb/s:Width x2) 24:6e:96:ad:1c:3a
>>>>>>> [   14.214796] igb 0000:04:00.0: eth1: PBA No: H39167-011
>>>>>>> [   14.227322] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>>>>>>> [   14.236433] Console: switching to colour dummy device 80x25
>>>>>>> [   14.242984] mgag200 0000:03:00.0: vgaarb: deactivate vga console
>>>>>>> [   14.254389] i40e 0000:01:00.1: fw 6.81.49447 api 1.7 nvm 6.80 0x80003d71 18.8.9 [8086:1572] [1028:0000]
>>>>>>> [   14.273233] [TTM] Zone  kernel: Available graphics memory: 32803830 KiB
>>>>>>> [   14.279871] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB
>>>>>>> [   14.286410] [TTM] Initializing pool allocator
>>>>>>> [   14.371752] [TTM] Initializing DMA pool allocator
>>>>>>> [   14.390001] i40e 0000:01:00.1: MAC address: 24:6e:96:ad:1c:1c
>>>>>>> [   14.396364] igb 0000:04:00.1: added PHC on eth2
>>>>>>> [   14.400906] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
>>>>>>> [   14.407788] igb 0000:04:00.1: eth2: (PCIe:5.0Gb/s:Width x2) 24:6e:96:ad:1c:3b
>>>>>>> [   14.415211] igb 0000:04:00.1: eth2: PBA No: H39167-011
>>>>>>> [   14.420363] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>>>>>>> [   14.429592] fbcon: mgag200drmfb (fb0) is primary device
>>>>>>> [   14.429663] Console: switching to colour frame buffer device 128x48
>>>>>>> [   14.437757] ata1: SATA link down (SStatus 0 SControl 300)
>>>>>>> [   14.751995] igb 0000:04:00.1 eno4: renamed from eth2
>>>>>>> [   14.777068] i40e 0000:01:00.1: PCI-Express: Speed 8.0GT/s Width x8
>>>>>>> [   14.786200] i40e 0000:01:00.1: Features: PF-id[1] VFs: 64 VSIs: 2 QP: 96 RSS FD_ATR FD_SB NTUPLE DCB VxLAN Geneve PTP VEPA
>>>>>>> [   14.790205] i40e 0000:01:00.1 eno2: renamed from eth3
>>>>>>> [   14.814571] i40e 0000:01:00.0 eno1: renamed from eth0
>>>>>>> [   14.831951] igb 0000:04:00.0 eno3: renamed from eth1
>>>>>>> [   14.900866] mgag200 0000:03:00.0: fb0: mgag200drmfb frame buffer device
>>>>>>> [   14.920279] [drm] Initialized mgag200 1.0.0 20110418 for 0000:03:00.0 on minor 0
>>>>>>> [ TIME ] Timed out waiting for device dev-ma…dper7425\x2d\x2d02\x2dswap.device.
>>>>>>> [DEPEND] Dependency failed for Resume from h…apper/rhel_dell--per7425--02-swap.
>>>>>>> [  OK  ] Reached target Local File Systems (Pre).
>>>>>>> [  OK  ] Reached target Local File Systems.
>>>>>>>            Starting Create Volatile Files and Directories...
>>>>>>> [  OK  ] Started Create Volatile Files and Directories.
>>>>>>> [  OK  ] Reached target System Initialization.
>>>>>>> [  OK  ] Reached target Basic System.
>>>>>>> [  211.950273] megaraid_sas 0000:61:00.0: Init cmd return status FAILED for SCSI host 0
>>>>>>> [  211.982750] megaraid_sas 0000:61:00.0: Failed from megasas_init_fw 5900
>>>>>>> [  335.300030] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  335.829702] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  336.350782] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  336.871598] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  337.392804] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  337.911627] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  338.432826] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  338.953664] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  339.474753] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  339.994651] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  340.516794] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  341.036653] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  341.557814] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  342.078594] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  342.598790] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  343.118630] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  343.638773] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  344.159833] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  344.682015] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  345.203808] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  345.725824] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  346.246877] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  346.768049] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  347.288906] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  347.810004] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  348.330743] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  348.852003] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  349.373837] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  349.895019] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  350.416807] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  350.938954] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  351.461819] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  351.982826] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  352.503629] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  353.024841] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  353.546801] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  354.068955] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  354.588695] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  355.108779] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  355.629602] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  356.149768] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  356.669659] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  357.190781] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  357.712677] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  358.233818] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  358.754667] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  359.279949] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  359.800700] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  360.321830] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  360.842697] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  361.363798] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  361.883666] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  362.403822] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  362.923656] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  363.444796] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  363.964617] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  364.484843] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  365.005671] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  365.526822] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  366.047628] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  366.567768] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  367.088617] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  367.608834] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  368.129669] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  368.650853] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  369.171704] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  369.692800] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  370.211609] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  370.731743] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  371.252651] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  371.772767] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  372.293677] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  372.815786] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  373.336682] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  373.857803] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  374.378712] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  374.899858] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  375.420617] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  375.941775] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  376.461645] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  376.982085] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  377.501934] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  378.025016] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  378.546902] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  379.066668] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  379.586660] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  380.107731] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  380.626853] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  381.148000] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  381.667787] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  382.188784] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  382.708818] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  383.230966] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  383.752793] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  384.274826] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  384.796776] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  385.319021] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  385.838833] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  386.358810] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  386.878655] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  387.398832] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  387.919664] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  388.440793] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  388.961607] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  389.481803] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  390.003632] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  390.523771] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  391.043627] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  391.564829] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  392.085687] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  392.605781] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  393.126625] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  393.646799] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  394.167611] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  394.687773] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  395.207595] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  395.727829] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  396.248653] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  396.769811] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  397.290615] dracut-initqueue[1097]: Warning: dracut-initqueue timeout - starting timeout scripts
>>>>>>> [  397.290708] dracut-initqueue[1097]: Warning: Could not boot.
>>>>>>>            Starting Setup Virtual Console...
>>>>>>> [  OK  ] Started Setup Virtual Console.
>>>>>>>            Starting Dracut Emergency Shell...
>>>>>>> Warning: /dev/mapper/rhel_dell--per7425--02-root does not exist
>>>>>>> Warning: /dev/rhel_dell-per7425-02/root does not exist
>>>>>>> Warning: /dev/rhel_dell-per7425-02/swap does not exist
>>>>>>>
>>>>>>> Generating "/run/initramfs/rdsosreport.txt"
>>>>>>>
>>>>>>>
>>>>>>> Entering emergency mode. Exit the shell to continue.
>>>>>>> Type "journalctl" to view system logs.
>>>>>>> You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick or /boot
>>>>>>> after mounting them and attach it to a bug report.
>>>>>>>
>>>>>>>
>>>>>>> dracut:/#
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> [root@dell-per7425-02 ~]# uname -r
>>>>>>> 5.2.0-rc4+
>>>>>>>
>>>>>>> [root@dell-per7425-02 ~]# lspci
>>>>>>> 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> 00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> 00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) PCIe GPP Bridge
>>>>>>> 00:01.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) PCIe GPP Bridge
>>>>>>> 00:01.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) PCIe GPP Bridge
>>>>>>> 00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 59)
>>>>>>> 00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 51)
>>>>>>> 00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:19.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:19.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:19.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:19.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:19.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:19.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:19.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:19.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1a.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1a.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1a.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1a.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1a.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1a.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1a.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1a.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1b.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1b.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1b.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1b.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1b.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1b.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1b.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1b.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1c.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1c.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1c.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1c.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1c.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1c.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1c.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1c.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1d.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1d.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1d.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1d.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1d.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1d.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1d.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1d.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1e.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1e.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1e.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1e.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1e.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1e.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1e.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1e.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 00:1f.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 0
>>>>>>> 00:1f.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 1
>>>>>>> 00:1f.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 2
>>>>>>> 00:1f.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 3
>>>>>>> 00:1f.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 4
>>>>>>> 00:1f.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 5
>>>>>>> 00:1f.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 6
>>>>>>> 00:1f.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Data Fabric: Device 18h; Function 7
>>>>>>> 01:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
>>>>>>> 01:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for 10GbE SFP+ (rev 01)
>>>>>>> 02:00.0 PCI bridge: PLDA Device be00 (rev 02)
>>>>>>> 03:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. Integrated Matrox G200eW3 Graphics Controller (rev 04)
>>>>>>> 04:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
>>>>>>> 04:00.1 Ethernet controller: Intel Corporation I350 Gigabit Network Connection (rev 01)
>>>>>>> 05:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> 05:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> 05:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Zeppelin USB 3.0 Host controller
>>>>>>> 06:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> 06:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> 06:00.2 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode] (rev 51)
>>>>>>> 20:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> 20:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> 20:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 20:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 20:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 21:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> 21:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> 21:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Zeppelin USB 3.0 Host controller
>>>>>>> 22:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> 22:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> 40:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> 40:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> 40:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 40:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 40:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 41:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> 41:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> 42:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> 42:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> 60:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> 60:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> 60:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:03.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) PCIe GPP Bridge
>>>>>>> 60:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 60:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 60:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 61:00.0 RAID bus controller: Broadcom / LSI MegaRAID Tri-Mode SAS3508 (rev 01)
>>>>>>> 62:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> 62:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> 63:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> 63:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> 80:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> 80:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> 80:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 80:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> 80:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> 81:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> 81:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> 82:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> 82:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> a0:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> a0:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> a0:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> a0:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> a0:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> a1:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> a1:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> a2:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> a2:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> c0:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> c0:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> c0:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> c0:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> c0:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> c1:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> c1:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> c2:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> c2:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>> e0:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Root Complex
>>>>>>> e0:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) I/O Memory Management Unit
>>>>>>> e0:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> e0:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
>>>>>>> e0:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B
>>>>>>> e1:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function
>>>>>>> e1:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 00h-0fh) Platform Security Processor
>>>>>>> e2:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Renoir PCIe Dummy Function
>>>>>>> e2:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Zeppelin Cryptographic Coprocessor NTBCCP
>>>>>>>
>>>>>>> [root@dell-per7425-02 ~]# cat /proc/cpuinfo
>>>>>>> ......
>>>>>>> processor	: 95
>>>>>>> vendor_id	: AuthenticAMD
>>>>>>> cpu family	: 23
>>>>>>> model		: 1
>>>>>>> model name	: AMD EPYC 7401 24-Core Processor
>>>>>>> stepping	: 2
>>>>>>> microcode	: 0x8001230
>>>>>>> cpu MHz		: 2339.896
>>>>>>> cache size	: 512 KB
>>>>>>> physical id	: 1
>>>>>>> siblings	: 48
>>>>>>> core id		: 30
>>>>>>> cpu cores	: 24
>>>>>>> apicid		: 125
>>>>>>> initial apicid	: 125
>>>>>>> fpu		: yes
>>>>>>> fpu_exception	: yes
>>>>>>> cpuid level	: 13
>>>>>>> wp		: yes
>>>>>>> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid amd_dcm aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb hw_pstate sme ssbd sev ibpb vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif overflow_recov succor smca
>>>>>>> bugs		: sysret_ss_attrs null_seg spectre_v1 spectre_v2 spec_store_bypass
>>>>>>> bogomips	: 3981.31
>>>>>>> TLB size	: 2560 4K pages
>>>>>>> clflush size	: 64
>>>>>>> cache_alignment	: 64
>>>>>>> address sizes	: 43 bits physical, 48 bits virtual
>>>>>>> power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]
>>>>>>>
