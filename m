From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: TCM and the SCSI-MIB
Date: Sat, 29 Jan 2011 16:39:46 +0100
Message-ID: <AANLkTi=PxwKZBoQM8xbc+T1kMBJ2DVK562ri2GCRSgCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57088 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1A2PkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jan 2011 10:40:07 -0500
Received: by iwn9 with SMTP id 9so4038861iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2011 07:40:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Jan 15, 2011 at 10:05 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 01/15/2011 01:25 PM, Bart Van Assche wrote:
>> On Fri, Jan 14, 2011 at 7:40 PM, James Bottomley
>> <James.Bottomley@suse.de> =A0wrote:
>>>
>>> [ ... ]
>>> Nicholas Bellinger (1):
>>> =A0 =A0 =A0target: Add LIO target core v4.0.0-rc6
>>> [ ... ]
>>
>> As anyone can see in the source file drivers/target/target_core_mib.=
c
>> this patch adds a significant number of new files to procfs. I thoug=
ht
>> that this was considered unacceptable since a long time ? Has anythi=
ng
>> changed ?
>>
>> See also http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-=
2.6.git;a=3Dblob;f=3Ddrivers/target/target_core_mib.c.
>
> Nothing has changed WRT procfs, and you are correct.
>
> But it's in now. =A0Submit a patch to fix this particular crapola! =A0=
:)

(trimmed CC-list and changed subject)

Hello Jeff,

As far as I can see the code in target_core_mib.c makes those counters
available to user space necessary for implementing the so-called
SCSI-MIB (RFC 4455). But that MIB does not only allow to monitor
target devices - it also allows to monitor initiator devices. A
question that not yet has been answered on this list is whether the
Linux kernel should make it possible to implement the SCSI-MIB on
Linux, and if so, for which types of devices - initiator devices only,
target devices only, or both.

=46urthermore, since the code in target_core_mib.c exports all
information read-only, that implementation does not allow to implement
the read-write attributes defined in the SCSI-MIB nor to create new
rows in tables via SNMP (several MIB objects in the SCSI-MIB have
read-create access). That is a severe limitation and I'm not sure
anyone who would like to use the SCSI-MIB will be able to live with
that.

=46or more information, see also http://www.ietf.org/rfc/rfc4455.txt.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
