From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: Re: PR registration on LIO iscsi returns sense key not ready
Date: Thu, 02 Oct 2014 16:31:15 +0200
Message-ID: <542D61B3.6030500@gmail.com>
References: <542D2D2D.2030100@gmail.com> <20141002161149.383599e3@grp-cvubrugier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59062 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBObP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 10:31:15 -0400
In-Reply-To: <20141002161149.383599e3@grp-cvubrugier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe Vu-Brugier <cvubrugier@fastmail.fm>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


On 10/02/2014 04:11 PM, Christophe Vu-Brugier wrote:
> Dear Luigi,
>
> On Thu, 02 Oct 2014 12:47:09 +0200, Luigi Tarenga wrote :
>> I have a little problem with LIO iscsi target and SPC-3 persistent
>> reservation.
>> The summary of my setup is:
>> host:
>>     centos 6.5 x86_64 with custom kernel 3.16.3 + scst patches
>>     targetcli (-fb) 2.1.fb37
>>     this host is configured to export a lun0 to the guest via iscsi
>>
>> guest:
>>     centos 7 x64_64 with stock kernel 3.10.0-123.6.3.el7.x86_64
>>     iscsi-initiator-utils-6.2.0.873-21.el7.x86_64
>>     sg3_utils-1.37-5.el7.x86_64
>>
>> [snip]
>>
>> the guest virtualization is done with qemu-2.0.0+kvm, NIC is virt-io and
>> the guest
>> connect to the host via a tap device.
>>
>> The guest can connect to the iSCSI target and i see the device as /dev/sda.
>> I partitioned, formatted and mounted it successfully.
>>
>> My problem that every PR Out command return a sense key not ready
>> even if the command run successfully, see this sequence:
> I think I already experienced these errors. Could you check the
> output of `dmesg` and look for errors like:
>
>    filp_open(/var/target/pr/aptpl_1a4f52f5-1036-498a-a14f-8818d28de1bb) for APTPL metadata failed
>    SPC-3 PR REGISTER: Received res_key: 0x0000000000000000 does not match existing SA REGISTER res_key: 0x000000002e5f2049
>    filp_open(/var/target/pr/aptpl_1a4f52f5-1036-498a-a14f-8818d28de1bb) for APTPL metadata failed
>
> You can fix this issue by creating the /var/target/pr directory.
> You should also create the /var/target/alua directory whih is
> expected by LIO too.
>
> Best regards,
>
Oh yeah! that was the problem! my bad I didn't checked dmesg on host :(
I didn't thought about aptpl because I ask for reservation without aptpl 
bit on
(-Z flag in sg_persist).

I created the 2 directories and now PR works like a charm :)

thank you very much!
Luigi

