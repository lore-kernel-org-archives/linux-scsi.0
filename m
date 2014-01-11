From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Sat, 11 Jan 2014 09:22:46 +0800
Message-ID: <52D09CE6.80200@oracle.com>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu> <52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21730 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaAKBYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 20:24:30 -0500
In-Reply-To: <52D056E9.8080008@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi <open-iscsi@googlegroups.com>, SCSI development list <linux-scsi@vger.kernel.org>


On 2014=E5=B9=B401=E6=9C=8811=E6=97=A5 04:24, Mike Christie wrote:
> On 01/10/2014 02:09 AM, vaughan wrote:
>> On 01/10/2014 03:41 PM, Mike Christie wrote:
>>> On 1/10/14 12:11 AM, vaughan wrote:
>>>> I haven't figure out why it's rejected with "bookmark invalid"(9)
>>>> reason, rather than "command not supported". IMO "bookmark invalid=
" is
>>>> used when minor protocol conflict such as final flag not set with
>>>> non-write command. However, I haven't find error of this kind in
>>>> report_opcode, so I guess it's not supported on the target.
>>>>
>>> Is it possible to get a wireshark/tcpdump trace? It does not have t=
o
>>> be during boot. We just need to see what commands are sent and the
>>> response the target is returning.
>>>
>>> I forgot we know some microsoft iscsi target people. We can just em=
ail
>>> them with the trace to confirm what is going on with the target. Th=
e
>>> trace seems to be easier for them than them interpreting linux kern=
el
>>> logs.
>> I enabled debug_iscsi_tcp, here is a more detailed log in normal con=
nection.
>> Does "conn error (1020)" mean it's target peer who disconnect the
>> connection at the same time of reject report_opcode?
> Yes.
>
>> If it is, I think iSCSI boot failure can't be avoided without disabl=
e
>> write_same check on OEL.
> Yes, you are right. Due to how more distros do boot, iscsid will not =
be
> up and you will hang. If are talking about disablement though I think=
 it
> should not be done at the iscsi layer. It should be some sort of
> white/black list at the scsi device layer or something like that.
>
> However, I will ping Microsoft and cc you and we can see what is up f=
or
> sure. Maybe we will get lucky and they will have a release with a fix=
 on
> their side.

Target:
   Windows Server 2008 R2 DataCenter
   Microsoft iSCSI Software Target: 3.3.16563.
Initiator:
   kernel with write_same check in sd, such as Kernel 3.11.10-200.fc19.=
x86_64

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
