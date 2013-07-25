From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Date: Thu, 25 Jul 2013 16:33:47 -0400
Message-ID: <51F18BAB.8060600@interlog.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org> <51F144F4.4090509@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38946 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3GYUeR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 16:34:17 -0400
In-Reply-To: <51F144F4.4090509@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 13-07-25 11:32 AM, vaughan wrote:
> On 07/23/2013 01:03 AM, J=C3=B6rn Engel wrote:
>> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>> There is a race when open sg with O_EXCL flag. Also a race may happ=
en between
>>> sg_open and sg_remove.
>>>
>>> Changes from v4:
>>>   * [3/4] use ERR_PTR series instead of adding another parameter in=
 sg_add_sfp
>>>   * [4/4] fix conflict for cherry-pick from v3.
>>>
>>> Changes from v3:
>>>   * release o_sem in sg_release(), not in sg_remove_sfp().
>>>   * not set exclude with sfd_lock held.
>>>
>>> Vaughan Cao (4):
>>>    [SCSI] sg: use rwsem to solve race during exclusive open
>>>    [SCSI] sg: no need sg_open_exclusive_lock
>>>    [SCSI] sg: checking sdp->detached isn't protected when open
>>>    [SCSI] sg: push file descriptor list locking down to per-device
>>>      locking
>>>
>>>   drivers/scsi/sg.c | 178 +++++++++++++++++++++++++----------------=
-------------
>>>   1 file changed, 83 insertions(+), 95 deletions(-)
>> Patchset looks good to me, although I didn't test it on hardware yet=
=2E
>> Signed-off-by: Joern Engel <joern@logfs.org>
>>
>> James, care to pick this up?
>>
>> J=C3=B6rn
> Hi James,
>
> sg driver has two races happen in
>   a) exclusive open and non-exclusive open
>   b) sg removal and sg open
> I explained the scenario detail in the separate patches. I did test
> those patches and
> J=C3=B6rn has reviewed them.  I got no response from Doug Gilbert for=
 a long
> time.
> Would you care to pick these up?

Hi,
Your patches applied with a little noise to lk 3.10.2 and
gave this warning from the build.

   CC [M]  drivers/scsi/sg.o
drivers/scsi/sg.c: In function =E2=80=98sg_open=E2=80=99:
drivers/scsi/sg.c:242:6: warning: unused variable =E2=80=98res=E2=80=99=
 [-Wunused-variable]

I'll keep testing ...

Doug Gilbert


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
