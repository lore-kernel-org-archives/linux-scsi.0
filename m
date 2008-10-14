From: Vlad Seliverstov <vseliverstov@yandex-team.ru>
Subject: Re: [Bug 11619] New: Hotplug doesn't work with SAS1064
Date: Tue, 14 Oct 2008 17:11:19 +0400
Message-ID: <48F49A77.6030804@yandex-team.ru>
References: <bug-11619-11613@http.bugzilla.kernel.org/> <20080922161028.d519bffd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavolo.yandex.ru ([87.250.244.45]:54960 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYJNNLp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 09:11:45 -0400
In-Reply-To: <20080922161028.d519bffd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>

Can I request progress status of this bug? I have more than 100 boxes with this controller, and I can't change faulty hard drives without reboot. And I can't use 2.6.20 on them too. :(

Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Mon, 22 Sep 2008 02:49:03 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=11619
>>
>>            Summary: Hotplug doesn't work with SAS1064
>>            Product: IO/Storage
>>            Version: 2.5
>>      KernelVersion: 2.6.27-rc6
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: high
>>           Priority: P1
>>          Component: SCSI
>>         AssignedTo: linux-scsi@vger.kernel.org
>>         ReportedBy: vseliverstov@yandex-team.ru
>>
>>
>> Latest working kernel version: 2.6.20
>> Earliest failing kernel version: 2.6.22
>> Hardware Environment: Any Intel-powered server with SAS1064 PCI-X SAS
>> controller
>> Problem Description: I have linux-box with SAS1064 PCI-X SAS Controller, and
>> I'm experiencing problems with hotswapping. When I detach disk from system,
>> replace it with another one, and trying to attach it again, nothing happens.
>> After reboot, it's OK - I have this disk attached and functioning. Interesting,
>> that if I try to attach old disk just after detaching it's OK too. 
>> I've tried following Vanilla kernel builds from linux git tree: 2.6.20, 2.6.22,
>> 2.6.24, 2.6.26, 2.6.27-rc6 and it's worked only with 2.6.20. So, I tried to
>> bisect buggy commit between 2.6.20 and 2.6.22 versions.
>> Here is bad commit: df9e062ad994c4db683377b108c0dbed4690e4b0 
>>
>> Steps to reproduce: 
>> - detach disk with:
>> # echo "scsi remove-single-device x y z k" > /proc/scsi/scsi
>> - physically remove it and insert another one;
>> - try to attach disk with:
>> # echo "scsi add-single-device x y z k" > /proc/scsi/scsi
>> or with
>> echo "- - -" > /sys/class/scsi_host/hostN/scan
>>
>>
> 
> Eric, df9e062ad994c4db683377b108c0dbed4690e4b0 was your
> 
> commit df9e062ad994c4db683377b108c0dbed4690e4b0
> Author: Eric Moore <eric.moore@lsi.com>
> Date:   Mon Jan 29 09:46:21 2007 -0700
> 
>     [SCSI] fusion - serialize target resets in mptsas.c
> 



-- 
Vlad Seliverstov
+7 (495) 739-7000 ext. 7132
www.yandex.ru
