From: vaughan <vaughan.cao@oracle.com>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Fri, 10 Jan 2014 14:11:24 +0800
Message-ID: <52CF8F0C.3040304@oracle.com>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJGMA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 01:12:00 -0500
In-Reply-To: <52CEEC97.8050108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi <open-iscsi@googlegroups.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 01/10/2014 02:38 AM, Mike Christie wrote:
> On 01/09/2014 04:20 AM, vaughan wrote:
>> We are testing linux iscsi boot under UEFI mode with Microsoft iSCSI
>> Software Target. But failed for rejected by target.
>> When do a normal iscsi connection, iscsi connection is keeping rejected
>> and recover. See below:
>>
>> Dec 15 20:09:07 ol6u4gx64 kernel: scsi11 : iSCSI Initiator over TCP/IP
>> Dec 15 20:09:08 ol6u4gx64 kernel: scsi 11:0:0:0: Direct-Access    
>> MSFT     Virtual HD       3.3  PQ: 0 ANSI: 5
>> Dec 15 20:09:08 ol6u4gx64 kernel: sd 11:0:0:0: Attached scsi generic sg3
>> type 0
>> Dec 15 20:09:08 ol6u4gx64 kernel: sd 11:0:0:0: [sdc] 307200 512-byte
>> logical blocks: (157 MB/150 MiB)
>> Dec 15 20:09:08 ol6u4gx64 kernel: sd 11:0:0:0: [sdc] Write Protect is off
>> Dec 15 20:09:08 ol6u4gx64 kernel: sd 11:0:0:0: [sdc] Got wrong page
>> Dec 15 20:09:08 ol6u4gx64 kernel: sd 11:0:0:0: [sdc] Assuming drive
>> cache: write through
>> Dec 15 20:09:08 ol6u4gx64 kernel: connection1:0: pdu (op 0x1 itt 0xa)
>> rejected. Reason code 0x9
>> Dec 15 20:09:08 ol6u4gx64 iscsid: Connection1:0 to [target:
>> iqn.1991-05.com.microsoft:test1, portal: 10.182.92.118,3260] through
>> [iface: default] is operational now
>> Dec 15 20:09:08 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
>> 0xc1, itt 0xa, data_length 512CDB: a3 c 1 12 0 0 0 0 2 0 0 0 0 0 0 0
>> connection1:0: detected conn error (1020)
>> Dec 15 20:09:09 ol6u4gx64 iscsid: Kernel reported iSCSI connection 1:0
>> error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>> Dec 15 20:09:11 ol6u4gx64 kernel: connection1:0: pdu (op 0x1 itt
>> 0x1000000b) rejected. Reason code 0x9
>> Dec 15 20:09:11 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
>> 0xc1, itt 0x1000000b, data_length 512CDB: a3 c 1 12 0 0 0 0 2 0 0 0 0 0
>> 0 0 connection1:0: detected conn error (1020)
>> Dec 15 20:09:11 ol6u4gx64 iscsid: connection1:0 is operational after
>> recovery (1 attempts)
>> Dec 15 20:09:12 ol6u4gx64 iscsid: Kernel reported iSCSI connection 1:0
>> error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>> Dec 15 20:09:14 ol6u4gx64 kernel: connection1:0: pdu (op 0x1 itt
>> 0x2000000c) rejected. Reason code 0x9
>> Dec 15 20:09:14 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
>> 0xc1, itt 0x2000000c, data_length 512CDB: a3 c 1 12 0 0 0 0 2 0 0 0 0 0
>> 0 0 connection1:0: detected conn error (1020)
>> ...
>> Dec 15 20:09:30 ol6u4gx64 kernel: connection1:0: pdu (op 0x1 itt
>> 0x70000011) rejected. Reason code 0x9
>> Dec 15 20:09:30 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
>> 0xc1, itt 0x70000011, data_length 512CDB: a3 c 1 93 0 0 0 0 2 0 0 0 0 0
>> 0 0 connection1:0: detected conn error (1020)
>> Dec 15 20:09:31 ol6u4gx64 iscsid: connection1:0 is operational after
>> recovery (1 attempts)
>> Dec 15 20:09:31 ol6u4gx64 iscsid: Kernel reported iSCSI connection 1:0
>> error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>> Dec 15 20:09:33 ol6u4gx64 kernel: connection1:0: pdu (op 0x1 itt
>> 0x80000012) rejected. Reason code 0x9
>> Dec 15 20:09:34 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
>> 0xc1, itt 0x80000012, data_length 512CDB: a3 c 1 41 0 0 0 0 2 0 0 0 0 0
>> 0 0 connection1:0: detected conn error (1020)
>> Dec 15 20:09:34 ol6u4gx64 iscsid: connection1:0 is operational after
>> recovery (1 attempts)
>> Dec 15 20:09:34 ol6u4gx64 iscsid: Kernel reported iSCSI connection 1:0
>> error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
>>
>> Digging the code, I found it's because sd_read_write_same() use
>> scsi_report_opcode() to check if write_same is supported, but rejected
>> by target.
>> dd to the iSCSI disk is ok.  This issue doesn't occur with Linux stgt
>> target.
>>
> 
> Was the log above taken with your iscsi logging fixing patch applied?

Yes, it is. And "rejected iscsi cmd hdr" line is for debug.

> 
>> There are some questions:
>> 1. Why stgt target don't has this issue? Does it support report_opcode
>> because it has a embeded controller lun0? Or it just returns INVALID in
>> response?
> 
> Don't know. Will let someone else that works on stgt respond.
> 
>> 2. report_opcode is optional in SPC-3, so it's possible that not all
>> iscsi target support it. But is it correct for microsoft iSCSI target to
>> reject the command rather than return it with normal SCSI response?
> 
> The iscsi spec has the reason code "command not supported" so I guess it
> is ok for the target to do this. I do not think I have ever seen that
> reason code used in production level targets, so it is probably not
> common. I think I have normally seen it for when a iscsi command, like
> nop, is not supported in targets being developed.
> 
> I think we should implement handling in the iscsi layer for it. I can
> make a patch if you have not already.

I haven't made a patch yet.
I haven't figure out why it's rejected with "bookmark invalid"(9)
reason, rather than "command not supported". IMO "bookmark invalid" is
used when minor protocol conflict such as final flag not set with
non-write command. However, I haven't find error of this kind in
report_opcode, so I guess it's not supported on the target.


> 
> 
>> 3. Why it didn't do the same recovery in iSCSI boot case as did in
>> normal connection?
> 
> What distro are you using? For RHEL and OEL and maybe others, during
> boot (boot means here time before iscsid is started by the init scripts
> on the real root device) if the connection drops like it did above, then
> iscsid is not running so the kernel cannot recover. For sles, I think
> iscsid runs so it would be ok the entire time.

I'm using OEL.

> 
> 
> 
>> 4. if report_opcode is not supported, shall write_same be disabled for
>> iSCSI?
> 
> No.
> 
>> 5. Shall write_same be disabled for iSCSI by default?
>>
> 
> No.
> 
> If you wanted to disable commands you would want to do it per device or
> target at the scsi layer, because there are or will be iscsi targets
> that support it.
> 
