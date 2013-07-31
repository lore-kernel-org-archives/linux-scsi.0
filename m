From: vaughan <vaughan.cao@oracle.com>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Date: Wed, 31 Jul 2013 12:40:16 +0800
Message-ID: <51F89530.8050908@oracle.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org> <51F144F4.4090509@oracle.com> <51F18BAB.8060600@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F18BAB.8060600@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: JBottomley@parallels.com, =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/26/2013 04:33 AM, Douglas Gilbert wrote:
> On 13-07-25 11:32 AM, vaughan wrote:
>> On 07/23/2013 01:03 AM, J=C3=B6rn Engel wrote:
>>> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>>> There is a race when open sg with O_EXCL flag. Also a race may
>>>> happen between
>>>> sg_open and sg_remove.
>>>>
>>>> Changes from v4:
>>>>   * [3/4] use ERR_PTR series instead of adding another parameter i=
n
>>>> sg_add_sfp
>>>>   * [4/4] fix conflict for cherry-pick from v3.
>>>>
>>>> Changes from v3:
>>>>   * release o_sem in sg_release(), not in sg_remove_sfp().
>>>>   * not set exclude with sfd_lock held.
>>>>
>>>> Vaughan Cao (4):
>>>>    [SCSI] sg: use rwsem to solve race during exclusive open
>>>>    [SCSI] sg: no need sg_open_exclusive_lock
>>>>    [SCSI] sg: checking sdp->detached isn't protected when open
>>>>    [SCSI] sg: push file descriptor list locking down to per-device
>>>>      locking
>>>>
>>>>   drivers/scsi/sg.c | 178
>>>> +++++++++++++++++++++++++-----------------------------
>>>>   1 file changed, 83 insertions(+), 95 deletions(-)
>>> Patchset looks good to me, although I didn't test it on hardware ye=
t.
>>> Signed-off-by: Joern Engel <joern@logfs.org>
>>>
>>> James, care to pick this up?
>>>
>>> J=C3=B6rn
>> Hi James,
>>
>> sg driver has two races happen in
>>   a) exclusive open and non-exclusive open
>>   b) sg removal and sg open
>> I explained the scenario detail in the separate patches. I did test
>> those patches and
>> J=C3=B6rn has reviewed them.  I got no response from Doug Gilbert fo=
r a long
>> time.
>> Would you care to pick these up?
>
> Hi,
> Your patches applied with a little noise to lk 3.10.2 and
> gave this warning from the build.
>
>   CC [M]  drivers/scsi/sg.o
> drivers/scsi/sg.c: In function =E2=80=98sg_open=E2=80=99:
> drivers/scsi/sg.c:242:6: warning: unused variable =E2=80=98res=E2=80=99
> [-Wunused-variable]
>
> I'll keep testing ...
Hi Doug,

Can I ask how about the test result?

Thanks,
Vaughan
>
> Doug Gilbert
>
