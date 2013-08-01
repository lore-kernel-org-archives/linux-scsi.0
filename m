From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Date: Thu, 01 Aug 2013 01:01:11 -0400
Message-ID: <51F9EB97.7070305@interlog.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130722170338.GA15824@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-07-22 01:03 PM, J=C3=B6rn Engel wrote:
> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>
>> There is a race when open sg with O_EXCL flag. Also a race may happe=
n between
>> sg_open and sg_remove.
>>
>> Changes from v4:
>>   * [3/4] use ERR_PTR series instead of adding another parameter in =
sg_add_sfp
>>   * [4/4] fix conflict for cherry-pick from v3.
>>
>> Changes from v3:
>>   * release o_sem in sg_release(), not in sg_remove_sfp().
>>   * not set exclude with sfd_lock held.
>>
>> Vaughan Cao (4):
>>    [SCSI] sg: use rwsem to solve race during exclusive open
>>    [SCSI] sg: no need sg_open_exclusive_lock
>>    [SCSI] sg: checking sdp->detached isn't protected when open
>>    [SCSI] sg: push file descriptor list locking down to per-device
>>      locking
>>
>>   drivers/scsi/sg.c | 178 +++++++++++++++++++++++++-----------------=
------------
>>   1 file changed, 83 insertions(+), 95 deletions(-)
>
> Patchset looks good to me, although I didn't test it on hardware yet.
> Signed-off-by: Joern Engel <joern@logfs.org>
>
> James, care to pick this up?

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Tested O_EXCL with multiple processes and threads; passed.
sg driver prior to this patch had "leaky" O_EXCL logic
according to the same test. Block device passed.

James, could you clean this up:
   drivers/scsi/sg.c:242:6: warning: unused variable =E2=80=98res=E2=80=
=99 [-Wunused-variable]

Doug Gilbert
