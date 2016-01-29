From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 17:32:54 -0600
Message-ID: <56ABF6A6.8070506@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/> <56AAC605.1080707@cs.wisc.edu> <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com> <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu> <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com> <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu> <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com> <56ABBCFF.9060003@cs.wisc.edu> <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53685 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbcA2Xdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 18:33:33 -0500
In-Reply-To: <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> HI Mike,
> 
> I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
> 

That is sort of expected. Your target is not setup for ALUA properly. It
says it supports ALUA, but when scsi_dh_alua asks about the ports it is
reporting there are none. Ccing the people that made the patch that
added the issue and own the code.

Hey Christoph and Hannes,

The dh/alua changes that added this:

        error = scsi_dh_add_device(sdev);
        if (error) {
                sdev_printk(KERN_INFO, sdev,
                                "failed to add device handler: %d\n",
error);
                return error;
        }

to scsi_sysfs_add_sdev are adding a regression.

1. If that fails, then we forget to do device_del before doing the
return. My patch in this thread added that back, so we do not see the
sysfs oopses anymore. But.....

2. It looks like in older kernels, we would allow misconfigured targets
like this one to still setup devices. Do we want that old behavior back?
Should we just ignore the return value from scsi_dh_add_device above?
Note that in this case, it is LIO so it can be easily fixed on the
target side by just setting it up properly. I do not think other targets
would hit this type of issue.





> 
> Here is dmesg
> 
> [   26.103812] scsi 3:0:0:2: Direct-Access     LIO-ORG  san-disk-2       4.0  PQ: 0 ANSI: 5
> [   26.104338] sd 3:0:0:2: alua: supports implicit and explicit TPGS
> [   26.104549] sd 3:0:0:2: alua: No target port descriptors found
> [   26.104552] sd 3:0:0:2: alua: Attach failed (-22)
> [   26.104554] sd 3:0:0:2: failed to add device handler: -22
> [   26.104578] sd 3:0:0:2: [sdc] 20507809792 512-byte logical blocks: (10.4 TB/9.54 TiB)
> [   26.104905] sd 3:0:0:2: [sdc] Write Protect is off
> [   26.104908] sd 3:0:0:2: [sdc] Mode Sense: 43 00 10 08
> [   26.105036] sd 3:0:0:2: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   26.112294] scsi host6: iSCSI Initiator over TCP/IP
> [   26.113279] scsi 4:0:0:3: Direct-Access     LIO-ORG  san-disk-3       4.0  PQ: 0 ANSI: 5
> [   26.113690] sd 4:0:0:3: alua: supports implicit and explicit TPGS
> [   26.113877] sd 4:0:0:3: [sdd] 9765625856 512-byte logical blocks: (5.00 TB/4.54 TiB)
> [   26.113948] sd 4:0:0:3: alua: No target port descriptors found
> [   26.113951] sd 4:0:0:3: alua: Attach failed (-22)
> [   26.113953] sd 4:0:0:3: failed to add device handler: -22
> [   26.114292] sd 4:0:0:3: [sdd] Write Protect is off
> [   26.114295] sd 4:0:0:3: [sdd] Mode Sense: 43 00 10 08
> [   26.114503] sd 4:0:0:3: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   26.123875] scsi 5:0:0:1: Direct-Access     LIO-ORG  san-disk-1       4.0  PQ: 0 ANSI: 5
> [   26.123911] scsi 6:0:0:4: Direct-Access     LIO-ORG  san-disk-4       4.0  PQ: 0 ANSI: 5
> [   26.124452] sd 6:0:0:4: alua: supports implicit and explicit TPGS
> [   26.124453] sd 5:0:0:1: alua: supports implicit and explicit TPGS
> [   26.124724] sd 5:0:0:1: alua: No target port descriptors found
> [   26.124727] sd 5:0:0:1: alua: Attach failed (-22)
> [   26.124728] sd 5:0:0:1: failed to add device handler: -22
> [   26.124736] sd 6:0:0:4: [sde] 10742171648 512-byte logical blocks: (5.49 TB/5.00 TiB)
> [   26.124773] sd 5:0:0:1: [sdf] 7812499389 512-byte logical blocks: (3.99 TB/3.63 TiB)
> [   26.124777] sd 6:0:0:4: alua: No target port descriptors found
> [   26.124779] sd 6:0:0:4: alua: Attach failed (-22)
> [   26.124780] sd 6:0:0:4: failed to add device handler: -22
> [   26.125182] sd 5:0:0:1: [sdf] Write Protect is off
> [   26.125184] sd 5:0:0:1: [sdf] Mode Sense: 43 00 10 08
> [   26.125217] sd 6:0:0:4: [sde] Write Protect is off
> [   26.125220] sd 6:0:0:4: [sde] Mode Sense: 43 00 10 08
> [   26.125306] sd 5:0:0:1: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   26.125512] sd 6:0:0:4: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   26.129633]  sdf: sdf1
> [   26.130637] sd 5:0:0:1: [sdf] Attached SCSI disk
> [   26.144377] ixgbe 0000:04:00.0: registered PHC device on enp4s0f0
> [   26.149072]  sdc: sdc1
> [   26.150434] sd 3:0:0:2: [sdc] Attached SCSI disk
> [   26.190709]  sdd: sdd1 sdd2
> [   26.193348] sd 4:0:0:3: [sdd] Attached SCSI disk
> [   26.230515]  sde: sde1
> [   26.231674] sd 6:0:0:4: [sde] Attached SCSI disk
> [   26.231987] sd 6:0:0:4: [sde] Synchronizing SCSI cache
> [   26.232021] sd 5:0:0:1: [sdf] Synchronizing SCSI cache
> [   26.233212] sd 3:0:0:2: [sdc] Synchronizing SCSI cache
> [   26.233440] sd 4:0:0:3: [sdd] Synchronizing SCSI cache
> [   26.236755] Buffer I/O error on dev sdc, logical block 2563476132, async page read
> [   26.238897] Buffer I/O error on dev sdd, logical block 1220703182, async page read
> [   26.245773] ixgbe 0000:04:00.1: SR-IOV enabled with 8 VFs
> [   26.245775] ixgbe 0000:04:00.1: configure port vlans to keep your VFs secure
> [   26.274544] scsi 6:0:0:0: Unexpected response from lun 4 while scanning, scan aborted
> [   26.283173] scsi 3:0:0:0: Unexpected response from lun 2 while scanning, scan aborted
> [   26.288571] scsi 4:0:0:0: Unexpected response from lun 3 while scanning, scan aborted
> [   26.288618] scsi 5:0:0:0: Unexpected response from lun 1 while scanning, scan aborted
> 
> 
> Second traceback is gone too, but still no luck attaching local iscsi targets either.
> 
> 
> [  639.148875] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does not match SCSI CDB Length: 8 for SAM Opcode: 0x12
> [  639.148911] sd 7:0:0:0: [sdc] 115343360 512-byte logical blocks: (59.0 GB/55.0 GiB)
> [  639.148925] sd 7:0:0:0: alua: No target port descriptors found
> [  639.148928] sd 7:0:0:0: alua: Attach failed (-22)
> [  639.149186] sd 7:0:0:0: [sdc] Write Protect is off
> [  639.149188] sd 7:0:0:0: [sdc] Mode Sense: 43 00 10 08
> [  639.149279] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [  639.149298] iSCSI/iqn.1994-05.com.redhat:cf7f1fafca4b: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
> [  639.149530] sd 7:0:0:0: failed to add device handler: -22
> [  639.154762] sd 7:0:0:0: [sdc] Attached SCSI disk
> [  639.154857] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> [  655.279047] scsi 7:0:0:0: Direct-Access     LIO-ORG  IBLOCK           4.0  PQ: 0 ANSI: 5
> [  655.279397] sd 7:0:0:0: alua: supports implicit and explicit TPGS
> [  655.279503] TARGET_CORE[iSCSI]: Expected Transfer Length: 264 does not match SCSI CDB Length: 8 for SAM Opcode: 0x12
> [  655.279533] sd 7:0:0:0: alua: No target port descriptors found
> [  655.279535] sd 7:0:0:0: alua: Attach failed (-22)
> [  655.279587] sd 7:0:0:0: [sdc] 115343360 512-byte logical blocks: (59.0 GB/55.0 GiB)
> [  655.279848] sd 7:0:0:0: [sdc] Write Protect is off
> [  655.279849] sd 7:0:0:0: [sdc] Mode Sense: 43 00 10 08
> [  655.279981] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [  655.280034] iSCSI/iqn.1994-05.com.redhat:cf7f1fafca4b: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
> [  655.280171] sd 7:0:0:0: failed to add device handler: -22
> [  655.286008] sd 7:0:0:0: [sdc] Attached SCSI disk
> [  655.286132] sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> 
> 
> Serguei Bezverkhi,
> TECHNICAL LEADER.SERVICES
> Global SP Services
> sbezverk@cisco.com
> Phone: +1 416 306 7312
> Mobile: +1 514 234 7374
> 
> CCIE (R&S,SP,Sec) - #9527
> 
> Cisco.com
> 
> 
> 
>  Think before you print.
> This email may contain confidential and privileged material for the sole use of the intended recipient. Any review, use, distribution or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive for the recipient), please contact the sender by reply email and delete all copies of this message.
> Please click here for Company Registration Information.
> 
> 
> 
> 
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Friday, January 29, 2016 2:27 PM
> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
> 
> 
> 
> On 01/29/2016 01:11 PM, Serguei Bezverkhi (sbezverk) wrote:
>> If you send me the diff for your patch, I will build new kernel myself.
>>
> 
> Bugzilla must be messing something up. I attached to one of the previous mails. Attaching it here again.
> 
> Email me offlist and without bugzilla if you do not get it here.
> 
> The patch will fix the syfs bug ons you are hitting.
> 
> I am not sure if it will fix the genhd one. We can deal with that one next if it is a different issue.
> 
> 
>> Serguei
>>
>>
>> Serguei Bezverkhi,
>> TECHNICAL LEADER.SERVICES
>> Global SP Services
>> sbezverk@cisco.com
>> Phone: +1 416 306 7312
>> Mobile: +1 514 234 7374
>>
>> CCIE (R&S,SP,Sec) - #9527
>>
>> Cisco.com
>>
>>
>>
>>  Think before you print.
>> This email may contain confidential and privileged material for the sole use of the intended recipient. Any review, use, distribution or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive for the recipient), please contact the sender by reply email and delete all copies of this message.
>> Please click here for Company Registration Information.
>>
>>
>>
>>
>> -----Original Message-----
>> From: Michael Christie [mailto:michaelc@cs.wisc.edu]
>> Sent: Friday, January 29, 2016 2:09 PM
>> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
>> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
>> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
>>
>>
>>> On Jan 29, 2016, at 6:04 AM, Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
>>>
>>> Actually this server uses both cases: Local taregts (since it is OpenStack server) and remote targets as it tries to mount 4 remotefile systems.  
>>>
>>> You are correct, I always use the same box I just change the kernel it is using to boot. No other changes to the environment. I do not mind to load a test kernel without that suspected patch, just get me the RPM.
>>>
>>
>> I do not know what you mean. I think the patch I sent will fix the sysfs errors caused due to alua not being setup properly on your system and scsi_dh_alua failing to attach. That patch should be applied to the 4.4 upstream kernel. Are you saying you want me to make you a kernel rpm?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
>> in the body of a message to majordomo@vger.kernel.org More majordomo 
>> info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

