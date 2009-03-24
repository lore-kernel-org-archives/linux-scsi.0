From: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: Re: [PATCH 06/13] [scsi] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:28:57 -0500
Message-ID: <6d291e080903241428n325d7805v6a61653d8d6516ba@mail.gmail.com>
References: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
	 <1237929888.3308.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:16059 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZCXV27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 17:28:59 -0400
In-Reply-To: <1237929888.3308.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Tue, Mar 24, 2009 at 4:24 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2009-03-24 at 16:12 -0500, stoyboyker@gmail.com wrote:
>> From: Stoyan Gaydarov <stoyboyker@gmail.com>
>>
>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>> ---
>> =C2=A0drivers/scsi/osst.c | =C2=A0 12 ++++++++----
>> =C2=A01 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
>> index 0ea78d9..80e7e98 100644
>> --- a/drivers/scsi/osst.c
>> +++ b/drivers/scsi/osst.c
>> @@ -4856,9 +4856,10 @@ static int os_scsi_tape_close(struct inode * =
inode, struct file * filp)
>>
>>
>> =C2=A0/* The ioctl command */
>> -static int osst_ioctl(struct inode * inode,struct file * file,
>> - =C2=A0 =C2=A0 =C2=A0unsigned int cmd_in, unsigned long arg)
>> +static long osst_ioctl(struct file * file, unsigned int cmd_in,
>> + =C2=A0 =C2=A0 unsigned long arg)
>> =C2=A0{
>> + =C2=A0 =C2=A0 lock_kernel();
>
> What necessitates the kernel locking? =C2=A0When st was audited, it d=
idn't
> need it; since osst is in many ways a copy of st, I'm surprised it do=
es.
>
> James

The lock was there before, because it is used before calling
osst_ioctl, my patches don't change any functionality. It is meant to
show the maintainers of the code that the lock is there and to allow
them make a decision as to how best to handle the code without the
kernel locking. If it is not needed then the locks can be removed and
the function call can remain under the unlocked_ioctl.

-Stoyan

>
>
>



--=20

-Stoyan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
