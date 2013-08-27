From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Date: Tue, 27 Aug 2013 15:13:50 +0200
Message-ID: <521CA60E.2040802@interlog.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org> <51F9EB97.7070305@interlog.com> <51FC9449.4060906@interlog.com> <51FF0BC0.5020702@oracle.com> <5200108A.9020008@interlog.com> <52099E1B.5000203@oracle.com> <5209A50E.8090300@interlog.com> <521C606C.3000109@oracle.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <521C606C.3000109@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-08-27 10:16 AM, vaughan wrote:
> On 08/13/2013 11:16 AM, Douglas Gilbert wrote:
>> On 13-08-12 10:46 PM, vaughan wrote:
>>> On 08/06/2013 04:52 AM, Douglas Gilbert wrote:
>>>> On 13-08-04 10:19 PM, vaughan wrote:
>>>>> On 08/03/2013 01:25 PM, Douglas Gilbert wrote:
>>>>>> On 13-08-01 01:01 AM, Douglas Gilbert wrote:
>>>>>>> On 13-07-22 01:03 PM, J=C3=B6rn Engel wrote:
>>>>>>>> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>>>>>>>>
>>>>>>>>> There is a race when open sg with O_EXCL flag. Also a race ma=
y
>>>>>>>>> happen between
>>>>>>>>> sg_open and sg_remove.
>>>>>>>>>
>>>>>>>>> Changes from v4:
>>>>>>>>>      * [3/4] use ERR_PTR series instead of adding another
>>>>>>>>> parameter in
>>>>>>>>> sg_add_sfp
>>>>>>>>>      * [4/4] fix conflict for cherry-pick from v3.
>>>>>>>>>
>>>>>>>>> Changes from v3:
>>>>>>>>>      * release o_sem in sg_release(), not in sg_remove_sfp().
>>>>>>>>>      * not set exclude with sfd_lock held.
>>>>>>>>>
>>>>>>>>> Vaughan Cao (4):
>>>>>>>>>       [SCSI] sg: use rwsem to solve race during exclusive ope=
n
>>>>>>>>>       [SCSI] sg: no need sg_open_exclusive_lock
>>>>>>>>>       [SCSI] sg: checking sdp->detached isn't protected when =
open
>>>>>>>>>       [SCSI] sg: push file descriptor list locking down to
>>>>>>>>> per-device
>>>>>>>>>         locking
>>>>>>>>>
>>>>>>>>>      drivers/scsi/sg.c | 178
>>>>>>>>> +++++++++++++++++++++++++-----------------------------
>>>>>>>>>      1 file changed, 83 insertions(+), 95 deletions(-)
>>>>>>>>
>>>>>>>> Patchset looks good to me, although I didn't test it on hardwa=
re
>>>>>>>> yet.
>>>>>>>> Signed-off-by: Joern Engel <joern@logfs.org>
>>>>>>>>
>>>>>>>> James, care to pick this up?
>>>>>>>
>>>>>>> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
>>>>>>>
>>>>>>> Tested O_EXCL with multiple processes and threads; passed.
>>>>>>> sg driver prior to this patch had "leaky" O_EXCL logic
>>>>>>> according to the same test. Block device passed.
>>>>>>>
>>>>>>> James, could you clean this up:
>>>>>>>       drivers/scsi/sg.c:242:6: warning: unused variable =E2=80=98=
res=E2=80=99
>>>>>>> [-Wunused-variable]
>>>>>>
>>>>>> Further testing suggests this patch on the sg driver is
>>>>>> broken, so I'll rescind my ack.
>>>>>>
>>>>>> The case it is broken for is when a device is opened
>>>>>> without O_EXCL. Now if, while it is open, a second
>>>>>> thread/process tries to open the same device O_EXCL
>>>>>> then IMO the second open should fail with EBUSY.
>>>>>>
>>>>>> My testing shows that O_EXCL opens properly deflect
>>>>>> other O_EXCL opens.
>>>>> Hi  Doug,
>>>>>
>>>>> My test don't have this issue. The routine is something as below:
>>>>>
>>>>> I start three opens without O_EXCL, wait 30s each, and open with
>>>>> O_EXCL|O_NONBLOCK, it failed with EBUSY.
>>>>> And I also call myopen with/without O_EXCL many times in backgrou=
nd at
>>>>> the same time, and the test is passed. I don't know why it failed=
 in
>>>>> your test.
>>>>>
>>>>> Usage: myopen [-e][-n][-d delay] -f file
>>>>>          -e: exclude
>>>>>          -n: nonblock
>>>>>          -d: delay N seconds and then close.
>>>>>
>>>>> [root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
>>>>> [1] 3417
>>>>> [root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
>>>>> [2] 3418
>>>>> [root@vacaowol5 16835013]# ./myopen  -f /dev/sg5 -d 30 &
>>>>> [3] 3419
>>>>> [root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
>>>>> max_active_device=3D6(origin 1)
>>>>>     def_reserved_size=3D32768
>>>>>     >>> device=3Dsg5 scsi5 chan=3D0 id=3D1 lun=3D0   em=3D0 sg_ta=
blesize=3D55
>>>>> excl=3D0
>>>>>       FD(1): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>>       FD(2): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>>       FD(3): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>>
>>>>> [root@vacaowol5 16835013]# ./myopen -e -n  -f /dev/sg5 -d 30 &
>>>>> [4] 3422
>>>>> [3422:3351] /dev/sg5:exclude: Device or resource busy
>>>>>
>>>>> [4]+  Exit 1                  ./myopen -e -n -f /dev/sg5 -d 30
>>>>>
>>>>> [root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
>>>>> max_active_device=3D6(origin 1)
>>>>>     def_reserved_size=3D32768
>>>>>     >>> device=3Dsg5 scsi5 chan=3D0 id=3D1 lun=3D0   em=3D0 sg_ta=
blesize=3D55
>>>>> excl=3D0
>>>>>       FD(1): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>>       FD(2): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>>       FD(3): timeout=3D60000ms bufflen=3D32768 (res)sgat=3D1 low_=
dma=3D0
>>>>>       cmd_q=3D0 f_packid=3D0 k_orphan=3D0 closed=3D0
>>>>>         No requests active
>>>>> [root@vacaowol5 16835013]# cat /proc/scsi/sg/debug
>>>>> [1]   Done                    ./myopen -f /dev/sg5 -d 30
>>>>> [2]-  Done                    ./myopen -f /dev/sg5 -d 30
>>>>> [3]+  Done                    ./myopen -f /dev/sg5 -d 30
>>>>>
>>>>
>>>> Hi,
>>>> After the initial failures about 36 hours ago, retesting
>>>> yesterday and today has not produced any unexpected
>>>> failures. And I have been trying hard on lk 3.10.4 and
>>>> lk 3.10.5 .
>>>>
>>>> My test program is a bit more intense than yours and can
>>>> be found in the sg3_utils beta in the News section of this
>>>> page:
>>>>     http://sg.danny.cz/sg/
>>>>
>>>> It is in the examples directory, two variants called
>>>> sg_tst_excl and sg_tst_excl2 . You will need a recent gcc
>>>> compiler, IOW something that can compile c++11 . gcc 4.7.3
>>>> in Ubuntu 13.04 only just manages, fedora 19 should do
>>>> better with gcc 4.8.1 . The threading is implemented using
>>>> pthreads so it should be reliable.
>>>>
>>>> Typically I run multiple instances (processes) and each has
>>>> multiple threads. One instance can run '-x' which will cause
>>>> its first thread not to use O_EXCL **. All my tests currently
>>>> use O_NONBLOCK and that leads to lots of EBUSYs (sometimes
>>>> in the billions).
>>>>
>>>> Doug Gilbert
>>>>
>>>>
>>>> ** Using '-x' on two instances will cause an expected failure
>>>>      so can be used as a control.
>>>>
>>> Hi Doug,
>>>
>>> Can I regard this as you ACK it again?
>>
>> Hi,
>> I'd like you to test your setup with sg_tst_excl or sg_tst_excl2 .
>> Since my last email, I have not seen any more failures with those
>> tests on the patched sg driver but I did see a couple on
>> /dev/sd* . With sg_tst_excl2, bsg devices can be used and since bsg
>> accepts and ignores O_EXCL, it fails reliably.
>>
>> BTW I use scsi_debug with 'delay=3D0' for a pseudo device.
>>
>> Doug Gilbert
> Hi Doug,
>
> I run test for sg and sd drivers with both sg_tst_excl and sg_tst_exc=
l2
> on kernel vanilla 3.10.9 with mypatches included on Fedora19 x86_64
> baremachine.
> * I've tried several times with different -w and -n setting, no failu=
re
> for sg driver found.
> * It's easy to find failure on both patched and non-patched kernel fo=
r
> sd driver with the following test command:
>      ./sg_tst_excl -w 3 -n 2000 -t 16 -x $1 &
>      ./sg_tst_excl -w 3 -n 2000 -t 16 $1 &
>      ./sg_tst_excl -w 0 -n 2000 -t 16 $1 &
>      ./sg_tst_excl -w -1 -n 2000 -t 16 $1 &
>      ./sg_tst_excl -w -2 -n 2000 -t 16 $1 &
> I think option '-w 0/-1/-2' is significant to trigger the failure, si=
nce
> when I only use '-w >0', test usually passed.

Hi,
Thanks for testing that. For others trying to follow this,
the usage message for that test utility is:

Usage: sg_tst_excl [-b] [-l <lba>] [-n <n_per_thr>] [-t <num_thrs>]
                    [-V] [-w <wait_ms>] [-x] <disk_device>
   where
     -b                block on open (def: O_NONBLOCK)
     -l <lba>          logical block to increment (def: 1000)
     -n <n_per_thr>    number of loops per thread (def: 200)
     -t <num_thrs>     number of threads (def: 4)
     -V                print version number then exit
     -w <wait_ms>      >0: sleep_for(<wait_ms>); =3D0: yield(); -1: no
                       wait; -2: sleep(0)  (def: 0)
     -x                don't use O_EXCL on first thread (def: use
                       O_EXCL on all threads)

Test O_EXCL open flag with sg driver. Each open/close cycle with the
O_EXCL flag does a double increment on lba (using its first 4 bytes).

----------------------

The test is using O_EXCL as a lock so that if a 4 byte integer in
a block starts out as even (and for a scsi_debug pseudo, blocks are
zero filled) then a open,double_increment,close sequence should
always see an even number after the open. Notice that it should be
safe for one process to run with '-x' so that its first thread
opens the device without the O_EXCL flag.


Acked-by: Douglas Gilbert <dgilbert@interlog.com>

And I let you run with the sd driver quirk :-)
