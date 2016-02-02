From: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Subject: RE: [Bug 111441] New: iscsi fails to attach to targets
Date: Tue, 2 Feb 2016 16:41:26 +0000
Message-ID: <45d71a40bde741e38cd0dd633833311b@XCH-ALN-006.cisco.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
 <56ABBCFF.9060003@cs.wisc.edu>
 <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
 <56ABF6A6.8070506@cs.wisc.edu>
 <1454139533.12686.3.camel@haakon3.risingtidesystems.com>
 <56AF8DEC.5000002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:39162 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbcBBQla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 11:41:30 -0500
In-Reply-To: <56AF8DEC.5000002@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Hello,

Any chance we could move forward with this investigation? I still cannot attach to any remove iscsi targets with either 4.4.0 or 4.4.1 kernels.

Thank you

Serguei


 

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Monday, February 01, 2016 11:55 AM
To: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>; bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 01/30/2016 01:38 AM, Nicholas A. Bellinger wrote:
> On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:
>> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
>>> HI Mike,
>>>
>>> I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
>>>
>>
>> That is sort of expected. Your target is not setup for ALUA properly. 
>> It says it supports ALUA, but when scsi_dh_alua asks about the ports 
>> it is reporting there are none. Ccing the people that made the patch 
>> that added the issue and own the code.
>>
>> Hey Christoph and Hannes,
>>
>> The dh/alua changes that added this:
>>
>>         error = scsi_dh_add_device(sdev);
>>         if (error) {
>>                 sdev_printk(KERN_INFO, sdev,
>>                                 "failed to add device handler: %d\n", 
>> error);
>>                 return error;
>>         }
>>
>> to scsi_sysfs_add_sdev are adding a regression.
>>
>> 1. If that fails, then we forget to do device_del before doing the 
>> return. My patch in this thread added that back, so we do not see the 
>> sysfs oopses anymore. But.....
>>
>> 2. It looks like in older kernels, we would allow misconfigured 
>> targets like this one to still setup devices. Do we want that old behavior back?
>> Should we just ignore the return value from scsi_dh_add_device above?
>> Note that in this case, it is LIO so it can be easily fixed on the 
>> target side by just setting it up properly. I do not think other 
>> targets would hit this type of issue.
>>
> 
> Btw, what does misconfigured mean here wrt target ALUA..?

[   25.833195] sd 6:0:0:4: alua: supports implicit and explicit TPGS
[   25.833360] sd 6:0:0:4: alua: No target port descriptors found
[   25.833363] sd 6:0:0:4: alua: Attach failed (-22)
[   25.833365] sd 6:0:0:4: failed to add device handler: -22

He has LIO configured to report it supports implicit/explicit ALUA, but the ports do not seem to be configured.

For the LIO config side, are his LUNs just not in a the default_lu_gp or any other group?
