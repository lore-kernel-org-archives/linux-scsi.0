From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 17:37:15 +0530
Message-ID: <585A7073.3060904@caviumnetworks.com>
References: <585A69E6.6040009@caviumnetworks.com>
 <1482320547.7638.7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0080.outbound.protection.outlook.com ([104.47.42.80]:63168
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753384AbcLUOlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 09:41:42 -0500
In-Reply-To: <1482320547.7638.7.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: hdegoede@redhat.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org



On 12/21/2016 05:12 PM, Oliver Neukum wrote:
> On Wed, 2016-12-21 at 17:09 +0530, George Cherian wrote:
>> Hi Oliver,
>>
>> I was working with this JMicron device and using the uas driver.
>> I am seeing the following 2 issues.
>>
>> 1) On connect I see the following messages.
>
> Thanks. Do you want to submit it to Greg?
> The patch is fine.
Yes please!!!

>
>> 2) On disconnect I am seeing the following issue
>>
>>    scsi host4: uas_post_reset: alloc streams error -19 after reset
>>    sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>>
>> This is more fatal because after these messages the USB port becomes
>> unusable. Even an lsusb invocation hangs for ever.
>
> Ouch. That points to a logic error. We should not reset if
> a device is gone.
> Could you send dmesg of such a case?
here is the dmesg!!
[  203.475382] usb 4-1.3: new SuperSpeed USB device number 3 using xhci_hcd
[  203.496172] usb 4-1.3: New USB device found, idVendor=152d, 
idProduct=9561
[  203.503037] usb 4-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=5
[  203.510352] usb 4-1.3: Product: JMS56x Series
[  203.514698] usb 4-1.3: Manufacturer: JMicron
[  203.518966] usb 4-1.3: SerialNumber: 00000000000000000000
[  203.594383] usbcore: registered new interface driver usb-storage
[  203.612425] scsi host4: uas
[  203.615418] usbcore: registered new interface driver uas
[  203.620979] scsi 4:0:0:0: Direct-Access     ST4000NM 0033-9ZM170 
  0001 PQ: 0 ANSI: 6
[  203.630240] sd 4:0:0:0: Attached scsi generic sg1 type 0
[  203.630382] sd 4:0:0:0: [sdb] 7814037168 512-byte logical blocks: 
(4.00 TB/3.63 TiB)
[  203.631338] sd 4:0:0:0: [sdb] Write Protect is off
[  203.631342] sd 4:0:0:0: [sdb] Mode Sense: 67 00 10 08
[  203.631734] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[  203.631899] xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled 
endpoint or incorrect stream ring
[  203.631904] xhci_hcd 0000:00:11.0: @0000001f610a1c10 00000000 
00000000 1b000000 03078001 state 14 ep_info 9403
[  203.631906] xhci_hcd 0000:00:11.0: No epring
[  203.674546]  sdb: sdb1
[  203.676639] sd 4:0:0:0: [sdb] Attached SCSI disk
[  213.222913] scsi host4: uas_post_reset: alloc streams error -19 after 
reset
[  213.230548] sd 4:0:0:0: [sdb] Synchronizing SCSI cache

Above is the dmesg without the unusual_uas patch applied.
Do you need me to enable any specific dev_dbg and then the dmesg output?

>
> 	Regards
> 		Oliver
>
>
